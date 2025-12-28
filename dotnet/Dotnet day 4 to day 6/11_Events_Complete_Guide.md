# Events in C# - Complete Guide

## 📚 Introduction

An **event** is a mechanism for a class to notify other classes when something of interest occurs. Events are built on delegates and implement the publisher-subscriber (observer) pattern.

---

## 🎯 Learning Objectives

- Understand the event pattern
- Declare and raise events
- Subscribe and unsubscribe from events
- Master event handlers and EventArgs

---

## 🔍 Publisher-Subscriber Pattern

```
┌─────────────────┐                    ┌─────────────────┐
│    PUBLISHER    │                    │   SUBSCRIBER    │
│   (Event Owner) │                    │  (Event Handler)│
├─────────────────┤                    ├─────────────────┤
│ Declares event  │                    │ Subscribes to   │
│ Raises event    │  ──────────────►   │ event (+= )     │
│                 │  Event notification │ Handles event   │
└─────────────────┘                    └─────────────────┘
                                       ┌─────────────────┐
                        ──────────────►│   SUBSCRIBER 2  │
                                       └─────────────────┘
```

---

## 💻 Code Examples

### Example 1: Basic Event Declaration and Handling

```csharp
using System;

// Step 1: Declare delegate for event
delegate void Notify();

// Publisher class
class ProcessBusinessLogic
{
    // Step 2: Declare event based on delegate
    public event Notify ProcessCompleted;
    
    public void StartProcess()
    {
        Console.WriteLine("Process Started...");
        // Simulate work
        System.Threading.Thread.Sleep(1000);
        Console.WriteLine("Process Completed!");
        
        // Step 3: Raise the event (notify subscribers)
        OnProcessCompleted();
    }
    
    // Protected method to raise event (best practice)
    protected virtual void OnProcessCompleted()
    {
        // Check if any subscribers exist
        if (ProcessCompleted != null)
        {
            ProcessCompleted();  // Invoke all subscribers
        }
        // Or use null-conditional operator:
        // ProcessCompleted?.Invoke();
    }
}

// Subscriber class
class Program
{
    static void Main()
    {
        ProcessBusinessLogic process = new ProcessBusinessLogic();
        
        // Step 4: Subscribe to event
        process.ProcessCompleted += Process_ProcessCompleted;
        process.ProcessCompleted += SendEmail;
        
        process.StartProcess();
    }
    
    // Event handlers
    static void Process_ProcessCompleted()
    {
        Console.WriteLine("Handler 1: Process completed notification received!");
    }
    
    static void SendEmail()
    {
        Console.WriteLine("Handler 2: Sending confirmation email...");
    }
}
```

#### Output:
```
Process Started...
Process Completed!
Handler 1: Process completed notification received!
Handler 2: Sending confirmation email...
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4 | `delegate void Notify();` | Delegate type for the event |
| 10 | `public event Notify ProcessCompleted;` | Event declaration using delegate |
| 23 | `protected virtual void OnProcessCompleted()` | Protected method to raise event safely |
| 26-29 | `if (ProcessCompleted != null)` | Check for subscribers before invoking |
| 43 | `process.ProcessCompleted += ...` | Subscribe to event (+= adds handler) |

---

### Example 2: Event with Data (EventArgs)

```csharp
using System;

// Custom EventArgs to pass data
class ProcessEventArgs : EventArgs
{
    public string Message { get; set; }
    public DateTime Timestamp { get; set; }
    
    public ProcessEventArgs(string msg)
    {
        Message = msg;
        Timestamp = DateTime.Now;
    }
}

// Delegate with sender and EventArgs
delegate void ProcessEventHandler(object sender, ProcessEventArgs e);

class ProcessBusinessLogic
{
    public event ProcessEventHandler ProcessCompleted;
    
