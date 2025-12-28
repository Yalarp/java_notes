# Generic and Non-Generic Delegates in C#

## 📚 Introduction

C# provides built-in generic delegates (`Func<>`, `Action<>`, `Predicate<>`) that eliminate the need to declare custom delegate types for most scenarios.

---

## 🎯 Learning Objectives

- Master Func<>, Action<>, Predicate<> delegates
- Understand generic vs non-generic delegates
- Apply built-in delegates with LINQ

---

## 🔍 Built-in Generic Delegates

```
┌─────────────────────────────────────────────────────────────────┐
│                   BUILT-IN DELEGATES                             │
├─────────────┬───────────────────────────────────────────────────┤
│ Delegate    │ Description                                        │
├─────────────┼───────────────────────────────────────────────────┤
│ Action<>    │ Takes 0-16 parameters, returns void               │
│ Func<>      │ Takes 0-16 parameters, returns a value            │
│ Predicate<> │ Takes 1 parameter, returns bool                   │
└─────────────┴───────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Action<> Delegate

```csharp
using System;

class Program
{
    static void Main()
    {
        // Action with no parameters
        Action greet = () => Console.WriteLine("Hello!");
        greet();  // Hello!
        
        // Action<T> with 1 parameter
        Action<string> greetName = name => Console.WriteLine($"Hello, {name}!");
        greetName("Alice");  // Hello, Alice!
        
        // Action<T1, T2> with 2 parameters
        Action<string, int> printInfo = (name, age) => 
            Console.WriteLine($"{name} is {age} years old");
        printInfo("Bob", 25);  // Bob is 25 years old
        
        // Action<T1, T2, T3> with 3 parameters
        Action<int, int, int> showSum = (a, b, c) => 
            Console.WriteLine($"Sum: {a + b + c}");
        showSum(1, 2, 3);  // Sum: 6
        
        // Using named method
        Action<string> upper = PrintUpper;
        upper("test");  // TEST
    }
    
    static void PrintUpper(string s) => Console.WriteLine(s.ToUpper());
}
```

---

### Example 2: Func<> Delegate

```csharp
using System;

class Program
{
    static void Main()
    {
        // Func<TResult> - no params, returns value
        Func<int> getNumber = () => 42;
        Console.WriteLine(getNumber());  // 42
        
        // Func<T, TResult> - 1 param, returns value
        Func<int, int> square = x => x * x;
        Console.WriteLine(square(5));  // 25
        
        // Func<T1, T2, TResult> - 2 params, returns value
        Func<int, int, int> add = (a, b) => a + b;
        Console.WriteLine(add(3, 4));  // 7
        
        // Func<T1, T2, T3, TResult> - 3 params
        Func<int, int, int, int> sumThree = (a, b, c) => a + b + c;
        Console.WriteLine(sumThree(1, 2, 3));  // 6
        
        // With complex types
        Func<string, int> stringLength = s => s.Length;
        Console.WriteLine(stringLength("Hello"));  // 5
        
        // Returning objects
        Func<int, int, (int sum, int product)> calculate = (a, b) => (a + b, a * b);
        var result = calculate(3, 4);
        Console.WriteLine($"Sum: {result.sum}, Product: {result.product}");
    }
}
```

---

### Example 3: Predicate<> Delegate

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // Predicate<T> - takes T, returns bool
        Predicate<int> isPositive = n => n > 0;
        Console.WriteLine(isPositive(5));   // True
        Console.WriteLine(isPositive(-3));  // False
        
        Predicate<string> isLong = s => s.Length > 5;
        Console.WriteLine(isLong("Hello"));       // False
        Console.WriteLine(isLong("World Wide"));  // True
        
        // Using with List<T>.Find
        List<int> numbers = new List<int> { -2, -1, 0, 1, 2, 3 };
        
        int firstPositive = numbers.Find(n => n > 0);
        Console.WriteLine($"First positive: {firstPositive}");  // 1
        
        List<int> allPositive = numbers.FindAll(n => n > 0);
        Console.WriteLine($"All positive: {string.Join(", ", allPositive)}");  // 1, 2, 3
        
        // RemoveAll with Predicate
        numbers.RemoveAll(n => n < 0);  // Removes -2, -1
        Console.WriteLine($"After remove: {string.Join(", ", numbers)}");  // 0, 1, 2, 3
    }
}
```

---

