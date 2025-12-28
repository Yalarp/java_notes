# Method Parameters: ref, out, in, params

## Overview
C# provides special keywords to control how arguments are passed to methods. Understanding these keywords is essential for writing flexible and efficient code.

---

## 1. Default: Pass by Value

### How It Works
By default, arguments are passed **by value**, meaning a copy is passed to the method.

```csharp
void Modify(int x)
{
    x = 100;  // Modifies local copy only
    Console.WriteLine($"Inside method: x = {x}");
}

int num = 10;
Modify(num);
Console.WriteLine($"After method: num = {num}");

// Output:
// Inside method: x = 100
// After method: num = 10  (unchanged!)
```

### Memory Diagram

```
Before and During Method Call:

Stack
┌─────────────────────────┐
│  Main's num = 10        │  (Original variable)
├─────────────────────────┤
│  Modify's x = 100       │  (Copy - separate memory)
└─────────────────────────┘
```

---

## 2. ref Keyword (Pass by Reference)

### What It Does
Passes the **actual variable** to the method, not a copy. Changes inside the method affect the original variable.

### Syntax

```csharp
void Method(ref int x) { }

int num = 10;
Method(ref num);  // Must use 'ref' at call site
```

### Rules
1. Variable **must be initialized** before passing
2. Use `ref` keyword at **both** declaration and call site

### Example

```csharp
void Modify(ref int x)
{
    x = 100;  // Modifies original variable!
    Console.WriteLine($"Inside method: x = {x}");
}

int num = 10;
Modify(ref num);
Console.WriteLine($"After method: num = {num}");

// Output:
// Inside method: x = 100
// After method: num = 100  (changed!)
```

### Swap Example

```csharp
void Swap(ref int a, ref int b)
{
    int temp = a;
    a = b;
    b = temp;
}

int x = 10, y = 20;
Console.WriteLine($"Before: x = {x}, y = {y}");
Swap(ref x, ref y);
Console.WriteLine($"After: x = {x}, y = {y}");

// Output:
// Before: x = 10, y = 20
// After: x = 20, y = 10
```

### Memory Diagram (ref)

```
Stack
┌─────────────────────────┐
│  Main's num = 100       │ ← Both point to same memory!
├─────────────────────────┤
│  x (ref to num)     ────┼──┘
└─────────────────────────┘
```

---

## 3. out Keyword (Output Parameter)

### What It Does
Like `ref`, but the variable **doesn't need to be initialized** before the call. The method **must assign** a value before returning.

### Syntax

```csharp
void Method(out int result) { result = 42; }

int value;  // No initialization needed
Method(out value);
```

### Rules
1. Variable **doesn't need initialization** before passing
2. Method **must assign** a value before returning
3. Use `out` keyword at **both** declaration and call site

### Example

```csharp
void GetMinMax(int[] arr, out int min, out int max)
{
    if (arr == null || arr.Length == 0)
        throw new ArgumentException("Array cannot be empty");
    
    min = arr[0];  // Must assign both 'out' parameters
    max = arr[0];
    
    foreach (int n in arr)
    {
        if (n < min) min = n;
        if (n > max) max = n;
    }
}

int[] numbers = { 5, 2, 8, 1, 9, 3 };
int minimum, maximum;  // Not initialized
GetMinMax(numbers, out minimum, out maximum);

Console.WriteLine($"Min: {minimum}, Max: {maximum}");
// Output: Min: 1, Max: 9
```

### Inline Declaration (C# 7+)

```csharp
// Declare variable inline in the call
GetMinMax(numbers, out int min, out int max);
Console.WriteLine($"Min: {min}, Max: {max}");

// Use discard (_) if you don't need a value
GetMinMax(numbers, out _, out int max);  // Ignore min
```

### Common Pattern: TryParse

```csharp
// TryParse returns bool and outputs the parsed value
string input = "42";

if (int.TryParse(input, out int result))
{
    Console.WriteLine($"Parsed: {result}");
}
else
{
    Console.WriteLine("Invalid number");
}

// Without using the result:
if (int.TryParse(input, out _))
{
    Console.WriteLine("Valid number");
}
```

