# Interfaces - C# 8+ Features

## 📚 Introduction

C# 8.0 introduced **default interface methods** (also called default interface implementations), allowing interfaces to provide default implementations. This was a significant change from traditional interfaces.

---

## 🎯 Learning Objectives

- Understand default interface implementations
- Learn when to use interface defaults vs abstract classes
- Master diamond inheritance handling
- Explore static interface members

---

## 🔍 New Interface Features in C# 8+

```
┌─────────────────────────────────────────────────────────────────┐
│               C# 8+ INTERFACE FEATURES                           │
├─────────────────────────────────────────────────────────────────┤
│ ✓ Default method implementations                                │
│ ✓ Static members (methods, properties, fields)                  │
│ ✓ Private methods (for code reuse within interface)            │
│ ✓ Protected members                                              │
│ ✓ Virtual members (can be overridden)                           │
│ ✓ Sealed members (prevent further override)                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Default Interface Method

```csharp
using System;

interface ILogger
{
    // Traditional interface method - must be implemented
    void Log(string message);
    
    // C# 8+ Default implementation
    void LogError(string message)
    {
        Console.WriteLine($"[ERROR] {DateTime.Now}: {message}");
    }
    
    void LogWarning(string message)
    {
        Console.WriteLine($"[WARNING] {DateTime.Now}: {message}");
    }
}

// Class only needs to implement Log()
class ConsoleLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[LOG] {message}");
    }
    
    // LogError and LogWarning use defaults
}

// Class can override default implementations
class FileLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[FILE] {message}");
    }
    
    // Override the default
    public void LogError(string message)
    {
        Console.WriteLine($"[FILE ERROR] {message}");  // Custom implementation
    }
}

