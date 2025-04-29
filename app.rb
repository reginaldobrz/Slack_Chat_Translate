require 'sinatra'
require 'json'
require_relative './app/controllers/messages_controller'
require 'dotenv/load'

configure do
  set :environment, :production
  disable :protection
  set :bind, '0.0.0.0'
  set :port, 4567
  set :public_folder, 'public'
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/' do
  MessagesController.list_messages
end

post '/send' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  MessagesController.send_message(data["text"])
end

get '/messages_json' do
  content_type :json
  MessagesController.all_messages.to_json
end

post "/slack/events" do
  request_data = JSON.parse(request.body.read)

  if request_data["type"] == "url_verification"
    return request_data["challenge"]
  end

  event = request_data["event"]

  if event["subtype"] == "bot_message"
    puts "[IGNORADO] Mensagem do próprio bot Slack"
    return status 200
  end

  return status 200 unless event["text"]

  if request_data["event"] && request_data["event"]["type"] == "message"
    user_id = event["user"]
    serviceSlack = SlackService.new
    user_name = serviceSlack.fetch_user_name(user_id)

    user_text = event["text"]
    translator = TranslationServiceOpenAi.new
    translated = translator.translate_to_portuguese(user_text)

    logger = MessageLogger.new

    logger.log(
      origem: "slack",
      original: user_text,
      translated: translated,
      user: user_name
    )
  end

  status 200
  body "ok"
end

post '/send-preview' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  text = data["text"]

  translator = TranslationServiceOpenAi.new
  translated = translator.translate_to_english(text)

  { status: 'ok', translated: translated }.to_json
end

if defined?(Rack::Protection::HostAuthorization)
  use Rack::Protection::HostAuthorization, allow: ->(host) { true }
end