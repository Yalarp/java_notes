# Dictionary<TKey, TValue> Collection in C#

## 📚 Introduction

`Dictionary<TKey, TValue>` is a high-performance collection for storing key-value pairs. It uses a hash table internally, providing O(1) average time complexity for lookups, insertions, and deletions.

---

## 🎯 Learning Objectives

- Understand Dictionary's hash table implementation
- Master Add, Remove, ContainsKey, TryGetValue operations
- Learn iteration patterns with KeyValuePair
- Compare Dictionary with SortedDictionary

---

## 📖 Theory: How Dictionary Works

### Hash Table Internals

```
┌────────────────────────────────────────────────────────────────┐
│                    Dictionary Hash Table                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Key "Butler" → GetHashCode() → 12345 → 12345 % 7 = 3          │
│                                                                 │
│  Bucket Array:                                                  │
│  ┌───┬───┬───┬───────────┬───┬───┬───┐                        │
│  │ 0 │ 1 │ 2 │     3     │ 4 │ 5 │ 6 │                        │
│  │   │   │   │Butler,7300│   │   │   │                        │
│  └───┴───┴───┴───────────┴───┴───┴───┘                        │
│                                                                 │
│  Lookup: O(1) average case                                      │
│  Collision: Chaining (linked list at same bucket)              │
└────────────────────────────────────────────────────────────────┘
```

### Dictionary Properties

| Property | Description |
|----------|-------------|
| **Hash Table Based** | O(1) average lookup/insert/delete |
| **Unordered** | No guaranteed order of elements |
| **No Duplicate Keys** | Throws exception on duplicate key |
| **Key Cannot Be Null** | ArgumentNullException on null key |
| **Value Can Be Null** | For reference types |

---

## 💻 Code Example 1: Basic Dictionary Operations

```csharp
using System;
using System.Collections.Generic;

class GenDictionaryDemo
{
    static void Main()
    {
        // Create a Dictionary for employee names (key) and salaries (value)
        Dictionary<string, double> dict = new Dictionary<string, double>();

        // Add elements to the collection
        dict.Add("Butler", 73000);
        dict.Add("Sanoj", 59000);
        dict.Add("Piku", 45000);
        dict.Add("Frank", 99000);

        // Get a collection of the keys (names)
        ICollection<string> c = dict.Keys;

        // Use the keys to obtain the values (salaries)
        foreach (string str in c)
            Console.WriteLine("{0}, Salary: {1:C}", str, dict[str]);
        
        // Output (order NOT guaranteed):
        // Butler, Salary: $73,000.00
        // Sanoj, Salary: $59,000.00
        // Piku, Salary: $45,000.00
        // Frank, Salary: $99,000.00
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `Dictionary<string, double>` | Create Dictionary with string keys, double values |
| 11-14 | `dict.Add(key, value)` | Add key-value pairs to dictionary |
| 17 | `dict.Keys` | Get collection of all keys |
| 20-21 | `dict[str]` | Access value by key (O(1) lookup) |

---

## 💻 Code Example 2: Practical Use - Counting Occurrences

```csharp
using System;
using System.Collections.Generic;

class CountOccurrence
{
    static void Main()
    {
        // Input array
        string[] arr = { "A", "B", "C", "D", "E", "F", "F", "G", "A" };

        // Step 1: Build frequency dictionary (O(n))
        Dictionary<string, int> freqMap = new Dictionary<string, int>();

        foreach (string item in arr)
        {
            // If key found, increment its value
            if (freqMap.ContainsKey(item))
            {
                // Reading value at key and incrementing it
                freqMap[item] = freqMap[item] + 1;
                // Or shorthand: freqMap[item]++;
            }
            // Else set value to 1
            else
            {
                // Setting value at key
                freqMap[item] = 1;  // If not present, add with count 1
            }
        }

        // Step 2: Query in O(1)
        Console.WriteLine("Count of A: " + freqMap["A"]);  // Output: 2
        Console.WriteLine("Count of F: " + freqMap["F"]);  // Output: 2
    }
}
```

### Memory Diagram After Building:

```
freqMap (Dictionary<string, int>)
┌────────────────────────────────────┐
│         Hash Table                 │
├─────────┬─────────────────────────┤
│   Key   │   Value                 │
├─────────┼─────────────────────────┤
│   "A"   │    2                    │
│   "B"   │    1                    │
│   "C"   │    1                    │
│   "D"   │    1                    │
│   "E"   │    1                    │
│   "F"   │    2                    │
│   "G"   │    1                    │
└─────────┴─────────────────────────┘

Query: freqMap["A"] → Returns 2 in O(1)
```

### Execution Flow:

```
Step 1: Process "A" → Not in dict → Add ["A", 1]
Step 2: Process "B" → Not in dict → Add ["B", 1]
Step 3: Process "C" → Not in dict → Add ["C", 1]
Step 4: Process "D" → Not in dict → Add ["D", 1]
Step 5: Process "E" → Not in dict → Add ["E", 1]
Step 6: Process "F" → Not in dict → Add ["F", 1]
Step 7: Process "F" → In dict → Update ["F", 2]
Step 8: Process "G" → Not in dict → Add ["G", 1]
Step 9: Process "A" → In dict → Update ["A", 2]
```

---

## 💻 Code Example 3: Finding Unique Characters

```csharp
using System;
using System.Collections.Generic;

