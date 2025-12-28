# Enumerations (Enums) in C#

## Overview
An enumeration (enum) is a distinct value type that defines a set of named constants. Enums make code more readable and maintainable by replacing magic numbers with meaningful names.

---

## 1. What is an Enum?

### Definition
An **enum** (enumeration) is a user-defined value type consisting of a set of named constants called enumerators.

### Why Use Enums?
1. **Readability**: `DayOfWeek.Monday` is clearer than `1`
2. **Type Safety**: Compiler prevents invalid assignments
3. **Maintainability**: Easy to add/modify values
4. **IntelliSense**: IDE shows available options

---

## 2. Basic Enum Declaration

### Syntax

```csharp
enum EnumName
{
    Value1,     // 0 by default
    Value2,     // 1
    Value3      // 2
}
```

### Example

```csharp
using System;

// Declare enum
enum DaysOfWeek
{
    Sunday,     // 0
    Monday,     // 1
    Tuesday,    // 2
    Wednesday,  // 3
    Thursday,   // 4
    Friday,     // 5
    Saturday    // 6
}

class Program
{
    static void Main()
    {
        DaysOfWeek today = DaysOfWeek.Wednesday;
        
        Console.WriteLine(today);        // Wednesday
        Console.WriteLine((int)today);   // 3
    }
}
```

---

## 3. Enum Values (Indexing)

### Default Indexing (Starts at 0)

```csharp
enum Color
{
    Red,      // 0
    Green,    // 1
    Blue      // 2
}
```

### Custom Starting Value

```csharp
enum ErrorCode
{
    Success = 1,    // 1
    Warning,        // 2 (continues from previous)
    Error           // 3
}
```

### Custom Values for Each

```csharp
enum HttpStatus
{
    OK = 200,
    NotFound = 404,
    InternalServerError = 500
}
```

### Non-Sequential Values

```csharp
enum FileAccess
{
    Read = 1,
    Write = 2,
    Execute = 4,
    ReadWrite = 3,       // Read + Write
    All = 7              // Read + Write + Execute
}
```

---

## 4. Using Enums

### Declaration and Assignment

```csharp
// Method 1: Direct assignment
DaysOfWeek day1 = DaysOfWeek.Monday;

// Method 2: Using default
DaysOfWeek day2 = default;  // First value (Sunday = 0)

// Method 3: Cast from int
DaysOfWeek day3 = (DaysOfWeek)3;  // Wednesday
```

### Getting Enum Value as Integer

```csharp
DaysOfWeek day = DaysOfWeek.Friday;
int value = (int)day;  // 5
Console.WriteLine(value);  // 5
```

### Getting Enum Name from Value

```csharp
string name = Enum.GetName(typeof(DaysOfWeek), 3);
Console.WriteLine(name);  // Wednesday
```

---

## 5. Enum in Switch Statements

```csharp
using System;

enum TrafficLight
{
    Red,
    Yellow,
    Green
}

class Program
{
    static void Main()
    {
        TrafficLight signal = TrafficLight.Red;
        
        switch (signal)
        {
            case TrafficLight.Red:
                Console.WriteLine("Stop!");
                break;
            case TrafficLight.Yellow:
                Console.WriteLine("Slow down!");
                break;
            case TrafficLight.Green:
                Console.WriteLine("Go!");
                break;
        }
    }
}
```

---

## 6. Enum Methods

### Common Enum Methods

```csharp
using System;

enum Months
{
    January = 1,
    February,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December
}

class Program
{
    static void Main()
    {
        // Get all names
        string[] names = Enum.GetNames(typeof(Months));
        Console.WriteLine("All months:");
        foreach (string name in names)
        {
            Console.WriteLine(name);
        }
        
        // Get all values
        Array values = Enum.GetValues(typeof(Months));
        Console.WriteLine("\nAll values:");
        foreach (int value in values)
        {
            Console.WriteLine(value);
        }
        
        // Check if value is defined
        bool isDefined = Enum.IsDefined(typeof(Months), 5);
        Console.WriteLine($"\nIs 5 defined? {isDefined}");  // True (May)
        
        // Parse string to enum
        Months month = (Months)Enum.Parse(typeof(Months), "March");
        Console.WriteLine($"\nParsed: {month}");  // March
        
        // Get name from value
        string monthName = Enum.GetName(typeof(Months), 7);
        Console.WriteLine($"\nMonth 7: {monthName}");  // July
    }
}
```

