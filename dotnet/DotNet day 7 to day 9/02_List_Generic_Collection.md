# List<T> Generic Collection in C#

## 📚 Introduction

`List<T>` is the most commonly used collection in C#. It provides a strongly-typed, dynamically-sized array with automatic resizing and rich set of methods for manipulation.

---

## 🎯 Learning Objectives

- Understand List<T> internal structure and capacity growth
- Master Add, Remove, Find, FindAll operations
- Learn Predicate<T> and lambda expressions with List
- Understand memory management in List<T>

---

## 📖 Theory: How List<T> Works

### Internal Structure

```
┌────────────────────────────────────────────────────────────────┐
│                    List<T> Internal Array                       │
├────────────────────────────────────────────────────────────────┤
│  When you create: List<char> lst = new List<char>();          │
│                                                                 │
│  Initial State:  Count = 0, Capacity = 0                       │
│  After 1 add:    Count = 1, Capacity = 4  (grows to 4)         │
│  After 5 adds:   Count = 5, Capacity = 8  (doubles when full)  │
│  After 9 adds:   Count = 9, Capacity = 16 (doubles again)      │
│                                                                 │
│  Note: Capacity grows in multiples (typically doubles)         │
└────────────────────────────────────────────────────────────────┘
```

### Capacity vs Count

| Property | Description |
|----------|-------------|
| **Count** | Number of elements actually in the list |
| **Capacity** | Total space allocated (always >= Count) |

---

## 💻 Code Example 1: Basic List Operations

```csharp
using System;
using System.Collections.Generic;

class GenListDemo
{
    static void Main()
    {
        // Create a list of characters
        List<char> lst = new List<char>();

        // Check initial count and capacity
        Console.WriteLine("count={0} capacity={1}", lst.Count, lst.Capacity);
        // Output: count=0 capacity=0
        
        Console.WriteLine("Adding 6 elements");
        
        // Add elements to the list
        lst.Add('C');
        lst.Add('A');
        lst.Add('E');
        lst.Add('B');
        lst.Add('D');
        lst.Add('F');

        // Check count and capacity after adding
        Console.WriteLine("count={0} capacity={1}", lst.Count, lst.Capacity);
        // Output: count=6 capacity=8

        // Display using array indexing
        Console.Write("Current contents: ");
        for (int i = 0; i < lst.Count; i++)
            Console.Write(lst[i] + " ");
        Console.WriteLine("\n");
        // Output: C A E B D F (maintains insertion order)
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `using System;` | Import System namespace |
| 2 | `using System.Collections.Generic;` | Import generic collections |
| 8 | `List<char> lst = new List<char>();` | Create empty list for char type |
| 11 | `lst.Count, lst.Capacity` | Count=0 (empty), Capacity=0 (no memory allocated) |
| 15-20 | `lst.Add('C');` etc. | Add 6 characters to list |
| 23 | After adding | Count=6, Capacity=8 (grew from 0→4→8) |
| 27-28 | `lst[i]` | Access by index like array |

### Execution Flow:

```
Step 1: List created → Count=0, Capacity=0
Step 2: Add('C') → Count=1, Capacity=4 (allocated space for 4)
Step 3: Add('A'), Add('E'), Add('B') → Count=4, Capacity=4
Step 4: Add('D') → Count=5, Capacity=8 (doubled!)
Step 5: Add('F') → Count=6, Capacity=8
```

---

## 💻 Code Example 2: Remove and Modify

```csharp
using System;
using System.Collections.Generic;

class ListModifyDemo
{
    static void Main()
    {
        List<char> lst = new List<char> { 'C', 'A', 'E', 'B', 'D', 'F' };
        
        // Remove elements from the list
        lst.Remove('F');  // Remove 'F'
        lst.Remove('A');  // Remove 'A'
        
        foreach (char c in lst)
            Console.Write(c + " ");
        // Output: C E B D
        
        // Change contents using array indexing
        Console.WriteLine("Change first three elements");
        lst[0] = 'X';
        lst[1] = 'Y';
        lst[2] = 'Z';
        
        foreach (char c in lst)
            Console.Write(c + " ");
        // Output: X Y Z D
        
        // This will cause compile-time error!
        // lst.Add(99);  // Error! 99 is int, not char!
    }
}
```

### Key Points:

| Operation | Behavior |
|-----------|----------|
| `Remove()` | Removes element, does NOT shrink capacity |
| `lst[index] = value` | Modifies value at index |
| `lst.Add(wrongType)` | Compile-time error (type safety) |

---

## 💻 Code Example 3: List with Custom Objects

```csharp
using System;
using System.Collections.Generic;

class Employee
{
    public string Name { get; set; }
    public double Salary { get; set; }
    
    public Employee() { }
    
    public Employee(string nm, double sl)
    {
        Name = nm;
        Salary = sl;
    }
    
