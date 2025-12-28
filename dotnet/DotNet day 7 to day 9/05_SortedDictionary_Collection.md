# SortedDictionary<TKey, TValue> Collection in C#

## 📚 Introduction

`SortedDictionary<TKey, TValue>` is a collection of key-value pairs that are sorted by key using a binary search tree (specifically a Red-Black tree). It provides O(log n) operations while maintaining sorted order.

---

## 🎯 Learning Objectives

- Understand SortedDictionary's Red-Black tree implementation
- Compare SortedDictionary with Dictionary and SortedList
- Learn when to use each dictionary type

---

## 📖 Theory: How SortedDictionary Works

### Red-Black Tree Structure

```
┌────────────────────────────────────────────────────────────────┐
│              SortedDictionary Red-Black Tree                    │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│                        [Frank, 99000]                          │
│                       /              \                          │
│              [Butler, 73000]   [Piku, 45000]                   │
│                                        \                        │
│                                   [Sanoj, 59000]               │
│                                                                 │
│  ✓ Keys are ALWAYS sorted (in-order traversal)                 │
│  ✓ Balanced tree: O(log n) operations                          │
│  ✓ No indexed access (unlike SortedList)                       │
└────────────────────────────────────────────────────────────────┘
```

### Properties

| Property | Description |
|----------|-------------|
| **Red-Black Tree** | Self-balancing binary search tree |
| **Sorted by Key** | Automatically maintains order |
| **O(log n)** | For add, remove, lookup |
| **No Index Access** | Cannot access by position |
| **No Duplicate Keys** | Throws on duplicate |

---

## 💻 Code Example: SortedDictionary Operations

```csharp
using System;
using System.Collections.Generic;

class GenSortedDictionaryDemo
{
    static void Main()
    {
        // Create SortedDictionary for employee names and salaries
        SortedDictionary<string, double> dict = 
            new SortedDictionary<string, double>();

        // Add elements (order doesn't matter - auto-sorted)
        dict.Add("Butler", 73000);
        dict.Add("Sanoj", 59000);
        dict.Add("Piku", 45000);
        dict.Add("Frank", 99000);
        
        // Get collection of keys (sorted)
        ICollection<string> c = dict.Keys;

        // Iterate - always in sorted order
        foreach (string str in c)
            Console.WriteLine("{0}, Salary: {1:C}", str, dict[str]);
        
        // Output (always sorted alphabetically):
        // Butler, Salary: $73,000.00
        // Frank, Salary: $99,000.00
        // Piku, Salary: $45,000.00
        // Sanoj, Salary: $59,000.00
    }
}
```

---

## 📊 Complete Comparison: Dictionary Types

| Feature | Dictionary | SortedList | SortedDictionary |
|---------|------------|------------|------------------|
| **Structure** | Hash Table | 2 Arrays | Red-Black Tree |
| **Sorted** | ❌ No | ✅ Yes | ✅ Yes |
| **Add/Remove** | O(1) | O(n) | O(log n) |
| **Lookup** | O(1) | O(log n) | O(log n) |
| **Index Access** | ❌ No | ✅ Yes | ❌ No |
| **Memory** | High | Low | Medium |
| **Best For** | Fast access | Small, static | Large, dynamic |

### When to Use Each:

```
┌─────────────────────────────────────────────────────────────┐
│ Need fastest lookups?           → Dictionary                │
│ Need sorted + indexed access?   → SortedList               │
│ Need sorted + frequent updates? → SortedDictionary          │
│ Small data, rarely modified?    → SortedList               │
│ Large data, frequent changes?   → SortedDictionary          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Points

1. **Use SortedDictionary** when you need sorted data with frequent modifications
2. **O(log n) everything** - balanced performance
3. **No index access** - use SortedList if you need `sl[0]`
4. **Same methods as Dictionary** - Add, Remove, ContainsKey, TryGetValue

---

## 🔗 Next Topic
Next: [06_HashSet_Collection.md](./06_HashSet_Collection.md) - HashSet<T>
