# 📚 Varargs (Variable Arguments) in Java

## Table of Contents
1. [Introduction to Varargs](#introduction-to-varargs)
2. [Fixed vs Variable Arguments](#fixed-vs-variable-arguments)
3. [Varargs Syntax](#varargs-syntax)
4. [How Varargs Works Internally](#how-varargs-works-internally)
5. [Varargs with Objects](#varargs-with-objects)
6. [Rules and Restrictions](#rules-and-restrictions)
7. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Varargs

**Varargs** (Variable Arguments) is a feature introduced in **Java 5** that allows a method to accept **zero or more arguments** of the same type.

### Key Benefits:
- Eliminates the need for overloaded methods
- Provides flexibility in method calls
- More readable than passing arrays

---

## Fixed vs Variable Arguments

### Fixed Number of Arguments:
```java
// Method accepts EXACTLY 2 arguments
void disp(int k, int p)
{
    System.out.println(k + "\t" + p);
}

// Calling:
disp(10, 20);     // ✓ Exactly 2 arguments - OK
disp(10);         // ✗ Error - too few
disp(10, 20, 30); // ✗ Error - too many
```

### Variable Number of Arguments:
```java
// Method accepts 0 or more arguments
void disp(int ...k)  // Note: ... is called "ellipsis"
{
    for(int i = 0; i < k.length; i++)
    {
        System.out.println(k[i]);
    }
}

// Calling:
disp();              // ✓ 0 arguments - OK
disp(10);            // ✓ 1 argument - OK
disp(10, 20);        // ✓ 2 arguments - OK
disp(10, 20, 30);    // ✓ 3 arguments - OK
// ... and so on
```

---

## Varargs Syntax

### Declaration:
```java
// Syntax: dataType ...variableName
returnType methodName(Type ...varName)
{
    // varName is treated as an array
}
```

### Examples:
```java
void show(int ...numbers)       // int varargs
void show(String ...names)      // String varargs
void show(Object ...items)      // Any object varargs
void show(double ...values)     // double varargs
```

---

## How Varargs Works Internally

### Varargs is internally treated as an ARRAY:

```java
void disp(int ...k)
{
    // 'k' is actually an int[] array
    System.out.println(k.getClass().getName());  // [I (int array)
    System.out.println(k.length);                // Number of arguments passed
}
```

### Code Example: Demo1.java
```java
public class Demo1
{
    // Line 3: Varargs method - accepts 0 or more int values
    void disp(int ...set)
    {
        // Line 5-8: Traditional for loop
        // set.length gives number of arguments passed
        for(int i = 0; i < set.length; i++)
        {
            System.out.println(set[i]);  // Access like array
        }
        
        // Line 9-12: Enhanced for-each loop
        // Works because varargs IS an array
        for(int k : set)
        {
            System.out.println(k);
        }
    }
    
    public static void main(String args[])
    {
        Demo1 d = new Demo1();
        
        // Line 17: Pass 2 arguments
        d.disp(10, 20);
        System.out.println(".................");
        
        // Line 19: Pass 5 arguments
        d.disp(100, 200, 300, 400, 500);
    }
}
```

### Execution Flow:
```
Step 1: d.disp(10, 20) called
        ┌─────────────────────────────────────┐
        │ set array is created: [10, 20]      │
        │ set.length = 2                      │
        │ Iteration: set[0]=10, set[1]=20     │
        └─────────────────────────────────────┘
        Output: 10
                20
                10
                20

Step 2: d.disp(100, 200, 300, 400, 500) called
        ┌──────────────────────────────────────────────┐
        │ set array is created: [100, 200, 300, 400, 500] │
        │ set.length = 5                                   │
        │ Iteration through all 5 elements                 │
        └──────────────────────────────────────────────┘
        Output: 100
                200
                300
                400
                500
                100
                200
                300
                400
                500
```

---

## Varargs with Objects

Using `Object ...args` allows passing **any type** of objects:

### Code Example: Demo2.java
```java
class A
{
    public String toString()
    {
        return "My Name is\t" + getClass().getName();  // Returns "My Name is  A"
    }
}

class B
{
    public String toString()
    {
        return "My Name is\t" + getClass().getName();  // Returns "My Name is  B"
    }
}

class C
{
    public String toString()
    {
        return "My Name is\t" + getClass().getName();  // Returns "My Name is  C"
    }
}

class D
{
    public String toString()
    {
        return "My Name is\t" + getClass().getName();  // Returns "My Name is  D"
    }
}

public class Demo2 
{
    // Line 31: Object varargs - accepts any objects
    void disp(Object ...col)
    {
        // Line 33-36: Traditional for loop
        for(int i = 0; i < col.length; i++)
        {
            System.out.println(col[i]);  // Calls toString() of each object
        }
        
        System.out.println("Using foreach loop");
        
        // Line 38-41: Enhanced for-each loop
        for(Object ref : col)
        {
            System.out.println(ref);
        }
    }
    
    public static void main(String args[])
    {
        // Line 45-48: Create objects of different classes
        A ob1 = new A();
        B ob2 = new B();
        C ob3 = new C();
        D ob4 = new D();
        
        // Line 49: Pass 4 different objects to varargs method
        new Demo2().disp(ob1, ob2, ob3, ob4);
    }
}
```

### Execution Flow:
```
Step 1: Create objects
        ob1 → A instance
        ob2 → B instance
        ob3 → C instance
        ob4 → D instance

Step 2: disp(ob1, ob2, ob3, ob4) called
        ┌─────────────────────────────────────────────┐
        │ col array: [A@xxx, B@xxx, C@xxx, D@xxx]     │
        │ col.length = 4                              │
        └─────────────────────────────────────────────┘

Step 3: Print each - calls toString()
        Output:
        My Name is  A
        My Name is  B
        My Name is  C
        My Name is  D
        Using foreach loop
        My Name is  A
        My Name is  B
        My Name is  C
        My Name is  D
```

### getClass().getName() Explanation:
```java
// getClass() - returns runtime class of the object
// getName() - returns fully qualified class name as String

Object obj = new A();
obj.getClass();          // Returns Class<A>
obj.getClass().getName(); // Returns "A" (or "package.A" if in package)
```

---

## Rules and Restrictions

### Rule 1: Only ONE varargs per method
```java
void valid(int ...a)              // ✓ OK
void invalid(int ...a, int ...b)  // ✗ Error - multiple varargs
```

### Rule 2: Varargs MUST be the LAST parameter
```java
void valid(int x, int ...a)       // ✓ OK - varargs at end
void valid(String s, int ...a)    // ✓ OK - varargs at end
void invalid(int ...a, int x)     // ✗ Error - varargs not last
```

### Rule 3: Can pass array instead of individual values
```java
void disp(int ...nums)
{
    for(int n : nums) System.out.println(n);
}

// Both calls are valid:
disp(1, 2, 3);            // Individual values
disp(new int[]{1, 2, 3}); // Array
```

### Rule 4: Varargs with regular parameters
```java
void show(String prefix, int ...numbers)
{
    System.out.println(prefix);
    for(int n : numbers)
    {
        System.out.println(n);
    }
}

// Usage:
show("Numbers:", 1, 2, 3);  // prefix = "Numbers:", numbers = [1,2,3]
show("Empty:");              // prefix = "Empty:", numbers = []
```

---

## Code Examples with Flow

### Complete Example with Different Scenarios:

```java
public class VarargsComplete
{
    // Method 1: Basic int varargs
    static int sum(int ...nums)
    {
        int total = 0;
        for(int n : nums)
        {
            total += n;
        }
        return total;
    }
    
    // Method 2: Mixed parameters with varargs
    static void printAll(String label, Object ...items)
    {
        System.out.println("=== " + label + " ===");
        for(Object item : items)
        {
            System.out.println(" - " + item);
        }
    }
    
    public static void main(String args[])
    {
        // Test 1: No arguments
        System.out.println(sum());  // Output: 0
        
        // Test 2: Single argument
        System.out.println(sum(5));  // Output: 5
        
        // Test 3: Multiple arguments
        System.out.println(sum(1, 2, 3, 4, 5));  // Output: 15
        
        // Test 4: Array as argument
        int[] arr = {10, 20, 30};
        System.out.println(sum(arr));  // Output: 60
        
        // Test 5: Mixed types with Object varargs
        printAll("Shopping", "Apple", "Banana", "Orange");
        printAll("Numbers", 1, 2, 3);
        printAll("Mixed", "Hello", 42, 3.14, true);
    }
}
```

### Memory Visualization:
```
Call: sum(1, 2, 3, 4, 5)

Stack:
┌────────────────────────────────┐
│ main()                         │
│   ├── sum() called             │
│   │   └── nums = reference ────┼──► [1, 2, 3, 4, 5] in Heap
│   │       total = 15           │
│   └── returns 15               │
└────────────────────────────────┘

Heap:
┌────────────────────────────────┐
│ int[]: [1, 2, 3, 4, 5]         │
│ length: 5                      │
└────────────────────────────────┘
```

---

## Key Takeaways

1. **Varargs** allows passing 0 or more arguments
2. **Syntax**: `Type ...variableName`
3. **Internally treated as array** - use `.length` and indexing
4. **Must be last parameter** in method signature
5. **Only one varargs** per method allowed
6. **Object varargs** accepts any object type
7. **Can pass array** directly to varargs method
8. **Introduced in Java 5** (JDK 1.5)

---

*Previous: [04_Enums_in_Java.md](./04_Enums_in_Java.md)*
*Next: [06_Overloading_Rules.md](./06_Overloading_Rules.md)*
