# Method Overloading in C#

## Overview
Method overloading allows you to define multiple methods with the same name but different parameter lists. This is a form of compile-time polymorphism that enables intuitive, flexible APIs.

---

## 1. What is Method Overloading?

### Definition
**Method overloading** means having multiple methods in the same class with the same name but different signatures (parameter lists).

```csharp
class Calculator
{
    public int Add(int a, int b) => a + b;
    public int Add(int a, int b, int c) => a + b + c;
    public double Add(double a, double b) => a + b;
    public string Add(string a, string b) => a + b;
}

Calculator calc = new Calculator();
Console.WriteLine(calc.Add(2, 3));        // 5 (int, int)
Console.WriteLine(calc.Add(2, 3, 4));     // 9 (int, int, int)
Console.WriteLine(calc.Add(2.5, 3.5));    // 6.0 (double, double)
Console.WriteLine(calc.Add("Hi", " "));   // "Hi " (string, string)
```

---

## 2. What Makes a Valid Overload?

### Methods Can Differ By:

1. **Number of parameters**
2. **Type of parameters**
3. **Order of parameter types**

```csharp
// ✅ Different number of parameters
void Process(int a) { }
void Process(int a, int b) { }
void Process(int a, int b, int c) { }

// ✅ Different types
void Process(int x) { }
void Process(string x) { }
void Process(double x) { }

// ✅ Different order of types
void Process(int x, string y) { }
void Process(string x, int y) { }
```

### Methods CANNOT Differ Only By:

1. **Return type**
2. **Parameter names**
3. **ref vs out** (they're considered the same)

```csharp
// ❌ Invalid - only return type differs
int GetValue() { return 1; }
string GetValue() { return "1"; }  // ERROR!

// ❌ Invalid - only parameter names differ
void Show(int a) { }
void Show(int b) { }  // ERROR!

// ❌ Invalid - ref and out are same signature
void Process(ref int x) { }
void Process(out int x) { x = 0; }  // ERROR!
```

### ref vs in vs Value Are Different

```csharp
// ✅ These ARE valid overloads
void Method(int x) { }           // By value
void Method(ref int x) { }       // By reference
void Method(in int x) { }        // Readonly reference

// Because call sites are different:
int n = 5;
Method(n);        // Calls by-value version
Method(ref n);    // Calls ref version
Method(in n);     // Calls in version
```

---

## 3. Constructor Overloading

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string City { get; set; }
    
    // Default constructor
    public Person() : this("Unknown", 0, "Unknown")
    {
    }
    
    // One parameter
    public Person(string name) : this(name, 0, "Unknown")
    {
    }
    
    // Two parameters
    public Person(string name, int age) : this(name, age, "Unknown")
    {
    }
    
    // All parameters (master constructor)
    public Person(string name, int age, string city)
    {
        Name = name;
        Age = age;
        City = city;
    }
}

// All valid:
Person p1 = new Person();
Person p2 = new Person("Raj");
Person p3 = new Person("Priya", 25);
Person p4 = new Person("Amit", 30, "Mumbai");
```

---

## 4. Overload Resolution

### How Compiler Chooses Which Overload to Call

The compiler picks the "best match" based on these rules:

1. **Exact match** is preferred
2. **Implicit conversions** considered if no exact match
3. **More specific type** wins over less specific

```csharp
class Demo
{
    void Print(int x) => Console.WriteLine("int");
    void Print(long x) => Console.WriteLine("long");
    void Print(double x) => Console.WriteLine("double");
    void Print(object x) => Console.WriteLine("object");
}

Demo d = new Demo();

d.Print(5);       // "int" - exact match
d.Print(5L);      // "long" - exact match
d.Print(5.0);     // "double" - exact match
d.Print(5.0f);    // "double" - float converts to double
d.Print("Hi");    // "object" - string → object
```

### Ambiguity Errors

```csharp
void Method(int x, double y) => Console.WriteLine("int, double");
void Method(double x, int y) => Console.WriteLine("double, int");

// ❌ Ambiguous call!
// Method(1, 1);  // Both require one implicit conversion
// ERROR: The call is ambiguous between...

// ✅ Fix with explicit casting
Method(1, 1.0);   // "int, double"
Method(1.0, 1);   // "double, int"
```

---

## 5. Overloading with Inheritance

### Derived Class Can Add Overloads

```csharp
class Animal
{
    public void Speak() => Console.WriteLine("Animal speaks");
    public void Speak(string message) => Console.WriteLine($"Animal says: {message}");
}

