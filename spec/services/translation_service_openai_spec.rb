require 'translation_service_openai'
require 'webmock/rspec'

describe TranslationServiceOpenAi do
  let(:dummy_key) { 'test-key' }
  let(:service) { TranslationServiceOpenAi.new(dummy_key) }

  before do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_return(status: 200, body: {
        choices: [
          { message: { content: "Hello" } }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'translates from Portuguese to English' do
    result = service.translate_to_english("Olá")
    expect(result).to eq("Hello")
  end

  it 'translates from English to Portuguese' do
    result = service.translate_to_portuguese("Hello")
    expect(result).to eq("Hello")
  end

  it 'handles API errors gracefully' do
    stub_request(:post, "https://api.openai.com/v1/chat/completions")
      .to_raise(StandardError.new("Timeout"))

    result = service.translate_to_english("Olá")
    expect(result).to match(/\[Translate Error:/)
  end
end
