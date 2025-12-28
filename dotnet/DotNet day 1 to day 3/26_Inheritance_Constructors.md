# Inheritance and Constructors in C#

## Overview
Constructors are not inherited in C#, but understanding how they work in inheritance hierarchies is crucial. Parent constructors always execute before child constructors, and the `base` keyword is used to call parent constructors.

---

## 1. Constructors are NOT Inherited

Unlike methods and properties, constructors are **never** inherited.

```csharp
class Parent
{
    public Parent(int value)
    {
        Console.WriteLine($"Parent constructor: {value}");
    }
}

class Child : Parent
{
    // ❌ Child does NOT inherit Parent's constructor
    // Must define its own constructor and call base
    
    public Child(int value) : base(value)
    {
        Console.WriteLine($"Child constructor: {value}");
    }
}
```

---

## 2. Constructor Execution Order

### Rule: Parent Constructor ALWAYS Executes First

```csharp
class GrandParent
{
    public GrandParent()
    {
        Console.WriteLine("1. GrandParent constructor");
    }
}

class Parent : GrandParent
{
    public Parent()
    {
        Console.WriteLine("2. Parent constructor");
    }
}

class Child : Parent
{
    public Child()
    {
        Console.WriteLine("3. Child constructor");
    }
}

// Creating Child object
Child c = new Child();
```

### Output:
```
1. GrandParent constructor
2. Parent constructor
3. Child constructor
```

### Execution Flow Diagram

```
new Child() is called
       │
       ▼
┌──────────────────────────────────┐
│ Child constructor is invoked     │
│ BUT before executing Child body, │
│ it must call Parent constructor  │
└──────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Parent constructor is invoked    │
│ BUT before executing Parent body,│
│ it must call GrandParent constr  │
└──────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ GrandParent constructor body     │
│ executes FIRST                   │
│ Output: "1. GrandParent..."      │
└──────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Parent constructor body executes │
│ Output: "2. Parent..."           │
└──────────────────────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│ Child constructor body executes  │
│ Output: "3. Child..."            │
└──────────────────────────────────┘
```

---

## 3. The `base` Keyword for Constructors

### Syntax

```csharp
class Child : Parent
{
    public Child(parameters) : base(arguments)
    {
        // Child constructor body
    }
}
```

### Basic Example

```csharp
class Animal
{
    public string Name { get; set; }
    public int Age { get; set; }
    
    public Animal(string name, int age)
    {
        Name = name;
        Age = age;
        Console.WriteLine($"Animal created: {Name}, {Age} years old");
    }
}

class Dog : Animal
{
    public string Breed { get; set; }
    
    // Call parent constructor using base
    public Dog(string name, int age, string breed) : base(name, age)
    {
        Breed = breed;
        Console.WriteLine($"Dog breed: {Breed}");
    }
}

// Usage
Dog d = new Dog("Buddy", 3, "Labrador");
```

### Output:
```
Animal created: Buddy, 3 years old
Dog breed: Labrador
```

---

## 4. When is base() Required?

### Case 1: Parent has only parameterized constructor

If parent class has **NO default (parameterless) constructor**, you MUST call `base()` with appropriate arguments.

```csharp
class Parent
{
    public int Value { get; }
    
    // Only parameterized constructor - no default!
    public Parent(int value)
    {
        Value = value;
    }
}

class Child : Parent
{
    // ❌ ERROR: No argument given that corresponds to 
    // required formal parameter 'value' of 'Parent.Parent(int)'
    // public Child() { }
    
    // ✅ CORRECT: Must call base with argument
    public Child(int value) : base(value)
    {
    }
    
    // ✅ Also CORRECT: Can provide default value
    public Child() : base(0)
    {
    }
}
```

### Case 2: Parent has default constructor

If parent has a default constructor, `base()` is called implicitly.

```csharp
class Parent
{
    public Parent()  // Default constructor exists
    {
        Console.WriteLine("Parent default constructor");
    }
}

class Child : Parent
{
    public Child()  // Implicitly calls base()
    {
        Console.WriteLine("Child constructor");
    }
    
    // Equivalent to:
    // public Child() : base()
    // {
    //     Console.WriteLine("Child constructor");
    // }
}
```

---

## 5. Constructor Chaining with `this` and `base`

### Using `this` to Chain Within Same Class

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string City { get; set; }
    
    // Master constructor
    public Person(string name, int age, string city)
    {
        Name = name;
        Age = age;
        City = city;
    }
    
    // Chain to master using this
    public Person(string name, int age) : this(name, age, "Unknown")
    {
    }
    
    public Person(string name) : this(name, 0, "Unknown")
    {
    }
    
    public Person() : this("Unknown", 0, "Unknown")
    {
    }
}
```

### Combining `this` and `base` in Inheritance

```csharp
class Employee
{
    public int Id { get; }
    public string Name { get; }
    
    public Employee(int id, string name)
    {
        Id = id;
        Name = name;
    }
}

class Manager : Employee
{
    public int TeamSize { get; }
    public double Bonus { get; }
    
    // Master constructor - calls base
    public Manager(int id, string name, int teamSize, double bonus) 
        : base(id, name)
    {
        TeamSize = teamSize;
        Bonus = bonus;
    }
    
    // Chains to sibling constructor (which calls base)
    public Manager(int id, string name, int teamSize) 
        : this(id, name, teamSize, 0)
    {
    }
    
    // Chains to sibling
    public Manager(int id, string name) 
        : this(id, name, 0, 0)
    {
    }
}
```

### Important: Cannot Use Both `this` and `base`

```csharp
// ❌ ERROR: Cannot call both this and base
// public Manager(int id) : base(id, "Default") : this(id, "Default", 0)
// { }

