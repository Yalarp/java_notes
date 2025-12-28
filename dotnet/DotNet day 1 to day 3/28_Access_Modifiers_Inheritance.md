# Access Modifiers in Inheritance

## Overview
Access modifiers control the visibility of class members across inheritance hierarchies and assemblies. Understanding how they work in inheritance is essential for proper encapsulation and designing class hierarchies.

---

## 1. Access Modifier Summary

| Modifier | Same Class | Derived Class (Same Assembly) | Derived Class (Diff Assembly) | Same Assembly | Outside Assembly |
|----------|------------|-------------------------------|------------------------------|---------------|------------------|
| `public` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `private` | ✅ | ❌ | ❌ | ❌ | ❌ |
| `protected` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `internal` | ✅ | ✅ | ❌ | ✅ | ❌ |
| `protected internal` | ✅ | ✅ | ✅ | ✅ | ❌ |
| `private protected` | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 2. Visual Representation

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ASSEMBLY A                                   │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                       BASE CLASS                                │ │
│  │  public        ──────────────────────────────────────────────────┼──> Outside Assembly ✅
│  │  private       ← Only here                                      │ │
│  │  protected     ──────────────────────────> Derived (any assembly)│ │
│  │  internal      ───────────────────> Same Assembly classes       │ │
│  │  protected internal ────────────> Derived OR Same Assembly      │ │
│  │  private protected ─────────────> Derived AND Same Assembly     │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                   DERIVED CLASS (Same Assembly)                 │ │
│  │  Can access: public, protected, internal, prot internal,        │ │
│  │              private protected                                  │ │
│  │  Cannot access: private                                         │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                   OTHER CLASS (Same Assembly)                   │ │
│  │  Can access: public, internal, protected internal               │ │
│  │  Cannot access: private, protected, private protected           │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│                         ASSEMBLY B                                   │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                   DERIVED CLASS (Different Assembly)            │ │
│  │  Can access: public, protected, protected internal              │ │
│  │  Cannot access: private, internal, private protected            │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                   OTHER CLASS (Different Assembly)              │ │
│  │  Can access: public only                                        │ │
│  │  Cannot access: everything else                                 │ │
│  └────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. private - Most Restrictive

Accessible only within the same class.

```csharp
class Parent
{
    private int _privateField = 10;
    
    private void PrivateMethod()
    {
        Console.WriteLine("Private method");
    }
    
    public void PublicMethod()
    {
        // ✅ Can access private members within same class
        Console.WriteLine(_privateField);
        PrivateMethod();
    }
}

class Child : Parent
{
    public void ChildMethod()
    {
        // ❌ ERROR: Cannot access private members
        // Console.WriteLine(_privateField);
        // PrivateMethod();
        
        // ✅ But can call public method that uses private internally
        PublicMethod();
    }
}

class Program
{
    static void Main()
    {
        Parent p = new Parent();
        // ❌ Cannot access private members
        // p._privateField = 20;
        // p.PrivateMethod();
    }
}
```

### Use Case
- Internal implementation details
- Data that should never be accessed directly from outside

---

## 4. protected - Derived Classes Only

Accessible within the class and any derived class.

```csharp
class Parent
{
    protected int _protectedField = 20;
    
    protected void ProtectedMethod()
    {
        Console.WriteLine("Protected method");
    }
}

class Child : Parent
{
    public void ChildMethod()
    {
        // ✅ Can access protected members in derived class
        Console.WriteLine(_protectedField);
        ProtectedMethod();
        
        // Can modify protected members
        _protectedField = 100;
    }
}

class OtherClass
{
    public void Test()
    {
        Parent p = new Parent();
        // ❌ Cannot access protected members from non-derived class
        // p._protectedField = 30;
        // p.ProtectedMethod();
    }
}
```

### Use Case
- Methods/properties that derived classes need to customize
- Internal state that subclasses may need to access

---

## 5. internal - Same Assembly Only

Accessible within the same assembly (project).

```csharp
// In Assembly1
namespace Assembly1
{
    public class MyClass
    {
        internal int InternalField = 30;
        
        internal void InternalMethod()
        {
            Console.WriteLine("Internal method");
        }
    }
    
    public class OtherClass
    {
        public void Test()
        {
            MyClass obj = new MyClass();
            // ✅ Same assembly - can access internal members
            Console.WriteLine(obj.InternalField);
            obj.InternalMethod();
        }
    }
}

// In Assembly2 (references Assembly1)
namespace Assembly2
{
    public class ExternalClass
    {
        public void Test()
        {
            Assembly1.MyClass obj = new Assembly1.MyClass();
            // ❌ Different assembly - cannot access internal members
            // Console.WriteLine(obj.InternalField);
            // obj.InternalMethod();
        }
    }
}
```

