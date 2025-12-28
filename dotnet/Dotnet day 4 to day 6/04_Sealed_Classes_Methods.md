# Sealed Classes and Methods in C#

## 📚 Introduction

The `sealed` keyword in C# is used to prevent inheritance. When applied to a class, no other class can inherit from it. When applied to a method, derived classes cannot further override that method.

### Why Use Sealed?
- **Security**: Prevent malicious overrides that could break functionality
- **Performance**: CLR can optimize sealed method calls
- **Design Intent**: Signal that a class/method is complete and shouldn't be extended
- **Stability**: Ensure behavior cannot be changed by inheritance

---

## 🎯 Learning Objectives

- Understand when and why to seal classes
- Learn how to seal overridden methods
- Differentiate sealed from final (Java comparison)
- Master sealed class design patterns

---

## 🔍 Conceptual Overview

### Sealed Class Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                      SEALED CLASS                                │
├─────────────────────────────────────────────────────────────────┤
│ ✓ Can be instantiated                                           │
│ ✓ Can inherit from other classes                                │
│ ✓ Can implement interfaces                                      │
│ ✗ Cannot be inherited from                                      │
│ ✗ Cannot have abstract methods (no derived class to implement) │
└─────────────────────────────────────────────────────────────────┘
```

### Sealed Method Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                      SEALED METHOD                               │
├─────────────────────────────────────────────────────────────────┤
│ • Must be an override method (sealing an existing virtual)      │
│ • Prevents further overriding in subsequent derived classes     │
│ • Combined with override: sealed override void Method()         │
│ • Cannot seal a method that isn't already virtual/override      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Basic Sealed Class

```csharp
using System;

sealed class MyClass
{
    public int x;
    public int y;
    
    public MyClass(int i, int j)
    {
        x = i;
        y = j;
    }
    
    public int Sum()
    {
        return x + y;
    }
}

// COMPILE ERROR: Cannot derive from sealed class
// class MyDerived : MyClass { }

