# Collections Overview in C#

## 📚 Introduction

In C#, collections are data structures used to store, manage, and manipulate groups of related objects. Unlike simple arrays, collections offer dynamic resizing, type safety, and optimized memory management.

---

## 🎯 Learning Objectives

After studying this note, you will understand:
- Limitations of arrays and why collections are needed
- Difference between generic and non-generic collections
- Overview of main collection types in .NET
- When to use each collection type

---

## 📖 Theory: Array Limitations

### Why Collections?

Arrays in C# have several limitations:

```
┌─────────────────────────────────────────────────────────────┐
│                    ARRAY LIMITATIONS                        │
├─────────────────────────────────────────────────────────────┤
│ 1. Fixed Size     - Cannot grow or shrink after creation   │
│ 2. No Type Safety - ArrayList allows any object type       │
│ 3. Boxing/Unboxing- Value types are boxed (performance hit)│
│ 4. Limited Methods- Basic operations only                  │
└─────────────────────────────────────────────────────────────┘
```

### Real-World Scenario

```
When you retrieve data from a database (e.g., all employees or customers),
you don't know the size beforehand. You need a "flexible train" that can
grow as per your data - this is where collections come in!
```

---

## 📊 Collection Types Comparison Table

| Collection | Storage | Access | Sorting | Duplicates | Null |
|------------|---------|--------|---------|------------|------|
| **List<T>** | Array | By Index | Not Sorted | Allowed | Allowed |
| **SortedList<K,V>** | Array | By Index/Key | Sorted by Key | Keys: No | Key: No |
| **Dictionary<K,V>** | Hash Table | By Key | Not Sorted | Keys: No | Key: No |
| **SortedDictionary<K,V>** | Binary Tree | By Key | Sorted by Key | Keys: No | Key: No |
| **HashSet<T>** | Hash Table | Not Indexed | Not Sorted | Not Allowed | Allowed |
| **SortedSet<T>** | Red-Black Tree | Not Indexed | Sorted | Not Allowed | Allowed |

---

## 🔍 Generic vs Non-Generic Collections

### Non-Generic (System.Collections)
```csharp
// OLD WAY - Avoid in modern code!
using System.Collections;

ArrayList list = new ArrayList();
list.Add(new Employee { Name = "Mona", Salary = 7000 });
list.Add(new Employee { Name = "Het", Salary = 3000 });
list.Add(new Animal());  // ⚠️ PROBLEM: No type safety!

foreach (Employee e in list)  // ❌ Runtime error on Animal!
    Console.WriteLine(e);
```

**Problems with Non-Generic:**
1. **No Type Safety** - Can add any object type
2. **Boxing/Unboxing** - Performance penalty for value types
3. **Runtime Errors** - Type mismatches discovered at runtime

### Generic (System.Collections.Generic)
```csharp
// MODERN WAY - Recommended!
using System.Collections.Generic;

List<Employee> list = new List<Employee>();
list.Add(new Employee { Name = "Mona", Salary = 7000 });
list.Add(new Employee { Name = "Het", Salary = 3000 });
// list.Add(new Animal());  // ✅ Compile-time error!

foreach (Employee e in list)  // ✅ Safe iteration
    Console.WriteLine(e);
```

**Benefits of Generic:**
1. **Type Safety** - Only specified type allowed
2. **No Boxing** - Better performance with value types
3. **Compile-Time Checks** - Errors caught before runtime

---

## 🎨 Visual: Collection Hierarchy

```
                    IEnumerable<T>
                          │
                    ICollection<T>
                    /           \
              IList<T>      IDictionary<K,V>
                 │                  │
           ┌─────┴─────┐      ┌────┴────┐
           │           │      │         │
        List<T>  SortedList  Dictionary  SortedDictionary
                 <K,V>        <K,V>      <K,V>
                 
                    ISet<T>
                    /     \
            HashSet<T>   SortedSet<T>
```

---

## 💻 Code Example: Employee Class (Used Throughout)

```csharp
using System;

// Employee class used in collection examples
class Employee
{
    public string Name { get; set; }      // Employee name
    public double Salary { get; set; }    // Employee salary
    
    // Default constructor
    public Employee() { }
    
    // Parameterized constructor
    public Employee(string nm, double sl)
    {
        Name = nm;
        Salary = sl;
    }
    
    // Override ToString for proper display
    public override string ToString()
    {
        return String.Format("{0} {1}", Name, Salary);
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `using System;` | Import System namespace for Console, String |
| 4 | `class Employee` | Define Employee class |
| 6-7 | `public string Name { get; set; }` | Auto-property for employee name |
| 8-9 | `public double Salary { get; set; }` | Auto-property for salary |
| 11 | `public Employee() { }` | Default constructor (required for object initializer) |
| 13-17 | Parameterized constructor | Sets Name and Salary via parameters |
| 19-22 | `override string ToString()` | Custom string representation for display |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Always use Generic collections** (`System.Collections.Generic`)
2. **List<T>** - When you need indexed access and order matters
3. **Dictionary<K,V>** - When you need fast key-based lookups
4. **HashSet<T>** - When you need unique values
5. **SortedList/SortedDictionary** - When you need automatic sorting by key

---

## ⚠️ Common Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|------------------|
| Using ArrayList | No type safety, boxing | Use `List<T>` |
| Using Hashtable | Non-generic, slow | Use `Dictionary<K,V>` |
| Ignoring capacity | Frequent resizing | Set initial capacity |

---

## 📝 Interview Questions

1. **What is the difference between Array and ArrayList?**
   - Array has fixed size, ArrayList is dynamic
   - Array is type-safe, ArrayList is not
   - ArrayList in System.Collections, Array is fundamental type

2. **Why prefer generic collections over non-generic?**
   - Type safety at compile time
   - No boxing/unboxing overhead
   - Better IntelliSense support

3. **When would you use Dictionary vs SortedDictionary?**
   - Dictionary: O(1) lookup, unordered
   - SortedDictionary: O(log n) lookup, sorted by key

4. **What namespace contains generic collections?**
   - `System.Collections.Generic`

---

## 🔗 Next Topic
Next: [02_List_Generic_Collection.md](./02_List_Generic_Collection.md) - Deep dive into List<T>
