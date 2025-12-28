# Named and Default Arguments in C#

## Overview
Named and default arguments provide flexibility in method calls by allowing argument reordering and optional parameters. These features make APIs more usable and reduce the need for method overloads.

---

## 1. Default Arguments (Optional Parameters)

### What Are Default Arguments?
Parameters with default values that can be omitted when calling the method.

### Syntax

```csharp
void MethodName(type param1, type param2 = defaultValue)
{
    // Implementation
}
```

### Basic Example

```csharp
void Greet(string name, string greeting = "Hello", string punctuation = "!")
{
    Console.WriteLine($"{greeting}, {name}{punctuation}");
}

// Different ways to call
Greet("Raj");                    // Hello, Raj!
Greet("Raj", "Hi");              // Hi, Raj!
Greet("Raj", "Hey", "?");        // Hey, Raj?
Greet("Raj", "Good morning", ".");  // Good morning, Raj.
```

### Rules for Default Arguments

1. **Default parameters must be at the END** of the parameter list
2. Default values must be **compile-time constants**

```csharp
// ✅ Correct - default parameters at end
void Method(int required, string optional1 = "default", int optional2 = 0) { }

// ❌ Wrong - default parameter before required
// void Method(string optional = "default", int required) { }  // Error!
```

### Valid Default Values

```csharp
class Example
{
    // Compile-time constants
    void Method1(int x = 0) { }                    // ✅ numeric literal
    void Method2(string s = "default") { }        // ✅ string literal
    void Method3(bool b = true) { }               // ✅ boolean literal
    void Method4(object o = null) { }             // ✅ null
    void Method5(DayOfWeek d = DayOfWeek.Monday) { } // ✅ enum value
    void Method6(double d = Math.PI) { }          // ✅ const expression
    
    // ❌ NOT allowed - runtime values
    // void Method7(DateTime d = DateTime.Now) { }      // Error!
    // void Method8(List<int> list = new List<int>()) { } // Error!
}
```

---

## 2. Named Arguments

### What Are Named Arguments?
Specify parameter names when calling methods, allowing you to pass arguments in any order.

### Syntax

```csharp
MethodName(paramName: value, otherParam: value);
```

### Basic Example

```csharp
void CreateUser(string name, int age, string city, string country)
{
    Console.WriteLine($"Name: {name}, Age: {age}, City: {city}, Country: {country}");
}

// Traditional call (positional)
CreateUser("Raj", 25, "Mumbai", "India");

// Named arguments - any order works!
CreateUser(name: "Raj", age: 25, city: "Mumbai", country: "India");
CreateUser(country: "India", name: "Priya", city: "Delhi", age: 30);
CreateUser(age: 28, name: "Amit", country: "India", city: "Pune");
```

### Rules for Named Arguments

1. Named arguments can appear in **any order**
2. Named arguments must come **after positional arguments**
3. Makes code **more readable** for methods with many parameters

```csharp
// ✅ Correct - positional before named
CreateUser("Raj", 25, city: "Mumbai", country: "India");

// ❌ Wrong - positional after named
// CreateUser(name: "Raj", 25, "Mumbai", "India");  // Error!
```

---

## 3. Combining Default and Named Arguments

### The Power of Combination
Named arguments let you skip optional parameters in the middle.

```csharp
void PrintReport(
    string title,
    int copies = 1,
    bool color = false,
    string paperSize = "A4",
    bool doubleSided = true)
{
    Console.WriteLine($"Title: {title}");
    Console.WriteLine($"Copies: {copies}");
    Console.WriteLine($"Color: {color}");
    Console.WriteLine($"Paper: {paperSize}");
    Console.WriteLine($"Double-sided: {doubleSided}");
}

// Just title (all defaults)
PrintReport("Sales Report");

// Skip to specific optional parameters
PrintReport("Sales Report", color: true);
PrintReport("Sales Report", paperSize: "A3", copies: 5);
PrintReport("Sales Report", doubleSided: false, color: true);

// Mix positional and named
PrintReport("Sales Report", 3, color: true);
```

---

## 4. Real-World Examples

### Example 1: Email Sending

