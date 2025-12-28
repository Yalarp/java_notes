# Exception Handling in C#

## 📚 Introduction

**Exception handling** provides a structured way to detect and handle runtime errors, preventing abnormal program termination. C# uses `try`, `catch`, `throw`, and `finally` keywords for exception management.

---

## 🎯 Learning Objectives

- Master try-catch-finally blocks
- Understand exception hierarchy
- Create custom exceptions
- Learn best practices for exception handling

---

## 🔍 Exception Class Hierarchy

```
                    ┌───────────────┐
                    │   Exception   │
                    └───────┬───────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
┌─────────▼─────────┐ ┌─────▼────────┐ ┌─────▼────────────┐
│ SystemException   │ │ApplicationException│ │ Your Exceptions   │
└─────────┬─────────┘ └──────────────┘ └──────────────────┘
          │
    ┌─────┴─────┬────────────┬────────────────┐
    │           │            │                │
┌───▼────┐ ┌────▼────┐ ┌─────▼─────┐ ┌────────▼────────┐
│NullRef │ │IndexOut │ │DivideBy   │ │ArgumentException│
│Exception│ │OfRange  │ │Zero       │ │                 │
└────────┘ └─────────┘ └───────────┘ └─────────────────┘
```

---

## 💻 Code Examples

### Example 1: Basic Exception Handling

```csharp
using System;

class Program
{
    static void Main()
    {
        int[] nums = new int[4];
        
        try
        {
            Console.WriteLine("Before exception is generated.");
            
            // Generate an index out-of-bounds exception
            for (int i = 0; i < 10; i++)
            {
                nums[i] = i;
                Console.WriteLine($"nums[{i}]: {nums[i]}");
            }
            
            Console.WriteLine("This won't be displayed");
        }
        catch (IndexOutOfRangeException e)
        {
            Console.WriteLine("Index out-of-bounds! " + e.Message);
        }
        
        Console.WriteLine("After catch statement.");
    }
}
```

#### Output:
```
Before exception is generated.
nums[0]: 0
nums[1]: 1
nums[2]: 2
nums[3]: 3
Index out-of-bounds! Index was outside the bounds of the array.
After catch statement.
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 9 | `try { ... }` | Encloses code that might throw exception |
| 14 | `nums[i] = i;` | Throws exception when i=4 (array size is 4) |
| 19 | `Console.WriteLine("This won't...");` | Never executes - exception already thrown |
| 21 | `catch (IndexOutOfRangeException e)` | Catches specific exception type |
| 25 | `Console.WriteLine("After catch...");` | Executes - program continues after catch |

---

### Example 2: Multiple Catch Blocks

```csharp
using System;

class Program
{
    static void Main()
    {
        int[] numer = { 4, 8, 16, 32, 64, 128, 256, 512 };
        int[] denom = { 2, 0, 4, 4, 0, 8 };
        
        for (int i = 0; i < numer.Length; i++)
        {
            try
            {
                Console.WriteLine($"{numer[i]} / {denom[i]} = {numer[i] / denom[i]}");
            }
            catch (DivideByZeroException)
            {
                Console.WriteLine("Cannot divide by zero!");
            }
            catch (IndexOutOfRangeException)
            {
                Console.WriteLine("No matching element in denom!");
            }
        }
    }
}
```

#### Output:
```
4 / 2 = 2
Cannot divide by zero!
16 / 4 = 4
32 / 4 = 8
Cannot divide by zero!
128 / 8 = 16
No matching element in denom!
No matching element in denom!
```

---

### Example 3: Catch-All Handler

```csharp
using System;

class Program
{
    static void Main()
    {
        try
        {
            // Code that might throw various exceptions
            int[] arr = null;
            Console.WriteLine(arr.Length);  // NullReferenceException
        }
        catch (Exception e)  // Catches ALL exceptions
        {
            Console.WriteLine($"An error occurred: {e.Message}");
            Console.WriteLine($"Exception type: {e.GetType().Name}");
        }
        
        // Alternative: parameterless catch
        try
        {
            throw new Exception("Test");
        }
        catch  // Catches everything (even non-Exception types in mixed assemblies)
        {
            Console.WriteLine("Something went wrong!");
        }
    }
}
```

---

### Example 4: The Finally Block

```csharp
using System;

class Program
{
    static void Main()
    {
        FileStream fs = null;
        
        try
        {
            fs = new FileStream("test.txt", FileMode.Open);
            // Read file...
        }
        catch (FileNotFoundException)
        {
            Console.WriteLine("File not found!");
        }
        finally
        {
            // ALWAYS executes - whether exception occurs or not
            if (fs != null)
            {
                fs.Close();
                Console.WriteLine("File closed in finally block.");
            }
        }
        
        Console.WriteLine("Program continues...");
    }
}
```

**Key Point**: `finally` block executes:
- After try block completes normally
- After catch block handles exception
- Even if exception is not caught
- Even if return statement is in try

---

### Example 5: Throwing Exceptions

```csharp
using System;

class BankAccount
{
    private double balance;
    
    public BankAccount(double initial)
    {
        if (initial < 0)
            throw new ArgumentException("Initial balance cannot be negative");
        balance = initial;
    }
    
    public void Withdraw(double amount)
    {
        if (amount <= 0)
            throw new ArgumentException("Amount must be positive");
        
        if (amount > balance)
            throw new InvalidOperationException("Insufficient funds");
        
        balance -= amount;
    }
    
