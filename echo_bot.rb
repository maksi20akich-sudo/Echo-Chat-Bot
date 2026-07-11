# echo_bot.rb
require 'time'

class EchoBot
  def initialize
    @history = []
    @greetings = ["Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!"]
  end

  def add_history(msg)
    @history << msg
    @history.shift if @history.size > 20
  end

  def process(text)
    add_history(text)
    if text.start_with?('/')
      parts = text.split(' ', 2)
      cmd = parts[0].downcase
      arg = parts[1] || ''
      case cmd
      when '/help' then help
      when '/greet' then @greetings.sample
      when '/time' then Time.now.strftime('%Y-%m-%d %H:%M:%S')
      when '/history' then show_history
      when '/flip'
        return "Flip what? Type /flip <message>" if arg.empty?
        arg.swapcase
      when '/bye' then "Goodbye! 👋"
      else "Unknown command: #{cmd}. Type /help for commands."
      end
    else
      "You said: \"#{text}\""
    end
  end

  def help
    <<~HELP
    Available commands:
      /help      - Show this help
      /greet     - Get a random greeting
      /time      - Show current date/time
      /history   - Show recent messages
      /flip <msg> - Echo with swapped case
      /bye       - Exit the bot
    HELP
  end

  def show_history
    return "No messages yet." if @history.empty?
    lines = @history.each_with_index.map { |msg, i| "  [#{i+1}] #{msg}" }
    "Recent messages:\n" + lines.join("\n")
  end
end

def main
  bot = EchoBot.new
  puts "🤖 Echo Bot: Hello! Type something or /help."
  loop do
    print "You: "
    user = gets&.chomp&.strip || ''
    next if user.empty?
    response = bot.process(user)
    if user.include?('/bye')
      puts "🤖 Echo Bot: #{response}"
      break
    end
    puts "🤖 Echo Bot: #{response}"
  end
end

main if __FILE__ == $0
