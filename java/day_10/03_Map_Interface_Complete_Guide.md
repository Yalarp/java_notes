# 📚 Java Map Interface - Complete Guide (HashMap, TreeMap, Hashtable)

## Table of Contents
1. [Introduction to Map](#introduction-to-map)
2. [Map Hierarchy](#map-hierarchy)
3. [HashMap Deep Dive](#hashmap-deep-dive)
4. [How HashMap Works Internally](#how-hashmap-works-internally)
5. [TreeMap Deep Dive](#treemap-deep-dive)
6. [Hashtable](#hashtable)
7. [ConcurrentHashMap](#concurrenthashmap)
8. [Traversing Maps](#traversing-maps)
9. [equals() and hashCode() Contract](#equals-and-hashcode-contract)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction to Map

**Map** is an interface that represents a collection of key-value pairs. Unlike other collections, Map is **NOT** part of the Collection interface hierarchy but is part of the Collection Framework.

### Map Characteristics
- Stores elements as **key-value pairs**
- **Keys must be unique** (no duplicate keys)
- Each key maps to exactly one value
- **put()** using key and value
- **get()** using only key

```java
// Basic Map usage
Map<Integer, String> mymap = new HashMap<Integer, String>();

mymap.put(100, "hello");     // Put with key 100
mymap.put(200, "welcome");   // Put with key 200

System.out.println(mymap.get(200));  // Get using key: "welcome"
```

---

## 📊 Map Hierarchy

```
                            ┌───────────────────┐
                            │       Map         │ (Interface)
                            └─────────┬─────────┘
                                      │
          ┌───────────────────────────┼───────────────────────────┐
          │                           │                           │
┌─────────▼─────────┐      ┌─────────▼─────────┐      ┌─────────▼─────────┐
│    AbstractMap    │      │    SortedMap      │      │   Dictionary      │
│   (Abstract)      │      │   (Interface)     │      │   (Legacy)        │
└─────────┬─────────┘      └─────────┬─────────┘      └─────────┬─────────┘
          │                          │                          │
    ┌─────┼─────┐               ┌────▼────┐               ┌────▼────┐
    │     │     │               │ TreeMap │               │Hashtable│
    ▼     ▼     ▼               └─────────┘               └─────────┘
HashMap  │  LinkedHashMap
         │
ConcurrentHashMap
```

### Map Implementations Comparison

| Class | Order | Thread-Safe | Null Keys | Null Values | Performance |
|-------|-------|-------------|-----------|-------------|-------------|
| **HashMap** | No order | ❌ No | ✅ 1 null | ✅ Multiple | Fastest |
| **LinkedHashMap** | Insertion order | ❌ No | ✅ 1 null | ✅ Multiple | Fast |
| **TreeMap** | Sorted by keys | ❌ No | ❌ No | ✅ Multiple | O(log n) |
| **Hashtable** | No order | ✅ Yes | ❌ No | ❌ No | Slower |
| **ConcurrentHashMap** | No order | ✅ Yes | ❌ No | ❌ No | Fast |

---

## 🗃️ HashMap Deep Dive

### HashMap Basics

```java
// FILE: HashMapDemo.java
// =======================

package datatypes_pro;

import java.util.*;
import java.util.Map.Entry;

public class HashMapDemo {
    public static void main(String args[]) {
        
        // Line 1: Create HashMap with String keys and Double values
        Map<String, Double> h = new HashMap<String, Double>();
        
        // Lines 2-5: Put key-value pairs
        h.put("john", 3434.34);   // Key: "john", Value: 3434.34
        h.put("tom", 123.12);     // Key: "tom", Value: 123.12
        h.put("jane", 1378.00);   // Key: "jane", Value: 1378.00
        h.put("todd", 99.22);     // Key: "todd", Value: 99.22
        
        // Line 6: Get a Set of entries (key-value pairs)
        // entrySet() returns Set<Map.Entry<String, Double>>
        Set<Entry<String, Double>> set = h.entrySet();
        
        // Line 7: Get iterator for the entry set
        Iterator<Entry<String, Double>> i = set.iterator();
        
        // Lines 8-12: Display all entries
        while (i.hasNext()) {
            // Each Entry contains getKey() and getValue() methods
            Map.Entry<String, Double> me = (Entry<String, Double>) i.next();
            System.out.print(me.getKey() + ": ");    // Print key
            System.out.println(me.getValue());        // Print value
        }
        // Output (order not guaranteed):
        // john: 3434.34
        // todd: 99.22
        // jane: 1378.0
        // tom: 123.12
        
        System.out.println();
        
        // Lines 13-15: Modify a value (deposit $1000 in john's account)
        double balance = h.get("john");     // Get current value: 3434.34
        h.put("john", balance + 1000);      // Put new value: 4434.34
        System.out.println("john's new balance: " + h.get("john"));
        // Output: john's new balance: 4434.34
    }
}
```

### HashMap Default Values

```
┌─────────────────────────────────────────────────────────────────────┐
│ HashMap Default Configuration                                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Initial Capacity: 16 buckets                                        │
│ Load Factor: 0.75                                                   │
│                                                                      │
│ What does Load Factor 0.75 mean?                                    │
│ ================================                                    │
│ When 75% of buckets are filled (16 × 0.75 = 12 buckets),           │
│ the capacity will DOUBLE to 32 buckets.                             │
│                                                                      │
│ This is called "rehashing" - all elements are redistributed.        │
│                                                                      │
│ ┌─────────────────────────────────────────────────────────────┐    │
│ │ Buckets [0] [1] [2] [3] [4] [5] [6] [7] [8] [9] [10-15]    │    │
│ │            │   │       │           │   │                    │    │
│ │            e1  e2      e3          e4  e5  ...              │    │
│ │                                                              │    │
│ │ When 12th bucket fills → Capacity doubles to 32             │    │
│ └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## ⚙️ How HashMap Works Internally

### The Hash Function

```java
/*
 * What is a Hash Function?
 * ========================
 * 
 * A hash function maps larger values to smaller values (bucket indices).
 * 
 * Properties:
 * - Should be O(1) for integers or O(len) for strings
 * - Should distribute elements evenly across buckets
 * 
 * Examples:
 * hash(2192354) = 7  (maps to bucket 7)
 * hash("tiger") = 2  (maps to bucket 2)
 */
```

### PUT Operation - Step by Step

```
┌─────────────────────────────────────────────────────────────────────┐
│ HashMap PUT Operation                                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ map.put(key, value)                                                 │
│       │                                                              │
│       ▼                                                              │
│ ┌─────────────────┐                                                 │
│ │ 1. Calculate    │ hashCode() is called on the KEY                │
│ │    hashCode()   │ Determines which BUCKET to use                  │
│ └────────┬────────┘                                                 │
│          │                                                           │
│          ▼                                                           │
│ ┌─────────────────┐                                                 │
│ │ 2. Is bucket    │                                                 │
│ │    empty?       │                                                 │
│ └────────┬────────┘                                                 │
│          │                                                           │
│    ┌─────┴─────┐                                                    │
│    │           │                                                    │
│   YES         NO                                                    │
│    │           │                                                    │
│    ▼           ▼                                                    │
│ ┌──────┐   ┌────────────────────┐                                  │
│ │Store │   │ HASH COLLISION!    │                                  │
│ │entry │   │ Same hashCode()    │                                  │
│ └──────┘   └─────────┬──────────┘                                  │
│                      │                                               │
│                      ▼                                               │
│            ┌─────────────────┐                                      │
│            │ 3. Check ==     │ Are keys same reference?            │
│            │    operator     │                                      │
│            └────────┬────────┘                                      │
│                     │                                                │
│               ┌─────┴─────┐                                         │
│              TRUE       FALSE                                       │
│               │           │                                         │
│               ▼           ▼                                         │
│         ┌───────────┐ ┌─────────────────┐                          │
│         │ OVERWRITE │ │ 4. Check        │                          │
│         │ the value │ │    equals()     │                          │
│         └───────────┘ └────────┬────────┘                          │
│                                │                                    │
│                          ┌─────┴─────┐                              │
│                        TRUE       FALSE                             │
│                          │           │                              │
│                          ▼           ▼                              │
│                    ┌───────────┐ ┌──────────────────┐              │
│                    │ OVERWRITE │ │ Add to linked    │              │
│                    │ the value │ │ list in bucket   │              │
│                    └───────────┘ └──────────────────┘              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### GET Operation - Step by Step

```
┌─────────────────────────────────────────────────────────────────────┐
│ HashMap GET Operation                                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ map.get(key)                                                        │
│       │                                                              │
│       ▼                                                              │
│ ┌─────────────────┐                                                 │
│ │ 1. Calculate    │ hashCode() on the given key                    │
│ │    hashCode()   │ Determines which bucket to SEARCH              │
│ └────────┬────────┘                                                 │
│          │                                                           │
│          ▼                                                           │
│ ┌─────────────────┐                                                 │
│ │ 2. Is bucket    │                                                 │
│ │    empty?       │                                                 │
│ └────────┬────────┘                                                 │
│          │                                                           │
│    ┌─────┴─────┐                                                    │
│   YES         NO                                                    │
│    │           │                                                    │
│    ▼           ▼                                                    │
│ ┌──────┐   ┌─────────────────┐                                     │
│ │Return│   │ 3. Check ==     │ Same reference as stored key?       │
│ │ null │   └────────┬────────┘                                     │
│ └──────┘            │                                               │
│               ┌─────┴─────┐                                         │
│              TRUE       FALSE                                       │
│               │           │                                         │
│               ▼           ▼                                         │
│         ┌───────────┐ ┌─────────────────┐                          │
│         │  Return   │ │ 4. Check        │                          │
│         │ the value │ │    equals()     │                          │
│         └───────────┘ └────────┬────────┘                          │
│                                │                                    │
│                          ┌─────┴─────┐                              │
│                        TRUE       FALSE                             │
│                          │           │                              │
│                          ▼           ▼                              │
│                    ┌───────────┐ ┌──────────────────┐              │
│                    │  Return   │ │ Traverse linked  │              │
│                    │ the value │ │ list, repeat     │              │
│                    └───────────┘ │ == and equals()  │              │
│                                  └──────────────────┘              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### HashMap Demo with Custom Keys (hashCode and equals)

```java
// FILE: HashMapDemo1.java - Custom hashCode() and equals()
// =========================================================

package datatypes_pro;

import java.util.*;

// When using get(), the sequence is: hashCode() → == → equals()
// If == returns false, it checks equals()

class Employee {
    private String empid;
    private int deptcode;
    private int citycode;
    
    // Constructor
    public Employee(String empid, int deptcode, int citycode) {
        this.empid = empid;
        this.deptcode = deptcode;
        this.citycode = citycode;
    }
    
    // Line 1: Override hashCode()
    // Returns deptcode as hash - employees in same dept go to same bucket
    @Override
    public int hashCode() {
        System.out.println("in hashcode");
        return deptcode;  // Hash based on department
    }
    
    // Line 2: Override equals()
    // Employees are "equal" if they have same citycode
    @Override
    public boolean equals(Object ref) {
        boolean flag = citycode == ((Employee) ref).citycode;
        System.out.println("in equals\t" + flag);
        return flag;  // Compare based on city
    }
    
    @Override
    public String toString() {
        return empid + "\t" + deptcode + "\t" + citycode;
    }
}

public class HashMapDemo1 {
    public static void main(String args[]) {
        
        // Create 4 employees
        Employee e1 = new Employee("e001", 1, 10);  // Dept 1, City 10
        Employee e2 = new Employee("e002", 1, 12);  // Dept 1, City 12
        Employee e3 = new Employee("e003", 2, 10);  // Dept 2, City 10
        Employee e4 = new Employee("e004", 1, 13);  // Dept 1, City 13
        
        // Create HashMap with Employee as key
        Map<Employee, String> map = new HashMap<Employee, String>();
        
        // Put operations - watch hashcode and equals calls
        map.put(e1, "first");   // hashCode=1, bucket 1, empty → store
        map.put(e2, "second");  // hashCode=1, collision! ==false, equals(city 12!=10)→new entry
        map.put(e3, "third");   // hashCode=2, bucket 2, empty → store
        map.put(e4, "fourth");  // hashCode=1, collision! ==false, equals(city 13!=10,12)→new entry
        
        System.out.println(map);
        
        // Get operation
        String val = map.get(e2);  // hashCode=1, find bucket 1, check == and equals
        System.out.println(val);   // Output: "second"
    }
}
```

**Output Analysis:**
```
in hashcode                     ← e1 put: calculate hash
in hashcode                     ← e2 put: calculate hash (same as e1!)
in equals   false               ← e2: different citycode, add to bucket
in hashcode                     ← e3 put: calculate hash
in hashcode                     ← e4 put: calculate hash (same as e1!)
in equals   false               ← e4: check against e1
in equals   false               ← e4: check against e2, add to bucket

{e001...=first, e002...=second, e004...=fourth, e003...=third}

in hashcode                     ← e2 get: calculate hash
in equals   false               ← e2 get: check against e1
in equals   true                ← e2 get: found! (equals e2)
second
```

---

## 🌳 TreeMap Deep Dive

### TreeMap Basics

TreeMap stores elements in **sorted order by keys**. Keys must implement `Comparable` OR a `Comparator` must be provided.

```java
// FILE: TreeMapDemo1.java
// ========================

import java.util.Map;
import java.util.TreeMap;

public class TreeMapDemo1 {
    public static void main(String[] args) {
        
        // Create TreeMap with Integer keys
        Map<Integer, String> mymap = new TreeMap<Integer, String>();
        
        // Add in random order
        mymap.put(3, "hello");
        mymap.put(2, "welcome");
        mymap.put(1, "hi");
        mymap.put(2, "good bye");  // Overwrites previous key=2 value
        
        System.out.println(mymap);
        // Output: {1=hi, 2=good bye, 3=hello}
        // Keys automatically sorted: 1, 2, 3
    }
}
```

### TreeMap with Custom Objects - REQUIRES Comparable!

```java
// FILE: TreeMapDemo2.java - This will FAIL!
// ==========================================

import java.util.*;

class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
}

public class TreeMapDemo2 {
    public static void main(String[] args) {
        
        Person p1 = new Person("abc", 20);
        Person p2 = new Person("xyz", 17);
        
        // TreeMap with Person as key
        TreeMap<Person, Integer> ref1 = new TreeMap<Person, Integer>();
        
        ref1.put(p1, 100);  // ❌ ClassCastException!
        ref1.put(p2, 200);
        // Error: Person cannot be cast to java.lang.Comparable
        
        System.out.println(ref1);
    }
}
```

> [!CAUTION]
> TreeMap and TreeSet require keys/elements that implement `Comparable` or you must provide a `Comparator`. Otherwise, you get `ClassCastException`!

### TreeMap with Comparable Interface

```java
// FILE: TreeMapDemo3.java - Using Comparable (Sort by Name)
// ==========================================================

import java.util.*;

// Person implements Comparable<Person>
class Person implements Comparable<Person> {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Define natural ordering - sort by name
    public int compareTo(Person ref) {
        return name.compareTo(ref.name);  // String comparison
    }
    // Returns:
    //   negative if this.name < ref.name
    //   zero     if this.name == ref.name
    //   positive if this.name > ref.name
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
}

public class TreeMapDemo3 {
    public static void main(String[] args) {
        
        Person p1 = new Person("abc", 20);
        Person p2 = new Person("xyz", 17);
        
        TreeMap<Person, Integer> ref1 = new TreeMap<Person, Integer>();
        
        ref1.put(p1, 100);  // ✓ Works now!
        ref1.put(p2, 200);
        
        System.out.println(ref1);
        // Output: {[abc	20]=100, [xyz	17]=200}
        // Sorted by name: abc comes before xyz
    }
}
```

### TreeMap with Comparable - Sort by Age

```java
// FILE: TreeMapDemo4.java - Comparable (Sort by Age)
// ===================================================

import java.util.*;

class Person implements Comparable<Person> {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Sort by age instead of name
    public int compareTo(Person ref) {
        if (age > ref.age) {
            return 1;   // This comes after ref
        } else if (age < ref.age) {
            return -1;  // This comes before ref
        } else {
            return 0;   // Same position (considered equal key!)
        }
    }
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
}

public class TreeMapDemo4 {
    public static void main(String[] args) {
        
        Person p1 = new Person("abc", 20);
        Person p2 = new Person("xyz", 17);
        
        TreeMap<Person, Integer> ref1 = new TreeMap<Person, Integer>();
        
        ref1.put(p1, 100);
        ref1.put(p2, 200);
        
        System.out.println(ref1);
        // Output: {[xyz	17]=200, [abc	20]=100}
        // Sorted by age: 17 comes before 20
    }
}
```

### TreeMap with Comparator - External Sorting

```java
// FILE: TreeMapDemo5.java - Using Comparator (Sort by Name)
// ==========================================================

import java.util.*;

// Person does NOT implement Comparable
class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
    
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
}

// Separate Comparator class for sorting by name
class NameComparator implements Comparator<Person> {
    
    public int compare(Person ref1, Person ref2) {
        // Compare names using String's compareTo
        return ref1.getName().compareTo(ref2.getName());
    }
}

public class TreeMapDemo5 {
    public static void main(String[] args) {
        
        Person p1 = new Person("abc", 20);
        Person p2 = new Person("xyz", 17);
        
        // Pass Comparator to TreeMap constructor
        TreeMap<Person, Integer> ref1 = new TreeMap<Person, Integer>(new NameComparator());
        
        ref1.put(p1, 100);
        ref1.put(p2, 200);
        
        System.out.println(ref1);
        // Output: {[abc	20]=100, [xyz	17]=200}
        // Sorted by name using NameComparator
    }
}
```

### TreeMap with Multiple Comparators

```java
// FILE: TreeMapDemo6.java - Multiple Comparators
// ===============================================

import java.util.*;

class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String toString() {
        return "[" + name + "\t" + age + "]";
    }
    
    public String getName() { return name; }
    public int getAge() { return age; }
}

// Comparator 1: Sort by Name
class NameComparator implements Comparator<Person> {
    public int compare(Person ref1, Person ref2) {
        return ref1.getName().compareTo(ref2.getName());
    }
}

// Comparator 2: Sort by Age
class AgeComparator implements Comparator<Person> {
    public int compare(Person ref1, Person ref2) {
        if (ref1.getAge() > ref2.getAge()) {
            return 1;
        } else if (ref1.getAge() < ref2.getAge()) {
            return -1;
        } else {
            return 0;
        }
    }
}

public class TreeMapDemo6 {
    public static void main(String[] args) {
        
        Person p1 = new Person("abc", 20);
        Person p2 = new Person("xyz", 17);
        
        // Use AgeComparator
        TreeMap<Person, Integer> ref1 = new TreeMap<Person, Integer>(new AgeComparator());
        
        ref1.put(p1, 100);
        ref1.put(p2, 200);
        
        System.out.println(ref1);
        // Output: {[xyz	17]=200, [abc	20]=100}
        // Sorted by age: 17 < 20
        
        // Can easily switch to NameComparator:
        // TreeMap<Person, Integer> ref2 = new TreeMap<>(new NameComparator());
    }
}
```

---

## 🔐 Hashtable

Hashtable is a **legacy class** (from Java 1.0) that is synchronized (thread-safe).

```java
// FILE: HashtableDemo.java
// =========================

import java.util.*;
import static java.lang.System.*;

public class HashtableDemo {
    public static void main(String args[]) {
        
        // Create Hashtable
        Hashtable<String, Float> ht = new Hashtable<String, Float>();
        
        // Add key-value pairs
        ht.put("first", 45.8f);
        ht.put("second", 67.3f);
        
        out.println(ht);  // {second=67.3, first=45.8}
        
        // Method 1: Using Enumeration (legacy way)
        Enumeration<String> e = ht.keys();
        while (e.hasMoreElements()) {
            String s = e.nextElement();
            out.println(s + "\t" + ht.get(s));
        }
        
        // Method 2: Getting values using elements()
        Enumeration<Float> e1 = ht.elements();
        while (e1.hasMoreElements()) {
            out.printf("%f\n", e1.nextElement());
        }
        
        // Method 3: Using keySet() and Iterator (modern way)
        out.println("Displaying keys");
        Set<String> s = ht.keySet();
        Iterator<String> itr = s.iterator();
        while (itr.hasNext()) {
            out.printf("%s\n", itr.next());
        }
        
        // Modifying values
        out.println("Modifying");
        float f = ht.get("second");
        out.println("second's old value is\t" + f);  // 67.3
        ht.put("second", f + 30);
        out.println("second's new value is\t" + ht.get("second"));  // 97.3
    }
}
```

### HashMap vs Hashtable

| Feature | HashMap | Hashtable |
|---------|---------|-----------|
| Thread-Safety | ❌ Not synchronized | ✅ Synchronized |
| Performance | Faster | Slower |
| Null Keys | ✅ Allows 1 null key | ❌ No null keys |
| Null Values | ✅ Allows null values | ❌ No null values |
| Legacy | Modern (Java 1.2) | Legacy (Java 1.0) |
| Preferred | ✅ Yes | ❌ Use ConcurrentHashMap |

---

## 🔄 ConcurrentHashMap

ConcurrentHashMap is a **thread-safe** implementation that allows concurrent read/write operations without locking the entire map.

### Key Differences from Hashtable

| Feature | Hashtable | ConcurrentHashMap |
|---------|-----------|-------------------|
| Locking | Entire table | Segment/bucket level |
| Read Operations | Blocked during write | Not blocked |
| Performance | Poor under concurrency | Excellent |
| Null Keys/Values | Not allowed | Not allowed |

```java
// Basic usage
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
map.put("key1", 100);

// Thread-safe operations
map.putIfAbsent("key2", 200);      // Put only if key doesn't exist
map.replace("key1", 100, 150);      // Replace only if old value matches
```

---

## 🔄 Traversing Maps

### Method 1: Using entrySet() and Iterator

```java
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);

// Get Set of entries
Set<Map.Entry<String, Integer>> entries = map.entrySet();
Iterator<Map.Entry<String, Integer>> itr = entries.iterator();

while (itr.hasNext()) {
    Map.Entry<String, Integer> entry = itr.next();
    System.out.println(entry.getKey() + " = " + entry.getValue());
}
```

### Method 2: Using keySet()

```java
Set<String> keys = map.keySet();
for (String key : keys) {
    System.out.println(key + " = " + map.get(key));
}
```

### Method 3: Using forEach (Java 8+)

```java
map.forEach((key, value) -> {
    System.out.println(key + " = " + value);
});
```

---

## 📝 equals() and hashCode() Contract

### The Contract

1. If `a.equals(b)` is `true`, then `a.hashCode() == b.hashCode()` MUST be `true`
2. If `a.hashCode() == b.hashCode()`, then `a.equals(b)` MAY or MAY NOT be `true`
3. If `a.equals(b)` is `false`, `hashCode()` values MAY or MAY NOT be equal

### Why This Matters

```java
// If you override equals(), you MUST override hashCode()!

class BadKey {
    int id;
    
    // Override equals but NOT hashCode - BAD!
    @Override
    public boolean equals(Object o) {
        return this.id == ((BadKey)o).id;
    }
    // hashCode() uses default (memory address)
}

public class Problem {
    public static void main(String[] args) {
        Map<BadKey, String> map = new HashMap<>();
        
        BadKey key1 = new BadKey(); key1.id = 1;
        map.put(key1, "value");
        
        BadKey key2 = new BadKey(); key2.id = 1;
        // key1.equals(key2) is TRUE
        // But key1.hashCode() != key2.hashCode() (different objects)
        
        String result = map.get(key2);  // Returns NULL!
        // Because different hashCode → different bucket → not found!
    }
}
```

---

## 📝 Interview Questions

### Q1: How does HashMap work internally?
**Answer:** HashMap uses an array of "buckets". When you put a key-value pair:
1. `hashCode()` is called on key to determine bucket index
2. If bucket is empty, entry is stored
3. If bucket has entries (collision), `equals()` is used to find matching key
4. If key found, value is overwritten; otherwise added to bucket's linked list

### Q2: What is hash collision?
**Answer:** When two different keys have the same hashCode(), they go to the same bucket. This is called collision. HashMap handles this by storing multiple entries in a bucket as a linked list (or tree in Java 8+).

### Q3: HashMap vs TreeMap?
**Answer:**
- **HashMap:** O(1) operations, no ordering, allows 1 null key
- **TreeMap:** O(log n) operations, sorted by keys, no null keys

### Q4: When to use ConcurrentHashMap vs Hashtable?
**Answer:** Always prefer ConcurrentHashMap. It provides better concurrency by locking at bucket level rather than entire table, resulting in much better performance under concurrent access.

### Q5: Why are Strings commonly used as HashMap keys?
**Answer:** String is immutable, so its hashCode is cached. Once computed, it won't change, making lookups faster. Also, String correctly implements equals() and hashCode().

### Q6: What happens if we don't override hashCode() when overriding equals()?
**Answer:** The contract is broken. Equal objects might have different hash codes, so they could be placed in different buckets. This causes get() to fail even for equal keys.

---

> [!TIP]
> **Best Practice:** When using custom objects as Map keys, ALWAYS override both `hashCode()` and `equals()` consistently!