class Program
{
    static void Main()
    {
        ILogger logger1 = new ConsoleLogger();
        logger1.Log("Test");          // [LOG] Test
        logger1.LogError("Oops");     // [ERROR] ... (default)
        
        ILogger logger2 = new FileLogger();
        logger2.Log("Test");          // [FILE] Test
        logger2.LogError("Oops");     // [FILE ERROR] Oops (overridden)
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 7 | `void Log(string message);` | Traditional - must implement |
| 10-13 | `void LogError(...)` | Default implementation - optional to override |
| 22 | `class ConsoleLogger : ILogger` | Only implements Log() |
| 40-43 | `public void LogError(...)` | FileLogger overrides default |

---

### Example 2: Accessing Default Methods

```csharp
using System;

interface IDemo
{
    void Required();
    
    void DefaultMethod()
    {
        Console.WriteLine("Default implementation");
    }
}

class MyClass : IDemo
{
    public void Required() { Console.WriteLine("Required"); }
    // DefaultMethod uses default
}

class Program
{
    static void Main()
    {
        MyClass obj = new MyClass();
        obj.Required();    // OK
        
        // obj.DefaultMethod();  // ERROR! Not accessible through class
        
        // Must use interface reference
        IDemo demo = obj;
        demo.DefaultMethod();  // OK - "Default implementation"
        
        // Or cast
        ((IDemo)obj).DefaultMethod();  // OK
    }
}
```

**Important**: Default interface methods are accessible ONLY through interface reference, not class reference!

---

### Example 3: Static Interface Members

```csharp
using System;

interface ICalculator
{
    // Static field (C# 8+)
    static int Precision = 2;
    
    // Static method
    static double Add(double a, double b)
    {
        return Math.Round(a + b, Precision);
    }
    
    // Instance method
    double Calculate(double input);
}

class ScientificCalculator : ICalculator
{
    public double Calculate(double input)
    {
        return Math.Pow(input, 2);
    }
}

class Program
{
    static void Main()
    {
        // Access static members through interface name
        Console.WriteLine(ICalculator.Add(1.234, 5.678));  // 6.91
        Console.WriteLine(ICalculator.Precision);          // 2
        
        // Change static field
        ICalculator.Precision = 3;
        Console.WriteLine(ICalculator.Add(1.234, 5.678));  // 6.912
    }
}
```

---

### Example 4: Private Methods in Interfaces

```csharp
using System;

interface IFormattable
{
    void Display(string value);
    
    // Private helper - used by default implementations
    private string FormatValue(string value)
    {
        return $"[{DateTime.Now:HH:mm:ss}] {value}";
    }
    
    void DisplayFormatted(string value)
    {
        Console.WriteLine(FormatValue(value));  // Uses private helper
    }
}

class Reporter : IFormattable
{
    public void Display(string value)
    {
        Console.WriteLine(value);
    }
}

class Program
{
    static void Main()
    {
        IFormattable reporter = new Reporter();
        reporter.Display("Hello");           // Hello
        reporter.DisplayFormatted("Hello");  // [14:30:45] Hello
    }
}
```

---

### Example 5: Diamond Inheritance Problem

```csharp
using System;

interface IA
{
    void Method()
    {
        Console.WriteLine("IA.Method");
    }
}

interface IB : IA
{
    // Override with new default
    new void Method()
    {
        Console.WriteLine("IB.Method");
    }
}

interface IC : IA
{
    // Another override
    new void Method()
    {
        Console.WriteLine("IC.Method");
    }
}

// Diamond: D inherits from both IB and IC
class D : IB, IC
{
    // Must explicitly choose which implementation
    // Or provide own implementation
    public void Method()
    {
        Console.WriteLine("D.Method");
    }
}

class Program
{
    static void Main()
    {
        D d = new D();
        d.Method();           // D.Method
        
        ((IA)d).Method();     // D.Method
        ((IB)d).Method();     // D.Method
        ((IC)d).Method();     // D.Method
    }
}
```

---

### Example 6: Virtual and Sealed in Interfaces

```csharp
using System;

interface IBase
{
    // Virtual - can be overridden in derived interfaces
    virtual void VirtualMethod()
    {
        Console.WriteLine("IBase.VirtualMethod");
    }
    
    // Sealed - cannot be overridden
    sealed void SealedMethod()
    {
        Console.WriteLine("IBase.SealedMethod");
    }
}

interface IDerived : IBase
{
    // Override the virtual method
    void IBase.VirtualMethod()
    {
        Console.WriteLine("IDerived.VirtualMethod");
    }
    
    // Cannot override SealedMethod!
    // void IBase.SealedMethod() { }  // ERROR
}

class MyClass : IDerived
{
    // Can override again
    public void VirtualMethod()
    {
        Console.WriteLine("MyClass.VirtualMethod");
    }
}

class Program
{
    static void Main()
    {
        IBase obj = new MyClass();
        obj.VirtualMethod();  // MyClass.VirtualMethod
        obj.SealedMethod();   // IBase.SealedMethod (sealed!)
    }
}
```

---

## 📊 When to Use Default Interface Methods

| Use Default Interface Methods | Use Abstract Class |
|-------------------------------|-------------------|
| Adding methods to existing interface | Need constructors |
| Share code across unrelated types | Need fields/state |
| API versioning without breaking | Need single implementation |
| Multiple inheritance needed | Related types hierarchy |

---

## ⚡ Key Points to Remember

1. **Default methods** require interface reference to access
2. **Static members** accessed via `InterfaceName.Member`
3. **Private methods** enable code reuse within interface
4. **Diamond problem** resolved by explicit implementation
5. **Target framework** must be .NET Core 3.0+ or .NET 5+

---

## ❌ Common Mistakes

### Mistake 1: Accessing default method through class
```csharp
MyClass obj = new MyClass();
obj.DefaultMethod();  // ERROR!
((IMyInterface)obj).DefaultMethod();  // CORRECT
```

### Mistake 2: Forgetting target framework
```csharp
// Requires <TargetFramework>net5.0</TargetFramework> or later
// Won't work with .NET Framework 4.x
```

---

## 📝 Practice Questions

1. **Can a class access default interface method through `this`?**
<details>
<summary>Answer</summary>
Only if cast: `((IInterface)this).DefaultMethod();`
</details>

2. **What happens if two interfaces have same default method?**
<details>
<summary>Answer</summary>
Class must provide own implementation or explicitly choose one.
</details>

---

## 🔗 Related Topics
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - Basic interfaces
- [03_Abstract_Classes_Methods.md](03_Abstract_Classes_Methods.md) - Abstract class alternative
