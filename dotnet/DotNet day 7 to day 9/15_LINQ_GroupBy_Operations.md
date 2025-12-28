# LINQ GroupBy Operations in C#

## 📚 Introduction

GroupBy is one of the most powerful LINQ operations, allowing you to group elements by a key and perform aggregate operations on each group.

---

## 🎯 Learning Objectives

- Master GroupBy with single and multiple keys
- Perform aggregations on groups
- Create complex projections from grouped data

---

## 💻 Code Example 1: Basic GroupBy

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
        var employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj", Salary = 6000, Department = "IT" },
            new Employee { Id = 2, Name = "Mona", Salary = 7000, Department = "HR" },
            new Employee { Id = 3, Name = "Het", Salary = 3000, Department = "IT" },
            new Employee { Id = 4, Name = "Sam", Salary = 8000, Department = "IT" },
            new Employee { Id = 5, Name = "Priya", Salary = 5000, Department = "HR" }
        };
        
        // Group by Department
        var grouped = employees.GroupBy(e => e.Department);
        
        foreach (var group in grouped)
        {
            Console.WriteLine($"Department: {group.Key}");
            foreach (var emp in group)
            {
                Console.WriteLine($"  - {emp.Name}: ${emp.Salary}");
            }
        }
    }
}
```

### Output:

```
Department: IT
  - Raj: $6000
  - Het: $3000
  - Sam: $8000
Department: HR
  - Mona: $7000
  - Priya: $5000
```

### How GroupBy Works:

```
┌────────────────────────────────────────────────────────────────┐
│                    GroupBy Visualization                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Input: [Raj-IT, Mona-HR, Het-IT, Sam-IT, Priya-HR]           │
│                                                                 │
│  GroupBy(e => e.Department)                                    │
│         ↓                                                       │
│  ┌─────────────────────────────────────────┐                   │
│  │  Key: "IT"                              │                   │
│  │  Items: [Raj, Het, Sam]                 │                   │
│  └─────────────────────────────────────────┘                   │
│  ┌─────────────────────────────────────────┐                   │
│  │  Key: "HR"                              │                   │
│  │  Items: [Mona, Priya]                   │                   │
│  └─────────────────────────────────────────┘                   │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 2: GroupBy with Aggregations

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
            new Employee { Id = 2, Name = "Mona", Salary = 7000, Department = "HR" },
            new Employee { Id = 3, Name = "Het", Salary = 3000, Department = "IT" },
            new Employee { Id = 4, Name = "Sam", Salary = 8000, Department = "IT" },
            new Employee { Id = 5, Name = "Priya", Salary = 5000, Department = "HR" }
        };
        
        // Group with aggregations
        var summary = employees
            .GroupBy(e => e.Department)
            .Select(g => new
            {
                Department = g.Key,
                Count = g.Count(),
                TotalSalary = g.Sum(e => e.Salary),
                AverageSalary = g.Average(e => e.Salary),
                MaxSalary = g.Max(e => e.Salary),
                MinSalary = g.Min(e => e.Salary)
            });
        
        Console.WriteLine("Department Summary:");
        foreach (var dept in summary)
        {
            Console.WriteLine($"{dept.Department}:");
            Console.WriteLine($"  Count: {dept.Count}");
            Console.WriteLine($"  Total: ${dept.TotalSalary}");
            Console.WriteLine($"  Average: ${dept.AverageSalary:F2}");
            Console.WriteLine($"  Max: ${dept.MaxSalary}, Min: ${dept.MinSalary}");
        }
    }
}
```

### Output:

```
Department Summary:
IT:
  Count: 3
  Total: $17000
  Average: $5666.67
  Max: $8000, Min: $3000
HR:
  Count: 2
  Total: $12000
  Average: $6000.00
  Max: $7000, Min: $5000
```

---

## 📊 GroupBy Return Type

```
IEnumerable<IGrouping<TKey, TElement>>
                ↓
    Each group has:
    - Key: The grouping key
    - Items: IEnumerable<TElement>
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **g.Key** - Access the grouping key
2. **g.Count(), g.Sum()** - Aggregate functions on group
3. **Returns IGrouping** - Each group is enumerable
4. **Deferred execution** - Like other LINQ

---

## 🔗 Next Topic
Next: [16_Collection_CRUD_Pattern.md](./16_Collection_CRUD_Pattern.md) - Collection CRUD Pattern
