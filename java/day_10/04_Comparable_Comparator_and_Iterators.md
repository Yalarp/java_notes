# 📚 Comparable vs Comparator & Fail-Fast vs Fail-Safe Iterators

## Table of Contents
1. [Comparable Interface](#comparable-interface)
2. [Comparator Interface](#comparator-interface)
3. [Comparable vs Comparator](#comparable-vs-comparator)
4. [Fail-Fast Iterator](#fail-fast-iterator)
5. [Fail-Safe Iterator](#fail-safe-iterator)
6. [ArrayList vs CopyOnWriteArrayList](#arraylist-vs-copyonwritearraylist)
7. [Interview Questions](#interview-questions)

---

## 📊 Comparable Interface

### What is Comparable?

The `Comparable` interface is used to define the **natural ordering** of objects. A class that implements Comparable can be sorted automatically by Collections.sort() or used in TreeSet/TreeMap.

### Key Points
- Located in `java.lang` package
- Has single method: `compareTo(T o)`
- Returns: negative, zero, or positive integer
- Defines **natural ordering** (only ONE way to sort)

### Comparable Demo

```java
// FILE: ComparableDemo1.java
// ==========================

import java.util.*;

// Line 1-2: Employee implements Comparable<Employee>
// This means Employee objects can be compared to each other
class Employee implements Comparable<Employee> {
    
    private String name;
    private int age;
    
    // Line 3-6: Constructor
    public Employee(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Line 7-18: THE compareTo() METHOD - Defines natural ordering
    // Returns:
    //   Positive (1)  → this object is GREATER than parameter
    //   Negative (-1) → this object is LESS than parameter
    //   Zero (0)      → this object is EQUAL to parameter
    public int compareTo(Employee e) {
        // Sorting by AGE
        if (age > e.age) {
            return 1;    // This employee is older → comes AFTER
        } else if (age < e.age) {
            return -1;   // This employee is younger → comes BEFORE
        } else {
            return 0;    // Same age → considered EQUAL
        }
    }
    
    // ALTERNATIVE: Sort by name (commented out)
    /*
    public int compareTo(Employee e) {
        // String's compareTo() handles the comparison
        return name.compareTo(e.name);
    }
    */
    
    // Line 19-21: toString for display
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
}

public class ComparableDemo1 {
    public static void main(String[] args) {
        
        // Line 22: Create ArrayList of Employee
        List<Employee> employeeList = new ArrayList<Employee>();
        
        // Lines 23-25: Add employees
        employeeList.add(new Employee("Tim", 23));
        employeeList.add(new Employee("Rolvin", 11));
        employeeList.add(new Employee("Gerald", 12));
        
        // Line 26: Display before sorting
        System.out.println("Before sort");
        System.out.println(employeeList);
        // Output: [[Tim	23], [Rolvin	11], [Gerald	12]]
        
        // Line 27: Sort using natural ordering (compareTo)
        // Collections.sort() calls compareTo() internally
        Collections.sort(employeeList);
        
        // Line 28: Display after sorting
        System.out.println("After sort");
        System.out.println(employeeList);
        // Output: [[Rolvin	11], [Gerald	12], [Tim	23]]
        // Sorted by age: 11 < 12 < 23
    }
}
```

**Flow of Collections.sort() with Comparable:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Collections.sort(employeeList)                                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Step 1: Is Employee Comparable? ─────────────────────► YES ✓     │
│                                                                      │
│   Step 2: Compare Tim(23) with Rolvin(11)                           │
│           Tim.compareTo(Rolvin)                                     │
│           23 > 11 → returns 1 → Tim comes AFTER Rolvin              │
│                                                                      │
│   Step 3: Compare Tim(23) with Gerald(12)                           │
│           Tim.compareTo(Gerald)                                     │
│           23 > 12 → returns 1 → Tim comes AFTER Gerald              │
│                                                                      │
│   Step 4: Compare Rolvin(11) with Gerald(12)                        │
│           Rolvin.compareTo(Gerald)                                  │
│           11 < 12 → returns -1 → Rolvin comes BEFORE Gerald         │
│                                                                      │
│   Result: [Rolvin(11), Gerald(12), Tim(23)]                         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Comparator Interface

### What is Comparator?

The `Comparator` interface is used to define **external/custom ordering** of objects. Unlike Comparable, you can create multiple Comparators for different sorting criteria.

### Key Points
- Located in `java.util` package
- Has method: `compare(T o1, T o2)`
- Returns: negative, zero, or positive integer
- Allows **multiple sorting strategies** (many ways to sort)
- Class being sorted doesn't need modification

### Comparator Demo

```java
// FILE: ComparatorDemo1.java
// ==========================

import java.util.*;

// Line 1-11: Employee class - Does NOT implement Comparable
// Sorting logic is EXTERNAL in separate Comparator classes
class Employee {
    private String name;
    private int age;
    
    public Employee(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
    
    // Getter methods for Comparators to access private fields
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
}

// Line 12-17: COMPARATOR #1 - Sort by Name
class SortByName implements Comparator<Employee> {
    
    // compare() method - compares TWO Employee objects
    public int compare(Employee e1, Employee e2) {
        // Use String's compareTo for alphabetical ordering
        return e1.getName().compareTo(e2.getName());
    }
}

// Line 18-31: COMPARATOR #2 - Sort by Age
class SortByAge implements Comparator<Employee> {
    
    public int compare(Employee e1, Employee e2) {
        // Compare ages numerically
        if (e1.getAge() > e2.getAge()) {
            return 1;    // e1 is older → e1 comes AFTER e2
        } else if (e1.getAge() < e2.getAge()) {
            return -1;   // e1 is younger → e1 comes BEFORE e2
        } else {
            return 0;    // Same age
        }
    }
}

public class ComparatorDemo1 {
    public static void main(String[] args) {
        
        // Create employee list
        List<Employee> employeeList = new ArrayList<Employee>();
        employeeList.add(new Employee("Tim", 23));
        employeeList.add(new Employee("Rolvin", 11));
        employeeList.add(new Employee("Gerald", 32));
        
        // SORT BY NAME using SortByName Comparator
        System.out.println("Sort by name");
        Collections.sort(employeeList, new SortByName());
        System.out.println(employeeList);
        // Output: [[Gerald	32], [Rolvin	11], [Tim	23]]
        // Alphabetical: Gerald < Rolvin < Tim
        
        // SORT BY AGE using SortByAge Comparator
        System.out.println("Sort by age");
        Collections.sort(employeeList, new SortByAge());
        System.out.println(employeeList);
        // Output: [[Rolvin	11], [Tim	23], [Gerald	32]]
        // By age: 11 < 23 < 32
    }
}
```

**Flow Diagram:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Comparator Pattern                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐                                                   │
│  │   Employee   │ ← No sorting logic inside!                        │
│  │   (class)    │   Just data holder                                │
│  └──────────────┘                                                   │
│          │                                                           │
│          │ used by                                                   │
│          ▼                                                           │
│  ┌──────────────────────┐    ┌──────────────────────┐              │
│  │   SortByName         │    │   SortByAge          │              │
│  │   (Comparator)       │    │   (Comparator)       │              │
│  ├──────────────────────┤    ├──────────────────────┤              │
│  │ compare(e1, e2)      │    │ compare(e1, e2)      │              │
│  │ → alphabetical       │    │ → numerical by age   │              │
│  └──────────────────────┘    └──────────────────────┘              │
│                                                                      │
│  Collections.sort(list, new SortByName()) → Sort alphabetically    │
│  Collections.sort(list, new SortByAge())  → Sort by age            │
│                                                                      │
│  ✓ Same list, different sorting - just swap Comparator!            │
└─────────────────────────────────────────────────────────────────────┘
```

---

## ⚖️ Comparable vs Comparator

### Comparison Table

| Feature | Comparable | Comparator |
|---------|------------|------------|
| **Package** | `java.lang` | `java.util` |
| **Method** | `compareTo(T o)` | `compare(T o1, T o2)` |
| **Number of Args** | 1 (compare with `this`) | 2 (compare two objects) |
| **Sorting Strategies** | ONE (natural ordering) | MULTIPLE (external) |
| **Modifies Class?** | ✅ Yes (implements interface) | ❌ No (separate class) |
| **Use Case** | Default/natural order | Custom/multiple orders |
| **Examples** | String, Integer, Date | Custom sorting needs |

### When to Use Which?

```java
// USE COMPARABLE when:
// ====================
// - You have ONE natural ordering
// - You own the class and can modify it
// - Ordering is intrinsic to the object

class Product implements Comparable<Product> {
    private double price;
    
    // Natural ordering by price (makes sense for products)
    public int compareTo(Product p) {
        return Double.compare(this.price, p.price);
    }
}


// USE COMPARATOR when:
// ====================
// - You need MULTIPLE sorting criteria
// - You can't modify the class
// - Ordering is not intrinsic to the object

// Sort employees by name
class NameComparator implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        return e1.getName().compareTo(e2.getName());
    }
}

// Sort employees by salary
class SalaryComparator implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        return Double.compare(e1.getSalary(), e2.getSalary());
    }
}

// Sort employees by department, then by name
class DeptThenNameComparator implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        int deptCompare = e1.getDept().compareTo(e2.getDept());
        if (deptCompare != 0) return deptCompare;
        return e1.getName().compareTo(e2.getName());
    }
}
```

---

## ⚡ Fail-Fast Iterator

### What is Fail-Fast?

**Fail-Fast iterator** immediately throws `ConcurrentModificationException` if the collection is structurally modified (add/remove) while iterating.

### Key Characteristics
- Used by: ArrayList, HashMap, HashSet, etc.
- Throws `ConcurrentModificationException` on modification
- Detects modifications using internal `modCount` variable
- Designed to catch bugs early

### Fail-Fast Demo

```java
// FILE: First.java - Fail-Fast Iterator Demo
// ==========================================

import java.util.*;
import java.util.concurrent.*;

public class First {
    public static void main(String args[]) {
        
        // Line 1: Create ArrayList (uses Fail-Fast iterator)
        List<String> list = new ArrayList<String>();
        
        // Lines 2-3: Add elements
        list.add("vivek");
        list.add("kumar");
        
        // Line 4: Create iterator
        // Iterator takes a "snapshot" of modCount
        Iterator i = list.iterator();
        
        // Lines 5-8: Iterate and try to modify
        while (i.hasNext()) {
            System.out.println(i.next());
            
            // ⚠️ THIS CAUSES ConcurrentModificationException!
            // list.add("abhishek");
            // 
            // Why? Because:
            // 1. Iterator remembers modCount when created
            // 2. list.add() increments modCount
            // 3. Iterator checks modCount on next()
            // 4. modCount changed → EXCEPTION!
        }
    }
}
```

**Internal Mechanism:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Fail-Fast Iterator - Internal Working                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ArrayList                        Iterator                         │
│   ┌──────────────┐                ┌──────────────┐                 │
│   │ modCount: 2  │                │expectedMod: 2│                 │
│   │              │   iterator()   │              │                 │
│   │ ["vivek",    │ ──────────────►│ Stores       │                 │
│   │  "kumar"]    │                │ modCount=2   │                 │
│   └──────────────┘                └──────────────┘                 │
│                                                                      │
│   list.add("abhishek")                                              │
│   ┌──────────────┐                                                  │
│   │ modCount: 3  │  ← modCount incremented!                        │
│   │              │                                                  │
│   │ ["vivek",    │                                                  │
│   │  "kumar",    │                                                  │
│   │  "abhishek"] │                                                  │
│   └──────────────┘                                                  │
│                                                                      │
│   Iterator.next()                                                   │
│   ┌──────────────────────────────────────────────────────────┐     │
│   │ Check: modCount(3) == expectedModCount(2)?               │     │
│   │        3 != 2 → ❌ ConcurrentModificationException!      │     │
│   └──────────────────────────────────────────────────────────┘     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🛡️ Fail-Safe Iterator

### What is Fail-Safe?

**Fail-Safe iterator** allows modifications to the collection while iterating because it works on a COPY (clone) of the collection.

### Key Characteristics
- Used by: CopyOnWriteArrayList, ConcurrentHashMap, etc.
- Does NOT throw `ConcurrentModificationException`
- Works on a snapshot/copy of data
- Modifications won't be visible in current iteration
- Iterator's `remove()` is NOT supported

### Fail-Safe Demo

```java
// FILE: First_a.java - Fail-Safe Iterator Demo
// =============================================

import java.util.*;
import java.util.concurrent.*;

public class First_a {
    public static void main(String args[]) {
        
        // Line 1: Create CopyOnWriteArrayList (uses Fail-Safe iterator)
        List<String> list = new CopyOnWriteArrayList<String>();
        
        // Lines 2-3: Add elements
        list.add("vivek");
        list.add("kumar");
        
        // Line 4: Create iterator
        // Iterator gets a SNAPSHOT of the list at this moment
        Iterator i = list.iterator();
        
        // Lines 5-9: Iterate and modify
        while (i.hasNext()) {
            System.out.println(i.next());
            
            // ✓ This does NOT throw exception!
            list.add("abhishek");
            
            // ⚠️ BUT this will throw UnsupportedOperationException!
            // i.remove();  // Not supported in CopyOnWriteArrayList
        }
        // Output: vivek, kumar
        // (abhishek is NOT printed because iterator uses old snapshot)
        
        System.out.println("*******************");
        
        // Line 10: Create NEW iterator to see modifications
        i = list.iterator();
        while (i.hasNext()) {
            System.out.println(i.next());
        }
        // Output: vivek, kumar, abhishek, abhishek
        // (abhishek was added twice in previous loop!)
    }
}
```

**Internal Mechanism:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Fail-Safe Iterator - Internal Working                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   CopyOnWriteArrayList           Iterator                           │
│   ┌──────────────────┐          ┌──────────────────┐               │
│   │ array: [vivek,   │iterator()│ snapshot: [vivek,│               │
│   │         kumar]   │─────────►│           kumar] │               │
│   └──────────────────┘          └──────────────────┘               │
│                                        │                            │
│   list.add("abhishek")                 │ Iterator works on          │
│   ┌──────────────────┐                 │ the SNAPSHOT, not          │
│   │ NEW array:       │                 │ the actual list            │
│   │ [vivek, kumar,   │                 │                            │
│   │  abhishek]       │                 ▼                            │
│   └──────────────────┘          next() returns from snapshot:      │
│                                  "vivek", "kumar" (only 2!)         │
│                                                                      │
│   To see "abhishek", create NEW iterator:                           │
│   i = list.iterator() → new snapshot with all 4 elements           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 ArrayList vs CopyOnWriteArrayList

### Comparison Demo

```java
// FILE: Second.java - Complete Comparison
// ========================================

import java.util.*;
import java.util.concurrent.*;

public class Second {
    public static void main(String args[]) {
        
        // CopyOnWriteArrayList - Fail-Safe
        List<String> list = new CopyOnWriteArrayList<String>();
        list.add("vivek");
        list.add("kumar");
        
        System.out.println("Before modification\t" + list);
        // Output: [vivek, kumar]
        
        Iterator i = list.iterator();
        while (i.hasNext()) {
            System.out.println(i.next());
            list.add("abhishek");  // ✓ No exception
            
            // i.remove();  // ⚠️ UnsupportedOperationException!
        }
        
        System.out.println("After modification\t" + list);
        // Output: [vivek, kumar, abhishek, abhishek]
        // (added twice - once for each iteration)
        
        // New iterator sees all modifications
        System.out.println("After modification:");
        Iterator i2 = list.iterator();
        while (i2.hasNext()) {
            System.out.println(i2.next());
        }
        // Output: vivek, kumar, abhishek, abhishek
    }
}
```

### Why Iterator.remove() Fails in CopyOnWriteArrayList

```java
// FILE: Third.java - remove() Not Supported
// ==========================================

/*
 * "remove()" operation is NOT allowed in case of Iterator of
 * CopyOnWriteArrayList
 */

package core1;

import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class Third {
    public static void main(String[] args) {
        
        List<Integer> mylist = new CopyOnWriteArrayList<>();
        mylist.add(10);
        mylist.add(20);
        mylist.add(30);
        mylist.add(40);
        
        System.out.println("Using Iterator");
        Iterator<Integer> itr = mylist.iterator();
        
        while (itr.hasNext()) {
            int k = itr.next();
            
            if (k == 20) {
                // ⚠️ This throws UnsupportedOperationException!
                itr.remove();
                // Why? Because iterator works on SNAPSHOT
                // Removing from snapshot makes no sense!
            }
            System.out.println(k);
        }
    }
}
```

### Comparison Table

| Feature | ArrayList | CopyOnWriteArrayList |
|---------|-----------|----------------------|
| **Thread-Safe** | ❌ No | ✅ Yes |
| **Iterator Type** | Fail-Fast | Fail-Safe |
| **Modify During Iteration** | ❌ Exception | ✅ Allowed |
| **Iterator.remove()** | ✅ Supported | ❌ UnsupportedOperationException |
| **Memory** | Less | More (creates copies) |
| **Write Performance** | Fast | Slow (copies on write) |
| **Read Performance** | Fast | Fast |
| **Use Case** | Single-threaded | Multi-threaded reads |

### When to Use Which?

```java
// USE ArrayList when:
// - Single-threaded environment
// - Need to remove while iterating
// - Memory is a concern
// - Frequent writes

// USE CopyOnWriteArrayList when:
// - Multi-threaded environment
// - Reads are much more frequent than writes
// - Need to iterate without worrying about modifications
// - Don't need to remove during iteration
```

---

## 📝 Interview Questions

### Q1: What is the difference between Comparable and Comparator?
**Answer:**
- **Comparable**: Defines natural ordering INSIDE the class (`compareTo()` method). Single sorting sequence.
- **Comparator**: Defines custom ordering OUTSIDE the class (`compare()` method). Multiple sorting sequences possible.

### Q2: Can a class implement both Comparable and use Comparator?
**Answer:** Yes! Comparable defines the default/natural ordering, while Comparator can override it with custom ordering when needed.

### Q3: What is Fail-Fast iterator?
**Answer:** Fail-Fast iterator throws `ConcurrentModificationException` if the collection is modified structurally while iterating. Used by ArrayList, HashMap, etc. It fails immediately when modification is detected.

### Q4: What is Fail-Safe iterator?
**Answer:** Fail-Safe iterator works on a copy/snapshot of the collection, so modifications don't affect iteration. Used by CopyOnWriteArrayList, ConcurrentHashMap. It never throws ConcurrentModificationException.

### Q5: Why does CopyOnWriteArrayList not support Iterator.remove()?
**Answer:** Because the iterator works on a snapshot. Removing from a snapshot makes no sense - it wouldn't affect the actual list. To remove, use the list's remove() method directly.

### Q6: How does Fail-Fast iterator detect modification?
**Answer:** Using an internal `modCount` variable. When iterator is created, it stores the current modCount. On each next() call, it checks if modCount has changed. If changed, it throws ConcurrentModificationException.

### Q7: What is ConcurrentModificationException?
**Answer:** It's a RuntimeException thrown when a collection is modified while iterating using a Fail-Fast iterator. It indicates a programming error - concurrent modification that could lead to unpredictable behavior.

### Q8: How to safely modify a collection while iterating?
**Answer:**
1. Use iterator's `remove()` method (not list's remove)
2. Use Fail-Safe collections (CopyOnWriteArrayList, ConcurrentHashMap)
3. Use traditional for loop with index manipulation
4. Collect items to remove/add and process after iteration

---

> [!TIP]
> **Memory Tip for Comparable vs Comparator:**
> - Comparable = "I can compare myself" (single method in class)
> - Comparator = "External comparator tool" (separate class, multiple strategies)

