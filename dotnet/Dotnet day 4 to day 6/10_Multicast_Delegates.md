# Multicast Delegates in C#

## 📚 Introduction

A **multicast delegate** can hold references to multiple methods. When invoked, it calls all methods in its invocation list in order. All delegates in C# are multicast delegates (derived from `System.MulticastDelegate`).

---

## 🎯 Learning Objectives

- Understand multicast delegate concept
- Master += and -= operators for combining delegates
- Learn invocation list behavior
- Handle return values in multicast delegates

---

## 🔍 Conceptual Overview

```
┌─────────────────────────────────────────────────────────────────┐
│               MULTICAST DELEGATE                                 │
├─────────────────────────────────────────────────────────────────┤
│  Single invocation = Multiple method calls                       │
│  Methods called in order of addition                             │
│  All delegates inherit from MulticastDelegate                    │
│  Use void return type (best practice)                           │
│  +=/+  adds methods, -=/- removes methods                       │
└─────────────────────────────────────────────────────────────────┘
```

### Invocation List

```
delegate = Method1 + Method2 + Method3

When delegate() is called:
┌──────────┐    ┌──────────┐    ┌──────────┐
│ Method1  │───►│ Method2  │───►│ Method3  │
│ called   │    │ called   │    │ called   │
└──────────┘    └──────────┘    └──────────┘
```

---

## 💻 Code Examples

### Example 1: Basic Multicast Delegate

```csharp
using System;

// Declare delegate type (void return - best practice for multicast)
delegate void StrMod(string str);

class MulticastDemo
{
    // Method 1: Remove spaces
    static void RemoveSpaces(string s)
    {
        string temp = "";
        for (int i = 0; i < s.Length; i++)
        {
            if (s[i] != ' ')
                temp += s[i];
        }
        Console.WriteLine($"RemoveSpaces: {temp}");
    }
    
    // Method 2: Reverse string
    static void Reverse(string s)
    {
        string temp = "";
        for (int i = s.Length - 1; i >= 0; i--)
        {
            temp += s[i];
        }
        Console.WriteLine($"Reverse: {temp}");
    }
    
    public static void Main()
    {
        // Create individual delegate instances
        StrMod removeSp = RemoveSpaces;
        StrMod reverseStr = Reverse;
        
        // Combine into multicast delegate
        StrMod strOp;
        strOp = removeSp;       // First method
        strOp += reverseStr;    // Add second method
        
        string str = "This is a test";
        
        Console.WriteLine("Calling multicast delegate:");
        strOp(str);  // Calls BOTH methods
        
        Console.WriteLine("\nAfter removing RemoveSpaces:");
        strOp -= removeSp;  // Remove first method
        strOp(str);         // Now only calls Reverse
    }
}
```

#### Output:
```
Calling multicast delegate:
RemoveSpaces: Thisisatest
Reverse: tset a si sihT

After removing RemoveSpaces:
Reverse: tset a si sihT
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4 | `delegate void StrMod(string str);` | Void return type - best for multicast |
| 33 | `StrMod removeSp = RemoveSpaces;` | Single delegate pointing to RemoveSpaces |
| 37 | `strOp = removeSp;` | strOp points to RemoveSpaces |
| 38 | `strOp += reverseStr;` | Adds Reverse to invocation list |
| 43 | `strOp(str);` | Calls RemoveSpaces, then Reverse |
| 46 | `strOp -= removeSp;` | Removes RemoveSpaces from list |

#### Memory Diagram

```
AFTER strOp += reverseStr:

strOp
┌────────────────────────────────────────────┐
│              Invocation List               │
│  ┌──────────────┐    ┌──────────────┐     │
│  │ RemoveSpaces │ ──►│   Reverse    │     │
│  │   (index 0)  │    │  (index 1)   │     │
│  └──────────────┘    └──────────────┘     │
└────────────────────────────────────────────┘

AFTER strOp -= removeSp:

strOp
┌────────────────────────────────────────────┐
│              Invocation List               │
│  ┌──────────────┐                          │
│  │   Reverse    │                          │
│  │   (index 0)  │                          │
│  └──────────────┘                          │
└────────────────────────────────────────────┘
```

---

### Example 2: Multicast with Math Operations

```csharp
using System;

delegate void MyMath(int a, int b);

class MultiCastDemo
{
    internal static void Add(int x, int y)
    {
        Console.WriteLine($"Add: {x} + {y} = {x + y}");
    }
    
    internal static void Product(int x, int y)
    {
        Console.WriteLine($"Product: {x} * {y} = {x * y}");
    }
    
    static void Main()
    {
        MyMath ad = Add;
        MyMath pd = Product;
        
        // Combine
        MyMath strOp = ad;
        strOp += pd;
        
        Console.WriteLine("Calling both methods:");
        strOp(5, 6);  // Both methods called with same arguments
        
        Console.WriteLine("\nAfter removing Product:");
        strOp -= pd;
        strOp(5, 6);  // Only Add is called
    }
}
```

#### Output:
```
Calling both methods:
Add: 5 + 6 = 11
Product: 5 * 6 = 30

After removing Product:
Add: 5 + 6 = 11
```

---

### Example 3: Return Values in Multicast Delegates

```csharp
using System;