    public void StartProcess()
    {
        Console.WriteLine("Process Started...");
        System.Threading.Thread.Sleep(500);
        
        // Raise event with data
        OnProcessCompleted(new ProcessEventArgs("Success"));
    }
    
    protected virtual void OnProcessCompleted(ProcessEventArgs e)
    {
        ProcessCompleted?.Invoke(this, e);
    }
}

class Program
{
    static void Main()
    {
        ProcessBusinessLogic process = new ProcessBusinessLogic();
        process.ProcessCompleted += HandleProcessCompleted;
        
        process.StartProcess();
    }
    
    static void HandleProcessCompleted(object sender, ProcessEventArgs e)
    {
        Console.WriteLine($"Received: {e.Message}");
        Console.WriteLine($"At: {e.Timestamp}");
        Console.WriteLine($"From: {sender.GetType().Name}");
    }
}
```

#### Output:
```
Process Started...
Received: Success
At: 12/28/2024 12:00:00 PM
From: ProcessBusinessLogic
```

---

### Example 3: Standard .NET Event Pattern

```csharp
using System;

class StockPriceChangedEventArgs : EventArgs
{
    public string Symbol { get; }
    public decimal OldPrice { get; }
    public decimal NewPrice { get; }
    
    public StockPriceChangedEventArgs(string symbol, decimal oldPrice, decimal newPrice)
    {
        Symbol = symbol;
        OldPrice = oldPrice;
        NewPrice = newPrice;
    }
}

class Stock
{
    private string symbol;
    private decimal price;
    
    // Standard event pattern using EventHandler<T>
    public event EventHandler<StockPriceChangedEventArgs> PriceChanged;
    
    public Stock(string symbol, decimal initialPrice)
    {
        this.symbol = symbol;
        this.price = initialPrice;
    }
    
    public decimal Price
    {
        get => price;
        set
        {
            if (price != value)
            {
                decimal oldPrice = price;
                price = value;
                OnPriceChanged(new StockPriceChangedEventArgs(symbol, oldPrice, price));
            }
        }
    }
    
    protected virtual void OnPriceChanged(StockPriceChangedEventArgs e)
    {
        PriceChanged?.Invoke(this, e);
    }
}

class StockMonitor
{
    public void Subscribe(Stock stock)
    {
        stock.PriceChanged += Stock_PriceChanged;
    }
    
    private void Stock_PriceChanged(object sender, StockPriceChangedEventArgs e)
    {
        if (e.NewPrice > e.OldPrice)
            Console.WriteLine($"📈 {e.Symbol}: ${e.OldPrice} → ${e.NewPrice} (+{e.NewPrice - e.OldPrice})");
        else
            Console.WriteLine($"📉 {e.Symbol}: ${e.OldPrice} → ${e.NewPrice} ({e.NewPrice - e.OldPrice})");
    }
}

class Program
{
    static void Main()
    {
        Stock msft = new Stock("MSFT", 300);
        StockMonitor monitor = new StockMonitor();
        
        monitor.Subscribe(msft);
        
        msft.Price = 310;
        msft.Price = 305;
        msft.Price = 320;
    }
}
```

#### Output:
```
📈 MSFT: $300 → $310 (+10)
📉 MSFT: $310 → $305 (-5)
📈 MSFT: $305 → $320 (+15)
```

---

### Example 4: Unsubscribing from Events

```csharp
using System;

delegate void MessageHandler(string msg);

class MessagePublisher
{
    public event MessageHandler MessageReceived;
    
    public void SendMessage(string msg)
    {
        Console.WriteLine($"Sending: {msg}");
        MessageReceived?.Invoke(msg);
    }
}

class Program
{
    static void Main()
    {
        MessagePublisher pub = new MessagePublisher();
        
        // Subscribe
        pub.MessageReceived += DisplayMessage;
        
        pub.SendMessage("Hello");  // Handler called
        
        // Unsubscribe
        pub.MessageReceived -= DisplayMessage;
        
        pub.SendMessage("Goodbye");  // Handler NOT called
    }
    
