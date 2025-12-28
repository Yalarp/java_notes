# Data Types and Identifiers in C#

## Overview
This chapter covers the fundamental building blocks of C# programs: identifiers (names), naming conventions, and the complete type system including value types, reference types, and the `var` keyword.

---

## 1. Identifiers

### What is an Identifier?
An **identifier** is a name used to identify a variable, class, method, namespace, interface, struct, enum, or any other user-defined item.

### Rules for Identifiers

| Rule | Valid Example | Invalid Example |
|------|---------------|-----------------|
| Can contain letters, digits, underscore | `myVar`, `my_var`, `var1` | - |
| Must start with letter or underscore | `_count`, `name` | `1name` ❌ |
| Cannot start with digit | `value1` | `1value` ❌ |
| Cannot use reserved keywords | `myClass` | `class` ❌ |
| Case-sensitive | `Name` ≠ `name` | - |

### Examples

```csharp
// ✅ Valid identifiers
int age;
string firstName;
double _salary;
float value123;
string firstName_lastName;

// ❌ Invalid identifiers
int 1stNumber;     // Starts with digit
string class;      // Reserved keyword
float my-value;    // Contains hyphen
double first name; // Contains space
```

---

## 2. Naming Conventions

### Pascal Casing
- First letter of each word is uppercase
- Used for: **Classes, Methods, Properties, Namespaces, Public Members**

```csharp
class StudentDetails { }           // Class
public void CalculateSalary() { }  // Method
public string FirstName { get; }   // Property
namespace MyApplication { }        // Namespace
```

### Camel Casing
- First word lowercase, subsequent words uppercase
- Used for: **Local variables, Parameters, Private fields**

```csharp
int studentAge;              // Local variable
void Process(string inputData) { }  // Parameter
private double _salary;      // Private field (with underscore prefix)
```

### Summary Table

| Convention | Used For | Example |
|------------|----------|---------|
| **PascalCase** | Classes, Methods, Properties, Namespaces | `StudentDetails`, `GetName()` |
| **camelCase** | Variables, Parameters, Private fields | `studentAge`, `inputData` |
| **_camelCase** | Private fields (with underscore) | `_firstName` |
| **UPPER_CASE** | Constants | `MAX_VALUE` |

---

## 3. Data Type Categories

### Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                         C# Data Types                             │
├─────────────────────────────┬────────────────────────────────────┤
│       VALUE TYPES           │         REFERENCE TYPES            │
├─────────────────────────────┼────────────────────────────────────┤
│ • Stored on STACK           │ • Stored on HEAP                   │
│ • Directly contains value   │ • Contains reference (address)     │
│ • Faster access             │ • Slower access                    │
│ • No garbage collection     │ • Garbage collected                │
│                             │                                    │
│ Examples:                   │ Examples:                          │
│ - int, float, double        │ - string, object                   │
│ - char, bool                │ - arrays, classes                  │
│ - struct, enum              │ - delegates, interfaces            │
└─────────────────────────────┴────────────────────────────────────┘
```

---

## 4. Value Types

### Predefined Value Types (Primitive Types)

#### Integer Types

| Type | .NET Type | Size | Range |
|------|-----------|------|-------|
| `sbyte` | System.SByte | 8 bits | -128 to 127 |
| `byte` | System.Byte | 8 bits | 0 to 255 |
| `short` | System.Int16 | 16 bits | -32,768 to 32,767 |
| `ushort` | System.UInt16 | 16 bits | 0 to 65,535 |
| `int` | System.Int32 | 32 bits | -2.1B to 2.1B |
| `uint` | System.UInt32 | 32 bits | 0 to 4.2B |
| `long` | System.Int64 | 64 bits | Very large range |
| `ulong` | System.UInt64 | 64 bits | 0 to very large |

#### Floating-Point Types

| Type | .NET Type | Size | Precision |
|------|-----------|------|-----------|
| `float` | System.Single | 32 bits | 7 digits |
| `double` | System.Double | 64 bits | 15-16 digits |
| `decimal` | System.Decimal | 128 bits | 28-29 digits (for money) |

#### Other Value Types

| Type | .NET Type | Description |
|------|-----------|-------------|
| `bool` | System.Boolean | true or false |
| `char` | System.Char | Single Unicode character (16-bit) |

### Code Example

```csharp
using System;

