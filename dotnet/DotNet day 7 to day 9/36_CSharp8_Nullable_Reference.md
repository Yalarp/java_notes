# C# 8-9 New Features - Nullable Reference Types, Init-Only, Records

## 📚 Introduction

C# 8 and 9 introduced major language features: nullable reference types improve null safety, init-only properties allow immutable object initialization, and records provide value-based equality for reference types.

---

## 🎯 Learning Objectives

- Enable and use nullable reference types
- Understand init-only properties for immutability
- Create and use records for data classes

---

## 📖 Part 1: Nullable Reference Types (C# 8)

```
┌────────────────────────────────────────────────────────────────┐
│               Nullable Reference Types (C# 8)                   │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem: NullReferenceException is common bug                 │
│                                                                 │
│  Solution: Compiler warns about potential null issues          │
│                                                                 │
│  string nonNull = "hello";   // Cannot be null                 │
│  string? nullable = null;    // Explicitly nullable            │
│                                                                 │
│  // Compiler warning if you try:                               │
│  int length = nullable.Length;  // ⚠️ May be null!            │
│                                                                 │
│  // Safe access:                                                │
│  int? length = nullable?.Length;  // Null-conditional          │
│  int length = nullable!.Length;   // Null-forgiving (trust me) │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Nullable Reference Types Example

```csharp
#nullable enable   // Enable nullable reference types

using System;

class Person
{
    // Non-nullable property (must be set)
    public string Name { get; set; }       // Required
    
    // Nullable property (can be null)
    public string? MiddleName { get; set; }  // Optional
    
    // Constructor must initialize non-nullable properties
    public Person(string name)
    {
        Name = name;  // Required
        // MiddleName defaults to null (allowed because nullable)
    }
}

