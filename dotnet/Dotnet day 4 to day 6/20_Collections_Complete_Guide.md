# Collections in C# - Complete Guide

## 📚 Introduction

C# provides a rich set of collection types in `System.Collections` and `System.Collections.Generic` namespaces for storing and manipulating groups of objects.

---

## 🎯 Learning Objectives

- Master List<T> operations
- Understand Dictionary<TKey, TValue>
- Learn SortedList and other collections
- Apply LINQ-style methods

---

## 🔍 Collection Types Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                      COLLECTION TYPES                             │
├──────────────────────┬───────────────────────────────────────────┤
│ Type                 │ Description                                │
├──────────────────────┼───────────────────────────────────────────┤
│ List<T>              │ Dynamic array, indexed access, fast add   │
│ Dictionary<K,V>      │ Key-value pairs, O(1) lookup              │
│ HashSet<T>           │ Unique elements, fast contains            │
│ Queue<T>             │ FIFO (First-In-First-Out)                 │
│ Stack<T>             │ LIFO (Last-In-First-Out)                  │
│ SortedList<K,V>      │ Sorted key-value pairs                    │
│ SortedDictionary<K,V>│ Binary tree, sorted by key                │
│ LinkedList<T>        │ Doubly-linked list                        │
└──────────────────────┴───────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: List<T> Basics

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // Creating a list
        List<string> names = new List<string>();
        
        // Adding elements
        names.Add("Alice");
        names.Add("Bob");
        names.Add("Charlie");
        
        // Adding multiple elements
        names.AddRange(new[] { "David", "Eve" });
        
        // Accessing by index
        Console.WriteLine($"First: {names[0]}");   // Alice
        Console.WriteLine($"Count: {names.Count}"); // 5
        
        // Inserting at position
        names.Insert(1, "Alex");  // After Alice
        
        // Removing elements
        names.Remove("Bob");         // Remove by value
        names.RemoveAt(0);           // Remove by index
        
        // Checking existence
        bool hasEve = names.Contains("Eve");  // True
        
        // Finding index
        int index = names.IndexOf("Charlie");
        
        // Iterating
        foreach (string name in names)
        {
            Console.WriteLine(name);
        }
        
        // Clearing
        names.Clear();
        Console.WriteLine($"After clear: {names.Count}");  // 0
    }
}
```

---

### Example 2: List<T> with Objects

```csharp
using System;
using System.Collections.Generic;

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Salary { get; set; }
    
    public override string ToString() => $"{Id}: {Name} (${Salary})";
}

class Program
{
    static void Main()
    {
        List<Employee> employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj", Salary = 6000 },
            new Employee { Id = 2, Name = "Mona", Salary = 7000 },
            new Employee { Id = 3, Name = "Het", Salary = 3000 }
        };
        
        // Find single element
        Employee found = employees.Find(e => e.Salary == 6000);
        Console.WriteLine($"Found: {found?.Name}");  // Raj
        
        // FindAll - returns List<T>
        List<Employee> highEarners = employees.FindAll(e => e.Salary >= 6000);
        Console.WriteLine($"High earners: {highEarners.Count}");  // 2
        
        // Exists - returns bool
        bool hasHighSalary = employees.Exists(e => e.Salary > 10000);
        Console.WriteLine($"Has > 10k: {hasHighSalary}");  // False
        
        // TrueForAll
        bool allPositive = employees.TrueForAll(e => e.Salary > 0);
        Console.WriteLine($"All positive: {allPositive}");  // True
        
        // ForEach
        employees.ForEach(e => Console.WriteLine(e));
        
        // Sort with custom comparison
        employees.Sort((a, b) => a.Salary.CompareTo(b.Salary));
        Console.WriteLine("\nSorted by salary:");
        employees.ForEach(e => Console.WriteLine(e));
    }
}
```

---

### Example 3: Dictionary<TKey, TValue>

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // Creating dictionary
        Dictionary<string, int> ages = new Dictionary<string, int>();
        
        // Adding entries
        ages.Add("Alice", 25);
        ages.Add("Bob", 30);
        ages["Charlie"] = 35;  // Alternative syntax
        
        // Accessing values
        Console.WriteLine($"Alice is {ages["Alice"]} years old");
        
        // Safe access with TryGetValue
        if (ages.TryGetValue("David", out int davidAge))
        {
            Console.WriteLine($"David is {davidAge}");
        }
        else
        {
            Console.WriteLine("David not found");
        }
        
        // Checking existence
        bool hasAlice = ages.ContainsKey("Alice");     // True
        bool has25 = ages.ContainsValue(25);           // True
        
        // Updating
        ages["Alice"] = 26;
        
        // Iterating
        foreach (KeyValuePair<string, int> pair in ages)
        {
            Console.WriteLine($"{pair.Key}: {pair.Value}");
        }
        
        // Keys and Values collections
        Console.WriteLine($"Keys: {string.Join(", ", ages.Keys)}");
        Console.WriteLine($"Values: {string.Join(", ", ages.Values)}");
        
        // Removing
        ages.Remove("Bob");
    }
}
```

---