class DataTypeDemo
{
    static void Main()
    {
        // Integer types
        byte b = 255;              // 8-bit unsigned
        sbyte sb = -128;           // 8-bit signed
        short s = 32767;           // 16-bit signed
        int i = 2147483647;        // 32-bit signed
        long l = 9223372036854775807L;  // 64-bit signed (L suffix)
        
        // Floating-point types
        float f = 3.14F;           // F suffix required
        double d = 3.14159265359;  // Default for decimals
        decimal m = 19.99M;        // M suffix required (for money)
        
        // Other types
        bool flag = true;
        char ch = 'A';             // Single quotes for char
        
        // Display sizes
        Console.WriteLine("int size: " + sizeof(int) + " bytes");
        Console.WriteLine("float size: " + sizeof(float) + " bytes");
    }
}
```

---

## 5. Reference Types

### Predefined Reference Types

| Type | .NET Type | Description |
|------|-----------|-------------|
| `string` | System.String | Sequence of characters |
| `object` | System.Object | Base type of all types |
| `dynamic` | (special) | Type resolved at runtime |

### User-Defined Reference Types
- Classes
- Arrays
- Interfaces
- Delegates

### Memory Diagram

```
VALUE TYPE:                    REFERENCE TYPE:
┌─────────┐                   ┌─────────┐      ┌─────────────┐
│  Stack  │                   │  Stack  │      │    Heap     │
├─────────┤                   ├─────────┤      ├─────────────┤
│ int x=5 │                   │ str     │─────>│   "Hello"   │
│    5    │                   │  (4000) │      │   (4000)    │
└─────────┘                   └─────────┘      └─────────────┘
  Direct                        Reference         Actual
  Storage                       (Address)         Object
```

---

## 6. Type Inheritance Hierarchy

### All Types Inherit from Object

```csharp
// Prove that int is derived from Object
int x = 42;
Console.WriteLine(x.GetType().BaseType);  // Output: System.ValueType

// ValueType inherits from Object
Console.WriteLine(typeof(int).BaseType.BaseType);  // Output: System.Object
```

### Hierarchy Diagram

```
                    System.Object
                         │
           ┌─────────────┴─────────────┐
           │                           │
    System.ValueType             Reference Types
           │                     (string, arrays,
           │                      classes, etc.)
    ┌──────┴──────┐
    │             │
Primitive      Structs
Types          Enums
(int, bool,
float, etc.)
```

---

## 7. Aliasing: Primitive Types and .NET Types

### Primitive Types are Aliases

```csharp
// These are exactly equivalent:
int a = 5;              // C# alias
System.Int32 b = 5;     // .NET type

// Both are valid:
int max = int.MaxValue;
int max2 = System.Int32.MaxValue;
```

### Complete Alias Table

| C# Alias | .NET Type | Default Value |
|----------|-----------|---------------|
| `bool` | System.Boolean | `false` |
| `byte` | System.Byte | `0` |
| `sbyte` | System.SByte | `0` |
| `char` | System.Char | `'\0'` |
| `decimal` | System.Decimal | `0.0M` |
| `double` | System.Double | `0.0D` |
| `float` | System.Single | `0.0F` |
| `int` | System.Int32 | `0` |
| `uint` | System.UInt32 | `0` |
| `long` | System.Int64 | `0L` |
| `ulong` | System.UInt64 | `0` |
| `short` | System.Int16 | `0` |
| `ushort` | System.UInt16 | `0` |
| `string` | System.String | `null` |
| `object` | System.Object | `null` |

---

## 8. The `new` Keyword with Value Types

### Value Types Can Use `new`

```csharp
// Method 1: Direct assignment (preferred)
int a = 10;

// Method 2: Using new keyword
int b = new int();  // b = 0 (default value)

// Both are valid! new with value types calls default constructor
```

### What `new` Does for Value Types
- Allocates memory on stack
- Initializes to default value
- Returns the value (not a reference)

```csharp
int x = new int();      // x = 0
bool flag = new bool(); // flag = false
double d = new double(); // d = 0.0
```

---

## 9. The `var` Keyword

### Implicitly Typed Local Variables

```csharp
// Explicitly typed
int number = 10;
string name = "Raj";
double salary = 50000.00;

// Implicitly typed (using var)
var number = 10;        // Compiler infers: int
var name = "Raj";       // Compiler infers: string
var salary = 50000.00;  // Compiler infers: double
```

### Rules for `var`

| Rule | Example | Valid? |
|------|---------|--------|
| Must be initialized at declaration | `var x = 10;` | ✅ |
| Cannot initialize with null (alone) | `var x = null;` | ❌ |
| Cannot use in class-level fields | `class C { var x = 5; }` | ❌ |
| Cannot use in method parameters | `void M(var x)` | ❌ |
| Cannot use in return types | `var M() { }` | ❌ |
| Once assigned, type is fixed | `var x = 10; x = "string";` | ❌ |

### Code Examples

```csharp
class VarDemo
{
    // ❌ WRONG: Cannot use var for class-level fields
    // var classField = 10;  // Compile error!
    
