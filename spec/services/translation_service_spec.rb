require 'translation_service'
require 'webmock/rspec'

describe TranslationService do
  let(:service) { TranslationService.new('https://fake-translate.com') }

  before do
    stub_request(:post, "https://fake-translate.com/translate")
      .to_return(status: 200, body: '{"translatedText":"Olá"}', headers: { 'Content-Type' => 'application/json' })
  end

  it 'translates to Portuguese' do
    result = service.translate_to_portuguese("Hello")
    expect(result).to eq("Olá")
  end

  it 'translates to English' do
    result = service.translate_to_english("Olá")
    expect(result).to eq("Olá")
  end

  it 'handles translation errors gracefully' do
    stub_request(:post, "https://fake-translate.com/translate").to_raise(StandardError)
    result = service.translate_to_english("Olá")
    expect(result).to eq("[Translate Error]")
  end
end
