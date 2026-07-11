// EchoBot.cs
using System;
using System.Collections.Generic;

class EchoBot
{
    private List<string> history = new List<string>();
    private List<string> greetings = new List<string> { "Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!" };
    private Random rand = new Random();

    private void AddHistory(string msg)
    {
        history.Add(msg);
        if (history.Count > 20) history.RemoveAt(0);
    }

    public string Process(string text)
    {
        AddHistory(text);
        if (text.StartsWith("/"))
        {
            string[] parts = text.Split(' ', 2);
            string cmd = parts[0].ToLower();
            string arg = parts.Length > 1 ? parts[1] : "";
            switch (cmd)
            {
                case "/help": return Help();
                case "/greet": return greetings[rand.Next(greetings.Count)];
                case "/time": return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                case "/history": return ShowHistory();
                case "/flip":
                    if (string.IsNullOrEmpty(arg)) return "Flip what? Type /flip <message>";
                    return SwapCase(arg);
                case "/bye": return "Goodbye! 👋";
                default: return $"Unknown command: {cmd}. Type /help for commands.";
            }
        }
        return $"You said: \"{text}\"";
    }

    private string Help()
    {
        return @"Available commands:
  /help      - Show this help
  /greet     - Get a random greeting
  /time      - Show current date/time
  /history   - Show recent messages
  /flip <msg> - Echo with swapped case
  /bye       - Exit the bot";
    }

    private string ShowHistory()
    {
        if (history.Count == 0) return "No messages yet.";
        List<string> lines = new List<string>();
        for (int i = 0; i < history.Count; i++)
            lines.Add($"  [{i+1}] {history[i]}");
        return "Recent messages:\n" + string.Join("\n", lines);
    }

    private string SwapCase(string s)
    {
        char[] arr = s.ToCharArray();
        for (int i = 0; i < arr.Length; i++)
        {
            if (char.IsLower(arr[i])) arr[i] = char.ToUpper(arr[i]);
            else if (char.IsUpper(arr[i])) arr[i] = char.ToLower(arr[i]);
        }
        return new string(arr);
    }

    static void Main()
    {
        var bot = new EchoBot();
        Console.WriteLine("🤖 Echo Bot: Hello! Type something or /help.");
        while (true)
        {
            Console.Write("You: ");
            string user = Console.ReadLine()?.Trim();
            if (string.IsNullOrEmpty(user)) continue;
            string response = bot.Process(user);
            if (user.Contains("/bye"))
            {
                Console.WriteLine($"🤖 Echo Bot: {response}");
                break;
            }
            Console.WriteLine($"🤖 Echo Bot: {response}");
        }
    }
}
