# 📚 Garbage Collection in Java

## Table of Contents
1. [Introduction to Garbage Collection](#introduction-to-garbage-collection)
2. [How Objects Become Eligible for GC](#how-objects-become-eligible-for-gc)
3. [The System.gc() Method](#the-systemgc-method)
4. [The finalize() Method](#the-finalize-method)
5. [GC Request vs Execution](#gc-request-vs-execution)
6. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Garbage Collection

**Garbage Collection (GC)** is the automatic memory management process in Java where the JVM reclaims memory occupied by objects that are no longer reachable.

### Key Concepts:
```
┌────────────────────────────────────────────────────────────────────┐
│                    GARBAGE COLLECTION                              │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Automatic memory management by JVM                              │
│  • Frees developers from manual memory deallocation                │
│  • Runs in background (daemon thread)                              │
│  • Cannot be forced - only requested                               │
│  • Java has NO delete operator (unlike C/C++)                      │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Benefits:
1. **No memory leaks** (mostly)
2. **No dangling pointers**
3. **Simplified code** - no manual free/delete
4. **Safer programs**

---

## How Objects Become Eligible for GC

An object becomes eligible for garbage collection when it is **no longer reachable** from any live thread.

### Ways to Make Object Unreachable:

**1. Setting Reference to null:**
```java
MyClass obj = new MyClass();  // Object created
obj = null;                    // Object now unreachable, eligible for GC
```

**2. Reassigning Reference:**
```java
MyClass obj = new MyClass();  // Object 1 created
obj = new MyClass();          // Object 1 abandoned, Object 2 assigned
                              // Object 1 eligible for GC
```

**3. Object Created Inside Method:**
```java
void method()
{
    MyClass obj = new MyClass();  // Local reference
}  // Method ends, obj goes out of scope, object eligible for GC
```

**4. Island of Isolation:**
```java
class MyClass
{
    MyClass ref;
}

MyClass a = new MyClass();
MyClass b = new MyClass();
a.ref = b;  // a references b
b.ref = a;  // b references a

a = null;
b = null;
// Now a and b reference each other but are unreachable
// Both are eligible for GC (island of isolation)
```

---

## The System.gc() Method

The `gc()` method is used to **request** garbage collection.

### Two Ways to Request GC:

```java
// Way 1: Using System class
System.gc();

// Way 2: Using Runtime class
Runtime.getRuntime().gc();
```

### What's Inside System.gc():
```java
// Inside System class:
public static void gc()
{
    Runtime.getRuntime().gc();
}
```

**Explanation:**
- `System.gc()` is a **convenience method**
- It internally calls `Runtime.getRuntime().gc()`
- Both are equivalent

### Important Note:
```
gc() is a REQUEST, not a command!

• JVM may or may not execute GC immediately
• JVM decides when to actually run GC
• You cannot force GC to run
```

---

## The finalize() Method

The `finalize()` method is called by the garbage collector **before reclaiming the object's memory**.

### Method Signature:
```java
protected void finalize() throws Throwable
{
    // Cleanup code
}
```

### Code Example: MyClass.java
```java
public class MyClass
{
    // Line 3-7: Override finalize method
    @Override
    protected void finalize()
    {
        System.out.println("in finalize method");
    }
    
    public static void main(String args[])
    {
        System.out.println("in main");
        
        // Line 11: Create object
        MyClass m = new MyClass();
        
        // Line 12: Make object eligible for GC
        m = null;
        
        // Line 13: Request garbage collection
        System.gc();
        
        // Line 14-17: Print numbers
        for(int i = 0; i < 10; i++)
        {
            System.out.println("Hello\t" + i);
        }
        
        System.out.println("done");
    }
}
```

### Possible Output:
```
in main
Hello   0
Hello   1
in finalize method    <-- May appear anywhere during loop
Hello   2
Hello   3
Hello   4
Hello   5
Hello   6
Hello   7
Hello   8
Hello   9
done
```

### Execution Flow:
```
Step 1: main() starts
        "in main" printed

Step 2: new MyClass() - object created in heap

Step 3: m = null - object now unreachable

Step 4: System.gc() - REQUEST for garbage collection
        GC runs in background (daemon thread)

Step 5: For loop continues (main thread)
        GC may run anytime during this

Step 6: When GC runs, it:
        ├── Identifies unreachable object
        ├── Calls finalize() on it
        └── Reclaims memory

Note: finalize() timing is UNPREDICTABLE!
```

---

## GC Request vs Execution

### Key Understanding:
```
┌────────────────────────────────────────────────────────────────────┐
│                   GC REQUEST vs EXECUTION                          │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  System.gc() or Runtime.getRuntime().gc()                          │
│  ↓                                                                 │
│  This is a REQUEST to JVM                                          │
│  ↓                                                                 │
│  JVM MAY or MAY NOT execute GC immediately                         │
│  ↓                                                                 │
│  JVM decides based on:                                             │
│    • Current heap usage                                            │
│    • Memory pressure                                               │
│    • GC algorithm in use                                           │
│    • JVM implementation                                            │
│                                                                    │
│  CANNOT FORCE GC - ONLY REQUEST IT                                 │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Why We Cannot Force GC:
1. GC is controlled by JVM, not by programmer
2. JVM optimizes when to run GC
3. Forcing GC would hurt performance
4. GC runs when JVM decides it's optimal

---

## Code Examples with Flow

### Complete GC Demo:

```java
class Resource
{
    String name;
    
    Resource(String name)
    {
        this.name = name;
        System.out.println("Resource created: " + name);
    }
    
    @Override
    protected void finalize()
    {
        System.out.println("Resource finalized: " + name);
    }
}

public class GCDemo
{
    public static void main(String args[])
    {
        System.out.println("Creating resources...");
        
        // Create objects and make them eligible for GC
        Resource r1 = new Resource("DB Connection");
        Resource r2 = new Resource("File Handle");
        Resource r3 = new Resource("Network Socket");
        
        // Make eligible for GC
        r1 = null;
        r2 = null;
        r3 = null;
        
        System.out.println("Requesting GC...");
        System.gc();
        
        // Give GC some time (NOT guaranteed to work)
        try { Thread.sleep(1000); } catch(Exception e) {}
        
        System.out.println("Program ending...");
    }
}
```

### Possible Output:
```
Creating resources...
Resource created: DB Connection
Resource created: File Handle
Resource created: Network Socket
Requesting GC...
Resource finalized: Network Socket
Resource finalized: File Handle
Resource finalized: DB Connection
Program ending...
```

### Memory Visualization:
```
Before null assignments:
┌──────────────────────────────────────────────────────────────────┐
│  HEAP                                                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │ DB Connection   │  │ File Handle     │  │ Network Socket  │  │
│  └────────▲────────┘  └────────▲────────┘  └────────▲────────┘  │
│           │                    │                    │            │
└───────────┼────────────────────┼────────────────────┼────────────┘
            │                    │                    │
         r1                   r2                   r3
         (Stack)             (Stack)             (Stack)

After null assignments:
┌──────────────────────────────────────────────────────────────────┐
│  HEAP                                                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │ DB Connection   │  │ File Handle     │  │ Network Socket  │  │
│  │ (UNREACHABLE)   │  │ (UNREACHABLE)   │  │ (UNREACHABLE)   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
         r1 = null           r2 = null           r3 = null
         (Stack)             (Stack)             (Stack)
```

---

## Deprecation Notice

> **Important:** As of Java 9, the `finalize()` method is **deprecated**.

### Why Deprecated:
1. **Unpredictable** execution timing
2. **Performance overhead**
3. **Can delay GC**
4. **Not guaranteed** to be called

### Alternatives:
- Use **try-with-resources** (AutoCloseable)
- Use **Cleaner** class (Java 9+)
- Explicit `close()` methods

```java
// Modern approach - try-with-resources
try (FileInputStream fis = new FileInputStream("file.txt"))
{
    // Use resource
}  // Automatically closed here
```

---

## Key Takeaways

1. **GC is automatic** - JVM manages memory
2. **System.gc()** - Requests GC, doesn't force it
3. **finalize()** - Called before reclaiming memory (deprecated)
4. **Objects eligible for GC** when unreachable
5. **Cannot force GC** - Only request it
6. **GC timing is unpredictable**
7. **Use try-with-resources** for resource cleanup (modern approach)

---

*Previous: [07_Inner_Classes.md](./07_Inner_Classes.md)*
*Next: [09_Exception_Handling_Basics.md](./09_Exception_Handling_Basics.md)*