---

## 4. in Keyword (Read-Only Reference, C# 7.2+)

### What It Does
Passes a **read-only reference**. The method cannot modify the parameter.

### Why Use It?
- Avoid copying large structs (performance)
- Guarantee the value won't be modified

### Syntax

```csharp
void PrintPoint(in Point p)
{
    // p.X = 10;  // ERROR: Cannot modify 'in' parameter
    Console.WriteLine($"Point: ({p.X}, {p.Y})");
}

Point point = new Point(5, 10);
PrintPoint(in point);  // 'in' keyword optional at call site
PrintPoint(point);      // Also works
```

### Example

```csharp
struct LargeStruct
{
    public double A, B, C, D, E, F, G, H;
    
    public LargeStruct(double val)
    {
        A = B = C = D = E = F = G = H = val;
    }
    
    public double Sum => A + B + C + D + E + F + G + H;
}

// Without 'in': copies entire struct (expensive)
void ProcessByValue(LargeStruct data)
{
    Console.WriteLine($"Sum: {data.Sum}");
}

// With 'in': passes reference, no copy (efficient)
void ProcessByRef(in LargeStruct data)
{
    Console.WriteLine($"Sum: {data.Sum}");
    // data.A = 100;  // ERROR: Cannot modify
}

LargeStruct big = new LargeStruct(10);
ProcessByRef(in big);  // No copy, read-only
```

### Rules for `in`

1. Cannot modify the parameter
2. Best for **large value types** (structs)
3. `in` keyword is **optional** at call site

---

## 5. params Keyword (Variable Arguments)

### What It Does
Allows passing a **variable number of arguments** as an array.

### Syntax

```csharp
void Method(params int[] numbers) { }

Method(1, 2, 3);           // Individual arguments
Method(1, 2, 3, 4, 5);     // Any number
Method();                   // Zero arguments
Method(new int[] {1,2,3}); // Pass array directly
```

### Rules
1. Must be the **last parameter**
2. Only **one params** per method
3. Can pass **zero or more** arguments

### Example

```csharp
int Sum(params int[] numbers)
{
    int total = 0;
    foreach (int n in numbers)
        total += n;
    return total;
}

Console.WriteLine(Sum(1, 2, 3));           // 6
Console.WriteLine(Sum(1, 2, 3, 4, 5));     // 15
Console.WriteLine(Sum());                   // 0

// With other parameters
void PrintMessage(string prefix, params object[] items)
{
    Console.Write(prefix + ": ");
    foreach (var item in items)
        Console.Write(item + " ");
    Console.WriteLine();
}

PrintMessage("Items", 1, "two", 3.0, true);
// Output: Items: 1 two 3 True
```

### Practical Example: String.Format

```csharp
// String.Format uses params internally:
// public static string Format(string format, params object[] args)

string result = string.Format("Name: {0}, Age: {1}, City: {2}", 
                              "Raj", 25, "Mumbai");
Console.WriteLine(result);
// Output: Name: Raj, Age: 25, City: Mumbai
```

---

## 6. Comparison Table

| Keyword | Must Initialize? | Must Assign in Method? | Can Modify? | Use Case |
|---------|-----------------|------------------------|-------------|----------|
| (none) | Yes | No | No (copy) | Pass value |
| `ref` | Yes | No | Yes | Modify caller's variable |
| `out` | No | Yes | Yes | Return multiple values |
| `in` | Yes | No | No | Large struct (readonly) |
| `params` | N/A | N/A | N/A | Variable arguments |

---

## 7. Combining Parameters

```csharp
// Can combine different parameter types
void Process(
    int value,              // Regular
    ref int refValue,       // By reference
    out int outValue,       // Output
    in int inValue,         // Readonly reference
    params string[] items)  // Variable args (must be last)
{
    Console.WriteLine($"value: {value}");
    refValue *= 2;         // Modify ref
    outValue = 100;        // Must assign out
    // inValue = 10;       // Cannot modify in
    
    foreach (var item in items)
        Console.WriteLine($"Item: {item}");
}

int a = 10, b = 20, c;
Process(a, ref b, out c, in a, "one", "two", "three");
Console.WriteLine($"b = {b}, c = {c}");  // b = 40, c = 100
```