    public override string ToString()
    {
        return String.Format("{0} {1}", Name, Salary);
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Create list with object initializer syntax
        List<Employee> listemp = new List<Employee>
        {
            new Employee { Name = "Raj", Salary = 6000 },
            new Employee { Name = "Mona", Salary = 7000 },
            new Employee { Name = "Het", Salary = 3000 }
        };

        // Display all employees
        foreach (Employee e in listemp)
            Console.WriteLine(e);
        
        // Find single employee by salary
        Employee obj = listemp.Find((arr) => arr.Salary == 6000);
        Console.WriteLine("Found: " + obj);
        // Output: Raj 6000
        
        // Find all employees with salary >= 6000
        var result = listemp.FindAll((arr) => arr.Salary >= 6000);
        Console.WriteLine("Employees with salary >= 6000:");
        foreach (Employee e in result)
            Console.WriteLine(e);
        // Output: Raj 6000, Mona 7000
    }
}
```

### Memory Diagram:

```
listemp (List<Employee>)
┌─────────────────────────────────────────────────────────────┐
│ Internal Array: Employee[]                                   │
├─────────┬─────────┬─────────┬─────────┬─────────┬─────────┤
│  [0]    │  [1]    │  [2]    │  [3]    │  [4]    │  ...    │
│   ↓     │   ↓     │   ↓     │  null   │  null   │         │
├─────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│Employee │Employee │Employee │         │         │         │
│Name=Raj │Name=Mona│Name=Het │         │         │         │
│Sal=6000 │Sal=7000 │Sal=3000 │         │         │         │
└─────────┴─────────┴─────────┴─────────┴─────────┴─────────┘
     Count = 3            Capacity = 4 (or more)
```

---

## 📖 Understanding Find() and Predicate<T>

### What is Predicate<T>?

```csharp
// Predicate<T> is a delegate that takes T and returns bool
public delegate bool Predicate<in T>(T obj);
```

### How Find() Works Internally:

```csharp
// Simplified internal implementation of Find()
public T? Find(Predicate<T> match)
{
    if (match == null)
        throw new ArgumentNullException("match");

    for (int i = 0; i < _size; i++)
    {
        if (match(_items[i]))  // Call the predicate
        {
            return _items[i];  // Return first match
        }
    }
    return default;  // Return null/default if not found
}
```

### How Our Lambda Expression Works:

```csharp
Employee obj = listemp.Find((arr) => arr.Salary == 6000);

// This is equivalent to:
Employee obj = listemp.Find(delegate(Employee arr) 
{
    return arr.Salary == 6000;
});
```

### Execution Flow of Find():

```
┌────────────────────────────────────────────────────────────┐
│ listemp.Find((arr) => arr.Salary == 6000)                  │
├────────────────────────────────────────────────────────────┤
│ i=0: arr = {Raj, 6000}                                     │
│      Check: 6000 == 6000? TRUE ✓                           │
│      Return: {Raj, 6000}                                   │
└────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 4: Custom Find Implementation

```csharp
using System;

namespace ConsoleApp2find
{
    public class Employee
    {
        public int Salary { get; set; }
        public string Name { get; set; }
    }
    
    internal class Mylist
    {
        Employee[] _items = new Employee[2];
        
        public Mylist()
        {
            _items[0] = new Employee { Salary = 6000, Name = "Raj" };
            _items[1] = new Employee { Salary = 3000, Name = "Mona" };
        }
        
        // Custom Find method using Predicate
        public Employee MyFind(Predicate<Employee> match)
        {
            int size = _items.Length;
            for (int i = 0; i < size; i++)
            {
                if (match(_items[i]))  // Call predicate on each item
                    return _items[i];
            }
            return null;
        }
    }
    
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
            Mylist mylist = new Mylist();
            
            // Use lambda expression as predicate
            Employee e1 = mylist.MyFind((arr) => arr.Salary == 6000);
            Console.WriteLine(e1.Name);  // Output: Raj
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 22 | `Predicate<Employee> match` | Parameter is a function that takes Employee, returns bool |
| 26-28 | `if (match(_items[i]))` | Call the passed function with current item |
| 41 | `(arr) => arr.Salary == 6000` | Lambda: takes arr, returns true if Salary == 6000 |

---

## 📋 List<T> Important Methods Summary

| Method | Description | Returns |
|--------|-------------|---------|
| `Add(T)` | Add item to end | void |
| `AddRange(IEnumerable<T>)` | Add multiple items | void |
| `Insert(index, T)` | Insert at position | void |
| `Remove(T)` | Remove first occurrence | bool |
| `RemoveAt(index)` | Remove at index | void |
| `Find(Predicate<T>)` | Find first match | T or null |
| `FindAll(Predicate<T>)` | Find all matches | List<T> |
| `Contains(T)` | Check if exists | bool |
| `IndexOf(T)` | Get index of item | int (-1 if not found) |
| `Sort()` | Sort in place | void |
| `Clear()` | Remove all items | void |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Capacity grows automatically** - typically doubles when full
2. **Remove does NOT shrink** capacity - use `TrimExcess()` if needed
3. **Type-safe** - compile-time error for wrong types
4. **Index-based access** - O(1) for reading by index
5. **Find uses Predicate<T>** - pass lambda or delegate
6. **Maintains insertion order** - unlike HashSet or Dictionary

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Not checking null from Find() | NullReferenceException | Always null-check result |
| Modifying list during foreach | InvalidOperationException | Use for loop or ToList() |
| Ignoring initial capacity | Frequent resizing | Set capacity in constructor |

---

## 📝 Interview Questions

1. **What is the default capacity of List<T>?**
   - 0 initially, grows to 4 on first add, then doubles

2. **Difference between Find() and FindAll()?**
   - Find returns first match (single item or null)
   - FindAll returns all matches (List<T>, can be empty)

3. **How does List<T> grow internally?**
   - When capacity is exceeded, a new larger array is created
   - Elements are copied to new array
   - Old array is garbage collected

4. **What is Predicate<T>?**
   - A delegate that takes T and returns bool
   - Used in Find, FindAll, RemoveAll, Exists methods

---

## 🔗 Next Topic
Next: [03_SortedList_Collection.md](./03_SortedList_Collection.md) - SortedList<TKey, TValue>