class Program
{
    static void Main()
    {
        Person person = new Person("John");
        
        // ✅ Safe - Name cannot be null
        Console.WriteLine(person.Name.ToUpper());
        
        // ❌ Warning - MiddleName might be null
        // Console.WriteLine(person.MiddleName.Length);  // Warning!
        
        // ✅ Safe access with null-conditional
        Console.WriteLine(person.MiddleName?.ToUpper() ?? "No middle name");
        
        // ✅ Null check first
        if (person.MiddleName != null)
        {
            Console.WriteLine(person.MiddleName.Length);  // Safe now
        }
        
        // ⚠️ Null-forgiving operator (use carefully!)
        string middle = person.MiddleName!;  // "Trust me, it's not null"
    }
}
```

---

## 📖 Part 2: Init-Only Properties (C# 9)

```
┌────────────────────────────────────────────────────────────────┐
│                Init-Only Properties (C# 9)                      │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Problem: Want immutable objects but also object initializers  │
│                                                                 │
│  readonly fields:                                               │
│  - Only via constructor                                        │
│  - No object initializer syntax                                │
│                                                                 │
│  public properties (get; set;):                                │
│  - Can be changed anytime (mutable)                            │
│                                                                 │
│  init-only (get; init;):                                       │
│  - Can use object initializer                                  │
│  - Cannot change after initialization                          │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Init-Only Properties Example

```csharp
using System;

// C# 9 init-only properties
class Person
{
    public string FirstName { get; init; }  // Set only during init
    public string LastName { get; init; }   // Set only during init
    public int Age { get; init; }           // Set only during init
    
    // Can still have read-write properties if needed
    public string Email { get; set; }
    
    // Computed property (always read-only)
    public string FullName => $"{FirstName} {LastName}";
}

class Program
{
    static void Main()
    {
        // ✅ Object initializer works with init properties
        var person = new Person
        {
            FirstName = "John",
            LastName = "Doe",
            Age = 30
        };
        
        Console.WriteLine(person.FullName);  // "John Doe"
        
        // ❌ Cannot modify init-only properties after creation
        // person.FirstName = "Jane";  // Compile error!
        
        // ✅ Read-write property can still be changed
        person.Email = "john@example.com";
    }
}
```

---

## 📖 Part 3: Records (C# 9)

```
┌────────────────────────────────────────────────────────────────┐
│                       Records (C# 9)                            │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Record = Reference type with VALUE EQUALITY                   │
│                                                                 │
│  Normal class:                                                  │
│  var p1 = new Person("John", 30);                              │
│  var p2 = new Person("John", 30);                              │
│  p1 == p2  // FALSE - reference comparison                     │
│                                                                 │
│  Record:                                                        │
│  var p1 = new Person("John", 30);                              │
│  var p2 = new Person("John", 30);                              │
│  p1 == p2  // TRUE - value comparison                          │
│                                                                 │
│  Records provide:                                               │
│  • Value equality (Equals, ==, GetHashCode)                    │
│  • ToString() with property values                             │
│  • Deconstruction                                              │
│  • with expressions for copying                                │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Records Example

```csharp
using System;

// Positional record - concise syntax
public record Person(string FirstName, string LastName, int Age);

// Equivalent to (expanded form):
/*
public record Person
{
    public string FirstName { get; init; }
    public string LastName { get; init; }
    public int Age { get; init; }
    
    public Person(string firstName, string lastName, int age)
    {
        FirstName = firstName;
        LastName = lastName;
        Age = age;
    }
    
    // Auto-generated: Equals, GetHashCode, ToString, Deconstruct, ==, !=
}
*/

class Program
{
    static void Main()
    {
        // Create records
        var p1 = new Person("John", "Doe", 30);
        var p2 = new Person("John", "Doe", 30);
        var p3 = new Person("Jane", "Smith", 25);
        
        // ✅ Value equality
        Console.WriteLine(p1 == p2);  // True! (same values)
        Console.WriteLine(p1 == p3);  // False (different values)
        
        // ✅ Nice ToString()
        Console.WriteLine(p1);        // Person { FirstName = John, LastName = Doe, Age = 30 }
        
        // ✅ Deconstruction
        var (first, last, age) = p1;
        Console.WriteLine($"{first} {last} is {age}");
        
        // ✅ With expression - create copy with changes
        var p4 = p1 with { Age = 31 };  // New record, different age
        Console.WriteLine(p4);  // Person { FirstName = John, LastName = Doe, Age = 31 }
        Console.WriteLine(p1);  // Original unchanged
        
        // ✅ Using in HashSet/Dictionary (works correctly!)
        var people = new HashSet<Person> { p1, p2, p3 };
        Console.WriteLine(people.Count);  // 2 (p1 and p2 are equal)
    }
}
```

### Record vs Class vs Struct:

```
┌────────────────────────────────────────────────────────────────┐
│             Record vs Class vs Struct                           │
├──────────────┬──────────────┬──────────────────────────────────┤
│    Class     │    Struct    │           Record                 │
├──────────────┼──────────────┼──────────────────────────────────┤
│ Reference    │ Value type   │ Reference type                   │
│ Ref equality │ Value equal  │ Value equality                   │
│ Mutable      │ Should be    │ Immutable by default             │
│ Heap         │ Stack        │ Heap                             │
│ Nullable     │ Non-null     │ Nullable                         │
├──────────────┴──────────────┴──────────────────────────────────┤
│ Use class for     │ Complex behavior, OOP                      │
│ Use struct for    │ Small, simple values (Point, DateTime)    │
│ Use record for    │ Data objects, DTOs, immutable data        │
└───────────────────┴────────────────────────────────────────────┘
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Nullable reference types** - Compiler warns about null
2. **string?** - Explicitly nullable
3. **init** - Set only during initialization
4. **record** - Value equality for reference types
5. **with expression** - Create modified copy of record
6. **Records auto-generate** - Equals, GetHashCode, ToString

---

## 📝 Interview Questions

1. **What does nullable reference types feature do?**
   - Compiler tracks null flow and warns about potential NullReferenceException
   - Must explicitly mark nullable types with ?

2. **Difference between get;set; and get;init;?**
   - set: Can change anytime
   - init: Can only set during object creation

3. **When would you use a record?**
   - Data transfer objects (DTOs)
   - Immutable value objects
   - When you need value equality

---

## 🔗 Next Topic
Next: [37_CSharp10_New_Features.md](./37_CSharp10_New_Features.md) - C# 10 Features
