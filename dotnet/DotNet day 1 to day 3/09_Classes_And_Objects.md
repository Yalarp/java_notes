# Classes and Objects in C#

## Overview
Classes are the foundation of object-oriented programming in C#. A class is a blueprint that defines the properties and behaviors of objects.

---

## 1. What is a Class?

### Definition
A **class** is a user-defined reference type that encapsulates data (fields) and behavior (methods).

### Syntax

```csharp
[access_modifier] class ClassName
{
    // Fields (data)
    // Constructors
    // Properties
    // Methods
}
```

---

## 2. What is an Object?

### Definition
An **object** is an instance of a class created using the `new` keyword.

### Creating Objects

```csharp
ClassName objectName = new ClassName();
```

---

## 3. Basic Class Example

```csharp
using System;

// Class definition
class Student
{
    // Fields (instance variables)
    public int rollNo;
    public string name;
    public double marks;
    
    // Method
    public void Display()
    {
        Console.WriteLine($"Roll: {rollNo}, Name: {name}, Marks: {marks}");
    }
    
    // Method with return value
    public bool IsPassed()
    {
        return marks >= 40;
    }
}

class Program
{
    static void Main()
    {
        // Create object using new keyword
        Student s1 = new Student();
        
        // Assign values to fields
        s1.rollNo = 101;
        s1.name = "Raj";
        s1.marks = 85.5;
        
        // Call methods
        s1.Display();  // Roll: 101, Name: Raj, Marks: 85.5
        
        if (s1.IsPassed())
            Console.WriteLine($"{s1.name} has passed!");
    }
}
```

---

## 4. Memory Allocation: Stack vs Heap

### When You Create an Object

```csharp
Student s1 = new Student();
```

### Memory Diagram

```
Stack                      Heap
┌────────────┐            ┌─────────────────┐
│    s1      │───────────>│  rollNo = 0     │
│  (address) │            │  name = null    │
│    5000    │            │  marks = 0.0    │
└────────────┘            └─────────────────┘
                             Address: 5000
```

### Explanation
1. **Stack**: Holds the reference variable `s1` (contains address)
2. **Heap**: Holds the actual object with its data
3. `new` keyword allocates memory on heap and returns the address

---

## 5. The `new` Keyword

### What `new` Does
1. Allocates memory on the heap for the object
2. Calls the constructor to initialize the object
3. Returns the reference (address) to the allocated memory

```csharp
// Without new - just a reference variable (null)
Student s1;
s1 = null;  // s1 doesn't point to any object

// With new - creates actual object
Student s2 = new Student();  // s2 points to object on heap
```

---

## 6. Object Hierarchy

### All Classes Inherit from Object

```csharp
class MyClass
{
    // Implicitly inherits from System.Object
}

// Equivalent to:
class MyClass : Object
{
}
```

### Object Class Methods

| Method | Description |
|--------|-------------|
| `ToString()` | Returns string representation (class name by default) |
| `Equals(object)` | Checks reference equality |
| `GetHashCode()` | Returns hash code |
| `GetType()` | Returns Type object |

```csharp
Student s = new Student();

Console.WriteLine(s.ToString());      // ProjectName.Student
Console.WriteLine(s.GetType());       // ProjectName.Student
Console.WriteLine(s.GetHashCode());   // Some number
Console.WriteLine(s.Equals(s));       // True
```

---

## 7. Multiple Objects

```csharp
using System;

class Account
{
    public int id;
    public string name;
    public double balance;
    
    public void Display()
    {
        Console.WriteLine($"ID: {id}, Name: {name}, Balance: {balance:C}");
    }
}

class Program
{
    static void Main()
    {
        // Create multiple objects
        Account a1 = new Account();
        a1.id = 1;
        a1.name = "Raj";
        a1.balance = 50000;
        
        Account a2 = new Account();
        a2.id = 2;
        a2.name = "Priya";
        a2.balance = 75000;
        
        // Each object has its own copy of data
        a1.Display();  // ID: 1, Name: Raj, Balance: $50,000.00
        a2.Display();  // ID: 2, Name: Priya, Balance: $75,000.00
    }
}
```

### Memory Diagram

```
Stack                      Heap
┌────────────┐            ┌─────────────────┐
│    a1      │───────────>│  id = 1         │
│   (4000)   │            │  name = "Raj"   │
├────────────┤            │  balance = 50000│
│    a2      │────────┐   └─────────────────┘
│   (5000)   │        │
└────────────┘        │   ┌─────────────────┐
                      └──>│  id = 2         │
                          │  name = "Priya" │
                          │  balance = 75000│
                          └─────────────────┘
```

---

## 8. Reference Assignment (Shallow Copy)

```csharp
Account a1 = new Account();
a1.name = "Raj";
a1.balance = 50000;

// Reference assignment
Account a2 = a1;  // Both point to SAME object!

a2.balance = 100000;

Console.WriteLine(a1.balance);  // 100000 (changed!)
Console.WriteLine(a2.balance);  // 100000
Console.WriteLine(a1 == a2);    // True (same reference)
```

### Memory After Reference Assignment