class Dog : Animal
{
    // Additional overload in derived class
    public void Speak(string message, int times)
    {
        for (int i = 0; i < times; i++)
            Console.WriteLine($"Dog: {message}");
    }
}

Dog d = new Dog();
d.Speak();                        // "Animal speaks"
d.Speak("Hello");                 // "Animal says: Hello"
d.Speak("Woof", 3);               // "Dog: Woof" (3 times)
```

### Hiding vs Overloading

```csharp
class Parent
{
    public void Method(int x) => Console.WriteLine("Parent: int");
}

class Child : Parent
{
    // This is a NEW overload (different signature)
    public void Method(string x) => Console.WriteLine("Child: string");
    
    // This would HIDE the parent method (same signature)
    // public new void Method(int x) => Console.WriteLine("Child: int");
}

Child c = new Child();
c.Method(5);       // "Parent: int" (inherited)
c.Method("Hi");    // "Child: string" (new overload)
```

---

## 6. Overloading with params

```csharp
void PrintAll(int single) => Console.WriteLine($"Single: {single}");
void PrintAll(int a, int b) => Console.WriteLine($"Two: {a}, {b}");
void PrintAll(params int[] numbers) => Console.WriteLine($"Params: {string.Join(", ", numbers)}");

PrintAll(1);           // "Single: 1" - exact match preferred
PrintAll(1, 2);        // "Two: 1, 2" - exact match preferred
PrintAll(1, 2, 3);     // "Params: 1, 2, 3" - only params matches
PrintAll(1, 2, 3, 4);  // "Params: 1, 2, 3, 4"
```

### params vs Array Parameter

```csharp
// These are the SAME signature - cannot coexist!
void Method(int[] arr) { }
void Method(params int[] arr) { }  // ERROR!
```

---

## 7. Overloading with Optional Parameters

```csharp
void Display(int x) => Console.WriteLine($"One param: {x}");
void Display(int x, int y = 0) => Console.WriteLine($"Two params: {x}, {y}");

// ⚠️ Ambiguous when called with one argument!
// Display(5);  // ERROR: Ambiguous!

// ✅ Works when second argument provided
Display(5, 10);  // "Two params: 5, 10"
```

### Best Practice: Avoid Overlapping Overloads

```csharp
// ✅ Better design - no overlap
void Display(int x) { }
void Display(int x, int y) { }  // No default for y
void Display(int x, int y, int z) { }
```

---

## 8. Practical Examples

### Example 1: String Formatting

```csharp
class Formatter
{
    // Format a single value
    public string Format(int value)
        => value.ToString();
    
    // Format with pattern
    public string Format(int value, string pattern)
        => value.ToString(pattern);
    
    // Format double
    public string Format(double value, int decimals = 2)
        => value.ToString($"F{decimals}");
    
    // Format date
    public string Format(DateTime date)
        => date.ToString("yyyy-MM-dd");
    
    public string Format(DateTime date, string pattern)
        => date.ToString(pattern);
}

var fmt = new Formatter();
Console.WriteLine(fmt.Format(42));                          // "42"
Console.WriteLine(fmt.Format(42, "D5"));                    // "00042"
Console.WriteLine(fmt.Format(3.14159));                     // "3.14"
Console.WriteLine(fmt.Format(3.14159, 4));                  // "3.1416"
Console.WriteLine(fmt.Format(DateTime.Now));                // "2025-12-28"
Console.WriteLine(fmt.Format(DateTime.Now, "dd/MM/yyyy"));  // "28/12/2025"
```

### Example 2: Database Query Builder

```csharp
class QueryBuilder
{
    // Find by ID
    public string FindById(int id)
        => $"SELECT * FROM table WHERE id = {id}";
    
    // Find by column value
    public string FindBy(string column, object value)
        => $"SELECT * FROM table WHERE {column} = '{value}'";
    
    // Find with multiple conditions
    public string FindBy(Dictionary<string, object> conditions)
    {
        var clauses = conditions.Select(kv => $"{kv.Key} = '{kv.Value}'");
        return $"SELECT * FROM table WHERE {string.Join(" AND ", clauses)}";
    }
    
    // Find with limit
    public string FindAll(int limit)
        => $"SELECT TOP {limit} * FROM table";
    
    public string FindAll(int skip, int take)
        => $"SELECT * FROM table OFFSET {skip} ROWS FETCH NEXT {take} ROWS ONLY";
}

