# Threading Fundamentals in C#

## 📚 Introduction

Threading allows applications to perform multiple operations concurrently. Understanding the difference between `Thread` and `Task` is crucial for modern C# development, where the Task Parallel Library (TPL) has become the recommended approach.

---

## 🎯 Learning Objectives

- Understand Thread class basics
- Compare Thread vs Task
- Learn when to use each approach

---

## 📖 Theory: Thread vs Task

```
┌────────────────────────────────────────────────────────────────┐
│                    Thread vs Task                               │
├──────────────────────────────┬─────────────────────────────────┤
│           Thread             │            Task                  │
├──────────────────────────────┼─────────────────────────────────┤
│ Low-level construct          │ High-level abstraction          │
│ System.Threading namespace   │ System.Threading.Tasks          │
│ Directly maps to OS thread   │ Uses thread pool                │
│ No return value              │ Can return value (Task<T>)      │
│ No built-in cancellation     │ CancellationToken support       │
│ Manual exception handling    │ Aggregated exceptions           │
│ One task per thread          │ Multiple tasks can share thread │
└──────────────────────────────┴─────────────────────────────────┘
```

### Thread Pool Concept

```
┌────────────────────────────────────────────────────────────────┐
│                      Thread Pool                                │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Tasks Queue: [Task1] [Task2] [Task3] [Task4] ...              │
│                  │       │       │                              │
│                  ▼       ▼       ▼                              │
│  Worker Threads: [T1]   [T2]   [T3]   [T4]  (reused)           │
│                                                                 │
│  Benefits:                                                      │
│  ✓ Thread reuse (no creation overhead)                         │
│  ✓ Automatic scaling to CPU cores                              │
│  ✓ Better resource management                                  │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Key Differences Summary

| Feature | Thread | Task |
|---------|--------|------|
| **Return Value** | ❌ No | ✅ Yes (Task<T>) |
| **Cancellation** | ❌ Manual | ✅ CancellationToken |
| **Thread Pool** | ❌ No | ✅ Yes |
| **Exception Handling** | Manual | Aggregated |
| **Continuation** | Manual | ContinueWith() |
| **async/await** | ❌ No | ✅ Yes |
| **Recommended** | Rare cases | ✅ Most cases |

---

## 💻 Code Example: Basic Thread Usage

```csharp
using System;
using System.Threading;

class ThreadDemo
{
    static void Main(string[] args)
    {
        // Name the main thread
        Thread.CurrentThread.Name = "Main";
        
        // Create a thread with lambda expression
        Thread thread = new Thread(() => 
        {
            Console.WriteLine("Hello from new thread!");
            Thread.Sleep(1000);  // Simulate work
            Console.WriteLine("Thread work complete.");
        });
        
        // Start the thread
        thread.Start();
        
        // Main thread continues
        Console.WriteLine("Hello from thread '{0}'.", 
                         Thread.CurrentThread.Name);
        
        // Wait for thread to complete
        thread.Join();
        
        Console.WriteLine("All done!");
    }
}
```

### Output:

```
Hello from thread 'Main'.
Hello from new thread!
Thread work complete.
All done!
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Use Task over Thread** - TPL is the modern approach
2. **Thread Pool** - Tasks reuse threads efficiently
3. **Thread.Join()** - Blocks until thread completes
4. **Thread.Sleep()** - Pauses current thread

---

## 📝 Interview Questions

1. **What is the difference between Thread and Task?**
   - Thread: Low-level, OS thread, no return value
   - Task: High-level, uses thread pool, supports return values

2. **Why prefer Task over Thread?**
   - Thread pool efficiency
   - async/await support
   - Better exception and cancellation handling

---

## 🔗 Next Topic
Next: [11_Task_Parallel_Library.md](./11_Task_Parallel_Library.md) - Task Parallel Library
