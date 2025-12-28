# Assemblies and Global Assembly Cache (GAC)

## Overview
Assemblies are the fundamental units of deployment, version control, reuse, and security in .NET. This chapter covers assembly types, structure, and how to create and use them.

---

## 1. What is an Assembly?

### Definition
An **assembly** is a compiled code library used for deployment, versioning, and security. It's the building block of .NET applications.

### File Extensions
- `.exe` - Executable assembly (has Main method entry point)
- `.dll` - Dynamic Link Library (class library, no entry point)

---

## 2. Assembly Structure

### Four Main Components

```
┌────────────────────────────────────────────────────────────┐
│                        ASSEMBLY                             │
├────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    1. MANIFEST                        │  │
│  │  • Assembly name                                      │  │
│  │  • Version information (Major.Minor.Build.Revision)   │  │
│  │  • Culture information                                │  │
│  │  • Strong name info (if signed)                       │  │
│  │  • List of all files in assembly                      │  │
│  │  • Referenced assemblies                              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                 2. TYPE METADATA                      │  │
│  │  • Information about types (classes, interfaces)     │  │
│  │  • Methods, properties, fields                        │  │
│  │  • Enables reflection                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    3. MSIL CODE                       │  │
│  │  • Intermediate language bytecode                     │  │
│  │  • Compiled from source code                          │  │
│  │  • JIT compiled to native at runtime                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                   4. RESOURCES                        │  │
│  │  • Images, icons                                      │  │
│  │  • String tables                                      │  │
│  │  • Localization files                                 │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

---

## 3. Types of Assemblies

### 3.1 Private Assembly

**Definition**: Used by a single application, deployed in the application's directory.

**Characteristics**:
- Located in application folder (or subfolder)
- Only accessible by that application
- No version conflicts with other applications
- Simple deployment (just copy)

**Example Structure**:
```
MyApplication/
├── MyApp.exe           (Main application)
├── MyLibrary.dll       (Private assembly)
└── AnotherLib.dll      (Another private assembly)
```

### 3.2 Shared Assembly

**Definition**: Used by multiple applications, stored in the Global Assembly Cache (GAC).

**Characteristics**:
- Located in GAC (Global Assembly Cache)
- Must have a strong name (signed with cryptographic key)
- Version control prevents DLL Hell
- Any application can reference it

**GAC Location**:
```
C:\Windows\Microsoft.NET\assembly\GAC_MSIL\
```

### 3.3 Satellite Assembly

**Definition**: Contains localized resources for different cultures.

**Characteristics**:
- Contains only resources (no code)
- Named with culture identifier (e.g., `MyApp.resources.dll`)
- Located in culture-specific folders

**Example Structure**:
```
MyApplication/
├── MyApp.exe
├── en-US/
│   └── MyApp.resources.dll
├── fr-FR/
│   └── MyApp.resources.dll
└── de-DE/
    └── MyApp.resources.dll
```

---

## 4. Comparison Table

| Feature | Private Assembly | Shared Assembly | Satellite Assembly |
|---------|-----------------|-----------------|-------------------|
| **Location** | App folder | GAC | Culture subfolder |
| **Strong Name** | Not required | Required | Not required |
| **Sharing** | Single app | Multiple apps | For localization |
| **Versioning** | Not enforced | Enforced | N/A |
| **Contains** | Code + Resources | Code + Resources | Resources only |

---

## 5. Creating a Class Library (Private Assembly)

### Step 1: Create Class Library Project

Using .NET CLI:
```bash
dotnet new classlib -n MyLibrary
```

### Step 2: Write Code

```csharp
// MyLibrary/Calculator.cs
namespace MyLibrary
{
    public class Calculator
    {
        public int Add(int a, int b)
        {
            return a + b;
        }
        
        public int Subtract(int a, int b)
        {
            return a - b;
        }
        
        public int Multiply(int a, int b)
        {
            return a * b;
        }
        
        public double Divide(int a, int b)
        {
            if (b == 0)
                throw new DivideByZeroException("Cannot divide by zero");
            return (double)a / b;
        }
    }
}
```

### Step 3: Build the Library

```bash
dotnet build
```

Output: `MyLibrary.dll` in `bin/Debug/` folder

### Step 4: Reference in Another Project

Using .NET CLI:
```bash
dotnet add reference ../MyLibrary/MyLibrary.csproj
```

Or manually add to `.csproj`:
```xml
<ItemGroup>
  <ProjectReference Include="..\MyLibrary\MyLibrary.csproj" />
</ItemGroup>
```

### Step 5: Use the Library

```csharp
// Program.cs in consuming application
using System;
using MyLibrary;

