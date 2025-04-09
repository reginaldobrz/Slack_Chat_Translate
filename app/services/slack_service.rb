require 'net/http'
require 'uri'
require 'json'

class SlackService
  def initialize(webhook_url = ENV['SLACK_WEBHOOK_URL'])
    raise ArgumentError, "Webhook URL is required" if webhook_url.nil? || webhook_url.strip.empty?

    @uri = URI.parse(webhook_url)
    @header = { 'Content-Type' => 'application/json' }
  end

  def send_message(text)
    body = { text: text }.to_json
    Net::HTTP.post(@uri, body, @header)
  end
end
