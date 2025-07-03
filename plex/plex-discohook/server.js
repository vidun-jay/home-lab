require('dotenv').config()
const express = require('express')
const fetch = require('node-fetch')
const path = require('path')
const cors = require('cors')

const app = express()
const port = process.env.PORT || 3000
const tmdbApiKey = process.env.TMDB_API_KEY
const discordWebhookUrl = process.env.DISCORD_WEBHOOK_URL

app.use(cors())
app.use(express.json())
app.use(express.static(path.join(__dirname, 'public')))

// search endpoint
app.post('/search', async (req, res) => {
  const { query } = req.body
  if (!query) return res.status(400).json({ error: 'Missing query' })

  try {
    const tmdbRes = await fetch(`https://api.themoviedb.org/3/search/multi?api_key=${tmdbApiKey}&query=${encodeURIComponent(query)}`)
    const tmdbData = await tmdbRes.json()
    const results = tmdbData.results
      .filter(i => i.media_type === 'movie' || i.media_type === 'tv')
      .map(i => ({
        id: i.id,
        title: i.title || i.name,
        description: i.overview,
        posterUrl: i.poster_path
          ? `https://image.tmdb.org/t/p/w300${i.poster_path}`
          : '',
        mediaType: i.media_type
      }))
    res.json({ results })
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'Search failed' })
  }
})

app.post('/add', async (req, res) => {
  const { id, title, description, posterUrl, mediaType } = req.body

  // map raw types to display names
  const libraryNames = { movie: 'Movies', tv: 'TV Shows' }
  const label        = libraryNames[mediaType] || mediaType

  // map to the TMDB detail URL
  const detailUrls = {
    movie: 'https://www.themoviedb.org/movie/',
    tv:    'https://www.themoviedb.org/tv/'
  }
  const link = detailUrls[mediaType] + id

  // build embed
  const embed = {
    embeds: [{
      title: `"${title}" - has been added to Plex`,
      url:   link,
      description: description || '',
      thumbnail:   { url: posterUrl || '' },
      fields: [
        { name: 'Library', value: label, inline: true }
      ],
      color: null
    }]
  }

  try {
    const discordRes = await fetch(discordWebhookUrl, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(embed)
    })
    if (!discordRes.ok) throw new Error(await discordRes.text())
    res.json({ success: true })
  } catch (err) {
    console.error('Discord error', err)
    res.status(500).json({ error: 'Failed to notify Discord' })
  }
})


app.listen(port, () => {
  console.log(`listening on http://localhost:${port}`)
})
