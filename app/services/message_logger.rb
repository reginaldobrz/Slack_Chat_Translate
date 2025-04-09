require 'json'

class MessageLogger
  def initialize(file_path = 'messages.json')
    @file_path = file_path
  end

  def load_messages
    return [] unless File.exist?(@file_path)

    content = File.read(@file_path)
    content.empty? ? [] : JSON.parse(content)
  rescue => e
    puts "Error to load messages: \#{e.message}"
    []
  end

  def log(data)
    messages = load_messages
    messages << data
    File.write(@file_path, JSON.pretty_generate(messages))
  end
end