var qb = new QueryBuilder();
Console.WriteLine(qb.FindById(42));
Console.WriteLine(qb.FindBy("name", "Raj"));
Console.WriteLine(qb.FindAll(10));
Console.WriteLine(qb.FindAll(20, 10));
```

### Example 3: File Operations

```csharp
class FileHelper
{
    // Read all text
    public string Read(string path)
        => File.ReadAllText(path);
    
    // Read with encoding
    public string Read(string path, Encoding encoding)
        => File.ReadAllText(path, encoding);
    
    // Read as lines
    public string[] Read(string path, bool asLines)
        => asLines ? File.ReadAllLines(path) : new[] { File.ReadAllText(path) };
    
    // Write text
    public void Write(string path, string content)
        => File.WriteAllText(path, content);
    
    // Write lines
    public void Write(string path, string[] lines)
        => File.WriteAllLines(path, lines);
    
    // Write with append option
    public void Write(string path, string content, bool append)
    {
        if (append)
            File.AppendAllText(path, content);
        else
            File.WriteAllText(path, content);
    }
}
```

---

## 9. Overloading vs Overriding

| Aspect | Overloading | Overriding |
|--------|-------------|------------|
| **Signature** | Different | Same |
| **Class** | Same class | Derived class |
| **Keywords** | None needed | `virtual`/`override` |
| **Binding** | Compile-time | Runtime |
| **Polymorphism** | Compile-time | Runtime |

```csharp
// Overloading - same class, different signatures
class Calculator
{
    int Add(int a, int b) => a + b;           // Overload 1
    double Add(double a, double b) => a + b;  // Overload 2
}

// Overriding - derived class, same signature
class Animal
{
    public virtual void Speak() => Console.WriteLine("...");
}

class Dog : Animal
{
    public override void Speak() => Console.WriteLine("Woof!");
}
```

---

## 10. Complete Example

```csharp
using System;
using System.Collections.Generic;

class Logger
{
    // Basic log
    public void Log(string message)
    {
        Log(message, LogLevel.Info);
    }
    
    // Log with level
    public void Log(string message, LogLevel level)
    {
        Log(message, level, DateTime.Now);
    }
    
    // Log with level and timestamp
    public void Log(string message, LogLevel level, DateTime timestamp)
    {
        Console.WriteLine($"[{timestamp:HH:mm:ss}] [{level,-7}] {message}");
    }
    
    // Log exception
    public void Log(Exception ex)
    {
        Log($"{ex.GetType().Name}: {ex.Message}", LogLevel.Error);
    }
    
    // Log exception with custom message
    public void Log(string message, Exception ex)
    {
        Log($"{message}: {ex.Message}", LogLevel.Error);
    }
    
    // Log object (serialized)
    public void Log(object obj)
    {
        Log($"Object: {obj}", LogLevel.Debug);
    }
    
    // Log dictionary
    public void Log(Dictionary<string, object> data)
    {
        foreach (var kv in data)
            Log($"  {kv.Key}: {kv.Value}", LogLevel.Debug);
    }
}

enum LogLevel { Debug, Info, Warning, Error }

class Program
{
    static void Main()
    {
        Logger log = new Logger();
        
        // Different overloads
        log.Log("Application started");
        log.Log("Processing...", LogLevel.Debug);
        log.Log("Warning!", LogLevel.Warning, DateTime.Now.AddHours(-1));
        
        try
        {
            throw new InvalidOperationException("Test error");
        }
        catch (Exception ex)
        {
            log.Log(ex);
            log.Log("Failed to process", ex);
        }
        
        log.Log(new { Name = "Raj", Age = 25 });
        log.Log(new Dictionary<string, object>
        {
            { "User", "Raj" },
            { "Action", "Login" }
        });
    }
}
```

---

## Key Points Summary

1. **Same name, different parameters** = method overloading
2. Valid differences: **count, types, order** of parameters
3. **Return type alone** doesn't create valid overload
4. **ref vs out** are same signature
5. Compiler picks **best match** at compile time
6. Avoid **ambiguous overloads** with optional parameters
7. This is **compile-time polymorphism**
8. Constructors can also be overloaded

---

## Common Mistakes to Avoid

1. ❌ Thinking return type creates different overload
2. ❌ Creating ambiguous overloads with optional params
3. ❌ Confusing overloading with overriding
4. ❌ Not understanding resolution order
5. ❌ Having ref and out with same types (same signature)

---

## Practice Questions

1. Can you overload by return type only?
2. Can ref and out create overloads of each other?
3. How does the compiler resolve overloaded method calls?
4. What is the difference between overloading and overriding?
5. Can constructors be overloaded?
6. What happens with ambiguous overloads?
7. How do params interact with overloading?
