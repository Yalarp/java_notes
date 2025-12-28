# C# 10-11 New Features

## 📚 Introduction

C# 10 and 11 continue to refine the language with features focused on reducing boilerplate code and improving expressiveness. Key additions include global usings, file-scoped namespaces, improved lambdas, and raw string literals.

---

## 🎯 Learning Objectives

- Use global and implicit usings
- Apply file-scoped namespace declarations
- Understand improved lambda expressions
- Use raw string literals for multi-line strings

---

## 📖 Part 1: Global Using Directives (C# 10)

```
┌────────────────────────────────────────────────────────────────┐
│               Global Using Directives (C# 10)                   │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem: Repeating same usings in every file                  │
│                                                                 │
│  Solution: Declare once, applies to entire project             │
│                                                                 │
│  // In GlobalUsings.cs (one file)                              │
│  global using System;                                          │
│  global using System.Collections.Generic;                      │
│  global using System.Linq;                                     │
│  global using System.Threading.Tasks;                          │
│                                                                 │
│  // Now all .cs files in project can use these without import  │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Global Usings Example

```csharp
// ===== GlobalUsings.cs =====
global using System;
global using System.Collections.Generic;
global using System.Linq;
global using System.Threading.Tasks;
global using MyApp.Models;  // Can include your own namespaces

// ===== Program.cs =====
// No using statements needed! All global usings are available

class Program
{
    static async Task Main()
    {
        // List<T> available without 'using System.Collections.Generic'
        var numbers = new List<int> { 1, 2, 3, 4, 5 };
        
        // LINQ available without 'using System.Linq'
        var doubled = numbers.Select(x => x * 2).ToList();
        
        // Task available without 'using System.Threading.Tasks'
        await Task.Delay(1000);
        
        Console.WriteLine(string.Join(", ", doubled));
    }
}
```

### Implicit Usings (.NET 6+):

```xml
<!-- In .csproj file -->
<PropertyGroup>
    <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>

<!-- Automatically includes:
    global using System;
    global using System.Collections.Generic;
    global using System.IO;
    global using System.Linq;
    global using System.Net.Http;
    global using System.Threading;
    global using System.Threading.Tasks;
-->
```

---

## 📖 Part 2: File-Scoped Namespaces (C# 10)

```csharp
// ❌ BEFORE C# 10: Nested namespace
namespace MyApp.Services
{
    public class UserService
    {
        public void CreateUser() { }
    }
    
    public class OrderService
    {
        public void CreateOrder() { }
    }
}

// ✅ C# 10: File-scoped namespace (less indentation!)
namespace MyApp.Services;

public class UserService
{
    public void CreateUser() { }
}

public class OrderService
{
    public void CreateOrder() { }
}

// Saves one level of indentation for entire file!
```

---

## 📖 Part 3: Target-Typed New (C# 9-10)

```csharp
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // ❌ Before: Redundant type name
        List<string> names1 = new List<string>();
        Dictionary<int, string> map1 = new Dictionary<int, string>();
        
        // ✅ C# 9+: Target-typed new
        List<string> names2 = new();            // Type inferred from left side
        Dictionary<int, string> map2 = new();   // Cleaner!
        
        // ✅ Works with constructors too
        Person person = new("John", 30);        // new Person("John", 30)
        
        // ✅ Works in arrays
        Person[] people = new Person[]
        {
            new("Alice", 25),     // Type inferred
            new("Bob", 35)
        };
        
        // ✅ Works in method calls
        AddPerson(new("Carol", 28));
    }
    
    static void AddPerson(Person p) => Console.WriteLine(p);
}

class Person
{
    public string Name { get; }
    public int Age { get; }
    public Person(string name, int age) => (Name, Age) = (name, age);
}
```

---

## 📖 Part 4: Improved Lambda Expressions (C# 10)

```csharp
using System;

class Program
{
    static void Main()
    {
        // ✅ Natural type for lambdas
        var add = (int a, int b) => a + b;        // Func<int, int, int>
        var greet = () => Console.WriteLine("Hi"); // Action
        
        // ✅ Explicit return type
        var parse = object (string s) => int.Parse(s);  // Returns object
        
        // ✅ Attributes on lambdas
        var validated = [System.Obsolete] () => "Old method";
        
        // ✅ Default parameter values (C# 12)
        // var greet = (string name = "World") => $"Hello, {name}!";
        
        Console.WriteLine(add(3, 5));  // 8
    }
}
```

---

## 📖 Part 5: Raw String Literals (C# 11)

```csharp
using System;

class Program
{
    static void Main()
    {
        // ❌ Before: Escaped strings are hard to read
        string json1 = "{\n  \"name\": \"John\",\n  \"age\": 30\n}";
        
        // ❌ Verbatim strings still need doubled quotes
        string json2 = @"{
          ""name"": ""John"",
          ""age"": 30
        }";
        
        // ✅ C# 11: Raw string literals
        string json3 = """
            {
                "name": "John",
                "age": 30
            }
            """;
        
        Console.WriteLine(json3);
        
        // ✅ With interpolation
        string name = "Alice";
        int age = 25;
        
        string personJson = $$"""
            {
                "name": "{{name}}",
                "age": {{age}}
            }
            """;
        
        Console.WriteLine(personJson);
    }
}
```

### Raw String Literal Rules:

```
┌────────────────────────────────────────────────────────────────┐
│              Raw String Literal Syntax                          │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  • Start with """ (3 or more quotes)                           │
│  • End with matching number of quotes                          │
│  • No escaping needed inside                                   │
│  • Whitespace before closing """ determines indentation        │
│  • For interpolation, use $$ with {{}}                        │
│                                                                 │
│  Example:                                                       │
│  string sql = """                                              │
│      SELECT *                                                   │
│      FROM Users                                                 │
│      WHERE Active = 1                                          │
│      """;                                                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Feature Summary

| Feature | Version | Benefit |
|---------|---------|---------|
| Global using | C# 10 | Reduce repetitive imports |
| File-scoped namespace | C# 10 | Less indentation |
| Target-typed new | C# 9 | Less redundancy |
| Natural lambda types | C# 10 | var with lambdas |
| Raw string literals | C# 11 | Cleaner multi-line strings |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **global using** - Declare once, use everywhere
2. **namespace X;** - File-scoped, one level less indentation
3. **Type x = new()** - Type inferred from variable
4. **var lambda = () => {}** - Natural types for lambdas
5. **\"\"\"...\"\"\"`** - Raw strings, no escaping
6. **$$\"\"\"...{{}}\"\"\"** - Interpolated raw strings

---

## 📝 Interview Questions

1. **What are global usings?**
   - Using statements that apply to entire project
   - Reduces repetitive imports

2. **Benefit of file-scoped namespaces?**
   - Removes one level of indentation
   - Cleaner code structure

3. **When would you use raw string literals?**
   - JSON, XML, SQL, regex patterns
   - Any multi-line string with special characters

---

## 🔗 Next Topic
Next: [38_Entity_Framework_Introduction.md](./38_Entity_Framework_Introduction.md) - Entity Framework Core
