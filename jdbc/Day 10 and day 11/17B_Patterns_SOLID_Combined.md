# Design Patterns in Spring

## Table of Contents
1. [Introduction](#1-introduction)
2. [Observer Pattern](#2-observer-pattern)
3. [Chain of Responsibility Pattern](#3-chain-of-responsibility-pattern)
4. [SOLID Principles](#4-solid-principles)
5. [Patterns Used by Spring](#5-patterns-used-by-spring)
6. [Common Interview Questions](#6-common-interview-questions)
7. [Key Takeaways](#7-key-takeaways)

---

## 1. Introduction

Understanding **Design Patterns** and **Design Principles** is crucial for building maintainable, scalable applications. Spring Framework itself uses many design patterns internally.

---

## 2. Observer Pattern

### What is Observer Pattern?

The **Observer Pattern** defines a one-to-many dependency between objects. When one object (subject) changes state, all its dependents (observers) are notified automatically.

### Real-World Analogy

```
┌─────────────────────────────────────────────────────────────┐
│                   OBSERVER PATTERN                           │
│                                                              │
│   Real World Example: YouTube Subscription                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                      │   │
│   │   YOUTUBE CHANNEL (Subject)                         │   │
│   │   ┌───────────────────────────────────────────┐     │   │
│   │   │         "TechTutorials"                   │     │   │
│   │   │                                           │     │   │
│   │   │    New Video: "Spring AOP Tutorial"       │     │   │
│   │   └─────────────────┬─────────────────────────┘     │   │
│   │                     │ Notify all subscribers        │   │
│   │     ┌───────────────┼───────────────┐               │   │
│   │     ▼               ▼               ▼               │   │
│   │  ┌──────┐       ┌──────┐       ┌──────┐            │   │
│   │  │User A│       │User B│       │User C│            │   │
│   │  │📧    │       │📧    │       │📧    │            │   │
│   │  └──────┘       └──────┘       └──────┘            │   │
│   │  (Observers)                                        │   │
│   │                                                      │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   When channel uploads video, ALL subscribers are notified! │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

```java
// Observer Interface
interface Observer {
    void update(String message);
}

// Subject Interface
interface Subject {
    void registerObserver(Observer o);
    void removeObserver(Observer o);
    void notifyObservers();
}

// Concrete Subject (YouTube Channel)
class YouTubeChannel implements Subject {
    private List<Observer> subscribers = new ArrayList<>();
    private String latestVideo;
    
    @Override
    public void registerObserver(Observer o) {
        subscribers.add(o);
    }
    
    @Override
    public void removeObserver(Observer o) {
        subscribers.remove(o);
    }
    
    @Override
    public void notifyObservers() {
        for (Observer o : subscribers) {
            o.update(latestVideo);
        }
    }
    
    public void uploadVideo(String title) {
        this.latestVideo = title;
        System.out.println("New video uploaded: " + title);
        notifyObservers();
    }
}

// Concrete Observer (Subscriber)
class Subscriber implements Observer {
    private String name;
    
    public Subscriber(String name) {
        this.name = name;
    }
    
    @Override
    public void update(String message) {
        System.out.println(name + " received notification: " + message);
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        YouTubeChannel channel = new YouTubeChannel();
        
        // Subscribe users
        channel.registerObserver(new Subscriber("Alice"));
        channel.registerObserver(new Subscriber("Bob"));
        channel.registerObserver(new Subscriber("Charlie"));
        
        // Upload video - all subscribers notified!
        channel.uploadVideo("Spring AOP Tutorial");
    }
}
```

**Output:**
```
New video uploaded: Spring AOP Tutorial
Alice received notification: Spring AOP Tutorial
Bob received notification: Spring AOP Tutorial
Charlie received notification: Spring AOP Tutorial
```

### Spring's Observer Pattern: ApplicationEvent

Spring uses this pattern for event handling:

```java
// Define Event
public class UserCreatedEvent extends ApplicationEvent {
    private User user;
    
    public UserCreatedEvent(Object source, User user) {
        super(source);
        this.user = user;
    }
}

// Publisher
@Service
public class UserService {
    @Autowired
    private ApplicationEventPublisher publisher;
    
    public void createUser(User user) {
        // Save user
        publisher.publishEvent(new UserCreatedEvent(this, user));
    }
}

// Observer/Listener
@Component
public class EmailNotificationListener {
    @EventListener
    public void handleUserCreated(UserCreatedEvent event) {
        // Send welcome email
    }
}
```

---

## 3. Chain of Responsibility Pattern

### What is Chain of Responsibility?

The **Chain of Responsibility** pattern passes a request along a chain of handlers. Each handler decides whether to process the request or pass it to the next handler.

### Real-World Analogy

```
┌─────────────────────────────────────────────────────────────┐
│              CHAIN OF RESPONSIBILITY                         │
│                                                              │
│   Real World Example: Support Ticket System                  │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                      │   │
│   │   Customer Complaint                                 │   │
│   │         │                                            │   │
│   │         ▼                                            │   │
│   │   ┌───────────────┐                                  │   │
│   │   │ Level 1 Agent │ ──► Can handle? YES ──► Solved! │   │
│   │   └───────┬───────┘                                  │   │
│   │           │ NO - Escalate                            │   │
│   │           ▼                                          │   │
│   │   ┌───────────────┐                                  │   │
│   │   │ Level 2 Agent │ ──► Can handle? YES ──► Solved! │   │
│   │   └───────┬───────┘                                  │   │
│   │           │ NO - Escalate                            │   │
│   │           ▼                                          │   │
│   │   ┌───────────────┐                                  │   │
│   │   │   Manager     │ ──► Must handle                 │   │
│   │   └───────────────┘                                  │   │
│   │                                                      │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

```java
// Abstract Handler
abstract class SupportHandler {
    protected SupportHandler nextHandler;
    
    public void setNextHandler(SupportHandler handler) {
        this.nextHandler = handler;
    }
    
    public abstract void handleRequest(Ticket ticket);
}

// Level 1 Handler
class Level1Support extends SupportHandler {
    @Override
    public void handleRequest(Ticket ticket) {
        if (ticket.getSeverity() <= 1) {
            System.out.println("Level 1 Support handled: " + ticket.getDescription());
        } else if (nextHandler != null) {
            System.out.println("Level 1 cannot handle, escalating...");
            nextHandler.handleRequest(ticket);
        }
    }
}

// Level 2 Handler
class Level2Support extends SupportHandler {
    @Override
    public void handleRequest(Ticket ticket) {
        if (ticket.getSeverity() <= 3) {
            System.out.println("Level 2 Support handled: " + ticket.getDescription());
        } else if (nextHandler != null) {
            System.out.println("Level 2 cannot handle, escalating...");
            nextHandler.handleRequest(ticket);
        }
    }
}

// Manager Handler
class ManagerSupport extends SupportHandler {
    @Override
    public void handleRequest(Ticket ticket) {
        System.out.println("Manager handled critical issue: " + ticket.getDescription());
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        // Create chain
        SupportHandler level1 = new Level1Support();
        SupportHandler level2 = new Level2Support();
        SupportHandler manager = new ManagerSupport();
        
        level1.setNextHandler(level2);
        level2.setNextHandler(manager);
        
        // Test different severity tickets
        Ticket simpleTicket = new Ticket("Password reset", 1);
        Ticket mediumTicket = new Ticket("System slow", 2);
        Ticket criticalTicket = new Ticket("Data breach!", 5);
        
        level1.handleRequest(simpleTicket);
        level1.handleRequest(mediumTicket);
        level1.handleRequest(criticalTicket);
    }
}
```

### Spring's Chain: Filter Chain

Spring Security uses this pattern:

```java
// Each filter is a handler in the chain
public class SecurityFilterChain {
    // AuthenticationFilter → AuthorizationFilter → ...
}
```

---

## 4. SOLID Principles

### What is SOLID?

SOLID is an acronym for five design principles that make software designs more understandable, flexible, and maintainable.

### S - Single Responsibility Principle

```
┌─────────────────────────────────────────────────────────────┐
│       SINGLE RESPONSIBILITY PRINCIPLE (SRP)                  │
│                                                              │
│   "A class should have only ONE reason to change"           │
│                                                              │
│   ❌ BAD:                                                    │
│   class User {                                               │
│       void saveUser() { }        // Database logic          │
│       void sendEmail() { }       // Email logic             │
│       void generateReport() { }  // Report logic            │
│   }                                                          │
│                                                              │
│   ✅ GOOD:                                                   │
│   class User { }                      // Just data          │
│   class UserRepository { save() }     // Database           │
│   class EmailService { send() }       // Email              │
│   class ReportGenerator { generate() }// Reports           │
└─────────────────────────────────────────────────────────────┘
```

### O - Open/Closed Principle

```
┌─────────────────────────────────────────────────────────────┐
│         OPEN/CLOSED PRINCIPLE (OCP)                          │
│                                                              │
│   "Open for extension, closed for modification"             │
│                                                              │
│   ❌ BAD (Modifying existing code):                         │
│   class DiscountCalculator {                                 │
│       double calculate(String type) {                        │
│           if (type.equals("student")) return 0.1;           │
│           if (type.equals("senior")) return 0.2;            │
│           // Must modify class for new discount type!       │
│       }                                                      │
│   }                                                          │
│                                                              │
│   ✅ GOOD (Extending without modification):                 │
│   interface Discount { double getRate(); }                  │
│   class StudentDiscount implements Discount { }             │
│   class SeniorDiscount implements Discount { }              │
│   class MilitaryDiscount implements Discount { }  // New!   │
└─────────────────────────────────────────────────────────────┘
```

### L - Liskov Substitution Principle

```
┌─────────────────────────────────────────────────────────────┐
│         LISKOV SUBSTITUTION PRINCIPLE (LSP)                  │
│                                                              │
│   "Subtypes must be substitutable for their base types"     │
│                                                              │
│   ❌ BAD (Square overrides Rectangle incorrectly):          │
│   class Rectangle {                                          │
│       void setWidth(int w) { this.width = w; }              │
│       void setHeight(int h) { this.height = h; }            │
│   }                                                          │
│   class Square extends Rectangle {                           │
│       void setWidth(int w) { this.width = w; this.height = w; }│
│       // Breaks Rectangle's expected behavior!              │
│   }                                                          │
│                                                              │
│   ✅ GOOD: Use interface instead                            │
│   interface Shape { int getArea(); }                        │
│   class Rectangle implements Shape { }                      │
│   class Square implements Shape { }                         │
└─────────────────────────────────────────────────────────────┘
```

### I - Interface Segregation Principle

```
┌─────────────────────────────────────────────────────────────┐
│       INTERFACE SEGREGATION PRINCIPLE (ISP)                  │
│                                                              │
│   "Clients should not be forced to depend on methods        │
│    they do not use"                                          │
│                                                              │
│   ❌ BAD (Fat interface):                                    │
│   interface Worker {                                         │
│       void work();                                           │
│       void eat();    // Robot doesn't eat!                  │
│       void sleep();  // Robot doesn't sleep!                │
│   }                                                          │
│                                                              │
│   ✅ GOOD (Segregated interfaces):                          │
│   interface Workable { void work(); }                       │
│   interface Eatable { void eat(); }                         │
│   interface Sleepable { void sleep(); }                     │
│                                                              │
│   class Human implements Workable, Eatable, Sleepable { }   │
│   class Robot implements Workable { }                       │
└─────────────────────────────────────────────────────────────┘
```

### D - Dependency Inversion Principle

```
┌─────────────────────────────────────────────────────────────┐
│       DEPENDENCY INVERSION PRINCIPLE (DIP)                   │
│                                                              │
│   "Depend on abstractions, not concretions"                 │
│                                                              │
│   ❌ BAD (Depends on concrete class):                       │
│   class OrderService {                                       │
│       private MySQLDatabase db = new MySQLDatabase();       │
│       // Tightly coupled to MySQL!                          │
│   }                                                          │
│                                                              │
│   ✅ GOOD (Depends on abstraction):                         │
│   interface Database { void save(); }                       │
│                                                              │
│   class OrderService {                                       │
│       private Database db;  // Interface, not concrete      │
│       public OrderService(Database db) {                    │
│           this.db = db;  // Injected!                       │
│       }                                                      │
│   }                                                          │
│                                                              │
│   // Can use MySQL, PostgreSQL, MongoDB, etc.               │
└─────────────────────────────────────────────────────────────┘
```

> **Note**: Spring's Dependency Injection is an implementation of DIP!

---

## 5. Patterns Used by Spring

| Pattern | Where Spring Uses It |
|---------|---------------------|
| **Singleton** | Default bean scope |
| **Factory** | BeanFactory, ApplicationContext |
| **Proxy** | AOP, @Transactional |
| **Template Method** | JdbcTemplate, HibernateTemplate |
| **Observer** | ApplicationEvent, @EventListener |
| **Strategy** | HandlerMethodArgumentResolver |
| **Decorator** | BeanPostProcessor |

---

## 6. Common Interview Questions

### Q1: What is Observer Pattern?
**A:** Observer pattern defines a one-to-many dependency between objects. When one object (subject) changes state, all its dependents (observers) are notified automatically.

### Q2: What is Chain of Responsibility?
**A:** It's a behavioral pattern where a request is passed along a chain of handlers. Each handler decides whether to process the request or pass it to the next handler.

### Q3: What does SOLID stand for?
**A:**
- **S** - Single Responsibility Principle
- **O** - Open/Closed Principle
- **L** - Liskov Substitution Principle
- **I** - Interface Segregation Principle
- **D** - Dependency Inversion Principle

### Q4: How does Spring implement Dependency Inversion?
**A:** Through Dependency Injection. Instead of creating dependencies internally, Spring injects them from outside, allowing classes to depend on abstractions (interfaces) rather than concrete implementations.

---

## 7. Key Takeaways

📌 **Observer Pattern**: One-to-many notification (Spring Events)

📌 **Chain of Responsibility**: Sequential processing (Security Filters)

📌 **SRP**: One class, one responsibility

📌 **OCP**: Extend, don't modify

📌 **LSP**: Subtypes are substitutable

📌 **ISP**: Small, focused interfaces

📌 **DIP**: Depend on abstractions (Spring DI!)

📌 **Spring uses many patterns** internally

---

*Previous: [13. Spring Templates Overview](./13_Spring_Templates_Overview.md)*

*Next: [15. Spring Interview Questions](./15_Spring_Interview_Questions.md)*
