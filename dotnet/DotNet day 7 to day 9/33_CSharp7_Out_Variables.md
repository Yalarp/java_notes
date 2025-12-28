# C# 7 Features - Out Variables and Tuples

## 📚 Introduction

C# 7 introduced several features to reduce boilerplate code and improve readability. Out variables and Tuples are among the most useful additions.

---

## 🎯 Learning Objectives

- Use inline out variable declarations
- Work with tuples for returning multiple values
- Understand tuple deconstruction

---

## 📖 Part 1: Out Variables

```
┌────────────────────────────────────────────────────────────────┐
│                     Out Variables (C# 7)                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BEFORE C# 7:                                                   │
│  ─────────────                                                  │
│  int result;                    // Declare first               │
│  if (int.TryParse("123", out result))                          │
│  {                                                              │
│      Console.WriteLine(result);                                │
│  }                                                              │
│                                                                 │
│  C# 7 AND LATER:                                                │
│  ───────────────                                                │
│  if (int.TryParse("123", out int result))  // Inline declare   │
│  {                                                              │
│      Console.WriteLine(result);                                │
│  }                                                              │
│                                                                 │
│  Benefit: Less boilerplate, variable declared where needed     │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Out Variable Examples

```csharp
using System;

class Program
{
    static void Main()
    {
        // ✅ C# 7: Declare out variable inline
        if (int.TryParse("123", out int number))
        {
            Console.WriteLine($"Parsed: {number}");  // number = 123
        }
        
        // ✅ Use var for type inference
        if (double.TryParse("3.14", out var pi))
        {
            Console.WriteLine($"Pi: {pi}");  // pi = 3.14
        }
        
        // ✅ Discard with _ if you don't need the value
        if (int.TryParse("456", out _))
        {
            Console.WriteLine("Valid number format");
        }
        
        // ✅ Multiple out parameters
        string input = "100,200";
        if (TryParsePair(input, out int x, out int y))
        {
            Console.WriteLine($"X: {x}, Y: {y}");
        }
        
        // ✅ Dictionary TryGetValue
        var dict = new Dictionary<string, int> { ["one"] = 1 };
        if (dict.TryGetValue("one", out int value))
        {
            Console.WriteLine($"Value: {value}");
        }
    }
    
    static bool TryParsePair(string input, out int x, out int y)
    {
        x = y = 0;
        string[] parts = input.Split(',');
        return parts.Length == 2 
            && int.TryParse(parts[0], out x) 
            && int.TryParse(parts[1], out y);
    }
}
```

---

## 📖 Part 2: Tuples

```
┌────────────────────────────────────────────────────────────────┐
│                       Tuples (C# 7)                             │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem: How to return multiple values from a method?         │
│                                                                 │
│  Old Solutions:                                                 │
│  • out parameters (verbose)                                    │
│  • Create a class (overkill for simple cases)                 │
│  • Use Tuple<T1, T2> (Item1, Item2 not descriptive)           │
│                                                                 │
│  C# 7 Solution: Named Tuples!                                  │
│                                                                 │
│  (string Name, int Age) GetPerson()                            │
│  {                                                              │
│      return ("John", 30);                                      │
│  }                                                              │
│                                                                 │
│  var person = GetPerson();                                     │
│  Console.WriteLine(person.Name);   // "John" - named!          │
│  Console.WriteLine(person.Age);    // 30                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Tuple Examples

```csharp
using System;

class Program
{
    static void Main()
    {
        // ✅ Creating tuples
        var tuple1 = (1, "hello");                    // Unnamed
        var tuple2 = (Id: 1, Name: "hello");         // Named
        (int Id, string Name) tuple3 = (2, "world"); // Named with type
        
        Console.WriteLine($"Id: {tuple2.Id}, Name: {tuple2.Name}");
        
        // ✅ Return tuple from method
        var person = GetPerson();
        Console.WriteLine($"{person.Name} is {person.Age} years old");
        
        // ✅ Deconstruction - extract into separate variables
        var (name, age) = GetPerson();
        Console.WriteLine($"{name} is {age}");
        
        // ✅ Partial deconstruction
        var (firstName, _) = GetPerson();  // Discard age
        Console.WriteLine($"First name only: {firstName}");
        
        // ✅ Tuple comparison (value equality)
        var t1 = (A: 1, B: 2);
        var t2 = (A: 1, B: 2);
        Console.WriteLine(t1 == t2);  // True! Value equality
        
        // ✅ Nested tuples
        var nested = (Name: "John", Address: (City: "NYC", Zip: "10001"));
        Console.WriteLine(nested.Address.City);  // NYC
        
        // ✅ Using tuples in LINQ
        var people = new[] { "Alice:25", "Bob:30", "Carol:35" };
        var parsed = people.Select(p => {
            var parts = p.Split(':');
            return (Name: parts[0], Age: int.Parse(parts[1]));
        });
        
        foreach (var p in parsed)
        {
            Console.WriteLine($"{p.Name}: {p.Age}");
        }
    }
    
    // Method returning named tuple
    static (string Name, int Age) GetPerson()
    {
        return ("John Doe", 30);
    }
    
    // Alternative syntax
    static (int Min, int Max, double Average) GetStatistics(int[] numbers)
    {
        return (
            Min: numbers.Min(),
            Max: numbers.Max(),
            Average: numbers.Average()
        );
    }
}
```

### Tuple vs Class Decision:

```
┌────────────────────────────────────────────────────────────────┐
│               When to Use Tuple vs Class                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  USE TUPLE:                                                     │
│  • Simple, temporary grouping                                  │
│  • Private or internal methods                                 │
│  • Quick return of multiple values                             │
│  • No need for methods on the type                             │
│                                                                 │
│  USE CLASS:                                                     │
│  • Public API return type                                      │
│  • Complex behavior needed                                     │
│  • Will be used across many places                             │
│  • Need to add methods                                         │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Comparison Table

| Feature | Before C# 7 | C# 7+ |
|---------|-------------|-------|
| Out variables | Declare first | Inline declaration |
| Multiple returns | out params or class | Named tuples |
| Tuple access | Item1, Item2 | Named: Name, Age |
| Discard | Must declare unused | Use _ |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Inline out** - Declare where you use it
2. **Use var** - Type inference works in out
3. **Discard _** - For values you don't need
4. **Named tuples** - More readable than Item1, Item2
5. **Deconstruction** - Extract tuple elements to variables
6. **Value equality** - Tuples compare by value

---

## 📝 Interview Questions

1. **What's the benefit of inline out variables?**
   - Reduces code, declares variable at point of use
   - Variable scope is limited appropriately

2. **When would you use tuples vs a class?**
   - Tuples: Simple, internal, temporary groupings
   - Class: Complex, public API, reusable

3. **How do you ignore a tuple element?**
   - Use discard: var (name, _) = GetPerson();

---

## 🔗 Next Topic
Next: [34_CSharp7_Pattern_Matching.md](./34_CSharp7_Pattern_Matching.md) - Pattern Matching
