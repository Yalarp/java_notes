# Static Classes in C#

## Overview
A static class is a class that cannot be instantiated and can only contain static members. It's perfect for utility classes and extension methods.

---

## 1. What is a Static Class?

### Definition
A static class is declared with the `static` keyword and can only contain static members.

### Characteristics
- Cannot be instantiated (no `new`)
- Contains only static members
- Implicitly sealed (cannot be inherited)
- Cannot have instance constructors
- Can have static constructor

### Syntax

```csharp
static class ClassName
{
    // Only static members allowed
    public static returnType MethodName() { }
    public static dataType FieldName;
}
```

---

## 2. Why Use Static Classes?

### Use Cases
1. **Utility methods** (Math operations, string helpers)
2. **Extension methods**
3. **Constants and configuration**
4. **Factory methods**
5. **Helper/Service classes**

---

## 3. Basic Example

```csharp
using System;

static class MathUtility
{
    // Static constant
    public const double PI = 3.14159265358979;
    
    // Static field
    public static int CalculationCount = 0;
    
    // Static constructor
    static MathUtility()
    {
        Console.WriteLine("MathUtility initialized");
    }
    
    // Static methods
    public static double Square(double x)
    {
        CalculationCount++;
        return x * x;
    }
    
    public static double Cube(double x)
    {
        CalculationCount++;
        return x * x * x;
    }
    
    public static bool IsEven(int n)
    {
        CalculationCount++;
        return n % 2 == 0;
    }
    
    public static bool IsPrime(int n)
    {
        CalculationCount++;
        if (n <= 1) return false;
        if (n <= 3) return true;
        if (n % 2 == 0 || n % 3 == 0) return false;
        
        for (int i = 5; i * i <= n; i += 6)
        {
            if (n % i == 0 || n % (i + 2) == 0)
                return false;
        }
        return true;
    }
}

class Program
{
    static void Main()
    {
        // ❌ Cannot instantiate static class
        // MathUtility obj = new MathUtility();  // Error!
        
        // ✅ Use class name to access members
        Console.WriteLine($"PI = {MathUtility.PI}");
        Console.WriteLine($"5² = {MathUtility.Square(5)}");
        Console.WriteLine($"3³ = {MathUtility.Cube(3)}");
        Console.WriteLine($"Is 7 prime? {MathUtility.IsPrime(7)}");
        Console.WriteLine($"Calculation count: {MathUtility.CalculationCount}");
    }
}
```

---

## 4. Static Class Rules

### What is Allowed

```csharp
static class ValidStaticClass
{
    // ✅ Static fields
    public static int count;
    private static string name;
    
    // ✅ Static properties
    public static int Count { get; set; }
    
    // ✅ Static methods
    public static void DoSomething() { }
    
    // ✅ Static constructor
    static ValidStaticClass() { }
    
    // ✅ Constants (implicitly static)
    public const double PI = 3.14;
    
    // ✅ Nested types
    public class NestedClass { }
}
```

### What is NOT Allowed

```csharp
static class InvalidStaticClass
{
    // ❌ Instance fields
    // public int instanceField;  // Error
    
    // ❌ Instance methods
    // public void InstanceMethod() { }  // Error
    
    // ❌ Instance constructor
    // public InvalidStaticClass() { }  // Error
    
    // ❌ Instance properties
    // public int Prop { get; set; }  // Error
}
```

---

## 5. Static Class is Sealed

```csharp
static class BaseStatic
{
    public static void Method() { }
}

// ❌ Cannot inherit from static class
// class Derived : BaseStatic { }  // Error!

// Static classes are implicitly sealed
// (cannot be base class)
```

---

## 6. Static Constructor in Static Class

