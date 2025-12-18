# 📚 Advanced Exception Topics in Java

## Table of Contents
1. [ARM - Automatic Resource Management](#arm---automatic-resource-management)
2. [Multi-Catch Block (Java 7+)](#multi-catch-block-java-7)
3. [Assertions](#assertions)
4. [NoClassDefFoundError vs ClassNotFoundException](#noclassdeffounderror-vs-classnotfoundexception)
5. [Code Examples with Flow](#code-examples-with-flow)

---

## ARM - Automatic Resource Management

**Automatic Resource Management (ARM)** is also known as **try-with-resources**. It was introduced in **Java 7**.

### What is Resource Management?
```
Resource Management means RELEASING resources once you use them.

Resources include:
  • File streams
  • Socket connections  
  • Database connections
  • Any object that holds external resources
```

### Before Java 7 (Explicit Resource Management):
```java
try
{
    FileInputStream fis = new FileInputStream("abc.txt");
    // code to read the file
}
catch(FileNotFoundException e)
{
    e.printStackTrace();
}
finally
{
    fis.close();  // Manual cleanup required!
}
```

### Java 7+ (Automatic Resource Management):
```java
// ARM block - resources declared in parentheses
try(FileInputStream fis = new FileInputStream("abc.txt"))
{
    // code to read the file
}
catch(FileNotFoundException e)
{
    e.printStackTrace();
}
// No finally needed! fis.close() is called automatically!
```

### How ARM Works Internally:
```
When you write:

try(FileInputStream fis = new FileInputStream("abc.txt"))
{
    // code
}

Compiler converts it to:

try
{
    FileInputStream fis = new FileInputStream("abc.txt");
    // code
}
finally
{
    fis.close();  // Compiler adds this!
}

The compiler provides the "finally" block with the close() statement.
That's why it's called "Automatic" Resource Management.
```

### Rules for ARM:

```
┌────────────────────────────────────────────────────────────────────┐
│                       ARM RULES                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. Resource must implement AutoCloseable or Closeable interface  │
│                                                                    │
│  2. Multiple resources can be declared (separated by semicolon)   │
│     try(Resource1 r1 = ...; Resource2 r2 = ...)                   │
│                                                                    │
│  3. Resources are closed in REVERSE order of declaration          │
│                                                                    │
│  4. Resource scope is limited to try block                        │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### AutoCloseable Interface:
```java
public interface AutoCloseable
{
    void close() throws Exception;
}

// Any class implementing this can be used in try-with-resources
```

### Complete ARM Example:
```java
import java.io.*;

public class ARMDemo
{
    public static void main(String args[])
    {
        // Multiple resources - closed in reverse order
        try(FileReader fr = new FileReader("input.txt");
            BufferedReader br = new BufferedReader(fr))
        {
            String line;
            while((line = br.readLine()) != null)
            {
                System.out.println(line);
            }
        }
        catch(IOException e)
        {
            System.out.println("Error: " + e.getMessage());
        }
        // br.close() called first (LIFO)
        // fr.close() called second
    }
}
```

---

## Multi-Catch Block (Java 7+)

You can catch **multiple exceptions in a single catch block** using the pipe `|` operator.

### Before Java 7:
```java
try
{
    // risky code
}
catch(IOException e)
{
    System.out.println("IO error: " + e);
}
catch(SQLException e)
{
    System.out.println("DB error: " + e);  // Duplicate code!
}
```

### Java 7+ (Multi-Catch):
```java
try
{
    // risky code
}
catch(IOException | SQLException e)  // Single catch for multiple types
{
    System.out.println("Error: " + e);
}
```

### Rules for Multi-Catch:
```
1. Exceptions must NOT have inheritance relationship
   catch(Exception | IOException e)  // ✗ Error - IOException is subclass

2. The exception variable is effectively FINAL
   catch(IOException | SQLException e)
   {
       e = new IOException();  // ✗ Error - cannot reassign
   }

3. Use pipe | to separate multiple exception types
```

### Examples:
```java
// Demo1.java - Basic multi-catch
try
{
    int arr[] = new int[5];
    arr[10] = 50;
}
catch(ArithmeticException | ArrayIndexOutOfBoundsException e)
{
    System.out.println("Error: " + e);
}

// Demo2.java - With inheritance check
try
{
    // code
}
catch(FileNotFoundException | IOException e)  // ✗ Error!
{
    // FileNotFoundException IS-A IOException
}

// Demo3.java - Correct usage
try
{
    // code
}
catch(SQLException | IOException e)  // ✓ OK - no inheritance
{
    System.out.println("Error: " + e);
}
```

---

## Assertions

**Assertions** are used to test assumptions in your code during development.

### What are Assertions?
```
┌────────────────────────────────────────────────────────────────────┐
│                       ASSERTIONS                                   │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  • Used to TEST the program during development                    │
│  • Assertions are DISABLED by default                             │
│  • Must be ENABLED to run (-ea flag)                              │
│                                                                    │
│  Advantage over System.out.println:                               │
│  • println statements must be removed/commented for production    │
│  • assert statements need NO changes - just disable them          │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Assert Syntax:
```java
// Simple assertion
assert condition;

// Assertion with message
assert condition : "Error message";
```

### Example: AssertDemo.java
```java
public class AssertDemo
{
    static int calculateDiscount(int price, int discount)
    {
        // Assert that discount is valid
        assert discount >= 0 && discount <= 100 : "Invalid discount: " + discount;
        
        int finalPrice = price - (price * discount / 100);
        
        // Assert result is valid
        assert finalPrice >= 0 : "Price cannot be negative";
        
        return finalPrice;
    }
    
    public static void main(String args[])
    {
        System.out.println(calculateDiscount(100, 20));  // 80
        System.out.println(calculateDiscount(100, 150)); // Assertion fails!
    }
}
```

### Running with Assertions:
```bash
# Compile normally
javac AssertDemo.java

# Run without assertions (default) - assertions ignored
java AssertDemo

# Run with assertions enabled
java -ea AssertDemo        # -ea = enable assertions
java -enableassertions AssertDemo

# Disable assertions (explicit)
java -da AssertDemo
```

### When Assertion Fails:
```
If assertion fails (condition is false):
  → AssertionError is thrown
  → Program crashes (if not caught)

Note: AssertionError is an Error, not Exception
      Should NOT be caught in normal code
```

---

## NoClassDefFoundError vs ClassNotFoundException

These are commonly confused. Here's the difference:

### ClassNotFoundException:
```
┌────────────────────────────────────────────────────────────────────┐
│               ClassNotFoundException                               │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Type: EXCEPTION (checked)                                         │
│                                                                    │
│  When: Class loaded DYNAMICALLY at runtime was not found          │
│                                                                    │
│  Cause: Class.forName(), ClassLoader.loadClass()                  │
│                                                                    │
│  Can be handled: YES                                               │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### NoClassDefFoundError:
```
┌────────────────────────────────────────────────────────────────────┐
│               NoClassDefFoundError                                 │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  Type: ERROR (unchecked)                                           │
│                                                                    │
│  When: Class was present at COMPILE time but missing at RUNTIME   │
│                                                                    │
│  Cause: .class file deleted after compilation, classpath issue    │
│                                                                    │
│  Can be handled: Usually NO (fix classpath)                        │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Comparison:

| Property | ClassNotFoundException | NoClassDefFoundError |
|----------|----------------------|---------------------|
| **Type** | Exception | Error |
| **Checked** | Yes | No |
| **When** | Dynamic loading | Runtime execution |
| **Cause** | Class.forName() fails | Missing .class file |
| **Recovery** | Possible | Usually not |

### Examples:
```java
// ClassNotFoundException
try
{
    Class<?> c = Class.forName("com.example.NonExistent");
}
catch(ClassNotFoundException e)
{
    System.out.println("Class not found: " + e.getMessage());
}

// NoClassDefFoundError
// 1. Compile: javac Main.java Helper.java
// 2. Delete Helper.class
// 3. Run: java Main
// Result: NoClassDefFoundError: Helper
```

---

## Code Examples with Flow

### Complete ARM Demo:
```java
import java.io.*;

// Custom resource implementing AutoCloseable
class MyResource implements AutoCloseable
{
    private String name;
    
    MyResource(String name)
    {
        this.name = name;
        System.out.println("Opening: " + name);
    }
    
    void doWork()
    {
        System.out.println("Working with: " + name);
    }
    
    @Override
    public void close()
    {
        System.out.println("Closing: " + name);
    }
}

public class CustomARMDemo
{
    public static void main(String args[])
    {
        try(MyResource r1 = new MyResource("Resource1");
            MyResource r2 = new MyResource("Resource2"))
        {
            r1.doWork();
            r2.doWork();
        }
        System.out.println("After try block");
    }
}
```

### Output:
```
Opening: Resource1
Opening: Resource2
Working with: Resource1
Working with: Resource2
Closing: Resource2      ← Closed in reverse order
Closing: Resource1      ← Closed last
After try block
```

### Flow:
```
Step 1: MyResource("Resource1") → "Opening: Resource1"
Step 2: MyResource("Resource2") → "Opening: Resource2"
Step 3: r1.doWork() → "Working with: Resource1"
Step 4: r2.doWork() → "Working with: Resource2"
Step 5: Exit try block - auto-close in REVERSE order
        r2.close() → "Closing: Resource2"
        r1.close() → "Closing: Resource1"
Step 6: Continue after try → "After try block"
```

---

## Key Takeaways

1. **ARM (try-with-resources)** - Automatic cleanup for AutoCloseable
2. **Multi-catch** - Single catch for multiple exceptions using `|`
3. **Assertions** - Testing tool, disabled by default
4. **ClassNotFoundException** - Dynamic loading failed (Exception)
5. **NoClassDefFoundError** - Compile-time class missing at runtime (Error)
6. **Resources closed in LIFO order** in ARM
7. **Enable assertions with -ea** flag

---

*Previous: [12_User_Defined_Exceptions.md](./12_User_Defined_Exceptions.md)*
*Next: [14_Overriding_and_Exceptions.md](./14_Overriding_and_Exceptions.md)*
