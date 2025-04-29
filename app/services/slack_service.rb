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

  def fetch_user_name(user_id)
    uri = URI("https://slack.com/api/users.info?user=#{user_id}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{ENV['SLACK_BOT_TOKEN']}"
    req['Content-Type'] = 'application/json'

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)
      if data["ok"]
        data["user"]["profile"]["real_name"] || "Unknown User"
      else
        puts "[SlackService] Erro buscando usuário: #{data['error']}"
        "Unknown User"
      end
    else
      puts "[SlackService] Erro HTTP buscando usuário: #{res.code}"
      "Unknown User"
    end
  rescue => e
    puts "Erro ao buscar nome do usuário Slack: #{e.message}"
    "Unknown User"
  end  
end