```csharp
static class AppConfig
{
    public static readonly string Environment;
    public static readonly string Version;
    public static readonly DateTime LoadTime;
    
    // Static constructor - runs once before first access
    static AppConfig()
    {
        Console.WriteLine("Loading configuration...");
        
        Environment = Environment.GetEnvironmentVariable("APP_ENV") 
                      ?? "Development";
        Version = "1.0.0";
        LoadTime = DateTime.Now;
        
        Console.WriteLine("Configuration loaded!");
    }
    
    public static void ShowConfig()
    {
        Console.WriteLine($"Environment: {Environment}");
        Console.WriteLine($"Version: {Version}");
        Console.WriteLine($"Loaded at: {LoadTime}");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Before accessing AppConfig");
        
        // First access triggers static constructor
        AppConfig.ShowConfig();
        
        Console.WriteLine("\nSecond access:");
        AppConfig.ShowConfig();  // Constructor doesn't run again
    }
}
```

---

## 7. Comparison: Static Class vs Non-Static Class with Static Members

```csharp
// Static class approach
static class StaticHelper
{
    public static void DoWork() { }
}

// Non-static class with static members
class NonStaticHelper
{
    // Private constructor to prevent instantiation
    private NonStaticHelper() { }
    
    public static void DoWork() { }
}

// Usage
StaticHelper.DoWork();        // ✅
NonStaticHelper.DoWork();     // ✅

// Difference:
// new StaticHelper();        // Compile-time error
// new NonStaticHelper();     // Still compile-time error (private constructor)
```

### When to Use Each

| Static Class | Class with Private Constructor |
|--------------|-------------------------------|
| Pure utility methods | Singleton pattern |
| Extension methods (required) | Factory pattern |
| Simple, no state needed | May need instance later |

---

## 8. Built-in Static Classes

```csharp
using System;

class BuiltInStaticDemo
{
    static void Main()
    {
        // Math (static class)
        double sqrt = Math.Sqrt(16);      // 4
        double abs = Math.Abs(-5);        // 5
        int max = Math.Max(10, 20);       // 20
        
        // Console (static class)
        Console.WriteLine("Hello");
        string input = Console.ReadLine();
        
        // Environment (static class)
        string os = Environment.OSVersion.ToString();
        int processorCount = Environment.ProcessorCount;
        
        // Convert (static class)
        int num = Convert.ToInt32("42");
        
        // File (static class) - System.IO
        bool exists = System.IO.File.Exists("file.txt");
        
        // Path (static class) - System.IO
        string ext = System.IO.Path.GetExtension("file.txt");
    }
}
```

---

## 9. Extension Methods (Requires Static Class)

```csharp
using System;

// Extension methods must be in static class
static class StringExtensions
{
    // 'this' parameter makes it an extension method
    public static string Reverse(this string str)
    {
        char[] chars = str.ToCharArray();
        Array.Reverse(chars);
        return new string(chars);
    }
    
    public static bool IsNullOrEmpty(this string str)
    {
        return string.IsNullOrEmpty(str);
    }
    
    public static int WordCount(this string str)
    {
        if (string.IsNullOrWhiteSpace(str))
            return 0;
        return str.Split(new[] { ' ' }, 
            StringSplitOptions.RemoveEmptyEntries).Length;
    }
}

static class IntExtensions
{
    public static bool IsEven(this int number)
    {
        return number % 2 == 0;
    }
    
    public static bool IsPrime(this int number)
    {
        if (number <= 1) return false;
        for (int i = 2; i <= Math.Sqrt(number); i++)
            if (number % i == 0) return false;
        return true;
    }
}

class Program
{
    static void Main()
    {
        // String extensions
        string text = "Hello World";
        Console.WriteLine(text.Reverse());      // dlroW olleH
        Console.WriteLine(text.WordCount());    // 2
        
        string empty = "";
        Console.WriteLine(empty.IsNullOrEmpty()); // True
        
        // Int extensions
        int num = 7;
        Console.WriteLine($"Is {num} even? {num.IsEven()}");     // False
        Console.WriteLine($"Is {num} prime? {num.IsPrime()}");   // True
    }
}
```

---

## 10. Utility Class Pattern

