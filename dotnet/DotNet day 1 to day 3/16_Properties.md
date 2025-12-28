# Properties in C#

## Overview
Properties provide a flexible way to read, write, or compute the value of private fields. They combine the accessibility of fields with the control of methods.

---

## 1. What is a Property?

### Definition
A **property** is a member that provides a flexible mechanism to read, write, or compute the value of a private field.

### Why Use Properties?
1. **Encapsulation**: Hide internal data implementation
2. **Validation**: Control what values are assigned
3. **Calculated values**: Return computed results
4. **Read-only/Write-only**: Restrict access

---

## 2. Full Property Syntax

```csharp
private dataType _fieldName;

public dataType PropertyName
{
    get 
    { 
        return _fieldName; 
    }
    set 
    { 
        _fieldName = value; 
    }
}
```

### Complete Example

```csharp
using System;

class Student
{
    // Private fields (backing fields)
    private int _rollNo;
    private string _name;
    private double _marks;
    
    // Property for RollNo
    public int RollNo
    {
        get 
        { 
            return _rollNo; 
        }
        set 
        { 
            if (value > 0)
                _rollNo = value;
            else
                throw new ArgumentException("Roll number must be positive");
        }
    }
    
    // Property for Name
    public string Name
    {
        get { return _name; }
        set 
        { 
            if (!string.IsNullOrEmpty(value))
                _name = value;
            else
                _name = "Unknown";
        }
    }
    
    // Property for Marks
    public double Marks
    {
        get { return _marks; }
        set 
        { 
            if (value >= 0 && value <= 100)
                _marks = value;
            else
                throw new ArgumentException("Marks must be between 0 and 100");
        }
    }
}

class Program
{
    static void Main()
    {
        Student s = new Student();
        
        // Using property setters
        s.RollNo = 101;
        s.Name = "Raj";
        s.Marks = 85.5;
        
        // Using property getters
        Console.WriteLine($"Roll: {s.RollNo}, Name: {s.Name}, Marks: {s.Marks}");
        
        // Validation in action
        try
        {
            s.Marks = 150;  // Invalid - throws exception
        }
        catch (ArgumentException ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
```

---

## 3. Auto-Implemented Properties

### Simplified Syntax
When no additional logic is needed, use auto-implemented properties.

```csharp
class Person
{
    // Auto-implemented properties
    // Compiler creates private backing field automatically
    public int Id { get; set; }
    public string Name { get; set; }
    public double Salary { get; set; }
}
```

### Equivalent To

```csharp
class Person
{
    private int _id;
    public int Id
    {
        get { return _id; }
        set { _id = value; }
    }
    
    // Same for other properties...
}
```

---

## 4. Expression-Bodied Properties (C# 6+)

```csharp
class Rectangle
{
    private double _width;
    private double _height;
    
    // Expression-bodied get (read-only)
    public double Area => _width * _height;
    public double Perimeter => 2 * (_width + _height);
    
    // Expression-bodied get and set (C# 7+)
    public double Width
    {
        get => _width;
        set => _width = value > 0 ? value : 0;
    }
    
    public double Height
    {
        get => _height;
        set => _height = value > 0 ? value : 0;
    }
}
```

---

## 5. Read-Only and Write-Only Properties

### Read-Only Property (Getter Only)

```csharp
class Employee
{
    private double _salary;
    
    // Read-only property
    public double Salary
    {
        get { return _salary; }
        // No setter - cannot be assigned from outside
    }
    
    // Alternative: Expression-bodied
    public double AnnualSalary => _salary * 12;
    
    public Employee(double salary)
    {
        _salary = salary;  // Can set in constructor
    }
}

class Program
{
    static void Main()
    {
        Employee e = new Employee(50000);
        Console.WriteLine(e.Salary);     // ✅ OK
        // e.Salary = 60000;             // ❌ Error - read-only
        Console.WriteLine(e.AnnualSalary); // ✅ OK
    }
}
```

