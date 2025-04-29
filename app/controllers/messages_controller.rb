require_relative '../services/slack_service'
require_relative '../services/translation_service_openai'
require_relative '../services/message_logger'
require 'erb'

class MessagesController
  def self.list_messages
    logger = MessageLogger.new
    @messages = logger.load_messages.reverse
    ERB.new(File.read('app/views/index.erb')).result(binding)
  end

  def self.send_message(text)
    translator = TranslationServiceOpenAi.new
    translated = translator.translate_to_english(text)
    
    sender = SlackService.new
    sender.send_message(translated)

    logger = MessageLogger.new
    logger.log({
      origem: 'user',
        original: text,
        translated: translated,
        timestamp: Time.now.to_s
    })

    { status: 'ok' }.to_json
  end

  def self.all_messages
    MessageLogger.new.load_messages
  end
end