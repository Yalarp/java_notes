# Introduction to .NET Framework

## Overview
The .NET Framework is a software development platform developed by Microsoft that supports the development and execution of highly distributed, component-based applications. This chapter covers the fundamental concepts of .NET architecture.

---

## 1. Why .NET?

### Cross-Language Interoperability
While Java successfully addressed portability in the Internet environment, it lacks certain features:

1. **Cross-language interoperability** (mixed-language programming) - The ability for code produced by one language to work easily with code produced by another language.

2. **Full Windows Integration** - Java programs can execute in Windows (with JVM installed), but Java and Windows are not closely coupled.

### Languages Supported
.NET Framework supports multiple languages including:
- C#
- VB.NET
- F#
- And many other programming languages

> **Key Point**: When you compile C#, VB, or F#, all generate MSIL (Microsoft Intermediate Language) code which CLR executes.

---

## 2. C# Relationship with .NET Framework

C# was created at Microsoft in the late 1990s as part of Microsoft's overall .NET strategy. Its chief architect was **Anders Hejlsberg**.

Two key reasons for the special relationship:
1. **C# was initially designed to create code for .NET**
2. **The libraries used by C# are the ones defined by the .NET Framework**

---

## 3. .NET Framework Components

### Framework Class Library (FCL)

```
┌─────────────────────────────────────────────────────────────┐
│                    Class Library (FCL)                       │
├─────────────────────────────────────────────────────────────┤
│  BCL (Base Class Library)                                    │
├─────────────────────────────────────────────────────────────┤
│  Windows Forms    - Desktop Application                      │
│  WPF             - Desktop Application (uses XAML)           │
│  WCF             - Service Creation                          │
│  LINQ            - Query over dataset, database, Array       │
│  ASP.NET         - Web Application                           │
│  ADO.NET         - Database Connection                       │
└─────────────────────────────────────────────────────────────┘
```

| Component | Purpose |
|-----------|---------|
| **BCL** | Base Class Library - Core functionality |
| **Windows Forms** | Desktop Application development |
| **WPF** | Windows Presentation Foundation - Desktop apps with XAML |
| **WCF** | Windows Communication Foundation - Service creation |
| **LINQ** | Language Integrated Query - ORM for data querying |
| **ASP.NET** | Web Application development |
| **ADO.NET** | Database connectivity |

---

## 4. Common Language Runtime (CLR)

### What is CLR?
The **Common Language Runtime** manages the execution of .NET code. It's similar to JRE in Java.

### How CLR Works

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│   C# Source   │────>│    MSIL +     │────>│   Native      │
│    Code       │     │   Metadata    │     │    Code       │
│   (.cs)       │     │   (.exe/.dll) │     │               │
└───────────────┘     └───────────────┘     └───────────────┘
        │                     │                     │
        ▼                     ▼                     ▼
   C# Compiler           CLR Loads            JIT Compiles
   (csc.exe)             Assembly             at Runtime
```

### MSIL (Microsoft Intermediate Language)
When you compile a C# program:
- The output is **NOT** executable code
- It's a file containing **MSIL** (pseudocode)
- Similar to Byte Code in Java

> **Key Point**: Any program compiled to MSIL can run in any environment where CLR is implemented - this achieves portability.

---

## 5. JIT Compiler (Just-In-Time)

### How JIT Works

```
┌────────────────────────────────────────────────────────────┐
│                    JIT Compilation Process                  │
├────────────────────────────────────────────────────────────┤
│  1. .NET Program Executes                                   │
│  2. CLR Activates JIT Compiler                             │
│  3. JIT Converts MSIL to Native Code ON DEMAND             │
│  4. Only called functions are compiled (first invocation)  │
│  5. Compiled code is cached for reuse                      │
└────────────────────────────────────────────────────────────┘
```

### Characteristics:
- **On-Demand Compilation**: Each part of your program is compiled only when needed
- **Performance**: Program runs nearly as fast as native-compiled code
- **Portability**: Gains benefits of MSIL while maintaining performance
- **Caching**: Compiled code is cached and recompiled only if source changes

---

## 6. Metadata

Metadata describes the data used by your program and enables code interaction with other code.

- Contained in the same file as MSIL
- Enables cross-language interoperability
- Includes type information about the program

---

## 7. Managed vs Unmanaged Code

### Managed Code

```csharp
// Example of Managed Code (C#)
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("This is managed code");
    }
}
```

**Characteristics:**
- Executed under CLR control
- Compiler produces MSIL targeted for CLR
- Uses .NET class library
- Benefits:
  - Modern memory management
  - Support for mixed languages
  - Better security
  - Version control support
  - Clean component interaction

### Unmanaged Code

**Characteristics:**
- Does NOT execute under CLR
- All Windows programs prior to .NET are unmanaged
- Pointers in C# are unmanaged code
- Managed and unmanaged code can work together

---

## 8. Common Language Specification (CLS)

### What is CLS?
CLS describes a set of features that different .NET-compatible languages have in common.

**Purpose:**
- Maximum usability across languages
- Especially important for software components used by other languages

### Common Type System (CTS)
- Subset of CLS
- Defines rules concerning data types
- C# supports both CLS and CTS

---

## 9. Compilation and Execution Flow

### Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    .NET Program Execution Flow                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 1: Write C# Source Code                                   │
│          (filename.cs)                                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 2: Compile using csc.exe                                  │
│          Command: csc filename.cs                               │
│          Output:  filename.exe (PE file with MSIL + Manifest)   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 3: PE file imports _CorExeMain from mscoree.dll          │
│          (Entry point stub)                                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 4: OS loads PE and dependent DLLs                        │
│          OS jumps to entry point                                │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 5: _CorExeMain performs:                                  │
│          • Initializes CLR                                      │
│          • Locates managed entry point                          │
│          • Begins execution                                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  Step 6: JIT compiles MSIL to native code (on demand)          │
│          Compiled code is cached                                │
└─────────────────────────────────────────────────────────────────┘
```

