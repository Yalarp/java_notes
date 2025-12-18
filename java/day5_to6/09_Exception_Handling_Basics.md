# 📚 Exception Handling Basics in Java

## Table of Contents
1. [What is an Exception](#what-is-an-exception)
2. [Why Use Exception Handling](#why-use-exception-handling)
3. [Exception Handling Keywords](#exception-handling-keywords)
4. [Try-Catch Block](#try-catch-block)
5. [Multiple Catch Blocks](#multiple-catch-blocks)
6. [The finally Block](#the-finally-block)
7. [When finally Does NOT Execute](#when-finally-does-not-execute)
8. [Code Examples with Flow](#code-examples-with-flow)

---

## What is an Exception

An **exception** is an event that occurs during the execution of a program that **interrupts the normal flow** of the program's instructions.

### Key Concepts:
```
┌────────────────────────────────────────────────────────────────────┐
│                    WHAT IS AN EXCEPTION?                           │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • An ABNORMAL condition that disrupts program flow               │
│  • Represented as an OBJECT in Java                               │
│  • Contains information about the error:                          │
│    - Error type (class name)                                      │
│    - Error message                                                │
│    - Stack trace (where it occurred)                              │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### How Exceptions are Raised:
```
Exception can be raised by:

  a) JVM - Automatically when error occurs
     Example: ArrayIndexOutOfBoundsException, NullPointerException

  b) Application (Developer) - Explicitly using 'throw' keyword
     Example: throw new IllegalArgumentException("Invalid input");

When exception is raised, it happens in TWO steps:
  1) Instantiation of that particular exception class
  2) Throwing that exception (that instance) to the caller
```

---

## Why Use Exception Handling

### Problem with Traditional Error Handling:
```
In traditional programming, error detection, reporting, and 
handling often lead to CONFUSING code because programmers 
would use error codes inside the main logic.
```

### Benefits of Exception Handling:

| Benefit | Description |
|---------|-------------|
| **Readable** | Exceptions have meaningful names (FileNotFoundException, NullPointerException) |
| **Propagation** | Can propagate errors up the call stack |
| **Grouping** | Natural grouping through class hierarchy |
| **Separation** | Error handling code separated from main logic |

---

## Exception Handling Keywords

Java provides **five keywords** for exception handling:

| Keyword | Purpose |
|---------|---------|
| `try` | Block of code to monitor for exceptions |
| `catch` | Block to handle the exception |
| `finally` | Block that always executes (cleanup) |
| `throw` | Manually throw an exception |
| `throws` | Declare that method may throw exception |

---

## Try-Catch Block

The basic structure for handling exceptions:

```java
try
{
    // Code that may throw exception
}
catch(ExceptionType e)
{
    // Handle the exception
}
```

### Code Example: Example1.java (Without Exception Handling)
```java
public class Example1
{
    public static void main(String args[])
    {
        // Line 5: Create array of 4 elements (indices 0,1,2,3)
        int arr[] = new int[4];
        System.out.println("Array created");
        
        // Line 7: PROBLEM! Index 4 doesn't exist
        arr[4] = 10;  // Runtime Exception: ArrayIndexOutOfBoundsException
        
        // Line 8: This will NEVER execute!
        System.out.println("Array assigned");
    }
}
```

### Execution Flow:
```
Step 1: Array created with 4 elements
        Output: "Array created"

Step 2: arr[4] = 10; executed
        ├── Valid indices: 0, 1, 2, 3
        ├── Index 4 doesn't exist
        └── JVM throws ArrayIndexOutOfBoundsException

Step 3: Program terminates abnormally
        "Array assigned" NEVER printed
```

### Code Example: Example2.java (With Exception Handling)
```java
public class Example2
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        System.out.println("Array created");
        
        // Line 7-14: Try-catch block
        try
        {
            // Line 9: This may throw exception
            arr[4] = 10;
        }
        catch(ArrayIndexOutOfBoundsException ae)
        {
            // Line 13-14: Handle the exception
            // System.out.println(ae);  // Prints exception message
            ae.printStackTrace();       // Prints full stack trace
        }
        
        // Line 16: This WILL execute now!
        System.out.println("Array assigned");
    }
}
```

### Execution Flow:
```
Step 1: Array created
        Output: "Array created"

Step 2: try block entered
        arr[4] = 10; throws exception

Step 3: catch block executes
        printStackTrace() prints:
        java.lang.ArrayIndexOutOfBoundsException: Index 4 out of bounds for length 4
            at Example2.main(Example2.java:9)

Step 4: Program continues normally
        Output: "Array assigned"
```

### Exception Object Methods:

| Method | Description |
|--------|-------------|
| `getMessage()` | Returns error message |
| `printStackTrace()` | Prints stack trace to console |
| `toString()` | Returns class name + message |
| `getStackTrace()` | Returns array of StackTraceElement |

---

## Multiple Catch Blocks

You can have multiple catch blocks for different exception types.

### Code Example: Example3.java
```java
// One try, multiple catch blocks
public class Example3
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        Example6 e1 = null;  // null reference
        System.out.println("Array created");
        
        try
        {
            // Line 11: May throw ArrayIndexOutOfBoundsException
            arr[4] = 10;
            
            // Line 12: May throw NullPointerException
            e1.toString();
        }
        catch(ArrayIndexOutOfBoundsException ae) 
        {
            System.out.println(ae);
        }
        catch(NullPointerException ne)
        {
            System.out.println(ne);
        }
        
        System.out.println("Array assigned");
    }
}
```

### Execution Flow:
```
Step 1: Only the FIRST exception is caught
        arr[4] = 10; throws ArrayIndexOutOfBoundsException
        
