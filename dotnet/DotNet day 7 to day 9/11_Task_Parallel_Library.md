# Task Parallel Library (TPL) in C#

## 📚 Introduction

The Task Parallel Library (TPL) was introduced in .NET 4.0 and is the recommended approach for parallel and asynchronous programming. It simplifies multithreading and automatically scales to utilize available processors.

---

## 🎯 Learning Objectives

- Master Task creation methods: new Task(), Task.Run(), Task.Factory.StartNew()
- Understand Task.Wait() and TaskStatus
- Learn when to use each creation method

---

## 📖 Theory: Task Overview

```
┌────────────────────────────────────────────────────────────────┐
│                    Task Lifecycle                               │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Created → WaitingToRun → Running → RanToCompletion           │
│                                  ↘                              │
│                                   → Faulted (exception)        │
│                                   → Canceled                   │
│                                                                 │
│   TaskStatus enumeration tracks the state                      │
└────────────────────────────────────────────────────────────────┘
```

### Task Types

| Type | Description |
|------|-------------|
| **Task** | Represents work that doesn't return a value |
| **Task<TResult>** | Represents work that returns a value |

---

## 💻 Code Example 1: Creating Task with new Task()

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Thread.CurrentThread.Name = "Main";

        // Create a task and supply a delegate using lambda expression
        Task taskA = new Task(() => Console.WriteLine("Hello from taskA."));
        
        // Start the task (required with new Task())
        taskA.Start();

        // Output a message from the calling thread
        Console.WriteLine("Hello from thread '{0}'.", 
                         Thread.CurrentThread.Name);
        
        // Wait for task to complete (like thread.Join())
        taskA.Wait();
        
        Console.WriteLine("done");
    }
}
```

### Output:

```
Hello from thread 'Main'.
Hello from taskA.
done
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 11 | `new Task(() => ...)` | Create task with lambda delegate |
| 14 | `taskA.Start()` | Must explicitly start (unlike Task.Run) |
| 20 | `taskA.Wait()` | Block until task completes |

---

## 💻 Code Example 2: Using Task.Run() (Recommended)

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Thread.CurrentThread.Name = "Main";

        // Define and run the task in one operation
        Task taskA = Task.Run(() => Console.WriteLine("Hello from taskA."));

        // Main thread continues immediately
        Console.WriteLine("Hello from thread '{0}'.", 
                         Thread.CurrentThread.Name);
        
        // Wait for completion
        taskA.Wait();

        Console.WriteLine("done");
    }
}
```

### Key Difference:

```
┌─────────────────────────────────────────────────────────────────┐
│  new Task() + Start()          vs        Task.Run()            │
├────────────────────────────────┬────────────────────────────────┤
│  Two steps required            │  One step - create and start  │
│  taskA = new Task(...)         │  taskA = Task.Run(...)         │
│  taskA.Start()                 │                                │
├────────────────────────────────┼────────────────────────────────┤
│  Use when need to delay start  │  ✅ Recommended for most cases │
└────────────────────────────────┴────────────────────────────────┘
```

---

## 💻 Code Example 3: Using Task.Factory.StartNew()

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        Thread.CurrentThread.Name = "Main";

        // Create and start task using TaskFactory
        Task taskA = Task.Factory.StartNew(
            () => Console.WriteLine("Hello from taskA."));

        // Main thread continues
        Console.WriteLine("Hello from thread '{0}'.", 
                         Thread.CurrentThread.Name);

        taskA.Wait();
        Console.WriteLine("done");
    }
}
```

### When to Use Task.Factory.StartNew():

```
┌─────────────────────────────────────────────────────────────────┐
│  Task.Run()                    vs    Task.Factory.StartNew()   │
├────────────────────────────────┬────────────────────────────────┤
│  Simpler API                   │  More control                  │
│  Uses default options          │  Custom TaskCreationOptions    │
│  No state parameter            │  Can pass state object         │
│  ✅ Recommended for most       │  Use for long-running tasks    │
└────────────────────────────────┴────────────────────────────────┘
```

---

## 💻 Code Example 4: Task with Return Value (Task<T>)

```csharp
using System;
using System.Threading.Tasks;

class Program
{
    static void Main(string[] args)
    {
        // Task that returns an integer
        Task<int> computeTask = Task.Run(() =>
        {
            int sum = 0;
            for (int i = 1; i <= 100; i++)
                sum += i;
            return sum;  // Return value
        });
        
        Console.WriteLine("Computing sum...");
        
        // Access result (blocks until complete)
        int result = computeTask.Result;
        
        Console.WriteLine("Sum of 1-100 = {0}", result);
        // Output: Sum of 1-100 = 5050
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `Task<int> computeTask` | Task returns int |
| 14 | `return sum;` | Return value from task |
| 20 | `computeTask.Result` | Get result (blocks if not done) |

---

## 📊 Task Creation Methods Comparison

| Method | Start Immediately | Control | Use Case |
|--------|-------------------|---------|----------|
| `new Task()` | ❌ No (call Start) | Basic | Need delayed start |
| `Task.Run()` | ✅ Yes | Default | ✅ Most cases |
| `Task.Factory.StartNew()` | ✅ Yes | Full | Long-running, custom options |

---

## 💻 Code Example 5: Task Status and Wait

```csharp
using System;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static void Main()
    {
        Task task = Task.Run(() =>
        {
            Thread.Sleep(2000);
            Console.WriteLine("Task completed!");
        });
        
        // Check status while running
        Console.WriteLine("Status: " + task.Status);  // WaitingToRun or Running
        
        // Wait with timeout
        bool completed = task.Wait(1000);  // Wait max 1 second
        Console.WriteLine("Completed in 1s? " + completed);  // False
        
        // Wait for full completion
        task.Wait();
        Console.WriteLine("Final Status: " + task.Status);  // RanToCompletion
    }
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Task.Run() is preferred** - Simple, uses thread pool
2. **Task.Wait()** - Blocks until task completes
3. **Task<T>.Result** - Get return value (blocks)
4. **TaskStatus** - Check task state (Running, Completed, etc.)
5. **Factory.StartNew()** - Only for advanced scenarios

---

## 📝 Interview Questions

1. **Difference between Task.Run and Task.Factory.StartNew?**
   - Task.Run: Simplified, default options
   - Factory.StartNew: More control, custom options

2. **What does Task.Wait() do?**
   - Blocks calling thread until task completes
   - Returns true/false with timeout overload

3. **How do you get a return value from Task?**
   - Use Task<T> and access .Result property
   - Or use await with async methods

---

## 🔗 Next Topic
Next: [12_Async_Await_Pattern.md](./12_Async_Await_Pattern.md) - Async/Await Pattern
