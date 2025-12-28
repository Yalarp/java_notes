# Behavioral Design Patterns

## Table of Contents
1. [Introduction to Design Patterns](#1-introduction-to-design-patterns)
2. [Chain of Responsibility Pattern](#2-chain-of-responsibility-pattern)
3. [Observer Design Pattern](#3-observer-design-pattern)
4. [Strategy Pattern](#4-strategy-pattern)
5. [Template Method Pattern](#5-template-method-pattern)
6. [Spring Framework Usage](#6-spring-framework-usage)
7. [When to Use Each Pattern](#7-when-to-use-each-pattern)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction to Design Patterns

### What are Design Patterns?

Design patterns are **proven solutions** to common software design problems. They are templates that can be applied to real-world programming scenarios.

### Categories of Design Patterns

```
┌─────────────────────────────────────────────────────────────┐
│              DESIGN PATTERN CATEGORIES                       │
│                                                              │
│  CREATIONAL (Object Creation)                                │
│  ├── Singleton                                              │
│  ├── Factory Method                                         │
│  ├── Abstract Factory                                       │
│  ├── Builder                                                │
│  └── Prototype                                              │
│                                                              │
│  STRUCTURAL (Object Composition)                             │
│  ├── Adapter                                                │
│  ├── Decorator                                              │
│  ├── Proxy                                                  │
│  ├── Facade                                                 │
│  └── Composite                                              │
│                                                              │
│  BEHAVIORAL (Object Communication) ← This Note              │
│  ├── Chain of Responsibility                                │
│  ├── Observer                                               │
│  ├── Strategy                                               │
│  ├── Template Method                                        │
│  ├── Command                                                │
│  └── State                                                  │
└─────────────────────────────────────────────────────────────┘
```

### Why Use Design Patterns?

- ✅ Proven solutions to common problems
- ✅ Common vocabulary for developers
- ✅ Increase code reusability
- ✅ Make code more maintainable
- ✅ Reduce development time

---

## 2. Chain of Responsibility Pattern

### Definition

Pass a request along a **chain of handlers**. Each handler decides to either **process** the request or **pass it to the next handler**.

### Real-World Analogy

```
┌─────────────────────────────────────────────────────────────┐
│              CHAIN OF RESPONSIBILITY                         │
│                                                              │
│   REAL-WORLD: Customer Support Escalation                   │
│                                                              │
│   Customer Complaint: "Product not working!"                │
│         │                                                    │
│         ▼                                                    │
│   ┌───────────────┐                                          │
│   │ Level 1 Agent │ Can you restart the device?             │
│   │   (Basic)     │ → Can handle? YES → Solved!             │
│   └───────┬───────┘            NO ↓                         │
│           │ Escalate                                         │
│           ▼                                                  │
│   ┌───────────────┐                                          │
│   │ Level 2 Agent │ Need to check diagnostics               │
│   │  (Technical)  │ → Can handle? YES → Solved!             │
│   └───────┬───────┘            NO ↓                         │
│           │ Escalate                                         │
│           ▼                                                  │
│   ┌───────────────┐                                          │
│   │   Manager     │ Authorize replacement                    │
│   │  (Authority)  │ → Must handle!                          │
│   └───────────────┘                                          │
│                                                              │
│   Key: Each handler either handles OR passes to next        │
└─────────────────────────────────────────────────────────────┘
```

### UML Structure

```
       ┌─────────────────────────┐
       │     <<abstract>>        │
       │    Handler              │
       ├─────────────────────────┤
       │ - successor: Handler    │
       ├─────────────────────────┤
       │ + setNext(Handler)      │
       │ + handleRequest(req)    │
       └───────────┬─────────────┘
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │Handler A│ │Handler B│ │Handler C│
   │(Level 1)│ │(Level 2)│ │(Manager)│
   └─────────┘ └─────────┘ └─────────┘
```

### Code Implementation

```java
// Abstract Handler
abstract class SupportHandler {
    protected SupportHandler nextHandler;
    protected String handlerName;
    
    public SupportHandler(String name) {
        this.handlerName = name;
    }
    
    public void setNextHandler(SupportHandler handler) {
        this.nextHandler = handler;
    }
    
    public abstract void handleRequest(SupportTicket ticket);
    
    protected void escalate(SupportTicket ticket) {
        if (nextHandler != null) {
            System.out.println(handlerName + " escalating to: " + 
                nextHandler.handlerName);
            nextHandler.handleRequest(ticket);
        } else {
            System.out.println("No higher authority. Ticket unresolved!");
        }
    }
}

// Support Ticket
class SupportTicket {
    private String issue;
    private int severity;  // 1=Low, 2=Medium, 3=High
    
    public SupportTicket(String issue, int severity) {
        this.issue = issue;
        this.severity = severity;
    }
    
    public String getIssue() { return issue; }
    public int getSeverity() { return severity; }
}

// Concrete Handler - Level 1
class Level1Support extends SupportHandler {
    public Level1Support() { super("Level 1 Support"); }
    
    @Override
    public void handleRequest(SupportTicket ticket) {
        System.out.println("\n[Level 1] Received: " + ticket.getIssue());
        
        if (ticket.getSeverity() <= 1) {
            System.out.println("[Level 1] ✓ Resolved: " + ticket.getIssue());
        } else {
            System.out.println("[Level 1] Cannot handle severity " + 
                ticket.getSeverity());
            escalate(ticket);
        }
    }
}

// Concrete Handler - Level 2
class Level2Support extends SupportHandler {
    public Level2Support() { super("Level 2 Support"); }
    
    @Override
    public void handleRequest(SupportTicket ticket) {
        System.out.println("[Level 2] Analyzing: " + ticket.getIssue());
        
        if (ticket.getSeverity() <= 2) {
            System.out.println("[Level 2] ✓ Resolved: " + ticket.getIssue());
        } else {
            System.out.println("[Level 2] Cannot handle severity " + 
                ticket.getSeverity());
            escalate(ticket);
        }
    }
}

// Concrete Handler - Manager
class ManagerSupport extends SupportHandler {
    public ManagerSupport() { super("Manager"); }
    
    @Override
    public void handleRequest(SupportTicket ticket) {
        System.out.println("[Manager] Reviewing: " + ticket.getIssue());
        System.out.println("[Manager] ✓ Authorized resolution for: " + 
            ticket.getIssue());
    }
}

// Usage
public class ChainDemo {
    public static void main(String[] args) {
        // Build chain
        SupportHandler level1 = new Level1Support();
        SupportHandler level2 = new Level2Support();
        SupportHandler manager = new ManagerSupport();
        
        level1.setNextHandler(level2);
        level2.setNextHandler(manager);
        
        // Test
        System.out.println("=== Low Severity (1) ===");
        level1.handleRequest(new SupportTicket("Password reset", 1));
        
        System.out.println("\n=== Medium Severity (2) ===");
        level1.handleRequest(new SupportTicket("Device malfunction", 2));
        
        System.out.println("\n=== High Severity (3) ===");
        level1.handleRequest(new SupportTicket("Data breach!", 3));
    }
}
```

### Output

```
=== Low Severity (1) ===
[Level 1] Received: Password reset
[Level 1] ✓ Resolved: Password reset

=== Medium Severity (2) ===
[Level 1] Received: Device malfunction
[Level 1] Cannot handle severity 2
Level 1 Support escalating to: Level 2 Support
[Level 2] Analyzing: Device malfunction
[Level 2] ✓ Resolved: Device malfunction

=== High Severity (3) ===
[Level 1] Received: Data breach!
[Level 1] Cannot handle severity 3
Level 1 Support escalating to: Level 2 Support
[Level 2] Analyzing: Data breach!
[Level 2] Cannot handle severity 3
Level 2 Support escalating to: Manager
[Manager] Reviewing: Data breach!
[Manager] ✓ Authorized resolution for: Data breach!
```

---

## 3. Observer Design Pattern

### Definition

Defines a **one-to-many** dependency between objects. When the **subject** (publisher) changes state, all **observers** (subscribers) are **notified automatically**.

### Real-World Analogy

```
┌─────────────────────────────────────────────────────────────┐
│                   OBSERVER PATTERN                           │
│                                                              │
│   REAL-WORLD: YouTube Subscription                          │
│                                                              │
│   YOUTUBE CHANNEL (Subject/Publisher)                        │
│   ┌───────────────────────────────────────────┐             │
│   │         "TechTutorials"                   │             │
│   │                                           │             │
│   │    New Video: "Spring AOP Tutorial"       │             │
│   │              ↓ PUBLISH                    │             │
│   └─────────────────┬─────────────────────────┘             │
│                     │                                        │
│     ┌───────────────┼───────────────┐                       │
│     │               │               │                       │
│     ▼               ▼               ▼                       │
│  ┌──────┐       ┌──────┐       ┌──────┐                    │
│  │Alice │       │ Bob  │       │Charlie│                   │
│  │  📧  │       │  📧  │       │  📧   │                   │
│  │      │       │      │       │       │                   │
│  │update│       │update│       │update │                   │
│  └──────┘       └──────┘       └──────┘                    │
│  (OBSERVERS/SUBSCRIBERS)                                     │
│                                                              │
│   When channel uploads → ALL subscribers notified!          │
└─────────────────────────────────────────────────────────────┘
```

### UML Structure

```
       ┌─────────────────────────┐
       │      <<interface>>      │
       │        Subject          │
       ├─────────────────────────┤
       │ + attach(Observer)      │
       │ + detach(Observer)      │
       │ + notify()              │
       └───────────┬─────────────┘
                   │
                   ▼
       ┌─────────────────────────┐         ┌──────────────────┐
       │    ConcreteSubject      │────────▶│ <<interface>>    │
       ├─────────────────────────┤         │    Observer      │
       │ - state                 │         ├──────────────────┤
       │ - observers: List       │         │ + update(data)   │
       ├─────────────────────────┤         └────────┬─────────┘
       │ + getState()            │                  │
       │ + setState()            │                  ▼
       └─────────────────────────┘         ┌──────────────────┐
                                           │ ConcreteObserver │
                                           └──────────────────┘
```

### Code Implementation

```java
// Observer Interface
interface Observer {
    void update(String channelName, String videoTitle);
}

// Subject Interface
interface Subject {
    void subscribe(Observer observer);
    void unsubscribe(Observer observer);
    void notifySubscribers();
}

// Concrete Subject (YouTube Channel)
class YouTubeChannel implements Subject {
    private String channelName;
    private List<Observer> subscribers = new ArrayList<>();
    private String latestVideo;
    
    public YouTubeChannel(String name) {
        this.channelName = name;
    }
    
    @Override
    public void subscribe(Observer observer) {
        subscribers.add(observer);
        System.out.println("New subscriber added! Total: " + subscribers.size());
    }
    
    @Override
    public void unsubscribe(Observer observer) {
        subscribers.remove(observer);
        System.out.println("Subscriber removed. Total: " + subscribers.size());
    }
    
    @Override
    public void notifySubscribers() {
        System.out.println("\n📢 Notifying all " + subscribers.size() + " subscribers...");
        for (Observer subscriber : subscribers) {
            subscriber.update(channelName, latestVideo);
        }
    }
    
    public void uploadVideo(String title) {
        this.latestVideo = title;
        System.out.println("\n🎬 [" + channelName + "] Uploaded: " + title);
        notifySubscribers();
    }
}

// Concrete Observer (Subscriber)
class Subscriber implements Observer {
    private String name;
    
    public Subscriber(String name) {
        this.name = name;
    }
    
    @Override
    public void update(String channelName, String videoTitle) {
        System.out.println("  📧 " + name + " received: New video from " + 
            channelName + " - \"" + videoTitle + "\"");
    }
    
    public String getName() { return name; }
}

// Usage
public class ObserverDemo {
    public static void main(String[] args) {
        // Create channel
        YouTubeChannel channel = new YouTubeChannel("TechTutorials");
        
        // Create subscribers
        Subscriber alice = new Subscriber("Alice");
        Subscriber bob = new Subscriber("Bob");
        Subscriber charlie = new Subscriber("Charlie");
        
        // Subscribe
        channel.subscribe(alice);
        channel.subscribe(bob);
        channel.subscribe(charlie);
        
        // Upload video - all subscribers notified!
        channel.uploadVideo("Spring AOP Tutorial");
        
        // Bob unsubscribes
        System.out.println("\n" + bob.getName() + " unsubscribes...");
        channel.unsubscribe(bob);
        
        // Upload another video
        channel.uploadVideo("Spring Boot Mastery");
    }
}
```

### Output

```
New subscriber added! Total: 1
New subscriber added! Total: 2
New subscriber added! Total: 3

🎬 [TechTutorials] Uploaded: Spring AOP Tutorial

📢 Notifying all 3 subscribers...
  📧 Alice received: New video from TechTutorials - "Spring AOP Tutorial"
  📧 Bob received: New video from TechTutorials - "Spring AOP Tutorial"
  📧 Charlie received: New video from TechTutorials - "Spring AOP Tutorial"

Bob unsubscribes...
Subscriber removed. Total: 2

🎬 [TechTutorials] Uploaded: Spring Boot Mastery

📢 Notifying all 2 subscribers...
  📧 Alice received: New video from TechTutorials - "Spring Boot Mastery"
  📧 Charlie received: New video from TechTutorials - "Spring Boot Mastery"
```

---

## 4. Strategy Pattern

### Definition

Define a family of algorithms, encapsulate each one, and make them **interchangeable**. Strategy lets the algorithm vary independently from clients that use it.

### Code Example

```java
// Strategy Interface
interface PaymentStrategy {
    void pay(double amount);
}

// Concrete Strategies
class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;
    
    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println("Paid $" + amount + " using Credit Card: " + 
            cardNumber.substring(12) + "XXXX");
    }
}

class UPIPayment implements PaymentStrategy {
    private String upiId;
    
    public UPIPayment(String upiId) {
        this.upiId = upiId;
    }
    
    @Override
    public void pay(double amount) {
        System.out.println("Paid ₹" + amount + " using UPI: " + upiId);
    }
}

// Context
class ShoppingCart {
    private PaymentStrategy paymentStrategy;
    
    public void setPaymentStrategy(PaymentStrategy strategy) {
        this.paymentStrategy = strategy;
    }
    
    public void checkout(double amount) {
        paymentStrategy.pay(amount);
    }
}

// Usage
public class StrategyDemo {
    public static void main(String[] args) {
        ShoppingCart cart = new ShoppingCart();
        
        // Pay with credit card
        cart.setPaymentStrategy(new CreditCardPayment("1234567890123456"));
        cart.checkout(100.0);
        
        // Switch to UPI
        cart.setPaymentStrategy(new UPIPayment("user@upi"));
        cart.checkout(50.0);
    }
}
```

---

## 5. Template Method Pattern

### Definition

Define the **skeleton of an algorithm** in a method, deferring some steps to subclasses. Template Method lets subclasses redefine certain steps without changing the algorithm's structure.

### Code Example

```java
// Abstract Class with Template Method
abstract class DataMiner {
    
    // Template Method - defines algorithm skeleton
    public final void mine() {
        openFile();
        extractData();
        parseData();
        analyzeData();
        sendReport();
        closeFile();
    }
    
    // Common steps
    private void analyzeData() {
        System.out.println("Analyzing data...");
    }
    
    private void sendReport() {
        System.out.println("Sending report via email...");
    }
    
    // Steps to be implemented by subclasses
    protected abstract void openFile();
    protected abstract void extractData();
    protected abstract void parseData();
    protected abstract void closeFile();
}

// Concrete Implementation - PDF
class PDFMiner extends DataMiner {
    protected void openFile() { System.out.println("Opening PDF file"); }
    protected void extractData() { System.out.println("Extracting PDF text"); }
    protected void parseData() { System.out.println("Parsing PDF data"); }
    protected void closeFile() { System.out.println("Closing PDF file"); }
}

// Concrete Implementation - CSV
class CSVMiner extends DataMiner {
    protected void openFile() { System.out.println("Opening CSV file"); }
    protected void extractData() { System.out.println("Reading CSV rows"); }
    protected void parseData() { System.out.println("Parsing CSV columns"); }
    protected void closeFile() { System.out.println("Closing CSV file"); }
}
```

---

## 6. Spring Framework Usage

### Chain of Responsibility in Spring

```java
// Spring Security Filter Chain
@Configuration
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        // Authentication Filter → Authorization Filter → ...
        return http
            .authorizeHttpRequests(...)
            .formLogin(...)
            .build();
    }
}
```

### Observer Pattern in Spring

```java
// Define Custom Event
public class UserRegisteredEvent extends ApplicationEvent {
    private User user;
    
    public UserRegisteredEvent(Object source, User user) {
        super(source);
        this.user = user;
    }
    
    public User getUser() { return user; }
}

// Publisher (Subject)
@Service
public class UserService {
    @Autowired
    private ApplicationEventPublisher publisher;
    
    public void registerUser(User user) {
        // Save user...
        
        // Publish event - all listeners notified
        publisher.publishEvent(new UserRegisteredEvent(this, user));
    }
}

// Observer 1 - Send Welcome Email
@Component
public class EmailNotificationListener {
    
    @EventListener
    public void handleUserRegistered(UserRegisteredEvent event) {
        System.out.println("Sending welcome email to: " + 
            event.getUser().getEmail());
    }
}

// Observer 2 - Create Audit Log
@Component
public class AuditLogListener {
    
    @EventListener
    public void handleUserRegistered(UserRegisteredEvent event) {
        System.out.println("Logging user registration: " + 
            event.getUser().getName());
    }
}

// Observer 3 - Async Processing
@Component
public class AsyncListener {
    
    @Async
    @EventListener
    public void handleUserRegistered(UserRegisteredEvent event) {
        // Runs in separate thread
        System.out.println("Processing async for: " + 
            event.getUser().getName());
    }
}
```

### Strategy Pattern in Spring

```java
// Strategy Interface
public interface NotificationStrategy {
    void send(String message, String recipient);
}

// Implementations
@Component("emailNotification")
public class EmailNotification implements NotificationStrategy {
    public void send(String message, String recipient) {
        System.out.println("Email to " + recipient + ": " + message);
    }
}

@Component("smsNotification")
public class SMSNotification implements NotificationStrategy {
    public void send(String message, String recipient) {
        System.out.println("SMS to " + recipient + ": " + message);
    }
}

// Service using Strategy
@Service
public class NotificationService {
    
    @Autowired
    @Qualifier("emailNotification")
    private NotificationStrategy strategy;
    
    public void notify(String message, String recipient) {
        strategy.send(message, recipient);
    }
}
```

---

## 7. When to Use Each Pattern

| Pattern | Use When |
|---------|----------|
| **Chain of Responsibility** | Multiple handlers, unclear which will handle |
| **Observer** | One change needs to notify many objects |
| **Strategy** | Multiple algorithms, switch at runtime |
| **Template Method** | Algorithm skeleton with customizable steps |

```
┌─────────────────────────────────────────────────────────────┐
│              PATTERN SELECTION GUIDE                         │
│                                                              │
│  "Who should handle this request?"                          │
│  → CHAIN OF RESPONSIBILITY                                   │
│                                                              │
│  "Notify everyone when this happens"                        │
│  → OBSERVER                                                  │
│                                                              │
│  "Do the same thing, but differently"                       │
│  → STRATEGY                                                  │
│                                                              │
│  "Same steps, different implementations"                    │
│  → TEMPLATE METHOD                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Common Interview Questions

### Q1: What is Chain of Responsibility?
**A:** A pattern where a request is passed along a chain of handlers. Each handler decides to process the request or pass it to the next handler in the chain.

### Q2: What is Observer Pattern?
**A:** Defines a one-to-many dependency. When the subject (publisher) changes state, all observers (subscribers) are notified automatically.

### Q3: Where does Spring use these patterns?
**A:**
- **Chain of Responsibility**: Security Filter Chain, Interceptors
- **Observer**: ApplicationEvent and @EventListener
- **Strategy**: Various interface implementations with @Qualifier
- **Template Method**: JdbcTemplate, RestTemplate

### Q4: Observer vs Pub-Sub?
**A:**
- Observer: Subject knows about observers directly
- Pub-Sub: Uses message broker, publisher doesn't know subscribers

### Q5: What is Strategy Pattern?
**A:** Defines interchangeable algorithms. Client can switch algorithms at runtime without changing its code.

---

## 9. Key Takeaways

📌 **Chain of Responsibility** - sequential handler chain

📌 **Observer** - one-to-many notification (publish-subscribe)

📌 **Strategy** - interchangeable algorithms

📌 **Template Method** - algorithm skeleton with customizable steps

📌 **Spring Security** uses Chain of Responsibility

📌 **Spring Events** implement Observer pattern

📌 **@EventListener** for observing events in Spring

📌 **@Qualifier** helps implement Strategy pattern

📌 Design patterns solve **common** problems

📌 Learn the **intent**, not just the code

---

*Previous: [16. HibernateTemplate Integration](./16_HibernateTemplate_Integration.md)*

*Next: [18. SOLID Design Principles](./18_SOLID_Design_Principles.md)*