Step 2: Jump to matching catch block
        catch(ArrayIndexOutOfBoundsException ae) handles it
        
Step 3: e1.toString() is SKIPPED (never reached)

Step 4: Program continues after catch blocks
```

### Rule: Most Specific First!

### Code Example: Example5.java
```java
/* When you define one try and multiple catch:
   The rule is MOST SPECIFIC catch block should 
   PRECEDE MOST GENERIC catch block.
*/
public class Example5
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        System.out.println("Array created");
        
        try
        {
            arr[4] = 10;
        }
        catch(ArrayIndexOutOfBoundsException ae)  // Specific FIRST
        {
            // If specific task needed for AIOOB
            System.out.println(ae);
        }
        catch(Exception ae)  // Generic LAST (catches everything else)
        {
            System.out.println(ae);
        }
        
        System.out.println("Array assigned");
    }
}
```

### Why This Order?
```
WRONG ORDER:
catch(Exception ae) { }               // Catches everything!
catch(ArrayIndexOutOfBoundsException ae) { }  // UNREACHABLE - Compile Error!

CORRECT ORDER:
catch(ArrayIndexOutOfBoundsException ae) { }  // Specific exception first
catch(Exception ae) { }               // Generic catch-all last
```

### Code Example: Example4.java (Generic Exception Catch)
```java
// The most generic catch block - catches ANY exception
public class Example4
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        System.out.println("Array created");
        
        try
        {
            arr[4] = 10;
        }
        catch(Exception ae)  // Catches ANY exception
        {
            System.out.println(ae);
        }
        
        System.out.println("Array assigned");
    }
}
```

---

## The finally Block

The `finally` block **always executes**, whether exception occurs or not.

### Code Example: Example6.java (Exception Occurs)
```java
public class Example6
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        System.out.println("Array created");
        
        try
        {
            arr[4] = 10;  // Exception thrown
        }
        catch(ArrayIndexOutOfBoundsException ae)
        {
            System.out.println("In catch\t" + ae);
        }
        finally
        {
            System.out.println("I am always printed");
        }
        
        System.out.println("Array assigned");
    }
}
```

### Output:
```
Array created
In catch    java.lang.ArrayIndexOutOfBoundsException: Index 4...
I am always printed
Array assigned
```

### Code Example: Example7.java (No Exception)
```java
/* finally{} block always executes whether or not exception is raised */
public class Example7
{
    public static void main(String args[])
    {
        int arr[] = new int[4];
        System.out.println("Array created");
        
        try
        {
            arr[3] = 10;  // Index 3 is valid - NO exception
        }
        catch(ArrayIndexOutOfBoundsException ae)
        {
            System.out.println("In catch\t" + ae);
        }
        finally
        {
            System.out.println("I am always printed");
        }
        
        System.out.println("Array assigned");
    }
}
```

### Output:
```
Array created
I am always printed
Array assigned
```

### Purpose of finally:
```
finally block is used to RELEASE RESOURCES such as:
  • File handles
  • Socket connections
  • Database connections

