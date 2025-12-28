# C# 7 - Ref Returns and Local Functions

## 📚 Introduction

C# 7 introduced ref returns (returning references instead of values) and local functions (functions declared inside methods). These features enable performance optimization and better code organization.

---

## 🎯 Learning Objectives

- Understand ref returns for performance-critical scenarios
- Use local functions for encapsulation within methods
- Know when to apply each feature

---

## 📖 Part 1: Ref Returns

```
┌────────────────────────────────────────────────────────────────┐
│                      Ref Returns (C# 7)                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Normal Return:                                                │
│  int GetValue() → Returns COPY of value                        │
│                                                                 │
│  Ref Return:                                                    │
│  ref int GetRef() → Returns REFERENCE to variable              │
│                     Can modify original through reference      │
│                                                                 │
│  Use Case:                                                      │
│  • Performance-critical code                                   │
│  • Avoid copying large structs                                 │
│  • Direct modification of array/collection elements            │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Ref Returns Example

```csharp
using System;

class Program
{
    static void Main()
    {
        int[] numbers = { 1, 5, 3, 8, 2 };
        Console.WriteLine($"Before: [{string.Join(", ", numbers)}]");
        
        // Get reference to largest element
        ref int largest = ref FindLargest(numbers);
        
        Console.WriteLine($"Largest value: {largest}");
        
        // Modify through reference - modifies array!
        largest = 100;
        
        Console.WriteLine($"After:  [{string.Join(", ", numbers)}]");
        // Output: After: [1, 5, 3, 100, 2]
    }
    
    // Returns a reference to array element
    static ref int FindLargest(int[] numbers)
    {
        int indexOfLargest = 0;
        
        for (int i = 1; i < numbers.Length; i++)
        {
            if (numbers[i] > numbers[indexOfLargest])
                indexOfLargest = i;
        }
        
        // ref return - returns reference to array element
        return ref numbers[indexOfLargest];
    }
}
```

### Execution Flow:

```
numbers = [1, 5, 3, 8, 2]
           ↓ FindLargest()
Find index of 8 (index 3)
           ↓ return ref numbers[3]
largest ────→ numbers[3] (reference, not copy)
           ↓ largest = 100
numbers[3] = 100
           ↓
numbers = [1, 5, 3, 100, 2]
```

---

## 📖 Part 2: Local Functions

```
┌────────────────────────────────────────────────────────────────┐
│                    Local Functions (C# 7)                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Definition: Functions declared INSIDE other methods           │
│                                                                 │
│  void OuterMethod()                                             │
│  {                                                              │
│      int LocalFunc(int x) => x * 2;  // Local function         │
│      Console.WriteLine(LocalFunc(5));                          │
│  }                                                              │
│                                                                 │
│  Benefits:                                                      │
│  • Encapsulation - only visible inside parent method          │
│  • Can access parent's variables (closure)                     │
│  • Better than lambdas for recursion                          │
│  • No delegate allocation overhead                             │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Local Functions Examples

```csharp
using System;

class Program
{
    static void Main()
    {
        // Example 1: Simple calculation
        Console.WriteLine(Calculate(10, 5));
        
        // Example 2: Validation with local function
        string result = ProcessInput("  hello123  ");
        Console.WriteLine(result);
        
        // Example 3: Recursive local function
        Console.WriteLine($"Factorial(5) = {Factorial(5)}");
    }
    
    // Example 1: Local function for helper logic
    static int Calculate(int x, int y)
    {
        // Local functions defined inside method
        int Add(int a, int b) => a + b;
        int Multiply(int a, int b) => a * b;
        
        // Use local functions
        int sum = Add(x, y);
        int product = Multiply(x, y);
        
        return sum + product;
    }
    
    // Example 2: Local function with closure
    static string ProcessInput(string input)
    {
        // Local function accessing outer variable
        string Clean(string s) => s.Trim().ToLower();
        
        bool IsValid(string s)
        {
            // Can access 'input' from outer scope
            return !string.IsNullOrEmpty(s) && s.Length > 0;
        }
        
        string cleaned = Clean(input);
        
        if (IsValid(cleaned))
            return $"Processed: {cleaned}";
        else
            return "Invalid input";
    }
    
    // Example 3: Recursive local function
    static int Factorial(int n)
    {
        // Local function for recursion
        int FactorialCore(int value, int accumulator)
        {
            if (value <= 1)
                return accumulator;
            return FactorialCore(value - 1, value * accumulator);
        }
        
        // Validate input, then call local function
        if (n < 0) throw new ArgumentException("Must be non-negative");
        return FactorialCore(n, 1);
    }
}
```

### Local Function vs Lambda:

```csharp
// Lambda (creates delegate, heap allocation)
Func<int, int> lambdaSquare = x => x * x;

// Local function (no delegate, no allocation)
int LocalSquare(int x) => x * x;

// Local functions are preferred when:
// - Used only within the method
// - Better for recursion
// - No delegate needed
```

---

## 📊 Feature Comparison

| Feature | Ref Returns | Local Functions |
|---------|-------------|-----------------|
| **Purpose** | Return reference | Encapsulate logic |
| **Performance** | Avoid copying | No delegate overhead |
| **Use case** | Large structs, arrays | Helper methods |
| **Syntax** | `ref int Method()` | `int Local() { }` |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **ref return** - Returns reference, not copy
2. **Can modify original** - Through returned reference
3. **Local functions** - Visible only in containing method
4. **Closure** - Local functions can access outer variables
5. **No allocation** - Local functions don't create delegates
6. **Recursion** - Local functions work well recursively

---

## 📝 Interview Questions

1. **When would you use ref returns?**
   - Performance-critical code with large structs
   - Direct modification of collection elements
   - Avoiding unnecessary copying

2. **Local function vs Lambda?**
   - Local function: No delegate allocation, better for recursion
   - Lambda: Can be passed as argument, stored in variable

---

## 🔗 Next Topic
Next: [36_CSharp8_Nullable_Reference.md](./36_CSharp8_Nullable_Reference.md) - Nullable Reference Types
