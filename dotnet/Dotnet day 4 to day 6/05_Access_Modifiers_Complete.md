# Access Modifiers in C# - Complete Guide

## 📚 Introduction

**Access modifiers** control the visibility and accessibility of classes, methods, properties, and other members. They are fundamental to encapsulation - one of the four pillars of OOP.

---

## 🎯 Learning Objectives

- Master all five access modifiers in C#
- Understand default access levels
- Learn accessibility across assemblies
- Apply proper encapsulation principles

---

## 🔍 Complete Access Modifier Table

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ACCESS MODIFIERS IN C#                                │
├──────────────────┬────────┬────────┬──────────┬──────────┬─────────────────┤
│    Modifier      │ Same   │ Derived│ Same     │ Different│ Different       │
│                  │ Class  │ Class  │ Assembly │ Assembly │ Assembly +      │
│                  │        │        │          │          │ Derived Class   │
├──────────────────┼────────┼────────┼──────────┼──────────┼─────────────────┤
│ public           │   ✓    │   ✓    │    ✓     │    ✓     │       ✓         │
│ private          │   ✓    │   ✗    │    ✗     │    ✗     │       ✗         │
│ protected        │   ✓    │   ✓    │    ✗     │    ✗     │       ✓         │
│ internal         │   ✓    │   ✓    │    ✓     │    ✗     │       ✗         │
│ protected internal│  ✓    │   ✓    │    ✓     │    ✗     │       ✓         │
│ private protected│   ✓    │   ✓*   │    ✗     │    ✗     │       ✗         │
└──────────────────┴────────┴────────┴──────────┴──────────┴─────────────────┘
                                    * Only if derived class is in same assembly
```

---

## 💻 Code Examples

### Example 1: All Access Modifiers in Action

```csharp
// Assembly: MyLibrary.dll
namespace MyLibrary
{
    public class Employee
    {
        public string Name;              // Accessible everywhere
        private int ssn;                 // Only within this class
        protected double salary;         // This class + derived classes
        internal string department;      // Same assembly only
        protected internal string email; // Same assembly OR derived classes
        private protected int id;        // Derived classes in same assembly only
        
        public Employee(string name, int ssn, double salary)
        {
            this.Name = name;
            this.ssn = ssn;
            this.salary = salary;
        }
        
        private void CalculateTax()
        {
            // Private - only callable within Employee
            Console.WriteLine($"Tax on {salary}");
        }
        
        protected void GiveRaise(double percent)
        {
            // Protected - callable in Employee or derived classes
            salary += salary * percent / 100;
        }
        
        internal void PrintDepartment()
        {
            // Internal - callable anywhere in same assembly
            Console.WriteLine(department);
        }
    }
    
    public class Manager : Employee
    {
        public Manager(string name, int ssn, double salary) 
            : base(name, ssn, salary) { }
        