---

## 7. Enum Underlying Type

### Default is int

```csharp
enum DefaultEnum
{
    A, B, C  // Stored as int32
}
```

### Specify Different Underlying Type

```csharp
enum SmallEnum : byte    // 8-bit
{
    A, B, C
}

enum LargeEnum : long    // 64-bit
{
    A, B, C
}

// Supported underlying types:
// byte, sbyte, short, ushort, int, uint, long, ulong
```

---

## 8. Flags Enum (Bitwise Operations)

### Defining a Flags Enum

```csharp
using System;

[Flags]
enum FilePermission
{
    None = 0,
    Read = 1,        // 0001
    Write = 2,       // 0010
    Execute = 4,     // 0100
    Delete = 8,      // 1000
    All = Read | Write | Execute | Delete  // 1111 = 15
}

class Program
{
    static void Main()
    {
        // Combine flags
        FilePermission userPerm = FilePermission.Read | FilePermission.Write;
        Console.WriteLine(userPerm);  // Read, Write
        Console.WriteLine((int)userPerm);  // 3
        
        // Check if flag is set
        bool canRead = (userPerm & FilePermission.Read) == FilePermission.Read;
        Console.WriteLine($"Can Read: {canRead}");  // True
        
        // Using HasFlag method (easier)
        bool canWrite = userPerm.HasFlag(FilePermission.Write);
        Console.WriteLine($"Can Write: {canWrite}");  // True
        
        bool canExecute = userPerm.HasFlag(FilePermission.Execute);
        Console.WriteLine($"Can Execute: {canExecute}");  // False
        
        // Add a flag
        userPerm |= FilePermission.Execute;
        Console.WriteLine(userPerm);  // Read, Write, Execute
        
        // Remove a flag
        userPerm &= ~FilePermission.Execute;
        Console.WriteLine(userPerm);  // Read, Write
    }
}
```

---

## 9. Enum with Methods (Extension Methods)

```csharp
using System;

enum Grade
{
    A = 1,
    B = 2,
    C = 3,
    D = 4,
    F = 5
}

static class GradeExtensions
{
    public static string GetDescription(this Grade grade)
    {
        switch (grade)
        {
            case Grade.A: return "Excellent";
            case Grade.B: return "Good";
            case Grade.C: return "Average";
            case Grade.D: return "Below Average";
            case Grade.F: return "Fail";
            default: return "Unknown";
        }
    }
    
    public static bool IsPassing(this Grade grade)
    {
        return grade != Grade.F;
    }
}

class Program
{
    static void Main()
    {
        Grade myGrade = Grade.B;
        
        Console.WriteLine(myGrade.GetDescription());  // Good
        Console.WriteLine(myGrade.IsPassing());       // True
    }
}
```

---

## 10. Practical Example: Employee Department

```csharp
using System;

enum Department
{
    HR = 1,
    IT,
    Sales,
    Marketing,
    Finance
}

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Salary { get; set; }
    public Department Dept { get; set; }
    
    public Employee(int id, string name, double salary, Department dept)
    {
        Id = id;
        Name = name;
        Salary = salary;
        Dept = dept;
    }
    
    public double PayTax()
    {
        double taxRate = 0.1;  // 10%
        return Salary * taxRate;
    }
    
    public override string ToString()
    {
        return $"ID: {Id}, Name: {Name}, Salary: {Salary:C}, " +
               $"Dept: {Dept}, Tax: {PayTax():C}";
    }
}

class Program
{
    static void Main()
    {
        Employee emp1 = new Employee(1, "Raj", 50000, Department.IT);
        Employee emp2 = new Employee(2, "Priya", 60000, Department.HR);
        Employee emp3 = new Employee(3, "Amit", 55000, Department.Sales);
        
        Console.WriteLine(emp1);
        Console.WriteLine(emp2);
        Console.WriteLine(emp3);
        
        // Filter by department
        Employee[] employees = { emp1, emp2, emp3 };
        
        Console.WriteLine("\nIT Department:");
        foreach (var emp in employees)
        {
            if (emp.Dept == Department.IT)
                Console.WriteLine(emp.Name);
        }
    }
}
```

