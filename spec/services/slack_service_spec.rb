require 'slack_service'

describe SlackService do
  let(:fake_url) { 'https://hooks.slack.com/services/FAKE/WEBHOOK/URL' }
  let(:service) { SlackService.new(fake_url) }

  it 'raises error with empty url' do
    expect { SlackService.new('') }.to raise_error(ArgumentError)
  end

  it 'responds to send_message' do
    expect(service).to respond_to(:send_message)
  end
end
