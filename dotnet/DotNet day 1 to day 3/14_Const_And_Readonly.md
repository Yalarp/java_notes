# Const and Readonly in C#

## Overview
`const` and `readonly` are used to create values that cannot be changed after initialization. Understanding their differences is crucial for proper usage.

---

## 1. Const Keyword

### Definition
A `const` field is a compile-time constant whose value cannot change.

### Characteristics
- Must be initialized at **declaration**
- Value known at **compile time**
- Implicitly **static**
- Stored in **assembly metadata** (not in memory at runtime)
- Can only use with **primitive types** and `string`

### Syntax

```csharp
const dataType NAME = value;
public const double PI = 3.14159;
```

### Example

```csharp
using System;

class Circle
{
    // const is implicitly static
    public const double PI = 3.14159;
    
    private double radius;
    
    public Circle(double radius)
    {
        this.radius = radius;
    }
    
    public double GetArea()
    {
        return PI * radius * radius;
    }
    
    public double GetCircumference()
    {
        return 2 * PI * radius;
    }
}

class Program
{
    static void Main()
    {
        // Access const using class name (because it's static)
        Console.WriteLine($"PI = {Circle.PI}");
        
        Circle c = new Circle(5);
        Console.WriteLine($"Area = {c.GetArea()}");
        Console.WriteLine($"Circumference = {c.GetCircumference()}");
        
        // ❌ Cannot modify const
        // Circle.PI = 3.14;  // Error: The left-hand side of an assignment 
                              // must be a variable, property or indexer
    }
}
```

---

## 2. Readonly Keyword

### Definition
A `readonly` field is a runtime constant whose value can only be set during declaration or in a constructor.

### Characteristics
- Can be initialized at **declaration** or in **constructor**
- Value can be determined at **runtime**
- Can be **instance or static**
- Can use with **any data type** including reference types
- Stored in **memory** (like regular fields)

### Syntax

```csharp
readonly dataType name = value;  // At declaration
// OR
readonly dataType name;          // Assigned in constructor
```

### Example

```csharp
using System;

class Employee
{
    // readonly can be assigned at declaration
    public readonly int MaxAge = 60;
    
    // readonly can be assigned in constructor
    public readonly int Id;
    public readonly DateTime CreatedDate;
    
    private string name;
    
    public Employee(int id, string name)
    {
        // Can assign readonly in constructor
        this.Id = id;
        this.name = name;
        this.CreatedDate = DateTime.Now;
    }
    
    public void Display()
    {
        Console.WriteLine($"ID: {Id}, Name: {name}, Created: {CreatedDate}");
        Console.WriteLine($"Max Age: {MaxAge}");
        
        // ❌ Cannot modify readonly after constructor
        // this.Id = 999;  // Error
    }
}

class Program
{
    static void Main()
    {
        Employee e = new Employee(101, "Raj");
        e.Display();
        
        // ❌ Cannot modify readonly from outside
        // e.Id = 999;  // Error
    }
}
```

---

## 3. Static Readonly

### Combining static with readonly

```csharp
using System;

class Configuration
{
    // Static readonly - initialized once
    public static readonly string ConnectionString;
    public static readonly DateTime StartupTime;
    
    // Static constructor initializes static readonly fields
    static Configuration()
    {
        ConnectionString = Environment.GetEnvironmentVariable("DB_CONNECTION")
                          ?? "Server=localhost;Database=App";
        StartupTime = DateTime.Now;
        Console.WriteLine("Configuration loaded at runtime");
    }
    
    // Instance readonly
    public readonly Guid SessionId;
    
    public Configuration()
    {
        SessionId = Guid.NewGuid();
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine($"Connection: {Configuration.ConnectionString}");
        Console.WriteLine($"Startup: {Configuration.StartupTime}");
        
        Configuration c1 = new Configuration();
        Configuration c2 = new Configuration();
        
        Console.WriteLine($"Session 1: {c1.SessionId}");
        Console.WriteLine($"Session 2: {c2.SessionId}");
    }
}
```

---

## 4. Const vs Readonly Comparison

| Feature | const | readonly |
|---------|-------|----------|
| **Initialization** | At declaration only | Declaration or constructor |
| **When value set** | Compile time | Runtime |
| **Implicit static** | Yes | No (can be static or instance) |
| **Reference types** | Only string and null | Any reference type |
| **Memory storage** | Inline in assembly | In memory at runtime |
| **Performance** | Slightly faster (inlined) | Regular field access |

---

## 5. Compile Time vs Runtime

### Const - Compile Time

```csharp
// Library.dll v1.0
public class Library
{
    public const int Version = 1;  // Compiled into calling code
}

// Program.exe (references Library.dll)
Console.WriteLine(Library.Version);  // 1 is embedded in Program.exe
```

> **Problem**: If Library.dll is updated to Version = 2, Program.exe will still show 1 unless recompiled!

### Readonly - Runtime

```csharp
public class Library
{
    public static readonly int Version = 1;  // Read at runtime
}

Console.WriteLine(Library.Version);  // Fetches from Library.dll at runtime
```

> **Solution**: If Library.dll is updated, Program.exe will get the new value.

---

## 6. Valid Types for Const

### Allowed Types
- All numeric types (int, float, double, etc.)
- bool
- char
- string
- enum
- null (for reference types)