```csharp
void SendEmail(
    string to,
    string subject,
    string body,
    string cc = null,
    string bcc = null,
    bool isHtml = false,
    int priority = 3,
    List<string> attachments = null)
{
    Console.WriteLine($"To: {to}");
    Console.WriteLine($"Subject: {subject}");
    Console.WriteLine($"Body: {body}");
    if (cc != null) Console.WriteLine($"CC: {cc}");
    if (bcc != null) Console.WriteLine($"BCC: {bcc}");
    Console.WriteLine($"HTML: {isHtml}");
    Console.WriteLine($"Priority: {priority}");
}

// Simple email
SendEmail("user@email.com", "Hello", "How are you?");

// With specific options using named args
SendEmail(
    to: "user@email.com",
    subject: "Urgent Meeting",
    body: "Please attend the meeting.",
    priority: 1,
    isHtml: true
);

// CC and high priority
SendEmail(
    to: "boss@company.com",
    subject: "Report",
    body: "<h1>Monthly Report</h1>",
    cc: "team@company.com",
    isHtml: true,
    priority: 2
);
```

### Example 2: Database Query

```csharp
List<Product> GetProducts(
    string category = null,
    decimal? minPrice = null,
    decimal? maxPrice = null,
    bool inStockOnly = false,
    string sortBy = "Name",
    bool ascending = true,
    int page = 1,
    int pageSize = 20)
{
    Console.WriteLine($"Category: {category ?? "All"}");
    Console.WriteLine($"Price: {minPrice ?? 0} - {maxPrice ?? decimal.MaxValue}");
    Console.WriteLine($"In stock only: {inStockOnly}");
    Console.WriteLine($"Sort: {sortBy} {(ascending ? "ASC" : "DESC")}");
    Console.WriteLine($"Page: {page}, Size: {pageSize}");
    
    return new List<Product>();
}

// Simple call - get first page of all products
GetProducts();

// Filter by category and price
GetProducts(category: "Electronics", maxPrice: 1000);

// In stock, sorted by price descending
GetProducts(inStockOnly: true, sortBy: "Price", ascending: false);

// Pagination
GetProducts(page: 3, pageSize: 50);
```

### Example 3: Constructor with Optional Parameters

```csharp
class Employee
{
    public int Id { get; }
    public string Name { get; }
    public string Department { get; }
    public double Salary { get; }
    public string Email { get; }
    public DateTime JoinDate { get; }
    
    public Employee(
        int id,
        string name,
        string department = "General",
        double salary = 30000,
        string email = null,
        DateTime? joinDate = null)
    {
        Id = id;
        Name = name;
        Department = department;
        Salary = salary;
        Email = email ?? $"{name.ToLower().Replace(" ", ".")}@company.com";
        JoinDate = joinDate ?? DateTime.Now;
    }
    
    public override string ToString()
    {
        return $"{Name} ({Id}) - {Department}, {Salary:C}, {Email}";
    }
}

// Different ways to create employees
var e1 = new Employee(1, "Raj");
var e2 = new Employee(2, "Priya", "IT", 50000);
var e3 = new Employee(3, "Amit", department: "HR", salary: 45000);
var e4 = new Employee(
    id: 4,
    name: "Sneha",
    department: "Finance",
    email: "sneha@custom.com"
);

Console.WriteLine(e1);
Console.WriteLine(e2);
Console.WriteLine(e3);
Console.WriteLine(e4);
```

---

## 5. Default Arguments vs Method Overloading

### Traditional Overloading

```csharp
// Multiple overloads needed
void Log(string message)
{
    Log(message, LogLevel.Info);
}

void Log(string message, LogLevel level)
{
    Log(message, level, DateTime.Now);
}

void Log(string message, LogLevel level, DateTime timestamp)
{
    Console.WriteLine($"[{timestamp}] [{level}] {message}");
}
```

### With Default Arguments (Cleaner!)

```csharp
// Single method with defaults
void Log(
    string message,
    LogLevel level = LogLevel.Info,
    DateTime? timestamp = null)
{
    var time = timestamp ?? DateTime.Now;
    Console.WriteLine($"[{time}] [{level}] {message}");
}

Log("Application started");
Log("Error occurred", LogLevel.Error);
Log("Custom time", LogLevel.Debug, new DateTime(2025, 1, 1));
```

### When to Use Which?

