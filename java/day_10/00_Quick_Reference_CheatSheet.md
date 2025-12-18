# 📋 JavaSE Day 10 - Quick Reference & Cheat Sheet

## 🗂️ Table of Contents Reference

| Topic | File |
|-------|------|
| Generics | `01_Generics_Complete_Guide.md` |
| Collection API (List, Set, Iterator) | `02_Collection_API_Complete_Guide.md` |
| Map (HashMap, TreeMap) | `03_Map_Interface_Complete_Guide.md` |
| Comparable, Comparator, Iterators | `04_Comparable_Comparator_and_Iterators.md` |
| Socket Programming | `05_Socket_Programming_Complete_Guide.md` |
| Interview Questions | `06_Interview_Questions_and_Answers.md` |

---

## 🔷 Generics Quick Reference

### Generic Syntax
```java
// Generic class
class Box<T> { T value; }

// Generic method
<T> void print(T item) { }

// Bounded type
class Box<T extends Number> { }  // T must be Number or subclass

// Multiple bounds
class Box<T extends Number & Serializable> { }
```

### Wildcards Cheat Sheet
```java
<?>              // Unknown type (read-only)
<? extends T>    // T or subtypes (read-only, PRODUCER)
<? super T>      // T or supertypes (can write T, CONSUMER)
```

### PECS Principle
```
Producer Extends, Consumer Super
```
- **Producer** (you read from it): Use `extends`
- **Consumer** (you write to it): Use `super`

---

## 🔷 Collection API Quick Reference

### Collection Hierarchy
```
Iterable
   └── Collection
          ├── List    (index-based, duplicates allowed)
          ├── Set     (unique, no index)
          └── Queue   (FIFO)

Map (separate hierarchy - key-value pairs)
```

### When to Use Which?

| Need | Use |
|------|-----|
| Fast random access | ArrayList |
| Fast insert/delete in middle | LinkedList |
| Unique elements, no order | HashSet |
| Unique elements, sorted | TreeSet |
| Key-value, fast access | HashMap |
| Key-value, sorted keys | TreeMap |
| Thread-safe List | CopyOnWriteArrayList |
| Thread-safe Map | ConcurrentHashMap |

### Time Complexity

| Operation | ArrayList | LinkedList | HashSet/HashMap | TreeSet/TreeMap |
|-----------|-----------|------------|-----------------|-----------------|
| Add | O(1)* | O(1) | O(1) | O(log n) |
| Get by index | O(1) | O(n) | N/A | N/A |
| Contains | O(n) | O(n) | O(1) | O(log n) |
| Remove | O(n) | O(1)** | O(1) | O(log n) |

\* Amortized  
\** If position known

---

## 🔷 Map Quick Reference

### HashMap Defaults
```java
Initial capacity: 16
Load factor: 0.75
Rehash when: 75% full
```

### Map Common Operations
```java
map.put(key, value);           // Add/update
map.get(key);                  // Get value
map.remove(key);               // Remove
map.containsKey(key);          // Check key
map.containsValue(value);      // Check value
map.keySet();                  // All keys
map.values();                  // All values
map.entrySet();                // All entries
```

### Traversing Map
```java
// Method 1: entrySet
for (Map.Entry<K, V> entry : map.entrySet()) {
    entry.getKey();
    entry.getValue();
}

// Method 2: forEach (Java 8+)
map.forEach((k, v) -> System.out.println(k + "=" + v));
```

---

## 🔷 Comparable vs Comparator

| Aspect | Comparable | Comparator |
|--------|------------|------------|
| Package | java.lang | java.util |
| Method | compareTo(T o) | compare(T o1, T o2) |
| Args | 1 (compare with this) | 2 (compare two objects) |
| Placement | Inside class | Separate class |
| Strategies | Single (natural) | Multiple |

### Quick Implementation
```java
// Comparable
class Employee implements Comparable<Employee> {
    public int compareTo(Employee e) {
        return this.age - e.age;  // Sort by age
    }
}

// Comparator
class SortByName implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        return e1.name.compareTo(e2.name);
    }
}
```

---

## 🔷 Iterator Quick Reference

### Fail-Fast vs Fail-Safe

| Feature | Fail-Fast | Fail-Safe |
|---------|-----------|-----------|
| Collections | ArrayList, HashMap | CopyOnWriteArrayList, ConcurrentHashMap |
| Modification | ❌ Exception | ✅ Allowed |
| Memory | Less | More (copies) |
| itr.remove() | ✅ Supported | ❌ Not supported |