Since you CANNOT rely upon "finalize" method for cleanup,
finally block is the guaranteed place for cleanup code.

Syntax options:
  try { } catch { } finally { }   ✓ Full form
  try { } finally { }             ✓ Without catch
  try { } catch { }               ✓ Without finally
```

---

## When finally Does NOT Execute

There are only **two scenarios** where finally will not execute:

### Scenario 1: System.exit() is called

```java
try
{
    System.exit(0);  // JVM terminates immediately
}
finally
{
    // This will NOT execute
}
```

### Scenario 2: Exception in finally block itself

```java
public class Demo2
{
    int disp(int k)
    { 
        try
        {
            return 1;
        }
        catch(Exception ex)
        {
            return 2;
        }
        finally
        {
            String s = null;
            System.out.println(s.length());  // NullPointerException!
            return 3;  // Never reached
        }
    }
}
```

### Special Case: Return in finally

```java
public class Demo1
{
    int disp(int k)
    {
        try
        {
            return 1;  // Will be RETURNED if finally has no return
        }
        catch(Exception ex)
        {
            return 2;
        }
        finally
        {
            return 3;  // This OVERRIDES try/catch returns!
        }
    }
    
    public static void main(String args[])
    {
        Demo1 e = new Demo1();
        System.out.println(e.disp(5));  // Output: 3
    }
}
```

**Explanation:**
When `return` is given inside `finally`, compiler removes `return` statements from both `try` and `catch` blocks. The finally return always wins.

---

## Code Examples with Flow

### Complete Flow Diagram:

```
┌────────────────────────────────────────────────────────────────────┐
│                    EXCEPTION HANDLING FLOW                         │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  try {                                                             │
│      risky code                                                    │
│  }                                                                 │
│      │                                                             │
│      ├── No Exception ──────────────────┐                         │
│      │                                  │                          │
│      └── Exception Thrown ───┐          │                          │
│                              ▼          │                          │
│  catch(ExceptionType e) {    │          │                          │
│      handle exception        │          │                          │
│  }                           │          │                          │
│      │                       │          │                          │
│      └───────────────────────┴──────────┘                          │
│                              │                                     │
│                              ▼                                     │
│  finally {                                                         │
│      cleanup (ALWAYS executes)                                     │
│  }                                                                 │
│      │                                                             │
│      ▼                                                             │
│  Continue program execution                                        │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Memory/Execution Visualization:

```
Example2.java Execution:

Call Stack:
┌─────────────────────────────────┐
│ main()                          │
│   ├── arr[] created             │
│   ├── try block entered         │
│   ├── arr[4]=10 → EXCEPTION!    │
│   │   └── ArrayIndexOutOf...    │
│   ├── Jump to catch block       │
│   ├── ae.printStackTrace()      │
│   ├── finally executes          │
│   └── Continue after try-catch  │
└─────────────────────────────────┘
```

---

## Key Takeaways

1. **Exception** - Abnormal condition that disrupts program flow
2. **try** - Block containing risky code
3. **catch** - Block handling specific exception
4. **finally** - Block that always executes (for cleanup)
5. **Order matters** - Most specific catch first
6. **Exception is an object** - Contains type, message, trace
7. **finally always runs** - Except System.exit() or exception in finally
8. **Return in finally** - Overrides try/catch returns

---

*Previous: [08_Garbage_Collection.md](./08_Garbage_Collection.md)*
*Next: [10_Exception_Hierarchy.md](./10_Exception_Hierarchy.md)*
