# Type Casting and Conversion in C#

## Overview
Type casting (or type conversion) is the process of converting a value from one data type to another. This chapter covers implicit and explicit conversions, overflow handling, boxing/unboxing, and common conversion pitfalls.

---

## 1. Types of Conversions

### Overview

```
┌────────────────────────────────────────────────────────────────────┐
│                    TYPE CONVERSIONS IN C#                          │
├────────────────────────────────┬───────────────────────────────────┤
│     IMPLICIT (Widening)        │     EXPLICIT (Narrowing)          │
├────────────────────────────────┼───────────────────────────────────┤
│ • Automatic by compiler        │ • Manual using cast operator      │
│ • No data loss possible        │ • Potential data loss             │
│ • Smaller to larger type       │ • Larger to smaller type          │
│ • Safe conversion              │ • May throw exception             │
│                                │                                   │
│ int → long, float → double     │ double → int, long → int          │
└────────────────────────────────┴───────────────────────────────────┘
```

---

## 2. Implicit Conversion (Widening)

### Definition
Automatically performed by the compiler when there's no risk of data loss.

### Implicit Conversion Paths

```
byte → short → int → long → float → double
                ↓
              decimal
              
char → int → long → float → double
```

### Code Example

```csharp
using System;

class ImplicitConversionDemo
{
    static void Main()
    {
        byte byteValue = 100;
        short shortValue = byteValue;    // byte to short (implicit)
        int intValue = shortValue;        // short to int (implicit)
        long longValue = intValue;        // int to long (implicit)
        float floatValue = longValue;     // long to float (implicit)
        double doubleValue = floatValue;  // float to double (implicit)
        
        Console.WriteLine($"byte: {byteValue}");
        Console.WriteLine($"short: {shortValue}");
        Console.WriteLine($"int: {intValue}");
        Console.WriteLine($"long: {longValue}");
        Console.WriteLine($"float: {floatValue}");
        Console.WriteLine($"double: {doubleValue}");
    }
}
```

### Output:
```
byte: 100
short: 100
int: 100
long: 100
float: 100
double: 100
```

---

## 3. Explicit Conversion (Narrowing)

### Definition
Requires a cast operator because data loss is possible.

### Syntax

```csharp
(targetType) expression
```

### Code Example

```csharp
using System;

class ExplicitConversionDemo
{
    static void Main()
    {
        double doubleValue = 123.456;
        
        // ❌ This will NOT compile (implicit narrowing not allowed)
        // int intValue = doubleValue;  // Error!
        
        // ✅ Explicit cast required
        int intValue = (int)doubleValue;
        
        Console.WriteLine($"double: {doubleValue}");  // 123.456
        Console.WriteLine($"int: {intValue}");        // 123 (fractional part lost)
        
        // Another example
        long bigNumber = 9876543210L;
        int truncated = (int)bigNumber;  // May overflow!
        
        Console.WriteLine($"long: {bigNumber}");
        Console.WriteLine($"int: {truncated}");  // Garbage value due to overflow
    }
}
```

---

## 4. Arithmetic Operations and Type Promotion

### The byte + byte = int Rule

> **Important**: When performing arithmetic operations on `byte`, `sbyte`, `short`, or `ushort`, the operands are automatically promoted to `int`.

```csharp
using System;

class TypePromotionDemo
{
    static void Main()
    {
        byte a = 10;
        byte b = 20;
        
        // ❌ This will NOT compile!
        // byte result = a + b;  // Error: Cannot implicitly convert int to byte
        
        // ✅ CORRECT approaches:
        
        // Option 1: Store in int
        int result1 = a + b;
        Console.WriteLine(result1);  // 30
        
        // Option 2: Explicit cast
        byte result2 = (byte)(a + b);
        Console.WriteLine(result2);  // 30
    }
}
```

### Why This Happens?
The CLR promotes smaller integer types to `int` for efficiency and to prevent intermediate overflow.

```csharp
byte a = 200;
byte b = 100;

// 200 + 100 = 300 which exceeds byte range (0-255)
// If result stayed as byte, we'd lose data
// So .NET promotes to int first

int result = a + b;  // 300 (safe)
byte truncated = (byte)(a + b);  // 44 (300 % 256 = 44)
```

---

## 5. Overflow Handling

### Default Behavior (Unchecked)