    static void DisplayMessage(string msg)
    {
        Console.WriteLine($"Received: {msg}");
    }
}
```

#### Output:
```
Sending: Hello
Received: Hello
Sending: Goodbye
```

---

### Example 5: Event vs Delegate - Access Restrictions

```csharp
using System;

delegate void MyDelegate();

class Publisher
{
    public MyDelegate PublicDelegate;  // Regular delegate
    public event MyDelegate PublicEvent;  // Event
    
    public void RaiseEvent()
    {
        PublicEvent?.Invoke();  // Only publisher can invoke
    }
}

class Program
{
    static void Main()
    {
        Publisher pub = new Publisher();
        
        // Delegate: Full access from outside
        pub.PublicDelegate = Handler;   // Can assign (=)
        pub.PublicDelegate += Handler;  // Can add (+=)
        pub.PublicDelegate();           // Can invoke directly!
        
        // Event: Restricted access
        // pub.PublicEvent = Handler;   // ERROR: Can only use += or -=
        pub.PublicEvent += Handler;     // Can add (+=) ✓
        // pub.PublicEvent();           // ERROR: Cannot invoke from outside!
        pub.RaiseEvent();               // Must use publisher's method
    }
    
    static void Handler() => Console.WriteLine("Handler called");
}
```

---

## 📊 Event vs Delegate Comparison

```
┌──────────────────────────────────────────────────────────────────┐
│              DELEGATE vs EVENT                                    │
├──────────────────────────────────────────────────────────────────┤
│                     │    DELEGATE    │       EVENT               │
├─────────────────────┼────────────────┼───────────────────────────┤
│ Assignment (=)      │      ✓         │   Only inside class       │
│ Add handler (+=)    │      ✓         │        ✓                  │
│ Remove handler (-=) │      ✓         │        ✓                  │
│ Invoke externally   │      ✓         │   ✗ (only publisher)     │
│ Null check needed   │     Yes        │       Yes                 │
│ Best for            │ Callbacks      │  Notifications            │
└─────────────────────┴────────────────┴───────────────────────────┘
```

---

## ⚡ Best Practices

| Practice | Example |
|----------|---------|
| Use `EventHandler<T>` | `public event EventHandler<MyEventArgs> MyEvent;` |
| Protected virtual raise method | `protected virtual void OnMyEvent(...)` |
| Null-conditional invoke | `MyEvent?.Invoke(this, args);` |
| Unsubscribe to prevent leaks | `obj.Event -= Handler;` |
| EventArgs for data | Derive from `EventArgs` class |

---

## ❌ Common Mistakes

### Mistake 1: Invoking event without null check
```csharp
ProcessCompleted();  // NullReferenceException if no subscribers!
ProcessCompleted?.Invoke();  // CORRECT
```

### Mistake 2: Memory leak - not unsubscribing
```csharp
// Subscribe
obj.Event += Handler;
// Forget to unsubscribe when done
// Object stays in memory because event holds reference
```

### Mistake 3: Using = instead of +=
```csharp
event.MyEvent = Handler;  // ERROR for events
event.MyEvent += Handler; // CORRECT
```

---

## 📝 Practice Questions

1. **Can you invoke an event from outside its declaring class?**
<details>
<summary>Answer</summary>
No. Events can only be invoked from within the class that declares them.
</details>

2. **What's the signature of EventHandler<T>?**
<details>
<summary>Answer</summary>
`void EventHandler<TEventArgs>(object sender, TEventArgs e)`
</details>

---

## 🔗 Related Topics
- [09_Delegates_Fundamentals.md](09_Delegates_Fundamentals.md) - Delegate basics
- [10_Multicast_Delegates.md](10_Multicast_Delegates.md) - Multicast behavior
- [12_Anonymous_Methods_Lambda.md](12_Anonymous_Methods_Lambda.md) - Lambda event handlers
