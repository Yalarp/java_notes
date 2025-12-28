# SortedList<TKey, TValue> Collection in C#

## 📚 Introduction

`SortedList<TKey, TValue>` is a collection of key-value pairs that are automatically sorted by the key. It uses an array-based implementation and provides both indexed and key-based access.

---

## 🎯 Learning Objectives

- Understand SortedList internal structure (array-based)
- Learn key-value pair operations
- Understand automatic sorting by key
- Compare SortedList with Dictionary and SortedDictionary

---

## 📖 Theory: How SortedList Works

### Internal Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                 SortedList Internal Structure                    │
├─────────────────────────────────────────────────────────────────┤
│  Two parallel arrays:                                           │
│                                                                  │
│  Keys Array:   [Butler] [Frank] [Piku] [Sanoj] [ ] [ ] [ ]     │
│  Values Array: [73000]  [99000] [45000] [59000] [ ] [ ] [ ]    │
│                                                                  │
│  ✓ Keys are ALWAYS sorted alphabetically                        │
│  ✓ Values are aligned with their corresponding keys             │
│  ✓ Can access by index (0,1,2...) OR by key ("Butler")         │
└─────────────────────────────────────────────────────────────────┘
```

### SortedList Properties

| Property | Description |
|----------|-------------|
| **Sorted by Key** | Automatically maintains sort order |
| **Array-Based** | Fast indexed access O(1) |
| **No Duplicate Keys** | Throws exception on duplicate key |
| **Key Cannot Be Null** | Keys must have value |
| **Value Can Be Null** | Values can be null (if reference type) |

---

## 💻 Code Example 1: Basic SortedList Operations

```csharp
using System;
using System.Collections.Generic;

class GenSLDemo
{
    static void Main()
    {
        // Create a SortedList for employee names (key) and salaries (value)
        SortedList<string, double> sl = new SortedList<string, double>();

        // Add elements to the collection
        sl.Add("Butler", 73000);   // Added first
        sl.Add("Sanoj", 59000);    // Added second
        sl.Add("Piku", 45000);     // Added third
        sl.Add("Frank", 99000);    // Added fourth

        // Get a collection of the keys
        ICollection<string> c = sl.Keys;
        
        // Access by index (sorted order)
        Console.WriteLine(sl.Keys[0]);    // Output: Butler (first alphabetically)
        
        // Access by key
        Console.WriteLine(sl["Butler"]);   // Output: 73000

        // Iterate using keys
        foreach (string str in c)
            Console.WriteLine("{0}, Salary: {1:C}", str, sl[str]);
        
        // Output (sorted by key):
        // Butler, Salary: $73,000.00
        // Frank, Salary: $99,000.00
        // Piku, Salary: $45,000.00
        // Sanoj, Salary: $59,000.00
        
        // Iterate using KeyValuePair
        foreach (KeyValuePair<string, double> x in sl)
            Console.WriteLine(x);
        // Output: [Butler, 73000], [Frank, 99000], etc.
    }
}
```

### Memory Diagram:

```
sl (SortedList<string, double>)
┌───────────────────────────────────────────────────────────────┐
│                    After Adding All Elements                   │
├───────────────────────────────────────────────────────────────┤
│  Keys Array (sorted):                                          │
│  ┌────────┬────────┬────────┬────────┬────────┬────────┐     │
│  │   0    │   1    │   2    │   3    │   4    │   5    │     │
│  │ Butler │ Frank  │  Piku  │ Sanoj  │  null  │  null  │     │
│  └────────┴────────┴────────┴────────┴────────┴────────┘     │
│                                                                │
│  Values Array (parallel):                                      │
│  ┌────────┬────────┬────────┬────────┬────────┬────────┐     │
│  │   0    │   1    │   2    │   3    │   4    │   5    │     │
│  │ 73000  │ 99000  │ 45000  │ 59000  │   -    │   -    │     │
│  └────────┴────────┴────────┴────────┴────────┴────────┘     │
├───────────────────────────────────────────────────────────────┤
│  sl.Keys[0] → "Butler"    sl["Butler"] → 73000                │
│  sl.Keys[1] → "Frank"     sl["Frank"]  → 99000                │
└───────────────────────────────────────────────────────────────┘
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `SortedList<string, double> sl` | Create SortedList with string keys, double values |
| 11-14 | `sl.Add(key, value)` | Add key-value pairs (sorted automatically) |
| 17 | `ICollection<string> c = sl.Keys` | Get all keys as collection |
| 20 | `sl.Keys[0]` | Access first key by index (0-based) |
| 23 | `sl["Butler"]` | Access value by key |
| 26-27 | `foreach (string str in c)` | Iterate through sorted keys |
| 35-36 | `KeyValuePair<string, double>` | Iterate as key-value pairs |

