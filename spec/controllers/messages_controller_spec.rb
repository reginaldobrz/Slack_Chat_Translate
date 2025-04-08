require 'spec_helper'
require_relative '../../app/controllers/messages_controller'

RSpec.describe MessagesController do
  it 'must return an array of messages' do
    expect(MessagesController.all_messages).to be_an(Array)
  end
end
