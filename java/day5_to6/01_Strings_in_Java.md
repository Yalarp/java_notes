# 📚 Strings in Java - Complete Guide

## Table of Contents
1. [Introduction to Strings](#introduction-to-strings)
2. [String Creation Methods](#string-creation-methods)
3. [String Constant Pool](#string-constant-pool)
4. [equals() vs == Comparison](#equals-vs--comparison)
5. [The intern() Method](#the-intern-method)
6. [Important String Methods](#important-string-methods)
7. [String Immutability](#string-immutability)
8. [Compile-Time String Optimization](#compile-time-string-optimization)
9. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Strings

A **String** in Java is an object that represents a sequence of characters. The String class is:
- **Immutable** - Once created, its value cannot be changed
- **Final** - Cannot be subclassed
- Located in `java.lang` package (auto-imported)

```java
// String is internally stored as character array
// In older Java versions:
private final char value[];

// In Java 9+:
private final byte value[];
```

---

## String Creation Methods

There are **two ways** to create a String in Java:

### Method 1: Using String Literal (Recommended)
```java
String str1 = "hello";
```
- Creates string in **String Constant Pool** (inside Heap)
- If same string already exists, returns reference to existing string
- More memory efficient

### Method 2: Using new Keyword
```java
String str2 = new String("hello");
```
- Creates string in **Heap memory** (outside pool)
- Always creates a new object
- Also creates one object in pool if not present

### Code Example: StringDemo1.java
```java
public class StringDemo1
{
    public static void main(String args[])
    {
        // Line 5: Creates "hello" in heap using new keyword
        // Also creates "hello" in String pool if not present
        String str1 = new String("hello");

        // Line 7: Prints "hello" - internally calls toString() of String class
        System.out.println(str1);  // Output: hello
    }
}
```

**Execution Flow:**
1. JVM loads `StringDemo1` class
2. `main()` is called
3. `new String("hello")` creates object in heap
4. `str1` reference points to this heap object
5. `System.out.println(str1)` calls `str1.toString()` and prints "hello"

---

## String Constant Pool

The **String Constant Pool** (also called String Intern Pool) is a special memory area in the **Heap** that stores unique string literals.

### Why String Pool Exists?
```
a) Object creation in general is a time-consuming process.
b) Object creation costs memory.
c) To increase performance and reduce overhead.
```

### How Pool Works:

```
Memory Layout:
┌─────────────────────────────────────────────────────┐
│                      HEAP MEMORY                     │
│  ┌───────────────────────────────────────────────┐  │
│  │           STRING CONSTANT POOL                 │  │
│  │                                                │  │
│  │   "hello" ──────► [Address: 2000]              │  │
│  │   "world" ──────► [Address: 3000]              │  │
│  │                                                │  │
│  └───────────────────────────────────────────────┘  │
│                                                      │
│   Regular Heap Objects:                              │
│   new String("hello") ──► [Address: 5000]           │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Code Example: StringDemo4.java
```java
public class StringDemo4
{
    public static void main(String args[])
    {
        // Line 5: Creates "hello" in heap (outside pool)
        String s1 = new String("hello");
        
        // Line 6: Creates "hello" in pool, s2 points to pool object
        String s2 = "hello";
        
        // Line 7: "hello" already in pool, s3 points to SAME pool object as s2
        String s3 = "hello";

        System.out.println(s1);  // hello
        System.out.println(s2);  // hello
        System.out.println(s3);  // hello

        // s2 and s3 comparison
        if(s2.equals(s3))  // true - same content
        {
            System.out.println("s2 and s3 are equals");
        }

        if(s2 == s3)  // true - SAME object reference (both point to pool)
        {
            System.out.println("s2 and s3 are ==");
        }
        
        // All have same hashCode because content is same
        System.out.println(s1.hashCode());  // 99162322
        System.out.println(s2.hashCode());  // 99162322
        System.out.println(s3.hashCode());  // 99162322
    }
}
```

**Execution Flow:**
```
Step 1: s1 = new String("hello")
        ├── Creates "hello" in pool (if not exists)
        └── Creates NEW object in heap, s1 points here

Step 2: s2 = "hello"
        └── "hello" already in pool, s2 points to pool object

Step 3: s3 = "hello"
        └── "hello" already in pool, s3 points to SAME pool object as s2

Memory State:
s1 ──────► [Heap Object: "hello" at 5000]
s2 ──┬───► [Pool Object: "hello" at 2000]
s3 ──┘
```

---

## equals() vs == Comparison

### The Difference:

| `==` operator | `equals()` method |
|---------------|-------------------|
| Compares **references** (memory addresses) | Compares **content** (actual characters) |
| Returns true if same object | Returns true if same content |
| Faster | Slower (character by character comparison) |

### Code Example: StringDemo2.java
```java
public class StringDemo2
{
    public static void main(String args[])
    {
        // Both created using new - two DIFFERENT heap objects
        String s1 = new String("hello");  // Object at address 5000
        String s2 = new String("hello");  // Object at address 6000

        System.out.println(s1);  // hello
        System.out.println(s2);  // hello

        // Content comparison - compares 'h','e','l','l','o'
        if(s1.equals(s2))  // TRUE - same content
        {
            System.out.println("s1 and s2 are equals");
        }

        // Reference comparison - compares addresses
        if(s1 == s2)  // FALSE - different objects (5000 != 6000)
        {
            System.out.println("s1 and s2 are ==");
        }
        else
        {
            System.out.println("s1 and s2 are not ==");
        }
        
        // hashCode is same because content is same
        System.out.println(s1.hashCode());  // 99162322
        System.out.println(s2.hashCode());  // 99162322
    }
}
```

**Output:**
```
hello
hello
s1 and s2 are equals
s1 and s2 are not ==
99162322
99162322
```

### Code Example: StringDemo3.java
```java
public class StringDemo3
{
    public static void main(String args[])
    {
        // s1 in heap, s2 in pool
        String s1 = new String("hello");  // Heap object
        String s2 = "hello";               // Pool object

        if(s1.equals(s2))  // TRUE - same content
        {
            System.out.println("s1 and s2 are equals");
        }

        if(s1 == s2)  // FALSE - different objects
        {
            System.out.println("s1 and s2 are ==");
        }
        else
        {
            System.out.println("s1 and s2 are not ==");
        }
    }
}
```

> **Note:** The drawback of `equals()` is that it's **slower** than `==` because it compares character by character.

---

## The intern() Method

The `intern()` method returns a **canonical representation** of the string from the pool.

### How intern() Works:
```
When intern() is invoked:
├── If pool ALREADY contains equal string → Returns reference from pool
└── If pool does NOT contain equal string → Adds to pool, returns reference
```

### Main Use of intern():
Using `intern()` can improve performance in situations where **string comparisons are frequent**. Interned strings can be compared using `==` (reference equality) instead of `equals()`, which is faster since it avoids character-by-character comparison.

### Code Example: StringDemo8_intern.java
```java
public class StringDemo8_intern
{
    public static void main(String args[])
    {
        // Example 1: Literal already in pool
        String s1 = "hello";        // Goes to pool at address 2000
        String s2 = s1.intern();    // "hello" already in pool, returns same reference
        System.out.println(s1 == s2);  // TRUE - same pool object

        // Example 2: Using new keyword
        String s3 = new String("world");  // Heap object at 5000, pool has "world" at 3000
        String s4 = s3.intern();          // Returns pool reference (3000)
        
        // s3 points to 5000 (heap), s4 points to 3000 (pool)
        System.out.println(s3 == s4);  // FALSE - different addresses
    }
}
```

### Code Example: StringDemo9_intern.java
```java
public class StringDemo9_intern
{
    public static void main(String args[])
    {
        String s1 = "hello";
        String s2 = "world";
        
        // concat() creates NEW string in heap (not in pool)
        String s3 = s1.concat(s2);  // "helloworld" in heap
        System.out.println(s3);  // helloworld
        
        // intern() checks pool, "helloworld" not there, adds it
        s3.intern();  // Now "helloworld" is in pool
        
        // Creating string from char array
        char[] c = {'J', 'A', 'V', 'A'};
        String s6 = new String(c);  // "JAVA" in heap
        s6.intern();  // Adds "JAVA" to pool if not present
    }
}
```

---

## Important String Methods

### Complete Methods Demo: StringDemo17.java
```java
public class StringDemo17
{
    public static void main(String args[])
    {
        String str1 = "hello world";
        
        // charAt(index) - Returns character at specified index
        System.out.println(str1.charAt(0));  // 'h' (index starts from 0)
        
        // concat(str) - Joins strings, returns NEW string
        String str2 = str1.concat(" welcome");
        System.out.println("str1 is \t" + str1);  // hello world (unchanged)
        System.out.println("str2 is \t" + str2);  // hello world welcome

        // compareTo(str) - Lexicographic comparison
        // Returns: negative if str1 < str2, 0 if equal, positive if str1 > str2
        int val = str1.compareTo(str2);
        System.out.println("comparison is\t" + val);  // negative number

        // indexOf(char) - First occurrence of character
        System.out.println(str1.indexOf('e'));  // 1

        // lastIndexOf(char) - Last occurrence of character
        System.out.println(str1.lastIndexOf('l'));  // 9

        // length() - Number of characters
        System.out.println("Length of str1 is \t" + str1.length());  // 11

        // replace(oldChar, newChar) - Replaces all occurrences
        String str3 = str1.replace('e', 'i');
        System.out.println(str1);  // hello world (unchanged)
        System.out.println(str3);  // hillo world

        // substring(beginIndex) - From index to end
        System.out.println(str1.substring(2));  // llo world

        // toLowerCase() - Converts to lowercase
        String str4 = "ABCDEFG";
        String str5 = str4.toLowerCase();
        System.out.println(str4);  // ABCDEFG (unchanged)
        System.out.println(str5);  // abcdefg

        // toUpperCase() - Converts to uppercase
        String str6 = str1.toUpperCase();
        System.out.println(str1);  // hello world (unchanged)
        System.out.println(str6);  // HELLO WORLD

        // trim() - Removes leading and trailing whitespace
        String str7 = "  how are you  ";
        System.out.println(str7);  // "  how are you  "
        String str8 = str7.trim();
        System.out.println(str7);  // "  how are you  " (unchanged)
        System.out.println(str8);  // "how are you"
    }
}
```

### String Methods Summary Table:

| Method | Description | Returns |
|--------|-------------|---------|
| `charAt(int index)` | Character at index | char |
| `concat(String str)` | Concatenates strings | String |
| `compareTo(String str)` | Lexicographic comparison | int |
| `equals(Object obj)` | Content comparison | boolean |
| `equalsIgnoreCase(String str)` | Case-insensitive comparison | boolean |
| `indexOf(char ch)` | First index of character | int |
| `lastIndexOf(char ch)` | Last index of character | int |
| `length()` | Number of characters | int |
| `replace(char old, char new)` | Replace characters | String |
| `substring(int begin)` | Substring from index | String |
| `substring(int begin, int end)` | Substring in range | String |
| `toLowerCase()` | Convert to lowercase | String |
| `toUpperCase()` | Convert to uppercase | String |
| `trim()` | Remove whitespace | String |
| `intern()` | Get pool reference | String |

---

## String Immutability

### What is Immutability?
Once a String object is created, its **content cannot be modified**. Any operation that appears to modify a String actually creates a **new String object**.

### Code Example: StringDemo10.java
```java
public class StringDemo10
{
    public static void main(String args[])
    {
        String s1 = "hello";
        
        // concat() does NOT modify s1, creates NEW string
        String s2 = s1.concat(" world");
        
        System.out.println(s1);  // hello (unchanged!)
        System.out.println(s2);  // hello world (new string)
    }
}
```

**Memory Visualization:**
```
Before concat():
s1 ──────► ["hello"] at 2000

After concat():
s1 ──────► ["hello"] at 2000 (unchanged)
s2 ──────► ["hello world"] at 3000 (new object)
```

### equalsIgnoreCase() for Case-Insensitive Comparison
### Code Example: StringDemo12.java
```java
public class StringDemo12
{
    public static void main(String args[])
    {
        String s1 = "admin";
        String s2 = "Admin";

        System.out.println(s1);  // admin
        System.out.println(s2);  // Admin

        if(s1 == s2)  // FALSE - different pool objects
        {
            System.out.println("s1 and s2 are ==");
        }
        else
        {
            System.out.println("s1 and s2 are not ==");
        }

        if(s1.equals(s2))  // FALSE - different content ('a' != 'A')
        {
            System.out.println("s1 and s2 are equals");
        }
        else
        {
            System.out.println("s1 and s2 are not equals");
        }

        if(s1.equalsIgnoreCase(s2))  // TRUE - ignores case
        {
            System.out.println("s1 and s2 are equalsIgnoreCase");
        }
    }
}
```

---

## Compile-Time String Optimization

The Java compiler performs **compile-time concatenation** for string literals.

### Code Example: StringDemo13.java
```java
public class StringDemo13
{
    public static void main(String args[])
    {
        String s1 = "hello";  // Pool: "hello" at 2000
        
        // Compiler optimization: "hel" + "lo" becomes "hello" at compile time
        if(s1 == "hel" + "lo")  // Compiler creates "hello", same pool object
        {
            System.out.println("true");  // This prints!
        }
        else
        {
            System.out.println("false");
        }
    }
}
```

**Explanation:** At compile time, `"hel" + "lo"` is evaluated to `"hello"`. The compiler stores `"hello"` in the pool. Since `s1` also points to `"hello"` in the pool, `s1 == "hel" + "lo"` is **true**.

### Code Example: StringDemo14.java (Variable Concatenation)
```java
public class StringDemo14
{
    public static void main(String args[])
    {
        String s1 = "hello";  // Pool: 2000
        String s2 = "hel";    // Pool: 4000
        
        // s2 + "lo" is evaluated at RUNTIME, creates new object
        if(s1 == (s2 + "lo"))  // Creates new heap object
        {
            System.out.println("true");
        }
        else
        {
            System.out.println("false");  // This prints!
        }
    }
}
```

**Explanation:** Because `s2` is a variable (not final), the concatenation `s2 + "lo"` happens at **runtime** and creates a new object in heap, not in pool.

### Code Example: StringDemo16.java (final Variable Optimization)
```java
public class StringDemo16
{
    public static void main(String args[])
    {
        String s1 = "hello";       // Pool: 2000
        final String s2 = "hel";   // FINAL - treated as compile-time constant
        
        // Because s2 is final, compiler can optimize: s2 + "lo" = "hello"
        if(s1 == (s2 + "lo"))  // Compile-time optimization!
        {
            System.out.println("true");  // This prints!
        }
        else
        {
            System.out.println("false");
        }
    }
}
```

**Explanation:** When `s2` is declared `final`, the compiler treats it as a compile-time constant. So `s2 + "lo"` is optimized to `"hello"` and stored in the pool.

---

## Code Examples with Flow

### Complete Flow Diagram for String Operations

```
┌──────────────────────────────────────────────────────────────────┐
│                    STRING CREATION FLOW                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  String s = "hello";                                             │
│  ├─► Check: Is "hello" in pool?                                  │
│  │   ├─► YES: Return existing reference                          │
│  │   └─► NO: Create in pool, return reference                    │
│                                                                  │
│  String s = new String("hello");                                 │
│  ├─► Step 1: Check/Create "hello" in pool (for literal)          │
│  └─► Step 2: Create NEW object in heap, return heap reference    │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                    COMPARISON FLOW                               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  s1 == s2                                                        │
│  └─► Compare: address(s1) == address(s2) ?                       │
│                                                                  │
│  s1.equals(s2)                                                   │
│  ├─► If same reference: return true                              │
│  ├─► If different class: return false                            │
│  └─► Compare character by character                              │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                    INTERN() FLOW                                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  s.intern()                                                      │
│  ├─► Check: Is equal string in pool?                             │
│  │   ├─► YES: Return pool reference                              │
│  │   └─► NO: Add to pool, return new pool reference              │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Key Takeaways

1. **String Pool saves memory** - Same literals share one object
2. **Use literals** - `"hello"` is more efficient than `new String("hello")`
3. **Use equals() for content** - `==` only checks reference
4. **Strings are immutable** - Operations return new strings
5. **intern() enables fast comparison** - Pool strings can use `==`
6. **final enables optimization** - Compiler can evaluate at compile-time
7. **hashCode same for equal content** - Even different objects

---

*Next: [02_StringBuilder_and_Mutability.md](./02_StringBuilder_and_Mutability.md)*