### Use Case
- Implementation details hidden from external assemblies
- Utility methods used across classes within same project

---

## 6. protected internal - OR Condition

Accessible if **derived class** OR **same assembly**.

```csharp
public class Parent
{
    protected internal int Value = 40;
}

// Same assembly, NOT derived - ✅ Can access (internal)
class SameAssemblyClass
{
    void Test()
    {
        Parent p = new Parent();
        Console.WriteLine(p.Value);  // ✅ Works
    }
}

// Same assembly, derived - ✅ Can access (both)
class DerivedSameAssembly : Parent
{
    void Test()
    {
        Console.WriteLine(Value);  // ✅ Works
    }
}

// Different assembly, derived - ✅ Can access (protected)
// In another project:
class DerivedDifferentAssembly : Parent
{
    void Test()
    {
        Console.WriteLine(Value);  // ✅ Works (protected part)
    }
}

// Different assembly, NOT derived - ❌ Cannot access
class ExternalClass
{
    void Test()
    {
        Parent p = new Parent();
        // Console.WriteLine(p.Value);  // ❌ Error
    }
}
```

### Use Case
- Members needed by same assembly AND derived classes in other assemblies

---

## 7. private protected - AND Condition (C# 7.2+)

Accessible only if **derived class** AND **same assembly**.

```csharp
public class Parent
{
    private protected int SecureValue = 50;
}

// Same assembly, derived - ✅ Can access
class DerivedSameAssembly : Parent
{
    void Test()
    {
        Console.WriteLine(SecureValue);  // ✅ Works
    }
}

// Same assembly, NOT derived - ❌ Cannot access
class SameAssemblyClass
{
    void Test()
    {
        Parent p = new Parent();
        // Console.WriteLine(p.SecureValue);  // ❌ Error
    }
}

// Different assembly, derived - ❌ Cannot access
class DerivedDifferentAssembly : Parent
{
    void Test()
    {
        // Console.WriteLine(SecureValue);  // ❌ Error
    }
}
```

### Use Case
- Most restrictive inheritance-based access
- Members for derived classes only within same assembly

---

## 8. Default Access Modifiers

### Class Level

```csharp
// Top-level classes default to internal
class MyClass { }  // Same as: internal class MyClass

// Nested classes default to private
class Outer
{
    class Inner { }  // Same as: private class Inner
}
```

### Member Level

```csharp
class MyClass
{
    int field;           // private
    void Method() { }    // private
    
    public int PublicField;
    public void PublicMethod() { }
}
```

### Interface Members

```csharp
interface IMyInterface
{
    void Method();       // public (implicit)
    int Property { get; }  // public (implicit)
}
```

---

## 9. Access Modifiers and Overriding

### Rules
1. Cannot change accessibility when overriding
2. Override must have same access modifier as virtual

```csharp
class Parent
{
    public virtual void PublicMethod() { }
    protected virtual void ProtectedMethod() { }
}

class Child : Parent
{
    // ✅ Same accessibility
    public override void PublicMethod() { }
    protected override void ProtectedMethod() { }
    
    // ❌ Cannot change accessibility
    // private override void PublicMethod() { }  // Error
}
```

---

## 10. Complete Example

