# 📚 User-Defined Exceptions in Java

## Table of Contents
1. [Why Create Custom Exceptions](#why-create-custom-exceptions)
2. [Creating Checked Exceptions](#creating-checked-exceptions)
3. [Creating Unchecked Exceptions](#creating-unchecked-exceptions)
4. [Choosing Checked vs Unchecked](#choosing-checked-vs-unchecked)
5. [Adding Constructors](#adding-constructors)
6. [Code Examples with Flow](#code-examples-with-flow)

---

## Why Create Custom Exceptions

### When Standard Exceptions Don't Fit:
```
Built-in exceptions are GENERIC (NullPointerException, IOException).

Sometimes you need DOMAIN-SPECIFIC exceptions:
  • InvalidAccountException (banking)
  • InsufficientBalanceException (e-commerce)
  • UserNotFoundException (authentication)
  • InvalidAgeException (validation)
```

### Benefits of Custom Exceptions:
1. **More descriptive** - Clear what went wrong
2. **Domain-specific** - Matches business logic
3. **Better handling** - Can catch specific conditions
4. **Encapsulation** - Hide internal details

---

## Creating Checked Exceptions

To create a **checked exception**, extend `Exception`:

```java
// Line 1: Extend Exception for CHECKED exception
public class MyException extends Exception
{
    // Constructor with message
    public MyException(String message)
    {
        super(message);  // Pass message to Exception constructor
    }
}
```

### Complete Example:
```java
// Custom checked exception
class InvalidAgeException extends Exception
{
    InvalidAgeException(String message)
    {
        super(message);
    }
}

// Usage
class Voter
{
    void checkAge(int age) throws InvalidAgeException  // Must declare!
    {
        if(age < 18)
        {
            throw new InvalidAgeException("Age " + age + " is too young to vote");
        }
        System.out.println("Eligible to vote!");
    }
}

public class CheckedDemo
{
    public static void main(String args[])
    {
        Voter voter = new Voter();
        
        try  // Must handle checked exception!
        {
            voter.checkAge(16);
        }
        catch(InvalidAgeException e)
        {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

**Output:**
```
Error: Age 16 is too young to vote
```

---

## Creating Unchecked Exceptions

To create an **unchecked exception**, extend `RuntimeException`:

```java
// Line 1: Extend RuntimeException for UNCHECKED exception
public class MyException extends RuntimeException
{
    public MyException(String message)
    {
        super(message);
    }
}
```

### Complete Example:
```java
// Custom unchecked exception
class InvalidInputException extends RuntimeException
{
    InvalidInputException(String message)
    {
        super(message);
    }
}

// Usage - no throws declaration needed!
class Calculator
{
    int divide(int a, int b)  // No throws needed
    {
        if(b == 0)
        {
            throw new InvalidInputException("Cannot divide by zero");
        }
        return a / b;
    }
}

public class UncheckedDemo
{
    public static void main(String args[])
    {
        Calculator calc = new Calculator();
        
        // Optional to handle - unchecked
        int result = calc.divide(10, 0);  // Will throw at runtime
    }
}
```

**Output:**
```
Exception in thread "main" InvalidInputException: Cannot divide by zero
    at Calculator.divide(UncheckedDemo.java:12)
    at UncheckedDemo.main(UncheckedDemo.java:21)
```

---

## Choosing Checked vs Unchecked

### Decision Framework:
```
┌────────────────────────────────────────────────────────────────────┐
│           WHEN TO CREATE CHECKED vs UNCHECKED                     │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  CREATE CHECKED EXCEPTION when:                                    │
│  ├── Client CAN take corrective action                            │
│  ├── You WANT to force the client to handle it                    │
│  └── Recovery is possible and meaningful                          │
│                                                                    │
│  Examples:                                                         │
│  • InsufficientFundsException → retry with smaller amount         │
│  • FileNotFoundException → prompt user for different file          │
│  • NetworkTimeoutException → retry connection                      │
│                                                                    │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  CREATE UNCHECKED EXCEPTION when:                                  │
│  ├── Error is due to programming mistake                          │
│  ├── Client should NOT or CANNOT take corrective action           │
│  └── Exception indicates bug in code                              │
│                                                                    │
│  Examples:                                                         │
│  • InvalidStateException → fix the code                           │
│  • IllegalArgumentException → fix the calling code                │
│  • ConfigurationException → fix configuration                     │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Quick Decision Guide:

| Question | If YES | If NO |
|----------|--------|-------|
| Can client recover? | Checked | Unchecked |
| Should client be forced to handle? | Checked | Unchecked |
| Is it a programming error? | Unchecked | Checked |
| Can be avoided with simple check? | Unchecked | Checked |

---

## Adding Constructors

Custom exceptions should typically have multiple constructors:

```java
public class BusinessException extends Exception
{
    // Constructor 1: No arguments
    public BusinessException()
    {
        super();
    }
    
    // Constructor 2: Message only
    public BusinessException(String message)
    {
        super(message);
    }
    
    // Constructor 3: Message and cause
    public BusinessException(String message, Throwable cause)
    {
        super(message, cause);
    }
    
    // Constructor 4: Cause only
    public BusinessException(Throwable cause)
    {
        super(cause);
    }
}
```

### Using Cause (Exception Chaining):
```java
try
{
    readFile("data.txt");
}
catch(IOException e)
{
    // Wrap low-level exception in business exception
    throw new BusinessException("Failed to load data", e);
}
```

---

## Code Examples with Flow

### Complete Banking Example:

```java
// Custom checked exception for insufficient balance
class InsufficientBalanceException extends Exception
{
    private double currentBalance;
    private double withdrawAmount;
    
    InsufficientBalanceException(double balance, double amount)
    {
        super("Cannot withdraw " + amount + " from balance " + balance);
        this.currentBalance = balance;
        this.withdrawAmount = amount;
    }
    
    double getShortfall()
    {
        return withdrawAmount - currentBalance;
    }
}

// Custom unchecked exception for invalid account
class InvalidAccountException extends RuntimeException
{
    InvalidAccountException(String accountNumber)
    {
        super("Invalid account: " + accountNumber);
    }
}

// Bank account class
class BankAccount
{
    private String accountNumber;
    private double balance;
    
    BankAccount(String accountNumber, double balance)
    {
        if(accountNumber == null || accountNumber.isEmpty())
        {
            throw new InvalidAccountException(accountNumber);  // Unchecked
        }
        this.accountNumber = accountNumber;
        this.balance = balance;
    }
    
    void withdraw(double amount) throws InsufficientBalanceException  // Checked
    {
        if(amount > balance)
        {
            throw new InsufficientBalanceException(balance, amount);
        }
        balance -= amount;
        System.out.println("Withdrawn: " + amount + ", New balance: " + balance);
    }
}

public class BankingDemo
{
    public static void main(String args[])
    {
        // Test 1: Valid account, valid withdrawal
        BankAccount acc = new BankAccount("ACC001", 1000);
        
        try
        {
            acc.withdraw(500);   // Success
            acc.withdraw(700);   // Insufficient balance
        }
        catch(InsufficientBalanceException e)
        {
            System.out.println("Error: " + e.getMessage());
            System.out.println("Shortfall: " + e.getShortfall());
        }
        
        // Test 2: Invalid account (unchecked - no try-catch needed)
        // BankAccount invalid = new BankAccount(null, 500);  // Throws!
    }
}
```

### Output:
```
Withdrawn: 500, New balance: 500.0
Error: Cannot withdraw 700.0 from balance 500.0
Shortfall: 200.0
```

### Execution Flow:
```
Step 1: new BankAccount("ACC001", 1000)
        Account created successfully

Step 2: acc.withdraw(500)
        500 <= 1000 → OK
        Output: Withdrawn: 500, New balance: 500.0

Step 3: acc.withdraw(700)
        700 > 500 → Insufficient!
        throw new InsufficientBalanceException(500, 700)
        
Step 4: Exception caught
        Error: Cannot withdraw 700.0 from balance 500.0
        Shortfall: 200.0
```

---

## Key Takeaways

1. **Extend Exception** for checked exceptions
2. **Extend RuntimeException** for unchecked exceptions
3. **Checked** when client CAN and SHOULD take action
4. **Unchecked** when it's a programming error
5. **Add multiple constructors** for flexibility
6. **Use exception chaining** to preserve original cause
7. **Add custom properties** for additional error info

---

*Previous: [11_Throws_and_Throw.md](./11_Throws_and_Throw.md)*
*Next: [13_Advanced_Exception_Topics.md](./13_Advanced_Exception_Topics.md)*
