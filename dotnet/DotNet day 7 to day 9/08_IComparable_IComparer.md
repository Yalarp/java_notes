# IComparable<T> and IComparer<T> in C#

## 📚 Introduction

When you need to sort custom objects in collections, you must define how objects compare to each other. C# provides two interfaces: `IComparable<T>` for natural ordering and `IComparer<T>` for external comparison logic.

---

## 🎯 Learning Objectives

- Understand the difference between IComparable and IComparer
- Implement custom sorting for objects
- Use comparison interfaces with List.Sort()

---

## 📖 Theory: Two Approaches to Comparison

```
┌────────────────────────────────────────────────────────────────┐
│                    Comparison Interfaces                        │
├──────────────────────┬─────────────────────────────────────────┤
│    IComparable<T>    │          IComparer<T>                   │
├──────────────────────┼─────────────────────────────────────────┤
│ Implemented BY the   │ Implemented as SEPARATE class          │
│ class being compared │                                         │
├──────────────────────┼─────────────────────────────────────────┤
│ "Natural" ordering   │ "Custom" ordering                       │
├──────────────────────┼─────────────────────────────────────────┤
│ obj.CompareTo(other) │ comparer.Compare(obj1, obj2)           │
├──────────────────────┼─────────────────────────────────────────┤
│ One sort order only  │ Multiple sort orders possible          │
└──────────────────────┴─────────────────────────────────────────┘
```

### Return Value Convention

| Return Value | Meaning |
|--------------|---------|
| **< 0** | Current object comes BEFORE the other |
| **= 0** | Objects are EQUAL in order |
| **> 0** | Current object comes AFTER the other |

---

## 💻 Code Example 1: IComparable<T> Implementation

```csharp
using System;
using System.Collections.Generic;

// Implement the generic IComparable<T> interface
class Inventory : IComparable<Inventory>
{
    string name;      // Item name
    double cost;      // Item cost
    int onhand;       // Quantity on hand

    public Inventory(string n, double c, int h)
    {
        name = n;
        cost = c;
        onhand = h;
    }

    public override string ToString()
    {
        return String.Format("{0,-10}Cost: {1,6:C}  On hand: {2}", 
                            name, cost, onhand);
    }
    
    // Implement the IComparable<T> interface
    public int CompareTo(Inventory obj)
    {
        // Compare by name (alphabetical order)
        return name.CompareTo(obj.name);
    }
}

class GenericIComparableDemo
{
    static void Main()
    {
        List<Inventory> inv = new List<Inventory>();

        // Add elements to the list
        inv.Add(new Inventory("Pliers", 5.95, 3));
        inv.Add(new Inventory("Wrenches", 8.29, 2));
        inv.Add(new Inventory("Hammers", 3.50, 4));
        inv.Add(new Inventory("Drills", 19.88, 8));

        Console.WriteLine("Inventory list before sorting:");
        foreach (Inventory i in inv)
            Console.WriteLine("   " + i);
        
        // Sort the list (uses CompareTo method)
        inv.Sort();

        Console.WriteLine("\nInventory list after sorting:");
        foreach (Inventory i in inv)
            Console.WriteLine("   " + i);
    }
}
```

### Output:

```
Inventory list before sorting:
   Pliers    Cost:  $5.95  On hand: 3
   Wrenches  Cost:  $8.29  On hand: 2
   Hammers   Cost:  $3.50  On hand: 4
   Drills    Cost: $19.88  On hand: 8

Inventory list after sorting:
   Drills    Cost: $19.88  On hand: 8
   Hammers   Cost:  $3.50  On hand: 4
   Pliers    Cost:  $5.95  On hand: 3
   Wrenches  Cost:  $8.29  On hand: 2
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 5 | `class Inventory : IComparable<Inventory>` | Class implements IComparable |
| 25-29 | `public int CompareTo(Inventory obj)` | Required method implementation |
| 28 | `name.CompareTo(obj.name)` | Delegate to string's CompareTo |
| 48 | `inv.Sort()` | Calls CompareTo to determine order |

### Execution Flow:

```
inv.Sort() internally works like this:

Compare("Pliers", "Wrenches") → "P" < "W" → Pliers before Wrenches
Compare("Pliers", "Hammers")  → "P" > "H" → Hammers before Pliers
Compare("Pliers", "Drills")   → "P" > "D" → Drills before Pliers
...

Final order: Drills, Hammers, Pliers, Wrenches (alphabetical)
```

---

## 💻 Code Example 2: IComparer<T> Implementation

```csharp
using System;
using System.Collections.Generic;

// Create a SEPARATE IComparer for Inventory objects
class CompInv : IComparer<Inventory>
{
    // Implement the Compare method
    public int Compare(Inventory x, Inventory y)
    {
        return string.Compare(x.name, y.name);
    }
}