```csharp
int maxInt = int.MaxValue;  // 2147483647
int overflow = maxInt + 1;   // Wraps to -2147483648 (silent overflow!)

Console.WriteLine(overflow);  // -2147483648
```

### The `checked` Keyword

Forces the runtime to throw an `OverflowException` when overflow occurs.

```csharp
using System;

class CheckedDemo
{
    static void Main()
    {
        int maxInt = int.MaxValue;
        
        try
        {
            // checked block - throws exception on overflow
            int result = checked(maxInt + 1);
            Console.WriteLine(result);
        }
        catch (OverflowException ex)
        {
            Console.WriteLine("Overflow detected!");
            Console.WriteLine(ex.Message);
        }
        
        // Or use checked block for multiple operations
        try
        {
            checked
            {
                int a = int.MaxValue;
                int b = 1;
                int sum = a + b;  // Throws OverflowException
            }
        }
        catch (OverflowException)
        {
            Console.WriteLine("Overflow in checked block!");
        }
    }
}
```

### Byte Overflow Example

```csharp
byte a = 200;
byte b = 100;

// Without checked - silent overflow
byte result1 = (byte)(a + b);  // 44 (wraps around)

// With checked - throws exception
try
{
    byte result2 = checked((byte)(a + b));
}
catch (OverflowException)
{
    Console.WriteLine("Byte overflow!");  // This executes
}
```

### The `unchecked` Keyword

Explicitly allows overflow (default behavior):

```csharp
int result = unchecked(int.MaxValue + 1);  // -2147483648 (no exception)
```

---

## 6. Boxing and Unboxing

### Boxing (Value Type → Object)

```csharp
int number = 42;
object boxed = number;  // Boxing: value copied to heap

Console.WriteLine(boxed);  // 42
```

### Memory Diagram

```
BEFORE BOXING:
Stack
┌─────────┐
│ number  │
│   42    │
└─────────┘

AFTER BOXING:
Stack                Heap
┌─────────┐         ┌───────────┐
│ boxed   │────────>│    42     │
│  (ref)  │         │  (boxed)  │
└─────────┘         └───────────┘
```

### Unboxing (Object → Value Type)

```csharp
object boxed = 42;
int unboxed = (int)boxed;  // Unboxing: explicit cast required

Console.WriteLine(unboxed);  // 42
```

### Unboxing Rules

```csharp
object boxed = 42;

// ✅ CORRECT: Unbox to same type
int correct = (int)boxed;

// ❌ WRONG: Cannot unbox to different type directly
// double wrong = (double)boxed;  // InvalidCastException!

// ✅ CORRECT: Convert after unboxing
double correct2 = (double)(int)boxed;  // First unbox, then convert
```

---

## 7. Type Conversion Methods

### Using Implicit Boxing

```csharp
// Everything can be assigned to object
int i = 10;
object o = i;  // Boxing

string s = "Hello";
object o2 = s;  // Reference stored (no boxing for reference types)
```

### Using new Keyword with Value Types

```csharp
// These are equivalent:
int a = 0;
int b = new int();  // Also creates int with default value 0

// new with value types:
// 1. Allocates on stack
// 2. Initializes to default value
// 3. Returns the value (not reference)
```

---

## 8. Common Conversion Scenarios

### Char to Int (ASCII/Unicode Value)

```csharp
char ch = 'A';
int asciiValue = ch;  // Implicit: 65

Console.WriteLine($"Character: {ch}");
Console.WriteLine($"ASCII value: {asciiValue}");
```

### Int to Char

```csharp
int value = 66;
char ch = (char)value;  // Explicit cast: 'B'

Console.WriteLine(ch);  // B
```

### Numeric to Boolean (NOT Allowed!)

```csharp
int number = 1;

// ❌ This is NOT allowed in C# (unlike C/C++)
// bool flag = number;  // Error!
// bool flag = (bool)number;  // Error!

// ✅ Must use comparison
bool flag = (number != 0);  // true
```

---

## 9. Floating-Point to Integer Conversion

### Truncation Behavior

```csharp
double d1 = 3.9;
int i1 = (int)d1;  // 3 (truncated, not rounded!)

double d2 = -3.9;
int i2 = (int)d2;  // -3 (truncated toward zero)

Console.WriteLine(i1);  // 3
Console.WriteLine(i2);  // -3
```

