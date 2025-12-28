# Static Members in C#

## Overview
Static members belong to the class itself rather than to any specific instance. They are shared across all instances of the class and can be accessed without creating an object.

---

## 1. Static vs Instance Members

```
┌────────────────────────────────────────────────────────────────┐
│                    INSTANCE MEMBERS                             │
├────────────────────────────────────────────────────────────────┤
│ • Belong to each object (instance)                             │
│ • Each object has its own copy                                 │
│ • Accessed through object reference                            │
│ • Created when object is created                               │
└────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────┐
│                     STATIC MEMBERS                              │
├────────────────────────────────────────────────────────────────┤
│ • Belong to the class itself                                   │
│ • Only ONE copy shared by all instances                        │
│ • Accessed through class name                                  │
│ • Created when class is loaded                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 2. Static Variables

### Definition
A static variable is shared among all instances of a class. Changes made by one object are visible to all.

### Syntax

```csharp
class ClassName
{
    static dataType variableName;
    public static dataType variableName;
}
```

### Example

```csharp
using System;

class Employee
{
    // Instance variable - each object has its own copy
    public string name;
    public double salary;
    
    // Static variable - shared by all objects
    public static int count = 0;
    public static string company = "ABC Corp";
    
    public Employee(string name, double salary)
    {
        this.name = name;
        this.salary = salary;
        count++;  // Increment shared counter
    }
    
    public void Display()
    {
        Console.WriteLine($"Name: {name}, Salary: {salary}, " +
                         $"Company: {company}, Total Employees: {count}");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine($"Initial count: {Employee.count}");  // 0
        
        Employee e1 = new Employee("Raj", 50000);
        Employee e2 = new Employee("Priya", 60000);
        Employee e3 = new Employee("Amit", 55000);
        
        e1.Display();
        e2.Display();
        e3.Display();
        
        Console.WriteLine($"\nTotal employees: {Employee.count}");  // 3
    }
}
```

### Memory Diagram

```
Static Memory (Method Area)         Heap Memory
┌─────────────────────┐            ┌──────────────┐
│ Employee.count = 3  │            │ e1 object    │
│ Employee.company =  │            │ name = "Raj" │
│   "ABC Corp"        │            │ salary=50000 │
└─────────────────────┘            ├──────────────┤
                                   │ e2 object    │
Stack                              │ name="Priya" │
┌─────────────────────┐            │ salary=60000 │
│ e1 (reference)      │───────────>├──────────────┤
│ e2 (reference)      │───────────>│ e3 object    │
│ e3 (reference)      │───────────>│ name="Amit"  │
└─────────────────────┘            │ salary=55000 │
                                   └──────────────┘
```

---

## 3. Static Methods

### Characteristics
- Called using class name, not object reference
- Can only access static members directly
- Cannot access instance members or use `this`
- Loaded into memory when class is loaded

### Example

```csharp
using System;

class MathHelper
{
    // Static methods belong to the class
    public static int Add(int a, int b)
    {
        return a + b;
    }
    
    public static int Multiply(int a, int b)
    {
        return a * b;
    }
    
    public static double Power(double baseNum, int exponent)
    {
        return Math.Pow(baseNum, exponent);
    }
}

class Program
{
    static void Main()
    {
        // Call static methods using class name
        int sum = MathHelper.Add(5, 3);
        int product = MathHelper.Multiply(4, 6);
        double power = MathHelper.Power(2, 10);
        
        Console.WriteLine($"Sum: {sum}");       // 8
        Console.WriteLine($"Product: {product}"); // 24
        Console.WriteLine($"Power: {power}");    // 1024
        
        // ❌ Cannot create instance to call static method
        // MathHelper obj = new MathHelper();
        // obj.Add(1, 2);  // Warning: should use class name
    }
}
```

### Static Method Restrictions

```csharp
class Demo
{
    private int instanceVar = 10;
    private static int staticVar = 20;
    
