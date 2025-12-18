# 📚 Exception Hierarchy in Java

## Table of Contents
1. [The Throwable Class](#the-throwable-class)
2. [Error vs Exception](#error-vs-exception)
3. [Checked vs Unchecked Exceptions](#checked-vs-unchecked-exceptions)
4. [Common Exception Types](#common-exception-types)
5. [Can We catch(Object)?](#can-we-catchobject)
6. [Code Examples with Flow](#code-examples-with-flow)

---

## The Throwable Class

All exceptions and errors in Java are subclasses of `java.lang.Throwable`.

### Hierarchy:
```
                    java.lang.Object
                          │
                          ▼
                  java.lang.Throwable
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
    java.lang.Error              java.lang.Exception
          │                               │
          ▼                               ▼
    [Errors]                    [Exceptions]
    - OutOfMemoryError          - IOException
    - StackOverflowError        - SQLException
    - VirtualMachineError       - RuntimeException
    - etc.                            │
                                      ▼
                              [RuntimeExceptions]
                              - NullPointerException
                              - ArrayIndexOutOfBoundsException
                              - ClassCastException
                              - etc.
```

---

## Error vs Exception

### Error:
```
┌────────────────────────────────────────────────────────────────────┐
│                           ERROR                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Represents SERIOUS problems                                     │
│  • Usually UNRECOVERABLE                                           │
│  • Related to JVM/system issues                                    │
│  • Application should NOT try to catch                            │
│                                                                    │
│  Examples:                                                         │
│  • OutOfMemoryError    - JVM ran out of memory                    │
│  • StackOverflowError  - Too deep recursion                       │
│  • VirtualMachineError - JVM internal problem                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Exception:
```
┌────────────────────────────────────────────────────────────────────┐
│                         EXCEPTION                                  │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Represents conditions that can be HANDLED                       │
│  • Usually RECOVERABLE                                             │
│  • Related to application/logic issues                            │
│  • Application SHOULD handle these                                │
│                                                                    │
│  Examples:                                                         │
│  • IOException           - File/network problems                  │
│  • SQLException          - Database problems                      │
│  • NullPointerException  - Programming errors                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Comparison Table:

| Property | Error | Exception |
|----------|-------|-----------|
| **Severity** | Serious, often fatal | Recoverable |
| **Cause** | JVM/System problems | Application/Logic issues |
| **Handling** | Should NOT catch | Should handle |
| **Recovery** | Usually impossible | Usually possible |
| **Examples** | OutOfMemoryError, StackOverflowError | IOException, SQLException |

---

## Checked vs Unchecked Exceptions

### Visual Hierarchy:
```
                         Exception
                             │
        ┌────────────────────┴────────────────────┐
        │                                         │
        ▼                                         ▼
[UNCHECKED EXCEPTIONS]                   [CHECKED EXCEPTIONS]
   RuntimeException                         IOException
                                           SQLException
        │                                   ClassNotFoundException
 Due to programmer's                        etc.
 logical mistakes
                                     These can be raised in
        │                            a logically correct program
 They can be avoided using
 simple "if...else"                         │
                                     Java ENFORCES programmer
        │                            to handle these
 Java does NOT enforce
 programmer to handle

Examples:                            Examples:
├── NullPointerException            ├── FileNotFoundException
├── NumberFormatException           ├── EOFException
├── ArrayIndexOutOfBoundsException  ├── SQLException
└── ClassCastException              └── InterruptedException
```

### Key Differences:

| Checked Exceptions | Unchecked Exceptions |
|-------------------|---------------------|
| Must be handled or declared | No requirement to handle |
| Compiler forces handling | Compiler doesn't check |
| Extends `Exception` (not `RuntimeException`) | Extends `RuntimeException` |
| Cannot be avoided with simple checks | Can be avoided with if-else |
| Example: `IOException` | Example: `NullPointerException` |

### When to Use Which:
```
CHECKED Exception:
  Use when the caller CAN and SHOULD take corrective action
  Example: File not found → prompt user for different file

UNCHECKED Exception:
  Use when error is due to programming mistake
  Example: Null pointer → fix the code, don't catch it
```

---

## Common Exception Types

### Unchecked Exceptions (RuntimeException):

| Exception | Cause |
|-----------|-------|
| `NullPointerException` | Calling method on null reference |
| `ArrayIndexOutOfBoundsException` | Invalid array index |
| `ClassCastException` | Invalid type casting |
| `ArithmeticException` | Division by zero |
| `NumberFormatException` | Invalid number format string |
| `IllegalArgumentException` | Invalid method argument |
| `IllegalStateException` | Method called at wrong time |

### Checked Exceptions:

| Exception | Cause |
|-----------|-------|
| `IOException` | I/O operation failure |
| `FileNotFoundException` | File doesn't exist |
| `SQLException` | Database operation failure |
| `ClassNotFoundException` | Class not found at runtime |
| `InterruptedException` | Thread interrupted |

---

## Can We catch(Object)?

### Question: Will this code compile?
```java
try
{
    // some code
}
catch(Object e)  // Can we use Object?
{
    
}
```

### Answer: NO, it will NOT compile!

### Explanation:
```
If "catch(Object)" was allowed, then people could write:

    throw new String("hello");     // ✗ String is not Throwable
    throw new Integer(20);         // ✗ Integer is not Throwable
    throw new Sample();            // ✗ Sample is not Throwable

The RULE is:
    Along with "throw" you can ONLY have a class of type "Throwable"

Therefore, catch block can ONLY catch Throwable or its subclasses.
```

### Valid Catch Types:
```java
catch(Throwable t) { }          // ✓ Catches everything
catch(Exception e) { }          // ✓ Catches all exceptions
catch(RuntimeException re) { }  // ✓ Catches runtime exceptions
catch(IOException ioe) { }      // ✓ Catches specific exception

catch(Object obj) { }           // ✗ Compilation Error!
catch(String str) { }           // ✗ Compilation Error!
```

---

## Code Examples with Flow

### Understanding Checked vs Unchecked:

```java
import java.io.*;

public class ExceptionTypeDemo
{
    // Method 1: Unchecked - no handling required
    void riskyMethod1()
    {
        int[] arr = new int[3];
        arr[5] = 10;  // ArrayIndexOutOfBoundsException
        // No compile error - unchecked
    }
    
    // Method 2: Checked - must handle or declare
    void riskyMethod2() throws IOException  // Must declare!
    {
        FileReader fr = new FileReader("nonexistent.txt");
        // Would cause FileNotFoundException (checked)
    }
    
    // Method 3: Handling checked exception
    void riskyMethod3()
    {
        try
        {
            FileReader fr = new FileReader("nonexistent.txt");
        }
        catch(FileNotFoundException e)  // Must handle!
        {
            System.out.println("File not found");
        }
    }
    
    public static void main(String args[])
    {
        ExceptionTypeDemo demo = new ExceptionTypeDemo();
        
        // Unchecked: No requirement to handle
        // demo.riskyMethod1();  // Compiles without try-catch
        
        // Checked: Must handle or propagate
        try
        {
            demo.riskyMethod2();
        }
        catch(IOException e)
        {
            e.printStackTrace();
        }
    }
}
```

### NoClassDefFoundError vs ClassNotFoundException:

| NoClassDefFoundError | ClassNotFoundException |
|---------------------|----------------------|
| **Type**: Error | **Type**: Exception (Checked) |
| Class was present at compile time but missing at runtime | Class loaded dynamically not found |
| **When**: Running a program | **When**: Class.forName(), loadClass() |
| Cannot recover | Can be handled |

```java
// ClassNotFoundException example
try
{
    Class.forName("com.nonexistent.MyClass");  // Throws ClassNotFoundException
}
catch(ClassNotFoundException e)
{
    System.out.println("Class not found");
}

// NoClassDefFoundError - cannot catch (Error)
// Happens when .class file is deleted after compilation
```

---

## Key Takeaways

1. **Throwable** is the root of all exceptions and errors
2. **Error** - Serious, unrecoverable, don't catch
3. **Exception** - Recoverable, should handle
4. **Checked** - Compiler enforces handling (extends Exception)
5. **Unchecked** - No compile-time checking (extends RuntimeException)
6. **catch(Object)** - Not allowed, must be Throwable or subclass
7. **Unchecked** = Programming errors (can be avoided)
8. **Checked** = External issues (must be handled)

---

*Previous: [09_Exception_Handling_Basics.md](./09_Exception_Handling_Basics.md)*
*Next: [11_Throws_and_Throw.md](./11_Throws_and_Throw.md)*