```csharp
class ConstTypes
{
    public const int MAX_SIZE = 100;
    public const double PI = 3.14159;
    public const bool DEBUG = true;
    public const char SEPARATOR = ',';
    public const string MESSAGE = "Hello";
    public const DayOfWeek FirstDay = DayOfWeek.Monday;
    public const object NULL_REF = null;
    
    // ❌ NOT allowed - requires runtime
    // public const DateTime NOW = DateTime.Now;          // Error
    // public const int[] NUMBERS = { 1, 2, 3 };          // Error
    // public const MyClass INSTANCE = new MyClass();    // Error
}
```

---

## 7. Readonly with Reference Types

```csharp
using System;

class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}

class Demo
{
    // readonly reference type
    public readonly Person person;
    public readonly int[] numbers;
    
    public Demo()
    {
        person = new Person { Name = "Raj", Age = 25 };
        numbers = new int[] { 1, 2, 3, 4, 5 };
    }
    
    public void ModifyPerson()
    {
        // ❌ Cannot reassign reference
        // person = new Person();  // Error
        
        // ✅ CAN modify object's properties
        person.Name = "Priya";     // OK!
        person.Age = 30;           // OK!
        
        // ❌ Cannot reassign array
        // numbers = new int[] { 6, 7, 8 };  // Error
        
        // ✅ CAN modify array elements
        numbers[0] = 100;          // OK!
    }
}
```

> **Important**: `readonly` prevents reassignment of the reference, not modification of the object!

---

## 8. Const in Expression

### Const Can Be Used in Expressions

```csharp
class Demo
{
    public const int A = 10;
    public const int B = 20;
    public const int SUM = A + B;     // ✅ OK - compile-time calculation
    public const int PRODUCT = A * B; // ✅ OK
    
    // ❌ Cannot use runtime values
    // public const int X = int.Parse("10");  // Error
}
```

---

## 9. Best Practices

### When to Use Const
- Values that will **NEVER change** (mathematical constants, protocol versions)
- Values known **at compile time**
- Simple types only

```csharp
public const double PI = 3.14159265358979;
public const int MAX_RETRY = 3;
public const string PRODUCT_NAME = "MyApp";
```

### When to Use Readonly
- Values that might **vary per deployment** (connection strings, configuration)
- Values determined **at runtime**
- Reference types
- Values that could change in **future versions**

```csharp
public static readonly string ConnectionString = 
    ConfigurationManager.ConnectionStrings["DB"].ConnectionString;
    
public readonly DateTime CreatedAt;
public readonly Guid UniqueId;
```

---

## 10. Complete Example

```csharp
using System;

class BankAccount
{
    // Constants - never change
    public const double MIN_BALANCE = 1000;
    public const double INTEREST_RATE = 0.05;
    public const string BANK_NAME = "National Bank";
    
    // Static readonly - set once at startup
    public static readonly DateTime BankStarted;
    public static readonly int AccountNumberStart;
    
    // Instance readonly - set per object
    public readonly int AccountNumber;
    public readonly DateTime AccountOpened;
    
    // Regular fields
    private string holderName;
    private double balance;
    
    // Static counter for account numbers
    private static int counter;
    
    // Static constructor
    static BankAccount()
    {
        BankStarted = DateTime.Now;
        AccountNumberStart = 10000;
        counter = AccountNumberStart;
    }
    
    // Instance constructor
    public BankAccount(string name, double initialDeposit)
    {
        if (initialDeposit < MIN_BALANCE)
        {
            throw new ArgumentException(
                $"Initial deposit must be at least {MIN_BALANCE:C}");
        }
        
        counter++;
        AccountNumber = counter;
        AccountOpened = DateTime.Now;
        holderName = name;
        balance = initialDeposit;
    }
    
    public double CalculateInterest()
    {
        return balance * INTEREST_RATE;
    }
    
    public override string ToString()
    {
        return $"Account #{AccountNumber} ({holderName})\n" +
               $"Balance: {balance:C}\n" +
               $"Interest: {CalculateInterest():C}\n" +
               $"Bank: {BANK_NAME}\n" +
               $"Opened: {AccountOpened}";
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine($"Bank: {BankAccount.BANK_NAME}");
        Console.WriteLine($"Min Balance: {BankAccount.MIN_BALANCE:C}");
        Console.WriteLine($"Interest Rate: {BankAccount.INTEREST_RATE:P}");
        Console.WriteLine($"Bank Started: {BankAccount.BankStarted}");
        Console.WriteLine();
        
        BankAccount a1 = new BankAccount("Raj", 50000);
        BankAccount a2 = new BankAccount("Priya", 100000);
        
        Console.WriteLine(a1);
        Console.WriteLine();
        Console.WriteLine(a2);
    }
}
```

---

## Key Points Summary

1. **`const`** = Compile-time constant, must be primitive/string
2. **`readonly`** = Runtime constant, can be any type
3. **`const` is implicitly static**, readonly can be static or instance
4. **`const` value is inlined** in assembly, readonly stored in memory
5. **`readonly` can be set** in declaration or constructor only
6. **`readonly` reference types** = reference is readonly, not the object
7. Use **`const`** for truly constant values
8. Use **`readonly`** for runtime-determined or deployable values

---

## Practice Questions

1. What is the difference between const and readonly?
2. Can you have a const DateTime? Why or why not?
3. Is const static or instance?
4. Can you modify a readonly reference type's properties?
5. When would you choose readonly over const?
6. What happens if you update a const in a DLL and don't recompile dependent code?
