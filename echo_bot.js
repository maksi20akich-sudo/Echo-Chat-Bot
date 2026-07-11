// echo_bot.js
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

class EchoBot {
    constructor() {
        this.history = [];
        this.greetings = ["Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!"];
    }

    addHistory(msg) {
        this.history.push(msg);
        if (this.history.length > 20) this.history.shift();
    }

    process(text) {
        this.addHistory(text);
        if (text.startsWith('/')) {
            const parts = text.split(' ');
            const cmd = parts[0].toLowerCase();
            const arg = parts.slice(1).join(' ');
            switch (cmd) {
                case '/help': return this.help();
                case '/greet': return this.greetings[Math.floor(Math.random() * this.greetings.length)];
                case '/time': return new Date().toLocaleString();
                case '/history': return this.showHistory();
                case '/flip':
                    if (!arg) return "Flip what? Type /flip <message>";
                    return arg.split('').map(c => c === c.toUpperCase() ? c.toLowerCase() : c.toUpperCase()).join('');
                case '/bye': return "Goodbye! 👋";
                default: return `Unknown command: ${cmd}. Type /help for commands.`;
            }
        }
        return `You said: "${text}"`;
    }

    help() {
        return `Available commands:
  /help      - Show this help
  /greet     - Get a random greeting
  /time      - Show current date/time
  /history   - Show recent messages
  /flip <msg> - Echo with swapped case
  /bye       - Exit the bot`;
    }

    showHistory() {
        if (this.history.length === 0) return "No messages yet.";
        const lines = this.history.map((msg, i) => `  [${i+1}] ${msg}`);
        return "Recent messages:\n" + lines.join('\n');
    }
}

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

async function main() {
    const bot = new EchoBot();
    console.log("🤖 Echo Bot: Hello! Type something or /help.");
    while (true) {
        const user = await ask("You: ");
        if (!user.trim()) continue;
        const response = bot.process(user);
        if (user.includes('/bye')) {
            console.log(`🤖 Echo Bot: ${response}`);
            break;
        }
        console.log(`🤖 Echo Bot: ${response}`);
    }
    rl.close();
}

main().catch(console.error);