class Program
{
    static void Main()
    {
        Calculator calc = new Calculator();
        
        Console.WriteLine(calc.Add(5, 3));       // 8
        Console.WriteLine(calc.Subtract(10, 4)); // 6
        Console.WriteLine(calc.Multiply(6, 7));  // 42
        Console.WriteLine(calc.Divide(15, 3));   // 5
    }
}
```

---

## 6. Strong Named Assembly

### What is a Strong Name?

A strong name consists of:
- Assembly name
- Version number
- Culture information
- Public key token

### Creating a Strong Named Assembly

#### Step 1: Generate Key Pair

```bash
sn -k MyKey.snk
```

#### Step 2: Sign the Assembly

Add to `.csproj`:
```xml
<PropertyGroup>
    <SignAssembly>true</SignAssembly>
    <AssemblyOriginatorKeyFile>MyKey.snk</AssemblyOriginatorKeyFile>
</PropertyGroup>
```

#### Step 3: Verify Strong Name

```bash
sn -v MyLibrary.dll
```

---

## 7. Global Assembly Cache (GAC)

### What is GAC?

The **Global Assembly Cache** is a machine-wide code cache that stores assemblies designed for sharing.

### GAC Location

```
.NET Framework: C:\Windows\assembly\
.NET Core/.NET 5+: C:\Windows\Microsoft.NET\assembly\
```

### Installing to GAC

Using gacutil:
```bash
gacutil -i MyLibrary.dll
```

### Viewing GAC

```bash
gacutil -l
```

### Removing from GAC

```bash
gacutil -u MyLibrary
```

---

## 8. Assembly Versioning

### Version Format

```
Major.Minor.Build.Revision
```

Example: `1.2.3.4`

| Component | Meaning |
|-----------|---------|
| **Major** | Breaking changes |
| **Minor** | New features (backward compatible) |
| **Build** | Bug fixes |
| **Revision** | Quick fixes |

### Setting Version in Code

```csharp
// AssemblyInfo.cs (older .NET Framework)
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
```

### Setting Version in .csproj

```xml
<PropertyGroup>
    <Version>1.0.0</Version>
    <AssemblyVersion>1.0.0.0</AssemblyVersion>
    <FileVersion>1.0.0.0</FileVersion>
</PropertyGroup>
```

---

## 9. Viewing Assembly Information

### Using ILDASM

```bash
ildasm MyLibrary.dll
```

Shows:
- Manifest
- Type information
- MSIL code
- Metadata

### Using Reflection in Code

```csharp
using System;
using System.Reflection;

class AssemblyInfoDemo
{
    static void Main()
    {
        Assembly assembly = Assembly.GetExecutingAssembly();
        
        Console.WriteLine($"Name: {assembly.GetName().Name}");
        Console.WriteLine($"Version: {assembly.GetName().Version}");
        Console.WriteLine($"Location: {assembly.Location}");
        
        // List all types
        foreach (Type type in assembly.GetTypes())
        {
            Console.WriteLine($"Type: {type.FullName}");
        }
    }
}
```

---

## 10. Complete Example: Creating and Using Library

### Library Project (MyMathLib)

```csharp
// MyMathLib/MathOperations.cs
namespace MyMathLib
{
    public class MathOperations
    {
        public static int Factorial(int n)
        {
            if (n < 0)
                throw new ArgumentException("Negative numbers not allowed");
            if (n <= 1) return 1;
            return n * Factorial(n - 1);
        }
        
        public static bool IsPrime(int n)
        {
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
        
        public static double Power(double baseNum, int exponent)
        {
            return Math.Pow(baseNum, exponent);
        }
    }
}
```

### Console Application Using the Library

```csharp
// Program.cs
using System;
using MyMathLib;

class Program
{
    static void Main()
    {
        // Using static methods from library
        Console.WriteLine($"5! = {MathOperations.Factorial(5)}");  // 120
        Console.WriteLine($"Is 17 prime? {MathOperations.IsPrime(17)}");  // True
        Console.WriteLine($"2^10 = {MathOperations.Power(2, 10)}");  // 1024
    }
}
```

---

## 11. DLL Hell and How .NET Solves It

### What is DLL Hell?

In older Windows development:
- Different apps might need different versions of same DLL
- Installing new app could overwrite DLL needed by old app
- No version control mechanism

### .NET Solution

1. **Private Assemblies**: Each app has its own copy
2. **Strong Naming**: Version + Public Key = Unique identity
3. **GAC**: Multiple versions can coexist
4. **Side-by-Side Execution**: Different versions run simultaneously

---

## Key Points Summary

1. **Assembly** = Deployment unit containing MSIL, metadata, manifest, resources
2. **Private Assembly** = Single app use, in app folder
3. **Shared Assembly** = Multiple apps, in GAC, requires strong name
4. **Satellite Assembly** = Resources only, for localization
5. **Strong Name** = Assembly name + Version + Culture + Public key
6. **GAC** = Global Assembly Cache for shared assemblies
7. **Version** = Major.Minor.Build.Revision
8. **.NET eliminates DLL Hell** through versioning and side-by-side execution

---

## Practice Questions

1. What is an assembly in .NET?
2. What are the four components of an assembly?
3. What is the difference between private and shared assemblies?
4. What is a strong name and why is it needed?
5. What is the GAC and when would you use it?
6. How does .NET solve the DLL Hell problem?
7. What is a satellite assembly used for?
