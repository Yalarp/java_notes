# Single Responsibility Principle (SRP) in C#

## 📚 Introduction

The Single Responsibility Principle states that a class should have only one reason to change. Each class should focus on doing one thing well. This is the foundation of maintainable, testable code.

---

## 🎯 Learning Objectives

- Understand what "one responsibility" means
- Identify SRP violations
- Refactor code to follow SRP

---

## 📖 Theory: What is a Responsibility?

```
┌────────────────────────────────────────────────────────────────┐
│             Single Responsibility Principle                     │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  "A class should have only ONE reason to change"               │
│                                                                 │
│  Responsibility = Reason to change = Axis of change            │
│                                                                 │
│  Examples of Responsibilities:                                  │
│  • Data persistence (saving to database)                       │
│  • Business calculations (computing values)                    │
│  • User interface (formatting for display)                     │
│  • Logging (recording events)                                  │
│  • Validation (checking rules)                                 │
│  • Email notification (sending messages)                       │
│                                                                 │
│  Each of these should be in a SEPARATE class!                  │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## ❌ Code Example 1: Violating SRP

```csharp
// ❌ BAD: Invoice class has MULTIPLE responsibilities
public class Invoice
{
    public long InvAmount { get; set; }
    public DateTime InvDate { get; set; }
    public string CustomerEmail { get; set; }
    
    // Responsibility 1: Invoice logic
    public void AddInvoice()
    {
        // Database insert logic here
        Console.WriteLine("Invoice added to database");
    }
    
    // Responsibility 2: Logging
    public void LogInfo(string info)
    {
        // Write to log file
        File.AppendAllText("log.txt", $"{DateTime.Now}: INFO - {info}\n");
    }
    
    public void LogError(string message, Exception ex)
    {
        // Write error to log file
        File.AppendAllText("log.txt", $"{DateTime.Now}: ERROR - {message}\n");
    }
    
    // Responsibility 3: Sending email
    public void SendEmail()
    {
        // Email sending logic
        Console.WriteLine($"Email sent to {CustomerEmail}");
    }
    
    // Responsibility 4: Report generation
    public void GeneratePDF()
    {
        // PDF generation logic
        Console.WriteLine("PDF invoice generated");
    }
}
```

### Problems with This Design:

```
┌────────────────────────────────────────────────────────────────┐
│                    WHY THIS IS BAD                              │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Too many reasons to change:                                │
│     • Change logging format? Modify Invoice class              │
│     • Change email provider? Modify Invoice class              │
│     • Change PDF library? Modify Invoice class                 │
│                                                                 │
│  2. Testing is difficult:                                       │
│     • Can't test invoice logic without file system             │
│     • Can't test without email configuration                   │
│                                                                 │
│  3. Code reuse is impossible:                                   │
│     • Other classes can't use this logging                     │
│     • Email logic tied to Invoice                              │
│                                                                 │
│  4. Teams step on each other:                                   │
│     • Developer A modifies logging                              │
│     • Developer B modifies email                                │
│     • Merge conflicts!                                         │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## ✅ Code Example 2: Applying SRP

### Step 1: Create ILogger Interface and Implementation

```csharp
// Logger is responsible ONLY for logging
public interface ILogger
{
    void Info(string info);
    void Debug(string info);
    void Error(string message, Exception ex);
}

public class Logger : ILogger
{
    private readonly string _logFilePath;
    
    public Logger()
    {
        _logFilePath = "application.log";
        // Initialize log file
    }
    
    public void Info(string info)
    {
        WriteToFile($"INFO: {info}");
    }
    
    public void Debug(string info)
    {
        WriteToFile($"DEBUG: {info}");
    }
    
    public void Error(string message, Exception ex)
    {
        WriteToFile($"ERROR: {message} - {ex.Message}");
    }
    
    private void WriteToFile(string message)
    {
        File.AppendAllText(_logFilePath, 
            $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} - {message}\n");
    }
}
```

### Step 2: Create MailSender Class

```csharp
// MailSender is responsible ONLY for sending emails
public class MailSender
{
    public string EmailFrom { get; set; }
    public string EmailTo { get; set; }
    public string EmailSubject { get; set; }
    public string EmailBody { get; set; }
    
    public void SendEmail()
    {
        // Email sending logic using SMTP
        Console.WriteLine($"Sending email from {EmailFrom} to {EmailTo}");
        Console.WriteLine($"Subject: {EmailSubject}");
        // SmtpClient configuration and sending...
    }
}
```

### Step 3: Create Refactored Invoice Class