    public double Balance => balance;
}

class Program
{
    static void Main()
    {
        try
        {
            BankAccount account = new BankAccount(100);
            account.Withdraw(150);  // Throws InvalidOperationException
        }
        catch (ArgumentException ex)
        {
            Console.WriteLine($"Argument error: {ex.Message}");
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine($"Operation error: {ex.Message}");
        }
    }
}
```

#### Output:
```
Operation error: Insufficient funds
```

---

### Example 6: Rethrowing Exceptions

```csharp
using System;

class Program
{
    static void Method1()
    {
        try
        {
            Method2();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Method1 caught: " + ex.Message);
            throw;  // Rethrow - preserves stack trace
        }
    }
    
    static void Method2()
    {
        try
        {
            throw new InvalidOperationException("Original error");
        }
        catch (Exception ex)
        {
            Console.WriteLine("Method2 caught: " + ex.Message);
            throw;  // Rethrow to Method1
        }
    }
    
    static void Main()
    {
        try
        {
            Method1();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Main caught: " + ex.Message);
            Console.WriteLine("Stack trace:\n" + ex.StackTrace);
        }
    }
}
```

---

### Example 7: Custom Exception Class

```csharp
using System;

// Custom exception for insufficient balance
public class InsufficientBalanceException : Exception
{
    public double CurrentBalance { get; }
    public double RequestedAmount { get; }
    
    public InsufficientBalanceException()
        : base("Insufficient balance for this transaction.")
    {
    }
    
    public InsufficientBalanceException(string message)
        : base(message)
    {
    }
    
    public InsufficientBalanceException(double balance, double amount)
        : base($"Cannot withdraw {amount}. Current balance: {balance}")
    {
        CurrentBalance = balance;
        RequestedAmount = amount;
    }
    
    public InsufficientBalanceException(string message, Exception inner)
        : base(message, inner)
    {
    }
}

class SavingsAccount
{
    private double balance;
    private const double MIN_BALANCE = 1000;
    
    public SavingsAccount(double initial) => balance = initial;
    
    public void Withdraw(double amount)
    {
        if (balance - amount < MIN_BALANCE)
        {
            throw new InsufficientBalanceException(balance, amount);
        }
        balance -= amount;
    }
}

class Program
{
    static void Main()
    {
        SavingsAccount account = new SavingsAccount(1500);
        
        try
        {
            account.Withdraw(1000);  // Would leave balance below 1000
        }
        catch (InsufficientBalanceException ex)
        {
            Console.WriteLine(ex.Message);
            Console.WriteLine($"Current: {ex.CurrentBalance}, Requested: {ex.RequestedAmount}");
        }
    }
}
```

#### Output:
```
Cannot withdraw 1000. Current balance: 1500
Current: 1500, Requested: 1000
```

---

### Example 8: Exception Filters (C# 6+)

```csharp
using System;

class Program
{
    static void Main()
    {
        try
        {
            throw new InvalidOperationException("Error code: 404");
        }
        catch (InvalidOperationException ex) when (ex.Message.Contains("404"))
        {
            Console.WriteLine("Handled 404 error");
        }
        catch (InvalidOperationException ex) when (ex.Message.Contains("500"))
        {
            Console.WriteLine("Handled 500 error");
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine("Handled other InvalidOperationException");
        }
    }
}
```

---

## 📊 Exception Handling Flow

```
try
{
    // Code that might throw
    statement1;
    statement2;  ← Exception thrown here
    statement3;  ← NOT executed
}
catch (SpecificException ex)
{
    // Handle specific exception
}
catch (Exception ex)
{
    // Handle any other exception
}
finally
{
    // ALWAYS runs (cleanup)
}
// Program continues here (if exception was handled)
```

---

## ⚡ Common Exception Types

| Exception | Cause |
|-----------|-------|
| `NullReferenceException` | Accessing member on null object |
| `IndexOutOfRangeException` | Array index out of bounds |
| `DivideByZeroException` | Integer division by zero |
| `InvalidOperationException` | Invalid state for operation |
| `ArgumentException` | Invalid argument passed |
| `ArgumentNullException` | Null passed where not allowed |
| `FileNotFoundException` | File not found |
| `FormatException` | Invalid format for parse |

---

## ❌ Common Mistakes

### Mistake 1: Empty catch block
```csharp
catch (Exception) { }  // BAD - hides errors!
```

### Mistake 2: Catching Exception too early
```csharp
catch (Exception) { }  // Catches TOO MUCH
catch (SpecificException) { }  // Never reached!
```

### Mistake 3: Using throw ex instead of throw
```csharp
throw ex;  // Resets stack trace - BAD
throw;     // Preserves stack trace - GOOD
```

---

## 📝 Practice Questions

1. **Does finally run if catch throws an exception?**
<details>
<summary>Answer</summary>
Yes! Finally always runs, even if the catch block throws.
</details>

2. **What's wrong with: `catch (Exception) { } catch (InvalidOperationException) { }`**
<details>
<summary>Answer</summary>
The second catch is unreachable. More specific exceptions must come before general ones.
</details>

---

## 🔗 Related Topics
- [13_Memory_Management_GC.md](13_Memory_Management_GC.md) - IDisposable and cleanup
- [16_File_Handling_IO.md](16_File_Handling_IO.md) - File exceptions
