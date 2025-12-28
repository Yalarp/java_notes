# Private Constructor and Singleton Pattern

## Overview
A private constructor prevents direct instantiation of a class from outside. It's commonly used to implement the Singleton design pattern, which ensures only one instance of a class exists.

---

## 1. Private Constructor

### What is a Private Constructor?
A constructor with `private` access modifier that cannot be called from outside the class.

### Purpose
1. Prevent direct object creation using `new`
2. Control how instances are created
3. Implement design patterns (Singleton, Factory)
4. Create utility classes with only static members

---

## 2. Basic Private Constructor Example

```csharp
class MyClass
{
    // Private constructor
    private MyClass()
    {
        Console.WriteLine("Private constructor called");
    }
    
    // Public static method to create instance
    public static MyClass CreateInstance()
    {
        return new MyClass();  // Can call private constructor from within class
    }
}

class Program
{
    static void Main()
    {
        // ❌ ERROR: Cannot access private constructor
        // MyClass obj1 = new MyClass();
        
        // ✅ OK: Use static factory method
        MyClass obj2 = MyClass.CreateInstance();
    }
}
```

---

## 3. Singleton Design Pattern

### What is Singleton?
A design pattern that ensures a class has only **one instance** and provides a global point of access to it.

### When to Use Singleton
- Database connections
- Configuration managers
- Logging services
- Thread pools
- Caching

---

## 4. Basic Singleton Implementation

```csharp
using System;

class Singleton
{
    // Static variable to hold the single instance
    private static Singleton _instance = null;
    
    // Private constructor prevents external instantiation
    private Singleton()
    {
        Console.WriteLine("Singleton instance created");
    }
    
    // Public static method to get the instance
    public static Singleton Instance()
    {
        // Lazy initialization - create only when first needed
        if (_instance == null)
        {
            _instance = new Singleton();
        }
        return _instance;
    }
    
    public void DoSomething()
    {
        Console.WriteLine("Singleton doing something");
    }
}

class Program
{
    static void Main()
    {
        // Get instance (creates on first call)
        Singleton s1 = Singleton.Instance();
        
        // Get instance again (returns same instance)
        Singleton s2 = Singleton.Instance();
        
        // Verify same instance
        Console.WriteLine($"Same instance? {s1 == s2}");  // True
        Console.WriteLine($"Same instance? {s1.Equals(s2)}");  // True
    }
}
```

### Output:
```
Singleton instance created
Same instance? True
Same instance? True
```

---

## 5. Memory Diagram

```
After Singleton.Instance() is called twice:

Stack                      Heap
┌────────────┐            ┌──────────────────┐
│    s1      │───────────>│  Singleton       │
│   (4000)   │       ┌───>│  instance data   │
├────────────┤       │    └──────────────────┘
│    s2      │───────┘
│   (4000)   │
└────────────┘

Both s1 and s2 point to the SAME object!

Static Memory:
┌─────────────────────┐
│ _instance = 4000    │  (Points to the single instance)
└─────────────────────┘
```

---

## 6. Singleton with Property

```csharp
class Singleton
{
    private static Singleton _instance = null;
    
    private Singleton()
    {
        Console.WriteLine("Instance created");
    }
    
    // Property instead of method
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
    
    public void ShowMessage()
    {
        Console.WriteLine("Hello from Singleton!");
    }
}

class Program
{
    static void Main()
    {
        // Access using property
        Singleton.Instance.ShowMessage();
    }
}
```

---

## 7. Thread-Safe Singleton

### Basic Singleton is NOT Thread-Safe!

```csharp
// Problem: Two threads might both see _instance as null
// and create two instances!

// Thread 1: if (_instance == null)  <- true
// Thread 2: if (_instance == null)  <- also true (before Thread 1 creates instance)
// Both create new instances!
```

### Solution 1: Lock

```csharp
class ThreadSafeSingleton
{
    private static ThreadSafeSingleton _instance = null;
    private static readonly object _lock = new object();
    
    private ThreadSafeSingleton() { }
    
    public static ThreadSafeSingleton Instance
    {
        get
        {
            lock (_lock)  // Only one thread can enter at a time
            {
                if (_instance == null)
                {
                    _instance = new ThreadSafeSingleton();
                }
                return _instance;
            }
        }
    }
}
```

### Solution 2: Double-Check Locking (Optimized)

```csharp
class ThreadSafeSingleton
{
    private static ThreadSafeSingleton _instance = null;
    private static readonly object _lock = new object();
    
    private ThreadSafeSingleton() { }
    
    public static ThreadSafeSingleton Instance
    {
        get
        {
            if (_instance == null)  // First check (no lock)
            {
                lock (_lock)
                {
                    if (_instance == null)  // Second check (with lock)
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

### Solution 3: Lazy<T> (Recommended)

```csharp
class ThreadSafeSingleton
{
    private static readonly Lazy<ThreadSafeSingleton> _lazy =
        new Lazy<ThreadSafeSingleton>(() => new ThreadSafeSingleton());
    