delegate int MyMath(int n);

class MultiCastReturnDemo
{
    public static int Square(int s)
    {
        int r = s * s;
        Console.WriteLine($"Square: {r}");
        return r;
    }
    
    public static int Cube(int c)
    {
        int r = c * c * c;
        Console.WriteLine($"Cube: {r}");
        return r;
    }
    
    static void Main()
    {
        MyMath ms = Square;
        ms += Cube;
        
        // When invoked, BOTH methods execute
        // But only LAST return value is kept!
        int result = ms(5);
        
        Console.WriteLine($"Final result: {result}");
    }
}
```

#### Output:
```
Square: 25
Cube: 125
Final result: 125  ← Only last method's return value!
```

**Important**: When a multicast delegate with a return type is invoked:
- ALL methods execute
- Only the LAST method's return value is returned
- This is why `void` is recommended for multicast delegates

---

### Example 4: GetInvocationList() - Access All Return Values

```csharp
using System;

delegate int MyMath(int n);

class Program
{
    public static int Square(int s) => s * s;
    public static int Cube(int c) => c * c * c;
    
    static void Main()
    {
        MyMath ms = Square;
        ms += Cube;
        
        // Get individual results using GetInvocationList()
        foreach (MyMath method in ms.GetInvocationList())
        {
            int result = method(3);
            Console.WriteLine($"{method.Method.Name}(3) = {result}");
        }
    }
}
```

#### Output:
```
Square(3) = 9
Cube(3) = 27
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 15 | `ms.GetInvocationList()` | Returns array of delegates |
| 16 | `foreach (MyMath method ...)` | Iterate through each delegate |
| 18 | `method(3)` | Invoke single method |
| 19 | `method.Method.Name` | Get method name via reflection |

---

### Example 5: Instance Methods in Multicast

```csharp
using System;

delegate void Logger(string message);

class ConsoleLogger
{
    public void Log(string msg) => Console.WriteLine($"[Console] {msg}");
}

class FileLogger
{
    public void Log(string msg) => Console.WriteLine($"[File] {msg}");
}

class Program
{
    static void Main()
    {
        ConsoleLogger console = new ConsoleLogger();
        FileLogger file = new FileLogger();
        
        Logger logger = console.Log;
        logger += file.Log;
        
        logger("Application started");
    }
}
```

#### Output:
```
[Console] Application started
[File] Application started
```

---

### Example 6: Delegate Chaining with + Operator

```csharp
using System;

delegate void Notify();

class Program
{
    static void Method1() => Console.WriteLine("Method1");
    static void Method2() => Console.WriteLine("Method2");
    static void Method3() => Console.WriteLine("Method3");
    
    static void Main()
    {
        // Chain using + operator (creates new delegate)
        Notify notify = Method1 + Method2 + Method3;
        notify();
        
        Console.WriteLine();
        
        // Remove using - operator
        notify = notify - Method2;
        notify();
    }
}
```

#### Output:
```
Method1
Method2
Method3

Method1
Method3
```

---

## 📊 Execution Flow

```
strOp(str) called where strOp = Method1 + Method2 + Method3

┌─────────────────────────────────────────────────────────────────┐
│                    INVOCATION SEQUENCE                           │
├─────────────────────────────────────────────────────────────────┤
│  1. strOp invoked with argument "str"                           │
│  2. Method1("str") executes first                               │
│  3. Method2("str") executes second                              │
│  4. Method3("str") executes third                               │
│  5. Return value (if any) from Method3 is returned              │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Key Points to Remember

| Concept | Description |
|---------|-------------|
| All delegates are multicast | Inherit from `MulticastDelegate` |
| `+=` operator | Adds method to invocation list |
| `-=` operator | Removes method from invocation list |
| Invocation order | Methods called in order of addition |
| Return value | Only last method's return value preserved |
| Best practice | Use `void` return type for multicast |
| `GetInvocationList()` | Returns array of individual delegates |

---

## ❌ Common Mistakes

### Mistake 1: Expecting all return values
```csharp
// Only last return value is kept!
int result = multicastDel(5);  // Result from LAST method only
```

### Mistake 2: Removing non-existent method
```csharp
del -= SomeMethod;  // No error, but does nothing if not in list
```

### Mistake 3: Not checking for null
```csharp
del -= lastMethod;
del();  // NullReferenceException if list is empty!
// Use: del?.Invoke();
```

---

## 📝 Practice Questions

1. **What's the output?**
```csharp
delegate void D();
static void A() => Console.Write("A");
static void B() => Console.Write("B");

D d = A;
d += B;
d += A;
d();
```
<details>
<summary>Answer</summary>
Output: `ABA` - Methods called in order they were added.
</details>

2. **After `d = d - A;` from above, what's the output of `d()`?**
<details>
<summary>Answer</summary>
Output: `BA` - Removes first instance of A from the list.
</details>

---

## 🔗 Related Topics
- [09_Delegates_Fundamentals.md](09_Delegates_Fundamentals.md) - Basic delegates
- [11_Events_Complete_Guide.md](11_Events_Complete_Guide.md) - Events (built on delegates)
- [12_Anonymous_Methods_Lambda.md](12_Anonymous_Methods_Lambda.md) - Lambda expressions
