# Structures (Structs) in C#

## Overview
A `struct` is a value type that can contain fields, methods, properties, and constructors. Structs are useful for lightweight data structures that don't require the overhead of classes.

---

## 1. What is a Struct?

### Definition
A **struct** (structure) is a user-defined value type that encapsulates a small group of related variables.

### Syntax

```csharp
struct StructName
{
    // Fields
    public dataType fieldName;
    
    // Constructor (must have parameters)
    public StructName(parameters)
    {
        // Initialize all fields
    }
    
    // Methods
    public returnType MethodName()
    {
        // Method body
    }
    
    // Properties
    public dataType PropertyName { get; set; }
}
```

---

## 2. Struct vs Class Comparison

| Feature | Struct | Class |
|---------|--------|-------|
| **Type** | Value type | Reference type |
| **Memory** | Stack | Heap |
| **Inheritance** | Cannot inherit (except System.ValueType) | Can inherit |
| **Can be inherited** | No (implicitly sealed) | Yes |
| **Default Constructor** | Cannot define (provided by system) | Can define |
| **Field Initialization** | Cannot initialize directly | Can initialize |
| **null Assignment** | Cannot (unless nullable) | Can |
| **Copy Behavior** | Full copy of data | Reference copy |

---

## 3. Memory Allocation

### Struct (Value Type)

```
Stack
┌──────────────┐
│ Point p1     │
│ ├── x = 10   │
│ └── y = 20   │
├──────────────┤
│ Point p2     │
│ ├── x = 10   │  <-- Full copy of data!
│ └── y = 20   │
└──────────────┘
```

### Class (Reference Type)

```
Stack                    Heap
┌──────────────┐        ┌──────────────┐
│ Point p1     │───────>│ x = 10       │
│ (address)    │        │ y = 20       │
├──────────────┤        └──────────────┘
│ Point p2     │───────────────┘
│ (address)    │        Both point to same object!
└──────────────┘
```

---

## 4. Basic Struct Example

```csharp
using System;

// Define a struct
struct Point
{
    public int X;
    public int Y;
    
    // Parameterized constructor
    public Point(int x, int y)
    {
        X = x;
        Y = y;
    }
    
    // Method
    public void Display()
    {
        Console.WriteLine($"Point: ({X}, {Y})");
    }
    
    // Override ToString
    public override string ToString()
    {
        return $"({X}, {Y})";
    }
}

class Program
{
    static void Main()
    {
        // Using default constructor (system provided)
        Point p1;  // X=0, Y=0
        p1.X = 10;
        p1.Y = 20;
        p1.Display();  // Point: (10, 20)
        
        // Using parameterized constructor
        Point p2 = new Point(30, 40);
        p2.Display();  // Point: (30, 40)
        
        // Using new with default constructor
        Point p3 = new Point();  // X=0, Y=0
        Console.WriteLine(p3);  // (0, 0)
    }
}
```

---

## 5. Struct Constructor Rules

### Rule 1: Cannot Define Parameterless Constructor

```csharp
struct MyStruct
{
    public int Value;
    
    // ❌ ERROR: Cannot define parameterless constructor in struct
    // public MyStruct()
    // {
    //     Value = 0;
    // }
    
    // ✅ CORRECT: Parameterized constructor
    public MyStruct(int value)
    {
        Value = value;
    }
}
```

> **Note**: C# 10+ allows parameterless constructors in structs, but earlier versions don't.

### Rule 2: Must Initialize All Fields in Constructor

```csharp
struct Person
{
    public string Name;
    public int Age;
    
    // ❌ ERROR: All fields must be assigned
    // public Person(string name)
    // {
    //     Name = name;  // Age not assigned!
    // }
    
    // ✅ CORRECT: All fields assigned
    public Person(string name, int age)
    {
        Name = name;
        Age = age;
    }
}
```

---

## 6. Field Initialization in Structs

### Cannot Initialize Fields at Declaration

```csharp
struct MyStruct
{
    // ❌ ERROR: Cannot initialize fields in struct declaration
    // public int Value = 10;
    
    // ✅ CORRECT: No initialization
    public int Value;
}
```

### Must Initialize Before Use

```csharp
struct Point
{
    public int X;
    public int Y;
}

class Program
{
    static void Main()
    {
        Point p;
        
        // ❌ ERROR: Use of unassigned local variable
        // Console.WriteLine(p.X);
        
        // ✅ CORRECT: Assign before use
        p.X = 10;
        p.Y = 20;
        Console.WriteLine(p.X);  // Now works
        
        // Alternative: Use new (initializes all to default)
        Point p2 = new Point();
        Console.WriteLine(p2.X);  // 0 (works)
    }
}
```

---

## 7. Value Type Copy Behavior

### Struct Copies All Data

```csharp
using System;

struct Point
{
    public int X;
    public int Y;
}

class Program
{
    static void Main()
    {
        Point p1 = new Point();
        p1.X = 10;
        p1.Y = 20;
        
        // Assignment creates FULL COPY
        Point p2 = p1;
        
        // Modify p2
        p2.X = 100;
        
        Console.WriteLine($"p1: ({p1.X}, {p1.Y})");  // (10, 20) - Unchanged!
        Console.WriteLine($"p2: ({p2.X}, {p2.Y})");  // (100, 20)
    }
}
```

### Memory Diagram

```
Before p2.X = 100:
Stack
┌───────────┐
│ p1.X = 10 │
│ p1.Y = 20 │
├───────────┤
│ p2.X = 10 │  <-- Independent copy
│ p2.Y = 20 │
└───────────┘

After p2.X = 100:
Stack
┌────────────┐
│ p1.X = 10  │  <-- Unchanged
│ p1.Y = 20  │
├────────────┤
│ p2.X = 100 │  <-- Only p2 changed
│ p2.Y = 20  │
└────────────┘
```

