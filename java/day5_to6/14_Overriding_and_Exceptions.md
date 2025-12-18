# 📚 Overriding and Exception Rules in Java

## Table of Contents
1. [Overview of Overriding Rules](#overview-of-overriding-rules)
2. [Exception Rules in Overriding](#exception-rules-in-overriding)
3. [Rule 1: No Exception Declaration](#rule-1-no-exception-declaration)
4. [Rule 2: Same Exception](#rule-2-same-exception)
5. [Rule 3: Subclass Exception](#rule-3-subclass-exception)
6. [Rule 4: Cannot Declare Broader Exception](#rule-4-cannot-declare-broader-exception)
7. [Why These Rules Exist](#why-these-rules-exist)
8. [Code Examples with Flow](#code-examples-with-flow)

---

## Overview of Overriding Rules

When overriding a method, these rules must be followed:

```
┌────────────────────────────────────────────────────────────────────┐
│                    OVERRIDING RULES                                │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. Arguments must be SAME                                         │
│     (otherwise it becomes overloading, not overriding)            │
│                                                                    │
│  2. Return type can be CO-VARIANT                                  │
│     (same type or subclass)                                       │
│                                                                    │
│  3. Access modifier must be SAME or MORE accessible               │
│     (private → default → protected → public)                      │
│                                                                    │
│  4. Checked exception rules (this document)                       │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Exception Rules in Overriding

### The Three Rules:

| Rule | Description |
|------|-------------|
| **Rule A** | Overriding method MAY NOT declare any checked exception |
| **Rule B** | Overriding method CAN declare same exception OR its subclass |
| **Rule C** | Overriding method CANNOT declare exception NOT declared by overridden method |

### Visual Summary:
```
Overridden (Parent):  void disp() throws IOException

Overriding (Child) can:
  ✓ void disp()                      → No exception
  ✓ void disp() throws IOException   → Same exception
  ✓ void disp() throws EOFException  → Subclass exception
  ✗ void disp() throws Exception     → Broader exception (ERROR!)
  ✗ void disp() throws SQLException  → Different exception (ERROR!)
```

---

## Rule 1: No Exception Declaration

**Overriding method may NOT declare any checked exception.**

```java
class Base
{
    public void disp() throws IOException
    {
        // May throw IOException
    }
}

class Sub extends Base
{
    // ✓ VALID - No exception declared
    public void disp()
    {
        // Does not throw any exception
    }
}
```

### Why This Works:
```
main()
{
    Base ref = new Sub();  // Upcasting
    ref.disp();            // Which disp() is called?
}

Compiler checks:
├── Does Base have disp()? YES
├── Is it accessible? YES
├── Does it throw checked exception? YES - IOException
└── Caller must handle or declare IOException

try
{
    ref.disp();  // Compiler satisfied
}
catch(IOException ie)
{
    ie.printStackTrace();
}

At RUNTIME:
├── Late binding occurs (not final, not static)
├── Sub's disp() is called
└── Sub's disp() throws NO exception
    → catch block is ready but not used
    → NO PROBLEM!
```

---

## Rule 2: Same Exception

**Overriding method CAN declare the same checked exception.**

```java
class Base
{
    public void disp() throws IOException
    {
        // May throw IOException
    }
}

class Sub extends Base
{
    // ✓ VALID - Same exception declared
    public void disp() throws IOException
    {
        // May throw IOException
    }
}
```

### Why This Works:
```
main()
{
    Base ref = new Sub();
    
    try
    {
        ref.disp();  // Compiler checks Base.disp() signature
    }
    catch(IOException ie)  // Handler for IOException
    {
        ie.printStackTrace();
    }
}

At RUNTIME:
├── Sub's disp() is called
├── If it throws IOException
└── catch(IOException) handles it
    → PERFECT MATCH!
```

---

## Rule 3: Subclass Exception

**Overriding method CAN declare subclass of the declared exception.**

```java
class Base
{
    public void disp() throws IOException  // Parent exception
    {
        // May throw IOException
    }
}

class Sub extends Base
{
    // ✓ VALID - Subclass exception (EOFException extends IOException)
    public void disp() throws EOFException
    {
        // May throw EOFException (which IS-A IOException)
    }
}
```

### Exception Hierarchy:
```
IOException
    ├── FileNotFoundException
    ├── EOFException         ← Used in child
    └── ...
```

### Why This Works:
```
main()
{
    Base ref = new Sub();
    
    try
    {
        ref.disp();
    }
    catch(IOException ie)  // Catches IOException and ALL subclasses
    {
        ie.printStackTrace();
    }
}

At RUNTIME:
├── Sub's disp() is called
├── If it throws EOFException
└── catch(IOException) CAN catch EOFException
    (because EOFException IS-A IOException)
    → NO PROBLEM!
```

---

## Rule 4: Cannot Declare Broader Exception

**Overriding method CANNOT declare exception NOT declared by overridden method.**

### Case A: Broader Exception
```java
class Base
{
    public void disp() throws IOException
    {
        // May throw IOException
    }
}

class Sub extends Base
{
    // ✗ COMPILATION ERROR!
    public void disp() throws Exception  // Exception is BROADER than IOException
    {
        // May throw Exception
    }
}
```

### Case B: No Exception in Parent
```java
class Base
{
    public void disp()  // No exception declared
    {
        // Clean method
    }
}

class Sub extends Base
{
    // ✗ COMPILATION ERROR!
    public void disp() throws Exception  // Parent declares nothing
    {
        // Cannot add new checked exception
    }
}
```

### Why This Rules Exist:
```
PROBLEM SCENARIO (if allowed):

class Base
{
    void disp() throws IOException { }
}

class Sub extends Base
{
    void disp() throws Exception { }  // Hypothetically allowed
}

main()
{
    Base ref = new Sub();  // Upcasting
    
    try
    {
        ref.disp();  // Compiler checks Base.disp() → IOException
    }
    catch(IOException ie)  // Handler for IOException only
    {
        ie.printStackTrace();
    }
}

At RUNTIME:
├── Sub's disp() is called (late binding)
├── Sub throws Exception (not IOException)
├── catch(IOException) CANNOT catch Exception
│   (because Exception is NOT-A IOException)
└── PROGRAM CRASHES! 💥

This is why Java prevents it at COMPILE time.
```

---

## Why These Rules Exist

### The Core Principle:
```
┌────────────────────────────────────────────────────────────────────┐
│                    THE REASONING                                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  When using base class reference to call overridden method:       │
│                                                                    │
│  Base ref = new Sub();                                             │
│  ref.disp();                                                       │
│                                                                    │
│  COMPILER only sees Base.disp() signature                         │
│  RUNTIME calls Sub.disp() (late binding)                          │
│                                                                    │
│  If Sub.disp() throws something Base.disp() didn't declare:       │
│  → The catch block (designed for Base.disp()) won't handle it     │
│  → Program crashes unexpectedly                                    │
│                                                                    │
│  Java prevents this at compile time by enforcing these rules.     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Summary of What's Allowed:

```
Parent declares: throws IOException

Child can declare:
┌─────────────────────────────────────┬──────────┬──────────────────┐
│ Child Declaration                   │ Allowed? │ Reason           │
├─────────────────────────────────────┼──────────┼──────────────────┤
│ throws IOException                  │ ✓ YES    │ Same exception   │
│ throws EOFException                 │ ✓ YES    │ Subclass         │
│ throws FileNotFoundException        │ ✓ YES    │ Subclass         │
│ (no throws)                         │ ✓ YES    │ More restrictive │
│ throws Exception                    │ ✗ NO     │ Broader          │
│ throws SQLException                 │ ✗ NO     │ Unrelated        │
└─────────────────────────────────────┴──────────┴──────────────────┘
```

---

## Code Examples with Flow

### Complete Example:

```java
import java.io.*;

class Base
{
    public void read() throws IOException
    {
        System.out.println("Base read - may throw IOException");
    }
    
    public void write() throws IOException
    {
        System.out.println("Base write - may throw IOException");
    }
    
    public void close()  // No exception
    {
        System.out.println("Base close - no exception");
    }
}

class Sub extends Base
{
    // Rule 1: No exception - VALID
    @Override
    public void read()
    {
        System.out.println("Sub read - no exception");
    }
    
    // Rule 3: Subclass exception - VALID
    @Override
    public void write() throws EOFException
    {
        System.out.println("Sub write - throws EOFException");
    }
    
    // Rule 4: Cannot add exception - INVALID (commented out)
    // @Override
    // public void close() throws IOException  // ✗ ERROR!
    // {
    //     System.out.println("Sub close");
    // }
}

public class OverridingExceptionDemo
{
    public static void main(String args[])
    {
        Base ref = new Sub();  // Upcasting
        
        try
        {
            ref.read();   // Calls Sub.read() - no exception
            ref.write();  // Calls Sub.write() - may throw EOFException
            ref.close();  // Calls Sub.close() - no exception
        }
        catch(IOException e)  // Handles IOException and all subclasses
        {
            System.out.println("Caught: " + e);
        }
        
        System.out.println("Program completed");
    }
}
```

### Output:
```
Sub read - no exception
Sub write - throws EOFException
Base close - no exception
Program completed
```

### Execution Flow:
```
Step 1: Base ref = new Sub()
        ref type: Base (compile-time)
        ref object: Sub (runtime)

Step 2: ref.read()
        Compiler: Checks Base.read() → throws IOException
        Runtime: Calls Sub.read() → no exception
        Result: Works fine

Step 3: ref.write()
        Compiler: Checks Base.write() → throws IOException
        Runtime: Calls Sub.write() → may throw EOFException
        Result: catch(IOException) can handle EOFException

Step 4: ref.close()
        Compiler: Checks Base.close() → no exception
        Runtime: Calls Base.close() (not overridden in Sub for this)
        Result: Works fine

Step 5: Program completes normally
```

---

## Key Takeaways

1. **Same or narrower** - Child can throw same or subclass exception
2. **No broader** - Child cannot throw broader exception
3. **No new exceptions** - If parent has none, child cannot add
4. **Compiler checks parent** - At compile time, parent signature is checked
5. **Runtime calls child** - At runtime, child method is executed
6. **Catch must match** - Handler must be able to catch what's thrown
7. **Rules protect runtime** - Prevent unexpected crashes

---

*Previous: [13_Advanced_Exception_Topics.md](./13_Advanced_Exception_Topics.md)*
*This completes the JavaSE Day 5-6 Notes!*