class UniqueCharsDemo
{
    static void Main(string[] args)
    {
        // Print unique characters with their first index
        string s = "vidyanidhi";
        Dictionary<char, int> ds = new Dictionary<char, int>();

        char[] c = s.ToCharArray();

        for (int i = 0; i < c.Length; i++)
        {
            try
            {
                ds.Add(c[i], i);  // Add char and its index
            }
            catch { }  // Ignore duplicate key exception
        }
        
        foreach (var d in ds)
            Console.WriteLine(d);
        
        // Output:
        // [v, 0]
        // [i, 1]
        // [d, 2]
        // [y, 3]
        // [a, 4]
        // [n, 5]
        // [h, 8]
    }
}
```

### Visual Representation:

```
Input: "vidyanidhi"
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ v │ i │ d │ y │ a │ n │ i │ d │ h │ i │
│ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
          ↓ Duplicate      ↓ Duplicate

Result Dictionary: {v:0, i:1, d:2, y:3, a:4, n:5, h:8}
(Only first occurrence of each character is stored)
```

---

## 📊 Important Dictionary Methods

| Method | Description | Returns |
|--------|-------------|---------|
| `Add(key, value)` | Add new key-value pair | void (throws if key exists) |
| `dict[key] = value` | Add or update | void |
| `Remove(key)` | Remove by key | bool |
| `ContainsKey(key)` | Check if key exists | bool |
| `ContainsValue(value)` | Check if value exists | bool |
| `TryGetValue(key, out value)` | Safe get | bool |
| `Clear()` | Remove all | void |
| `Keys` | Get all keys | ICollection<TKey> |
| `Values` | Get all values | ICollection<TValue> |

---

## 💻 Code Example 4: Add vs Indexer Assignment

```csharp
using System;
using System.Collections.Generic;

class DictionaryAddDemo
{
    static void Main()
    {
        Dictionary<string, int> dict = new Dictionary<string, int>();
        
        // Using Add() - throws if key exists
        dict.Add("one", 1);
        // dict.Add("one", 100);  // ❌ ArgumentException!
        
        // Using indexer - adds OR updates
        dict["two"] = 2;      // Adds new key
        dict["two"] = 200;    // Updates existing key ✅
        
        // Better approach: Check first
        if (!dict.ContainsKey("three"))
        {
            dict.Add("three", 3);
        }
        
        // Or use TryAdd (returns false if exists)
        bool added = dict.TryAdd("four", 4);  // Returns true
        added = dict.TryAdd("four", 400);      // Returns false, not added
    }
}
```

---

## 📊 Dictionary vs SortedDictionary

| Feature | Dictionary | SortedDictionary |
|---------|------------|------------------|
| **Internal Structure** | Hash Table | Red-Black Tree |
| **Lookup Time** | O(1) average | O(log n) |
| **Insert/Delete Time** | O(1) average | O(log n) |
| **Order** | Unordered | Sorted by Key |
| **Memory** | More (hash buckets) | Less |
| **Use When** | Speed is priority | Sorted order needed |

---

## 💻 Code Example 5: SortedDictionary Comparison

```csharp
using System;
using System.Collections.Generic;

class GenSortedDictionaryDemo
{
    static void Main()
    {
        // SortedDictionary - automatically sorted by key
        SortedDictionary<string, double> dict = new SortedDictionary<string, double>();

        // Add elements (order of addition doesn't matter)
        dict.Add("Butler", 73000);
        dict.Add("Sanoj", 59000);
        dict.Add("Piku", 45000);
        dict.Add("Frank", 99000);

        // Get a collection of the keys (sorted)
        ICollection<string> c = dict.Keys;

        // Output is always sorted alphabetically
        foreach (string str in c)
            Console.WriteLine("{0}, Salary: {1:C}", str, dict[str]);
        
        // Output (always in sorted order):
        // Butler, Salary: $73,000.00
        // Frank, Salary: $99,000.00
        // Piku, Salary: $45,000.00
        // Sanoj, Salary: $59,000.00
    }
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **O(1) operations** - Fastest for lookups, inserts, deletes
2. **Unordered** - Don't rely on iteration order
3. **Use ContainsKey** - Before accessing to avoid exception
4. **TryGetValue** - Safer than direct indexer access
5. **Indexer can add or update** - Unlike Add() which throws
6. **Great for counting/grouping** - O(1) updates

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Direct access without check | KeyNotFoundException | Use TryGetValue or ContainsKey |
| Using Add for update | ArgumentException | Use indexer `dict[key] = value` |
| Assuming order | Order not guaranteed | Use SortedDictionary if order needed |
| Null key | ArgumentNullException | Always validate key |

---

## 📝 Interview Questions

1. **What is the time complexity of Dictionary operations?**
   - Add/Remove/Lookup: O(1) average, O(n) worst case (all collisions)

2. **Difference between Add() and indexer assignment?**
   - Add() throws if key exists
   - Indexer adds if not exists, updates if exists

3. **How does Dictionary handle collisions?**
   - Uses chaining (linked list at bucket)
   - Rehashes when load factor exceeds threshold

4. **When to use Dictionary vs SortedDictionary?**
   - Dictionary: Speed priority, order doesn't matter
   - SortedDictionary: Need sorted enumeration

---

## 🔗 Next Topic
Next: [05_SortedDictionary_Collection.md](./05_SortedDictionary_Collection.md) - SortedDictionary<TKey, TValue>
