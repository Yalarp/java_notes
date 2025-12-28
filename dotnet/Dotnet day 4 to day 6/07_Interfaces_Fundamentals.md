# Interfaces in C# - Fundamentals

## 📚 Introduction

An **interface** defines a contract - a set of method signatures, properties, events, and indexers that implementing classes must provide. Unlike abstract classes, interfaces contain no implementation (pre-C# 8) and support multiple inheritance.

---

## 🎯 Learning Objectives

- Understand interface declaration and implementation
- Master implicit vs explicit interface implementation
- Learn common .NET interfaces (ICloneable, IComparable)
- Differentiate interfaces from abstract classes

---

## 🔍 Interface Characteristics

```
┌─────────────────────────────────────────────────────────────────┐
│                      INTERFACE                                   │
├─────────────────────────────────────────────────────────────────┤
│ ✓ All members are implicitly public and abstract               │
│ ✓ Can have methods, properties, events, indexers               │
│ ✓ A class can implement multiple interfaces                    │
│ ✓ Interfaces can inherit from other interfaces                 │
│ ✗ Cannot have fields                                            │
│ ✗ Cannot have constructors                                      │
│ ✗ Cannot be instantiated                                        │
│ ✗ Default access is internal (for interface itself)            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Basic Interface Implementation

```csharp
using System;

// Interface declaration (default: internal)
interface IMessageService
{
    // Interface members are public by default
    void SendMessage(string message);
    string GetStatus();
}

// Class implementing the interface
class EmailService : IMessageService
{
    public void SendMessage(string message)
    {
        Console.WriteLine($"Email sent: {message}");
    }
    
    public string GetStatus()
    {
        return "Email service active";
    }
}

class SmsService : IMessageService
{
    public void SendMessage(string message)
    {
        Console.WriteLine($"SMS sent: {message}");
    }
    
    public string GetStatus()
    {
        return "SMS service active";
    }
}

class Program
{
    static void Main()
    {
        // Polymorphism through interface
        IMessageService service = new EmailService();
        service.SendMessage("Hello");      // Output: Email sent: Hello
        
        service = new SmsService();
        service.SendMessage("Hello");      // Output: SMS sent: Hello
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4-9 | `interface IMessageService` | Defines contract with two methods |
| 12 | `class EmailService : IMessageService` | Implements all interface members |
| 14-17 | `public void SendMessage(...)` | Must be public when implementing implicitly |
| 42 | `IMessageService service = new EmailService();` | Interface reference to implementation |

---

### Example 2: Multiple Interface Implementation

```csharp
using System;

interface IPrintable
{
    void Print();
}

interface IScannable
{
    void Scan();
}

// Class implementing multiple interfaces
class MultiFunctionPrinter : IPrintable, IScannable
{
    public void Print()
    {
        Console.WriteLine("Printing document...");
    }
    
    public void Scan()
    {
        Console.WriteLine("Scanning document...");
    }
}

class Program
{
    static void Main()
    {
        MultiFunctionPrinter mfp = new MultiFunctionPrinter();
        
        // Access through class reference
        mfp.Print();
        mfp.Scan();
        
        // Access through interface references
        IPrintable printable = mfp;
        printable.Print();
        
        IScannable scannable = mfp;
        scannable.Scan();
    }
}
```

---

### Example 3: Interface Inheritance from Class and Interface

```csharp
using System;

interface IMessageService
{
    void SendMessage(string address);
}

class Parent
{
    public void SendMessage(string address)
    {
        Console.WriteLine("Parent send message");
    }
}

// Email inherits from parent class AND implements interface
class Email : Parent, IMessageService
{
    // This method satisfies BOTH parent and interface
    public new void SendMessage(string address)
    {
        Console.WriteLine($"Sending Email to {address}");
    }
}

class Program
{
    static void Main()
    {
        Email email = new Email();
        email.SendMessage("test@example.com");
        
        // If Email doesn't override, Parent's method satisfies interface!
    }
}
```

**Key Insight**: If a parent class has a method with the same signature as an interface method, and the child implements that interface, the parent's method can satisfy the interface requirement!

---

### Example 4: Explicit Interface Implementation

When two interfaces have the same method signature, use explicit implementation:

```csharp
using System;

interface I1
{
    void A();
}

interface I2
{
    void A();
}

class C : I1, I2
{
    // Public implementation - called through class reference
    public void A()
    {
        Console.WriteLine("C.A() - public");
    }
    
    // Explicit I1 implementation - called only through I1 reference
    void I1.A()
    {
        Console.WriteLine("I1.A() - explicit");
    }
}

class Program
{
    static void Main()
    {
        C c = new C();
        I1 i1 = c;
        I2 i2 = c;
        
        c.A();    // Output: C.A() - public
        i1.A();   // Output: I1.A() - explicit
        i2.A();   // Output: C.A() - public (uses public implementation)
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 16-19 | `public void A()` | Public implementation, member of class |
| 22-25 | `void I1.A()` | Explicit implementation, NOT a member of class |
| 33 | `c.A();` | Calls public implementation |
| 34 | `i1.A();` | Calls explicit I1.A() implementation |
| 35 | `i2.A();` | No explicit I2.A(), so calls public A() |

#### Key Rules for Explicit Implementation

```
┌───────────────────────────────────────────────────────────────────┐
│              EXPLICIT INTERFACE IMPLEMENTATION                     │
├───────────────────────────────────────────────────────────────────┤
│ 1. No access modifier (always private to class)                   │
│ 2. Cannot be called through class reference                      │
│ 3. Must be called through interface reference                    │
│ 4. Used to resolve naming conflicts                              │
│ 5. Used to hide interface implementation from class users        │
└───────────────────────────────────────────────────────────────────┘
```

---

### Example 5: ICloneable Interface - Shallow Copy

```csharp
using System;

public class Point : ICloneable
{
    public int X { get; set; }
    public int Y { get; set; }
    
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
    
    public override string ToString()
    {
        return $"X = {X}, Y = {Y}";
    }
    
    // ICloneable implementation
    public object Clone()
    {
        // MemberwiseClone creates shallow copy
        return this.MemberwiseClone();
    }
}

class Program
{
    static void Main()
    {
        Point p1 = new Point(100, 100);
        Point p2 = (Point)p1.Clone();
        
        Console.WriteLine($"Before modification:");
        Console.WriteLine($"p1: {p1}");  // X = 100, Y = 100
        Console.WriteLine($"p2: {p2}");  // X = 100, Y = 100
        
        p2.X = 50;
        p2.Y = 50;
        
        Console.WriteLine($"After modifying p2:");
        Console.WriteLine($"p1: {p1}");  // X = 100, Y = 100 (unchanged)
        Console.WriteLine($"p2: {p2}");  // X = 50, Y = 50
    }
}
```

#### Memory Diagram - Shallow Copy (Value Types)

```
BEFORE CLONE:
Stack:                     
┌─────┐                   
│ p1  │────► Point { X=100, Y=100 }
└─────┘                   

AFTER CLONE:             
┌─────┐                   
│ p1  │────► Point { X=100, Y=100 } ← Original
└─────┘                   
┌─────┐                   
│ p2  │────► Point { X=100, Y=100 } ← Independent copy
└─────┘                   
```

---

### Example 6: ICloneable - Shallow Copy Problem with Reference Types

```csharp
using System;

public class PointDescription
{
    public string PetName { get; set; }
}

public class Point : ICloneable
{
    public int X { get; set; }
    public int Y { get; set; }
    public PointDescription Desc = new PointDescription();
    
    public Point(int x, int y, string petName)
    {
        X = x;
        Y = y;
        Desc.PetName = petName;
    }
    
    public override string ToString()
    {
        return $"X = {X}, Y = {Y}, Name = {Desc.PetName}";
    }
    
    // Shallow copy - references are copied, not objects
    public object Clone()
    {
        return this.MemberwiseClone();
    }
}

class Program
{
    static void Main()
    {
        Point p1 = new Point(100, 100, "Jane");
        Point p2 = (Point)p1.Clone();
        
        Console.WriteLine("Before modification:");
        Console.WriteLine($"p1: {p1}");  // X=100, Y=100, Name=Jane
        Console.WriteLine($"p2: {p2}");  // X=100, Y=100, Name=Jane
        
        // Modify p2's description
        p2.X = 50;
        p2.Desc.PetName = "CHANGED";
        
        Console.WriteLine("After modification:");
        Console.WriteLine($"p1: {p1}");  // X=100, Y=100, Name=CHANGED ← !!
        Console.WriteLine($"p2: {p2}");  // X=50, Y=100, Name=CHANGED
    }
}
```

#### Memory Diagram - Shallow Copy Problem

```
AFTER SHALLOW CLONE:
┌─────┐     ┌─────────────────────────────────────┐
│ p1  │────►│ X=100, Y=100                        │
└─────┘     │ Desc ────────────────┐              │
            └─────────────────────────────────────┘
                                   │
                                   ▼
                         ┌──────────────────┐
                         │ PetName="CHANGED"│ ◄── SHARED!
                         └──────────────────┘
                                   ▲
┌─────┐     ┌─────────────────────────────────────┐
│ p2  │────►│ X=50, Y=100                         │
└─────┘     │ Desc ────────────────┘              │
            └─────────────────────────────────────┘

Both p1 and p2 share the SAME PointDescription object!
```

---

### Example 7: Deep Copy Solution

```csharp
public object Clone()
{
    // Create deep copy manually
    Point newPoint = new Point(this.X, this.Y, this.Desc.PetName);
    return newPoint;
}
```

---

## 📊 Interface vs Abstract Class

```
┌─────────────────────┬────────────────────────────────────────────┐
│     INTERFACE       │            ABSTRACT CLASS                  │
├─────────────────────┼────────────────────────────────────────────┤
│ No implementation   │ Can have implementation                    │
│ Multiple inheritance│ Single inheritance only                    │
│ No fields           │ Can have fields                            │
│ No constructors     │ Can have constructors                      │
│ All public          │ Any access modifier                        │
│ No static members   │ Can have static members                    │
│ "Can do" relationship│ "Is a" relationship                       │
└─────────────────────┴────────────────────────────────────────────┘
```

---

## ⚡ Common .NET Interfaces

| Interface | Purpose | Key Method |
|-----------|---------|------------|
| `ICloneable` | Create copy of object | `object Clone()` |
| `IComparable` | Compare objects for ordering | `int CompareTo(object)` |
| `IComparer` | Custom comparison logic | `int Compare(obj1, obj2)` |
| `IEnumerable` | Enable foreach iteration | `IEnumerator GetEnumerator()` |
| `IEnumerator` | Iterate through collection | `Current`, `MoveNext()`, `Reset()` |
| `IDisposable` | Resource cleanup | `void Dispose()` |

---

## ❌ Common Mistakes

### Mistake 1: Forgetting explicit interface methods aren't class members
```csharp
C c = new C();
c.I1.A();  // ERROR: I1.A() is not a member of C
// Must use: ((I1)c).A() or I1 i = c; i.A();
```

### Mistake 2: Adding access modifier to explicit implementation
```csharp
public void I1.A() { }  // ERROR: Cannot have access modifier
void I1.A() { }         // CORRECT
```

---

## 📝 Practice Questions

1. **Can an interface have a constructor?**
<details>
<summary>Answer</summary>
No. Interfaces cannot have constructors.
</details>

2. **What's the output?**
```csharp
interface I { void M(); }
class C : I { void I.M() { Console.Write("A"); } }
C c = new C();
c.M();  // ?
```
<details>
<summary>Answer</summary>
Compile Error! Explicit implementation `I.M()` is not accessible through class reference.
</details>

---

## 🔗 Related Topics
- [03_Abstract_Classes_Methods.md](03_Abstract_Classes_Methods.md) - Abstract vs Interface
- [08_Interfaces_CSharp8_Features.md](08_Interfaces_CSharp8_Features.md) - Default interface methods