### Example 4: Comparison of Delegate Types

```csharp
using System;

class Program
{
    static void Main()
    {
        // Custom delegate (old way)
        delegate int MyOperation(int a, int b);
        MyOperation customAdd = (a, b) => a + b;
        
        // Func<> (modern way - preferred)
        Func<int, int, int> funcAdd = (a, b) => a + b;
        
        // Both work the same way
        Console.WriteLine(customAdd(3, 4));  // 7
        Console.WriteLine(funcAdd(3, 4));    // 7
        
        // Predicate<T> vs Func<T, bool>
        Predicate<int> predIsEven = n => n % 2 == 0;
        Func<int, bool> funcIsEven = n => n % 2 == 0;
        
        // Both check the same condition
        Console.WriteLine(predIsEven(4));  // True
        Console.WriteLine(funcIsEven(4));  // True
        
        // Note: List<T>.Find requires Predicate<T>, not Func<T, bool>
    }
}
```

---

### Example 5: Delegates as Method Parameters

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void ProcessList<T>(List<T> items, Action<T> action)
    {
        foreach (T item in items)
        {
            action(item);
        }
    }
    
    static List<TResult> TransformList<T, TResult>(List<T> items, Func<T, TResult> transformer)
    {
        List<TResult> results = new List<TResult>();
        foreach (T item in items)
        {
            results.Add(transformer(item));
        }
        return results;
    }
    
    static List<T> FilterList<T>(List<T> items, Predicate<T> condition)
    {
        List<T> results = new List<T>();
        foreach (T item in items)
        {
            if (condition(item))
                results.Add(item);
        }
        return results;
    }
    
    static void Main()
    {
        List<int> numbers = new List<int> { 1, 2, 3, 4, 5 };
        
        // Action: Print each number
        Console.WriteLine("Processing:");
        ProcessList(numbers, n => Console.WriteLine($"  Number: {n}"));
        
        // Func: Transform to squares
        List<int> squares = TransformList(numbers, n => n * n);
        Console.WriteLine($"Squares: {string.Join(", ", squares)}");
        
        // Predicate: Filter even numbers
        List<int> evens = FilterList(numbers, n => n % 2 == 0);
        Console.WriteLine($"Evens: {string.Join(", ", evens)}");
    }
}
```

#### Output:
```
Processing:
  Number: 1
  Number: 2
  Number: 3
  Number: 4
  Number: 5
Squares: 1, 4, 9, 16, 25
Evens: 2, 4
```

---

## 📊 Delegate Comparison Table

| Feature | Action<> | Func<> | Predicate<> |
|---------|----------|--------|-------------|
| Return type | void | TResult | bool |
| Parameters | 0-16 | 0-16 | exactly 1 |
| Use case | Side effects | Transformation | Condition |
| LINQ usage | ForEach | Select, Aggregate | Where, Find |

---

## ⚡ When to Use Which

| Scenario | Use |
|----------|-----|
| Print, log, update | `Action<>` |
| Calculate, convert, transform | `Func<>` |
| Filter, check condition | `Predicate<>` |
| Need custom signature | Custom delegate |

---

## ❌ Common Mistakes

### Mistake 1: Confusing Predicate and Func<T, bool>
```csharp
List<int> list = new List<int> { 1, 2, 3 };
// list.Find(n => n > 1);  // Expects Predicate<T>
// Func<int, bool> won't work directly with Find
```

### Mistake 2: Forgetting last type in Func is return type
```csharp
Func<int, int, int>  // int Add(int, int)
//     ^    ^    ^
//     |    |    └── Return type
//     └────┴─────── Parameters
```

---

## 📝 Practice Questions

1. **What's the signature of Func<int, string, bool>?**
<details>
<summary>Answer</summary>
`bool Method(int a, string b)` - Takes int and string, returns bool.
</details>

2. **Which delegate would you use for List.RemoveAll?**
<details>
<summary>Answer</summary>
`Predicate<T>` - It needs a condition that returns bool.
</details>

---

## 🔗 Related Topics
- [09_Delegates_Fundamentals.md](09_Delegates_Fundamentals.md) - Basic delegates
- [12_Anonymous_Methods_Lambda.md](12_Anonymous_Methods_Lambda.md) - Lambda expressions
- [20_Collections_Complete_Guide.md](20_Collections_Complete_Guide.md) - Collections methods
