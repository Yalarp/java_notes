# HashSet<T> Collection in C#

## 📚 Introduction

`HashSet<T>` is an unordered collection of unique elements. It uses a hash table for storage, providing O(1) average time for add, remove, and contains operations. Introduced in .NET 3.5, it's perfect for ensuring no duplicates.

---

## 🎯 Learning Objectives

- Understand HashSet's unique value guarantee
- Master set operations: Union, Intersect, Except, SymmetricExcept
- Learn practical use cases for HashSet

---

## 📖 Theory: How HashSet Works

```
┌────────────────────────────────────────────────────────────────┐
│                    HashSet Hash Table                           │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Add("C#") → GetHashCode() → 5678 → 5678 % 7 = 1               │
│  Add("C#") → Already at bucket 1 → REJECTED (duplicate!)       │
│                                                                 │
│  Bucket Array:                                                  │
│  ┌───┬───────┬───┬───┬───────┬───┬───┐                        │
│  │ 0 │   1   │ 2 │ 3 │   4   │ 5 │ 6 │                        │
│  │   │ "C#"  │   │   │"Java" │   │   │                        │
│  └───┴───────┴───┴───┴───────┴───┴───┘                        │
│                                                                 │
│  ✓ NO duplicate values allowed                                 │
│  ✓ O(1) for Add, Remove, Contains                              │
│  ✓ Unordered - no guaranteed iteration order                   │
└────────────────────────────────────────────────────────────────┘
```

### HashSet Properties

| Property | Description |
|----------|-------------|
| **Unique Values** | No duplicates allowed |
| **Hash Table** | O(1) average operations |
| **Unordered** | No guaranteed order |
| **Null Allowed** | Can contain one null |
| **Value Type** | Stores only values (not key-value) |

---

## 💻 Code Example 1: Basic HashSet Operations

```csharp
using System;
using System.Collections.Generic;

class HashSetBasicDemo
{
    static public void Main()
    {
        // Create HashSet using HashSet class
        HashSet<string> myhash = new HashSet<string>();
        
        // Add elements to HashSet
        myhash.Add("C");
        myhash.Add("C++");
        myhash.Add("C#");
        myhash.Add("Java");
        myhash.Add("Ruby");
        myhash.Add("Php");
        
        // Check count
        Console.WriteLine("Total elements: {0}", myhash.Count);
        // Output: Total elements: 6
        
        // Remove element
        myhash.Remove("Ruby");
        Console.WriteLine("After removing Ruby: {0}", myhash.Count);
        // Output: After removing Ruby: 5
        
        // RemoveWhere with predicate
        myhash.RemoveWhere(data => data.StartsWith("C"));
        // Removes: C, C++, C#
        
        foreach (var val in myhash)
        {
            Console.WriteLine(val);
        }
        // Output: Java, Php
        
        // Clear all elements
        myhash.Clear();
        Console.WriteLine("After Clear: {0}", myhash.Count);
        // Output: After Clear: 0
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `HashSet<string> myhash` | Create empty HashSet for strings |
| 11-16 | `myhash.Add(value)` | Add unique values |
| 19 | `myhash.Count` | Get number of elements |
| 22 | `myhash.Remove("Ruby")` | Remove specific element |
| 26 | `RemoveWhere(predicate)` | Remove all matching predicate |
| 33 | `myhash.Clear()` | Remove all elements |

---

## 💻 Code Example 2: Set Operations - Union

```csharp
using System;
using System.Collections.Generic;

class HashSetUnionDemo
{
    static void Show(string msg, HashSet<char> set)
    {
        Console.Write(msg);
        foreach (char ch in set)
            Console.Write(ch + " ");
        Console.WriteLine();
    }
    
    static void Main()
    {
        HashSet<char> setA = new HashSet<char>();
        HashSet<char> setB = new HashSet<char>();

        setA.Add('A');
        setA.Add('B');
        setA.Add('C');

        setB.Add('C');
        setB.Add('D');
        setB.Add('E');

        Show("Initial setA: ", setA);  // A B C
        Show("Initial setB: ", setB);  // C D E

        // Union: Combines all elements (no duplicates)
        setA.UnionWith(setB);
        Show("setA after Union with setB: ", setA);
        // Output: A B C D E
    }
}
```

### Union Visual:

```
┌─────────────┐     ┌─────────────┐
│   Set A     │     │   Set B     │
│  A   B   C  │     │  C   D   E  │
└──────┬──────┘     └──────┬──────┘
       │                   │
       └─────────┬─────────┘
                 ▼
         ┌─────────────────┐
         │  A  B  C  D  E  │  ← UnionWith
         └─────────────────┘
```

---

## 💻 Code Example 3: Set Operations - Intersect

```csharp
using System;
using System.Collections.Generic;

class HashSetIntersectDemo
{
    static void Show(string msg, HashSet<char> set)
    {
        Console.Write(msg);
        foreach (char ch in set)
            Console.Write(ch + " ");
        Console.WriteLine();
    }
    
    static void Main()
    {
        HashSet<char> setA = new HashSet<char> { 'A', 'B', 'C' };
        HashSet<char> setB = new HashSet<char> { 'C', 'D', 'E' };

        Show("Initial setA: ", setA);  // A B C
        Show("Initial setB: ", setB);  // C D E

        // Intersect: Only common elements
        setA.IntersectWith(setB);
        Show("setA after Intersect with setB: ", setA);
        // Output: C (only common element)
    }
}
```

### Intersect Visual:

```
┌─────────────┐     ┌─────────────┐
│   Set A     │     │   Set B     │
│  A   B │ C  │     │  C │ D   E  │
└────────┼────┘     └────┼────────┘
         │               │
         └───────┬───────┘
                 ▼
            ┌─────────┐
            │    C    │  ← IntersectWith
            └─────────┘
