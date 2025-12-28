# Abstract Classes and Methods in C#

## 📚 Introduction

An **abstract class** is an incomplete class that cannot be instantiated directly. It serves as a blueprint for derived classes, defining common structure and behavior while leaving specific implementations to subclasses.

### When to Use Abstract Classes
- When you want to share code among closely related classes
- When you expect derived classes to have common methods with different implementations
- When you want to provide a partial implementation that subclasses complete

---

## 🎯 Learning Objectives

- Understand what makes a class abstract
- Differentiate between abstract and virtual methods
- Learn when abstract classes are preferred over interfaces
- Master the rules for abstract class inheritance

---

## 🔍 Conceptual Overview

### Abstract Class Characteristics

```
┌─────────────────────────────────────────────────────────────────┐
│                      ABSTRACT CLASS                              │
├─────────────────────────────────────────────────────────────────┤
│ ✓ Can have constructors (called by derived classes)            │
│ ✓ Can have abstract methods (no implementation)                │
│ ✓ Can have concrete methods (with implementation)              │
│ ✓ Can have fields, properties, events                          │
│ ✗ Cannot be instantiated directly                               │
│ ✗ Abstract methods cannot be private                            │
└─────────────────────────────────────────────────────────────────┘
```

### Real-World Examples in .NET Framework

| Abstract Class | Description |
|----------------|-------------|
| `System.Array` | Base for all arrays; provides Sort(), Reverse(), CopyTo() |
| `System.ValueType` | Base for all value types (int, bool, struct) |
| `System.IO.Stream` | Base for FileStream, MemoryStream, NetworkStream |
| `System.Data.Common.DbConnection` | Base for SqlConnection, OracleConnection |

### Abstract vs Virtual Methods

| Feature | Virtual Method | Abstract Method |
|---------|----------------|-----------------|
| Implementation | Has default implementation | No implementation at all |
| Override required? | Optional (`may` override) | Mandatory (`must` override) |
| Class type | Can be in regular class | Only in abstract class |
| Keyword in base | `virtual` | `abstract` |
| Keyword in derived | `override` | `override` |

---

## 💻 Code Examples

### Example 1: Why Abstract Classes Exist

Consider an Account system:

```csharp
// Problem: What does withdraw mean for a generic "Account"?
class Account
{
    public virtual void Withdraw(double amount)
    {
        // What should we do here?
        // We don't know if it's Savings or Current!
        Console.WriteLine("I don't know how to withdraw");
    }
}
```

**Solution: Make Account abstract and force subclasses to implement Withdraw:**

```csharp
abstract class Account
{
    public abstract void Withdraw(double amount);  // No body!
}
```

---

### Example 2: Complete Abstract Class Example - TwoDShape

```csharp
using System;

abstract class TwoDShape
{
    double pri_width;   // private
    double pri_height;  // private
    string pri_name;    // private
    
    // Abstract class CAN have constructor
    public TwoDShape(double w, double h, string n)
    {
        width = w;
        height = h;
        name = n;
        Console.WriteLine("TwoDShape Constructor");
    }
    
    // Properties
    public double width
    {
        get { return pri_width; }
        set { pri_width = value; }
    }
    
    public double height
    {
        get { return pri_height; }
        set { pri_height = value; }
    }
    
    public string name
    {
        get { return pri_name; }
        set { pri_name = value; }
    }
    
    // Concrete method - shared by all derived classes
    public void ShowDim()
    {
        Console.WriteLine("Width and height are " + width + " and " + height);
    }
    
    // Abstract method - MUST be overridden by derived classes
    public abstract double Area();
}

// Triangle MUST override Area()
class Triangle : TwoDShape
{
    public Triangle(double w, double h) : base(w, h, "triangle")
    {
        Console.WriteLine("Triangle Constructor");
    }
    
    public override double Area()
    {
        return width * height / 2;
    }
}

// Rectangle MUST override Area()
class Rectangle : TwoDShape
{
    public Rectangle(double w, double h) : base(w, h, "rectangle")
    {
        Console.WriteLine("Rectangle Constructor");
    }
    
    public override double Area()
    {
        return width * height;
    }
}

class Program
{
    public static void Main()
    {
        // TwoDShape s = new TwoDShape(5, 5, "test");  // ERROR! Cannot instantiate
        
        TwoDShape[] shapes = new TwoDShape[2];
        shapes[0] = new Triangle(8.0, 12.0);
        shapes[1] = new Rectangle(10, 4);
        
        for (int i = 0; i < shapes.Length; i++)
        {
            Console.WriteLine("Object is " + shapes[i].name);
            Console.WriteLine("Area is " + shapes[i].Area());
            shapes[i].ShowDim();
            Console.WriteLine();
        }
    }
}
```

