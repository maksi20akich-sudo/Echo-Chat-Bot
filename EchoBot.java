// EchoBot.java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class EchoBot {
    private List<String> history = new ArrayList<>();
    private List<String> greetings = Arrays.asList("Hello there! 👋", "Hi! 😊", "Greetings, human!", "Yo! 🤖", "Howdy!");
    private Random rand = new Random();

    private void addHistory(String msg) {
        history.add(msg);
        if (history.size() > 20) history.remove(0);
    }

    public String process(String text) {
        addHistory(text);
        if (text.startsWith("/")) {
            String[] parts = text.split(" ", 2);
            String cmd = parts[0].toLowerCase();
            String arg = parts.length > 1 ? parts[1] : "";
            switch (cmd) {
                case "/help": return help();
                case "/greet": return greetings.get(rand.nextInt(greetings.size()));
                case "/time": return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                case "/history": return showHistory();
                case "/flip":
                    if (arg.isEmpty()) return "Flip what? Type /flip <message>";
                    return swapCase(arg);
                case "/bye": return "Goodbye! 👋";
                default: return "Unknown command: " + cmd + ". Type /help for commands.";
            }
        }
        return "You said: \"" + text + "\"";
    }

    private String help() {
        return "Available commands:\n" +
               "  /help      - Show this help\n" +
               "  /greet     - Get a random greeting\n" +
               "  /time      - Show current date/time\n" +
               "  /history   - Show recent messages\n" +
               "  /flip <msg> - Echo with swapped case\n" +
               "  /bye       - Exit the bot";
    }

    private String showHistory() {
        if (history.isEmpty()) return "No messages yet.";
        StringBuilder sb = new StringBuilder("Recent messages:\n");
        for (int i = 0; i < history.size(); i++) {
            sb.append("  [").append(i+1).append("] ").append(history.get(i)).append("\n");
        }
        return sb.toString().trim();
    }

    private String swapCase(String s) {
        char[] arr = s.toCharArray();
        for (int i = 0; i < arr.length; i++) {
            if (Character.isLowerCase(arr[i])) arr[i] = Character.toUpperCase(arr[i]);
            else if (Character.isUpperCase(arr[i])) arr[i] = Character.toLowerCase(arr[i]);
        }
        return new String(arr);
    }

    public static void main(String[] args) {
        EchoBot bot = new EchoBot();
        Scanner scanner = new Scanner(System.in);
        System.out.println("🤖 Echo Bot: Hello! Type something or /help.");
        while (true) {
            System.out.print("You: ");
            String user = scanner.nextLine().trim();
            if (user.isEmpty()) continue;
            String response = bot.process(user);
            if (user.contains("/bye")) {
                System.out.println("🤖 Echo Bot: " + response);
                break;
            }
            System.out.println("🤖 Echo Bot: " + response);
        }
        scanner.close();
    }
}
