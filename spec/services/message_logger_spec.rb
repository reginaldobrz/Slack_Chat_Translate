require 'message_logger'
require 'fileutils'

describe MessageLogger do
  let(:test_path) { 'spec/test_messages.json' }
  let(:logger) { MessageLogger.new(test_path) }

  before do
    File.write(test_path, JSON.dump([{ original: "Hello", translated: "Olá" }]))
  end

  after do
    FileUtils.rm_f(test_path)
  end

  it 'loads messages from file' do
    messages = logger.load_messages
    expect(messages).to be_a(Array)
    expect(messages.first['original']).to eq("Hello")
  end

  it 'logs a new message' do
    logger.log({ original: "Bye", translated: "Tchau" })
    messages = logger.load_messages
    expect(messages.map { |m| m['original'] }).to include("Bye")
  end
end
