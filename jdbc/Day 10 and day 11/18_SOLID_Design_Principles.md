# SOLID Design Principles

## Table of Contents
1. [Introduction to SOLID](#1-introduction-to-solid)
2. [S - Single Responsibility Principle](#2-s---single-responsibility-principle)
3. [O - Open/Closed Principle](#3-o---openclosed-principle)
4. [L - Liskov Substitution Principle](#4-l---liskov-substitution-principle)
5. [I - Interface Segregation Principle](#5-i---interface-segregation-principle)
6. [D - Dependency Inversion Principle](#6-d---dependency-inversion-principle)
7. [SOLID in Spring Framework](#7-solid-in-spring-framework)
8. [Real-World Application](#8-real-world-application)
9. [Anti-Patterns and Code Smells](#9-anti-patterns-and-code-smells)
10. [Common Interview Questions](#10-common-interview-questions)
11. [Key Takeaways](#11-key-takeaways)

---

## 1. Introduction to SOLID

### What is SOLID?

**SOLID** is an acronym for five design principles intended to make object-oriented designs more understandable, flexible, and maintainable.

```
┌─────────────────────────────────────────────────────────────┐
│                    SOLID PRINCIPLES                          │
│                                                              │
│   S ─── Single Responsibility Principle                     │
│         "A class should have only ONE reason to change"     │
│                                                              │
│   O ─── Open/Closed Principle                                │
│         "Open for extension, closed for modification"       │
│                                                              │
│   L ─── Liskov Substitution Principle                        │
│         "Subtypes must be substitutable for base types"     │
│                                                              │
│   I ─── Interface Segregation Principle                      │
│         "Clients shouldn't depend on unused methods"        │
│                                                              │
│   D ─── Dependency Inversion Principle                       │
│         "Depend on abstractions, not concretions"           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Why SOLID Matters

| Benefit | Description |
|---------|-------------|
| **Maintainability** | Easier to modify and debug |
| **Flexibility** | Easy to extend functionality |
| **Testability** | Simpler unit testing |
| **Reusability** | Components can be reused |
| **Readability** | Code is easier to understand |

---

## 2. S - Single Responsibility Principle

### Definition

> **"A class should have only ONE reason to change."**

Each class should have only **one job** or **one responsibility**.

### Bad Example ❌

```java
/**
 * VIOLATION: This class has MULTIPLE responsibilities
 * - User data management
 * - Database operations
 * - Email sending
 * - Report generation
 * 
 * If email provider changes → modify this class
 * If database changes → modify this class
 * If report format changes → modify this class
 */
class User {
    private String name;
    private String email;
    
    // Responsibility 1: User data
    public void setName(String name) { this.name = name; }
    
    // Responsibility 2: Database operations
    public void saveToDatabase() {
        // Database connection code
        // SQL execution
    }
    
    // Responsibility 3: Email sending  
    public void sendWelcomeEmail() {
        // SMTP configuration
        // Email sending logic
    }
    
    // Responsibility 4: Report generation
    public void generatePDFReport() {
        // PDF generation code
    }
}
```

### Good Example ✅

```java
/**
 * CORRECT: Each class has ONE responsibility
 */

// Responsibility: User data only
class User {
    private String name;
    private String email;
    
    // Only getters/setters for user data
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}

// Responsibility: Database operations
class UserRepository {
    public void save(User user) {
        // Database operations
    }
    
    public User findById(int id) {
        // Find and return user
        return null;
    }
}

// Responsibility: Email sending
class EmailService {
    public void sendWelcomeEmail(User user) {
        // Email sending logic
    }
}

// Responsibility: Report generation
class ReportGenerator {
    public byte[] generatePDF(User user) {
        // PDF generation
        return null;
    }
}
```

### Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│       SINGLE RESPONSIBILITY PRINCIPLE                        │
│                                                              │
│   ❌ BAD: One class, many responsibilities                  │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  User                                                │   │
│   │  ├── saveToDatabase()   ← Database (Reason 1)       │   │
│   │  ├── sendWelcomeEmail() ← Email (Reason 2)          │   │
│   │  ├── generatePDF()      ← Reports (Reason 3)        │   │
│   │  └── validateData()     ← Validation (Reason 4)     │   │
│   └─────────────────────────────────────────────────────┘   │
│   4 REASONS TO CHANGE = VIOLATION                           │
│                                                              │
│   ✅ GOOD: Separate classes for each responsibility         │
│   ┌────────────┐  ┌────────────┐  ┌────────────┐           │
│   │    User    │  │UserRepo    │  │EmailService│           │
│   │ (data only)│  │save()      │  │send()      │           │
│   │            │  │find()      │  │            │           │
│   └────────────┘  └────────────┘  └────────────┘           │
│   1 REASON EACH = CORRECT                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. O - Open/Closed Principle

### Definition

> **"Software entities should be open for extension, but closed for modification."**

You should be able to **add new functionality** without **changing existing code**.

### Bad Example ❌

```java
/**
 * VIOLATION: Must modify class to add new discount type
 */
class DiscountCalculator {
    public double calculate(String customerType, double amount) {
        if (customerType.equals("regular")) {
            return amount * 0.1;
        } else if (customerType.equals("premium")) {
            return amount * 0.2;
        } else if (customerType.equals("vip")) {
            return amount * 0.3;
        }
        // What if we need "military" discount?
        // Must MODIFY this class! ❌
        
        return 0;
    }
}
```

### Good Example ✅

```java
/**
 * CORRECT: Extend with new classes, don't modify existing
 */

// Abstraction
interface DiscountStrategy {
    double calculateDiscount(double amount);
}

// Extensions - add new without modifying existing
class RegularDiscount implements DiscountStrategy {
    public double calculateDiscount(double amount) {
        return amount * 0.1;
    }
}

class PremiumDiscount implements DiscountStrategy {
    public double calculateDiscount(double amount) {
        return amount * 0.2;
    }
}

class VIPDiscount implements DiscountStrategy {
    public double calculateDiscount(double amount) {
        return amount * 0.3;
    }
}

// New discount? Just add new class!
class MilitaryDiscount implements DiscountStrategy {
    public double calculateDiscount(double amount) {
        return amount * 0.25;  // 25% military discount
    }
}

// Calculator is CLOSED for modification
class DiscountCalculator {
    public double calculate(DiscountStrategy strategy, double amount) {
        return strategy.calculateDiscount(amount);
    }
}

// Usage
DiscountCalculator calc = new DiscountCalculator();
calc.calculate(new MilitaryDiscount(), 100);  // No modification needed!
```

### Key Insight

```
┌─────────────────────────────────────────────────────────────┐
│              OPEN/CLOSED PRINCIPLE                           │
│                                                              │
│   CLOSED for modification:                                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  DiscountCalculator                                  │   │
│   │  • calculate(DiscountStrategy, amount)              │   │
│   │  • This code NEVER needs to change                  │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   OPEN for extension:                                        │
│   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│   │RegularDiscount│ │VIPDiscount   │ │MilitaryDiscount│    │
│   │(existing)     │ │(existing)    │ │(NEW!)          │    │
│   └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                              │
│   Add new functionality by ADDING classes, not changing!   │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. L - Liskov Substitution Principle

### Definition

> **"Subtypes must be substitutable for their base types."**

If class B extends class A, anywhere you use A, you should be able to use B without breaking the application.

### Bad Example ❌

```java
/**
 * VIOLATION: Square is NOT truly substitutable for Rectangle
 */
class Rectangle {
    protected int width;
    protected int height;
    
    public void setWidth(int w) { this.width = w; }
    public void setHeight(int h) { this.height = h; }
    
    public int getArea() { return width * height; }
}

class Square extends Rectangle {
    // Square forces both to be equal - BREAKS Rectangle contract!
    @Override
    public void setWidth(int w) {
        this.width = w;
        this.height = w;  // Unexpected! Changes height too!
    }
    
    @Override
    public void setHeight(int h) {
        this.width = h;   // Unexpected! Changes width too!
        this.height = h;
    }
}

// This test FAILS with Square!
void testRectangle(Rectangle r) {
    r.setWidth(5);
    r.setHeight(10);
    
    // For Rectangle: 5 * 10 = 50 ✓
    // For Square: 10 * 10 = 100 ✗ (width was changed!)
    assert r.getArea() == 50;  // FAILS with Square!
}
```

### Good Example ✅

```java
/**
 * CORRECT: Use interface, each shape calculates own area
 */
interface Shape {
    int getArea();
}

class Rectangle implements Shape {
    private int width;
    private int height;
    
    public Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
    
    public int getArea() { return width * height; }
}

class Square implements Shape {
    private int side;
    
    public Square(int side) {
        this.side = side;
    }
    
    public int getArea() { return side * side; }
}

// Both work correctly as Shape!
void printArea(Shape shape) {
    System.out.println("Area: " + shape.getArea());  // Works for both!
}
```

### LSP Test

```
┌─────────────────────────────────────────────────────────────┐
│              LISKOV SUBSTITUTION PRINCIPLE                   │
│                                                              │
│   THE TEST:                                                  │
│   If S is a subtype of T, then objects of type T may be    │
│   replaced with objects of type S without altering the      │
│   correctness of the program.                               │
│                                                              │
│   SIMPLE RULE:                                               │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  void process(Parent p) { ... }                      │   │
│   │                                                      │   │
│   │  process(new Parent());  ← Should work ✓            │   │
│   │  process(new Child());   ← Should work ✓            │   │
│   │                                                      │   │
│   │  If Child breaks process(), LSP is VIOLATED!        │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. I - Interface Segregation Principle

### Definition

> **"Clients should not be forced to depend on methods they don't use."**

Many small, specific interfaces are better than one large, general interface.

### Bad Example ❌

```java
/**
 * VIOLATION: Fat interface forces implementation of unused methods
 */
interface Worker {
    void work();
    void eat();
    void sleep();
    void code();
    void debug();
}

class HumanProgrammer implements Worker {
    public void work() { /* Works */ }
    public void eat() { /* Eats */ }
    public void sleep() { /* Sleeps */ }
    public void code() { /* Codes */ }
    public void debug() { /* Debugs */ }
}

class RobotWorker implements Worker {
    public void work() { /* Works */ }
    public void eat() { /* WHAT? Robots don't eat! */ }
    public void sleep() { /* WHAT? Robots don't sleep! */ }
    public void code() { /* Codes */ }
    public void debug() { /* Debugs */ }
}
// Robot is FORCED to implement eat() and sleep() - VIOLATION!
```

### Good Example ✅

```java
/**
 * CORRECT: Small, focused interfaces
 */

// Segregated interfaces
interface Workable {
    void work();
}

interface Eatable {
    void eat();
}

interface Sleepable {
    void sleep();
}

interface Programmer {
    void code();
    void debug();
}

// Human implements all relevant interfaces
class HumanProgrammer implements Workable, Eatable, Sleepable, Programmer {
    public void work() { System.out.println("Working..."); }
    public void eat() { System.out.println("Eating lunch..."); }
    public void sleep() { System.out.println("Sleeping..."); }
    public void code() { System.out.println("Writing code..."); }
    public void debug() { System.out.println("Debugging..."); }
}

// Robot only implements what it can do
class RobotProgrammer implements Workable, Programmer {
    public void work() { System.out.println("Robot working 24/7..."); }
    public void code() { System.out.println("Robot writing code..."); }
    public void debug() { System.out.println("Robot debugging..."); }
    // No eat() or sleep() - not forced!
}
```

### Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│              INTERFACE SEGREGATION PRINCIPLE                 │
│                                                              │
│   ❌ BAD: Fat interface                                      │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  interface Worker                                    │   │
│   │  ├── work()                                         │   │
│   │  ├── eat()    ← Robot can't!                        │   │
│   │  ├── sleep()  ← Robot can't!                        │   │
│   │  ├── code()                                         │   │
│   │  └── debug()                                        │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   ✅ GOOD: Segregated interfaces                            │
│   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│   │Workable  │ │Eatable   │ │Sleepable │ │Programmer│      │
│   │work()    │ │eat()     │ │sleep()   │ │code()    │      │
│   │          │ │          │ │          │ │debug()   │      │
│   └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│                                                              │
│   Human: implements all 4                                    │
│   Robot: implements Workable + Programmer only              │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. D - Dependency Inversion Principle

### Definition

> **"High-level modules should not depend on low-level modules. Both should depend on abstractions."**
> **"Abstractions should not depend on details. Details should depend on abstractions."**

In simpler terms: **Depend on interfaces, not concrete classes.**

### Bad Example ❌

```java
/**
 * VIOLATION: High-level class depends on low-level class directly
 */
class MySQLDatabase {
    public void save(String data) {
        System.out.println("Saving to MySQL: " + data);
    }
}

class OrderService {
    // TIGHT COUPLING: Depends on concrete MySQLDatabase
    private MySQLDatabase database = new MySQLDatabase();
    
    public void createOrder(String order) {
        // Business logic...
        database.save(order);  // What if we want PostgreSQL?
    }
}

// To switch to PostgreSQL:
// 1. Create PostgreSQLDatabase class
// 2. MODIFY OrderService to use PostgreSQL ← PROBLEM!
```

### Good Example ✅

```java
/**
 * CORRECT: Both depend on abstraction
 */

// Abstraction (Interface)
interface Database {
    void save(String data);
}

// Low-level module depends on abstraction
class MySQLDatabase implements Database {
    public void save(String data) {
        System.out.println("Saving to MySQL: " + data);
    }
}

class PostgreSQLDatabase implements Database {
    public void save(String data) {
        System.out.println("Saving to PostgreSQL: " + data);
    }
}

class MongoDatabase implements Database {
    public void save(String data) {
        System.out.println("Saving to MongoDB: " + data);
    }
}

// High-level module depends on abstraction
class OrderService {
    private Database database;  // Depends on interface!
    
    // Dependency injected from outside (DI)
    public OrderService(Database database) {
        this.database = database;
    }
    
    public void createOrder(String order) {
        // Business logic...
        database.save(order);
    }
}

// Usage - can swap implementations easily!
OrderService mysqlService = new OrderService(new MySQLDatabase());
OrderService mongoService = new OrderService(new MongoDatabase());
```

### DIP with Spring

```java
// Spring implements DIP through Dependency Injection
@Service
public class OrderService {
    
    private final Database database;  // Depends on interface
    
    @Autowired  // Spring injects the implementation
    public OrderService(Database database) {
        this.database = database;
    }
}

@Repository("mysql")
class MySQLDatabase implements Database { ... }

@Repository("mongo")  
class MongoDatabase implements Database { ... }

// Spring configuration decides which implementation
@Configuration
class AppConfig {
    @Bean
    public Database database() {
        return new MongoDatabase();  // Easy to switch!
    }
}
```

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│              DEPENDENCY INVERSION PRINCIPLE                  │
│                                                              │
│   ❌ BAD: High-level depends on low-level                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  OrderService ──────────────► MySQLDatabase         │   │
│   │  (High-level)    (direct)     (Low-level)           │   │
│   │                                                      │   │
│   │  Change database = Change OrderService ❌            │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   ✅ GOOD: Both depend on abstraction                       │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  OrderService ──────────► <<interface>>             │   │
│   │  (High-level)              Database                 │   │
│   │                               △                     │   │
│   │                    ┌──────────┼──────────┐          │   │
│   │                    │          │          │          │   │
│   │                 MySQL      Postgres   MongoDB       │   │
│   │                (Low-level implementations)          │   │
│   │                                                      │   │
│   │  Change database = Just swap implementation ✓       │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   SPRING DI implements this principle!                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. SOLID in Spring Framework

### How Spring Implements SOLID

| Principle | Spring Implementation |
|-----------|----------------------|
| **SRP** | @Controller, @Service, @Repository separation |
| **OCP** | Plugins, Interceptors, Listeners for extension |
| **LSP** | Interface-based programming everywhere |
| **ISP** | Fine-grained interfaces (CrudRepository, etc.) |
| **DIP** | Dependency Injection (@Autowired) |

### Spring Example

```java
// SRP: Each layer has single responsibility
@Controller
public class UserController {
    @Autowired
    private UserService userService;  // DIP: Depends on interface
}

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userRepo;  // DIP
}

@Repository
public class UserRepositoryImpl implements UserRepository {
    // Database access only
}

// OCP: Add new behavior without modification
@Component
public class AuditListener {
    @EventListener
    public void onUserCreated(UserCreatedEvent event) {
        // Extension without modifying UserService
    }
}
```

---

## 8. Real-World Application

### Complete Example: Payment System

```java
// ISP: Small, focused interfaces
interface PaymentProcessor {
    void processPayment(double amount);
}

interface Refundable {
    void processRefund(double amount);
}

// OCP & DIP: Easy to add new payment methods
class CreditCardPayment implements PaymentProcessor, Refundable {
    public void processPayment(double amount) {
        System.out.println("Credit card payment: $" + amount);
    }
    public void processRefund(double amount) {
        System.out.println("Credit card refund: $" + amount);
    }
}

class UPIPayment implements PaymentProcessor {
    public void processPayment(double amount) {
        System.out.println("UPI payment: ₹" + amount);
    }
    // UPI doesn't support refund easily - not forced to implement!
}

// SRP: OrderService only handles order logic
@Service
class OrderService {
    private final PaymentProcessor paymentProcessor;  // DIP
    
    @Autowired
    public OrderService(PaymentProcessor paymentProcessor) {
        this.paymentProcessor = paymentProcessor;
    }
    
    public void checkout(double amount) {
        // Order logic only
        paymentProcessor.processPayment(amount);
    }
}
```

---

## 9. Anti-Patterns and Code Smells

### Signs of SOLID Violations

| Violation | Code Smell |
|-----------|-----------|
| SRP | God classes with 1000+ lines |
| OCP | Long switch/if-else chains |
| LSP | Empty method implementations |
| ISP | Many `throw new UnsupportedOperationException()` |
| DIP | `new` keyword in business logic |

### Quick Check Questions

```
┌─────────────────────────────────────────────────────────────┐
│              SOLID VIOLATION DETECTOR                        │
│                                                              │
│  Ask yourself:                                               │
│                                                              │
│  SRP: "How many reasons does this class have to change?"   │
│       If > 1 → Consider splitting                           │
│                                                              │
│  OCP: "Do I modify existing code to add features?"         │
│       If yes → Consider abstraction                         │
│                                                              │
│  LSP: "Can I use child class everywhere parent is used?"   │
│       If no → Reconsider inheritance                        │
│                                                              │
│  ISP: "Do implementing classes use ALL interface methods?" │
│       If no → Split the interface                           │
│                                                              │
│  DIP: "Does this class create its dependencies?"            │
│       If yes → Inject them instead                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. Common Interview Questions

### Q1: What does SOLID stand for?
**A:**
- **S** - Single Responsibility Principle
- **O** - Open/Closed Principle
- **L** - Liskov Substitution Principle
- **I** - Interface Segregation Principle
- **D** - Dependency Inversion Principle

### Q2: How does Spring implement DIP?
**A:** Through Dependency Injection. Components depend on interfaces, and Spring injects concrete implementations at runtime via @Autowired.

### Q3: What is the difference between SRP and ISP?
**A:**
- SRP: One class = one responsibility
- ISP: One interface = one role/purpose
- SRP is about classes, ISP is about interfaces

### Q4: Give an example of OCP in real code
**A:** Strategy pattern: Instead of if-else for payment types, create PaymentStrategy interface. New payment methods = new class, no modification to existing code.

### Q5: Why is LSP important?
**A:** LSP ensures that inheritance is used correctly. If violated, polymorphism breaks - code expecting parent behavior fails with child classes.

### Q6: What is a "Fat Interface" and how to fix it?
**A:** An interface with too many methods, forcing classes to implement unused methods. Fix: Split into smaller, focused interfaces (ISP).

---

## 11. Key Takeaways

📌 **S** - One class = One job/responsibility

📌 **O** - Add new features by adding code, not changing it

📌 **L** - Child classes must work wherever parent works

📌 **I** - Many small interfaces > One big interface

📌 **D** - Depend on interfaces, not concrete classes

📌 **Spring DI** implements Dependency Inversion

📌 **@Autowired** = DIP in action

📌 Violations lead to **rigid, fragile** code

📌 SOLID = **maintainable, flexible** code

📌 Learn the **principle**, not just the definition

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│                  SOLID QUICK REFERENCE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  S: One class = One reason to change                        │
│     ├─ BAD: User class with save, email, report            │
│     └─ GOOD: User, UserRepo, EmailService, ReportGen       │
│                                                              │
│  O: Open for extension, closed for modification             │
│     ├─ BAD: if-else for each discount type                 │
│     └─ GOOD: DiscountStrategy interface + implementations  │
│                                                              │
│  L: Subtypes must be substitutable                          │
│     ├─ BAD: Square extends Rectangle (breaks setWidth)     │
│     └─ GOOD: Both implement Shape interface                │
│                                                              │
│  I: Small focused interfaces                                │
│     ├─ BAD: Worker with work(), eat(), sleep() - Robot?    │
│     └─ GOOD: Workable, Eatable, Sleepable separate         │
│                                                              │
│  D: Depend on abstractions                                  │
│     ├─ BAD: OrderService creates new MySQLDatabase()       │
│     └─ GOOD: OrderService receives Database interface      │
│                                                              │
│  SPRING = SOLID in practice!                                │
│  @Controller/@Service/@Repository = SRP                     │
│  @Autowired = DIP                                           │
│  Interface-based programming = LSP, DIP                     │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [17. Behavioral Design Patterns](./17_Behavioral_Design_Patterns.md)*

*Next: [19. Spring Interview Questions](./19_Spring_Interview_Questions.md)*
