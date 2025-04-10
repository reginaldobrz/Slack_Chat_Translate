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
        { role: "user", content: text }
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