```
Stack                      Heap
┌────────────┐            ┌─────────────────┐
│    a1      │───────────>│  name = "Raj"   │
│   (4000)   │            │  balance=100000 │
├────────────┤       ┌───>└─────────────────┘
│    a2      │───────┘
│   (4000)   │
└────────────┘

Both a1 and a2 point to the same object!
```

---

## 9. Class Members

### Types of Members

```csharp
class Employee
{
    // 1. FIELDS (Data)
    private int id;
    private string name;
    private double salary;
    
    // 2. STATIC FIELD
    private static int count;
    
    // 3. CONSTANT
    public const double TAX_RATE = 0.1;
    
    // 4. CONSTRUCTOR
    public Employee(int id, string name, double salary)
    {
        this.id = id;
        this.name = name;
        this.salary = salary;
        count++;
    }
    
    // 5. PROPERTIES
    public int Id { get => id; }
    public string Name
    {
        get => name;
        set => name = value;
    }
    
    // 6. INSTANCE METHOD
    public double CalculateTax()
    {
        return salary * TAX_RATE;
    }
    
    // 7. STATIC METHOD
    public static int GetCount()
    {
        return count;
    }
    
    // 8. OVERRIDE METHOD
    public override string ToString()
    {
        return $"ID: {id}, Name: {name}, Salary: {salary:C}";
    }
}
```

---

## 10. Access Modifiers

| Modifier | Class | Subclass | Assembly | Outside |
|----------|-------|----------|----------|---------|
| `public` | ✓ | ✓ | ✓ | ✓ |
| `private` | ✓ | ✗ | ✗ | ✗ |
| `protected` | ✓ | ✓ | ✗ | ✗ |
| `internal` | ✓ | ✓* | ✓ | ✗ |
| `protected internal` | ✓ | ✓ | ✓ | ✗ |
| `private protected` | ✓ | ✓** | ✗ | ✗ |

\* Only if subclass is in same assembly
\*\* Only if subclass is in same assembly

---

## 11. Default Values

### Class Fields Have Default Values

```csharp
class DefaultsDemo
{
    public int number;        // 0
    public double amount;     // 0.0
    public bool flag;         // false
    public string text;       // null
    public char ch;           // '\0'
    public Student student;   // null
}

class Program
{
    static void Main()
    {
        DefaultsDemo d = new DefaultsDemo();
        
        Console.WriteLine(d.number);   // 0
        Console.WriteLine(d.amount);   // 0
        Console.WriteLine(d.flag);     // False
        Console.WriteLine(d.text == null);  // True
    }
}
```

---

## 12. Complete Example

```csharp
using System;

class BankAccount
{
    // Fields
    private static int counter;
    private int accountId;
    private string holderName;
    private double balance;
    
    // Static constructor
    static BankAccount()
    {
        Console.WriteLine("Bank of India - Welcome!");
        counter = 1000;
    }
    
    // Instance constructor
    public BankAccount(string name, double initialBalance)
    {
        counter++;
        accountId = counter;
        holderName = name;
        balance = initialBalance > 0 ? initialBalance : 0;
    }
    
    // Properties
    public int AccountId => accountId;
    public string HolderName => holderName;
    public double Balance => balance;
    
    // Methods
    public void Deposit(double amount)
    {
        if (amount > 0)
        {
            balance += amount;
            Console.WriteLine($"Deposited: {amount:C}. New Balance: {balance:C}");
        }
    }
    
    public bool Withdraw(double amount)
    {
        if (amount > 0 && amount <= balance)
        {
            balance -= amount;
            Console.WriteLine($"Withdrawn: {amount:C}. New Balance: {balance:C}");
            return true;
        }
        Console.WriteLine("Insufficient balance!");
        return false;
    }
    
    public override string ToString()
    {
        return $"Account: {accountId}, Holder: {holderName}, Balance: {balance:C}";
    }
}

class Program
{
    static void Main()
    {
        BankAccount acc1 = new BankAccount("Raj", 10000);
        BankAccount acc2 = new BankAccount("Priya", 25000);
        
        Console.WriteLine(acc1);
        Console.WriteLine(acc2);
        
        acc1.Deposit(5000);
        acc1.Withdraw(3000);
        
        Console.WriteLine($"\nFinal: {acc1}");
    }
}
```

### Output:
```
Bank of India - Welcome!
Account: 1001, Holder: Raj, Balance: $10,000.00
Account: 1002, Holder: Priya, Balance: $25,000.00
Deposited: $5,000.00. New Balance: $15,000.00
Withdrawn: $3,000.00. New Balance: $12,000.00

Final: Account: 1001, Holder: Raj, Balance: $12,000.00
```

---

## Key Points Summary

1. **Class** = Blueprint/template for objects
2. **Object** = Instance of class created with `new`
3. **Fields** = Data stored in objects
4. **Methods** = Behavior/actions of objects
5. **Reference variable** on stack, **object** on heap
6. **`new` keyword** allocates heap memory
7. All classes inherit from **System.Object**
8. Reference assignment creates **shallow copy**
9. **Default access** for class members is `private`
10. Fields have **default values** (0, null, false)

---

## Practice Questions

1. What is the difference between a class and an object?
2. What does the `new` keyword do?
3. Where is an object stored - stack or heap?
4. What happens when you assign one object to another?
5. What is the parent class of all classes in C#?
6. What are the default values for fields?
7. What is the difference between instance and static members?