### Rounding Instead of Truncating

```csharp
double d = 3.9;

// Using Math.Round
int rounded = (int)Math.Round(d);  // 4

// Using Convert class (also rounds)
int converted = Convert.ToInt32(d);  // 4

Console.WriteLine(rounded);   // 4
Console.WriteLine(converted); // 4
```

---

## 10. Conversion Hierarchy

### Implicit Conversion Allowed

```
byte    → short, ushort, int, uint, long, ulong, float, double, decimal
sbyte   → short, int, long, float, double, decimal
short   → int, long, float, double, decimal
ushort  → int, uint, long, ulong, float, double, decimal
int     → long, float, double, decimal
uint    → long, ulong, float, double, decimal
long    → float, double, decimal
ulong   → float, double, decimal
float   → double
char    → ushort, int, uint, long, ulong, float, double, decimal
```

---

## 11. Loss of Precision

### float and double Can Lose Precision

```csharp
long bigNumber = 123456789123456789L;
float f = bigNumber;  // Implicit but loses precision!

Console.WriteLine(bigNumber);  // 123456789123456789
Console.WriteLine(f);          // 1.234568E+17 (approximation)

// decimal is exact for this range
decimal d = bigNumber;
Console.WriteLine(d);          // 123456789123456789 (exact)
```

---

## 12. Code Example: Complete Demonstration

```csharp
using System;

class ConversionDemo
{
    static void Main()
    {
        Console.WriteLine("=== IMPLICIT CONVERSION ===");
        byte b = 50;
        int i = b;  // byte to int (implicit)
        Console.WriteLine($"byte {b} → int {i}");
        
        Console.WriteLine("\n=== EXPLICIT CONVERSION ===");
        double d = 123.456;
        int truncated = (int)d;  // double to int (explicit)
        Console.WriteLine($"double {d} → int {truncated}");
        
        Console.WriteLine("\n=== BYTE ARITHMETIC ===");
        byte a = 100, c = 200;
        // byte sum = a + c;  // Error!
        int sum = a + c;  // Works (promotion to int)
        Console.WriteLine($"byte {a} + byte {c} = int {sum}");
        
        Console.WriteLine("\n=== OVERFLOW ===");
        byte x = 200, y = 100;
        byte wrapped = (byte)(x + y);  // 300 wraps to 44
        Console.WriteLine($"Overflow: {x} + {y} = {wrapped} (as byte)");
        
        Console.WriteLine("\n=== CHECKED OVERFLOW ===");
        try
        {
            byte result = checked((byte)(x + y));
        }
        catch (OverflowException)
        {
            Console.WriteLine("OverflowException caught!");
        }
        
        Console.WriteLine("\n=== BOXING/UNBOXING ===");
        int value = 42;
        object boxed = value;  // Boxing
        int unboxed = (int)boxed;  // Unboxing
        Console.WriteLine($"Original: {value}, Boxed: {boxed}, Unboxed: {unboxed}");
    }
}
```

---

## Key Points Summary

1. **Implicit conversion**: Automatic, no data loss, smaller → larger
2. **Explicit conversion**: Manual cast, possible data loss, larger → smaller
3. **byte + byte = int**: Arithmetic on small integers promotes to int
4. **`checked`**: Throws OverflowException on overflow
5. **`unchecked`**: Allows overflow silently (default)
6. **Boxing**: Value type to object (copies to heap)
7. **Unboxing**: Object to value type (requires explicit cast)
8. **Truncation**: float/double to int loses fractional part (doesn't round)
9. **Cannot convert**: int to bool directly (unlike C/C++)
10. **float/double**: May lose precision with very large numbers

---

## Common Mistakes to Avoid

1. ❌ Expecting `byte + byte` to return `byte`
2. ❌ Forgetting explicit cast for narrowing conversions
3. ❌ Not using `checked` when overflow would be an error
4. ❌ Trying to unbox to wrong type
5. ❌ Expecting truncation to round

---

## Practice Questions

1. Why does `byte + byte` result in `int`?
2. What is the difference between `checked` and `unchecked`?
3. What is boxing and unboxing?
4. Can you convert `int` to `bool` directly in C#?
5. What happens when you convert `3.9` to `int`?
6. What is the difference between truncation and rounding?
7. How do you convert safely from `double` to `int` with rounding?
