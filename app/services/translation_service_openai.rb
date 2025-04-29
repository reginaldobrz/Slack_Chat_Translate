require 'net/http'
require 'json'

class TranslationServiceOpenAi
  def initialize(api_key = ENV['OPENAI_API_KEY'])
    raise ArgumentError, "API key is required" if api_key.nil? || api_key.strip.empty?

    @api_key = api_key
    @uri = URI("https://api.openai.com/v1/chat/completions")
  end

  def translate_to_english(text)
    translate(text, 'portuguese', 'english')
  end

  def translate_to_portuguese(text)
    translate(text, 'english', 'portuguese')
  end

  def translate(text, source_lang, target_lang)
    req = Net::HTTP::Post.new(@uri)
    req['Authorization'] = "Bearer #{@api_key}"
    req['Content-Type'] = 'application/json'
    req.body = {
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: "You are a helpful assistant that only translates #{source_lang} to #{target_lang}." },
        { role: "user", content: "You are an advanced specialized #{source_lang} to #{target_lang} translator who only interacts from inside a chatroom. Your speciality is to translate technical chatter about Ruby, Ruby on Rails, Postgres, AWS, Javascript, etc, conveying the exact meaning of the phrases without corrupting the technical aspects of the original message. You do not translate the names of the technologies, variables, functions, classes, modules, libraries. You do not translate jargon that is better understood in its original language (usually English). Apply this instructions to translate this following text: #{text}" }
      ],
      temperature: 0.2
    }.to_json

    res = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    parsed = JSON.parse(res.body)
    parsed.dig("choices", 0, "message", "content") || "[Translate Error]"
  rescue => e
    "[Translate Error: #{e.message}]"
  end
end
