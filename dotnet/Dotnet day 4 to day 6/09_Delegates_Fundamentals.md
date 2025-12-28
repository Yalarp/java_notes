# Delegates in C# - Fundamentals

## 📚 Introduction

A **delegate** is a type-safe function pointer in C#. It holds a reference to a method with a specific signature and return type. Delegates are the foundation for events, callbacks, and LINQ.

### Why Delegates?
- Enable callback patterns
- Support event-driven programming
- Allow methods to be passed as parameters
- Foundation for lambda expressions

---

## 🎯 Learning Objectives

- Understand delegate declaration and instantiation
- Master delegate invocation
- Learn delegate with static and instance methods
- Understand type safety in delegates

---

## 🔍 Conceptual Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      DELEGATE                                    │
├─────────────────────────────────────────────────────────────────┤
│  Declaration:  delegate ReturnType Name(Parameters);           │
│  Purpose:      Type-safe method reference                       │
│  Inheritance:  Derived from System.Delegate                     │
│  Key Feature:  Method signature must match delegate signature   │
└─────────────────────────────────────────────────────────────────┘
```

### Delegate vs Function Pointer (C/C++)

| Feature | C/C++ Function Pointer | C# Delegate |
|---------|----------------------|-------------|
| Type Safety | None | Full |
| Can point to | Any function | Only matching signature |
| Instance methods | Complex | Easy |
| Multiple methods | Manual array | Built-in (multicast) |

---

## 💻 Code Examples

### Example 1: Basic Delegate Declaration and Use

```csharp
using System;

// Step 1: Declare delegate type
delegate int MyMath(int n);

class DelegateDemo
{
    // Methods matching delegate signature
    public static int Square(int s)
    {
        return s * s;
    }
    
    public static int Cube(int c)
    {
        return c * c * c;
    }
    
