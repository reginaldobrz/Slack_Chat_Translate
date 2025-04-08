require 'spec_helper'
require 'rack/test'
require_relative '../app'

RSpec.describe 'Slack Translator App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'must return the messages on route /messages_json' do
    get '/messages_json'
    expect(last_response).to be_ok
    expect { JSON.parse(last_response.body) }.not_to raise_error
  end
end
