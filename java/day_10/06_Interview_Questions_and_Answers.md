# 📚 JavaSE Day 10 - Comprehensive Interview Questions & Answers

## Table of Contents
1. [Generics Interview Questions](#generics-interview-questions)
2. [Collection API Interview Questions](#collection-api-interview-questions)
3. [Map Interview Questions](#map-interview-questions)
4. [Comparable & Comparator Interview Questions](#comparable--comparator-interview-questions)
5. [Iterator Interview Questions](#iterator-interview-questions)
6. [Socket Programming Interview Questions](#socket-programming-interview-questions)
7. [Scenario-Based Questions](#scenario-based-questions)
8. [Code Output Questions](#code-output-questions)

---

## 🔷 Generics Interview Questions

### Q1: What are Generics in Java? Why were they introduced?
**Answer:** 
Generics were introduced in Java 5 to provide **compile-time type safety**. They allow you to write code that works with different types while catching type errors at compile time rather than runtime.

**Benefits:**
- Compile-time type checking (eliminates ClassCastException)
- No explicit casting needed when retrieving elements
- Code reusability with type safety

**Before Generics:**
```java
List list = new ArrayList();
list.add("Hello");
String s = (String) list.get(0);  // Casting required!
// list.add(100);  // No error! But can cause ClassCastException later
```

**With Generics:**
```java
List<String> list = new ArrayList<String>();
list.add("Hello");
String s = list.get(0);  // No casting!
// list.add(100);  // Compile error! Type safety!
```

---

### Q2: What is Type Erasure?
**Answer:**
Type Erasure is the process where the Java compiler removes all generic type information during compilation. The JVM has no knowledge of generics.

**Example:**
```java
// Source code
public class Box<T> {
    private T value;
}

// After compilation (what JVM sees)
public class Box {
    private Object value;  // T becomes Object
}
```

**Why?** For backward compatibility with pre-Java 5 code.

---

### Q3: Can you use primitives with Generics?
**Answer:**
**No.** Generics only work with reference types (objects). For primitives, use their wrapper classes:

```java
// Wrong
// List<int> list = new ArrayList<int>();  // Compile error!

// Correct
List<Integer> list = new ArrayList<Integer>();
list.add(10);  // Autoboxing converts int to Integer
```

---

### Q4: What is the difference between `<?>` and `<Object>`?
**Answer:**

| Feature | `List<?>` | `List<Object>` |
|---------|-----------|----------------|
| Meaning | Unknown type | Specifically Object type |
| Accepts | Any List type | Only List<Object> |
| Can add? | ❌ No (except null) | ✅ Yes |
| Use case | Read-only operations | When you need to add any object |

```java
// List<?> accepts any List
void process(List<?> list) {
    // list.add("test");  // Error! Can't add
    System.out.println(list);  // Only read
}

// List<Object> only accepts List<Object>
void process(List<Object> list) {
    list.add("test");  // OK! Can add
}
```

---

### Q5: Explain `<? extends T>` vs `<? super T>`
**Answer:**

**`<? extends T>` (Upper Bounded):**
- Accepts T or any SUBTYPE of T
- **READ-ONLY** - Cannot add elements
- Use when you want to READ from the structure

**`<? super T>` (Lower Bounded):**
- Accepts T or any SUPERTYPE of T
- **CAN ADD** elements of type T
- Use when you want to WRITE to the structure

```java
// PECS: Producer Extends, Consumer Super

// Producer - only reads, use extends
void printAnimals(List<? extends Animal> animals) {
    for (Animal a : animals) {
        a.speak();  // Read and use
    }
    // animals.add(new Dog());  // Error! Can't add
}

// Consumer - writes, use super
void addDogs(List<? super Dog> list) {
    list.add(new Dog());  // Can add Dog
    list.add(new Puppy());  // Can add Dog subtypes
    // list.add(new Animal());  // Error! Only Dog or below
}
```

---

### Q6: Why is `List<Dog>` not assignable to `List<Animal>`?
**Answer:**
Because of type safety. If it were allowed:

```java
List<Dog> dogs = new ArrayList<Dog>();
List<Animal> animals = dogs;  // If this were allowed...
animals.add(new Cat());  // Cat would go into Dog list!
Dog d = dogs.get(0);  // ClassCastException! Cat is not Dog
```

Arrays allow this but throw `ArrayStoreException` at runtime. Generics prevent it at compile time (safer!).

---

## 🔷 Collection API Interview Questions

### Q7: What is the difference between Collection and Collections?
**Answer:**

| Aspect | Collection | Collections |
|--------|------------|-------------|
| Type | Interface | Utility class |
| Purpose | Root interface of collection hierarchy | Static methods for algorithms |
| Methods | add(), remove(), size(), etc. | sort(), max(), min(), shuffle(), etc. |

```java
// Collection is an interface
Collection<String> list = new ArrayList<>();

// Collections is a utility class
Collections.sort(list);
Collections.shuffle(list);
String max = Collections.max(list);
```

---

### Q8: ArrayList vs LinkedList - When to use which?
**Answer:**

| Operation | ArrayList | LinkedList |
|-----------|-----------|------------|
| Random access (get) | O(1) ✓ Fast | O(n) ✗ Slow |
| Add at end | O(1) | O(1) |
| Add in middle | O(n) ✗ Slow | O(1) ✓ Fast |
| Remove from middle | O(n) ✗ Slow | O(1) ✓ Fast |
| Memory | Less | More (pointers) |

**Use ArrayList when:**
- Frequent random access needed
- Mostly reading/traversing

**Use LinkedList when:**
- Frequent insert/delete in middle
- Implementing Queue or Deque

---

### Q9: How is ArrayList different from Vector?
**Answer:**

| Feature | ArrayList | Vector |
|---------|-----------|--------|
| Thread-safety | ❌ Not synchronized | ✅ Synchronized |
| Performance | Fast | Slow (due to sync) |
| Legacy | Modern (Java 1.2) | Legacy (Java 1.0) |
| Growth | 50% size increase | 100% size increase |
| Preferred | ✅ Yes | ❌ No (use ArrayList + sync) |

---

### Q10: HashSet vs TreeSet?
**Answer:**

| Feature | HashSet | TreeSet |
|---------|---------|---------|
| Order | No order | Sorted order |
| Performance | O(1) | O(log n) |
| Null values | ✅ Allows 1 null | ❌ No nulls |
| Implementation | Hash table | Red-Black tree |
| Element requirement | hashCode() + equals() | Comparable or Comparator |

---

## 🔷 Map Interview Questions

### Q11: How does HashMap work internally?
**Answer:**
HashMap uses an **array of buckets**. Each bucket can hold multiple entries (in case of collision).

**PUT operation:**
1. Calculate `hashCode()` of key → determines bucket index
2. If bucket empty → store entry
3. If bucket has entries (collision):
   - Check `==` (reference equality)
   - If false, check `equals()`
   - If equal key found → overwrite value
   - If not found → add to linked list (or tree in Java 8)

**GET operation:**
1. Calculate `hashCode()` of key → find bucket
2. Search bucket using `==` then `equals()`
3. Return value if found, null otherwise

---

### Q12: What is hash collision and how is it handled?
**Answer:**
**Hash collision** occurs when two different keys produce the same hash code, mapping to the same bucket.

**Handling:**
- **Before Java 8:** Linked list within bucket
- **Java 8+:** When bucket exceeds 8 entries, converts to Red-Black tree (performance from O(n) to O(log n))

```
Bucket 5:
[Key1, Val1] → [Key2, Val2] → [Key3, Val3]  (Linked List)

If entries > 8:
         [Key2]
        /      \
    [Key1]    [Key3]  (Red-Black Tree)
```

---

### Q13: HashMap vs Hashtable vs ConcurrentHashMap?
**Answer:**

| Feature | HashMap | Hashtable | ConcurrentHashMap |
|---------|---------|-----------|-------------------|
| Thread-safe | ❌ No | ✅ Yes | ✅ Yes |
| Null keys | ✅ 1 null | ❌ No | ❌ No |
| Null values | ✅ Yes | ❌ No | ❌ No |
| Locking | N/A | Whole table | Segment/bucket |
| Performance | Fastest | Slowest | Fast |
| Preferred | Single thread | ❌ No | Multi-thread |

---

### Q14: Why must we override hashCode() when we override equals()?
**Answer:**
Because of the **hash-based contract**:
- If `a.equals(b)` is true → `a.hashCode() == b.hashCode()` MUST be true

If you only override equals():
```java
class Employee {
    int id;
    
    @Override
    public boolean equals(Object o) {
        return this.id == ((Employee)o).id;  // Same ID = equal
    }
    // hashCode() not overridden - uses Object's (memory address)
}

Map<Employee, String> map = new HashMap<>();
Employee e1 = new Employee(1);
map.put(e1, "John");

Employee e2 = new Employee(1);  // Same ID
map.get(e2);  // Returns NULL! Why?
// e1.equals(e2) = true
// e1.hashCode() != e2.hashCode() (different objects!)
// Different hashCode → different bucket → not found!
```

---

### Q15: What is the default capacity and load factor of HashMap?
**Answer:**
- **Initial capacity:** 16 buckets
- **Load factor:** 0.75

When 75% of buckets are filled (12 buckets), capacity doubles to 32. This is called **rehashing** - all elements are redistributed.

Higher load factor = less memory, more collisions
Lower load factor = more memory, fewer collisions

---

## 🔷 Comparable & Comparator Interview Questions

### Q16: When to use Comparable vs Comparator?
**Answer:**

**Use Comparable when:**
- You own the class
- There's ONE natural ordering
- Ordering is intrinsic to the object

**Use Comparator when:**
- You can't modify the class
- Need multiple sorting criteria
- Ordering is external/custom

```java
// Comparable - natural ordering by employee ID
class Employee implements Comparable<Employee> {
    public int compareTo(Employee e) {
        return Integer.compare(this.id, e.id);
    }
}

// Comparator - multiple orderings
class SortByName implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        return e1.name.compareTo(e2.name);
    }
}

class SortBySalary implements Comparator<Employee> {
    public int compare(Employee e1, Employee e2) {
        return Double.compare(e1.salary, e2.salary);
    }
}
```

---

### Q17: What does compareTo() return?
**Answer:**
- **Negative value:** This object is LESS than parameter (comes first)
- **Zero:** Objects are EQUAL
- **Positive value:** This object is GREATER than parameter (comes after)

```java
// Sort numbers ascending
public int compareTo(Integer other) {
    if (this < other) return -1;  // This comes first
    if (this > other) return 1;   // This comes after
    return 0;                      // Equal
}

// Shortcut:
return Integer.compare(this, other);
```

---

## 🔷 Iterator Interview Questions

### Q18: What is the difference between Fail-Fast and Fail-Safe iterator?
**Answer:**

| Feature | Fail-Fast | Fail-Safe |
|---------|-----------|-----------|
| Used by | ArrayList, HashMap, HashSet | CopyOnWriteArrayList, ConcurrentHashMap |
| Modification during iteration | ❌ Throws ConcurrentModificationException | ✅ Allowed |
| Works on | Actual collection | Copy/snapshot of collection |
| Memory | Less | More |
| Iterator.remove() | ✅ Supported | ❌ UnsupportedOperationException |

---

### Q19: How does Fail-Fast iterator detect modification?
**Answer:**
Using internal `modCount` variable:
1. When iterator is created, it stores current `modCount` as `expectedModCount`
2. Any structural modification (add/remove) increments `modCount`
3. On each `next()` call, iterator checks: `modCount == expectedModCount?`
4. If not equal → throws `ConcurrentModificationException`

---

### Q20: How to safely remove elements while iterating?
**Answer:**

**Wrong way:**
```java
for (String s : list) {
    if (condition) {
        list.remove(s);  // ConcurrentModificationException!
    }
}
```

**Correct ways:**
```java
// 1. Use Iterator's remove()
Iterator<String> itr = list.iterator();
while (itr.hasNext()) {
    if (condition) {
        itr.remove();  // Safe!
    }
}

// 2. Use CopyOnWriteArrayList
List<String> list = new CopyOnWriteArrayList<>();
for (String s : list) {
    list.remove(s);  // Safe! (but can't use itr.remove())
}

// 3. Use removeIf() (Java 8+)
list.removeIf(s -> s.startsWith("A"));
```

---

## 🔷 Socket Programming Interview Questions

### Q21: What is the difference between TCP and UDP?
**Answer:**

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented | Connectionless |
| Reliability | Guaranteed delivery | No guarantee |
| Order | Maintains order | No ordering |
| Speed | Slower | Faster |
| Overhead | Higher | Lower |
| Use case | File transfer, Web | Streaming, Gaming |

---

### Q22: What is the role of ServerSocket.accept()?
**Answer:**
The `accept()` method:
1. **Blocks** the server thread until a client connects
2. When client connects, returns a `Socket` object representing that client
3. Server can then use this Socket for communication with that specific client

Similar to DatagramSocket's `receive()` method in UDP.

---

### Q23: How to create a server that handles multiple clients?
**Answer:**
Use multi-threading:

```java
ServerSocket server = new ServerSocket(8000);
while (true) {
    Socket client = server.accept();  // Block until client connects
    new Thread(() -> {
        // Handle client in separate thread
        handleClient(client);
    }).start();
}
```

Main thread immediately returns to accept next client while handler thread serves current client.

---

### Q24: Can we send objects over network?
**Answer:**
**Yes**, using `ObjectInputStream` and `ObjectOutputStream`. The object's class must implement `Serializable`.

```java
// Sending
ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
oos.writeObject(myObject);  // Serializes and sends

// Receiving
ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
MyObject obj = (MyObject) ois.readObject();  // Deserializes
```

---

## 🔷 Scenario-Based Questions

### Q25: You need to store unique elements in sorted order. What will you use?
**Answer:** `TreeSet`
- Unique elements: Set guarantees uniqueness
- Sorted order: TreeSet maintains sorted order

```java
Set<String> names = new TreeSet<>();
names.add("Charlie");
names.add("Alice");
names.add("Bob");
// Output: [Alice, Bob, Charlie] - automatically sorted!
```

---

### Q26: You need a thread-safe List with good read performance. What will you use?
**Answer:** `CopyOnWriteArrayList`
- Thread-safe without explicit synchronization
- Excellent for scenarios where reads >> writes
- Creates copy on write, so reads are fast

**Alternative:** If writes are frequent, use `Collections.synchronizedList()` with ArrayList.

---

### Q27: You have Employee objects and need to sort them by name sometimes, by salary sometimes. How?
**Answer:** Use **Comparators**:

```java
class Employee {
    String name;
    double salary;
}

// Sort by name
Collections.sort(employees, (e1, e2) -> e1.name.compareTo(e2.name));

// Sort by salary
Collections.sort(employees, (e1, e2) -> Double.compare(e1.salary, e2.salary));

// Using Comparator.comparing (Java 8+)
Collections.sort(employees, Comparator.comparing(Employee::getName));
Collections.sort(employees, Comparator.comparing(Employee::getSalary));
```

---

## 🔷 Code Output Questions

### Q28: What is the output?
```java
List<Integer> list = new ArrayList<>();
list.add(10);
list.add(20);
list.add(30);
list.remove(1);
System.out.println(list);
```

**Answer:** `[10, 30]`

`remove(1)` removes element at **index** 1 (which is 20), not the element with value 1.

To remove value 1: `list.remove(Integer.valueOf(1))`

---

### Q29: What is the output?
```java
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");
set.add("A");
System.out.println(set.size());
```

**Answer:** `2`

HashSet doesn't allow duplicates. Second "A" is ignored.

---

### Q30: What is the output?
```java
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
map.put("a", 3);
System.out.println(map);
```

**Answer:** `{a=3, b=2}`

When putting with existing key, the value is **overwritten**.

---

### Q31: Will this compile? Why?
```java
List<Animal> animals = new ArrayList<Dog>();
```

**Answer:** **No**, it won't compile.

Generic type must be exactly the same. `List<Animal>` is not compatible with `ArrayList<Dog>` even though `Dog extends Animal`.

Correct alternatives:
```java
List<Dog> dogs = new ArrayList<Dog>();  // Same type
List<Animal> animals = new ArrayList<Animal>();  // Same type
List<? extends Animal> animals = new ArrayList<Dog>();  // Wildcard
```

---

### Q32: What happens here?
```java
List<String> list = new ArrayList<>();
list.add("A");
for (String s : list) {
    list.add("B");
}
```

**Answer:** `ConcurrentModificationException`

ArrayList uses fail-fast iterator. Modifying the list during iteration throws exception.

---

> [!TIP]
> **Interview Preparation Tips:**
> 1. Practice drawing HashMap bucket structure
> 2. Know the time complexity of common operations
> 3. Understand the internal workings, not just usage
> 4. Be prepared to write code on whiteboard
> 5. Know when to use which collection!

