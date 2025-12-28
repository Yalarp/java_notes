# Strings and StringBuilder in C#

## Overview
Strings are immutable reference types representing sequences of characters. StringBuilder provides a mutable alternative for efficient string manipulation. Understanding the difference is crucial for writing performant code.

---

## 1. String Basics

### What is a String?
A **string** is an immutable sequence of Unicode characters.

```csharp
// Different ways to create strings
string s1 = "Hello World";
string s2 = new string('a', 5);  // "aaaaa"
string s3 = string.Empty;        // "" (empty string)
string s4 = null;                // null reference
```

### Key Characteristics
- **Immutable**: Cannot be changed after creation
- **Reference type**: Stored on heap
- **Special behavior**: Interning, value-like comparison

---

## 2. String Immutability

### What Does Immutable Mean?

```csharp
string s = "Hello";
s = s + " World";  // Creates NEW string!
```

### Memory Visualization

```
Before: s = "Hello"
┌─────┐      ┌─────────┐
│  s  │─────>│ "Hello" │
└─────┘      └─────────┘

After: s = s + " World"
┌─────┐      ┌─────────────┐
│  s  │─────>│"Hello World"│  (NEW string)
└─────┘      └─────────────┘
             
             ┌─────────┐
             │ "Hello" │  (Orphaned - garbage collected)
             └─────────┘
```

### Performance Impact

```csharp
// ❌ BAD: Creates many temporary strings
string result = "";
for (int i = 0; i < 10000; i++)
{
    result = result + i.ToString();  // 10000 new strings created!
}
// Time: ~500ms for 10000 iterations

// ✅ GOOD: Use StringBuilder
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 10000; i++)
{
    sb.Append(i);  // Modifies existing buffer
}
string result = sb.ToString();
// Time: ~1ms for 10000 iterations
```

---

## 3. String Interning

### What is Interning?
The CLR maintains a pool of unique string literals to save memory.

```csharp
string a = "Hello";
string b = "Hello";
string c = new string("Hello".ToCharArray());
string d = string.Intern(c);

// Reference comparison
Console.WriteLine(ReferenceEquals(a, b));   // True (interned)
Console.WriteLine(ReferenceEquals(a, c));   // False (not interned)
Console.WriteLine(ReferenceEquals(a, d));   // True (manually interned)

// Value comparison (always compares content)
Console.WriteLine(a == b);  // True
Console.WriteLine(a == c);  // True
```

### Memory Diagram

```
String Intern Pool
┌────────────────────────────────────────┐
│  "Hello"  →  [Address: 1000]           │
│  "World"  →  [Address: 2000]           │
│  ...                                   │
└────────────────────────────────────────┘

Stack                Heap
┌─────┐             
│  a  │───────┐     
├─────┤       │     ┌─────────┐
│  b  │───────┼────>│ "Hello" │ Address: 1000 (Interned)
├─────┤       │     └─────────┘
│  c  │       │     ┌─────────┐
│     │───────┴────>│ "Hello" │ Address: 3000 (New)
├─────┤             └─────────┘
│  d  │─────────────> Points to 1000 (Interned)
└─────┘
```

---

## 4. Common String Methods

### Length and Access

```csharp
string s = "Hello World";

Console.WriteLine(s.Length);        // 11
Console.WriteLine(s[0]);            // 'H'
Console.WriteLine(s[s.Length - 1]); // 'd'

// Iterate characters
foreach (char c in s)
    Console.Write(c + " ");  // H e l l o   W o r l d
```

### Case Conversion

```csharp
string s = "Hello World";

Console.WriteLine(s.ToUpper());  // "HELLO WORLD"
Console.WriteLine(s.ToLower());  // "hello world"
```

### Trimming

```csharp
string s = "   Hello World   ";

Console.WriteLine($"[{s.Trim()}]");       // [Hello World]
Console.WriteLine($"[{s.TrimStart()}]");  // [Hello World   ]
Console.WriteLine($"[{s.TrimEnd()}]");    // [   Hello World]

// Trim specific characters
string s2 = "###Hello###";
Console.WriteLine(s2.Trim('#'));  // "Hello"
```