### Example 4: SortedList<TKey, TValue>

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // SortedList automatically maintains key order
        SortedList<int, string> students = new SortedList<int, string>();
        
        // Add elements (keys are sorted automatically)
        students.Add(3, "Charlie");
        students.Add(1, "Alice");
        students.Add(2, "Bob");
        
        // Elements are stored in key order
        Console.WriteLine("Students (sorted by ID):");
        foreach (var pair in students)
        {
            Console.WriteLine($"  {pair.Key}: {pair.Value}");
        }
        // Output:
        //   1: Alice
        //   2: Bob
        //   3: Charlie
        
        // Access by key
        Console.WriteLine($"Student 2: {students[2]}");  // Bob
        
        // Access by index
        Console.WriteLine($"First key: {students.Keys[0]}");      // 1
        Console.WriteLine($"First value: {students.Values[0]}");  // Alice
        
        // ContainsKey
        if (students.ContainsKey(2))
        {
            Console.WriteLine("Student 2 exists");
        }
        
        // IndexOfKey
        int index = students.IndexOfKey(2);  // 1 (second position)
    }
}
```

---

### Example 5: Stack<T> and Queue<T>

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        // Stack: LIFO (Last-In-First-Out)
        Stack<string> plates = new Stack<string>();
        plates.Push("Red");
        plates.Push("Green");
        plates.Push("Blue");
        
        Console.WriteLine($"Top plate: {plates.Peek()}");   // Blue
        Console.WriteLine($"Pop: {plates.Pop()}");          // Blue
        Console.WriteLine($"New top: {plates.Peek()}");     // Green
        
        // Queue: FIFO (First-In-First-Out)
        Queue<string> customers = new Queue<string>();
        customers.Enqueue("Alice");
        customers.Enqueue("Bob");
        customers.Enqueue("Charlie");
        
        Console.WriteLine($"First: {customers.Peek()}");      // Alice
        Console.WriteLine($"Dequeue: {customers.Dequeue()}"); // Alice
        Console.WriteLine($"New first: {customers.Peek()}");  // Bob
    }
}
```

---

### Example 6: HashSet<T>

```csharp
using System;
using System.Collections.Generic;

class Program
{
    static void Main()
    {
        HashSet<int> set1 = new HashSet<int> { 1, 2, 3, 4, 5 };
        HashSet<int> set2 = new HashSet<int> { 4, 5, 6, 7, 8 };
        
        // No duplicates allowed
        set1.Add(1);  // No effect - already exists
        Console.WriteLine($"Count: {set1.Count}");  // 5
        
        // Fast Contains
        bool hasFive = set1.Contains(5);  // O(1) operation
        
        // Set operations
        // Union
        HashSet<int> union = new HashSet<int>(set1);
        union.UnionWith(set2);  // 1,2,3,4,5,6,7,8
        
        // Intersection
        HashSet<int> intersection = new HashSet<int>(set1);
        intersection.IntersectWith(set2);  // 4,5
        
        // Difference
        HashSet<int> difference = new HashSet<int>(set1);
        difference.ExceptWith(set2);  // 1,2,3
        
        Console.WriteLine($"Union: {string.Join(",", union)}");
        Console.WriteLine($"Intersection: {string.Join(",", intersection)}");
        Console.WriteLine($"Difference: {string.Join(",", difference)}");
    }
}
```

---

## 📊 Collection Performance Comparison

| Operation | List<T> | Dictionary<K,V> | HashSet<T> | SortedList<K,V> |
|-----------|---------|-----------------|------------|-----------------|
| Access by index | O(1) | N/A | N/A | O(1) |
| Access by key | O(n) | O(1) | N/A | O(log n) |
| Add | O(1)* | O(1) | O(1) | O(n) |
| Remove | O(n) | O(1) | O(1) | O(n) |
| Contains | O(n) | O(1) | O(1) | O(log n) |

*Amortized - occasional O(n) for resizing

---

## ⚡ Key Points to Remember

| Collection | Use When |
|------------|----------|
| List<T> | Need indexed access, ordered collection |
| Dictionary | Need fast key-based lookup |
| HashSet | Need unique elements, set operations |
| Stack | Need LIFO behavior |
| Queue | Need FIFO behavior |
| SortedList | Need sorted key-value pairs |

---

## ❌ Common Mistakes

### Mistake 1: Modifying collection during iteration
```csharp
foreach (var item in list)
{
    list.Remove(item);  // InvalidOperationException!
}
// Use for loop with index or ToList() first
```

### Mistake 2: Accessing Dictionary with non-existent key
```csharp
int age = ages["NotExist"];  // KeyNotFoundException!
// Use TryGetValue instead
```

---

## 📝 Practice Questions

1. **What's the difference between List.Find and List.FindAll?**
<details>
<summary>Answer</summary>
`Find` returns first matching element (or default), `FindAll` returns List of all matching elements.
</details>

2. **Why use HashSet over List for checking membership?**
<details>
<summary>Answer</summary>
HashSet.Contains is O(1), List.Contains is O(n).
</details>

---

## 🔗 Related Topics
- [06_Boxing_Unboxing.md](06_Boxing_Unboxing.md) - Generic vs non-generic
- [19_Generic_NonGeneric_Delegates.md](19_Generic_NonGeneric_Delegates.md) - Predicates for Find