---

## 💻 Code Example 2: Handling Duplicate Keys

```csharp
using System;
using System.Collections.Generic;

class SortedListDuplicateDemo
{
    static void Main(string[] args)
    {
        SortedList<string, string> openWith = new SortedList<string, string>();

        // Add some elements
        openWith.Add("txt", "notepad.exe");
        openWith.Add("bmp", "paint.exe");
        openWith.Add("dib", "paint.exe");   // Duplicate VALUE is OK
        openWith.Add("rtf", "wordpad.exe");

        // Try to add duplicate KEY - throws exception!
        try
        {
            openWith.Add("txt", "winword.exe");  // ❌ Key "txt" already exists
        }
        catch (ArgumentException)
        {
            Console.WriteLine("An element with Key = \"txt\" already exists.");
        }
        
        // After sorting (by key):
        // bmp → paint.exe
        // dib → paint.exe
        // rtf → wordpad.exe
        // txt → notepad.exe
    }
}
```

### Key Behavior:

| Scenario | Result |
|----------|--------|
| Add duplicate key | `ArgumentException` thrown |
| Add duplicate value | ✅ Allowed |
| Add null key | `ArgumentNullException` thrown |
| Add null value | ✅ Allowed (for reference types) |

---

## 💻 Code Example 3: Modify and Remove Operations

```csharp
using System;
using System.Collections.Generic;

class SortedListModifyDemo
{
    static void Main(string[] args)
    {
        SortedList<string, string> openWith = new SortedList<string, string>();
        
        openWith.Add("txt", "notepad.exe");
        openWith.Add("bmp", "paint.exe");
        openWith.Add("rtf", "wordpad.exe");

        // Access value using indexer (key as index)
        Console.WriteLine("For key = \"rtf\", value = {0}.", openWith["rtf"]);
        // Output: wordpad.exe

        // Modify value using indexer
        openWith["rtf"] = "winword.exe";
        Console.WriteLine("For key = \"rtf\", value = {0}.", openWith["rtf"]);
        // Output: winword.exe

        // Remove by key
        Console.WriteLine("\nRemove(\"doc\")");
        openWith.Remove("doc");

        // Check if key exists
        if (!openWith.ContainsKey("doc"))
        {
            Console.WriteLine("Key \"doc\" is not found.");
        }
    }
}
```

---

## 💻 Code Example 4: TryGetValue for Safe Access

```csharp
using System;
using System.Collections.Generic;

class SortedListTryGetDemo
{
    static void Main(string[] args)
    {
        SortedList<string, string> openWith = new SortedList<string, string>();
        
        openWith.Add("txt", "notepad.exe");
        openWith.Add("bmp", "paint.exe");
        openWith.Add("dib", "paint.exe");
        openWith.Add("rtf", "wordpad.exe");

        // Direct access to non-existent key throws exception!
        try
        {
            Console.WriteLine("For key = \"tif\", value = {0}.", openWith["tif"]);
        }
        catch (KeyNotFoundException)
        {
            Console.WriteLine("Key = \"tif\" is not found.");
        }
        
        // Better way: TryGetValue (no exception)
        string value = "";
        if (openWith.TryGetValue("tif", out value))
        {
            Console.WriteLine("For key = \"tif\", value = {0}.", value);
        }
        else
        {
            Console.WriteLine("Key = \"tif\" is not found.");
        }
    }
}
```

### Comparison: Direct Access vs TryGetValue

| Method | Key Not Found | Performance |
|--------|---------------|-------------|
| `sl["key"]` | Throws `KeyNotFoundException` | Faster if key exists |
| `TryGetValue()` | Returns false, no exception | Safer, no exception overhead |

---

## 💻 Code Example 5: Iterating Keys and Values