### Substring

```csharp
string s = "Hello World";

Console.WriteLine(s.Substring(6));     // "World"
Console.WriteLine(s.Substring(0, 5));  // "Hello"
Console.WriteLine(s.Substring(6, 5));  // "World"
```

### Split and Join

```csharp
// Split
string csv = "apple,banana,cherry";
string[] fruits = csv.Split(',');
// fruits = ["apple", "banana", "cherry"]

// Split with multiple delimiters
string data = "a,b;c|d";
string[] parts = data.Split(',', ';', '|');
// parts = ["a", "b", "c", "d"]

// Join
string joined = string.Join(" - ", fruits);
// "apple - banana - cherry"

string lines = string.Join(Environment.NewLine, fruits);
// Multi-line string
```

### Replace

```csharp
string s = "Hello World";

Console.WriteLine(s.Replace("World", "C#"));  // "Hello C#"
Console.WriteLine(s.Replace('l', 'L'));       // "HeLLo WorLd"
Console.WriteLine(s.Replace("l", ""));        // "Heo Word"
```

### Search Methods

```csharp
string s = "Hello World";

// Contains
Console.WriteLine(s.Contains("World"));   // True
Console.WriteLine(s.Contains("world"));   // False (case-sensitive)
Console.WriteLine(s.Contains("world", StringComparison.OrdinalIgnoreCase)); // True

// StartsWith / EndsWith
Console.WriteLine(s.StartsWith("Hello")); // True
Console.WriteLine(s.EndsWith("World"));   // True

// IndexOf / LastIndexOf
Console.WriteLine(s.IndexOf('o'));        // 4
Console.WriteLine(s.LastIndexOf('o'));    // 7
Console.WriteLine(s.IndexOf("World"));    // 6
Console.WriteLine(s.IndexOf("xyz"));      // -1 (not found)
```

### Insert and Remove

```csharp
string s = "Hello World";

Console.WriteLine(s.Insert(6, "Beautiful "));  // "Hello Beautiful World"
Console.WriteLine(s.Remove(5));                // "Hello"
Console.WriteLine(s.Remove(5, 1));             // "HelloWorld"
```

---

## 5. String Comparison

```csharp
string a = "Hello";
string b = "hello";

// Ordinal comparison (case-sensitive, byte-by-byte)
Console.WriteLine(a == b);                    // False
Console.WriteLine(a.Equals(b));               // False
Console.WriteLine(string.Equals(a, b));       // False

// Case-insensitive comparison
Console.WriteLine(a.Equals(b, StringComparison.OrdinalIgnoreCase));  // True
Console.WriteLine(string.Equals(a, b, StringComparison.OrdinalIgnoreCase)); // True

// Compare (returns int: <0, 0, >0)
Console.WriteLine(string.Compare(a, b));      // -1 (a < b)
Console.WriteLine(string.Compare(a, b, ignoreCase: true));  // 0

// CompareTo (for sorting)
Console.WriteLine("apple".CompareTo("banana")); // < 0 (apple before banana)
```

---

## 6. String Formatting

### Concatenation
```csharp
string name = "Raj";
int age = 25;

// + operator
string s1 = "Name: " + name + ", Age: " + age;

// String.Concat
string s2 = string.Concat("Name: ", name, ", Age: ", age);
```

### String.Format
```csharp
string s = string.Format("Name: {0}, Age: {1}", name, age);
string s2 = string.Format("{0} is {1} years old", name, age);
```

### String Interpolation (Preferred)
```csharp
string s = $"Name: {name}, Age: {age}";
string s2 = $"{name} is {age} years old";

// With expressions
string s3 = $"Next year {name} will be {age + 1}";

// With formatting
double price = 1234.567;
string s4 = $"Price: {price:C}";       // $1,234.57
string s5 = $"Price: {price:F2}";      // 1234.57
string s6 = $"Price: {price:N2}";      // 1,234.57
```

### Format Specifiers