    // Instance method can access both
    public void InstanceMethod()
    {
        Console.WriteLine(instanceVar);  // ✅ OK
        Console.WriteLine(staticVar);    // ✅ OK
        StaticMethod();                  // ✅ OK
    }
    
    // Static method can ONLY access static members
    public static void StaticMethod()
    {
        // Console.WriteLine(instanceVar); // ❌ ERROR
        Console.WriteLine(staticVar);      // ✅ OK
        // InstanceMethod();                // ❌ ERROR
    }
}
```

---

## 4. Static Constructor

### Characteristics
- Called automatically by CLR before first use
- No access modifier (no public/private)
- No parameters
- Called only ONCE per class
- Used to initialize static members

### Example

```csharp
using System;

class Database
{
    public static string ConnectionString;
    public static int MaxConnections;
    
    // Static constructor - called once when class is first used
    static Database()
    {
        Console.WriteLine("Static constructor called - Loading configuration");
        ConnectionString = "Server=localhost;Database=MyDB";
        MaxConnections = 100;
    }
    
    // Instance constructor
    public Database()
    {
        Console.WriteLine("Instance constructor called");
    }
    
    public static void ShowConfig()
    {
        Console.WriteLine($"Connection: {ConnectionString}");
        Console.WriteLine($"Max Connections: {MaxConnections}");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Before using Database class");
        
        // First access triggers static constructor
        Database.ShowConfig();
        
        Console.WriteLine("\nCreating objects:");
        Database d1 = new Database();
        Database d2 = new Database();
        
        // Static constructor NOT called again
    }
}
```

### Output:
```
Before using Database class
Static constructor called - Loading configuration
Connection: Server=localhost;Database=MyDB
Max Connections: 100

Creating objects:
Instance constructor called
Instance constructor called
```

---

## 5. Execution Order

```csharp
class ExecutionOrder
{
    // 1. Static field initializers run first
    private static int staticField = InitStaticField();
    
    // 2. Static constructor runs second
    static ExecutionOrder()
    {
        Console.WriteLine("2. Static constructor");
    }
    
    // 3. Instance field initializers run for each object
    private int instanceField = InitInstanceField();
    
    // 4. Instance constructor runs for each object
    public ExecutionOrder()
    {
        Console.WriteLine("4. Instance constructor");
    }
    
    private static int InitStaticField()
    {
        Console.WriteLine("1. Static field initializer");
        return 1;
    }
    
    private int InitInstanceField()
    {
        Console.WriteLine("3. Instance field initializer");
        return 2;
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Creating first object:");
        ExecutionOrder obj1 = new ExecutionOrder();
        
        Console.WriteLine("\nCreating second object:");
        ExecutionOrder obj2 = new ExecutionOrder();
    }
}
```

### Output:
```
Creating first object:
1. Static field initializer
2. Static constructor
3. Instance field initializer
4. Instance constructor

Creating second object:
3. Instance field initializer
4. Instance constructor
```

---

## 6. Static Variable Use Cases

### Counter Example

```csharp
class Account
{
    private static int nextAccountNumber = 1000;
    
    public int AccountNumber { get; }
    public string Name { get; set; }
    public double Balance { get; set; }
    
    public Account(string name, double balance)
    {
        AccountNumber = nextAccountNumber++;
        Name = name;
        Balance = balance;
    }
    
    public override string ToString()
    {
        return $"Account #{AccountNumber}: {Name}, Balance: {Balance:C}";
    }
}

class Program
{
    static void Main()
    {
        Account a1 = new Account("Raj", 10000);
        Account a2 = new Account("Priya", 20000);
        Account a3 = new Account("Amit", 15000);
        
        Console.WriteLine(a1);  // Account #1000...
        Console.WriteLine(a2);  // Account #1001...
        Console.WriteLine(a3);  // Account #1002...
    }
}
```

### Common Data Example

```csharp
class Employee
{
    // Common data for all employees
    public static string CompanyName = "ABC Corp";
    public static double TaxRate = 0.1;
    
