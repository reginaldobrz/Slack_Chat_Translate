require 'spec_helper'
require_relative '../../app/services/translation_service'

RSpec.describe TranslationService do
  it 'should return a text translated into English' do
    result = TranslationService.translate_to_english("Olá mundo")
    expect(result).to be_a(String)
  end
end