// ✅ CORRECT: Use only one
public Manager(int id) : this(id, "Default")  // this calls another which calls base
{ }
```

---

## 6. Constructor Overloading in Inheritance

```csharp
class Vehicle
{
    public string Brand { get; set; }
    public int Year { get; set; }
    
    public Vehicle()
    {
        Brand = "Unknown";
        Year = 2000;
    }
    
    public Vehicle(string brand)
    {
        Brand = brand;
        Year = 2000;
    }
    
    public Vehicle(string brand, int year)
    {
        Brand = brand;
        Year = year;
    }
}

class Car : Vehicle
{
    public int Doors { get; set; }
    
    // Can call any parent constructor
    public Car() : base()
    {
        Doors = 4;
    }
    
    public Car(string brand) : base(brand)
    {
        Doors = 4;
    }
    
    public Car(string brand, int year) : base(brand, year)
    {
        Doors = 4;
    }
    
    public Car(string brand, int year, int doors) : base(brand, year)
    {
        Doors = doors;
    }
}

// All valid:
Car c1 = new Car();
Car c2 = new Car("Toyota");
Car c3 = new Car("Honda", 2023);
Car c4 = new Car("BMW", 2024, 2);
```

---

## 7. Static Constructors and Inheritance

Static constructors follow different rules:

```csharp
class Parent
{
    static Parent()
    {
        Console.WriteLine("Parent static constructor");
    }
    
    public Parent()
    {
        Console.WriteLine("Parent instance constructor");
    }
}

class Child : Parent
{
    static Child()
    {
        Console.WriteLine("Child static constructor");
    }
    
    public Child()
    {
        Console.WriteLine("Child instance constructor");
    }
}

// First Child object
Child c = new Child();
```

### Output:
```
Child static constructor
Parent static constructor
Parent instance constructor
Child instance constructor
```

**Note:** Static constructors run once when type is first accessed, before instance constructors.

---

## 8. Complete Example: Bank Account Hierarchy

```csharp
using System;

class BankAccount
{
    private static int _nextAccountNumber = 1000;
    
    public int AccountNumber { get; }
    public string HolderName { get; set; }
    public double Balance { get; protected set; }
    
    public BankAccount(string holderName, double initialDeposit)
    {
        AccountNumber = ++_nextAccountNumber;
        HolderName = holderName;
        Balance = initialDeposit;
        Console.WriteLine($"BankAccount created: #{AccountNumber}");
    }
    
    public virtual void Deposit(double amount)
    {
        if (amount > 0) Balance += amount;
    }
    
    public virtual bool Withdraw(double amount)
    {
        if (amount > 0 && amount <= Balance)
        {
            Balance -= amount;
            return true;
        }
        return false;
    }
    
    public virtual void DisplayInfo()
    {
        Console.WriteLine($"Account #{AccountNumber}");
        Console.WriteLine($"Holder: {HolderName}");
        Console.WriteLine($"Balance: {Balance:C}");
    }
}

class SavingsAccount : BankAccount
{
    public double InterestRate { get; set; }
    
    public SavingsAccount(string holderName, double initialDeposit, double interestRate)
        : base(holderName, initialDeposit)
    {
        InterestRate = interestRate;
        Console.WriteLine("SavingsAccount features added");
    }
    
    public void ApplyInterest()
    {
        double interest = Balance * InterestRate;
        Deposit(interest);
        Console.WriteLine($"Interest applied: {interest:C}");
    }
    
    public override void DisplayInfo()
    {
        base.DisplayInfo();
        Console.WriteLine($"Interest Rate: {InterestRate:P}");
    }
}

class CurrentAccount : BankAccount
{
    public double OverdraftLimit { get; set; }
    
    public CurrentAccount(string holderName, double initialDeposit, double overdraftLimit)
        : base(holderName, initialDeposit)
    {
        OverdraftLimit = overdraftLimit;
        Console.WriteLine("CurrentAccount features added");
    }
    
    public override bool Withdraw(double amount)
    {
        if (amount > 0 && amount <= Balance + OverdraftLimit)
        {
            Balance -= amount;
            return true;
        }
        return false;
    }
    
    public override void DisplayInfo()
    {
        base.DisplayInfo();
        Console.WriteLine($"Overdraft Limit: {OverdraftLimit:C}");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Creating Savings Account ===");
        SavingsAccount savings = new SavingsAccount("Raj", 10000, 0.05);
        savings.DisplayInfo();
        
        Console.WriteLine("\n=== Creating Current Account ===");
        CurrentAccount current = new CurrentAccount("Priya", 5000, 2000);
        current.DisplayInfo();
        
        Console.WriteLine("\n=== Transactions ===");
        savings.ApplyInterest();
        savings.DisplayInfo();
        
        current.Withdraw(6000);  // Uses overdraft
        current.DisplayInfo();
    }
}
```

---

## Key Points Summary

1. **Constructors are NOT inherited**
2. **Parent constructor executes first** (always)
3. **base()** calls parent constructor
4. **If parent has no default constructor**, base() is required
5. **Implicit base()** call if parent has default constructor
6. **Cannot use both this() and base()** in same constructor
7. **Static constructors** execute before instance constructors
8. **Constructor chaining** with this() and base() for DRY code

---

## Common Mistakes to Avoid

1. ❌ Forgetting to call base() when parent has only parameterized constructor
2. ❌ Trying to use both this() and base() together
3. ❌ Assuming constructors are inherited
4. ❌ Not understanding execution order (parent first)

---

## Practice Questions

1. Are constructors inherited in C#?
2. Which constructor executes first - parent or child?
3. When is the base() call mandatory?
4. Can you call both this() and base() in the same constructor?
5. What happens if parent has no default constructor and child doesn't call base()?
6. In what order do static constructors execute compared to instance constructors?