### Safe Removal While Iterating
```java
// Use Iterator's remove()
Iterator<String> itr = list.iterator();
while (itr.hasNext()) {
    if (condition) itr.remove();  // Safe!
}

// Java 8+
list.removeIf(item -> condition);
```

---

## 🔷 Thread-Safe Collections

### Converting to Thread-Safe
```java
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
Map<K, V> syncMap = Collections.synchronizedMap(new HashMap<>());
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
```

### Built-in Thread-Safe
```java
CopyOnWriteArrayList<T>    // Read-heavy scenarios
ConcurrentHashMap<K, V>    // High concurrency
Vector<T>                   // Legacy, avoid
Hashtable<K, V>             // Legacy, avoid
```

---

## 🔷 Socket Programming Quick Reference

### TCP Classes
```java
// Server
ServerSocket server = new ServerSocket(port);
Socket client = server.accept();  // Blocks until connect

// Client
Socket socket = new Socket(host, port);

// Streams
InputStream in = socket.getInputStream();
OutputStream out = socket.getOutputStream();
```

### UDP Classes
```java
// Server
DatagramSocket socket = new DatagramSocket(port);
DatagramPacket packet = new DatagramPacket(buffer, length);
socket.receive(packet);  // Blocks

// Client
DatagramPacket packet = new DatagramPacket(data, length, address, port);
DatagramSocket socket = new DatagramSocket();
socket.send(packet);
```

### Port Ranges
```
1-1023:      System reserved
1024-65535:  User applications
```

---

## 🔷 Common Mistakes & Solutions

| Mistake | Solution |
|---------|----------|
| Raw types | Always use generics: `List<String>` not `List` |
| Modifying list during foreach | Use Iterator or CopyOnWriteArrayList |
| Not overriding hashCode | Always override hashCode with equals |
| Using == for object comparison | Use equals() method |
| Forgetting Serializable | Implement Serializable for network/file storage |

---

## 🔷 Code Snippets

### Create Collections (Java 9+)
```java
List<String> list = List.of("a", "b", "c");  // Immutable
Set<String> set = Set.of("a", "b", "c");     // Immutable
Map<String, Integer> map = Map.of("a", 1, "b", 2);
```

### Sort Collections
```java
Collections.sort(list);                      // Natural order
Collections.sort(list, comparator);          // Custom order
Collections.sort(list, Collections.reverseOrder());  // Reverse
list.sort(Comparator.comparing(Emp::getName));  // Java 8
```

### Convert Between Collections
```java
// List to Set (remove duplicates)
Set<String> set = new HashSet<>(list);

// Set to List
List<String> list = new ArrayList<>(set);

// Array to List
List<String> list = Arrays.asList(array);
List<String> list = new ArrayList<>(Arrays.asList(array));  // Modifiable

// List to Array
String[] array = list.toArray(new String[0]);
```

---

## 🔷 Important Method Signatures

### Collection Methods
```java
boolean add(E e)
boolean remove(Object o)
boolean contains(Object o)
int size()
boolean isEmpty()
void clear()
Iterator<E> iterator()
```

### List Additional Methods
```java
E get(int index)
E set(int index, E element)
void add(int index, E element)
E remove(int index)
int indexOf(Object o)
```

### Map Methods
```java
V put(K key, V value)
V get(Object key)
V remove(Object key)
boolean containsKey(Object key)
boolean containsValue(Object value)
Set<K> keySet()
Collection<V> values()
Set<Map.Entry<K,V>> entrySet()
```

---

## 🔷 Quick Decision Tree

```
Need to store elements?
├── With duplicates?
│   ├── Yes → List
│   │   ├── Fast access by index? → ArrayList
│   │   └── Fast insert/delete? → LinkedList
│   └── No → Set
│       ├── Need sorted? → TreeSet
│       └── Don't need order? → HashSet
│
└── As key-value pairs? → Map
    ├── Need sorted keys? → TreeMap
    ├── Need thread-safe? → ConcurrentHashMap
    └── Single thread? → HashMap
```

---

> [!TIP]
> **Quick Memory Tips:**
> - **ArrayList**: Array that can grow
> - **LinkedList**: Chain of nodes
> - **HashSet**: Like HashMap with keys only
> - **TreeSet**: Sorted Set using tree
> - **HashMap**: Fast key-value storage
> - **TreeMap**: Sorted key-value storage