```csharp
using System;
using System.Collections.Generic;

class SortedListIterateDemo
{
    static void Main(string[] args)
    {
        SortedList<string, string> openWith = new SortedList<string, string>();
        
        openWith.Add("txt", "notepad.exe");
        openWith.Add("bmp", "paint.exe");
        openWith.Add("dib", "paint.exe");
        openWith.Add("rtf", "wordpad.exe");

        // Check before adding
        if (!openWith.ContainsKey("ht"))
        {
            openWith.Add("ht", "hypertrm.exe");
            Console.WriteLine("Value added for key = \"ht\": {0}", openWith["ht"]);
        }
        
        // Iterate as KeyValuePair
        Console.WriteLine("\nAll Key-Value Pairs:");
        foreach (KeyValuePair<string, string> kvp in openWith)
        {
            Console.WriteLine("Key = {0}, Value = {1}", kvp.Key, kvp.Value);
        }
        
        // Get only values
        IList<string> ilistValues = openWith.Values;
        
        Console.WriteLine("\nAll Values:");
        foreach (string s in ilistValues)
        {
            Console.WriteLine("Value = {0}", s);
        }
        
        // Access value by index
        Console.WriteLine("\nIndexed retrieval: Values[2] = {0}", openWith.Values[2]);
    }
}
```

---

## 💻 Code Example 6: SortedList with Custom Objects

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
        Employee e1 = new Employee { Name = "Raj", Salary = 6000 };
        Employee e2 = new Employee { Name = "Mona", Salary = 7000 };
        Employee e3 = new Employee { Name = "Het", Salary = 3000 };
        
        // Key is employee name, Value is Employee object
        SortedList<string, Employee> listemp = new SortedList<string, Employee>();

        listemp.Add(e1.Name, e1);  // Key: "Raj"
        listemp.Add(e2.Name, e2);  // Key: "Mona"
        listemp.Add(e3.Name, e3);  // Key: "Het"
        
        // Output is sorted by KEY (name)
        foreach (KeyValuePair<string, Employee> x in listemp)
            Console.WriteLine(x);
        
        // Output (sorted alphabetically by key):
        // [Het, Het 3000]
        // [Mona, Mona 7000]
        // [Raj, Raj 6000]
    }
}
```

### Memory Visualization:

```
listemp (SortedList<string, Employee>)
┌─────────────────────────────────────────────────────────────┐
│  Keys (sorted):    [Het]  [Mona]  [Raj]                     │
│  Values:           [→]    [→]     [→]                       │
│                     │      │       │                        │
│                     ▼      ▼       ▼                        │
│                  Employee Employee Employee                  │
│                  Het,3000 Mona,7000 Raj,6000                │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 SortedList vs Dictionary vs SortedDictionary

| Feature | SortedList | Dictionary | SortedDictionary |
|---------|------------|------------|------------------|
| **Internal Structure** | Array | Hash Table | Binary Search Tree |
| **Sorted** | ✅ Yes | ❌ No | ✅ Yes |
| **Add/Remove** | O(n) | O(1) | O(log n) |
| **Lookup by Key** | O(log n) | O(1) | O(log n) |
| **Indexed Access** | ✅ Yes | ❌ No | ❌ No |
| **Memory** | Less | More | More |

### When to Use SortedList:

1. Need sorted data with indexed access
2. Few modifications after initial build
3. Memory is a concern
4. Small to medium collections

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Always sorted by key** - no manual sorting needed
2. **Duplicate keys not allowed** - throws ArgumentException
3. **Two access methods** - by index (sl.Keys[0]) or by key (sl["key"])
4. **KeyValuePair** - use for iteration
5. **TryGetValue** - safer than direct indexer access
6. **O(n) for Add** - due to maintaining sorted array

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Adding duplicate key | ArgumentException | Check ContainsKey first |
| Direct access to missing key | KeyNotFoundException | Use TryGetValue |
| Expecting index = insertion order | Wrong assumption | Index = sorted position |

---

## 📝 Interview Questions

1. **How is SortedList different from Dictionary?**
   - SortedList is sorted, Dictionary is not
   - SortedList allows indexed access, Dictionary doesn't
   - SortedList uses arrays, Dictionary uses hash table

2. **What happens when you add to SortedList?**
   - Finds correct sorted position (binary search)
   - Shifts elements to make room
   - O(n) operation due to shifting

3. **Can SortedList have null keys?**
   - No, keys cannot be null (throws ArgumentNullException)
   - Values can be null for reference types

4. **How to safely check if key exists?**
   - Use `ContainsKey()` or `TryGetValue()`

---

## 🔗 Next Topic
Next: [04_Dictionary_Collection.md](./04_Dictionary_Collection.md) - Dictionary<TKey, TValue>
