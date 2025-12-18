# 📚 Throws and Throw in Java

## Table of Contents
1. [The throw Keyword](#the-throw-keyword)
2. [The throws Keyword](#the-throws-keyword)
3. [Handle vs Declare Rule](#handle-vs-declare-rule)
4. [Exception Propagation](#exception-propagation)
5. [Throws with Checked Exceptions](#throws-with-checked-exceptions)
6. [Code Examples with Flow](#code-examples-with-flow)

---

## The throw Keyword

The `throw` keyword is used to **explicitly throw an exception** (raise an exception manually).

### Syntax:
```java
throw new ExceptionType("message");
```

### Key Points:
```
┌────────────────────────────────────────────────────────────────────┐
│                    throw KEYWORD                                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Used to RAISE an exception explicitly                          │
│  • Must throw a Throwable object (or subclass)                    │
│  • Followed by an instance of exception                           │
│  • Causes immediate jump to exception handler                      │
│                                                                    │
│  Syntax:                                                           │
│    throw new ExceptionType("error message");                      │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Example:
```java
void validateAge(int age)
{
    if(age < 0)
    {
        // Explicitly throw exception
        throw new IllegalArgumentException("Age cannot be negative");
    }
    System.out.println("Valid age: " + age);
}
```

### What Happens When You Throw:
```
throw new RuntimeException("error");

Two steps occur:
  1) INSTANTIATION: new RuntimeException("error") creates exception object
  2) THROWING: That object is thrown to the caller
```

---

## The throws Keyword

The `throws` keyword is used to **declare** that a method may throw an exception.

### Syntax:
```java
returnType methodName() throws ExceptionType1, ExceptionType2
{
    // method body
}
```

### Key Points:
```
┌────────────────────────────────────────────────────────────────────┐
│                    throws KEYWORD                                  │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Used to DECLARE exception                                       │
│  • Part of method signature                                       │
│  • Tells caller: "This method might throw this exception"         │
│  • Caller must then HANDLE or DECLARE the exception               │
│                                                                    │
│  What is "declaring" exception?                                   │
│    Propagating it to the caller and making it caller's           │
│    responsibility to "handle or declare"                          │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Difference: throw vs throws

| throw | throws |
|-------|--------|
| **Raises** exception | **Declares** exception |
| Used with exception **instance** | Used with exception **class** |
| Inside method body | In method signature |
| Followed by `new Exception()` | Followed by `Exception` |
| Only one exception at a time | Can list multiple exceptions |

### Example:
```java
// throw - inside method body, with instance
void method1()
{
    throw new IOException("Error occurred");  // ✗ Compile error - checked!
}

// throws - in method signature, with class name
void method2() throws IOException
{
    throw new IOException("Error occurred");  // ✓ OK - declared
}
```

---

## Handle vs Declare Rule

For **checked exceptions**, you must either **HANDLE** or **DECLARE** them.

### Handle (try-catch):
```java
void readFile()
{
    try
    {
        FileReader fr = new FileReader("file.txt");
        // Read file
    }
    catch(FileNotFoundException e)
    {
        System.out.println("File not found!");
    }
}
```

### Declare (throws):
```java
void readFile() throws FileNotFoundException
{
    FileReader fr = new FileReader("file.txt");
    // Exception propagated to caller
}
```

### Visual Flow:
```
┌────────────────────────────────────────────────────────────────────┐
│                    HANDLE vs DECLARE                               │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Checked Exception Occurs                                          │
│            │                                                       │
│            ▼                                                       │
│  ┌─────────────────────┐                                          │
│  │ You must choose:    │                                          │
│  └─────────┬───────────┘                                          │
│            │                                                       │
│   ┌────────┴────────┐                                             │
│   │                 │                                              │
│   ▼                 ▼                                              │
│  HANDLE           DECLARE                                          │
│  (try-catch)      (throws)                                        │
│   │                 │                                              │
│   ▼                 ▼                                              │
│  Handle here      Pass to caller                                  │
│                   (caller must handle/declare)                    │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Exception Propagation

When an exception is thrown and not caught, it **propagates up the call stack**.

### Example:
```java
public class PropagationDemo
{
    void method3() throws IOException
    {
        throw new IOException("Error in method3");
    }
    
    void method2() throws IOException
    {
        method3();  // Propagates exception from method3
    }
    
    void method1()
    {
        try
        {
            method2();  // Finally handled here
        }
        catch(IOException e)
        {
            System.out.println("Caught: " + e.getMessage());
        }
    }
    
    public static void main(String args[])
    {
        new PropagationDemo().method1();
    }
}
```

### Propagation Flow:
```
┌─────────────────────────────────────────────────────────────────┐
│                    EXCEPTION PROPAGATION                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  main()                                                         │
│    │                                                            │
│    └── calls method1()                                          │
│          │                                                      │
│          └── calls method2()                                    │
│                │                                                │
│                └── calls method3()                              │
│                      │                                          │
│                      └── throws IOException                     │
│                            │                                    │
│                            ▲                                    │
│                      propagates to method2                      │
│                            │                                    │
│                            ▲                                    │
│                      propagates to method1                      │
│                            │                                    │
│                            ▲                                    │
│                      CAUGHT in method1's catch block            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Throws with Checked Exceptions

### Checked Exception - Must Handle or Declare:
```java
import java.io.*;

class CheckedDemo
{
    // Method declares it might throw IOException
    void readFile() throws IOException
    {
        FileReader fr = new FileReader("test.txt");
        BufferedReader br = new BufferedReader(fr);
        String line = br.readLine();
        br.close();
    }
    
    void caller()
    {
        // Option 1: Handle
        try
        {
            readFile();
        }
        catch(IOException e)
        {
            System.out.println("Error reading file");
        }
    }
    
    // Option 2: Declare
    void callerAlternative() throws IOException
    {
        readFile();  // Propagate to MY caller
    }
}
```

### Unchecked Exception - No Requirement:
```java
class UncheckedDemo
{
    // No throws needed for RuntimeException
    void riskyMethod()
    {
        throw new RuntimeException("Something went wrong");
    }
    
    void caller()
    {
        // No requirement to handle or declare
        riskyMethod();  // May crash at runtime
    }
}
```

---

## Code Examples with Flow

### Complete Example:

```java
import java.io.*;

public class ThrowThrowsDemo
{
    // Method 1: Using throw to raise exception
    static void checkAge(int age)
    {
        if(age < 0)
        {
            // throw: raise exception explicitly
            throw new IllegalArgumentException("Age cannot be negative: " + age);
        }
        if(age < 18)
        {
            throw new IllegalArgumentException("Must be 18 or older: " + age);
        }
        System.out.println("Age accepted: " + age);
    }
    
    // Method 2: Using throws to declare checked exception
    static void readConfig(String path) throws FileNotFoundException
    {
        // May throw FileNotFoundException (checked)
        FileReader fr = new FileReader(path);
        System.out.println("File opened: " + path);
    }
    
    public static void main(String args[])
    {
        // Test 1: throw with unchecked (no handling required)
        try
        {
            checkAge(-5);
        }
        catch(IllegalArgumentException e)
        {
            System.out.println("Invalid age: " + e.getMessage());
        }
        
        // Test 2: throws with checked (must handle or declare)
        try
        {
            readConfig("config.properties");
        }
        catch(FileNotFoundException e)
        {
            System.out.println("Config file not found!");
        }
        
        System.out.println("Program continues...");
    }
}
```

### Output:
```
Invalid age: Age cannot be negative: -5
Config file not found!
Program continues...
```

### Flow Visualization:
```
main() starts
    │
    ├── checkAge(-5) called
    │   ├── age < 0 → TRUE
    │   └── throw new IllegalArgumentException(...)
    │       │
    │       └── Exception propagates to caller
    │           │
    │           └── Caught in main's catch block
    │               Output: "Invalid age: ..."
    │
    ├── readConfig("config.properties") called
    │   ├── new FileReader(...) throws FileNotFoundException
    │   └── Exception propagates to caller (declared with throws)
    │       │
    │       └── Caught in main's catch block
    │           Output: "Config file not found!"
    │
    └── "Program continues..."
```

---

## Key Takeaways

1. **throw** - Raises exception (with instance)
2. **throws** - Declares exception (in signature)
3. **Checked exceptions** - Must handle or declare
4. **Unchecked exceptions** - No requirement
5. **Propagation** - Unhandled exceptions go up call stack
6. **Handle** - Use try-catch
7. **Declare** - Use throws, pass to caller

---

*Previous: [10_Exception_Hierarchy.md](./10_Exception_Hierarchy.md)*
*Next: [12_User_Defined_Exceptions.md](./12_User_Defined_Exceptions.md)*