#### Output:
```
TwoDShape Constructor
Triangle Constructor
TwoDShape Constructor
Rectangle Constructor
Object is triangle
Area is 48
Width and height are 8 and 12

Object is rectangle
Area is 40
Width and height are 10 and 4
```

#### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 3 | `abstract class TwoDShape` | Declares abstract class - cannot instantiate |
| 5-7 | `double pri_width; ...` | Private backing fields for properties |
| 10-16 | `public TwoDShape(...)` | Constructor - called from derived classes |
| 39-42 | `public void ShowDim()` | Concrete method - shared implementation |
| 45 | `public abstract double Area();` | Abstract method - NO body, just semicolon |
| 50 | `: base(w, h, "triangle")` | Calls parent constructor |
| 54-57 | `public override double Area()` | MUST override abstract method |
| 76 | `// new TwoDShape(...)` | Error - cannot instantiate abstract class |
| 78-79 | `shapes[0] = new Triangle(...)` | Store derived objects in abstract base array |
| 84 | `shapes[i].Area()` | Polymorphic call to correct Area() |

#### Execution Flow

```
new Triangle(8.0, 12.0) called
    │
    ├─► Triangle constructor starts
    │       │
    │       └─► : base(8.0, 12.0, "triangle") → calls TwoDShape constructor
    │               │
    │               └─► Sets width=8, height=12, name="triangle"
    │               └─► Prints "TwoDShape Constructor"
    │
    └─► Triangle constructor body runs
            └─► Prints "Triangle Constructor"
```

---

### Example 3: Abstract Class vs Regular Class

```csharp
// What if child doesn't override abstract method?
abstract class Account
{
    public abstract void Withdraw(double amount);
}

// COMPILE ERROR! 'SavingsAccount' must implement 'Account.Withdraw'
class SavingsAccount : Account
{
    // Missing Withdraw override!
}

// Solution 1: Implement the abstract method
class SavingsAccount : Account
{
    public override void Withdraw(double amount)
    {
        Console.WriteLine($"Withdrawing {amount} from savings");
    }
}

// Solution 2: Make the child class abstract too
abstract class SavingsAccount : Account
{
    // Now SavingsAccount is also abstract
    // Some other class must eventually implement Withdraw
}
```

---

### Example 4: Abstract Class with Concrete Methods

```csharp
abstract class Account
{
    protected double balance;
    protected string name;
    
    public Account(string n, double bal)
    {
        name = n;
        balance = bal;
    }
    
    // Abstract method - each account type implements differently
    public abstract void Withdraw(double amount);
    
    // Concrete method - same for all accounts
    public void Deposit(double amount)
    {
        balance += amount;
        Console.WriteLine($"{amount} deposited. New balance: {balance}");
    }
    
    // Concrete method - shared
    public void ShowBalance()
    {
        Console.WriteLine($"Account: {name}, Balance: {balance}");
    }
}

class SavingsAccount : Account
{
    const double MIN_BALANCE = 1000;
    
    public SavingsAccount(string n, double bal) : base(n, bal) { }
    
    public override void Withdraw(double amount)
    {
        if (balance - amount >= MIN_BALANCE)
        {
            balance -= amount;
            Console.WriteLine($"Withdrawn {amount}. Balance: {balance}");
        }
        else
        {
            Console.WriteLine("Cannot withdraw! Minimum balance required.");
        }
    }
}

class CurrentAccount : Account
{
    public CurrentAccount(string n, double bal) : base(n, bal) { }
    
    public override void Withdraw(double amount)
    {
        balance -= amount;  // Can go negative
        Console.WriteLine($"Withdrawn {amount}. Balance: {balance}");
    }
}

class Program
{
    static void Main()
    {
        Account[] accounts = new Account[2];
        accounts[0] = new SavingsAccount("Savings-001", 5000);
        accounts[1] = new CurrentAccount("Current-001", 3000);
        
        foreach (Account acc in accounts)
        {
            acc.Deposit(1000);     // Shared concrete method
            acc.Withdraw(4000);    // Polymorphic - each type behaves differently
            acc.ShowBalance();     // Shared concrete method
            Console.WriteLine();
        }
    }
}
```

