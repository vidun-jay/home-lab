const express = require('express');
const puppeteer = require('puppeteer');
const path = require('path');
const cors = require('cors');

const app = express();
const port = 3000;
const discordWebhookUrl = process.env.DISCORD_WEBHOOK_URL;

app.use(cors()); // use cors middleware
app.use(express.json()); // parse json bodies

// serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// serve index.html file at the root route
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// api endpoint that handles url processing using puppeteer
app.post('/process-url', express.json(), async (req, res) => {
  const { url, library } = req.body;

  if (!url.startsWith('https://watch.plex.tv/')) {
    return res.status(400).json({ error: 'Invalid Plex URL.' });
  }

  try {
    const data = await extractData(url, library);
    await sendToDiscord(data, url); // send the extracted data to discord
    res.json({ message: 'Data sent to Discord successfully!' });
  } catch (error) {
    console.error('Error during data extraction or sending to Discord:', error);
    res.status(500).json({ error: 'Error extracting data or sending to Discord' });
  }
});

// function that launches puppeteer and scrapes the webpage
async function extractData(url, library) {
  const browser = await puppeteer.launch({
    executablePath: "/usr/bin/chromium",
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();
  await page.goto(url, { waitUntil: 'networkidle0' });

  // scrape the data from the page
  const data = await page.evaluate((lib) => {
    const titleSelector = 'h1';
    const descriptionSelector = '.ineka90.ineka9j.ineka9a.ineka9n._1v25wbq1g._1v25wbq1c._1v25wbqlk';
    const imageSelector = '._1h4p3k00._1v25wbq8._1v25wbq1w._1v25wbqk._1v25wbq1g._1v25wbq18._1v25wbq14._1v25wbq3g._1v25wbq28';

    let title = document.querySelector(titleSelector)?.textContent.trim() || 'No title found';
    let description = document.querySelector(descriptionSelector)?.textContent.trim() || 'No description found';
    let imageUrl = '';

    // find the img element with the specific class
    const imageElement = document.querySelector(`${imageSelector} img`);
    if (imageElement) {
      imageUrl = imageElement.src || '';
    }

    // return the data object
    return { title, description, imageUrl, library: lib };
  }, library);

  await browser.close();
  return data;
}


// function to send data to discord using webhook
async function sendToDiscord(data, url) {
  const discordEmbed = {
    embeds: [
      {
        title: `"${data.title}" - has been added to Plex!`,
        description: data.description,
        url: url,
        color: null,
        fields: [
          {
            name: "Library",
            value: data.library,
            inline: true
          }
        ],
        thumbnail: {
          url: data.imageUrl
        }
      }
    ]
  };

  // log the payload for debugging
  console.log('Payload being sent to Discord:', JSON.stringify(discordEmbed, null, 2));

  // Use fetch to post to the Discord webhook URL
  const response = await fetch(discordWebhookUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(discordEmbed)
  });

  if (!response.ok) {
    const errorBody = await response.text();
    throw new Error(`Discord webhook responded with status: ${response.status}, body: ${errorBody}`);
  }
}

// start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
