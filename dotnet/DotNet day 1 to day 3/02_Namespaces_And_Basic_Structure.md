# Namespaces and Basic Program Structure

## Overview
Namespaces provide a way to organize related types and avoid naming conflicts in large-scale applications. This chapter covers namespace concepts and the fundamental structure of a C# program.

---

## 1. What is a Namespace?

### Definition
A **namespace** is a logical grouping of related classes, interfaces, structs, enums, and delegates.

### Purpose
1. **Organizing Code**: Group related types together
2. **Avoiding Name Collisions**: Prevent class name conflicts
3. **Better Manageability**: Easier to maintain large codebases

---

## 2. Real-World Analogy

Think of namespaces like folders in a file system:

```
My Documents
├── Office/
│   ├── Report.docx
│   └── Presentation.pptx
└── Personal/
    ├── Report.docx       <-- Same name, no conflict!
    └── Photos.zip
```

Similarly in C#:
```
System
├── Console (class)
├── String (class)
└── Int32 (struct)

MyCompany.Project
├── Console (class)       <-- Same name, no conflict!
└── Helper (class)
```

---

## 3. Declaring a Namespace

### Basic Syntax

```csharp
namespace NamespaceName
{
    // classes, interfaces, structs, enums, delegates
    class ClassName
    {
        // class members
    }
}
```

### Complete Example

```csharp
// Line 1: Declare namespace called 'Basics'
namespace Basics
{
    // Line 2: Define a class within the namespace
    class MyFirstCSharpClass
    {
        // Line 3: Static Main method - entry point
        static void Main()
        {
            // Line 4: Use Console from System namespace
            System.Console.WriteLine("Hello World");
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Description |
|------|-------------|
| 1 | `namespace Basics` - Creates a logical container named "Basics" |
| 2 | `class MyFirstCSharpClass` - Entry point class containing Main |
| 3 | `static void Main()` - Program entry point (M is capital) |
| 4 | `System.Console.WriteLine` - Fully qualified name usage |

---

## 4. The `using` Directive

### Purpose
Allows you to use types from a namespace without specifying the full namespace path.

### Without `using`:

```csharp
namespace Basics
{
    class MyFirstCSharpClass
    {
        static void Main()
        {
            // Must use fully qualified name
            System.Console.WriteLine("Hello World");
        }
    }
}
```

### With `using`:

```csharp
using System;  // Import entire System namespace

namespace Basics
{
    class MyFirstCSharpClass
    {
        static void Main()
        {
            // Now can use Console directly
            Console.WriteLine("Hello World");
        }
    }
}
```

---

## 5. Namespace Access Modifiers

> **Important Rule**: Namespaces cannot have access modifiers!

```csharp
// ❌ WRONG - This will cause compile error
public namespace MyNamespace  // ERROR!
{
}

// ✅ CORRECT
namespace MyNamespace
{
}
```

**Why?** Namespaces are purely organizational constructs - they are not types and don't have visibility in the traditional sense.

---

## 6. Access Modifiers for Classes

### Top-Level Class (Declared Directly in Namespace)

| Modifier | Description |
|----------|-------------|
| `public` | Accessible from any assembly |
| `internal` | Accessible only within same assembly (DEFAULT) |

```csharp
namespace MyApp
{
    // Default is internal
    class InternalClass { }
    
    // Explicitly public
    public class PublicClass { }
}
```

### Default Access Modifier

> **Key Point**: For a top-level class, the default access modifier is `internal`, not `private`!

```csharp
// These two declarations are equivalent:
class MyClass { }
internal class MyClass { }
```

---

## 7. Access Modifiers for Class Members

### Default is `private`

```csharp
class MyClass
{
    int myField;           // private by default
    void MyMethod() { }    // private by default
    
    public int PublicField;        // explicitly public
    public void PublicMethod() { }
}
```

### All Access Modifiers:

| Modifier | Accessibility |
|----------|---------------|
| `public` | Accessible from anywhere |
| `private` | Accessible only within the class (DEFAULT for members) |
| `protected` | Accessible in class and derived classes |
| `internal` | Accessible within same assembly |
| `protected internal` | Accessible in derived classes OR same assembly |
| `private protected` | Accessible in derived classes within same assembly |

---

## 8. Basic C# Program Structure

### Complete Program Template

```csharp
// Section 1: Using directives (imports)
using System;
using System.Collections.Generic;

// Section 2: Namespace declaration
namespace MyApplication
{
    // Section 3: Class declaration
    class Program
    {
        // Section 4: Main method (entry point)
        static void Main(string[] args)
        {
            // Program logic here
            Console.WriteLine("Hello, World!");
        }
        
        // Section 5: Other methods
        static void HelperMethod()
        {
            // Helper logic
        }
    }
    