#### Output:
```
1000 deposited. New balance: 6000
Withdrawn 4000. Balance: 2000
Account: Savings-001, Balance: 2000

1000 deposited. New balance: 4000
Withdrawn 4000. Balance: 0
Account: Current-001, Balance: 0
```

---

## 📊 Visual Summary

```
                    ┌──────────────────────┐
                    │   abstract Account   │
                    │──────────────────────│
                    │ # balance            │
                    │ # name               │
                    │──────────────────────│
                    │ + Deposit()          │ ← Concrete (shared)
                    │ + ShowBalance()      │ ← Concrete (shared)
                    │ + Withdraw()         │ ← Abstract (must override)
                    └──────────┬───────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                                      │
   ┌────────▼─────────┐               ┌───────────▼────────┐
   │ SavingsAccount   │               │   CurrentAccount   │
   │──────────────────│               │────────────────────│
   │ MIN_BALANCE=1000 │               │                    │
   │──────────────────│               │────────────────────│
   │ + Withdraw()     │               │ + Withdraw()       │
   │   (checks min)   │               │   (allows -ve)     │
   └──────────────────┘               └────────────────────┘
```

---

## ⚡ Key Points to Remember

| Rule | Description |
|------|-------------|
| Cannot instantiate | `new AbstractClass()` is a compile error |
| Constructor allowed | Used when derived classes call `base(...)` |
| Abstract methods | No body, must be overridden in derived class |
| Concrete methods | Have implementation, inherited as-is |
| Abstract class without abstract methods | Valid, but rare usage |
| Abstract method requires abstract class | If class has abstract method, class MUST be abstract |
| No private abstract | Abstract/virtual members cannot be private |

---

## ❌ Common Mistakes

### Mistake 1: Trying to instantiate abstract class
```csharp
TwoDShape s = new TwoDShape(5, 5, "test");  // ERROR!
```

### Mistake 2: Forgetting to override abstract method
```csharp
class Triangle : TwoDShape
{
    // ERROR: 'Triangle' does not implement 'TwoDShape.Area()'
}
```

### Mistake 3: Adding body to abstract method
```csharp
public abstract double Area()
{
    return 0;  // ERROR: Abstract method cannot have body
}
```

### Mistake 4: Making abstract method private
```csharp
private abstract void Process();  // ERROR: Cannot be private
```

---

## 📝 Practice Questions

1. **Can an abstract class have a constructor? Why?**
<details>
<summary>Answer</summary>
Yes! The constructor is called when derived classes instantiate. It's used to initialize common fields.
</details>

2. **What happens if a derived class doesn't override an abstract method?**
<details>
<summary>Answer</summary>
Compile error, unless the derived class is also marked abstract.
</details>

3. **Is it valid: `abstract class A { }` (no abstract methods)?**
<details>
<summary>Answer</summary>
Yes! An abstract class doesn't need abstract methods, though it's uncommon. It still can't be instantiated.
</details>

---

## 🔗 Related Topics

- [01_Polymorphism_Virtual_Methods.md](01_Polymorphism_Virtual_Methods.md) - Virtual methods
- [04_Sealed_Classes_Methods.md](04_Sealed_Classes_Methods.md) - Preventing inheritance
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - Interfaces vs abstract classes