    static void Main()
    {
        // Step 2: Create delegate instance pointing to Square
        MyMath ms = new MyMath(Square);
        
        // Step 3: Invoke delegate (calls Square)
        int result = ms(4);
        Console.WriteLine($"Square of 4 = {result}");  // 16
        
        // Reassign to different method
        ms = new MyMath(Cube);
        result = ms(5);
        Console.WriteLine($"Cube of 5 = {result}");    // 125
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4 | `delegate int MyMath(int n);` | Declares delegate type: returns int, takes int |
| 9-12 | `public static int Square(int s)` | Method matching delegate signature |
| 22 | `MyMath ms = new MyMath(Square);` | Creates delegate pointing to Square |
| 25 | `int result = ms(4);` | Invokes delegate (calls Square(4)) |
| 29 | `ms = new MyMath(Cube);` | Reassigns to different method |

#### Memory Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│  Delegate Declaration: delegate int MyMath(int n);             │
│                                                                  │
│  This creates a CLASS (yes, delegates are classes!)            │
│  that can hold reference to any method with:                    │
│    - Return type: int                                           │
│    - Parameters: (int)                                          │
└─────────────────────────────────────────────────────────────────┘

ms (delegate instance)
┌─────────────────┐
│ Target: null    │  (static method has no instance)
│ Method: Square  │──────► public static int Square(int s)
└─────────────────┘

After reassignment:
┌─────────────────┐
│ Target: null    │
│ Method: Cube    │──────► public static int Cube(int c)
└─────────────────┘
```

---

### Example 2: Simplified Delegate Syntax

```csharp
using System;

delegate int MyMath(int n);

class DelegateDemo
{
    public static int Square(int s) => s * s;
    public static int Cube(int c) => c * c * c;
    
    static void Main()
    {
        // Simplified syntax (no 'new MyMath()')
        MyMath ms = Square;
        Console.WriteLine(ms(4));  // 16
        
        ms = Cube;
        Console.WriteLine(ms(5));  // 125
    }
}
```

---

### Example 3: Delegate with Instance Methods

```csharp
using System;

delegate int MyMath(int n);

class Calculator
{
    private int multiplier;
    
    public Calculator(int mult)
    {
        multiplier = mult;
    }
    
    // Instance method
    public int Multiply(int n)
    {
        return n * multiplier;
    }
}

class Program
{
    static void Main()
    {
        Calculator calc1 = new Calculator(2);
        Calculator calc2 = new Calculator(10);
        
        // Delegate to instance method
        MyMath del1 = new MyMath(calc1.Multiply);
        MyMath del2 = new MyMath(calc2.Multiply);
        
        Console.WriteLine(del1(5));  // 10 (5 * 2)
        Console.WriteLine(del2(5));  // 50 (5 * 10)
    }
}
```

#### Memory Diagram for Instance Method Delegate

```
calc1                                calc2
┌─────────────────┐                 ┌─────────────────┐
│ multiplier = 2  │                 │ multiplier = 10 │
└─────────────────┘                 └─────────────────┘
         ▲                                   ▲
         │                                   │
del1     │                          del2     │
┌────────┴────────┐                ┌────────┴────────┐
│ Target: calc1   │                │ Target: calc2   │
│ Method: Multiply│                │ Method: Multiply│
└─────────────────┘                └─────────────────┘
```

---

### Example 4: Delegate as Method Parameter (Callback)

```csharp
using System;

delegate void StringOperation(string str);

class StringProcessor
{
    // Method accepting delegate as parameter
    public void ProcessStrings(string[] strings, StringOperation operation)
    {
        foreach (string s in strings)
        {
            operation(s);  // Callback
        }
    }
}

class Program
{
    static void PrintUpper(string s)
    {
        Console.WriteLine(s.ToUpper());
    }
    
    static void PrintLower(string s)
    {
        Console.WriteLine(s.ToLower());
    }
    
    static void Main()
    {
        StringProcessor processor = new StringProcessor();
        string[] names = { "Alice", "Bob", "Charlie" };
        
        Console.WriteLine("Uppercase:");
        processor.ProcessStrings(names, PrintUpper);
        
        Console.WriteLine("Lowercase:");
        processor.ProcessStrings(names, PrintLower);
    }
}
```

#### Output:
```
Uppercase:
ALICE
BOB
CHARLIE
Lowercase:
alice
bob
charlie
```

#### Execution Flow

```
ProcessStrings(names, PrintUpper) called
    │
    ├─► Loop iteration 1: operation("Alice") → PrintUpper("Alice") → "ALICE"
    ├─► Loop iteration 2: operation("Bob") → PrintUpper("Bob") → "BOB"
    └─► Loop iteration 3: operation("Charlie") → PrintUpper("Charlie") → "CHARLIE"
```

---

### Example 5: Delegate Return Values

```csharp
using System;

delegate string StringTransform(string input);

class Program
{
    static string Reverse(string s)
    {
        char[] arr = s.ToCharArray();
        Array.Reverse(arr);
        return new string(arr);
    }
    
    static string AddExclamation(string s)
    {
        return s + "!";
    }
    
    static void Main()
    {
        StringTransform transform = Reverse;
        string result = transform("Hello");
        Console.WriteLine(result);  // olleH
        
        transform = AddExclamation;
        result = transform("Hello");
        Console.WriteLine(result);  // Hello!
    }
}
```

---

### Example 6: Type Safety Demonstration

```csharp
using System;

delegate int IntOperation(int n);
delegate double DoubleOperation(double n);

class Program
{
    static int Square(int x) => x * x;
    static double Half(double x) => x / 2;
    
    static void Main()
    {
        IntOperation intOp = Square;      // OK - signatures match
        DoubleOperation doubleOp = Half;  // OK - signatures match
        
        // intOp = Half;   // ERROR: Cannot convert double(double) to int(int)
        // doubleOp = Square;  // ERROR: Cannot convert int(int) to double(double)
    }
}
```

---

## 📊 Delegate Internals

When you declare a delegate, the compiler creates a class:

```csharp
// Your code:
delegate int MyMath(int n);

// Compiler generates something like:
public sealed class MyMath : System.MulticastDelegate
{
    public MyMath(object target, IntPtr method) { }
    public int Invoke(int n) { }
    public IAsyncResult BeginInvoke(int n, AsyncCallback callback, object state) { }
    public int EndInvoke(IAsyncResult result) { }
}
```

---

## ⚡ Key Points to Remember

| Concept | Description |
|---------|-------------|
| Declaration | `delegate ReturnType Name(Parameters);` |
| Instantiation | `Name del = new Name(MethodName);` or `Name del = MethodName;` |
| Invocation | `del(arguments);` or `del.Invoke(arguments);` |
| Type safety | Method signature must exactly match delegate |
| Instance methods | Delegate stores object reference (Target) |
| Static methods | Target is null |

---

## ❌ Common Mistakes

### Mistake 1: Mismatched signatures
```csharp
delegate int MyDel(int x);
void SomeMethod(int x) { }  // Returns void, not int
MyDel del = SomeMethod;     // ERROR!
```

### Mistake 2: Calling without null check
```csharp
MyDel del = null;
del(5);  // NullReferenceException!
// Use: del?.Invoke(5);
```

### Mistake 3: Forgetting parentheses for invocation
```csharp
MyDel del = Square;
Console.WriteLine(del);     // Prints delegate type, not result
Console.WriteLine(del(5));  // Correct: prints 25
```

---

## 📝 Practice Questions

1. **What's the output?**
```csharp
delegate int Op(int x);
static int Double(int x) => x * 2;
static int Triple(int x) => x * 3;

Op op = Double;
op = Triple;
Console.WriteLine(op(5));
```
<details>
<summary>Answer</summary>
Output: `15` - The delegate was reassigned to Triple, so Triple(5) = 15.
</details>

2. **True or False: A delegate can point to both static and instance methods.**
<details>
<summary>Answer</summary>
True. For instance methods, it also stores the object reference in Target.
</details>

---

## 🔗 Related Topics
- [10_Multicast_Delegates.md](10_Multicast_Delegates.md) - Multiple method invocation
- [11_Events_Complete_Guide.md](11_Events_Complete_Guide.md) - Event pattern
- [12_Anonymous_Methods_Lambda.md](12_Anonymous_Methods_Lambda.md) - Lambda expressions