    public string Name { get; set; }
    public double Salary { get; set; }
    
    public double CalculateTax()
    {
        return Salary * TaxRate;  // Uses static TaxRate
    }
}

class Program
{
    static void Main()
    {
        // Change affects all employees
        Employee.TaxRate = 0.15;
        
        Employee e1 = new Employee { Name = "Raj", Salary = 50000 };
        Employee e2 = new Employee { Name = "Priya", Salary = 60000 };
        
        Console.WriteLine($"{e1.Name} tax: {e1.CalculateTax():C}");  // $7,500
        Console.WriteLine($"{e2.Name} tax: {e2.CalculateTax():C}");  // $9,000
    }
}
```

---

## 7. Accessing Static Members

### Correct Way: Using Class Name

```csharp
// ✅ Correct - use class name
int result = MathHelper.Add(5, 3);
Console.WriteLine(Employee.count);
```

### Incorrect Way: Using Instance (Allowed but Warning)

```csharp
// ⚠️ Works but generates warning
MathHelper obj = new MathHelper();
int result = obj.Add(5, 3);  // Warning: static member accessed via instance
```

---

## 8. Complete Example: Bank System

```csharp
using System;

class Bank
{
    // Static members - shared data
    private static string bankName;
    private static double interestRate;
    private static int totalAccounts = 0;
    private static double totalDeposits = 0;
    
    // Static constructor - initialize bank data
    static Bank()
    {
        Console.WriteLine("Bank System Initialized");
        bankName = "National Bank";
        interestRate = 0.05;
    }
    
    // Instance members - per account data
    private int accountId;
    private string holderName;
    private double balance;
    
    public Bank(string holderName, double initialDeposit)
    {
        totalAccounts++;
        this.accountId = 1000 + totalAccounts;
        this.holderName = holderName;
        this.balance = initialDeposit;
        totalDeposits += initialDeposit;
    }
    
    // Static method
    public static void ShowBankInfo()
    {
        Console.WriteLine($"Bank: {bankName}");
        Console.WriteLine($"Interest Rate: {interestRate:P}");
        Console.WriteLine($"Total Accounts: {totalAccounts}");
        Console.WriteLine($"Total Deposits: {totalDeposits:C}");
    }
    
    // Static method to change interest rate
    public static void SetInterestRate(double rate)
    {
        interestRate = rate;
        Console.WriteLine($"Interest rate updated to {rate:P}");
    }
    
    // Instance method
    public double CalculateInterest()
    {
        return balance * interestRate;
    }
    
    public void Display()
    {
        Console.WriteLine($"Account #{accountId}: {holderName}, " +
                         $"Balance: {balance:C}, Interest: {CalculateInterest():C}");
    }
}

class Program
{
    static void Main()
    {
        Bank.ShowBankInfo();
        Console.WriteLine();
        
        Bank b1 = new Bank("Raj", 50000);
        Bank b2 = new Bank("Priya", 100000);
        Bank b3 = new Bank("Amit", 75000);
        
        Bank.ShowBankInfo();
        Console.WriteLine();
        
        b1.Display();
        b2.Display();
        b3.Display();
        
        Bank.SetInterestRate(0.07);
        Console.WriteLine();
        
        b1.Display();
    }
}
```

---

## Key Points Summary

1. **Static variable** = Shared by all instances, one copy
2. **Static method** = Called using class name, cannot access instance members
3. **Static constructor** = Called once, initializes static members
4. **Accessed via class name** not instance reference
5. Static members are **loaded when class is loaded**
6. Static constructor runs **before first use**
7. Use static for **common/shared data**
8. Use static for **utility methods** that don't need object state

---

## Practice Questions

1. What is the difference between static and instance variables?
2. Why can't static methods access instance variables?
3. When is a static constructor called?
4. Can you overload a static constructor?
5. What is stored in static memory?
6. Give examples of when to use static variables.
