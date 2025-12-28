# Attributes and Metadata in C#

## 📚 Introduction

**Attributes** provide a way to add metadata to your code elements (classes, methods, properties, etc.). This metadata can be queried at runtime using **reflection**.

---

## 🎯 Learning Objectives

- Understand built-in attributes
- Create custom attributes
- Query attributes using reflection
- Apply AttributeUsage correctly

---

## 🔍 What Are Attributes?

```
┌─────────────────────────────────────────────────────────────────┐
│                      ATTRIBUTES                                  │
├─────────────────────────────────────────────────────────────────┤
│ • Metadata attached to code elements                            │
│ • Enclosed in square brackets [Attribute]                       │
│ • Processed at compile-time or runtime                          │
│ • All derive from System.Attribute                              │
│ • "Attribute" suffix is optional: [Obsolete] = [ObsoleteAttribute]│
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Common Built-in Attributes

```csharp
using System;

class Demo
{
    // Marks method as outdated
    [Obsolete("Use NewMethod instead")]
    public void OldMethod()
    {
        Console.WriteLine("Old way of doing things");
    }
    
    public void NewMethod()
    {
        Console.WriteLine("New and improved!");
    }
    
    // Conditional compilation
    [System.Diagnostics.Conditional("DEBUG")]
    public void DebugOnly()
    {
        Console.WriteLine("Only runs in DEBUG mode");
    }
}

class Program
{
    static void Main()
    {
        Demo d = new Demo();
        d.OldMethod();    // Compiler warning!
        d.NewMethod();
        d.DebugOnly();    // Removed in Release builds
    }
}
```

---

### Example 2: Serialization Attributes

```csharp
using System;
using System.Text.Json.Serialization;

class Person
{
    [JsonPropertyName("full_name")]
    public string Name { get; set; }
    
    [JsonIgnore]
    public string Password { get; set; }
    
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string Nickname { get; set; }
}
```

---

### Example 3: Creating Custom Attribute

```csharp
using System;

// Step 1: Define the attribute class
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, 
                AllowMultiple = true)]
public class DeveloperInfoAttribute : Attribute
{
    public string Developer { get; }
    public string Date { get; set; }
    public int Version { get; set; } = 1;
    
    // Positional parameter (required)
    public DeveloperInfoAttribute(string developer)
    {
        Developer = developer;
    }
}

