// echo_bot.swift
import Foundation

class EchoBot {
    private var history: [String] = []
    private let greetings = ["Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!"]

    private func addHistory(_ msg: String) {
        history.append(msg)
        if history.count > 20 { history.removeFirst() }
    }

    func process(_ text: String) -> String {
        addHistory(text)
        if text.hasPrefix("/") {
            let parts = text.split(separator: " ", maxSplits: 1).map(String.init)
            let cmd = parts[0].lowercased()
            let arg = parts.count > 1 ? parts[1] : ""
            switch cmd {
            case "/help": return help()
            case "/greet": return greetings.randomElement()!
            case "/time": return Date().formatted()
            case "/history": return showHistory()
            case "/flip":
                if arg.isEmpty { return "Flip what? Type /flip <message>" }
                return arg.map { $0.isLowercase ? $0.uppercased() : $0.lowercased() }.joined()
            case "/bye": return "Goodbye! 👋"
            default: return "Unknown command: \(cmd). Type /help for commands."
            }
        }
        return "You said: \"\(text)\""
    }

    private func help() -> String {
        return """
        Available commands:
          /help      - Show this help
          /greet     - Get a random greeting
          /time      - Show current date/time
          /history   - Show recent messages
          /flip <msg> - Echo with swapped case
          /bye       - Exit the bot
        """
    }

    private func showHistory() -> String {
        if history.isEmpty { return "No messages yet." }
        let lines = history.enumerated().map { "  [\($0.offset+1)] \($0.element)" }
        return "Recent messages:\n" + lines.joined(separator: "\n")
    }
}

func main() {
    let bot = EchoBot()
    print("🤖 Echo Bot: Hello! Type something or /help.")
    while true {
        print("You: ", terminator: "")
        guard let user = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { break }
        if user.isEmpty { continue }
        let response = bot.process(user)
        if user.contains("/bye") {
            print("🤖 Echo Bot: \(response)")
            break
        }
        print("🤖 Echo Bot: \(response)")
    }
}

main()