    static void Main()
    {
        // ✅ CORRECT: var with initialization
        var number = 100;        // int
        var pi = 3.14;           // double
        var greeting = "Hello";  // string
        var flag = true;         // bool
        
        // ❌ WRONG: var without initialization
        // var x;  // Compile error!
        
        // ❌ WRONG: var with null (type cannot be inferred)
        // var n = null;  // Compile error!
        
        // ✅ CORRECT: var with null but with type cast
        var str = (string)null;  // Allowed - type is string
        
        // Type is fixed after declaration
        var value = 10;
        // value = "text";  // ❌ Error: cannot assign string to int
        
        // Display inferred types
        Console.WriteLine(number.GetType());  // System.Int32
        Console.WriteLine(pi.GetType());      // System.Double
    }
}
```

### When to Use `var`

```csharp
// ✅ Good use: Complex types where type is obvious
var dictionary = new Dictionary<string, List<int>>();

// ✅ Good use: Anonymous types
var person = new { Name = "Raj", Age = 25 };

// ❌ Avoid: Simple types where explicit is clearer
var x = 5;  // Use int x = 5; instead for clarity
```

---

## 10. Value Type vs Reference Type Comparison

```csharp
using System;

class ComparisonDemo
{
    static void Main()
    {
        // VALUE TYPE behavior
        int a = 10;
        int b = a;   // Copy of value
        b = 20;      // Change b
        Console.WriteLine(a);  // Output: 10 (unchanged)
        Console.WriteLine(b);  // Output: 20
        
        // REFERENCE TYPE behavior
        int[] arr1 = { 1, 2, 3 };
        int[] arr2 = arr1;   // Copy of reference (same object)
        arr2[0] = 999;       // Change through arr2
        Console.WriteLine(arr1[0]);  // Output: 999 (changed!)
    }
}
```

### Memory Diagram

```
VALUE TYPE:
┌─────────┐
│  a = 10 │  (a has its own copy)
├─────────┤
│  b = 20 │  (b has its own copy)
└─────────┘

REFERENCE TYPE:
┌─────────┐     ┌─────────────────┐
│  arr1   │────>│  { 999, 2, 3 }  │
├─────────┤     └─────────────────┘
│  arr2   │────────────┘
└─────────┘
  Both point to same array!
```

---

## 11. Default Values

### Value Types Have Default Values

```csharp
class DefaultValueDemo
{
    // Class-level fields get default values
    static int number;        // default: 0
    static bool flag;         // default: false
    static double amount;     // default: 0.0
    static char ch;           // default: '\0'
    static string name;       // default: null (reference type)
    
    static void Main()
    {
        Console.WriteLine(number);  // 0
        Console.WriteLine(flag);    // False
        Console.WriteLine(amount);  // 0
        
        // Local variables must be assigned before use
        int localVar;
        // Console.WriteLine(localVar);  // ❌ Error: Use of unassigned local variable
        
        localVar = 10;
        Console.WriteLine(localVar);  // ✅ Now works: 10
    }
}
```

---

## 12. Literal Suffixes

### Number Literal Suffixes

```csharp
// Long literal
long bigNumber = 9876543210L;  // L or l suffix

// Float literal
float price = 19.99F;  // F or f suffix (required!)

// Double literal
double pi = 3.14159;   // D or d suffix (optional, default)

// Decimal literal
decimal money = 1234.56M;  // M or m suffix (required!)

// Unsigned suffixes
uint ui = 100U;        // U or u suffix
ulong ul = 100UL;      // UL or ul suffix
```

### Character and String Literals

```csharp
char letter = 'A';           // Single quotes for char
char newline = '\n';         // Escape sequence
char unicode = '\u0041';     // Unicode (A)

string text = "Hello";       // Double quotes for string
string path = @"C:\Users";   // Verbatim string (@ prefix)
string interpolated = $"Name: {name}";  // Interpolated string
```

---

## Key Points Summary

1. **Identifiers** must start with letter or underscore, cannot be keywords
2. **PascalCase** for classes, methods, properties
3. **camelCase** for variables, parameters
4. **Value types** stored on stack, hold actual data
5. **Reference types** stored on heap, hold address
6. All types inherit from `System.Object`
7. Primitive types are aliases for .NET types
8. **`var`** is for implicitly typed local variables only
9. Value types have default values, local variables must be initialized
10. Use suffixes for float (F), decimal (M), long (L)

---

## Practice Questions

1. What is the difference between value types and reference types?
2. What is the default access modifier for class members?
3. What are the rules for using the `var` keyword?
4. What is the .NET equivalent of `int`?
5. What happens when you assign one value type variable to another?
6. What happens when you assign one reference type variable to another?
7. What is the base class of all types in .NET?
8. Why are `float` and `decimal` literals required to have suffixes?
