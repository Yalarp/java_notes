# 📚 StringBuilder and Mutability in Java

## Table of Contents
1. [Mutable vs Immutable Objects](#mutable-vs-immutable-objects)
2. [Why Immutability Matters](#why-immutability-matters)
3. [The Immutable Class Pattern](#the-immutable-class-pattern)
4. [The Mutable Class Pattern](#the-mutable-class-pattern)
5. [StringBuilder Class](#stringbuilder-class)
6. [How Compiler Uses StringBuilder](#how-compiler-uses-stringbuilder)
7. [StringBuilder vs StringBuffer](#stringbuilder-vs-stringbuffer)
8. [Code Examples with Flow](#code-examples-with-flow)

---

## Mutable vs Immutable Objects

### Definition

| Mutable Objects | Immutable Objects |
|-----------------|-------------------|
| State CAN be changed after creation | State CANNOT be changed after creation |
| Same object is modified | New object is created for any change |
| Example: StringBuilder, ArrayList | Example: String, Integer, LocalDate |
| Can have setter methods | No setter methods |

### Key Difference in Behavior

```
Mutable Object:
┌───────────────────┐
│ obj.value = 10    │  ──modify──►  ┌───────────────────┐
└───────────────────┘               │ obj.value = 20    │ (same object)
                                    └───────────────────┘

Immutable Object:
┌───────────────────┐                ┌───────────────────┐
│ obj.value = 10    │  ──modify──►   │ obj.value = 10    │ (unchanged)
└───────────────────┘                └───────────────────┘
                                     + 
                                    ┌───────────────────┐
                                    │ newObj.value = 20 │ (new object)
                                    └───────────────────┘
```

---

## Why Immutability Matters

### Advantages of Immutability:
1. **Thread Safety** - Multiple threads can share without synchronization
2. **Security** - Value cannot be changed by untrusted code
3. **Caching** - Safe to reuse (String pool uses this)
4. **Predictability** - No unexpected state changes

### Disadvantages of Immutability:
1. **Memory Overhead** - New object for every change
2. **Performance** - Object creation is expensive

### When to Use What:
- Use **Immutable** when object is shared across threads or as keys in HashMap
- Use **Mutable** when frequent modifications are needed

---

## The Immutable Class Pattern

### Code Example: ImmutableDemo.java
```java
// Immutable class - once created, value cannot change
class Immutable
{
    // Line 5: Private field - cannot be accessed directly
    private int num;

    // Line 7-10: Constructor - only way to set the value
    public Immutable(int num)
    {
        this.num = num;  // Line 9: Set value during construction
    }
    
    // Line 11-14: Getter - can only READ the value
    int getNum()
    {
        return num;  // Line 13: Returns the value
    }
    
    // Line 15-18: toString for printing
    public String toString()
    {
        return "[" + num + "]";  // Line 17: Returns formatted string
    }
    
    // Line 19-22: add() method - DOES NOT modify this object
    // Instead, creates and returns a NEW Immutable object
    public Immutable add(int k)
    {
        // Line 21: Creates NEW object with new value
        // Original object remains unchanged
        return new Immutable(num + k);
    }
}

public class ImmutableDemo
{
    public static void main(String args[])
    {
        // Line 28: Create Immutable with value 10
        Immutable i1 = new Immutable(10);
        System.out.println(i1);  // Output: [10]
        
        // Line 30: add(20) creates NEW object, i1 is NOT changed
        Immutable i2 = i1.add(20);
        
        // Line 31: i1 is still [10] - UNCHANGED!
        System.out.println(i1);  // Output: [10]
        
        // Line 32: i2 is [30] - the new object
        System.out.println(i2);  // Output: [30]
    }
}
```

### Execution Flow:
```
Step 1: new Immutable(10)
        ┌─────────────────┐
   i1 ──► │ num = 10       │  Object at address 1000
        └─────────────────┘

Step 2: i1.add(20) called
        ├── num + k = 10 + 20 = 30
        └── return new Immutable(30)
            Creates NEW object:
            ┌─────────────────┐
       i2 ──► │ num = 30       │  Object at address 2000
            └─────────────────┘

Step 3: Print i1 → [10] (object at 1000 unchanged)
Step 4: Print i2 → [30] (new object at 2000)
```

### Key Points for Immutable Class:
1. **No setter methods** - Value set only in constructor
2. **Private fields** - Cannot be modified directly
3. **Methods return new objects** - Never modify `this`
4. **Class should be final** - Prevents subclassing

---

## The Mutable Class Pattern

### Code Example: MutableDemo.java
```java
// Mutable class - value can be changed after creation
class Mutable
{
    // Line 5: Private field
    private int num;

    // Line 7-10: Constructor
    public Mutable(int num)
    {
        this.num = num;  // Line 9: Initialize value
    }
    
    // Line 11-14: Setter method - ALLOWS modification
    public void setNum(int num)
    {
        this.num = num;  // Line 13: Changes the value
    }
    
    // Line 15-18: Getter method
    int getNum()
    {
        return num;  // Line 17: Returns current value
    }
    
    // Line 19-22: toString
    public String toString()
    {
        return "[" + num + "]";  // Line 21: Formatted output
    }
    
    // Line 23-27: add() method - MODIFIES this object
    public Mutable add(int k)
    {
        num += k;       // Line 25: Modifies the same object!
        return this;    // Line 26: Returns SAME object for chaining
    }
}

public class MutableDemo
{
    public static void main(String args[])
    {
        // Line 33: Create Mutable with value 10
        Mutable i1 = new Mutable(10);
        System.out.println(i1);  // Output: [10]
        
        // Line 35: Method chaining - each add() modifies i1
        i1.add(20).add(50).add(100);
        
        // Line 36: i1 is NOW [180] - MODIFIED!
        System.out.println(i1);  // Output: [180]
    }
}
```

### Execution Flow:
```
Step 1: new Mutable(10)
        ┌─────────────────┐
   i1 ──► │ num = 10       │  Object at address 1000
        └─────────────────┘

Step 2: i1.add(20) - modifies SAME object
        ┌─────────────────┐
   i1 ──► │ num = 30       │  Same object at 1000
        └─────────────────┘
        Returns i1 (for chaining)

Step 3: .add(50) - continues on same object
        ┌─────────────────┐
   i1 ──► │ num = 80       │  Same object at 1000
        └─────────────────┘

Step 4: .add(100) - continues on same object
        ┌─────────────────┐
   i1 ──► │ num = 180      │  Same object at 1000
        └─────────────────┘

Step 5: Print i1 → [180] (object at 1000 was modified)
```

### Method Chaining Pattern:
```java
i1.add(20).add(50).add(100);
```
This is possible because `add()` returns `this`, allowing consecutive calls.

---

## StringBuilder Class

StringBuilder is a **mutable alternative to String**. When you need to perform many string modifications, StringBuilder is much more efficient.

### Why Use StringBuilder?
- **String** creates new object for each modification
- **StringBuilder** modifies the same object

### Code Example: StringBuilderDemo.java
```java
// StringBuilder class is mutable
public class StringBuilderDemo
{
    public static void main(String args[])
    {
        // Line 6: Create StringBuilder with initial content "hello"
        StringBuilder sb1 = new StringBuilder("hello");
        System.out.println(sb1);  // Output: hello
        
        // Line 8: append() MODIFIES sb1 (does not create new object)
        sb1.append("world");
        
        // Line 9: sb1 is now "helloworld"
        System.out.println(sb1);  // Output: helloworld
    }
}
```

### Execution Flow:
```
Step 1: new StringBuilder("hello")
        ┌───────────────────────────┐
  sb1 ──► │ buffer: ['h','e','l','l','o'] │  Object at 1000
        └───────────────────────────┘

Step 2: sb1.append("world")
        ┌─────────────────────────────────────────┐
  sb1 ──► │ buffer: ['h','e','l','l','o','w','o','r','l','d'] │  SAME object
        └─────────────────────────────────────────┘

Step 3: Print sb1 → "helloworld" (same object, modified content)
```

### Common StringBuilder Methods:

| Method | Description | Returns |
|--------|-------------|---------|
| `append(String s)` | Adds string at end | StringBuilder |
| `insert(int offset, String s)` | Inserts at position | StringBuilder |
| `delete(int start, int end)` | Removes characters | StringBuilder |
| `reverse()` | Reverses content | StringBuilder |
| `toString()` | Converts to String | String |
| `length()` | Current length | int |
| `capacity()` | Current capacity | int |

---

## How Compiler Uses StringBuilder

When you write string concatenation using `+` operator, the **compiler automatically converts it to StringBuilder** operations.

### Code Example: StringBuilder class usage.txt
```java
public class StringBuilderDemo1
{
    public static void main(String args[])
    {
        int num1 = 10, num2 = 20;
        
        // What you write:
        System.out.println(num1 + "\t" + num2);
    }
}
```

### What Compiler Does:
```java
// Your code:
System.out.println(num1 + "\t" + num2);

// Compiler converts to:
System.out.println(new StringBuilder().append(num1).append("\t").append(num2).toString());
```

### Step-by-Step Breakdown:
```
1. new StringBuilder()        → Creates empty StringBuilder
2. .append(num1)              → Appends "10"
3. .append("\t")              → Appends tab character
4. .append(num2)              → Appends "20"
5. .toString()                → Converts to "10\t20"
6. System.out.println(...)    → Prints result
```

### Why This Matters:
In a loop, manual StringBuilder is more efficient:

```java
// INEFFICIENT - creates many StringBuilder objects
String result = "";
for(int i = 0; i < 1000; i++) {
    result = result + i;  // Creates new StringBuilder each iteration
}

// EFFICIENT - single StringBuilder object
StringBuilder sb = new StringBuilder();
for(int i = 0; i < 1000; i++) {
    sb.append(i);  // Modifies same object
}
String result = sb.toString();
```

---

## StringBuilder vs StringBuffer

| StringBuilder | StringBuffer |
|---------------|--------------|
| Introduced in Java 5 | Since Java 1.0 |
| **Not synchronized** | **Synchronized** (thread-safe) |
| Faster | Slower (due to synchronization) |
| Use in single-threaded code | Use when multiple threads access |
| Preferred in most cases | Use only when thread-safety needed |

### Example:
```java
// For single-threaded applications:
StringBuilder sb = new StringBuilder("hello");  // Preferred

// For multi-threaded applications:
StringBuffer sbf = new StringBuffer("hello");   // Thread-safe
```

---

## Code Examples with Flow

### Comparing String vs StringBuilder

```java
public class ComparisonDemo
{
    public static void main(String args[])
    {
        // Using String (Immutable)
        String str = "hello";
        str = str.concat(" world");  // Creates NEW String object
        // Original "hello" still exists in pool
        
        // Using StringBuilder (Mutable)
        StringBuilder sb = new StringBuilder("hello");
        sb.append(" world");  // Modifies SAME object
        // No new object created
    }
}
```

### Memory Comparison:

```
String Operations:
─────────────────
str = "hello"               → Object 1 in pool
str = str.concat(" world")  → Object 2 created ("hello world")
                            → str now points to Object 2
                            → Object 1 still exists (may be garbage collected later)

StringBuilder Operations:
─────────────────────────
sb = new StringBuilder("hello")  → Object 1 with buffer
sb.append(" world")              → Same Object 1, buffer expanded
                                 → No new object created
```

---

## Key Takeaways

1. **Immutable objects** - Cannot be changed after creation, safer
2. **Mutable objects** - Can be changed, more efficient for modifications
3. **String is immutable** - Every modification creates new object
4. **StringBuilder is mutable** - Modifications happen in place
5. **Compiler uses StringBuilder** - For string concatenation with `+`
6. **Use StringBuilder in loops** - Much more efficient than string concatenation
7. **Method chaining** - Possible when methods return `this`
8. **StringBuffer** - Thread-safe version of StringBuilder

---

*Previous: [01_Strings_in_Java.md](./01_Strings_in_Java.md)*
*Next: [03_Wrapper_Classes.md](./03_Wrapper_Classes.md)*
