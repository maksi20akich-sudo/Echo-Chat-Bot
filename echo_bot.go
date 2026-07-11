// echo_bot.go
package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"strings"
	"time"
)

type EchoBot struct {
	history  []string
	greetings []string
}

func NewEchoBot() *EchoBot {
	return &EchoBot{
		history:   []string{},
		greetings: []string{"Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!"},
	}
}

func (b *EchoBot) addHistory(msg string) {
	b.history = append(b.history, msg)
	if len(b.history) > 20 {
		b.history = b.history[1:]
	}
}

func (b *EchoBot) process(text string) string {
	b.addHistory(text)
	if strings.HasPrefix(text, "/") {
		parts := strings.SplitN(text, " ", 2)
		cmd := strings.ToLower(parts[0])
		arg := ""
		if len(parts) > 1 {
			arg = parts[1]
		}
		switch cmd {
		case "/help":
			return b.help()
		case "/greet":
			return b.greetings[rand.Intn(len(b.greetings))]
		case "/time":
			return time.Now().Format("2006-01-02 15:04:05")
		case "/history":
			return b.showHistory()
		case "/flip":
			if arg == "" {
				return "Flip what? Type /flip <message>"
			}
			return swapCase(arg)
		case "/bye":
			return "Goodbye! 👋"
		default:
			return fmt.Sprintf("Unknown command: %s. Type /help for commands.", cmd)
		}
	}
	return fmt.Sprintf("You said: \"%s\"", text)
}

func swapCase(s string) string {
	result := []rune(s)
	for i, r := range result {
		if r >= 'a' && r <= 'z' {
			result[i] = r - 'a' + 'A'
		} else if r >= 'A' && r <= 'Z' {
			result[i] = r - 'A' + 'a'
		}
	}
	return string(result)
}

func (b *EchoBot) help() string {
	return `Available commands:
  /help      - Show this help
  /greet     - Get a random greeting
  /time      - Show current date/time
  /history   - Show recent messages
  /flip <msg> - Echo with swapped case
  /bye       - Exit the bot`
}

func (b *EchoBot) showHistory() string {
	if len(b.history) == 0 {
		return "No messages yet."
	}
	lines := make([]string, len(b.history))
	for i, msg := range b.history {
		lines[i] = fmt.Sprintf("  [%d] %s", i+1, msg)
	}
	return "Recent messages:\n" + strings.Join(lines, "\n")
}

func main() {
	rand.Seed(time.Now().UnixNano())
	bot := NewEchoBot()
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("🤖 Echo Bot: Hello! Type something or /help.")
	for {
		fmt.Print("You: ")
		if !scanner.Scan() {
			break
		}
		user := strings.TrimSpace(scanner.Text())
		if user == "" {
			continue
		}
		response := bot.process(user)
		if strings.Contains(user, "/bye") {
			fmt.Printf("🤖 Echo Bot: %s\n", response)
			break
		}
		fmt.Printf("🤖 Echo Bot: %s\n", response)
	}
}
