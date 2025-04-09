require 'net/http'
require 'uri'
require 'json'

class TranslationService
  def initialize(base_url = ENV['LIBRETRANSLATE_URL'] || 'https://libretranslate.com')
    @base_url = base_url
  end

  def translate_to_english(text)
    translate(text, 'pt', 'en')
  end

  def translate_to_portuguese(text)
    translate(text, 'en', 'pt')
  end

  def translate(text, source_lang, target_lang)
    uri = URI("#{@base_url}/translate")
    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = 'application/json'
    req.body = {
      q: text,
      source: source_lang,
      target: target_lang,
      format: "text"
    }.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    parsed = JSON.parse(res.body)
    parsed["translatedText"] || "[Translate Error]"
  rescue => e
    puts "Error: #{e.message}"
    "[Translate Error]"
  end
end
