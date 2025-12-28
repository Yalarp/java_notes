# SortedSet<T> Collection in C#

## 📚 Introduction

`SortedSet<T>` is a collection of unique elements that are automatically maintained in sorted order. It uses a Red-Black tree internally, providing O(log n) operations while guaranteeing sorted enumeration.

---

## 🎯 Learning Objectives

- Understand SortedSet's Red-Black tree structure
- Compare SortedSet with HashSet
- Learn when to use SortedSet

---

## 📖 Theory: How SortedSet Works

```
┌────────────────────────────────────────────────────────────────┐
│                  SortedSet Red-Black Tree                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│                          [C]                                    │
│                        /     \                                  │
│                      [B]     [X]                                │
│                                                                 │
│  Add order: X, C, B                                            │
│  Iteration order: B, C, X (always sorted!)                     │
│                                                                 │
│  ✓ Unique values (like HashSet)                                │
│  ✓ Sorted order (unlike HashSet)                               │
│  ✓ O(log n) operations                                         │
└────────────────────────────────────────────────────────────────┘
```

### SortedSet vs HashSet

| Feature | HashSet | SortedSet |
|---------|---------|-----------|
| **Structure** | Hash Table | Red-Black Tree |
| **Sorted** | ❌ No | ✅ Yes |
| **Add/Remove** | O(1) | O(log n) |
| **Contains** | O(1) | O(log n) |
| **Use When** | Order doesn't matter | Need sorted iteration |

---

## 💻 Code Example: SortedSet Operations

```csharp
using System;
using System.Collections.Generic;

class SortedSetDemo
{
    static void Show(string msg, SortedSet<char> set)
    {
        Console.Write(msg);
        foreach (char ch in set)
            Console.Write(ch + " ");
        Console.WriteLine();
    }
    
    static void Main()
    {
        SortedSet<char> setA = new SortedSet<char>();

        // Add in random order
        setA.Add('X');
        setA.Add('C');
        setA.Add('B');

        Show("Content of setA: ", setA);
        // Output: B C X (automatically sorted!)
        
        // All set operations (Union, Intersect, etc.) also available
        SortedSet<char> setB = new SortedSet<char> { 'A', 'D' };
        setA.UnionWith(setB);
        
        Show("After Union: ", setA);
        // Output: A B C D X (still sorted!)
    }
}
```

### Execution Flow:

```
Add('X') → Tree: [X]
Add('C') → Tree: [C]-[X] (C becomes root, X is right child)
Add('B') → Tree:    [C]
                   /   \
                 [B]   [X]  (Balanced tree)

Iteration (in-order): B → C → X (sorted!)
```

---

## 🔑 Key Points

1. **Always sorted** - Iteration gives elements in order
2. **O(log n) operations** - Slightly slower than HashSet
3. **Same set operations** - Union, Intersect, Except work same way
4. **Use IComparer<T>** - For custom sort order

---

## 🔗 Next Topic
Next: [08_IComparable_IComparer.md](./08_IComparable_IComparer.md) - Custom Sorting