        public void PromoteEmployee()
        {
            // Can access protected member from base class
            base.GiveRaise(10);
            
            // Can access protected internal
            Console.WriteLine(email);
            
            // Cannot access private member
            // Console.WriteLine(ssn);  // ERROR!
        }
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 6 | `public string Name;` | Accessible from anywhere |
| 7 | `private int ssn;` | Only accessible within Employee class |
| 8 | `protected double salary;` | Accessible in Employee and all derived classes |
| 9 | `internal string department;` | Accessible within same assembly (DLL/EXE) |
| 10 | `protected internal string email;` | Accessible in same assembly OR derived classes |
| 11 | `private protected int id;` | Only in derived classes within same assembly |

---

### Example 2: Default Access Modifiers

```csharp
// What is the default access modifier?

class MyClass           // Default: internal (for non-nested types)
{
    int x;              // Default: private (for class members)
    void Method() { }   // Default: private
}

interface IMyInterface  // Default: internal
{
    void Method();      // Default: public (interface members are always public)
}

enum MyEnum             // Default: internal
{
    Value1,             // Enum members are always public
    Value2
}

struct MyStruct         // Default: internal
{
    int x;              // Default: private
}
```

---

### Example 3: Accessibility at Class Level

```csharp
// File: Program.cs in Assembly1

// This is the default - internal
class InternalClass { }

// Explicitly public - accessible from other assemblies
public class PublicClass { }

// ERROR: Classes cannot be private at namespace level
// private class PrivateClass { }

// Nested classes CAN be private
public class Outer
{
    private class Inner  // Only accessible within Outer
    {
        public void Display() { Console.WriteLine("Inner class"); }
    }
    
    public void CreateInner()
    {
        Inner i = new Inner();  // OK - we're inside Outer
        i.Display();
    }
}

class Program
{
    static void Main()
    {
        // Outer.Inner i = new Outer.Inner();  // ERROR: inaccessible
        Outer o = new Outer();
        o.CreateInner();  // OK
    }
}
```

---

### Example 4: Protected vs Private

```csharp
using System;

class Parent
{
    private int privateField = 100;
    protected int protectedField = 200;
    
    private void PrivateMethod()
    {
        Console.WriteLine("Parent's private method");
    }
    
    protected void ProtectedMethod()
    {
        Console.WriteLine("Parent's protected method");
    }
}

class Child : Parent
{
    public void Test()
    {
        // Cannot access private member
        // Console.WriteLine(privateField);  // ERROR!
        // PrivateMethod();  // ERROR!
        
        // CAN access protected members
        Console.WriteLine(protectedField);  // OK: 200
        ProtectedMethod();                  // OK
    }
}

class Other
{
    public void Test()
    {
        Child c = new Child();
        // Cannot access private OR protected from non-derived class
        // Console.WriteLine(c.privateField);   // ERROR!
        // Console.WriteLine(c.protectedField); // ERROR!
    }
}
```

---

### Example 5: Internal and Protected Internal

```csharp
// Assembly: LibraryAssembly.dll

namespace LibraryAssembly
{
    public class LibraryClass
    {
        internal string InternalData = "Internal";
        protected internal string ProtectedInternalData = "Protected Internal";
        
        internal void InternalMethod()
        {
            Console.WriteLine("Internal method - same assembly only");
        }
        
        protected internal void ProtectedInternalMethod()
        {
            Console.WriteLine("Protected Internal - same assembly OR derived");
        }
    }
}

// In same assembly - everything accessible
class SameAssemblyClass
{
    void Test()
    {
        LibraryClass lib = new LibraryClass();
        Console.WriteLine(lib.InternalData);           // OK
        Console.WriteLine(lib.ProtectedInternalData);  // OK
        lib.InternalMethod();                          // OK
        lib.ProtectedInternalMethod();                 // OK
    }
}
```

```csharp
// Assembly: ClientAssembly.exe (different assembly)
using LibraryAssembly;

class ClientClass
{
    void Test()
    {
        LibraryClass lib = new LibraryClass();
        // Console.WriteLine(lib.InternalData);  // ERROR: inaccessible
        // lib.InternalMethod();                 // ERROR: inaccessible
        
        // Console.WriteLine(lib.ProtectedInternalData);  // ERROR (not derived)
    }
}

// But if we derive from LibraryClass...
class DerivedClient : LibraryClass
{
    void Test()
    {
        // Protected internal is accessible in derived class!
        Console.WriteLine(ProtectedInternalData);  // OK
        ProtectedInternalMethod();                 // OK
    }
}
```

---

## 📊 Visual Diagram

```
         ┌──────────────────────────────────────────────────────────┐
         │                     ASSEMBLY A                           │
         │  ┌─────────────────────────────────────────────────────┐ │
         │  │  class Parent                                       │ │
         │  │  ┌─────────────────────────────────────────────────┐│ │
         │  │  │ private    ──► Only here                        ││ │
         │  │  │ protected  ──► Here + all derived classes       ││ │
         │  │  │ internal   ──► Anywhere in Assembly A           ││ │
         │  │  │ public     ──► Anywhere, any assembly           ││ │
         │  │  └─────────────────────────────────────────────────┘│ │
         │  └─────────────────────────────────────────────────────┘ │
         │                                                          │
         │  ┌─────────────────────────────────────────────────────┐ │
         │  │  class Child : Parent                               │ │
         │  │  ✓ Can access: protected, internal, public          │ │
         │  │  ✗ Cannot access: private                           │ │
         │  └─────────────────────────────────────────────────────┘ │
         │                                                          │
         │  ┌─────────────────────────────────────────────────────┐ │
         │  │  class Other (not derived)                          │ │
         │  │  ✓ Can access: internal, public                     │ │
         │  │  ✗ Cannot access: private, protected                │ │
         │  └─────────────────────────────────────────────────────┘ │
         └──────────────────────────────────────────────────────────┘
         
         ┌──────────────────────────────────────────────────────────┐
         │                     ASSEMBLY B                           │
         │  ┌─────────────────────────────────────────────────────┐ │
         │  │  class ExternalChild : Parent                       │ │
         │  │  ✓ Can access: protected, public                    │ │
         │  │  ✗ Cannot access: private, internal                 │ │
         │  └─────────────────────────────────────────────────────┘ │
         │                                                          │
         │  ┌─────────────────────────────────────────────────────┐ │
         │  │  class ExternalOther (not derived)                  │ │
         │  │  ✓ Can access: public only                          │ │
         │  │  ✗ Cannot access: all others                        │ │
         │  └─────────────────────────────────────────────────────┘ │
         └──────────────────────────────────────────────────────────┘
```

---

## ⚡ Key Points to Remember

| Modifier | Scope | Default For |
|----------|-------|-------------|
| `public` | Everywhere | None |
| `private` | Same class only | Class members |
| `protected` | Same class + derived classes | None |
| `internal` | Same assembly | Non-nested types |
| `protected internal` | Same assembly OR derived classes | None |
| `private protected` | Derived classes in same assembly | None |

---

## ❌ Common Mistakes

### Mistake 1: Forgetting default is private
```csharp
class MyClass
{
    int x;  // This is PRIVATE, not public!
}
```

### Mistake 2: Protected doesn't mean "any subclass anywhere"
```csharp
// In Assembly A
public class Parent { protected int x; }

// In Assembly B
public class Child : Parent
{
    Parent p = new Parent();
    // ERROR: Cannot access protected member through base class instance
    // Console.WriteLine(p.x);
    
    // OK: Can access through 'this'
    Console.WriteLine(this.x);
}
```

---

## 📝 Practice Questions

1. **What's the default access modifier for class members?**
<details>
<summary>Answer</summary>
`private`
</details>

2. **Can a derived class in a different assembly access protected members?**
<details>
<summary>Answer</summary>
Yes, through `this` or through inheritance, but not through a base class instance.
</details>

---

## 🔗 Related Topics
- [04_Sealed_Classes_Methods.md](04_Sealed_Classes_Methods.md) - Preventing inheritance
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - Interface member accessibility
