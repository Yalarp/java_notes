# Nullable Types and Partial Classes in C#

## 📚 Introduction

**Nullable types** allow value types to represent undefined or missing values. **Partial classes** allow splitting a class definition across multiple files.

---

## Part 1: Nullable Types

### 🎯 Learning Objectives
- Understand nullable value types
- Master null-coalescing operators
- Learn nullable reference types (C# 8+)

---

### 🔍 The Problem with Value Types

```csharp
int age = ???;  // What value represents "unknown"?
// -1? 0? int.MinValue? - All are valid ages (theoretically)!

// Solution: Nullable<int> or int?
int? age = null;  // Now null means "unknown"
```

---

### 💻 Nullable Value Types Examples

#### Example 1: Basic Nullable Types

```csharp
using System;

class Program
{
    static void Main()
    {
        // Nullable value types
        int? nullableInt = null;
        double? nullableDouble = 3.14;
        bool? nullableBool = null;
        
        Console.WriteLine($"nullableInt: {nullableInt}");           // (nothing)
        Console.WriteLine($"nullableDouble: {nullableDouble}");     // 3.14
        Console.WriteLine($"Has value: {nullableInt.HasValue}");    // False
        Console.WriteLine($"Has value: {nullableDouble.HasValue}"); // True
        
        // Accessing Value
        if (nullableDouble.HasValue)
        {
            Console.WriteLine($"Value: {nullableDouble.Value}");
        }
        
        // DANGER: Accessing Value when null
        // Console.WriteLine(nullableInt.Value);  // InvalidOperationException!
    }
}
```

#### Example 2: Null-Coalescing Operator (??)

```csharp
using System;

class Program
{
    static void Main()
    {
        int? score = null;
        
        // If score is null, use 0
        int actualScore = score ?? 0;
        Console.WriteLine($"Score: {actualScore}");  // 0
        
        score = 85;
        actualScore = score ?? 0;
        Console.WriteLine($"Score: {actualScore}");  // 85
        
        // Chaining ??
        int? a = null;
        int? b = null;
        int? c = 42;
        int result = a ?? b ?? c ?? 0;
        Console.WriteLine($"Result: {result}");  // 42
    }
}
```

#### Example 3: Null-Coalescing Assignment (??=) - C# 8+

```csharp
using System;

class Program
{
    static void Main()
    {
        int? number = null;
        
        // Assign only if null
        number ??= 10;
        Console.WriteLine($"number: {number}");  // 10
        
        number ??= 20;  // Not assigned - number already has value
        Console.WriteLine($"number: {number}");  // Still 10
    }
}
```

#### Example 4: Null-Conditional Operator (?.)

```csharp
using System;

class Person
{
    public string Name { get; set; }
    public Address Address { get; set; }
}

class Address
{
    public string City { get; set; }
}

class Program
{
    static void Main()
    {
        Person person = null;
        
        // Without ?. : throws NullReferenceException
        // string name = person.Name;
        
        // With ?. : returns null if person is null
        string name = person?.Name;
        Console.WriteLine($"Name: {name ?? "Unknown"}");
        
        // Chaining
        person = new Person { Name = "John" };
        string city = person?.Address?.City;  // null (Address is null)
        Console.WriteLine($"City: {city ?? "No city"}");
        
        person.Address = new Address { City = "NYC" };
        city = person?.Address?.City;  // "NYC"
        Console.WriteLine($"City: {city}");
    }
}
```

#### Example 5: Nullable with Methods

```csharp
using System;

class Program
{
    static int? GetValue(bool returnNull)
    {
        return returnNull ? null : 42;
    }
    
    static void ProcessValue(int? value)
    {
        if (value.HasValue)
            Console.WriteLine($"Processing: {value.Value}");
        else
            Console.WriteLine("No value to process");
    }
    
    static void Main()
    {
        int? val1 = GetValue(true);
        int? val2 = GetValue(false);
        
        ProcessValue(val1);  // No value to process
        ProcessValue(val2);  // Processing: 42
        
        // GetValueOrDefault()
        Console.WriteLine(val1.GetValueOrDefault());     // 0
        Console.WriteLine(val1.GetValueOrDefault(100));  // 100
    }
}
```

---

### 📊 Nullable Operators Summary

| Operator | Name | Example | Result |
|----------|------|---------|--------|
| `??` | Null-coalescing | `x ?? 0` | x if not null, else 0 |
| `??=` | Null-coalescing assignment | `x ??= 5` | Assigns 5 to x if null |
| `?.` | Null-conditional | `obj?.Prop` | Prop value or null |
| `?[]` | Null-conditional element | `arr?[0]` | Element or null |

---

## Part 2: Partial Classes

### 🎯 Learning Objectives
- Understand partial class purpose
- Learn partial class rules
- Use partial methods

---

### 🔍 What Are Partial Classes?

Partial classes allow splitting a class definition across multiple files. At compile time, they are combined into a single class.

```
File1.cs                    File2.cs
┌───────────────────┐      ┌───────────────────┐
│ partial class Foo │      │ partial class Foo │
│ {                 │  +   │ {                 │
│   void Method1()  │      │   void Method2()  │
│ }                 │      │ }                 │
└───────────────────┘      └───────────────────┘
                    │
                    ▼
            ┌───────────────────┐
            │    class Foo      │
            │ {                 │
            │   void Method1()  │
            │   void Method2()  │
            │ }                 │
            └───────────────────┘
```

---

### 💻 Partial Class Examples

#### Example 1: Basic Partial Class

```csharp
// File: Employee.Part1.cs
public partial class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    
    public void DisplayInfo()
    {
        Console.WriteLine($"{Id}: {Name}");
    }
}

// File: Employee.Part2.cs
public partial class Employee
{
    public double Salary { get; set; }
    
    public void CalculateTax()
    {
        double tax = Salary * 0.1;
        Console.WriteLine($"Tax: {tax}");
    }
}

// Usage
class Program
{
    static void Main()
    {
        Employee emp = new Employee
        {
            Id = 1,
            Name = "John",
            Salary = 50000
        };
        
        emp.DisplayInfo();   // From Part1
        emp.CalculateTax();  // From Part2
    }
}
```

#### Example 2: Generated Code Separation

```csharp
// File: Form1.Designer.cs (Auto-generated)
partial class Form1
{
    private Button button1;
    private TextBox textBox1;
    
    private void InitializeComponent()
    {
        this.button1 = new Button();
        this.textBox1 = new TextBox();
        // ... generated code
    }
}

// File: Form1.cs (User code)
partial class Form1
{
    public Form1()
    {
        InitializeComponent();
    }
    
    private void button1_Click(object sender, EventArgs e)
    {
        // Your event handler
        MessageBox.Show("Clicked!");
    }
}
```

#### Example 3: Rules for Partial Classes

```csharp
// All parts must:
// 1. Use 'partial' keyword
// 2. Have same accessibility
// 3. Be in same namespace
// 4. Have same type parameters (if generic)

// VALID:
public partial class MyClass { }  // File1.cs
public partial class MyClass { }  // File2.cs

// INVALID - different accessibility:
public partial class Bad { }   // File1.cs
internal partial class Bad { } // File2.cs - ERROR!

// Any part can specify:
// - Base class (only one part can, all inherit from it)
// - Interfaces (combined from all parts)
// - Attributes (merged)

public partial class Example : BaseClass { }  // File1.cs
public partial class Example : IInterface1 { }  // File2.cs
// Result: Example inherits BaseClass and implements IInterface1
```

#### Example 4: Partial Methods

```csharp
// File: Generated.cs
partial class DataProcessor
{
    // Partial method declaration (no body)
    partial void OnDataProcessed(string data);
    
    public void Process(string data)
    {
        // Do processing...
        Console.WriteLine($"Processing: {data}");
        
        // Call partial method (safe even if not implemented)
        OnDataProcessed(data);
    }
}

// File: Custom.cs
partial class DataProcessor
{
    // Partial method implementation (optional)
    partial void OnDataProcessed(string data)
    {
        Console.WriteLine($"Custom handling for: {data}");
    }
}

// Usage
class Program
{
    static void Main()
    {
        DataProcessor dp = new DataProcessor();
        dp.Process("Sample");
        // Output:
        // Processing: Sample
        // Custom handling for: Sample
    }
}
```

#### Partial Method Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                    PARTIAL METHODS                               │
├─────────────────────────────────────────────────────────────────┤
│ ✓ Must return void (pre-C# 9)                                   │
│ ✓ Cannot have out parameters (pre-C# 9)                         │
│ ✓ Implicitly private                                            │
│ ✓ If not implemented, calls are removed by compiler             │
│ ✓ C# 9+: Can have return types and out params (if implemented) │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Key Points Summary

### Nullable Types
| Feature | Example | Description |
|---------|---------|-------------|
| Declaration | `int? x` | Same as `Nullable<int>` |
| Check | `x.HasValue` | True if not null |
| Get value | `x.Value` | Throws if null |
| Default | `x.GetValueOrDefault()` | Returns 0 if null |
| Coalesce | `x ?? 0` | Use 0 if null |

### Partial Classes
| Feature | Description |
|---------|-------------|
| Purpose | Split class across files |
| Use cases | Generated code, large classes, team work |
| Requirement | `partial` keyword on all parts |
| Compile result | Single unified class |

---

## ❌ Common Mistakes

### Mistake 1: Accessing Value without check
```csharp
int? x = null;
int y = x.Value;  // InvalidOperationException!
int y = x ?? 0;   // SAFE
```

### Mistake 2: Forgetting partial keyword
```csharp
partial class A { }  // File1.cs
class A { }          // File2.cs - ERROR: Duplicate definition!
```

---

## 📝 Practice Questions

1. **What's the output?**
```csharp
int? a = null;
int? b = 5;
int c = a ?? b ?? 10;
Console.WriteLine(c);
```
<details>
<summary>Answer</summary>
`5` - a is null so uses b, which is 5.
</details>

2. **Can partial classes have different base classes in different files?**
<details>
<summary>Answer</summary>
No. Only one part can specify a base class, and it applies to the whole class.
</details>

---

## 🔗 Related Topics
- [14_Exception_Handling.md](14_Exception_Handling.md) - Handling null exceptions
- [06_Boxing_Unboxing.md](06_Boxing_Unboxing.md) - Nullable boxing behavior
