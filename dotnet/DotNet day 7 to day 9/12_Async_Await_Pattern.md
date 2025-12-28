# Async/Await Pattern in C#

## 📚 Introduction

The `async` and `await` keywords simplify asynchronous programming by allowing you to write asynchronous code that looks synchronous. Introduced in C# 5.0, they work with the Task Parallel Library to provide clean, readable async code.

---

## 🎯 Learning Objectives

- Understand async/await keywords and their purpose
- Learn how async methods transform at compile time
- Master best practices for asynchronous programming

---

## 📖 Theory: How Async/Await Works

```
┌────────────────────────────────────────────────────────────────┐
│                    Async/Await Flow                             │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  async Task DoWorkAsync()                                       │
│  {                                                              │
│      Console.WriteLine("Start");    ← Runs synchronously       │
│      await Task.Delay(1000);        ← Returns control to caller│
│      Console.WriteLine("End");      ← Continues after await    │
│  }                                                              │
│                                                                 │
│  When await is hit:                                            │
│  1. Method returns Task to caller immediately                  │
│  2. Caller continues with other work                           │
│  3. When awaited task completes, method resumes                │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

### Key Concepts

| Keyword | Purpose |
|---------|---------|
| **async** | Marks method as asynchronous |
| **await** | Suspends execution until Task completes |
| **Task** | Return type for async methods (no value) |
| **Task<T>** | Return type for async methods (with value) |

---

## 💻 Code Example 1: Basic Async/Await

```csharp
using System;
using System.Threading.Tasks;

class Program
{
    static async Task Main(string[] args)  // async Main (C# 7.1+)
    {
        Console.WriteLine("Before calling async method");
        
        await DoWorkAsync();  // Wait for completion
        
        Console.WriteLine("After async method completed");
    }
    
    static async Task DoWorkAsync()
    {
        Console.WriteLine("Starting async work...");
        
        await Task.Delay(2000);  // Simulate async operation (2 seconds)
        
        Console.WriteLine("Async work completed!");
    }
}
```

### Output (with timing):

```
Before calling async method
Starting async work...
[2 second pause]
Async work completed!
After async method completed
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 6 | `async Task Main` | Async entry point (C# 7.1+) |
| 10 | `await DoWorkAsync()` | Wait for async method |
| 15 | `async Task DoWorkAsync` | Returns Task, can be awaited |
| 19 | `await Task.Delay(2000)` | Async sleep (doesn't block thread) |

---

## 💻 Code Example 2: Async with Return Value

```csharp
using System;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        Console.WriteLine("Fetching data...");
        
        int result = await CalculateSumAsync();
        
        Console.WriteLine($"Result: {result}");
    }
    
    static async Task<int> CalculateSumAsync()
    {
        await Task.Delay(1000);  // Simulate network call
        
        int sum = 0;
        for (int i = 1; i <= 100; i++)
            sum += i;
            
        return sum;  // Returns int, wrapped in Task<int>
    }
}
```

### Key Point:

```
┌─────────────────────────────────────────────────────────────────┐
│  Method declares: async Task<int>                               │
│  Return statement: return sum;        (just int)               │
│  Caller receives: Task<int>                                     │
│  After await: int result = await Method();                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 3: Parallel Async Operations

```csharp
using System;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        Console.WriteLine("Starting parallel operations...");
        
        // Start multiple tasks (don't await yet)
        Task<int> task1 = DoOperationAsync(1, 2000);
        Task<int> task2 = DoOperationAsync(2, 1500);
        Task<int> task3 = DoOperationAsync(3, 1000);
        
        // All three run in parallel!
        
        // Wait for all to complete
        int[] results = await Task.WhenAll(task1, task2, task3);
        
        Console.WriteLine($"Results: {results[0]}, {results[1]}, {results[2]}");
        Console.WriteLine("Total time: ~2 seconds (not 4.5 seconds!)");
    }
    
    static async Task<int> DoOperationAsync(int id, int delay)
    {
        Console.WriteLine($"Operation {id} starting...");
        await Task.Delay(delay);
        Console.WriteLine($"Operation {id} completed!");
        return id * 10;
    }
}
```

### Execution Timeline:

```
Time: 0ms
├── Operation 1 starts (2000ms)
├── Operation 2 starts (1500ms)
├── Operation 3 starts (1000ms)

Time: 1000ms
└── Operation 3 completes ✓

Time: 1500ms
└── Operation 2 completes ✓

Time: 2000ms
└── Operation 1 completes ✓
    All done! (Total: 2000ms, NOT 4500ms)
```

---

## 📊 Async Method Patterns

| Pattern | Use Case |
|---------|----------|
| `await Task.Delay()` | Async sleep (doesn't block) |
| `await Task.WhenAll()` | Wait for multiple tasks |
| `await Task.WhenAny()` | Wait for first to complete |
| `await foreach` | Async iteration (C# 8+) |
| `ConfigureAwait(false)` | Library code, no context needed |

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| `async void` | Exceptions lost, no await | Use `async Task` |
| `.Result` or `.Wait()` | Deadlock in UI apps | Use `await` |
| Forgetting `await` | Method runs but not awaited | Always await async calls |
| Blocking async code | Defeats purpose | Async all the way |

---

## 💻 Code Example 4: Exception Handling

```csharp
using System;
using System.Threading.Tasks;

class Program
{
    static async Task Main()
    {
        try
        {
            await DoRiskyOperationAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Caught: {ex.Message}");
        }
    }
    
    static async Task DoRiskyOperationAsync()
    {
        await Task.Delay(100);
        throw new InvalidOperationException("Something went wrong!");
    }
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **async marks method** - Must contain await
2. **await suspends** - Returns control to caller
3. **Task.Delay** - Async sleep (not Thread.Sleep)
4. **Task.WhenAll** - Parallel execution
5. **Never use async void** - Except for event handlers
6. **Async all the way** - Don't mix .Wait() and await

---

## 📝 Interview Questions

1. **What is the difference between Task.Wait() and await?**
   - Wait() blocks the thread
   - await suspends the method, frees the thread

2. **Why is async void bad?**
   - Can't await it
   - Exceptions crash the app
   - Only use for event handlers

3. **What happens when you await a completed task?**
   - Continues synchronously (no context switch)

4. **How does await work internally?**
   - Compiler generates state machine
   - Method split into before/after await parts

---

## 🔗 Next Topic
Next: [13_Extension_Methods.md](./13_Extension_Methods.md) - Extension Methods
