# Boxing and Unboxing in C#

## 📚 Introduction

**Boxing** is the process of converting a value type (stored on stack) to a reference type (stored on heap). **Unboxing** is the reverse - extracting the value type from an object.

Understanding boxing/unboxing is crucial for:
- Performance optimization
- Understanding how collections work
- Interoperating between value and reference types

---

## 🎯 Learning Objectives

- Understand the difference between value types and reference types
- Master boxing and unboxing operations
- Recognize performance implications
- Avoid common pitfalls

---

## 🔍 Value Types vs Reference Types

### Memory Layout

```
┌─────────────────────────────────────────────────────────────────┐
│                    VALUE TYPES                                   │
├─────────────────────────────────────────────────────────────────┤
│ • Stored on STACK (usually)                                     │
│ • Contains actual data                                          │
│ • Copied on assignment                                          │
│ • Examples: int, float, bool, char, struct, enum                │
│ • Derive from System.ValueType (which derives from Object)      │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   REFERENCE TYPES                                │
├─────────────────────────────────────────────────────────────────┤
│ • Reference on STACK, object on HEAP                            │
│ • Contains address (reference) to data                          │
│ • Reference copied, data shared on assignment                   │
│ • Examples: class, interface, delegate, object, string          │
│ • All derive from System.Object                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Understanding Value Type Behavior

```csharp
using System;

class Program
{
    static void Main()
    {
        // Value type - stored on stack
        int x = 10;
        int y = x;   // COPY of value
        
        y = 20;      // Changes only y
        
        Console.WriteLine($"x = {x}");  // Output: x = 10
        Console.WriteLine($"y = {y}");  // Output: y = 20
    }
}
```

#### Memory Diagram

```
Stack:
┌────────────┐
│  x = 10    │  ← Original value unchanged
├────────────┤
│  y = 20    │  ← Independent copy, now modified
└────────────┘
```

---

### Example 2: Understanding Reference Type Behavior

```csharp
using System;

class Employee
{
    public int Salary;
}

class Program
{
    static void Main()
    {
        // Reference type - reference on stack, object on heap
        Employee e1 = new Employee { Salary = 5000 };
        Employee e2 = e1;   // COPY of reference (not object!)
        
        e2.Salary = 8000;   // Changes the SAME object
        
        Console.WriteLine($"e1.Salary = {e1.Salary}");  // Output: 8000
        Console.WriteLine($"e2.Salary = {e2.Salary}");  // Output: 8000
    }
}
```

#### Memory Diagram

```
Stack:                     Heap:
┌────────────┐            ┌──────────────────┐
│    e1      │──────────► │  Salary = 8000   │ ◄── Both point
├────────────┤            └──────────────────┘     to SAME object
│    e2      │─────────────────────┘
└────────────┘
```

---

### Example 3: Boxing - Value Type to Object

```csharp
using System;

class Program
{
    static void Main()
    {
        int i = 123;        // Value type - on stack
        
        // BOXING: Create object on heap including the value
        object o = i;       // Implicit boxing
        
        Console.WriteLine($"i = {i}");  // Output: 123
        Console.WriteLine($"o = {o}");  // Output: 123
        
        // They are independent now!
        i = 456;
        Console.WriteLine($"i = {i}");  // Output: 456
        Console.WriteLine($"o = {o}");  // Output: 123 (unchanged)
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 7 | `int i = 123;` | Creates value type on stack |
| 10 | `object o = i;` | BOXING: Creates new object on heap containing copy of value |
| 16 | `i = 456;` | Changes only stack value |
| 18 | `o` still = 123 | Boxed value is independent copy |

#### Boxing Memory Diagram

```
BEFORE BOXING:
Stack:
┌────────────┐
│  i = 123   │
└────────────┘

AFTER BOXING (object o = i):
Stack:                     Heap:
┌────────────┐            ┌──────────────────────┐
│  i = 123   │            │  Type: Int32         │
├────────────┤            │  Value: 123          │
│    o       │──────────► │  (boxed int)         │
└────────────┘            └──────────────────────┘
```

---

### Example 4: Unboxing - Object to Value Type

```csharp
using System;

class Program
{
    static void Main()
    {
        int i = 123;
        object o = i;       // Boxing
        
        // UNBOXING: Extract value from boxed object
        int j = (int)o;     // Explicit unboxing (cast required)
        
        Console.WriteLine($"j = {j}");  // Output: 123
        
        // Type must match exactly!
        // long k = (long)o;  // InvalidCastException!
        
        // Correct way to convert:
        long k = (long)(int)o;  // First unbox to int, then convert
        Console.WriteLine($"k = {k}");  // Output: 123
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 11 | `int j = (int)o;` | Unboxing: explicit cast extracts value |
| 16 | `(long)o` | ERROR: Must unbox to exact type |
| 19 | `(long)(int)o` | Correct: unbox to int, then convert to long |

---

### Example 5: Performance Impact of Boxing

```csharp
using System;
using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        const int iterations = 10000000;
        
        // NON-GENERIC: Uses boxing (ArrayList stores object)
        Stopwatch sw1 = Stopwatch.StartNew();
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < iterations; i++)
        {
            arrayList.Add(i);             // Boxing occurs here!
        }
        sw1.Stop();
        Console.WriteLine($"ArrayList (boxing): {sw1.ElapsedMilliseconds} ms");
        