| Default Arguments | Method Overloading |
|-------------------|-------------------|
| Simple parameter variations | Different logic per overload |
| Optional configurations | Need different signatures |
| Reducing code duplication | Compile-time type checking |
| API simplification | Better IntelliSense |

---

## 6. Caller Information Attributes

Special attributes that provide caller information as defaults:

```csharp
using System.Runtime.CompilerServices;

void Log(
    string message,
    [CallerMemberName] string memberName = "",
    [CallerFilePath] string filePath = "",
    [CallerLineNumber] int lineNumber = 0)
{
    Console.WriteLine($"[{Path.GetFileName(filePath)}:{lineNumber}] {memberName}(): {message}");
}

void ProcessData()
{
    Log("Processing started");  // Automatically captures caller info
    // ...
    Log("Processing completed");
}

// Output:
// [Program.cs:15] ProcessData(): Processing started
// [Program.cs:18] ProcessData(): Processing completed
```

---

## 7. Versioning Considerations

### Be Careful When Changing Defaults!

```csharp
// Version 1.0
void Process(int timeout = 30) { }  // Default: 30

// Version 2.0
void Process(int timeout = 60) { }  // Changed default to 60!

// ⚠️ Problem: Callers compiled against v1.0 will still use 30!
// Default values are embedded at compile time.
```

### Best Practice: Use Constants

```csharp
public const int DefaultTimeout = 30;

void Process(int timeout = DefaultTimeout) { }

// Allows callers to reference the constant:
Process(MyClass.DefaultTimeout);
```

---

## 8. Complete Example

```csharp
using System;
using System.IO;
using System.Runtime.CompilerServices;

class Logger
{
    public enum Level { Debug, Info, Warning, Error }
    
    public static void Log(
        string message,
        Level level = Level.Info,
        bool includeTimestamp = true,
        [CallerMemberName] string caller = "",
        [CallerLineNumber] int line = 0)
    {
        string timestamp = includeTimestamp ? $"[{DateTime.Now:HH:mm:ss}] " : "";
        string levelStr = $"[{level}]".PadRight(10);
        string location = $"({caller}:{line})";
        
        Console.WriteLine($"{timestamp}{levelStr} {message} {location}");
    }
}

class Program
{
    static void Main()
    {
        // Basic usage
        Logger.Log("Application started");
        
        // Custom level
        Logger.Log("Something went wrong", Logger.Level.Error);
        
        // Skip timestamp
        Logger.Log("Debug info", level: Logger.Level.Debug, includeTimestamp: false);
        
        // Named arguments for clarity
        Logger.Log(
            message: "Processing complete",
            level: Logger.Level.Info,
            includeTimestamp: true
        );
        
        ProcessItems();
    }
    
    static void ProcessItems()
    {
        Logger.Log("Processing items...");
        // Caller info automatically captured!
        Logger.Log("Done", Logger.Level.Debug);
    }
}
```

### Output:
```
[11:30:45] [Info]     Application started (Main:5)
[11:30:45] [Error]    Something went wrong (Main:8)
[Debug]    Debug info (Main:11)
[11:30:45] [Info]     Processing complete (Main:14)
[11:30:45] [Info]     Processing items... (ProcessItems:23)
[11:30:45] [Debug]    Done (ProcessItems:25)
```

---

## Key Points Summary

1. **Default arguments**: Parameters with default values, can be omitted
2. **Named arguments**: Specify parameter names with `name:` syntax
3. **Default parameters must be LAST** in parameter list
4. **Named arguments must come AFTER** positional arguments
5. Named arguments allow **skipping optional parameters**
6. Default values must be **compile-time constants**
7. Use **CallerInfo attributes** for automatic caller information
8. Consider **versioning** - defaults are embedded at compile time

---

## Common Mistakes to Avoid

1. ❌ Placing default parameters before required parameters
2. ❌ Using non-constant expressions as defaults
3. ❌ Mixing positional after named arguments
4. ❌ Changing defaults without understanding versioning impact
5. ❌ Creating too many optional parameters (consider builder pattern)

---

## Practice Questions

1. Can default parameters be at the beginning of a parameter list?
2. How do you skip middle optional parameters?
3. Can you mix positional and named arguments?
4. What types of values can be used as defaults?
5. What happens when you change a default value in a library?
6. What are CallerMemberName and CallerLineNumber used for?