```csharp
using System;

// Assembly: BankLibrary

namespace BankLibrary
{
    public class BankAccount
    {
        // public - accessible everywhere
        public string AccountNumber { get; }
        
        // protected - derived classes can access
        protected double Balance { get; set; }
        
        // private - only this class
        private string _pin;
        
        // internal - same assembly only
        internal DateTime LastTransaction { get; set; }
        
        // protected internal - derived OR same assembly
        protected internal string BranchCode { get; set; }
        
        // private protected - derived AND same assembly
        private protected double OverdraftLimit { get; set; }
        
        public BankAccount(string accountNumber, string pin)
        {
            AccountNumber = accountNumber;
            _pin = pin;
            Balance = 0;
            LastTransaction = DateTime.Now;
        }
        
        // public method
        public void Deposit(double amount)
        {
            if (amount > 0)
            {
                Balance += amount;
                LastTransaction = DateTime.Now;
            }
        }
        
        // protected method - for derived classes
        protected bool ValidatePin(string pin)
        {
            return _pin == pin;
        }
        
        // private method - internal implementation
        private void LogTransaction(string type, double amount)
        {
            Console.WriteLine($"[{DateTime.Now}] {type}: {amount:C}");
        }
    }
    
    // Derived class in SAME assembly
    public class SavingsAccount : BankAccount
    {
        public double InterestRate { get; set; }
        
        public SavingsAccount(string accNo, string pin, double rate) 
            : base(accNo, pin)
        {
            InterestRate = rate;
            OverdraftLimit = 0;  // ✅ private protected accessible
        }
        
        public void ApplyInterest()
        {
            double interest = Balance * InterestRate;  // ✅ protected accessible
            Balance += interest;
            LastTransaction = DateTime.Now;  // ✅ internal accessible
        }
        
        public bool AuthenticateAndWithdraw(string pin, double amount)
        {
            if (ValidatePin(pin))  // ✅ protected accessible
            {
                if (amount <= Balance)
                {
                    Balance -= amount;
                    return true;
                }
            }
            return false;
        }
    }
    
    // Non-derived class in SAME assembly
    class BankUtility
    {
        public void ProcessAccount(BankAccount account)
        {
            // ✅ Can access
            Console.WriteLine(account.AccountNumber);  // public
            Console.WriteLine(account.LastTransaction);  // internal
            Console.WriteLine(account.BranchCode);  // protected internal
            
            // ❌ Cannot access
            // Console.WriteLine(account.Balance);  // protected
            // Console.WriteLine(account.OverdraftLimit);  // private protected
        }
    }
}

// Assembly: ClientApplication (references BankLibrary)

namespace ClientApplication
{
    using BankLibrary;
    
    // Derived class in DIFFERENT assembly
    class PremiumAccount : BankAccount
    {
        public PremiumAccount(string accNo, string pin) : base(accNo, pin)
        {
            // ✅ Can access
            Balance = 1000;  // protected
            BranchCode = "PREMIUM";  // protected internal
            
            // ❌ Cannot access
            // OverdraftLimit = 5000;  // private protected - needs SAME assembly
            // LastTransaction = DateTime.Now;  // internal
        }
    }
    
    // Non-derived class in DIFFERENT assembly
    class Program
    {
        static void Main()
        {
            BankAccount account = new BankAccount("123456", "1234");
            
            // ✅ Can access
            Console.WriteLine(account.AccountNumber);  // public
            account.Deposit(1000);  // public method
            
            // ❌ Cannot access
            // Console.WriteLine(account.Balance);  // protected
            // Console.WriteLine(account.LastTransaction);  // internal
            // Console.WriteLine(account.BranchCode);  // protected internal
        }
    }
}
```

---

## 11. Quick Reference Chart

```
┌──────────────────────────────────────────────────────────────┐
│                    ACCESS MODIFIER GUIDE                      │
├──────────────────────────────────────────────────────────────┤
│  MOST RESTRICTIVE                                            │
│  ─────────────────                                           │
│  private          → Same class only                          │
│  private protected → Derived + Same assembly (C# 7.2+)       │
│  protected        → Derived classes (any assembly)           │
│  internal         → Same assembly only                       │
│  protected internal → Derived OR Same assembly               │
│  public           → Everywhere                               │
│  ─────────────────                                           │
│  LEAST RESTRICTIVE                                           │
└──────────────────────────────────────────────────────────────┘
```

---

## Key Points Summary

1. **private**: Class only - most restrictive
2. **protected**: Derived classes anywhere
3. **internal**: Same assembly only (like Java's package-private)
4. **protected internal**: protected OR internal
5. **private protected**: protected AND internal (C# 7.2+)
6. **public**: No restrictions
7. **Default class**: internal
8. **Default members**: private
9. **Cannot change accessibility** when overriding
10. **Interface members**: Always public

---

## Common Mistakes to Avoid

1. ❌ Assuming derived classes can access private members
2. ❌ Confusing internal with protected
3. ❌ Forgetting protected internal is OR (not AND)
4. ❌ Trying to make override less accessible
5. ❌ Not understanding assembly boundaries

---

## Practice Questions

1. What is the difference between private and protected?
2. What's the difference between protected internal and private protected?
3. What is the default access modifier for class members?
4. Can a derived class in a different assembly access internal members?
5. Can you change the access modifier when overriding a method?
6. What access modifier would you use for a utility method used only within your library?
7. If a base class method is protected virtual, what must the override be?