class Inventory
{
    public string name;   // Made public for comparer access
    double cost;
    int onhand;

    public Inventory(string n, double c, int h)
    {
        name = n;
        cost = c;
        onhand = h;
    }
    
    public override string ToString()
    {
        return String.Format("{0,-10}Cost: {1,6:C}  On hand: {2}", 
                            name, cost, onhand);
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Create the comparer instance
        CompInv comp = new CompInv();
        
        List<Inventory> inv = new List<Inventory>();

        // Add elements to the list
        inv.Add(new Inventory("Pliers", 5.95, 3));
        inv.Add(new Inventory("Wrenches", 8.29, 2));
        inv.Add(new Inventory("Hammers", 3.50, 4));
        inv.Add(new Inventory("Drills", 19.88, 8));

        Console.WriteLine("Inventory list before sorting:");
        foreach (Inventory i in inv)
            Console.WriteLine("   " + i);

        // Sort using the IComparer
        inv.Sort(comp);  // Pass comparer to Sort()

        Console.WriteLine("\nInventory list after sorting:");
        foreach (Inventory i in inv)
            Console.WriteLine("   " + i);
    }
}
```

### Key Difference:

```
┌─────────────────────────────────────────────────────────────────┐
│  IComparable<T>           │  IComparer<T>                      │
├───────────────────────────┼─────────────────────────────────────┤
│  inv.Sort()               │  inv.Sort(comp)                    │
│  (uses object's method)   │  (uses external comparer)          │
├───────────────────────────┼─────────────────────────────────────┤
│  One fixed sort order     │  Multiple comparers = multiple     │
│                           │  sort orders possible              │
└───────────────────────────┴─────────────────────────────────────┘
```

---

## 💻 Code Example 3: Multiple Sort Orders with IComparer

```csharp
using System;
using System.Collections.Generic;

class Inventory
{
    public string Name { get; set; }
    public double Cost { get; set; }
    public int OnHand { get; set; }
    
    public Inventory(string n, double c, int h)
    {
        Name = n; Cost = c; OnHand = h;
    }
}

// Sort by Name
class SortByName : IComparer<Inventory>
{
    public int Compare(Inventory x, Inventory y) 
        => x.Name.CompareTo(y.Name);
}

// Sort by Cost
class SortByCost : IComparer<Inventory>
{
    public int Compare(Inventory x, Inventory y) 
        => x.Cost.CompareTo(y.Cost);
}

// Sort by OnHand quantity
class SortByQuantity : IComparer<Inventory>
{
    public int Compare(Inventory x, Inventory y) 
        => x.OnHand.CompareTo(y.OnHand);
}

class Program
{
    static void Main()
    {
        List<Inventory> inv = new List<Inventory>
        {
            new Inventory("Pliers", 5.95, 3),
            new Inventory("Wrenches", 8.29, 2),
            new Inventory("Hammers", 3.50, 4),
            new Inventory("Drills", 19.88, 8)
        };
        
        // Sort by Name
        inv.Sort(new SortByName());
        Console.WriteLine("Sorted by Name:");
        // Drills, Hammers, Pliers, Wrenches
        
        // Sort by Cost
        inv.Sort(new SortByCost());
        Console.WriteLine("Sorted by Cost:");
        // Hammers(3.50), Pliers(5.95), Wrenches(8.29), Drills(19.88)
        
        // Sort by Quantity
        inv.Sort(new SortByQuantity());
        Console.WriteLine("Sorted by Quantity:");
        // Wrenches(2), Pliers(3), Hammers(4), Drills(8)
    }
}
```

---

## 📊 When to Use Each

| Scenario | Use |
|----------|-----|
| Class has ONE natural order | IComparable<T> |
| Need multiple sort orders | IComparer<T> |
| Can't modify the class | IComparer<T> |
| Sorting 3rd party objects | IComparer<T> |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **IComparable** - Implemented BY the class, defines natural order
2. **IComparer** - External class, allows multiple sort orders
3. **Return < 0** - First object comes before second
4. **Return > 0** - First object comes after second
5. **Return = 0** - Objects are equal in sort order

---

## 📝 Interview Questions

1. **Difference between IComparable and IComparer?**
   - IComparable: Implemented by class, one natural order
   - IComparer: Separate class, multiple orders possible

2. **What does CompareTo return?**
   - Negative: this < other
   - Zero: this == other
   - Positive: this > other

3. **When would you use IComparer over IComparable?**
   - Need multiple sort orders
   - Cannot modify the class
   - Sorting third-party objects

---

## 🔗 Next Topic
Next: [09_IEnumerable_IEnumerator.md](./09_IEnumerable_IEnumerator.md) - Custom Iteration