### Manifest Contents:
- **Version info** - Assembly version
- **Culture info** - Localization information
- **Metadata** - Type information for the project

---

## 10. ILDASM Tool

### What is ILDASM?
**Intermediate Language Disassembler** - Displays metadata and MSIL code in readable format.

### How to Use:

**Method 1: File Location**
```
C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin\ildasm.exe
```

**Method 2: Visual Studio Command Prompt**
```
ildasm.exe
```

**EXE Location in Project:**
```
D:\practice\YourProject\bin\Debug\
```

---

## 11. Code Example with Explanation

```csharp
using System;  // Line 1: Import System namespace for Console class

namespace Basics  // Line 2: Define namespace for logical grouping
{
    class MyFirstCSharpClass  // Line 3: Entry point class (contains Main)
    {
        static void Main()  // Line 4: Main method - 'M' is capital
        {
            // Line 5: Console is static class, WriteLine is static method
            Console.WriteLine("Hello world");
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `using System;` | Imports System namespace containing Console class |
| 2 | `namespace Basics` | Logical grouping of classes, avoids name collision |
| 3 | `class MyFirstCSharpClass` | Class containing Main is called entry point class |
| 4 | `static void Main()` | Entry point method (M is capital in C#) |
| 5 | `Console.WriteLine()` | Static method of static class Console |

### Valid Main Method Signatures:

```csharp
// void return type versions
public static void Main(String[] args)
public static void Main()
private static void Main()
static void Main()

// int return type versions (require return 0;)
public static int Main(String[] args)
public static int Main()
private static int Main()
static int Main()
```

---

## 12. Memory Model in .NET

### Stack vs Heap

```
┌────────────────────────────────────────────────────────────────┐
│                         MEMORY MODEL                            │
├───────────────────────────────┬────────────────────────────────┤
│           STACK               │             HEAP                │
├───────────────────────────────┼────────────────────────────────┤
│ • Value types (int, float)    │ • Reference types (objects)    │
│ • Method parameters           │ • Arrays                       │
│ • Local variables             │ • Strings                      │
│ • Object references           │ • Class instances              │
│ • Fast allocation             │ • Garbage collected            │
│ • LIFO structure              │ • Dynamic allocation           │
└───────────────────────────────┴────────────────────────────────┘
```

### Visual Example:

```
Stack                    Heap
┌─────────┐             ┌─────────────────┐
│  myobj  │────────────>│   new Myclass   │
│  4000   │             │   sum() method  │
├─────────┤             │   sqr() method  │
│ result  │             └─────────────────┘
│    7    │
└─────────┘
```

---

## Key Points Summary

1. **.NET Framework** provides CLR for program execution and class libraries for development
2. **CLR** manages execution of .NET code and provides:
   - Memory management
   - Security
   - Cross-language interoperability
3. **MSIL** is intermediate code (similar to Java bytecode)
4. **JIT** compiles MSIL to native code on demand at runtime
5. **Metadata** describes types used in the program
6. **Managed code** runs under CLR control
7. **CLS** ensures cross-language compatibility
8. **CTS** defines common type rules
9. All source files have `.cs` extension
10. Compilation: `csc filename.cs` produces `.exe` file

---

## Self-Assessment Questions

1. What is CLR?
2. What is MSIL?
3. What is the use of JIT?
4. Who reads Managed Code?
5. What is CLS and CTS?
6. What should you use for Desktop Application?
7. What should you use for Web Application?
8. What is WCF and explain its use?
9. What is the difference between Managed and Unmanaged code?
10. What does _CorExeMain do?

---

## Practice Questions

1. Explain the complete execution flow when a C# program runs.
2. Compare CLR with JRE (Java Runtime Environment).
3. What are the benefits of using managed code?
4. Why is cross-language interoperability important?
5. How does JIT compilation improve both performance and portability?