```

---

## 💻 Code Example 4: Set Operations - Except (Difference)

```csharp
using System;
using System.Collections.Generic;

class HashSetExceptDemo
{
    static void Show(string msg, HashSet<char> set)
    {
        Console.Write(msg);
        foreach (char ch in set)
            Console.Write(ch + " ");
        Console.WriteLine();
    }
    
    static void Main()
    {
        HashSet<char> setA = new HashSet<char> { 'A', 'B', 'C' };
        HashSet<char> setB = new HashSet<char> { 'C', 'D', 'E' };

        Show("Initial setA: ", setA);  // A B C
        Show("Initial setB: ", setB);  // C D E

        // Except: Elements in A but not in B
        setA.ExceptWith(setB);
        Show("setA after Except with setB: ", setA);
        // Output: A B (C was removed because it's in B)
    }
}
```

### Except (A - B) Visual:

```
     A = {2, 3, 4, 5, 6, 7}
     B = {3, 5, 7, 9, 11, 13}
     
     A – B = {2, 4, 6}  (elements in A but not in B)
```

---

## 💻 Code Example 5: Symmetric Difference

```csharp
using System;
using System.Collections.Generic;

class HashSetSymmetricDemo
{
    static void Show(string msg, HashSet<char> set)
    {
        Console.Write(msg);
        foreach (char ch in set)
            Console.Write(ch + " ");
        Console.WriteLine();
    }
    
    static void Main()
    {
        HashSet<char> setA = new HashSet<char> { 'A', 'B', 'C' };
        HashSet<char> setB = new HashSet<char> { 'C', 'D', 'E' };

        Show("Initial setA: ", setA);  // A B C
        Show("Initial setB: ", setB);  // C D E

        // SymmetricExcept: Elements in A or B but NOT both
        setA.SymmetricExceptWith(setB);
        Show("setA after SymmetricExcept with setB: ", setA);
        // Output: A B D E (C removed because it's in BOTH)
    }
}
```

### Symmetric Difference Visual:

```
┌─────────────────────────────────────────┐
│         Symmetric Difference            │
├─────────────────────────────────────────┤
│                                         │
│    ┌───────┐     ┌───────┐             │
│    │ A   B │  C  │ D   E │             │
│    │   ████│     │████   │             │
│    └───────┘     └───────┘             │
│        ▲             ▲                  │
│        │             │                  │
│   In A only     In B only              │
│                                         │
│   Result: A B D E (excludes C)         │
└─────────────────────────────────────────┘
```

---

## 💻 Code Example 6: Practical - Remove Duplicates

```csharp
using System;
using System.Collections.Generic;

class RemoveDuplicatesDemo
{
    static void Main(string[] args)
    {
        string s = "vidyanidhi";
        HashSet<char> uniqueChars = new HashSet<char>();
        
        char[] c = s.ToCharArray();
        
        for (int i = 0; i < c.Length; i++)
        {
            uniqueChars.Add(c[i]);  // Duplicates automatically ignored
        }
        
        foreach (var d in uniqueChars)
            Console.WriteLine(d);
        
        // Output: v i d y a n h
        // (duplicates 'i' and 'd' appear only once)
    }
}
```

### Memory Diagram:

```
Input: "vidyanidhi"
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ v │ i │ d │ y │ a │ n │ i │ d │ h │ i │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
      ↓       ↓      ↓       ↓      ↓  ↓
   Added  Added  Added       │    Added │
                          Ignored    Ignored

HashSet: { v, i, d, y, a, n, h }  (7 unique chars)
```

---

## 📋 Complete Set Operations Summary

| Method | Description | Example |
|--------|-------------|---------|
| `UnionWith(B)` | A ∪ B - All elements | {1,2} ∪ {2,3} = {1,2,3} |
| `IntersectWith(B)` | A ∩ B - Common only | {1,2} ∩ {2,3} = {2} |
| `ExceptWith(B)` | A - B - In A, not B | {1,2} - {2,3} = {1} |
| `SymmetricExceptWith(B)` | A △ B - Not in both | {1,2} △ {2,3} = {1,3} |
| `IsSubsetOf(B)` | A ⊆ B? | Returns bool |
| `IsSupersetOf(B)` | A ⊇ B? | Returns bool |
| `Overlaps(B)` | Any common? | Returns bool |
| `SetEquals(B)` | A = B? | Returns bool |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **No duplicates** - Add returns false if exists
2. **O(1) operations** - Hash table performance
3. **Unordered** - Use SortedSet if order needed
4. **Set operations** - Union, Intersect, Except built-in
5. **Null allowed** - Can contain one null value

---

## 📝 Interview Questions

1. **How does HashSet ensure uniqueness?**
   - Uses hash table; checks hash code and equality before adding

2. **Difference between HashSet and List?**
   - HashSet: Unique values, O(1) contains, unordered
   - List: Allows duplicates, O(n) contains, ordered

3. **What is SymmetricExceptWith?**
   - Returns elements in either set but NOT in both

---

## 🔗 Next Topic
Next: [07_SortedSet_Collection.md](./07_SortedSet_Collection.md) - SortedSet<T>
