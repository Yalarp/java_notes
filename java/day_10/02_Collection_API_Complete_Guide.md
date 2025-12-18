# 📚 Java Collection API - Complete Guide (Basic to Advanced)

## Table of Contents
1. [Introduction to Collection API](#introduction-to-collection-api)
2. [Collection Hierarchy](#collection-hierarchy)
3. [Why Collection API?](#why-collection-api)
4. [List Interface and Implementations](#list-interface-and-implementations)
5. [Set Interface and Implementations](#set-interface-and-implementations)
6. [Queue Interface](#queue-interface)
7. [Iterator Interface](#iterator-interface)
8. [Collections Utility Class](#collections-utility-class)
9. [Algorithms in Collections](#algorithms-in-collections)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction to Collection API

The **Collection API** (also called Collection Framework) is a unified architecture for representing and manipulating collections in Java. It provides a set of interfaces, implementations, and algorithms for working with groups of objects.

> [!IMPORTANT]
> All Collection API classes are in the `java.util` package. Always import: `import java.util.*;`

---

## 📊 Collection Hierarchy

```
                            ┌───────────────────┐
                            │    Iterable       │ (Interface)
                            └─────────┬─────────┘
                                      │
                            ┌─────────▼─────────┐
                            │   Collection      │ (Interface)
                            └─────────┬─────────┘
                                      │
          ┌───────────────────────────┼───────────────────────────┐
          │                           │                           │
┌─────────▼─────────┐      ┌─────────▼─────────┐      ┌─────────▼─────────┐
│       List        │      │        Set        │      │      Queue        │
│   (Interface)     │      │   (Interface)     │      │   (Interface)     │
└─────────┬─────────┘      └─────────┬─────────┘      └─────────┬─────────┘
          │                          │                          │
    ┌─────┼─────┐              ┌─────┼─────┐              ┌─────┼─────┐
    │     │     │              │     │     │              │     │     │
    ▼     ▼     ▼              ▼     ▼     ▼              ▼     ▼     ▼
ArrayList  │  LinkedList   HashSet  │  TreeSet     LinkedList  PriorityQueue
        Vector                LinkedHashSet


                            ┌───────────────────┐
                            │       Map         │ (Interface - NOT Collection!)
                            └─────────┬─────────┘
                                      │
          ┌───────────────────────────┼───────────────────────────┐
          │                           │                           │
┌─────────▼─────────┐      ┌─────────▼─────────┐      ┌─────────▼─────────┐
│     HashMap       │      │     TreeMap       │      │    Hashtable      │
│   (Class)         │      │     (Class)       │      │    (Legacy)       │
└───────────────────┘      └───────────────────┘      └───────────────────┘
```

---

## 🤔 Why Collection API?

### Problems with Arrays

Arrays in Java have several limitations:

```java
// ARRAY LIMITATIONS:
// ==================

int[] arr = new int[5];  // Fixed size of 5

// Problem 1: Fixed Size
// Cannot add 6th element - ArrayIndexOutOfBoundsException!

// Problem 2: No ready-made algorithms
// Must write own code for sorting, searching, etc.

// Problem 3: Not dynamic
// Cannot grow or shrink automatically
```

### Collection API Benefits

The Collection API provides:

| Feature | Description |
|---------|-------------|
| **Containers (Dynamic)** | Collections grow/shrink automatically |
| **Sorted Collections** | TreeSet, TreeMap maintain sorted order |
| **Unique Elements** | Set implementations prevent duplicates |
| **Thread-Safety** | Vector, Hashtable, ConcurrentHashMap are thread-safe |
| **Key-Value Storage** | Map implementations store key-value pairs |
| **Serializable** | All collections implement Serializable for easy persistence |
| **Iterators** | Easy traversal through any collection |
| **Algorithms** | Built-in sort, search, min, max, shuffle, etc. |

---

## 📋 List Interface and Implementations

### List Characteristics
- **Index-based** access (like arrays)
- **Duplicates allowed**
- **Maintains insertion order**

### List Implementations Comparison

| Class | Performance | Thread-Safe | Special Features |
|-------|-------------|-------------|------------------|
| **ArrayList** | Fast random access | ❌ No | Best for traversal, index-based access |
| **Vector** | Slower | ✅ Yes | Legacy class, synchronized |
| **LinkedList** | Fast insert/delete | ❌ No | Doubly linked list, implements Deque |
| **CopyOnWriteArrayList** | Read-fast, Write-slow | ✅ Yes | Fail-safe iterator |

---

### ArrayList Demo

```java
// FILE: ArrayListDemo.java
// =========================

import java.util.*;                    // Line 1: Import all utilities
import static java.lang.System.*;      // Line 2: Static import for System.out

public class ArrayListDemo {
    public static void main(String args[]) {
        
        // Line 3: Create ArrayList with generic type <String>
        // Using List interface as reference (polymorphism)
        List<String> a1 = new ArrayList<String>();
        
        // Line 4: Initial size is 0 (no elements yet)
        out.println("Initial size of a1: " + a1.size());  // Output: 0
        
        // Lines 5-10: Adding elements
        a1.add("c");      // Index 0: adds "c"
        a1.add("a");      // Index 1: adds "a"
        a1.add("e");      // Index 2: adds "e"
        a1.add("b");      // Index 3: adds "b"
        a1.add("d");      // Index 4: adds "d"
        a1.add("f");      // Index 5: adds "f"
        
        // Line 11: Add at specific index
        // Shifts existing elements to the right
        a1.add(1, "a2");  // Insert "a2" at index 1
        // New order: [c, a2, a, e, b, d, f]
        
        out.println("After adding size of a1: " + a1.size());  // Output: 7
        out.println("Contents of a1: " + a1);
        // Output: [c, a2, a, e, b, d, f]
        
        // Lines 12-13: Removing elements
        a1.remove("f");   // Remove by object - removes "f"
        a1.remove(2);     // Remove by index - removes element at index 2 ("a")
        
        out.println("After removing size of a1: " + a1.size());  // Output: 5
        out.println("Contents of a1: " + a1);
        // Output: [c, a2, e, b, d]
    }
}
```

**Flow Diagram:**
```
Initial State:       After add():         After add(1,"a2"):    After remove():
┌────────────┐       ┌────────────┐       ┌────────────┐       ┌────────────┐
│   (empty)  │  →    │ 0: "c"     │  →    │ 0: "c"     │  →    │ 0: "c"     │
└────────────┘       │ 1: "a"     │       │ 1: "a2"    │       │ 1: "a2"    │
size: 0              │ 2: "e"     │       │ 2: "a"     │       │ 2: "e"     │
                     │ 3: "b"     │       │ 3: "e"     │       │ 3: "b"     │
                     │ 4: "d"     │       │ 4: "b"     │       │ 4: "d"     │
                     │ 5: "f"     │       │ 5: "d"     │       └────────────┘
                     └────────────┘       │ 6: "f"     │       size: 5
                     size: 6              └────────────┘
                                          size: 7
```

---

### ArrayList with Integer - Remove Gotcha!

```java
// FILE: ArrayListDemo1.java - IMPORTANT remove() behavior!
// =========================================================

import java.util.*;
import static java.lang.System.*;

public class ArrayListDemo1 {
    public static void main(String args[]) {
        
        // Line 1: Create ArrayList of Integer
        List<Integer> a1 = new ArrayList<Integer>();
        
        out.println("Initial size of a1: " + a1.size());  // Output: 0
        
        // Lines 2-6: Add some integers
        a1.add(5);     // Index 0
        a1.add(10);    // Index 1
        a1.add(15);    // Index 2
        a1.add(20);    // Index 3
        a1.add(30);    // Index 4
        
        out.println("After adding size: " + a1.size());  // Output: 5
        out.println("Contents of a1: " + a1);            // [5, 10, 15, 20, 30]
        
        // ⚠️ TRICKY PART - remove() with Integer!
        // ========================================
        
        // Line 7: a1.remove(2) - Removes element at INDEX 2 (which is 15)!
        // NOT the element equal to 2!
        // a1.remove(2);  // Would remove 15, not 2
        
        // Line 8: To remove element with value 2, use Integer object:
        a1.remove(new Integer(2));  // Tries to remove element "2"
        // Since 2 is not in list, nothing is removed!
        
        out.println("After removing size: " + a1.size());  // Output: 5 (no change)
        out.println("Contents of a1: " + a1);              // [5, 10, 15, 20, 30]
    }
}
```

> [!CAUTION]
> When using `remove()` with Integer ArrayList:
> - `list.remove(2)` → Removes element at **index** 2
> - `list.remove(new Integer(2))` → Removes element with **value** 2

---

### LinkedList Demo

```java
// FILE: LinkedListDemo.java
// =========================

import java.util.*;
import static java.lang.System.*;

public class LinkedListDemo {
    public static void main(String args[]) {
        
        // Line 1: Create LinkedList (also implements Deque)
        List<String> l = new LinkedList<String>();
        
        // Lines 2-6: Add elements
        l.add("f");   // [f]
        l.add("b");   // [f, b]
        l.add("d");   // [f, b, d]
        l.add("e");   // [f, b, d, e]
        l.add("c");   // [f, b, d, e, c]
        
        // Line 7: LinkedList-specific methods (need casting)
        // addLast() - adds at the end
        ((LinkedList) l).addLast("z");    // [f, b, d, e, c, z]
        
        // Line 8: addFirst() - adds at the beginning
        ((LinkedList) l).addFirst("a");   // [a, f, b, d, e, c, z]
        
        // Line 9: add at specific index
        l.add(1, "a2");                    // [a, a2, f, b, d, e, c, z]
        
        out.println("Original contents: " + l);
        // Output: [a, a2, f, b, d, e, c, z]
        
        // Lines 10-11: Remove elements
        l.remove("f");    // Remove by object: [a, a2, b, d, e, c, z]
        l.remove(2);      // Remove at index 2: [a, a2, d, e, c, z]
        
        out.println("After deletion: " + l);
        // Output: [a, a2, d, e, c, z]
        
        // Lines 12-13: LinkedList specific remove methods
        ((LinkedList) l).removeFirst();   // [a2, d, e, c, z]
        ((LinkedList) l).removeLast();    // [a2, d, e, c]
        
        out.println("After deleting first and last: " + l);
        // Output: [a2, d, e, c]
        
        // Line 14: Get element at index
        Object val = l.get(2);  // Gets "e"
        out.println("l after change is: " + l);
    }
}
```

**LinkedList Structure:**
```
┌──────────────────────────────────────────────────────────────────┐
│ LinkedList (Doubly Linked List)                                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ┌───┐    ┌───┐    ┌───┐    ┌───┐    ┌───┐                     │
│   │ a │◄──►│a2 │◄──►│ d │◄──►│ e │◄──►│ c │                     │
│   └───┘    └───┘    └───┘    └───┘    └───┘                     │
│     ▲                                   ▲                        │
│   first                               last                       │
│                                                                   │
│ Operations:                                                       │
│ • addFirst() - O(1)                                              │
│ • addLast()  - O(1)                                              │
│ • get(index) - O(n) - must traverse                              │
│ • add(middle) - O(1) once position found                         │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Set Interface and Implementations

### Set Characteristics
- **No duplicates** allowed
- May or may not maintain order
- No index-based access

### Set Implementations Comparison

| Class | Ordering | Performance | Null Values |
|-------|----------|-------------|-------------|
| **HashSet** | No order guaranteed | O(1) for add/remove/contains | Allows 1 null |
| **LinkedHashSet** | Insertion order | O(1) | Allows 1 null |
| **TreeSet** | Sorted order | O(log n) | No nulls |

---

### HashSet Demo

```java
// FILE: HashSetDemo.java
// =======================

import java.util.*;
import static java.lang.System.*;

public class HashSetDemo {
    public static void main(String args[]) {
        
        // Line 1: Create HashSet of String
        HashSet<String> hs = new HashSet<String>();
        
        // Lines 2-7: Add elements
        // HashSet does NOT maintain insertion order
        hs.add("b");
        hs.add("c");
        hs.add("d");
        hs.add("e");
        hs.add("f");
        hs.add("g");
        
        // Line 8: Trying to add duplicate - returns false, no change
        hs.add("b");  // Duplicate - ignored!
        
        out.println("Contents of hs: " + hs);
        // Output: Order NOT guaranteed! Could be: [b, c, d, e, f, g]
        // But might print in different order
    }
}
```

### TreeSet Demo

```java
// FILE: TreeSetDemo.java
// =======================

import java.util.*;
import static java.lang.System.*;

public class TreeSetDemo {
    public static void main(String args[]) {
        
        // Line 1: Create TreeSet of String
        // TreeSet maintains SORTED order
        TreeSet<String> t = new TreeSet<String>();
        
        // Lines 2-6: Add elements in random order
        t.add("e");
        t.add("b");
        t.add("d");
        t.add("c");
        t.add("a");
        
        out.println("Contents are: " + t);
        // Output: [a, b, c, d, e] - ALWAYS sorted!
    }
}
```

> [!WARNING]
> **TreeSet and TreeMap** require elements to be **Comparable** or you must provide a **Comparator**. They also don't allow null values!

---

## 🔄 Iterator Interface

### What is Iterator?

Iterator provides a way to traverse through a collection without exposing its underlying structure.

```java
// ITERATOR METHODS:
// ================
// hasNext() - Returns true if more elements exist
// next()    - Returns current element and moves pointer forward
// remove()  - Removes last element returned by next()
```

### Iterator Demo

```java
// FILE: IteratorDemo.java
// ========================

import java.util.*;

public class IteratorDemo {
    public static void main(String args[]) {
        
        // Line 1: Create and populate ArrayList
        List<String> mylist = new ArrayList<String>();
        mylist.add("hello");
        mylist.add("welcome");
        mylist.add("all the best");
        
        // Line 2: Create iterator
        // iterator() method returns an Iterator object
        // The actual class is a private inner class of ArrayList
        Iterator itr = mylist.iterator();
        
        // Line 3: Print actual class name of iterator
        System.out.println(itr.getClass().getName());
        // Output: java.util.ArrayList$Itr (private inner class)
        
        // Line 4-7: Traverse using while loop
        while (itr.hasNext()) {           // Check if elements remain
            System.out.println(itr.next()); // Get current and move forward
        }
        // Output:
        // hello
        // welcome
        // all the best
    }
}

/*
 * hasNext() method checks whether there are elements 
 * inside list for traversal. Returns true or false.
 * 
 * next() method returns the current element and places 
 * the record pointer on the next element.
 */
```

**Iterator Flow:**
```
┌────────────────────────────────────────────────────────────────────┐
│ ArrayList: ["hello", "welcome", "all the best"]                     │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│ Initial State:     After 1st next():   After 2nd next():          │
│        ▼                    ▼                   ▼                  │
│   ┌─────────┐         ┌─────────┐         ┌─────────┐             │
│   │  hello  │         │  hello  │         │  hello  │             │
│   ├─────────┤         ├─────────┤         ├─────────┤             │
│   │ welcome │         │ welcome │         │ welcome │             │
│   ├─────────┤         ├─────────┤         ├─────────┤             │
│   │all best │         │all best │         │all best │             │
│   └─────────┘         └─────────┘         └─────────┘             │
│        ↑                    ↑                   ↑                  │
│    Pointer at           Pointer at          Pointer at            │
│    index 0              index 1             index 2               │
│                                                                     │
│ hasNext():true      hasNext():true      hasNext():true            │
│ next(): "hello"     next(): "welcome"   next(): "all the best"    │
│                                                                     │
│ After 3rd next(): hasNext():false (END)                            │
└────────────────────────────────────────────────────────────────────┘
```

### Using Generic Iterator (Type-Safe)

```java
// FILE: IteratorDemo2.java - Generic Iterator
// ============================================

import java.util.*;

public class IteratorDemo2 {
    public static void main(String args[]) {
        
        // Create typed ArrayList
        List<String> mylist = new ArrayList<String>();
        mylist.add("hello");
        mylist.add("welcome");
        mylist.add("all the best");
        
        // Line 1: Create GENERIC iterator
        // <String> means next() returns String directly
        Iterator<String> itr = mylist.iterator();
        
        while (itr.hasNext()) {
            // Line 2: NO casting required!
            String temp = itr.next();  // Directly returns String
            System.out.println(temp);
        }
    }
}
```

---

## 🛠️ Collections Utility Class

### Why Collections Class Exists?

```java
/*
 * STORY OF COLLECTIONS CLASS:
 * ==========================
 * 
 * When Java founders were thinking of providing algorithms, they realized 
 * that algorithms cannot be instance methods as they are just utility methods.
 * 
 * They decided to use static methods. But the problem was:
 * - Collection API hierarchy has all INTERFACES at the top
 * - Static methods were NOT allowed in interfaces (before Java 8)
 * 
 * Solution: Create a separate class "Collections" with all static methods!
 */
```

### Common Collections Methods

| Method | Description |
|--------|-------------|
| `sort(List)` | Sorts in natural order |
| `sort(List, Comparator)` | Sorts using custom comparator |
| `reverse(List)` | Reverses element order |
| `shuffle(List)` | Randomly shuffles elements |
| `min(Collection)` | Returns minimum element |
| `max(Collection)` | Returns maximum element |
| `binarySearch(List, key)` | Binary search (list must be sorted) |
| `synchronizedList(List)` | Returns thread-safe list |
| `synchronizedMap(Map)` | Returns thread-safe map |

---

### Algorithms Demo

```java
// FILE: AlgorithmsDemo.java
// =========================

import java.util.*;
import static java.lang.System.*;

public class AlgorithmsDemo {
    public static void main(String args[]) {
        
        // Line 1: Create LinkedList of Integer
        LinkedList<Integer> l = new LinkedList<Integer>();
        
        // Lines 2-5: Add elements
        l.add(-8);
        l.add(20);
        l.add(-20);
        l.add(8);
        // List: [-8, 20, -20, 8]
        
        // Line 6: Create reverse order comparator
        // reverseOrder() returns a Comparator for descending order
        Comparator<Integer> c = Collections.reverseOrder();
        
        // Line 7: Sort using the comparator (descending order)
        Collections.sort(l, c);
        
        // Line 8: Display using iterator
        Iterator<Integer> itr = l.iterator();
        System.out.println("List sorted in reverse:");
        while (itr.hasNext()) {
            System.out.print(itr.next() + " ");
        }
        System.out.println();
        // Output: 20 8 -8 -20
        
        // Line 9: Shuffle the list randomly
        Collections.shuffle(l);
        itr = l.iterator();
        while (itr.hasNext()) {
            System.out.print(itr.next() + " ");
        }
        System.out.println();
        // Output: Random order each time!
        
        // Line 10: Shuffle again
        Collections.shuffle(l);
        itr = l.iterator();
        while (itr.hasNext()) {
            System.out.print(itr.next() + " ");
        }
        System.out.println();
        // Output: Different random order!
        
        // Lines 11-12: Min and Max
        System.out.println("Minimum: " + Collections.min(l));  // Output: -20
        System.out.println("Maximum: " + Collections.max(l));  // Output: 20
        
        // Lines 13-18: Sorting without comparator (natural order)
        System.out.println("\nNow without Comparator:");
        LinkedList<Integer> l1 = new LinkedList<Integer>();
        l1.add(-8);
        l1.add(20);
        l1.add(-20);
        l1.add(8);
        
        // Natural order sorting (ascending)
        Collections.sort(l1);
        
        Iterator<Integer> itr1 = l1.iterator();
        System.out.println("List sorted:");
        while (itr1.hasNext()) {
            System.out.print(itr1.next() + " ");
        }
        // Output: -20 -8 8 20
    }
}
```

---

## 🔒 Converting to Thread-Safe Collections

```java
// FILE: Thread Safety Conversion
// ==============================

import java.util.*;

public class ThreadSafeDemo {
    public static void main(String args[]) {
        
        // LISTS:
        // ======
        
        // Non-thread-safe list
        List<String> mylist = new ArrayList<String>();
        
        // Convert to thread-safe
        List<String> mylist1 = Collections.synchronizedList(mylist);
        // mylist1 is now thread-safe!
        
        
        // MAPS:
        // =====
        
        // Non-thread-safe map
        Map<String, Integer> mymap = new HashMap<String, Integer>();
        
        // Convert to thread-safe
        Map<String, Integer> mymap1 = Collections.synchronizedMap(mymap);
        // mymap1 is now thread-safe!
        
        
        // SETS:
        // =====
        
        // Non-thread-safe set
        Set<String> myset = new HashSet<String>();
        
        // Convert to thread-safe
        Set<String> myset1 = Collections.synchronizedSet(myset);
        // myset1 is now thread-safe!
    }
}
```

---

## 🗃️ Collections Store References (Important Concept!)

### Demo 1: Collections Store References

```java
// FILE: Demo1.java - References in Collections
// =============================================

import java.util.*;

class myclass {
    int num;
    
    myclass(int num) {
        this.num = num;
    }
}

public class Demo1 {
    public static void main(String args[]) {
        
        // Create HashMap
        Map<String, myclass> h = new HashMap<String, myclass>();
        
        // Create object with num = 100
        myclass m1 = new myclass(100);
        System.out.println(m1.num);  // Output: 100
        
        // Put in map - stores REFERENCE to m1
        h.put("first", m1);
        
        // Modify the ORIGINAL object
        m1.num = 200;
        System.out.println(m1.num);  // Output: 200
        
        // Retrieve from map
        myclass ref = h.get("first");
        System.out.println(ref.num);  // Output: 200 (SAME object!)
    }
}
```

**Memory Diagram:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ HEAP MEMORY                                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌──────────────┐                    ┌──────────────┐              │
│   │   HashMap h  │                    │ myclass obj  │              │
│   ├──────────────┤                    ├──────────────┤              │
│   │ "first" ─────┼────────────────────►│  num: 200   │              │
│   └──────────────┘                    └──────────────┘              │
│                                              ▲                       │
│   STACK:                                     │                       │
│   ┌────────┐                                 │                       │
│   │   m1 ──┼─────────────────────────────────┘                       │
│   └────────┘                                                         │
│   ┌────────┐                                                         │
│   │  ref ──┼─────────────────────────────────►(same object)         │
│   └────────┘                                                         │
│                                                                      │
│ m1, h.get("first"), and ref ALL point to the SAME object!          │
│ When m1.num changes to 200, ALL references see 200                  │
└─────────────────────────────────────────────────────────────────────┘
```

### Demo 2: Serialization Creates Copies

```java
// FILE: Demo2.java - Serialization Creates Deep Copy
// ===================================================

import java.util.*;
import java.io.*;

class myclass implements Serializable {
    int num;
    
    myclass(int num) {
        this.num = num;
    }
}

public class Demo2 {
    public static void main(String args[]) {
        try {
            Map<String, myclass> h = new HashMap<String, myclass>();
            
            // Create streams for serialization
            FileOutputStream fos = new FileOutputStream("my.txt");
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            
            // Create object with num = 100
            myclass m1 = new myclass(100);
            System.out.println(m1.num);  // Output: 100
            
            // Put in map
            h.put("first", m1);
            
            // SERIALIZE (write) to file - creates COPY
            oos.writeObject(h);
            oos.close();
            fos.close();
            
            // Now modify original object
            m1.num = 300;
            System.out.println(m1.num);  // Output: 300
            
            // DESERIALIZE (read) from file
            FileInputStream fis = new FileInputStream("my.txt");
            ObjectInputStream ois = new ObjectInputStream(fis);
            
            Map<String, myclass> map = (HashMap<String, myclass>) ois.readObject();
            
            myclass ref = map.get("first");
            System.out.println(ref.num);  // Output: 100 (NOT 300!)
            // Serialization captured the state at time of writing (100)
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

> [!TIP]
> **Key Insight:** Collections store references, not copies. But serialization creates a deep copy at the time of writing.

---

## 📝 Interview Questions

### Q1: What is the difference between Collection and Collections?
**Answer:**
- `Collection` is an **interface** - the root of collection hierarchy
- `Collections` is a **utility class** with static methods for algorithms

### Q2: ArrayList vs LinkedList?
**Answer:**
| Feature | ArrayList | LinkedList |
|---------|-----------|------------|
| Storage | Dynamic array | Doubly linked list |
| Random access | O(1) - Fast | O(n) - Slow |
| Insert/Delete middle | O(n) - Slow | O(1) - Fast (once found) |
| Memory | Less overhead | More overhead (pointers) |

### Q3: HashSet vs TreeSet?
**Answer:**
| Feature | HashSet | TreeSet |
|---------|---------|---------|
| Order | No order | Sorted order |
| Performance | O(1) | O(log n) |
| Null values | Allows 1 null | No nulls allowed |
| Implementation | Hash table | Red-Black tree |

### Q4: How to make ArrayList thread-safe?
**Answer:**
```java
List<String> list = new ArrayList<String>();
List<String> syncList = Collections.synchronizedList(list);
```

### Q5: What happens if we add duplicate to Set?
**Answer:** The `add()` method returns `false` and the set remains unchanged. Duplicates are simply ignored.

### Q6: Can we store null in TreeSet?
**Answer:** No, TreeSet doesn't allow null values because it needs to compare elements for sorting (will throw NullPointerException).

---

> [!TIP]
> Always use the interface as the reference type: `List<String> list = new ArrayList<>();` This allows easy switching of implementations!