---

## 8. ref Returns and ref Locals (C# 7+)

### Return a Reference

```csharp
class Matrix
{
    private int[,] data = new int[3, 3];
    
    // Return reference to element
    public ref int GetElement(int row, int col)
    {
        return ref data[row, col];
    }
}

Matrix m = new Matrix();

// Get reference and modify directly
ref int element = ref m.GetElement(1, 1);
element = 42;  // Modifies the matrix directly!

Console.WriteLine(m.GetElement(1, 1));  // 42
```

---

## 9. Complete Example

```csharp
using System;

class ParameterDemo
{
    // Regular parameter (by value)
    static void ByValue(int x)
    {
        x = x * 2;
        Console.WriteLine($"  Inside ByValue: {x}");
    }
    
    // ref parameter (by reference)
    static void ByRef(ref int x)
    {
        x = x * 2;
        Console.WriteLine($"  Inside ByRef: {x}");
    }
    
    // out parameter (output only)
    static void GetValues(out int a, out int b, out int c)
    {
        a = 10;
        b = 20;
        c = 30;
    }
    
    // in parameter (read-only reference)
    static void ReadOnly(in int x)
    {
        Console.WriteLine($"  Inside ReadOnly: {x}");
        // x = x * 2;  // ERROR!
    }
    
    // params (variable arguments)
    static double Average(params double[] numbers)
    {
        if (numbers.Length == 0) return 0;
        
        double sum = 0;
        foreach (double n in numbers)
            sum += n;
        return sum / numbers.Length;
    }
    
    static void Main()
    {
        Console.WriteLine("=== By Value ===");
        int num1 = 10;
        ByValue(num1);
        Console.WriteLine($"  After call: {num1}");  // Still 10
        
        Console.WriteLine("\n=== By Ref ===");
        int num2 = 10;
        ByRef(ref num2);
        Console.WriteLine($"  After call: {num2}");  // Now 20
        
        Console.WriteLine("\n=== Out ===");
        GetValues(out int a, out int b, out int c);
        Console.WriteLine($"  Values: {a}, {b}, {c}");
        
        Console.WriteLine("\n=== In ===");
        int num3 = 100;
        ReadOnly(in num3);
        
        Console.WriteLine("\n=== Params ===");
        Console.WriteLine($"  Average(1, 2, 3) = {Average(1, 2, 3)}");
        Console.WriteLine($"  Average(1, 2, 3, 4, 5) = {Average(1, 2, 3, 4, 5)}");
        Console.WriteLine($"  Average() = {Average()}");
        
        Console.WriteLine("\n=== TryParse Pattern ===");
        if (int.TryParse("42", out int result))
            Console.WriteLine($"  Parsed: {result}");
    }
}
```

---

## Key Points Summary

1. **Default (by value)**: Pass a copy, original unchanged
2. **ref**: Pass reference, must initialize, can modify
3. **out**: Pass reference, don't initialize, must assign in method
4. **in**: Pass read-only reference, cannot modify (C# 7.2+)
5. **params**: Variable number of arguments, must be last
6. Use **ref/out** to return multiple values
7. Use **in** for large value types to avoid copying
8. Use **params** for flexible APIs

---

## Common Mistakes to Avoid

1. ❌ Forgetting `ref`/`out` at call site
2. ❌ Not initializing `ref` parameter before call
3. ❌ Not assigning `out` parameter in method
4. ❌ Trying to modify `in` parameter
5. ❌ Placing `params` before other parameters

---

## Practice Questions

1. What is the difference between ref and out?
2. When would you use the in keyword?
3. What are the rules for params?
4. Can you have multiple params in one method?
5. Does ref pass a copy or the actual variable?
6. Must an out parameter be initialized before the call?
