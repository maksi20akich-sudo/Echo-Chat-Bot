# echo_bot.py
import datetime
import random
import sys

class EchoBot:
    def __init__(self):
        self.history = []
        self.greetings = ["Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!"]

    def _add_history(self, msg):
        self.history.append(msg)
        if len(self.history) > 20:
            self.history.pop(0)

    def process(self, text):
        self._add_history(text)
        if text.startswith("/"):
            parts = text.split(" ", 1)
            cmd = parts[0].lower()
            arg = parts[1] if len(parts) > 1 else ""
            if cmd == "/help":
                return self.help()
            elif cmd == "/greet":
                return random.choice(self.greetings)
            elif cmd == "/time":
                return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            elif cmd == "/history":
                return self.show_history()
            elif cmd == "/flip":
                return arg.swapcase() if arg else "Flip what? Type /flip <message>"
            elif cmd == "/bye":
                return "Goodbye! 👋"
            else:
                return f"Unknown command: {cmd}. Type /help for commands."
        else:
            return f"You said: \"{text}\""

    def help(self):
        return """Available commands:
  /help      - Show this help
  /greet     - Get a random greeting
  /time      - Show current date/time
  /history   - Show recent messages
  /flip <msg> - Echo with swapped case
  /bye       - Exit the bot"""

    def show_history(self):
        if not self.history:
            return "No messages yet."
        lines = [f"  [{i+1}] {msg}" for i, msg in enumerate(self.history)]
        return "Recent messages:\n" + "\n".join(lines)

def main():
    bot = EchoBot()
    print("🤖 Echo Bot: Hello! Type something or /help.")
    while True:
        try:
            user = input("You: ").strip()
            if not user:
                continue
            response = bot.process(user)
            if "/bye" in user:
                print(f"🤖 Echo Bot: {response}")
                break
            print(f"🤖 Echo Bot: {response}")
        except KeyboardInterrupt:
            print("\n🤖 Echo Bot: Goodbye! 👋")
            break
        except EOFError:
            break

if __name__ == "__main__":
    main()