---

## 8. Structs and Methods

### Passing Struct to Method (By Value)

```csharp
using System;

struct Point
{
    public int X, Y;
}

class Program
{
    static void ModifyPoint(Point p)
    {
        p.X = 999;  // Modifies local copy
    }
    
    static void Main()
    {
        Point p1 = new Point();
        p1.X = 10;
        
        ModifyPoint(p1);  // Passes copy
        
        Console.WriteLine(p1.X);  // 10 - Unchanged!
    }
}
```

### Passing Struct by Reference

```csharp
static void ModifyPointRef(ref Point p)
{
    p.X = 999;  // Modifies original
}

static void Main()
{
    Point p1 = new Point();
    p1.X = 10;
    
    ModifyPointRef(ref p1);  // Passes reference
    
    Console.WriteLine(p1.X);  // 999 - Changed!
}
```

---

## 9. Structs Cannot Inherit

```csharp
// ❌ ERROR: Structs cannot inherit from other structs or classes
// struct DerivedStruct : SomeClass { }
// struct DerivedStruct : SomeStruct { }

// ✅ Structs can implement interfaces
interface IDisplayable
{
    void Display();
}

struct Point : IDisplayable
{
    public int X, Y;
    
    public void Display()
    {
        Console.WriteLine($"({X}, {Y})");
    }
}
```

---

## 10. When to Use Structs

### Use Struct When:
1. Logically represents a single value (like a Point, Color)
2. Instance size is small (< 16 bytes recommended)
3. Immutable preferred
4. Short-lived, created and destroyed frequently
5. No need for inheritance

### Use Class When:
1. Need inheritance
2. Instance is large
3. Reference semantics needed
4. Identity matters (comparing references)
5. Long-lived objects

---

## 11. Built-in Structs in .NET

```csharp
// Numeric types
int i = 10;          // System.Int32 (struct)
double d = 3.14;     // System.Double (struct)
decimal m = 19.99M;  // System.Decimal (struct)

// Other built-in structs
DateTime dt = DateTime.Now;
TimeSpan ts = TimeSpan.FromHours(2);
Guid id = Guid.NewGuid();

// Nullable value types (also structs)
int? nullable = null;
```

---

## 12. Struct with Properties

```csharp
struct Rectangle
{
    // Private fields
    private double _width;
    private double _height;
    
    // Properties
    public double Width
    {
        get { return _width; }
        set { _width = value > 0 ? value : 0; }
    }
    
    public double Height
    {
        get { return _height; }
        set { _height = value > 0 ? value : 0; }
    }
    
    // Calculated property (read-only)
    public double Area
    {
        get { return _width * _height; }
    }
    
    // Constructor
    public Rectangle(double width, double height)
    {
        _width = width > 0 ? width : 0;
        _height = height > 0 ? height : 0;
    }
    
    public void Display()
    {
        Console.WriteLine($"Width: {Width}, Height: {Height}, Area: {Area}");
    }
}

class Program
{
    static void Main()
    {
        Rectangle rect = new Rectangle(10, 5);
        rect.Display();  // Width: 10, Height: 5, Area: 50
        
        rect.Width = 20;
        rect.Display();  // Width: 20, Height: 5, Area: 100
    }
}
```

---

## 13. Complete Example: Employee Struct

```csharp
using System;

struct Employee
{
    // Fields
    private int _id;
    private string _name;
    private double _salary;
    private static int _counter;
    
    // Properties
    public int Id => _id;  // Read-only
    
    public string Name
    {
        get => _name;
        set => _name = !string.IsNullOrEmpty(value) ? value : "Unknown";
    }
    
    public double Salary
    {
        get => _salary;
        set => _salary = value >= 0 ? value : 0;
    }
    
    // Constructor
    public Employee(string name, double salary)
    {
        _counter++;
        _id = _counter;
        _name = !string.IsNullOrEmpty(name) ? name : "Unknown";
        _salary = salary >= 0 ? salary : 0;
    }
    
    // Methods
    public void GiveRaise(double percentage)
    {
        _salary += _salary * (percentage / 100);
    }
    
    public override string ToString()
    {
        return $"ID: {_id}, Name: {_name}, Salary: {_salary:C}";
    }
}

class Program
{
    static void Main()
    {
        Employee emp1 = new Employee("Raj", 50000);
        Employee emp2 = new Employee("Priya", 60000);
        
        Console.WriteLine(emp1);  // ID: 1, Name: Raj, Salary: $50,000.00
        Console.WriteLine(emp2);  // ID: 2, Name: Priya, Salary: $60,000.00
        
        emp1.GiveRaise(10);  // 10% raise
        Console.WriteLine($"After raise: {emp1}");
    }
}
```

---

## Key Points Summary

1. **Struct** = User-defined value type stored on stack
2. **Value Type Behavior** = Copy creates independent duplicate
3. **Cannot define parameterless constructor** (system provides default)
4. **Must initialize all fields** in constructor
5. **Cannot inherit** from classes or other structs
6. **Can implement interfaces**
7. **Implicitly sealed** - cannot be base class
8. **Use for small, simple data structures**
9. **Built-in types** (int, double) are actually structs

---

## Common Mistakes to Avoid

1. ❌ Trying to define parameterless constructor
2. ❌ Trying to inherit from another struct
3. ❌ Initializing fields at declaration
4. ❌ Expecting reference behavior (like class)
5. ❌ Using struct for large data structures

---

## Practice Questions

1. What is the difference between struct and class?
2. Why can't we define a parameterless constructor in struct?
3. Where is struct stored - stack or heap?
4. What happens when you assign one struct variable to another?
5. Can a struct implement an interface?
6. Can a struct inherit from another struct?
7. When should you use struct instead of class?