| Specifier | Description | Example |
|-----------|-------------|---------|
| `C` | Currency | $1,234.57 |
| `N` | Number with commas | 1,234.57 |
| `F` | Fixed-point | 1234.57 |
| `E` | Scientific | 1.23E+003 |
| `P` | Percentage | 12.35% |
| `D` | Decimal (int only) | 0042 |
| `X` | Hexadecimal | 1A |

```csharp
double d = 0.1234;
Console.WriteLine($"{d:P}");    // 12.34%
Console.WriteLine($"{d:P0}");   // 12%

int n = 42;
Console.WriteLine($"{n:D5}");   // 00042
Console.WriteLine($"{n:X}");    // 2A

DateTime now = DateTime.Now;
Console.WriteLine($"{now:d}");  // 12/28/2025
Console.WriteLine($"{now:D}");  // Sunday, December 28, 2025
Console.WriteLine($"{now:yyyy-MM-dd HH:mm:ss}"); // 2025-12-28 11:30:00
```

---

## 7. Verbatim Strings and Raw Strings

### Verbatim Strings (@)

```csharp
// Without @ - need escape sequences
string path1 = "C:\\Users\\Name\\file.txt";

// With @ - no escaping needed
string path2 = @"C:\Users\Name\file.txt";

// Multi-line verbatim string
string multiLine = @"Line 1
Line 2
Line 3";

// Quotes in verbatim strings (double them)
string quote = @"He said ""Hello""";
```

### Raw String Literals (C# 11+)

```csharp
// Triple quotes for raw strings
string json = """
    {
        "name": "Raj",
        "age": 25,
        "city": "Mumbai"
    }
    """;

// With interpolation
string name = "Raj";
string jsonInterp = $$"""
    {
        "name": "{{name}}",
        "greeting": "Hello, World!"
    }
    """;
```

---

## 8. StringBuilder

### Why StringBuilder?
- Strings are **immutable** - modifications create new objects
- StringBuilder is **mutable** - modifies in place
- Much better performance for multiple modifications

### Creating StringBuilder

```csharp
using System.Text;

// Different constructors
StringBuilder sb1 = new StringBuilder();
StringBuilder sb2 = new StringBuilder("Initial text");
StringBuilder sb3 = new StringBuilder(100);  // Initial capacity
StringBuilder sb4 = new StringBuilder("Text", 200);  // Initial value and capacity
```

### StringBuilder Methods

```csharp
StringBuilder sb = new StringBuilder();

// Append - adds to end
sb.Append("Hello");
sb.Append(' ');
sb.Append("World");
sb.Append('!');
sb.Append(42);  // Works with any type
// Result: "Hello World!42"

// AppendLine - adds with newline
sb.Clear();
sb.AppendLine("Line 1");
sb.AppendLine("Line 2");
// Result: "Line 1\nLine 2\n"

// AppendFormat
sb.Clear();
sb.AppendFormat("Name: {0}, Age: {1}", "Raj", 25);
// Result: "Name: Raj, Age: 25"

// Insert
sb.Clear();
sb.Append("Hello World");
sb.Insert(6, "Beautiful ");
// Result: "Hello Beautiful World"

// Remove
sb.Clear();
sb.Append("Hello World");
sb.Remove(5, 6);  // Remove 6 chars starting at index 5
// Result: "Hello"

// Replace
sb.Clear();
sb.Append("Hello World");
sb.Replace("World", "C#");
// Result: "Hello C#"

// Clear
sb.Clear();  // Empty the builder

// Get result
string result = sb.ToString();
```

### StringBuilder Properties

```csharp
StringBuilder sb = new StringBuilder("Hello");

Console.WriteLine(sb.Length);    // 5 (current length)
Console.WriteLine(sb.Capacity);  // 16 (default capacity)

sb.Length = 3;  // Truncate to "Hel"
sb.Capacity = 100;  // Increase capacity
```

### Method Chaining (Fluent)

```csharp
string result = new StringBuilder()
    .Append("Hello")
    .Append(" ")
    .Append("World")
    .AppendLine("!")
    .Replace("World", "C#")
    .ToString();
// Result: "Hello C#!\n"
```