    private ThreadSafeSingleton() { }
    
    public static ThreadSafeSingleton Instance => _lazy.Value;
}
```

---

## 8. Factory Pattern with Private Constructor

```csharp
using System;

class MyClass
{
    private string name;
    private int id;
    private static MyClass _instance = null;
    
    // Private constructor
    private MyClass(string name, int id)
    {
        this.name = name;
        this.id = id;
    }
    
    // Factory method - creates NEW instance each time
    public static MyClass GetObject(string name, int id)
    {
        // Unlike Singleton, always creates new instance
        _instance = new MyClass(name, id);
        return _instance;
    }
    
    public string Display()
    {
        return $"{name} {id}";
    }
}

class Program
{
    static void Main()
    {
        MyClass obj1 = MyClass.GetObject("ACTS", 885);
        Console.WriteLine(obj1.Display());  // ACTS 885
        
        MyClass obj2 = MyClass.GetObject("VITA", 445);
        Console.WriteLine(obj2.Display());  // VITA 445
        
        // Different objects
        Console.WriteLine(obj1 == obj2);  // False
    }
}
```

---

## 9. Practical Singleton Example: Configuration Manager

```csharp
using System;
using System.Collections.Generic;

class ConfigurationManager
{
    private static ConfigurationManager _instance = null;
    private static readonly object _lock = new object();
    
    private Dictionary<string, string> _settings;
    
    private ConfigurationManager()
    {
        // Load configuration once
        _settings = new Dictionary<string, string>
        {
            {"DatabaseServer", "localhost"},
            {"DatabaseName", "MyDB"},
            {"Timeout", "30"},
            {"MaxConnections", "100"}
        };
        Console.WriteLine("Configuration loaded");
    }
    
    public static ConfigurationManager Instance
    {
        get
        {
            if (_instance == null)
            {
                lock (_lock)
                {
                    if (_instance == null)
                    {
                        _instance = new ConfigurationManager();
                    }
                }
            }
            return _instance;
        }
    }
    
    public string GetSetting(string key)
    {
        return _settings.ContainsKey(key) ? _settings[key] : null;
    }
    
    public void SetSetting(string key, string value)
    {
        _settings[key] = value;
    }
}

class Program
{
    static void Main()
    {
        // First access loads configuration
        var config1 = ConfigurationManager.Instance;
        Console.WriteLine($"Server: {config1.GetSetting("DatabaseServer")}");
        
        // Second access uses same instance
        var config2 = ConfigurationManager.Instance;
        Console.WriteLine($"Same instance? {config1 == config2}");  // True
        
        // Changes visible across all references
        config1.SetSetting("Timeout", "60");
        Console.WriteLine($"Timeout: {config2.GetSetting("Timeout")}");  // 60
    }
}
```

---

## 10. Comparison: Singleton vs Factory

| Aspect | Singleton | Factory |
|--------|-----------|---------|
| **Instances** | Only one | Multiple |
| **Purpose** | Share single instance | Control object creation |
| **Object Lifetime** | Entire application | As needed |
| **Use Case** | Config, Logger, Cache | Complex object creation |

---

## 11. Limiting Object Creation

```csharp
class LimitedInstances
{
    private static int _count = 0;
    private const int MAX_INSTANCES = 3;
    
    private int _id;
    
    private LimitedInstances()
    {
        _count++;
        _id = _count;
        Console.WriteLine($"Instance {_id} created");
    }
    
    public static LimitedInstances Create()
    {
        if (_count >= MAX_INSTANCES)
        {
            throw new InvalidOperationException(
                $"Cannot create more than {MAX_INSTANCES} instances");
        }
        return new LimitedInstances();
    }
    
    public void Display()
    {
        Console.WriteLine($"I am instance {_id}");
    }
}

class Program
{
    static void Main()
    {
        var obj1 = LimitedInstances.Create();  // OK
        var obj2 = LimitedInstances.Create();  // OK
        var obj3 = LimitedInstances.Create();  // OK
        
        try
        {
            var obj4 = LimitedInstances.Create();  // Exception!
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
```

---

## Key Points Summary

1. **Private constructor** prevents external instantiation
2. **Singleton** ensures only one instance exists
3. **Use static method/property** to access instance
4. **Lazy initialization** creates instance when first needed
5. **Thread safety** is important in multi-threaded applications
6. Use **`lock`** or **`Lazy<T>`** for thread safety
7. **Factory pattern** controls creation but allows multiple instances
8. **Don't overuse Singleton** - can make testing difficult

---

## Practice Questions

1. What is a private constructor used for?
2. Explain the Singleton pattern with an example.
3. Why is the basic Singleton implementation not thread-safe?
4. How does Lazy<T> help implement Singleton?
5. What's the difference between Singleton and Factory pattern?
6. When would you use a Singleton?
7. How can you limit the number of instances of a class?
