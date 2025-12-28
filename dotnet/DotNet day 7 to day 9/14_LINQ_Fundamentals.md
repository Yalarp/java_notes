# LINQ Fundamentals in C#

## 📚 Introduction

LINQ (Language Integrated Query) provides a unified way to query data from various sources (collections, databases, XML) using C# syntax. It's built on extension methods and lambda expressions.

---

## 🎯 Learning Objectives

- Understand LINQ query syntax vs method syntax
- Master common LINQ operations: Select, Where, OrderBy
- Learn how LINQ works with collections

---

## 📖 Theory: Two Query Syntaxes

```
┌────────────────────────────────────────────────────────────────┐
│                    LINQ Syntax Options                          │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Query Syntax (SQL-like):                                       │
│  ─────────────────────────                                      │
│  var result = from e in employees                              │
│               where e.Salary > 50000                           │
│               select e;                                         │
│                                                                 │
│  Method Syntax (Lambda):                                        │
│  ───────────────────────                                        │
│  var result = employees                                         │
│               .Where(e => e.Salary > 50000)                    │
│               .Select(e => e);                                  │
│                                                                 │
│  Both produce identical results!                               │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 1: Basic LINQ Queries

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Salary { get; set; }
    public string Department { get; set; }
}

class Program
{
    static void Main()
    {
        List<Employee> employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj", Salary = 6000, Department = "IT" },
            new Employee { Id = 2, Name = "Mona", Salary = 7000, Department = "HR" },
            new Employee { Id = 3, Name = "Het", Salary = 3000, Department = "IT" },
            new Employee { Id = 4, Name = "Sam", Salary = 8000, Department = "IT" }
        };
        
        // Where: Filter employees in IT
        var itEmployees = employees.Where(e => e.Department == "IT");
        
        Console.WriteLine("IT Employees:");
        foreach (var emp in itEmployees)
            Console.WriteLine($"  {emp.Name} - {emp.Salary}");
        
        // Select: Project to new shape
        var names = employees.Select(e => e.Name);
        
        Console.WriteLine("\nAll Names:");
        foreach (var name in names)
            Console.WriteLine($"  {name}");
        
        // OrderBy: Sort by salary
        var sortedBySalary = employees.OrderBy(e => e.Salary);
        
        Console.WriteLine("\nSorted by Salary:");
        foreach (var emp in sortedBySalary)
            Console.WriteLine($"  {emp.Name} - {emp.Salary}");
    }
}
```

### Output:

```
IT Employees:
  Raj - 6000
  Het - 3000
  Sam - 8000

All Names:
  Raj
  Mona
  Het
  Sam

Sorted by Salary:
  Het - 3000
  Raj - 6000
  Mona - 7000
  Sam - 8000
```

---

## 📊 Common LINQ Methods

| Method | Description | Example |
|--------|-------------|---------|
| `Where` | Filter elements | `.Where(x => x > 5)` |
| `Select` | Transform/project | `.Select(x => x.Name)` |
| `OrderBy` | Sort ascending | `.OrderBy(x => x.Age)` |
| `OrderByDescending` | Sort descending | `.OrderByDescending(x => x.Age)` |
| `First` | First element | `.First()` |
| `FirstOrDefault` | First or null | `.FirstOrDefault(x => x.Id == 5)` |
| `Single` | Exactly one | `.Single(x => x.Id == 5)` |
| `Count` | Count elements | `.Count()` |
| `Sum` | Sum values | `.Sum(x => x.Price)` |
| `Average` | Average | `.Average(x => x.Score)` |
| `Max/Min` | Max/Min value | `.Max(x => x.Salary)` |
| `Take` | First n elements | `.Take(5)` |
| `Skip` | Skip n elements | `.Skip(10)` |
| `Distinct` | Unique elements | `.Distinct()` |
| `ToList` | Convert to List | `.ToList()` |
| `ToArray` | Convert to array | `.ToArray()` |

---

## 💻 Code Example 2: Chaining LINQ Methods

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        List<Employee> employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj", Salary = 6000, Department = "IT" },
            new Employee { Id = 2, Name = "Mona", Salary = 7000, Department = "HR" },
            new Employee { Id = 3, Name = "Het", Salary = 3000, Department = "IT" },
            new Employee { Id = 4, Name = "Sam", Salary = 8000, Department = "IT" }
        };
        
        // Chain multiple operations
        var result = employees
            .Where(e => e.Department == "IT")      // Filter: IT only
            .Where(e => e.Salary > 5000)           // Filter: High salary
            .OrderByDescending(e => e.Salary)      // Sort: Highest first
            .Select(e => new { e.Name, e.Salary }) // Project: Anonymous type
            .Take(2);                              // Limit: First 2
        
        Console.WriteLine("Top 2 High-Salary IT Employees:");
        foreach (var emp in result)
            Console.WriteLine($"  {emp.Name}: ${emp.Salary}");
        
        // Output:
        // Top 2 High-Salary IT Employees:
        //   Sam: $8000
        //   Raj: $6000
    }
}
```

### Execution Flow:

```
employees (4 items)
    ↓
.Where(Department == "IT")  → Raj, Het, Sam (3 items)
    ↓
.Where(Salary > 5000)       → Raj, Sam (2 items)
    ↓
.OrderByDescending(Salary)  → Sam, Raj (sorted)
    ↓
.Select(Name, Salary)       → {Sam, 8000}, {Raj, 6000}
    ↓
.Take(2)                    → {Sam, 8000}, {Raj, 6000}
```

---

## 💻 Code Example 3: Query Syntax

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        var employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj", Salary = 6000, Department = "IT" },
            new Employee { Id = 2, Name = "Mona", Salary = 7000, Department = "HR" }
        };
        
        // Query syntax (SQL-like)
        var query = from e in employees
                    where e.Department == "IT"
                    orderby e.Name
                    select new { e.Name, e.Salary };
        
        // Method syntax (equivalent)
        var method = employees
            .Where(e => e.Department == "IT")
            .OrderBy(e => e.Name)
            .Select(e => new { e.Name, e.Salary });
        
        // Both produce same result!
    }
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Deferred execution** - Query runs when iterated, not when defined
2. **Method syntax preferred** - More flexible, better for chaining
3. **Always use System.Linq** - Required namespace
4. **ToList() forces execution** - Materializes results immediately
5. **Anonymous types** - Create with `new { prop1, prop2 }`

---

## 📝 Interview Questions

1. **What is LINQ?**
   - Language Integrated Query for querying data in C#

2. **Query syntax vs Method syntax?**
   - Query: SQL-like, begins with "from"
   - Method: Lambda-based, uses extension methods

3. **What is deferred execution?**
   - Query is not executed until results are enumerated

---

## 🔗 Next Topic
Next: [15_LINQ_GroupBy_Operations.md](./15_LINQ_GroupBy_Operations.md) - LINQ GroupBy
