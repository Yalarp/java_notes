# Factory and Singleton Design Patterns in C#

## 📚 Introduction

Design patterns are reusable solutions to common software design problems. Factory Pattern creates objects without exposing creation logic. Singleton Pattern ensures only one instance exists.

---

## 🎯 Learning Objectives

- Understand Factory Pattern and its variations
- Implement thread-safe Singleton Pattern
- Know when to use each pattern

---

## 📖 Part 1: Factory Pattern

```
┌────────────────────────────────────────────────────────────────┐
│                     Factory Pattern                             │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem:                                                       │
│  • Client code creates objects directly with "new"             │
│  • Client knows about concrete classes                         │
│  • Hard to change implementations                              │
│                                                                 │
│  Solution:                                                      │
│  • Factory method encapsulates object creation                 │
│  • Client works with interfaces/abstractions                   │
│  • Easy to change implementations                              │
│                                                                 │
│  Client ──→ Factory ──→ Creates ──→ IProduct                   │
│            (static)      appropriate   ↑                        │
│                          concrete      │                        │
│                          class     implements                   │
│                                        │                        │
│                              ┌─────────┴─────────┐              │
│                              │                   │              │
│                         ProductA            ProductB            │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Factory Pattern Example

```csharp
using System;

// Step 1: Define interface (product abstraction)
public interface ILogger
{
    void Log(string message);
}

// Step 2: Create concrete implementations
public class FileLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[FILE] {DateTime.Now}: {message}");
        // Write to file...
    }
}

public class DatabaseLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[DB] {DateTime.Now}: {message}");
        // Write to database...
    }
}

public class ConsoleLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[CONSOLE] {DateTime.Now}: {message}");
    }
}

// Step 3: Create Factory class
public class LoggerFactory
{
    public static ILogger CreateLogger(string type)
    {
        return type.ToLower() switch
        {
            "file" => new FileLogger(),
            "database" or "db" => new DatabaseLogger(),
            "console" => new ConsoleLogger(),
            _ => throw new ArgumentException($"Unknown logger type: {type}")
        };
    }
    
    // Alternative: Create from configuration
    public static ILogger CreateLoggerFromConfig()
    {
        // Read from config file
        string type = "file"; // Would come from config
        return CreateLogger(type);
    }
}

// Step 4: Client uses factory
class Program
{
    static void Main()
    {
        // Client doesn't know about concrete classes
        ILogger logger = LoggerFactory.CreateLogger("file");
        logger.Log("Application started");
        
        // Easy to switch implementations
        logger = LoggerFactory.CreateLogger("database");
        logger.Log("User logged in");
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 5 | `interface ILogger` | Abstraction that factory returns |
| 37 | `static ILogger CreateLogger` | Factory method - static for easy access |
| 39-44 | `switch` expression | Creates appropriate concrete class |
| 54 | `LoggerFactory.CreateLogger` | Client uses factory, not "new" |

---

## 📖 Part 2: Singleton Pattern

```
┌────────────────────────────────────────────────────────────────┐
│                     Singleton Pattern                           │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem:                                                       │
│  • Need exactly ONE instance of a class                        │
│  • Multiple instances would cause problems                     │
│  • Example: Database connection, Config, Logging               │
│                                                                 │
│  Solution:                                                      │
│  • Private constructor (can't create outside)                  │
│  • Static property returns single instance                     │
│  • Lazy initialization (create when needed)                    │
│                                                                 │
│         ┌──────────────────┐                                   │
│         │    Singleton     │                                   │
│         ├──────────────────┤                                   │
│         │ - _instance      │ ← Single instance                 │
│         │ - Singleton()    │ ← Private constructor             │
│         │ + Instance       │ ← Public access point             │
│         └──────────────────┘                                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Singleton Pattern Examples

### Version 1: Basic (NOT Thread-Safe)

```csharp
// ❌ NOT thread-safe - don't use in multi-threaded applications
public class Singleton
{
    private static Singleton _instance;
    
    // Private constructor prevents external instantiation
    private Singleton() 
    {
        Console.WriteLine("Singleton instance created");
    }
    
    public static Singleton Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new Singleton();
            }
            return _instance;
        }
    }
    
    public void DoSomething()
    {
        Console.WriteLine("Singleton method called");
    }
}
```

### Version 2: Thread-Safe with Lock

```csharp
// ✅ Thread-safe using double-check locking
public class ThreadSafeSingleton
{
    private static ThreadSafeSingleton _instance;
    private static readonly object _lock = new object();
    
    private ThreadSafeSingleton() 
    {
        Console.WriteLine("Thread-safe Singleton created");
    }
    
    public static ThreadSafeSingleton Instance
    {
        get
        {
            // First check (no lock)
            if (_instance == null)
            {
                // Lock for thread safety
                lock (_lock)
                {
                    // Second check (inside lock)
                    if (_instance == null)
                    {
                        _instance = new ThreadSafeSingleton();
                    }
                }
            }
            return _instance;
        }
    }
}
```

### Version 3: Lazy<T> (Recommended)

```csharp
// ✅ BEST: Uses Lazy<T> - thread-safe and simple
public class LazySingleton
{
    // Lazy<T> handles thread-safety automatically
    private static readonly Lazy<LazySingleton> _lazy = 
        new Lazy<LazySingleton>(() => new LazySingleton());
    
    private LazySingleton() 
    {
        Console.WriteLine("Lazy Singleton created");
    }
    
    public static LazySingleton Instance => _lazy.Value;
    
    public void DoWork()
    {
        Console.WriteLine("Working...");
    }
}

// Usage
class Program
{
    static void Main()
    {
        // First access creates instance
        LazySingleton.Instance.DoWork();
        
        // Same instance returned
        LazySingleton s1 = LazySingleton.Instance;
        LazySingleton s2 = LazySingleton.Instance;
        
        Console.WriteLine(object.ReferenceEquals(s1, s2));  // True
    }
}
```

---

## 📊 Pattern Comparison

| Aspect | Factory | Singleton |
|--------|---------|-----------|
| **Purpose** | Create objects | Ensure one instance |
| **Instance count** | Multiple | Exactly one |
| **Best for** | Object creation logic | Shared resources |
| **Examples** | Logger factory, DB factory | Config, Connection pool |

---

## ⚠️ Singleton Considerations

| Consideration | Description |
|---------------|-------------|
| **Testability** | Hard to mock - consider DI instead |
| **Hidden dependencies** | Makes code less explicit |
| **Thread safety** | Must handle in multi-threaded apps |
| **Lifetime** | Lives for entire application |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Factory** - Encapsulates object creation logic
2. **Singleton** - Guarantees single instance
3. **Use Lazy<T>** - Best for thread-safe singleton
4. **Private constructor** - Core of singleton
5. **Return interface** - Factory should return abstractions

---

## 📝 Interview Questions

1. **When would you use Factory Pattern?**
   - Object creation is complex
   - Need to hide concrete implementations
   - Want to decouple client from concrete classes

2. **How do you make Singleton thread-safe?**
   - Double-check locking with lock
   - Lazy<T> (recommended)
   - Static initializer

3. **What's the problem with using Singleton?**
   - Hard to unit test (can't mock)
   - Hidden dependencies
   - Global state can cause issues

---

## 🔗 Next Topic
Next: [33_CSharp7_Out_Variables.md](./33_CSharp7_Out_Variables.md) - C# 7 Features