    // Other classes in same namespace
    class OtherClass
    {
    }
}
```

---

## 9. The Main Method

### Entry Point
- `Main` is the entry point of any C# application
- Must be `static` (can be called without object creation)
- **Important**: In C#, `Main` has capital 'M' (unlike Java's lowercase 'main')

### Valid Main Method Signatures

```csharp
// void return type versions
public static void Main(String[] args)    // With command line args
public static void Main()                  // Without args
private static void Main()                 // Private access
static void Main()                         // Default access

// int return type versions
public static int Main(String[] args)      // Must have return statement
public static int Main()
static int Main()

// Example with int return:
static int Main()
{
    Console.WriteLine("Processing...");
    return 0;  // Return 0 for success
}
```

---

## 10. Console Class

### Namespace
`System.Console` is a **static class** containing static methods for console I/O.

### Common Methods

```csharp
using System;

class ConsoleDemo
{
    static void Main()
    {
        // Output methods
        Console.Write("Hello ");           // No newline
        Console.WriteLine("World!");       // With newline
        
        // Input methods
        string input = Console.ReadLine(); // Read a line
        int key = Console.Read();          // Read single character (returns int)
        
        // Formatted output
        Console.WriteLine("Value: {0}", 42);
        Console.WriteLine($"Name: {"John"}");  // String interpolation
        
        // Wait for key press
        Console.ReadKey();
    }
}
```

### Method Comparison

| Method | Description |
|--------|-------------|
| `Write()` | Output without newline |
| `WriteLine()` | Output with newline |
| `Read()` | Read single character (returns int) |
| `ReadLine()` | Read entire line (returns string) |
| `ReadKey()` | Read a key press |

---

## 11. Nested Namespaces

### Syntax

```csharp
namespace Company
{
    namespace Project
    {
        namespace Module
        {
            class MyClass { }
        }
    }
}

// Shortened syntax (preferred):
namespace Company.Project.Module
{
    class MyClass { }
}
```

### Using Nested Namespaces

```csharp
using Company.Project.Module;

// Or use fully qualified name:
Company.Project.Module.MyClass obj = new Company.Project.Module.MyClass();
```

---

## 12. Static Using Directive (C# 6.0+)

### Traditional Way

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello");
        double result = Math.Sqrt(16);
    }
}
```

### With Static Using

```csharp
using static System.Console;
using static System.Math;

class Program
{
    static void Main()
    {
        WriteLine("Hello");        // No need for Console.
        double result = Sqrt(16);  // No need for Math.
    }
}
```

---

## 13. Execution Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     C# Program Execution                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  1. Source Code Written (Program.cs)                            │
│     - using directives at top                                   │
│     - namespace declaration                                     │
│     - class with Main() method                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. Compile with csc.exe                                        │
│     Command: csc Program.cs                                     │
│     Output:  Program.exe (MSIL + Manifest)                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. Execute Program.exe                                         │
│     - CLR loads the assembly                                    │
│     - Looks for static Main() method                            │
│     - JIT compiles Main() to native code                        │
│     - Execution begins                                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## 14. Multiple Classes in One Namespace

```csharp
using System;

namespace SchoolManagement
{
    // Class 1: Student
    class Student
    {
        public string Name;
        public int RollNo;
        
        public void Display()
        {
            Console.WriteLine($"Name: {Name}, Roll: {RollNo}");
        }
    }
    
    // Class 2: Teacher
    class Teacher
    {
        public string Name;
        public string Subject;
    }
    
    // Entry point class
    class Program
    {
        static void Main()
        {
            Student s = new Student();
            s.Name = "Raj";
            s.RollNo = 101;
            s.Display();
        }
    }
}
```

---

## Key Points Summary

1. **Namespace** provides logical grouping and avoids name collisions
2. **`using` directive** imports namespaces to avoid fully qualified names
3. **Namespaces cannot have access modifiers**
4. **Default access for top-level class** is `internal`
5. **Default access for class members** is `private`
6. **Main method** is the entry point (capital 'M' in C#)
7. **Console class** is static - used for console I/O
8. **Static using** allows importing static members directly

---

## Common Mistakes to Avoid

1. ❌ Adding access modifier to namespace
2. ❌ Using lowercase 'main' instead of 'Main'
3. ❌ Forgetting `using System;` and getting "Console not found" error
4. ❌ Thinking default access for class is `private` (it's `internal`)
5. ❌ Not understanding difference between `Read()` (returns int) and `ReadLine()` (returns string)

---

## Practice Questions

1. What is a namespace and why is it needed?
2. What is the default access modifier for a top-level class?
3. What is the default access modifier for class members?
4. Can namespaces have access modifiers? Why or why not?
5. Write a program that uses two classes from different namespaces with the same class name.
6. What is the difference between `Console.Write()` and `Console.WriteLine()`?
7. List all valid signatures for the `Main` method.
8. Explain the purpose of `using static`.