class Program
{
    static void Main()
    {
        MyClass obj = new MyClass(5, 10);
        Console.WriteLine("Sum: " + obj.Sum());  // Output: Sum: 15
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 3 | `sealed class MyClass` | Prevents any class from inheriting MyClass |
| 20 | `// class MyDerived : MyClass` | Would cause compile error |
| 25 | `new MyClass(5, 10)` | Sealed classes CAN be instantiated |

---

### Example 2: Sealed Classes in .NET Framework

```csharp
// String is a sealed class - you cannot inherit from it
// sealed class String { ... }

// COMPILE ERROR:
// class MyString : String { }  // Cannot derive from sealed type 'string'

// Why is String sealed?
// 1. Security - prevents tampering with string internals
// 2. Immutability - String's immutable contract can't be broken
// 3. Performance - CLR optimizes sealed class method calls
```

---

### Example 3: Sealing an Overridden Method

```csharp
using System;

class A
{
    public virtual void Display()
    {
        Console.WriteLine("A.Display()");
    }
}

class B : A
{
    // Seals the method - no further overriding allowed
    public sealed override void Display()
    {
        Console.WriteLine("B.Display()");
    }
}

class C : B
{
    // COMPILE ERROR: Cannot override sealed method
    // public override void Display() { }
    
    // But can use 'new' to hide (not recommended)
    public new void Display()
    {
        Console.WriteLine("C.Display() - hiding");
    }
}

class Program
{
    static void Main()
    {
        A obj1 = new B();
        obj1.Display();  // Output: B.Display()
        
        A obj2 = new C();
        obj2.Display();  // Output: B.Display() (sealed version)
        
        C obj3 = new C();
        obj3.Display();  // Output: C.Display() - hiding
    }
}
```

#### Execution Flow

```
Inheritance Chain:
    ┌───────────────┐
    │    class A    │
    │ virtual Display│
    └───────┬───────┘
            │ override
    ┌───────▼───────┐
    │    class B    │
    │ sealed override│  ← Seals Display here
    └───────┬───────┘
            │ cannot override
    ┌───────▼───────┐
    │    class C    │
    │ new Display    │  ← Can only hide, not override
    └───────────────┘
```

---

### Example 4: Why Seal Methods?

```csharp
class BankAccount
{
    protected double balance;
    
    public virtual double CalculateInterest()
    {
        return balance * 0.03;  // 3% base interest
    }
}

class SavingsAccount : BankAccount
{
    // Seal to prevent derived classes from changing interest calculation
    public sealed override double CalculateInterest()
    {
        // Special savings interest rate - must not be changed
        return balance * 0.05;  // 5% fixed
    }
}

class PremiumSavings : SavingsAccount
{
    // COMPILE ERROR: Cannot override sealed method
    // public override double CalculateInterest()
    // {
    //     return balance * 0.10;  // Someone trying to cheat!
    // }
}
```

**Use Case**: The bank wants to ensure that all savings accounts give exactly 5% interest, and no derived class can override this critical calculation.

---

### Example 5: Sealed Class with Inheritance

```csharp
// A sealed class CAN inherit from another class
class Base
{
    public virtual void Show()
    {
        Console.WriteLine("Base.Show()");
    }
}

sealed class Derived : Base
{
    public override void Show()
    {
        Console.WriteLine("Derived.Show()");
    }
}

// This is INVALID - cannot inherit from sealed class
// class MoreDerived : Derived { }
```

---

### Example 6: Comparison - Virtual, Override, Sealed, New

```csharp
using System;

class Level1
{
    public virtual void Method()
    {
        Console.WriteLine("Level1");
    }
}

class Level2 : Level1
{
    public override void Method()  // Can override
    {
        Console.WriteLine("Level2");
    }
}

class Level3 : Level2
{
    public sealed override void Method()  // Can override and seal
    {
        Console.WriteLine("Level3");
    }
}

class Level4 : Level3
{
    // public override void Method() { }  // ERROR: sealed
    
    public new void Method()  // Can hide
    {
        Console.WriteLine("Level4 - hidden");
    }
}

class Program
{
    static void Main()
    {
        Level1 a = new Level4();
        a.Method();  // Output: Level3 (sealed version)
        
        Level4 b = new Level4();
        b.Method();  // Output: Level4 - hidden
    }
}
```

#### Method Resolution Table

| Reference Type | Object Type | Method Called | Output |
|---------------|-------------|---------------|--------|
| Level1 | Level4 | Level3.Method (sealed) | "Level3" |
| Level2 | Level4 | Level3.Method (sealed) | "Level3" |
| Level3 | Level4 | Level3.Method (sealed) | "Level3" |
| Level4 | Level4 | Level4.Method (new/hidden) | "Level4 - hidden" |

---

## 📊 Visual Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│                  KEYWORD COMPARISON                              │
├─────────────────┬───────────────────┬───────────────────────────┤
│    Keyword      │     Applied To    │         Effect            │
├─────────────────┼───────────────────┼───────────────────────────┤
│    sealed       │     class         │ Cannot be inherited       │
│    sealed       │     method        │ Cannot be overridden      │
│    abstract     │     class         │ Cannot be instantiated    │
│    abstract     │     method        │ Must be overridden        │
│    virtual      │     method        │ May be overridden         │
│    new          │     method        │ Hides inherited method    │
└─────────────────┴───────────────────┴───────────────────────────┘
```

---

## ⚡ Key Points to Remember

1. **Sealed class** = Cannot be inherited (final class)
2. **Sealed method** = Cannot be overridden further
3. **sealed + override** go together for methods
4. Cannot seal a method that isn't virtual/override
5. Sealed class CAN inherit from other classes
6. Sealed class CAN implement interfaces
7. Performance benefit: JIT can inline sealed method calls

---

## ❌ Common Mistakes

### Mistake 1: Trying to seal a non-virtual method
```csharp
class A
{
    public void Display() { }  // Not virtual
}
class B : A
{
    public sealed void Display() { }  // ERROR: Cannot seal
}
```

### Mistake 2: Inheriting from sealed class
```csharp
sealed class Final { }
class Derived : Final { }  // ERROR: Cannot inherit from sealed
```

### Mistake 3: Confusing sealed with private
```csharp
sealed class MyClass
{
    // "sealed" doesn't mean "private"
    // The class is public by default
}
```

---

## 📝 Practice Questions

1. **Can a sealed class have virtual methods?**
<details>
<summary>Answer</summary>
It can, but it's pointless since no class can inherit from it to override those methods.
</details>

2. **Can you seal a method that is not an override?**
<details>
<summary>Answer</summary>
No. The `sealed` modifier on a method must accompany `override`.
</details>

3. **What's the output?**
```csharp
class A { public virtual void M() { Console.Write("A "); } }
class B : A { public sealed override void M() { Console.Write("B "); } }
class C : B { public new void M() { Console.Write("C "); } }

A obj = new C();
obj.M();
```
<details>
<summary>Answer</summary>
Output: `B ` - The polymorphic call goes to the sealed version in B.
</details>

---

## 🔗 Related Topics

- [01_Polymorphism_Virtual_Methods.md](01_Polymorphism_Virtual_Methods.md) - Virtual/override basics
- [03_Abstract_Classes_Methods.md](03_Abstract_Classes_Methods.md) - Abstract (opposite of sealed)
- [05_Access_Modifiers_Complete.md](05_Access_Modifiers_Complete.md) - Access control
