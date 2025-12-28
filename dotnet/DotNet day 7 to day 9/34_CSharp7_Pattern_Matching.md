# C# 7-8 Pattern Matching

## 📚 Introduction

Pattern matching enhances conditional logic by allowing you to test values against patterns and extract information from them. It's more expressive and concise than traditional if-else chains.

---

## 🎯 Learning Objectives

- Master type patterns and when patterns
- Use switch expressions (C# 8)
- Understand property and positional patterns

---

## 📖 Pattern Types Overview

```
┌────────────────────────────────────────────────────────────────┐
│                    Pattern Matching Types                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  TYPE PATTERN (C# 7)                                           │
│  if (obj is string s)    // Test type AND extract variable     │
│                                                                 │
│  CONSTANT PATTERN                                               │
│  if (obj is null)        // Test against constant              │
│  if (obj is 42)          // Test against value                 │
│                                                                 │
│  SWITCH EXPRESSION (C# 8)                                      │
│  var result = status switch                                    │
│  {                                                              │
│      200 => "OK",                                              │
│      404 => "Not Found",                                       │
│      _ => "Unknown"                                            │
│  };                                                             │
│                                                                 │
│  PROPERTY PATTERN (C# 8)                                       │
│  if (person is { Age: > 18, Name: "John" })                    │
│                                                                 │
│  POSITIONAL PATTERN (C# 8)                                     │
│  if (point is (0, 0))    // For deconstructible types         │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 1: Type Pattern (C# 7)

```csharp
using System;

class Program
{
    static void Main()
    {
        object[] items = { "Hello", 42, 3.14, null, new Person("John", 30) };
        
        foreach (object item in items)
        {
            // ✅ Type pattern: is TYPE VARIABLE
            if (item is string text)
            {
                Console.WriteLine($"String: '{text}' (Length: {text.Length})");
            }
            else if (item is int number)
            {
                Console.WriteLine($"Integer: {number * 2}");
            }
            else if (item is double d)
            {
                Console.WriteLine($"Double: {d:F2}");
            }
            else if (item is Person p)
            {
                Console.WriteLine($"Person: {p.Name}, Age: {p.Age}");
            }
            else if (item is null)
            {
                Console.WriteLine("Null value");
            }
        }
    }
}

class Person
{
    public string Name { get; }
    public int Age { get; }
    
    public Person(string name, int age) => (Name, Age) = (name, age);
}
```

### Before vs After Pattern Matching:

```csharp
// ❌ BEFORE C# 7
if (obj is string)
{
    string s = (string)obj;  // Cast required
    Console.WriteLine(s.ToUpper());
}

// ✅ C# 7+
if (obj is string s)  // Test and assign in one step
{
    Console.WriteLine(s.ToUpper());
}
```

---

## 💻 Code Example 2: Switch Expressions (C# 8)

```csharp
using System;

class Program
{
    static void Main()
    {
        // ✅ Switch expression (expression-bodied)
        int statusCode = 404;
        
        string message = statusCode switch
        {
            200 => "OK",
            201 => "Created",
            204 => "No Content",
            400 => "Bad Request",
            401 => "Unauthorized",
            403 => "Forbidden",
            404 => "Not Found",
            500 => "Internal Server Error",
            _ => "Unknown Status"  // Default case (discard pattern)
        };
        
        Console.WriteLine($"Status {statusCode}: {message}");
        
        // ✅ With when clauses
        int score = 85;
        string grade = score switch
        {
            >= 90 => "A",
            >= 80 => "B",
            >= 70 => "C",
            >= 60 => "D",
            _ => "F"
        };
        
        Console.WriteLine($"Score {score}: Grade {grade}");
        
        // ✅ Type patterns in switch
        object value = "Hello World";
        string description = value switch
        {
            string s when s.Length > 10 => $"Long string: {s}",
            string s => $"Short string: {s}",
            int i when i > 0 => $"Positive: {i}",
            int i => $"Non-positive: {i}",
            null => "Null value",
            _ => $"Unknown type: {value.GetType()}"
        };
        
        Console.WriteLine(description);
    }
}
```

### Switch Statement vs Expression:

```csharp
// Switch Statement (traditional)
string GetDay(int day)
{
    switch (day)
    {
        case 1: return "Monday";
        case 2: return "Tuesday";
        // ... more cases
        default: return "Unknown";
    }
}

// Switch Expression (C# 8) - More concise!
string GetDay(int day) => day switch
{
    1 => "Monday",
    2 => "Tuesday",
    // ... more cases
    _ => "Unknown"
};
```

---

## 💻 Code Example 3: Property Patterns (C# 8)

```csharp
using System;

class Employee
{
    public string Name { get; init; }
    public string Department { get; init; }
    public decimal Salary { get; init; }
    public bool IsManager { get; init; }
}

class Program
{
    static void Main()
    {
        var employee = new Employee
        {
            Name = "John",
            Department = "IT",
            Salary = 85000,
            IsManager = true
        };
        
        // ✅ Property pattern matching
        string description = employee switch
        {
            // Match on property values
            { Department: "IT", IsManager: true } 
                => "IT Manager",
            
            { Department: "IT", Salary: > 80000 } 
                => "Senior IT Employee",
            
            { Department: "IT" } 
                => "IT Employee",
            
            { IsManager: true } 
                => "Manager",
            
            { Salary: > 100000 } 
                => "Executive",
            
            _ => "Regular Employee"
        };
        
        Console.WriteLine($"{employee.Name}: {description}");
        
        // ✅ Nested property pattern
        var order = new Order
        {
            Customer = new Customer { Name = "Alice", IsPremium = true },
            Total = 500
        };
        
        decimal discount = order switch
        {
            { Customer: { IsPremium: true }, Total: > 100 } => 0.2m,
            { Customer: { IsPremium: true } } => 0.1m,
            { Total: > 500 } => 0.05m,
            _ => 0m
        };
        
        Console.WriteLine($"Discount: {discount:P0}");
    }
}

class Order
{
    public Customer Customer { get; init; }
    public decimal Total { get; init; }
}

class Customer
{
    public string Name { get; init; }
    public bool IsPremium { get; init; }
}
```

---

## 💻 Code Example 4: Positional Patterns

```csharp
using System;

// For positional patterns, type must have a Deconstruct method
class Point
{
    public int X { get; }
    public int Y { get; }
    
    public Point(int x, int y) => (X, Y) = (x, y);
    
    // Required for positional patterns
    public void Deconstruct(out int x, out int y) => (x, y) = (X, Y);
}

class Program
{
    static void Main()
    {
        var points = new Point[]
        {
            new Point(0, 0),
            new Point(5, 0),
            new Point(0, 5),
            new Point(3, 4),
            new Point(-1, -1)
        };
        
        foreach (var point in points)
        {
            // ✅ Positional pattern matching
            string location = point switch
            {
                (0, 0) => "Origin",
                (_, 0) => "On X-axis",        // _ matches any value
                (0, _) => "On Y-axis",
                (var x, var y) when x == y => "On diagonal (x=y)",
                (var x, var y) when x > 0 && y > 0 => "Quadrant I",
                (var x, var y) when x < 0 && y > 0 => "Quadrant II",
                (var x, var y) when x < 0 && y < 0 => "Quadrant III",
                _ => "Quadrant IV"
            };
            
            Console.WriteLine($"({point.X}, {point.Y}): {location}");
        }
    }
}
```

---

## 📊 Pattern Types Summary

| Pattern | Syntax | Use Case |
|---------|--------|----------|
| **Type** | `obj is Type t` | Check type, extract variable |
| **Constant** | `x is 42` | Match exact value |
| **Relational** | `x is > 0` | Compare with operators |
| **Property** | `{ Prop: value }` | Match object properties |
| **Positional** | `(x, y)` | Match deconstructed values |
| **Discard** | `_` | Match anything |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **is + variable** - Pattern match and assign in one step
2. **switch expression** - Concise alternative to switch statement
3. **Property patterns** - Match based on property values
4. **when clause** - Add conditions to patterns
5. **Discard _** - Default case in switch expressions
6. **Positional patterns** - Work with Deconstruct methods

---

## 📝 Interview Questions

1. **What's the difference between switch statement and switch expression?**
   - Expression returns a value, statement executes code
   - Expression uses `=>`, statement uses `:`
   - Expression uses `_` for default, statement uses `default:`

2. **When would you use property patterns?**
   - When matching based on object property values
   - Complex conditional logic based on object state

---

## 🔗 Next Topic
Next: [35_CSharp7_Ref_Returns.md](./35_CSharp7_Ref_Returns.md) - Ref Returns and Local Functions