---

## 9. String vs StringBuilder Comparison

| Aspect | String | StringBuilder |
|--------|--------|---------------|
| **Mutability** | Immutable | Mutable |
| **Memory** | New object per change | Modifies buffer |
| **Performance** | Slow for many changes | Fast for many changes |
| **Thread Safety** | Safe (immutable) | Not thread-safe |
| **Namespace** | System | System.Text |
| **Use When** | Few/no modifications | Many modifications |

### Performance Comparison

```csharp
using System.Diagnostics;

int iterations = 50000;

// String concatenation
Stopwatch sw1 = Stopwatch.StartNew();
string s = "";
for (int i = 0; i < iterations; i++)
    s += "a";
sw1.Stop();
Console.WriteLine($"String: {sw1.ElapsedMilliseconds}ms");

// StringBuilder
Stopwatch sw2 = Stopwatch.StartNew();
StringBuilder sb = new StringBuilder();
for (int i = 0; i < iterations; i++)
    sb.Append("a");
string result = sb.ToString();
sw2.Stop();
Console.WriteLine($"StringBuilder: {sw2.ElapsedMilliseconds}ms");

// Typical results:
// String: 2000-3000ms
// StringBuilder: 1-2ms
```

---

## 10. Complete Example

```csharp
using System;
using System.Text;

class StringDemo
{
    static void Main()
    {
        // String operations
        Console.WriteLine("=== String Operations ===\n");
        
        string original = "  Hello, World!  ";
        Console.WriteLine($"Original: [{original}]");
        Console.WriteLine($"Trimmed: [{original.Trim()}]");
        Console.WriteLine($"Upper: {original.ToUpper()}");
        Console.WriteLine($"Lower: {original.ToLower()}");
        Console.WriteLine($"Replace: {original.Replace("World", "C#")}");
        Console.WriteLine($"Substring: {original.Trim().Substring(0, 5)}");
        
        // Split and Join
        Console.WriteLine("\n=== Split and Join ===\n");
        
        string csv = "apple,banana,cherry,date";
        string[] fruits = csv.Split(',');
        
        foreach (string fruit in fruits)
            Console.WriteLine($"  - {fruit}");
        
        string rejoined = string.Join(" | ", fruits);
        Console.WriteLine($"Rejoined: {rejoined}");
        
        // String Interpolation and Formatting
        Console.WriteLine("\n=== Formatting ===\n");
        
        string name = "Raj";
        int age = 25;
        double salary = 75000.50;
        DateTime now = DateTime.Now;
        
        Console.WriteLine($"Name: {name}");
        Console.WriteLine($"Age: {age}");
        Console.WriteLine($"Salary: {salary:C}");
        Console.WriteLine($"Date: {now:yyyy-MM-dd}");
        
        // StringBuilder
        Console.WriteLine("\n=== StringBuilder ===\n");
        
        StringBuilder sb = new StringBuilder();
        
        sb.AppendLine("=== Report ===");
        sb.AppendFormat("Generated: {0:F}\n", DateTime.Now);
        sb.AppendLine();
        sb.AppendLine("Items:");
        
        for (int i = 1; i <= 5; i++)
        {
            sb.AppendFormat("  {0}. Item {0}\n", i);
        }
        
        sb.AppendLine();
        sb.Append("=== End ===");
        
        Console.WriteLine(sb.ToString());
    }
}
```

---

## Key Points Summary

1. **Strings are immutable** - modifications create new objects
2. **String interning** - identical literals share memory
3. Use **StringBuilder** for multiple modifications
4. **String interpolation** (`$""`) is preferred for formatting
5. **Verbatim strings** (`@""`) for paths and multi-line
6. **== compares values**, not references for strings
7. StringBuilder is **not thread-safe**

---

## Practice Questions

1. Why are strings immutable?
2. What is string interning?
3. When should you use StringBuilder over string?
4. What is the difference between `==` and `Equals()` for strings?
5. How do you format a number as currency in string interpolation?
6. What is a verbatim string?
7. What is the default capacity of StringBuilder?