// Step 2: Apply the attribute
[DeveloperInfo("John", Date = "2024-01-15", Version = 2)]
[DeveloperInfo("Jane", Date = "2024-02-20")]  // AllowMultiple = true
class MyClass
{
    [DeveloperInfo("Bob")]
    public void MyMethod()
    {
        Console.WriteLine("Method implementation");
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4 | `[AttributeUsage(...)]` | Specifies where attribute can be applied |
| 4 | `AttributeTargets.Class \| AttributeTargets.Method` | Valid on classes and methods |
| 5 | `AllowMultiple = true` | Can apply multiple times to same element |
| 6 | `: Attribute` | All attributes inherit from System.Attribute |
| 8 | `public string Developer { get; }` | Read-only property (set in constructor) |
| 9 | `public string Date { get; set; }` | Named parameter (optional) |
| 10 | `public int Version { get; set; } = 1;` | Named parameter with default |
| 13 | `DeveloperInfoAttribute(string developer)` | Positional parameter (required) |

---

### Example 4: Reading Attributes with Reflection

```csharp
using System;
using System.Reflection;

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
public class AuthorAttribute : Attribute
{
    public string Name { get; }
    public string Version { get; set; }
    
    public AuthorAttribute(string name)
    {
        Name = name;
    }
}

[Author("Alice", Version = "1.0")]
class Calculator
{
    [Author("Bob", Version = "1.1")]
    public int Add(int a, int b) => a + b;
}

class Program
{
    static void Main()
    {
        Type type = typeof(Calculator);
        
        // Get class-level attributes
        var classAttrs = type.GetCustomAttributes<AuthorAttribute>();
        foreach (var attr in classAttrs)
        {
            Console.WriteLine($"Class Author: {attr.Name}, Version: {attr.Version}");
        }
        
        // Get method-level attributes
        MethodInfo method = type.GetMethod("Add");
        var methodAttrs = method.GetCustomAttributes<AuthorAttribute>();
        foreach (var attr in methodAttrs)
        {
            Console.WriteLine($"Method Author: {attr.Name}, Version: {attr.Version}");
        }
        
        // Check if attribute exists
        bool hasAuthor = type.IsDefined(typeof(AuthorAttribute), false);
        Console.WriteLine($"Has Author attribute: {hasAuthor}");
    }
}
```

#### Output:
```
Class Author: Alice, Version: 1.0
Method Author: Bob, Version: 1.1
Has Author attribute: True
```

---

### Example 5: AttributeUsage Options

```csharp
using System;

// Only allowed on methods, can't be inherited by derived classes
[AttributeUsage(AttributeTargets.Method, Inherited = false)]
public class NoInheritAttribute : Attribute { }

// Only allowed on properties, single use only
[AttributeUsage(AttributeTargets.Property, AllowMultiple = false)]
public class ValidateAttribute : Attribute 
{
    public int MinLength { get; set; }
    public int MaxLength { get; set; }
}

class User
{
    [Validate(MinLength = 3, MaxLength = 50)]
    public string Username { get; set; }
}
```

---

### Example 6: Validation with Custom Attributes

```csharp
using System;
using System.Reflection;

// Custom validation attribute
[AttributeUsage(AttributeTargets.Property)]
public class RangeAttribute : Attribute
{
    public int Min { get; }
    public int Max { get; }
    
    public RangeAttribute(int min, int max)
    {
        Min = min;
        Max = max;
    }
    
    public bool IsValid(int value)
    {
        return value >= Min && value <= Max;
    }
}

class Product
{
    public string Name { get; set; }
    
    [Range(1, 100)]
    public int Quantity { get; set; }
    
    [Range(0, 10000)]
    public decimal Price { get; set; }
}

class Validator
{
    public static bool Validate(object obj)
    {
        Type type = obj.GetType();
        
        foreach (PropertyInfo prop in type.GetProperties())
        {
            var rangeAttr = prop.GetCustomAttribute<RangeAttribute>();
            if (rangeAttr != null)
            {
                object value = prop.GetValue(obj);
                if (value is int intValue)
                {
                    if (!rangeAttr.IsValid(intValue))
                    {
                        Console.WriteLine($"{prop.Name} is out of range [{rangeAttr.Min}-{rangeAttr.Max}]");
                        return false;
                    }
                }
            }
        }
        return true;
    }
}

class Program
{
    static void Main()
    {
        Product p1 = new Product { Name = "Widget", Quantity = 50 };
        Product p2 = new Product { Name = "Gadget", Quantity = 150 };
        
        Console.WriteLine($"p1 valid: {Validator.Validate(p1)}");  // True
        Console.WriteLine($"p2 valid: {Validator.Validate(p2)}");  // False
    }
}
```

---

## 📊 Common Built-in Attributes

| Attribute | Purpose |
|-----------|---------|
| `[Obsolete]` | Mark as deprecated |
| `[Serializable]` | Mark class as serializable |
| `[NonSerialized]` | Exclude field from serialization |
| `[Conditional]` | Conditional compilation |
| `[Flags]` | Enum can be combined with bitwise |
| `[DllImport]` | Import from unmanaged DLL |
| `[MethodImpl]` | Method implementation hints |
| `[CallerMemberName]` | Capture caller method name |

---

## ⚡ AttributeTargets Options

| Target | Description |
|--------|-------------|
| `All` | Any element |
| `Class` | Classes |
| `Method` | Methods |
| `Property` | Properties |
| `Field` | Fields |
| `Parameter` | Method parameters |
| `ReturnValue` | Return value |
| `Constructor` | Constructors |
| `Interface` | Interfaces |
| `Assembly` | Assembly level |

---

## ❌ Common Mistakes

### Mistake 1: Forgetting Attribute suffix
```csharp
class MyAttribute : Attribute { }  // Correct
class My : Attribute { }           // Works but not conventional
```

### Mistake 2: Using wrong attribute target
```csharp
[AttributeUsage(AttributeTargets.Method)]
class OnlyMethods : Attribute { }

[OnlyMethods]  // Error if applied to class!
class MyClass { }
```

---

## 📝 Practice Questions

1. **What's the base class for all attributes?**
<details>
<summary>Answer</summary>
`System.Attribute`
</details>

2. **Can an attribute be applied multiple times to the same element?**
<details>
<summary>Answer</summary>
Only if `AttributeUsage` has `AllowMultiple = true`
</details>

---

## 🔗 Related Topics
- [17_Serialization.md](17_Serialization.md) - Serialization attributes
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - ICloneable attribute patterns