```csharp
using System;

static class DateTimeHelper
{
    public static bool IsWeekend(DateTime date)
    {
        return date.DayOfWeek == DayOfWeek.Saturday 
            || date.DayOfWeek == DayOfWeek.Sunday;
    }
    
    public static bool IsBusinessHour(DateTime time)
    {
        return time.Hour >= 9 && time.Hour < 17;
    }
    
    public static string ToFriendlyString(DateTime date)
    {
        TimeSpan diff = DateTime.Now - date;
        
        if (diff.TotalMinutes < 1)
            return "Just now";
        if (diff.TotalMinutes < 60)
            return $"{(int)diff.TotalMinutes} minutes ago";
        if (diff.TotalHours < 24)
            return $"{(int)diff.TotalHours} hours ago";
        if (diff.TotalDays < 7)
            return $"{(int)diff.TotalDays} days ago";
        
        return date.ToString("MMM dd, yyyy");
    }
}

static class ValidationHelper
{
    public static bool IsValidEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return false;
        
        int atIndex = email.IndexOf('@');
        int dotIndex = email.LastIndexOf('.');
        
        return atIndex > 0 && dotIndex > atIndex + 1 
               && dotIndex < email.Length - 1;
    }
    
    public static bool IsValidPhoneNumber(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone))
            return false;
        
        string digits = new string(phone.Where(char.IsDigit).ToArray());
        return digits.Length == 10;
    }
}

class Program
{
    static void Main()
    {
        DateTime now = DateTime.Now;
        Console.WriteLine($"Is today weekend? {DateTimeHelper.IsWeekend(now)}");
        Console.WriteLine($"Is business hour? {DateTimeHelper.IsBusinessHour(now)}");
        
        DateTime past = DateTime.Now.AddHours(-3);
        Console.WriteLine($"Friendly: {DateTimeHelper.ToFriendlyString(past)}");
        
        Console.WriteLine($"Valid email: {ValidationHelper.IsValidEmail("test@example.com")}");
        Console.WriteLine($"Valid phone: {ValidationHelper.IsValidPhoneNumber("123-456-7890")}");
    }
}
```

---

## 11. Complete Example: Logger Utility

```csharp
using System;
using System.IO;

static class Logger
{
    // Static readonly configuration
    private static readonly string LogFilePath;
    private static readonly object LockObject = new object();
    
    public static LogLevel MinLevel { get; set; } = LogLevel.Info;
    
    static Logger()
    {
        LogFilePath = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
            "application.log");
    }
    
    public static void Debug(string message) => Log(LogLevel.Debug, message);
    public static void Info(string message) => Log(LogLevel.Info, message);
    public static void Warning(string message) => Log(LogLevel.Warning, message);
    public static void Error(string message) => Log(LogLevel.Error, message);
    
    private static void Log(LogLevel level, string message)
    {
        if (level < MinLevel) return;
        
        string logEntry = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] [{level}] {message}";
        
        // Thread-safe write
        lock (LockObject)
        {
            Console.WriteLine(logEntry);
            // File.AppendAllText(LogFilePath, logEntry + Environment.NewLine);
        }
    }
}

enum LogLevel
{
    Debug = 0,
    Info = 1,
    Warning = 2,
    Error = 3
}

class Program
{
    static void Main()
    {
        Logger.Debug("Debug message");    // Won't show (below MinLevel)
        Logger.Info("Application started");
        Logger.Warning("Low memory");
        Logger.Error("File not found");
        
        Logger.MinLevel = LogLevel.Debug;
        Logger.Debug("Now this shows");
    }
}
```

---

## Key Points Summary

1. **Static class** = Cannot be instantiated, only static members
2. **Implicitly sealed** = Cannot be inherited
3. **Perfect for utility methods** and extension methods
4. **No instance constructor** = Only static constructor allowed
5. **Extension methods** MUST be in static class
6. Examples: `Math`, `Console`, `File`, `Convert`
7. Use when **no instance state** is needed
8. Good for **helper/utility** functionality

---

## Practice Questions

1. What are the characteristics of a static class?
2. Can you inherit from a static class?
3. What types of members can a static class have?
4. Why must extension methods be in a static class?
5. Name some built-in static classes in .NET.
6. When would you use a static class vs a regular class with static members?
