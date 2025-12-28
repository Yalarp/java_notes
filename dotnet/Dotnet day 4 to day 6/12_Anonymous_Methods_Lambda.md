# Anonymous Methods and Lambda Expressions

## 📚 Introduction

**Anonymous methods** and **lambda expressions** allow you to define inline methods without explicitly declaring a separate method. They are concise ways to create delegates.

---

## 🎯 Learning Objectives

- Understand anonymous method syntax
- Master lambda expression syntax
- Learn expression vs statement lambdas
- Apply lambdas with built-in delegates

---

## 🔍 Evolution of Inline Methods

```
C# 1.0: Named methods only
C# 2.0: Anonymous methods (delegate keyword)
C# 3.0: Lambda expressions (=>) ← Most common today
```

---

## 💻 Code Examples

### Example 1: From Named Method to Lambda

```csharp
using System;

delegate int MathOperation(int x, int y);

class Program
{
    // C# 1.0: Named method
    static int Add(int a, int b) => a + b;
    
    static void Main()
    {
        // 1. Named method delegate
        MathOperation op1 = Add;
        Console.WriteLine($"Named method: {op1(5, 3)}");
        
        // 2. Anonymous method (C# 2.0)
        MathOperation op2 = delegate(int a, int b)
        {
            return a + b;
        };
        Console.WriteLine($"Anonymous method: {op2(5, 3)}");
        
        // 3. Lambda expression (C# 3.0)
        MathOperation op3 = (int a, int b) => { return a + b; };
        Console.WriteLine($"Lambda (explicit types): {op3(5, 3)}");
        
        // 4. Lambda with type inference
        MathOperation op4 = (a, b) => a + b;
        Console.WriteLine($"Lambda (inferred): {op4(5, 3)}");
    }
}
```

#### Output:
```
Named method: 8
Anonymous method: 8
Lambda (explicit types): 8
Lambda (inferred): 8
```

---

### Example 2: Anonymous Method Syntax

```csharp
using System;

delegate void Printer(string message);
delegate int Calculator(int x, int y);

class Program
{
    static void Main()
    {
        // Anonymous method with parameters
        Printer print = delegate(string msg)
        {
            Console.WriteLine($"Message: {msg}");
        };
        print("Hello!");
        
        // Anonymous method with return value
        Calculator calc = delegate(int a, int b)
        {
            int result = a + b;
            return result;
        };
        Console.WriteLine($"Sum: {calc(10, 20)}");
        
        // Anonymous method accessing outer variable (closure)
        int multiplier = 5;
        Calculator multiply = delegate(int a, int b)
        {
            return (a + b) * multiplier;  // Captures 'multiplier'
        };
        Console.WriteLine($"Multiplied: {multiply(3, 4)}");  // (3+4)*5 = 35
    }
}
```

---

### Example 3: Lambda Expression Syntax

```csharp
using System;

class Program
{
    static void Main()
    {
        // Expression lambda (single expression, implicit return)
        Func<int, int> square = x => x * x;
        Console.WriteLine($"Square: {square(5)}");  // 25
        
        // Expression lambda with multiple parameters
        Func<int, int, int> add = (a, b) => a + b;
        Console.WriteLine($"Add: {add(3, 4)}");  // 7
        
        // Statement lambda (code block with explicit return)
        Func<int, int, int> max = (a, b) =>
        {
            if (a > b)
                return a;
            else
                return b;
        };
        Console.WriteLine($"Max: {max(10, 20)}");  // 20
        
        // Lambda with no parameters
        Action greet = () => Console.WriteLine("Hello!");
        greet();  // Hello!
        
        // Lambda with single parameter (no parentheses needed)
        Func<int, bool> isEven = n => n % 2 == 0;
        Console.WriteLine($"Is 4 even? {isEven(4)}");  // True
    }
}
```

---

### Example 4: Built-in Delegate Types

```csharp
using System;

class Program
{
    static void Main()
    {
        // Action: void return type, 0-16 parameters
        Action sayHello = () => Console.WriteLine("Hello!");
        Action<string> greet = name => Console.WriteLine($"Hello, {name}!");
        Action<int, int> showSum = (a, b) => Console.WriteLine($"Sum: {a + b}");
        
        sayHello();           // Hello!
        greet("Alice");       // Hello, Alice!
        showSum(5, 3);        // Sum: 8
        
        // Func: returns value, 0-16 parameters (last type is return type)
        Func<int> getNumber = () => 42;
        Func<int, int> double_ = n => n * 2;
        Func<int, int, int> multiply = (a, b) => a * b;
        
        Console.WriteLine(getNumber());       // 42
        Console.WriteLine(double_(5));        // 10
        Console.WriteLine(multiply(3, 4));    // 12
        
        // Predicate: returns bool, 1 parameter
        Predicate<int> isPositive = n => n > 0;
        Console.WriteLine(isPositive(5));     // True
        Console.WriteLine(isPositive(-3));    // False
    }
}
```

---

### Example 5: Lambda with Event Handlers