```csharp
// Invoice class now has ONLY ONE responsibility:
// Managing invoice data and operations
public class Invoice
{
    public long InvAmount { get; set; }
    public DateTime InvDate { get; set; }
    public string CustomerEmail { get; set; }
    
    // Dependencies are injected
    private readonly ILogger _logger;
    private readonly MailSender _emailSender;
    
    // Constructor injection
    public Invoice(ILogger logger, MailSender emailSender)
    {
        _logger = logger;
        _emailSender = emailSender;
    }
    
    public void AddInvoice()
    {
        try
        {
            _logger.Info("AddInvoice method started");
            
            // Only invoice-specific logic here
            // Database insert logic
            Console.WriteLine("Invoice added to database");
            
            // Delegate email to MailSender
            _emailSender.EmailFrom = "billing@company.com";
            _emailSender.EmailTo = CustomerEmail;
            _emailSender.EmailSubject = "New Invoice Created";
            _emailSender.EmailBody = $"Invoice for ${InvAmount} dated {InvDate}";
            _emailSender.SendEmail();
            
            _logger.Info("AddInvoice completed successfully");
        }
        catch (Exception ex)
        {
            _logger.Error("Error adding invoice", ex);
            throw;
        }
    }
    
    public void DeleteInvoice()
    {
        try
        {
            _logger.Info($"Delete Invoice started at {DateTime.Now}");
            // Delete logic here
        }
        catch (Exception ex)
        {
            _logger.Error("Error deleting invoice", ex);
            throw;
        }
    }
}
```

### Step 4: Using the Classes

```csharp
class Program
{
    static void Main(string[] args)
    {
        // Create dependencies
        ILogger logger = new Logger();
        MailSender emailSender = new MailSender();
        
        // Inject into Invoice
        Invoice invoice = new Invoice(logger, emailSender)
        {
            InvAmount = 5000,
            InvDate = DateTime.Now,
            CustomerEmail = "customer@example.com"
        };
        
        invoice.AddInvoice();
    }
}
```

---

## 📊 Before vs After Comparison

```
┌────────────────────────────────────────────────────────────────┐
│  BEFORE SRP                    AFTER SRP                       │
├────────────────────────────┬───────────────────────────────────┤
│                            │                                   │
│  ┌─────────────────────┐   │  ┌──────────────┐                │
│  │     Invoice         │   │  │   Invoice    │                │
│  ├─────────────────────┤   │  ├──────────────┤                │
│  │ + AddInvoice()      │   │  │ + AddInvoice │ ──→ uses       │
│  │ + DeleteInvoice()   │   │  │ + Delete...  │      ↓         │
│  │ + LogInfo()         │   │  └──────────────┘      │         │
│  │ + LogError()        │   │                         │         │
│  │ + SendEmail()       │   │  ┌──────────────┐      │         │
│  │ + GeneratePDF()     │   │  │   ILogger    │ ←────┤         │
│  └─────────────────────┘   │  ├──────────────┤      │         │
│                            │  │ + Info()     │      │         │
│  One class, 4 reasons      │  │ + Debug()    │      │         │
│  to change                 │  │ + Error()    │      │         │
│                            │  └──────────────┘      │         │
│                            │                         │         │
│                            │  ┌──────────────┐      │         │
│                            │  │  MailSender  │ ←────┘         │
│                            │  ├──────────────┤                │
│                            │  │ + SendEmail()│                │
│                            │  └──────────────┘                │
│                            │                                   │
│                            │  Each class = 1 reason to change │
└────────────────────────────┴───────────────────────────────────┘
```

---

## 📊 Benefits of SRP

| Benefit | Description |
|---------|-------------|
| **Easier Testing** | Test each class independently |
| **Better Reuse** | Logger can be used anywhere |
| **Simpler Changes** | Change email logic in one place |
| **Parallel Development** | Different devs work on different classes |
| **Clearer Code** | Each class has one clear purpose |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **One responsibility** per class
2. **Delegation** - Let other classes handle their jobs
3. **Dependency Injection** - Pass dependencies, don't create them
4. **Interfaces** - Use for abstraction and testability
5. **Cohesion** - Everything in a class should be related

---

## 📝 Interview Questions

1. **What is Single Responsibility Principle?**
   - A class should have only one reason to change
   - Each class focuses on one job/responsibility

2. **How do you identify SRP violations?**
   - Class has multiple unrelated methods
   - Changes to one feature require modifying unrelated code
   - Hard to name the class (does too many things)

3. **How does SRP relate to Dependency Injection?**
   - SRP separates concerns into classes
   - DI connects those classes together

---

## 🔗 Next Topic
Next: [31_Composition_Over_Inheritance.md](./31_Composition_Over_Inheritance.md) - Composition Pattern