        // GENERIC: No boxing (List<int> stores int directly)
        Stopwatch sw2 = Stopwatch.StartNew();
        List<int> genericList = new List<int>();
        for (int i = 0; i < iterations; i++)
        {
            genericList.Add(i);           // No boxing!
        }
        sw2.Stop();
        Console.WriteLine($"List<int> (no boxing): {sw2.ElapsedMilliseconds} ms");
    }
}
```

#### Typical Output:
```
ArrayList (boxing): 850 ms
List<int> (no boxing): 120 ms
```

**Boxing is approximately 7x slower** due to:
1. Heap allocation
2. Memory copy
3. Garbage collection pressure

---

### Example 6: Common Boxing Scenarios

```csharp
using System;

class Program
{
    static void Main()
    {
        int value = 42;
        
        // Scenario 1: Assigning to object
        object obj = value;                    // Boxing
        
        // Scenario 2: Calling ToString() - NO boxing (virtual in ValueType)
        string s = value.ToString();           // No boxing
        
        // Scenario 3: Passing to method with object parameter
        PrintObject(value);                    // Boxing
        
        // Scenario 4: Interface conversion
        IComparable comparable = value;        // Boxing (interface is ref type)
        
        // Scenario 5: String concatenation (historical - modern C# may optimize)
        string message = "Value is: " + value; // May cause boxing
        
        // Better: Use string interpolation or ToString()
        string better = $"Value is: {value}";  // Compiler optimizes
    }
    
    static void PrintObject(object o)
    {
        Console.WriteLine(o);
    }
}
```

---

### Example 7: Modifying Boxed Value (The Trap!)

```csharp
using System;

struct Point
{
    public int X;
    public int Y;
    
    public void Move(int dx, int dy)
    {
        X += dx;
        Y += dy;
    }
}

class Program
{
    static void Main()
    {
        Point p = new Point { X = 1, Y = 2 };
        
        object boxed = p;   // Boxing - creates COPY
        
        p.Move(10, 10);     // Modifies original on stack
        
        Console.WriteLine($"Original: ({p.X}, {p.Y})");  // (11, 12)
        Console.WriteLine($"Boxed: ({((Point)boxed).X}, {((Point)boxed).Y})");  // (1, 2)
        
        // The boxed copy is unchanged!
    }
}
```

---

## 📊 Boxing/Unboxing Flow

```
┌─────────────┐                    ┌─────────────────────┐
│   STACK     │                    │        HEAP         │
│  int i = 42 │                    │                     │
└──────┬──────┘                    │                     │
       │                           │                     │
       │  object o = i;            │  ┌───────────────┐  │
       │  (BOXING)                 │  │ Type: Int32   │  │
       └─────────────────────────────►│ Value: 42     │  │
                                   │  └───────────────┘  │
                                   │                     │
       ┌───────────────────────────────────────┘        │
       │  int j = (int)o;                               │
       │  (UNBOXING)                                    │
       ▼                           │                     │
┌─────────────┐                    │                     │
│  int j = 42 │                    │                     │
└─────────────┘                    └─────────────────────┘
```

---

## ⚡ Key Points to Remember

| Concept | Description |
|---------|-------------|
| Boxing | Value type → Reference type (implicit) |
| Unboxing | Reference type → Value type (explicit cast) |
| Performance | Boxing creates heap allocation, unboxing copies |
| Type safety | Unbox must match exact type |
| Independence | Boxed value is a copy, not a reference |
| Generics | Use `List<T>` instead of `ArrayList` to avoid boxing |

---

## ❌ Common Mistakes

### Mistake 1: Unboxing to wrong type
```csharp
object o = 42;
long x = (long)o;  // InvalidCastException!
// Must unbox to int first: (long)(int)o
```

### Mistake 2: Expecting boxed value to change with original
```csharp
int i = 10;
object o = i;
i = 20;
Console.WriteLine(o);  // Still 10, not 20!
```

### Mistake 3: Using non-generic collections for value types
```csharp
ArrayList list = new ArrayList();
list.Add(1);  // Boxing every insertion!
// Use List<int> instead
```

---

## 📝 Practice Questions

1. **What's the output?**
```csharp
int x = 10;
object o = x;
int y = (int)o;
y = 20;
Console.WriteLine(o);
```
<details>
<summary>Answer</summary>
Output: `10` - Unboxing creates a copy; modifying `y` doesn't affect boxed value.
</details>

2. **Will this throw an exception?**
```csharp
object o = 5;
double d = (double)o;
```
<details>
<summary>Answer</summary>
Yes! InvalidCastException. Must unbox to exact type: `(double)(int)o`
</details>

---

## 🔗 Related Topics
- [05_Access_Modifiers_Complete.md](05_Access_Modifiers_Complete.md) - Type accessibility
- [20_Collections_Complete_Guide.md](20_Collections_Complete_Guide.md) - Generic vs non-generic collections
