require 'spec_helper'
require_relative '../../app/services/message_logger'

RSpec.describe MessageLogger do
  it 'should load messages from JSON file without error' do
    expect { MessageLogger.load_messages }.not_to raise_error
  end
end