```csharp
using System;
using System.Windows.Forms;

class Program
{
    static void Main()
    {
        Button button = new Button();
        
        // Traditional: Named method handler
        button.Click += Button_Click;
        
        // Lambda: Inline handler
        button.Click += (sender, e) =>
        {
            Console.WriteLine("Button clicked!");
        };
        
        // One-liner lambda
        button.MouseEnter += (s, e) => Console.WriteLine("Mouse entered");
    }
    
    static void Button_Click(object sender, EventArgs e)
    {
        Console.WriteLine("Button clicked (named method)");
    }
}
```

---

### Example 6: Closures (Capturing Variables)

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        int factor = 10;
        
        // Lambda captures 'factor' from outer scope
        Func<int, int> multiplier = n => n * factor;
        
        Console.WriteLine(multiplier(5));  // 50
        
        factor = 20;  // Change captured variable
        Console.WriteLine(multiplier(5));  // 100 (uses current value!)
        
        // Common closure pitfall with loops
        List<Action> actions = new List<Action>();
        
        for (int i = 0; i < 3; i++)
        {
            actions.Add(() => Console.WriteLine(i));  // Captures 'i'
        }
        
        // All print 3! (final value of i after loop)
        Console.WriteLine("Closure pitfall:");
        foreach (var action in actions)
            action();  // 3, 3, 3
        
        // Fix: Create local copy
        actions.Clear();
        for (int i = 0; i < 3; i++)
        {
            int local = i;  // Local copy
            actions.Add(() => Console.WriteLine(local));
        }
        
        Console.WriteLine("Fixed with local copy:");
        foreach (var action in actions)
            action();  // 0, 1, 2
    }
}
```

#### Output:
```
50
100
Closure pitfall:
3
3
3
Fixed with local copy:
0
1
2
```

---

### Example 7: LINQ with Lambdas

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Employee
{
    public string Name { get; set; }
    public int Salary { get; set; }
}

class Program
{
    static void Main()
    {
        List<Employee> employees = new List<Employee>
        {
            new Employee { Name = "Raj", Salary = 6000 },
            new Employee { Name = "Mona", Salary = 7000 },
            new Employee { Name = "Het", Salary = 3000 }
        };
        
        // Find: Returns first match
        Employee found = employees.Find(e => e.Salary == 6000);
        Console.WriteLine($"Found: {found.Name}");  // Raj
        
        // FindAll: Returns all matches
        List<Employee> highEarners = employees.FindAll(e => e.Salary >= 6000);
        Console.WriteLine($"High earners: {highEarners.Count}");  // 2
        
        // LINQ Where (similar to FindAll)
        var filtered = employees.Where(e => e.Salary > 5000);
        
        // LINQ Select (projection)
        var names = employees.Select(e => e.Name);
        Console.WriteLine($"Names: {string.Join(", ", names)}");
        
        // LINQ OrderBy
        var sorted = employees.OrderByDescending(e => e.Salary);
        foreach (var emp in sorted)
            Console.WriteLine($"{emp.Name}: {emp.Salary}");
    }
}
```

---

## 📊 Lambda Syntax Summary

| Scenario | Syntax | Example |
|----------|--------|---------|
| No parameters | `() => expression` | `() => 42` |
| One parameter | `x => expression` | `x => x * 2` |
| Multiple parameters | `(x, y) => expression` | `(a, b) => a + b` |
| Explicit types | `(int x) => expression` | `(int x) => x * 2` |
| Statement block | `() => { statements; }` | `() => { return 42; }` |

---

## ⚡ Built-in Delegate Types

| Type | Signature | Use Case |
|------|-----------|----------|
| `Action` | `void ()` | No params, no return |
| `Action<T>` | `void (T)` | One param, no return |
| `Action<T1,T2>` | `void (T1, T2)` | Two params, no return |
| `Func<TResult>` | `TResult ()` | No params, returns value |
| `Func<T,TResult>` | `TResult (T)` | One param, returns value |
| `Predicate<T>` | `bool (T)` | One param, returns bool |

---

## ❌ Common Mistakes

### Mistake 1: Closure captures variable, not value
```csharp
int x = 10;
Func<int> f = () => x;
x = 20;
Console.WriteLine(f());  // 20, not 10!
```

### Mistake 2: Forgetting return in statement lambda
```csharp
Func<int, int> bad = x => { x * 2; };     // No return - compile error
Func<int, int> good = x => { return x * 2; };  // Correct
```

---

## 📝 Practice Questions

1. **Convert to lambda: `delegate(int x) { return x * x; }`**
<details>
<summary>Answer</summary>
`x => x * x`
</details>

2. **What's the output?**
```csharp
int n = 5;
Func<int> f = () => n * 2;
n = 10;
Console.WriteLine(f());
```
<details>
<summary>Answer</summary>
`20` - Lambda captures variable reference, not value.
</details>

---

## 🔗 Related Topics
- [09_Delegates_Fundamentals.md](09_Delegates_Fundamentals.md) - Delegate basics
- [11_Events_Complete_Guide.md](11_Events_Complete_Guide.md) - Event handlers
- [19_Generic_NonGeneric_Delegates.md](19_Generic_NonGeneric_Delegates.md) - Func, Action, Predicate