### Write-Only Property (Setter Only)

```csharp
class PasswordManager
{
    private string _hashedPassword;
    
    // Write-only property
    public string Password
    {
        set { _hashedPassword = HashPassword(value); }
        // No getter - cannot be read
    }
    
    private string HashPassword(string raw)
    {
        // Simple hash for demo
        return new string(raw.Reverse().ToArray()) + "###";
    }
    
    public bool Validate(string input)
    {
        return _hashedPassword == HashPassword(input);
    }
}
```

---

## 6. Auto-Property Initializers (C# 6+)

```csharp
class Product
{
    // Initialize auto-properties
    public int Id { get; set; } = 0;
    public string Name { get; set; } = "Unknown";
    public double Price { get; set; } = 0.0;
    public DateTime Created { get; set; } = DateTime.Now;
    
    // Read-only auto-property with initializer
    public Guid UniqueId { get; } = Guid.NewGuid();
}

class Program
{
    static void Main()
    {
        Product p = new Product();
        Console.WriteLine(p.Name);      // Unknown
        Console.WriteLine(p.Created);   // Current date/time
        Console.WriteLine(p.UniqueId);  // Unique GUID
    }
}
```

---

## 7. Access Modifiers on Accessors

### Different Access Levels for Get and Set

```csharp
class Account
{
    // Public get, private set
    public int Id { get; private set; }
    
    // Public get, protected set
    public double Balance { get; protected set; }
    
    // Public get, internal set
    public string Status { get; internal set; }
    
    public Account(int id, double initialBalance)
    {
        Id = id;                    // ✅ OK - inside class
        Balance = initialBalance;   // ✅ OK - inside class
    }
}

class Program
{
    static void Main()
    {
        Account acc = new Account(1, 1000);
        
        Console.WriteLine(acc.Id);      // ✅ OK - get is public
        // acc.Id = 2;                  // ❌ Error - set is private
        
        Console.WriteLine(acc.Balance); // ✅ OK
        // acc.Balance = 2000;          // ❌ Error - set is protected
    }
}
```

---

## 8. Init-Only Setters (C# 9+)

```csharp
class Person
{
    // Can only be set during initialization
    public string Name { get; init; }
    public int Age { get; init; }
}

class Program
{
    static void Main()
    {
        // Object initializer works
        Person p = new Person { Name = "Raj", Age = 25 };
        
        Console.WriteLine($"{p.Name}, {p.Age}");
        
        // ❌ Cannot modify after initialization
        // p.Name = "Priya";  // Error
    }
}
```

---

## 9. Properties with Validation

```csharp
using System;

class Employee
{
    private int _age;
    private double _salary;
    private string _email;
    
    public int Age
    {
        get => _age;
        set
        {
            if (value < 18 || value > 65)
                throw new ArgumentException("Age must be between 18 and 65");
            _age = value;
        }
    }
    
    public double Salary
    {
        get => _salary;
        set
        {
            if (value < 0)
                throw new ArgumentException("Salary cannot be negative");
            _salary = value;
        }
    }
    
    public string Email
    {
        get => _email;
        set
        {
            if (string.IsNullOrEmpty(value) || !value.Contains("@"))
                throw new ArgumentException("Invalid email format");
            _email = value;
        }
    }
}

class Program
{
    static void Main()
    {
        Employee e = new Employee();
        
        try
        {
            e.Age = 25;          // ✅ OK
            e.Salary = 50000;    // ✅ OK
            e.Email = "raj@company.com";  // ✅ OK
            
            e.Age = 15;          // ❌ Throws exception
        }
        catch (ArgumentException ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
}
```

---

## 10. Calculated Properties

