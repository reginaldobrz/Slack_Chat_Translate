
# Slack Chat Translator (Ruby + Sinatra)

This project is a simple web application built in Ruby (without Rails) that enables real-time translation between Portuguese and English within a Slack channel, with a web interface and integration with an LLM (like LibreTranslate or OpenAI).

---

## ✨ Features

- Chat-style interface (static, no React)
- Automatic translation between 🇧🇷 Portuguese ⇄ 🇺🇸 English
- Slack integration (send and receive messages)
- Web view updated via polling every 3 seconds
- Translation confirmation before sending
- Public access via Cloudflare Tunnel

---

## 📦 Prerequisites

- Ruby `>= 3.0` (tested on 3.4.2)
- Bundler (`gem install bundler`)
- A [Slack API](https://api.slack.com/) account
- Translation API key:
  - [LibreTranslate](https://libretranslate.com/) (free)
  - or [OpenAI API](https://platform.openai.com/) (paid)

---

## 🚀 Installation

```bash
# Clone the repository
git clone https://github.com/your-username/slack-chat-translator.git
cd slack-chat-translator

# Install dependencies
bundle install

# Create the .env file with your keys
cp .env.example .env
```

---

## 🐳 Running LibreTranslate locally (Docker)

You can run your own translation server locally using LibreTranslate with Docker:

### 1. Start the container:

```bash
docker run -d -p 5000:5000 libretranslate/libretranslate
```

Set the URL in your .env file:

```bash
LIBRETRANSLATE_URL=http://localhost:5000/translate
```

Verify it's working by visiting in your browser:

```bash
http://localhost:5000
```

You should see the LibreTranslate REST API interface.

---

## ▶️ Running the application

```bash
ruby app.rb
```

Access the app at: http://localhost:4567

---

## 🌐 [Option 1] Make it public with Cloudflare Tunnel

```bash
cloudflared tunnel --url http://localhost:4567
```

Your terminal will display a public link like:

```bash
https://random-example.trycloudflare.com
```

Use this link to configure the Slack Events URL:

```bash
https://your-tunnel.trycloudflare.com/slack/events
```

---

## 🌐 [Option 2] Make it public with Ngrok Tunnel

With the ngrok agent installed, run the following command:

```bash
npx ngrok start --all --config ./ngrok.yml
```

Your terminal will show two public forwarding links:  
One for port `:5000` (LibreTranslate) and another for port `:4567` (Sinatra app):

- Add the URL provided for port `:5000` to your `.env` file under the key `LIBRETRANSLATE_URL`

- The URL for port `:4567` will be used to configure your Slack app. Go to:

```bash
https://api.slack.com/apps
```

Create a new app to act as your chat bot. In the settings, go to the "Event Subscriptions" tab, enable the feature, and in the "Request URL" field, paste the ngrok URL for port `:4567` followed by `/slack/events`. Save it.

```bash
https://YOUR-NGROK-URL/slack/events
```
OBS: Remember to add yout ngrok authtoken on ngrok.yml

That’s it — your chat bot is now ready to listen to events from your application.

---

## 🛠️ Development Notes

- Messages are stored in `messages.json`

- The UI is built using plain HTML + ERB + CSS

- New messages are fetched every 3 seconds via polling

- The "Send" button shows a translation before submission

- A toast notification appears if a new message arrives and the user isn’t at the bottom of the chat

---

## 🧪 Testing

- Send a message from the web interface

- Check if it was sent to Slack (translated)

- Reply in Slack (in English) and watch it appear in the interface (translated into Portuguese)

---

## 📂 Project Structure

```bash
app/
  controllers/
  services/
  views/
  public/
app.rb
messages.json
.env
Gemfile
```
