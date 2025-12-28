# Composition Over Inheritance in C#

## 📚 Introduction

"Favor composition over inheritance" is a fundamental principle in object-oriented design. It means combining simple objects to achieve complex behavior rather than creating deep inheritance hierarchies.

---

## 🎯 Learning Objectives

- Understand IS-A vs HAS-A relationships
- Know when to use composition vs inheritance
- Implement composition patterns in C#

---

## 📖 Theory: Composition vs Inheritance

```
┌────────────────────────────────────────────────────────────────┐
│            Composition vs Inheritance                           │
├───────────────────────────┬────────────────────────────────────┤
│       INHERITANCE         │         COMPOSITION                │
│       (IS-A)              │         (HAS-A)                    │
├───────────────────────────┼────────────────────────────────────┤
│ Dog IS-A Animal           │ Car HAS-A Engine                   │
│ class Dog : Animal        │ class Car { Engine _engine; }      │
├───────────────────────────┼────────────────────────────────────┤
│ Tight coupling            │ Loose coupling                     │
│ Compile-time binding      │ Runtime flexibility                │
│ Single inheritance only   │ Multiple components possible       │
│ Base class changes break  │ Components can be swapped          │
├───────────────────────────┼────────────────────────────────────┤
│ When to use:              │ When to use:                       │
│ • True IS-A relationship  │ • HAS-A relationship              │
│ • Need to override        │ • Need flexibility                 │
│ • Polymorphism required   │ • Multiple behaviors              │
└───────────────────────────┴────────────────────────────────────┘
```

---

## ❌ Code Example 1: Inheritance Problems

```csharp
// ❌ Problematic inheritance hierarchy
public class Bird
{
    public virtual void Fly() => Console.WriteLine("Flying...");
    public virtual void Eat() => Console.WriteLine("Eating...");
}

public class Penguin : Bird
{
    // ❌ Problem! Penguins can't fly!
    public override void Fly() 
    {
        throw new NotImplementedException("Penguins can't fly!");
    }
}

// Usage breaks Liskov Substitution Principle
Bird bird = new Penguin();
bird.Fly();  // Throws exception! Unexpected!
```

---

## ✅ Code Example 2: Composition Solution

```csharp
// ✅ Define behaviors as interfaces
public interface IFlyable
{
    void Fly();
}

public interface ISwimmable
{
    void Swim();
}

// Implementations of behaviors
public class FlyingBehavior : IFlyable
{
    public void Fly() => Console.WriteLine("Flying through the sky!");
}

public class SwimmingBehavior : ISwimmable
{
    public void Swim() => Console.WriteLine("Swimming in water!");
}

// ✅ Compose behaviors into classes
public class Sparrow
{
    private readonly IFlyable _flyBehavior;
    
    public Sparrow()
    {
        _flyBehavior = new FlyingBehavior();  // HAS-A flying behavior
    }
    
    public void Fly() => _flyBehavior.Fly();
}

public class Penguin
{
    private readonly ISwimmable _swimBehavior;
    
    public Penguin()
    {
        _swimBehavior = new SwimmingBehavior();  // HAS-A swimming behavior
    }
    
    public void Swim() => _swimBehavior.Swim();
    // No Fly method - penguins don't fly!
}

public class Duck
{
    private readonly IFlyable _flyBehavior;
    private readonly ISwimmable _swimBehavior;
    
    public Duck()
    {
        _flyBehavior = new FlyingBehavior();     // HAS-A flying
        _swimBehavior = new SwimmingBehavior();  // HAS-A swimming
    }
    
    public void Fly() => _flyBehavior.Fly();
    public void Swim() => _swimBehavior.Swim();
}
```

---

## 💻 Code Example 3: Invoice with Composition

```csharp
// Using composition for Invoice (as seen in SRP example)
public class Invoice
{
    private readonly ILogger _logger;       // HAS-A logger
    private readonly MailSender _mail;      // HAS-A mail sender
    
    public long Amount { get; set; }
    public DateTime Date { get; set; }
    
    // Dependencies injected via constructor
    public Invoice(ILogger logger, MailSender mail)
    {
        _logger = logger;
        _mail = mail;
    }
    
    public void Process()
    {
        _logger.Info("Processing invoice...");   // Delegates to composed object
        // Invoice-specific logic
        _mail.SendEmail();                       // Delegates to composed object
    }
}

// vs Inheritance (less flexible)
// public class Invoice : LoggingBase, EmailBase  // Can't do multiple inheritance!
```

### Why Composition is Better Here:

```
┌────────────────────────────────────────────────────────────────┐
│          Benefits of Composition in Invoice                    │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Single Inheritance Limitation                              │
│     • C# allows only ONE base class                            │
│     • With composition: unlimited components!                  │
│                                                                 │
│  2. Runtime Flexibility                                         │
│     • Can inject different logger implementations              │
│     • FileLogger, DatabaseLogger, ConsoleLogger...             │
│                                                                 │
│  3. Testability                                                 │
│     • Inject mock logger for testing                           │
│     • No file system or email required                         │
│                                                                 │
│  4. Loose Coupling                                              │
│     • Invoice doesn't know HOW to log                          │
│     • Just knows it HAS something that logs                    │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 When to Use Each

| Use Inheritance When | Use Composition When |
|---------------------|---------------------|
| True IS-A relationship | HAS-A or USES-A relationship |
| Need polymorphism | Need flexibility |
| Overriding behavior | Combining behaviors |
| Single clear hierarchy | Multiple capabilities |
| Framework expects it | Testability is important |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Inheritance = IS-A** → Dog IS-A Animal
2. **Composition = HAS-A** → Car HAS-A Engine
3. **Favor composition** for flexibility and testability
4. **Use interfaces** to define behaviors
5. **Inject dependencies** for loose coupling

---

## 📝 Interview Questions

1. **When would you use inheritance over composition?**
   - True IS-A relationship exists
   - Need polymorphism in system
   - Framework requires it (e.g., Form : Window)

2. **What problems does composition solve?**
   - Avoids single inheritance limitation
   - Allows runtime behavior changes
   - Better testability with dependency injection

---

## 🔗 Next Topic
Next: [32_Design_Patterns_Factory.md](./32_Design_Patterns_Factory.md) - Factory and Singleton
