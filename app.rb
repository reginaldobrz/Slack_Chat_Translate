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

post '/enviar' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  MessagesController.send_message(data["texto"])
end

get '/mensagens_json' do
  content_type :json
  MessagesController.all_messages.to_json
end

post "/slack/events" do
  request_data = JSON.parse(request.body.read)

  if request_data["type"] == "url_verification"
    return request_data["challenge"]
  end

  event = request_data["event"]
  return status 200 unless event

  if event["subtype"] == "bot_message"
    puts "[IGNORADO] Mensagem do próprio bot Slack"
    return status 200
  end

  return status 200 unless event["text"]

  user_text = event["text"]

  translated = TranslationService.translate_to_portuguese(user_text)

  MessageLogger.log(
    origem: "slack",
    original: user_text,
    translated: translated
  )

  status 200
  body "ok"
end

post '/enviar-preview' do
  request.body.rewind
  data = JSON.parse(request.body.read)
  texto = data["texto"]

  translated = TranslationService.translate_to_english(texto)

  { status: 'ok', translated: translated }.to_json
end

if defined?(Rack::Protection::HostAuthorization)
  use Rack::Protection::HostAuthorization, allow: ->(host) { true }
end