---

## 11. Built-in .NET Enums

### Common Framework Enums

```csharp
using System;

class BuiltInEnumsDemo
{
    static void Main()
    {
        // DayOfWeek
        DayOfWeek today = DateTime.Now.DayOfWeek;
        Console.WriteLine($"Today is: {today}");
        
        // ConsoleColor
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Green text!");
        Console.ResetColor();
        
        // StringComparison
        bool equals = "Hello".Equals("hello", StringComparison.OrdinalIgnoreCase);
        Console.WriteLine($"Case-insensitive match: {equals}");  // True
        
        // DateTimeKind
        DateTime utc = DateTime.SpecifyKind(DateTime.Now, DateTimeKind.Utc);
        Console.WriteLine($"Kind: {utc.Kind}");
        
        // Environment.SpecialFolder
        string desktop = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
        Console.WriteLine($"Desktop path: {desktop}");
    }
}
```

---

## 12. Converting Between Enum and String

### String to Enum

```csharp
// Using Enum.Parse
DaysOfWeek day1 = (DaysOfWeek)Enum.Parse(typeof(DaysOfWeek), "Monday");

// Using Enum.TryParse (safer)
if (Enum.TryParse<DaysOfWeek>("Friday", out DaysOfWeek day2))
{
    Console.WriteLine(day2);  // Friday
}

// Case-insensitive
Enum.TryParse<DaysOfWeek>("MONDAY", true, out DaysOfWeek day3);
```

### Enum to String

```csharp
DaysOfWeek day = DaysOfWeek.Wednesday;

string name1 = day.ToString();                    // "Wednesday"
string name2 = Enum.GetName(typeof(DaysOfWeek), day);  // "Wednesday"
string formatted = $"Today is {day}";             // "Today is Wednesday"
```

---

## 13. Enum Best Practices

### Do's ✅

```csharp
// 1. Use singular names for non-flags
enum Color { Red, Green, Blue }

// 2. Use plural names for flags
[Flags]
enum Colors { Red = 1, Green = 2, Blue = 4 }

// 3. Define a "None" or default value
enum Status { None = 0, Active = 1, Inactive = 2 }

// 4. Use powers of 2 for flags
[Flags]
enum Permissions { None = 0, Read = 1, Write = 2, Execute = 4 }
```

### Don'ts ❌

```csharp
// 1. Don't use enum for ever-changing values
enum Categories { ... }  // Better use database table

// 2. Don't use consecutive values for flags
[Flags]
enum Wrong { A = 1, B = 2, C = 3 }  // C overlaps with A|B!

// 3. Don't use enum suffix in name
enum DayOfWeekEnum { ... }  // Just "DayOfWeek"
```

---

## Key Points Summary

1. **Enum** = Set of named constants (value type)
2. **Default indexing** starts at 0
3. **Can customize** starting value and individual values
4. **Underlying type** is `int` by default, can change
5. **[Flags] attribute** for bitwise combinations
6. **Enum.Parse()** converts string to enum
7. **ToString()** converts enum to string
8. **Enum.GetNames()** and **Enum.GetValues()** for iteration
9. **Type-safe** alternative to magic numbers
10. **Stored on stack** (value type)

---

## Practice Questions

1. What is an enum and why use it?
2. What is the default underlying type of an enum?
3. How do you get the integer value of an enum?
4. What is the [Flags] attribute used for?
5. How do you convert a string to an enum safely?
6. Can enum values be negative?
7. How do you iterate through all values of an enum?
8. What happens if you cast an invalid integer to an enum?
