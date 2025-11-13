# OmbiBot

> A bot to ombi with

![](ombibot.gif)

## Prerequisites

1. Ruby >= 1.9.3
2. Bundler/RubyGems

## Installation

1. Install dependencies

```
$ bundle install
```

## Running

1. Replace environment variables

   1. create a file in the /config called `.env`
   1. copy from `.env.example` and replace with your values (leave slack one empty for now)

2. Start the server

```
$ bundle exec foreman start
```

3. Host it somewhere with an SSL cert (needed for interactions)

4. Set up Slack bot

   1. [Create a Slack app](https://api.slack.com/apps) and configure it in your workspace
   2. Add Bots, Interactive Components, and Permissions
   3. Configure `.env` with `Bot User OAuth Access Token` from `OAuth and Permissions` sidebar tab
   4. Configure the `Request URL` on `Interactive Components` to the URL from #3 above

5. ?

6. Profit!

## How to use:

```
plex search ricky bobby
```

will return Talladega Nights: The Ballad of Ricky Bobby

Command Structure:

```
[trigger] [command] [expression]
```

- `trigger` - one of "plex" or "ombibot" or "ombi"
- `command` - one of "download" or "find" or "search" or "get" or "request"
- `expression` - the movie you're searching for (TV support coming soon.)

You can also send DMs to the bot, for your more embarassing requests. The DMs don't require the trigger word.

## Docker Setup

### Quick Start with Docker

```bash
# Build the image
docker build -t ombibot:latest .

# Run the container (set environment variables)
docker run -d \
  --name ombibot \
  -e SLACK_API_TOKEN=xoxb-your-token \
  -e OMBI_URL=http://ombi:5000 \
  -e OMBI_API_KEY=your-api-key \
  -e PLEX_URL=http://plex:32400 \
  -e PLEX_TOKEN=your-plex-token \
  -p 3000:3000 \
  ombibot:latest
```

### Docker Hub

The image is available on Docker Hub:

```bash
docker pull marjoemitchell/ombibot:latest
docker run -d \
  --name ombibot \
  -e SLACK_API_TOKEN=xoxb-your-token \
  -e OMBI_URL=http://ombi:5000 \
  -e OMBI_API_KEY=your-api-key \
  -p 3000:3000 \
  marjoemitchell/ombibot:latest
```

### Unraid Installation

1. In Unraid, go to **Community Applications**
2. Search for **OmbiBot**
3. Click install and configure the environment variables
4. Click apply

**Required Settings:**
- `SLACK_API_TOKEN` - Your Slack bot OAuth token from https://api.slack.com/apps
- `OMBI_URL` - URL to your Ombi instance (e.g., `http://ombi:5000`)
- `OMBI_API_KEY` - Your Ombi API key from Ombi settings

**Optional Settings:**
- `PORT` - Port for the bot to listen on (default: 3000)
- `TZ` - Timezone (default: America/Chicago)
- `PLEX_URL` - URL to your Plex server (e.g., `http://plex:32400`)
- `PLEX_TOKEN` - Your Plex API token
- `OMBI_USER` - Ombi username (if needed)
- `RACK_ENV` - Environment (default: production)

**Configuration Methods:**

You can configure OmbiBot in two ways:

**Method 1: Environment Variables (Recommended)**
Set the environment variables directly in the Unraid container settings. This is the recommended approach.

**Method 2: .env File Mount (Optional)**
Alternatively, you can create a `.env` file on your Unraid server and mount it to the container:
1. Create `.env` file at `/mnt/user/appdata/ombibot/.env` (or your preferred location)
2. Copy values from the `.env.example` file in this repo
3. In the OmbiBot container settings, add a volume mount:
   - Host Path: `/mnt/user/appdata/ombibot/.env`
   - Container Path: `/app/.env`
   - Mode: Read-only

**⚠️ Security Note:** Never commit your `.env` file to version control. Keep your API tokens and secrets secure.

### Environment Variables

See `.env.example` for all configuration options:

```bash
cp .env.example .env
# Edit .env with your settings
```

## Built With:

- [Slack Ruby Bot](https://github.com/dblock/slack-ruby-bot)
- [Sinatra](https://sinatrarb.com/) - Web framework
- [HTTParty](https://github.com/jnunemaker/httparty) - HTTP client
- Ruby 3.2+
