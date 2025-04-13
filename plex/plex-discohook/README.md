![Node.js Version](https://img.shields.io/badge/node-v21.7.1-brightgreen)
![Docker Version](https://img.shields.io/badge/docker-v20.10.15-blue)

## Overview
Plex Webhook Server is a Node.js application designed to interact with Plex media server URLs. It allows users to submit a URL from the Plex platform and specifies the media library category (e.g., Anime, Movies, TV Shows). The server processes these URLs using Puppeteer to scrape relevant media information, then sends a formatted message to a specified Discord webhook, notifying about media additions to Plex libraries.

## Installation
This project uses Docker to ensure it runs smoothly both in development and production environments. Follow these steps to set up and run the Plex Webhook Server using Docker.

### Step 1: Clone the Repository
First, clone the repository to your local machine using Git:
```
git clone https://github.com/vidun-jay/plex-discohook.git
cd plex-webhook-server
```

### Step 2: Set Up Environment Variables
Open the .env file in the root directory of the project and add your Discord webhook URL to it:
```
DISCORD_WEBHOOK_URL=https://discordapp.com/api/webhooks/.../...
```

### Step 3: Run Docker Compose
Build the docker image using `docker-compose`.
```
docker compose up
```
This command will:

- Build the Docker image from the Dockerfile if it's not already built.
- Start a container based on that image.
- Attach the container output to the terminal window.

### Step 4: Verify Installation
Once the Docker Compose process is running, open your web browser and navigate to [http://localhost:3000](http://localhost:3000). You should see the Plex Webhook Server interface, indicating that the server is running correctly.

### Step 5: Stopping the Server
To stop the server, use the following command in the terminal:
```
docker compose down
```

**⚠️ Note**: After it's been installed, you can run the server at any time again using:
```
docker run plex-webhook-server
```

### Prerequisites
**Docker**: Ensure that Docker is installed on your machine. If not, download and install Docker from [Docker's official website](https://www.docker.com/products/docker-desktop/).

## Creating a Discord Webhook
To use the Discord integration feature, you need to create a webhook in your Discord server. Here’s how to set it up:

1. Open Discord: Go to your server where you have the necessary permissions.
2. Server Settings: Click on the server name, then select Server Settings.
3. Integrations: Go to the Integrations tab and click on Webhooks.
4. New Webhook: Click on New Webhook. Name your webhook and choose the channel where messages will be posted.
5. Copy Webhook URL: After creating the webhook, click the Copy Webhook URL button to get the URL. This is the URL you will use in your project to send messages to Discord.

## How to Use
1. Start the Server: Run the server using Docker or directly with Node.js
2. Access the Web Interface: Open your web browser and navigate to http://localhost:3000. This will load the interactive interface.
3. Enter Plex URL: In the web interface, input a valid Plex URL into the URL field.
4. Select Library: Choose the appropriate library category for the media from the dropdown menu.
5. Submit: Click the submit button. If the URL is valid and the server is able to process it, the details of the media will be scraped and sent to the specified Discord channel.
6. Discord Notification: Check the configured Discord channel for the notification that includes the title, description, and other relevant details of the media added to Plex.

## Local Development
### Prerequisites
Node.js (v14 or above)
Docker (for containerization)
Access to a Discord server and permissions to manage webhooks

### Running Locally
To run the server locally without Docker, follow these steps:

Install dependencies: `npm install`
Start the server: `node server.js`
Visit http://localhost:3000 in your browser to use the application.