```csharp
class Rectangle
{
    public double Width { get; set; }
    public double Height { get; set; }
    
    // Calculated properties - no backing field
    public double Area => Width * Height;
    public double Perimeter => 2 * (Width + Height);
    public double Diagonal => Math.Sqrt(Width * Width + Height * Height);
    
    // Constructor
    public Rectangle(double width, double height)
    {
        Width = width;
        Height = height;
    }
}

class Program
{
    static void Main()
    {
        Rectangle r = new Rectangle(10, 5);
        
        Console.WriteLine($"Width: {r.Width}");
        Console.WriteLine($"Height: {r.Height}");
        Console.WriteLine($"Area: {r.Area}");           // 50
        Console.WriteLine($"Perimeter: {r.Perimeter}"); // 30
        Console.WriteLine($"Diagonal: {r.Diagonal:F2}"); // 11.18
        
        // Change dimensions
        r.Width = 20;
        Console.WriteLine($"New Area: {r.Area}");       // 100
    }
}
```

---

## 11. Static Properties

```csharp
class Counter
{
    // Static backing field
    private static int _count;
    
    // Static property
    public static int Count
    {
        get { return _count; }
        private set { _count = value; }
    }
    
    // Static constructor
    static Counter()
    {
        Count = 0;
    }
    
    // Instance constructor increments count
    public Counter()
    {
        Count++;
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine($"Initial count: {Counter.Count}");  // 0
        
        Counter c1 = new Counter();
        Counter c2 = new Counter();
        Counter c3 = new Counter();
        
        Console.WriteLine($"Final count: {Counter.Count}");    // 3
    }
}
```

---

## 12. Complete Example

```csharp
using System;

class BankAccount
{
    // Static properties
    private static int _nextAccountNumber = 1000;
    public static int TotalAccounts { get; private set; }
    
    // Instance properties with backing fields
    private double _balance;
    
    public int AccountNumber { get; }  // Read-only
    public string HolderName { get; set; }
    
    public double Balance
    {
        get => _balance;
        private set
        {
            if (value < 0)
                throw new InvalidOperationException("Balance cannot be negative");
            _balance = value;
        }
    }
    
    // Calculated property
    public double Interest => Balance * 0.05;
    
    public BankAccount(string name, double initialDeposit)
    {
        AccountNumber = _nextAccountNumber++;
        HolderName = name;
        Balance = initialDeposit;
        TotalAccounts++;
    }
    
    public void Deposit(double amount)
    {
        if (amount > 0)
            Balance += amount;
    }
    
    public bool Withdraw(double amount)
    {
        if (amount > 0 && amount <= Balance)
        {
            Balance -= amount;
            return true;
        }
        return false;
    }
    
    public override string ToString()
    {
        return $"Account #{AccountNumber}\n" +
               $"Holder: {HolderName}\n" +
               $"Balance: {Balance:C}\n" +
               $"Interest: {Interest:C}";
    }
}

class Program
{
    static void Main()
    {
        BankAccount a1 = new BankAccount("Raj", 10000);
        BankAccount a2 = new BankAccount("Priya", 25000);
        
        Console.WriteLine(a1);
        Console.WriteLine();
        
        a1.Deposit(5000);
        a1.Withdraw(2000);
        
        Console.WriteLine($"After transactions: {a1.Balance:C}");
        Console.WriteLine($"\nTotal accounts: {BankAccount.TotalAccounts}");
    }
}
```

---

## Key Points Summary

1. **Properties** = Controlled access to fields
2. **get accessor** = Returns value
3. **set accessor** = Assigns value (uses `value` keyword)
4. **Auto-properties** = Compiler creates backing field
5. **Expression-bodied** = Concise syntax with `=>`
6. **Validation** = Control values in setter
7. **Access modifiers** = Different levels for get/set
8. **init** = Set only during initialization
9. **Calculated** = Return computed value, no backing field
10. **Static properties** = Belong to class, not instance

---

## Practice Questions

1. What is the difference between a field and a property?
2. What is the purpose of the `value` keyword in a setter?
3. How do you create a read-only property?
4. What are auto-implemented properties?
5. How can you have different access levels for get and set?
6. What is an init-only setter?
