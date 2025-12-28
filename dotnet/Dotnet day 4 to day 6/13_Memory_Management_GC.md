# Memory Management and Garbage Collection in C#

## 📚 Introduction

C# uses **automatic memory management** through the **Garbage Collector (GC)**. The GC automatically reclaims memory occupied by objects that are no longer in use, freeing developers from manual memory management.

---

## 🎯 Learning Objectives

- Understand stack vs heap memory
- Master garbage collection generations
- Learn destructor and finalizer concepts
- Implement IDisposable pattern

---

## 🔍 Memory Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    .NET MEMORY LAYOUT                            │
├─────────────────────────────────────────────────────────────────┤
│  STACK (per thread)          │  HEAP (shared)                   │
│  - Value types               │  - Reference types               │
│  - Method parameters         │  - Objects (class instances)     │
│  - Local variables           │  - Arrays                        │
│  - Fast allocation/dealloc   │  - Managed by GC                 │
│  - LIFO structure            │  - Three generations             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: Object Creation and References

```csharp
using System;

class Employee
{
    public string Name;
    public int Id;
    
    public Employee(int id, string name)
    {
        Id = id;
        Name = name;
        Console.WriteLine($"Employee {id} created");
    }
}

class Program
{
    static void Main()
    {
        // Object created on HEAP, reference on STACK
        Employee e1 = new Employee(1, "Raj");
        
        // Another reference to same object
        Employee e2 = e1;
        
        Console.WriteLine($"e1 == e2: {e1 == e2}");  // True (same object)
        
        // e1 set to null, but object still referenced by e2
        e1 = null;
        Console.WriteLine($"e2.Name: {e2.Name}");  // Still accessible
        
        // Now nothing references the object - eligible for GC
        e2 = null;
        // Object can be collected whenever GC runs
    }
}
```

#### Memory Diagram

```
INITIAL STATE (after e1 = new Employee(...)):

Stack:              Heap:
┌─────┐            ┌────────────────────┐
│ e1  │───────────►│ Employee           │
└─────┘            │ Id = 1             │
                   │ Name = "Raj"       │
                   └────────────────────┘

AFTER e2 = e1:

Stack:              Heap:
┌─────┐            ┌────────────────────┐
│ e1  │───────────►│ Employee           │
├─────┤            │ Id = 1             │◄──┐
│ e2  │────────────│ Name = "Raj"       │   │
└─────┘            └────────────────────┘   │
                           ▲                │
                           └────────────────┘

AFTER e1 = null; e2 = null:

Stack:              Heap:
┌─────┐            ┌────────────────────┐
│ e1  │ null       │ Employee           │ ← No references!
├─────┤            │ Id = 1             │   Eligible for GC
│ e2  │ null       │ Name = "Raj"       │
└─────┘            └────────────────────┘
```

---

### Example 2: Garbage Collection Generations

```csharp
using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== GC Generations Demo ===");
        
        object obj = new object();
        
        // Check which generation an object is in
        Console.WriteLine($"Generation of obj: {GC.GetGeneration(obj)}");
        
        // Force GC collection
        GC.Collect();
        Console.WriteLine($"After GC.Collect(): {GC.GetGeneration(obj)}");
        
        GC.Collect();
        Console.WriteLine($"After second GC.Collect(): {GC.GetGeneration(obj)}");
        
        GC.Collect();
        Console.WriteLine($"After third GC.Collect(): {GC.GetGeneration(obj)}");
        
        // Memory info
        Console.WriteLine($"\nTotal Memory: {GC.GetTotalMemory(false):N0} bytes");
        Console.WriteLine($"Gen0 Collections: {GC.CollectionCount(0)}");
        Console.WriteLine($"Gen1 Collections: {GC.CollectionCount(1)}");
        Console.WriteLine($"Gen2 Collections: {GC.CollectionCount(2)}");
    }
}
```

#### Output:
```
=== GC Generations Demo ===
Generation of obj: 0
After GC.Collect(): 1
After second GC.Collect(): 2
After third GC.Collect(): 2
```

---

### Example 3: Generations Explained

```
┌─────────────────────────────────────────────────────────────────┐
│               GARBAGE COLLECTION GENERATIONS                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Generation 0 (Gen0)                                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Short-lived objects (newly created)                       │  │
│  │ Most collections happen here                              │  │
│  │ Fast collection                                           │  │
│  └──────────────────────────────────────────────────────────┘  │
│                        ↓ Survives collection                    │
│  Generation 1 (Gen1)                                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Buffer between short-lived and long-lived                │  │
│  │ Objects that survive Gen0 collection                      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                        ↓ Survives collection                    │
│  Generation 2 (Gen2)                                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Long-lived objects                                        │  │
│  │ Static data, cached objects                               │  │
│  │ Expensive to collect                                      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### Example 4: Destructor (Finalizer)

```csharp
using System;

class Destruct
{
    int x;
    
    public Destruct(int i)
    {
        x = i;
        Console.WriteLine($"Constructing {x}");
    }
    
    // Destructor - called by GC before reclaiming memory
    ~Destruct()
    {
        Console.WriteLine($"Destructing {x}");
    }
    
    public void Generator(int i)
    {
        Destruct o = new Destruct(i);
        // 'o' goes out of scope - eligible for GC
    }
}

class Program
{
    static void Main()
    {
        Destruct ob = new Destruct(0);
        
        // Generate many objects that become garbage
        for (int count = 1; count < 100000; count++)
            ob.Generator(count);
        
        Console.WriteLine("Done generating objects");
        
        // Force collection to see destructors run
        GC.Collect();
        GC.WaitForPendingFinalizers();
        
        Console.WriteLine("Main ending");
    }
}
```

**Important**: Destructors are:
- Called by GC (non-deterministic timing)
- Cannot be called directly
- Converted to `Finalize()` method internally
- Should be avoided when possible (use IDisposable instead)

---

### Example 5: IDisposable Pattern

```csharp
using System;
using System.IO;

class ResourceHolder : IDisposable
{
    private FileStream fileStream;
    private bool disposed = false;
    
    public ResourceHolder(string filename)
    {
        fileStream = new FileStream(filename, FileMode.OpenOrCreate);
        Console.WriteLine("Resource acquired");
    }
    
    // Public Dispose method
    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);  // Prevent finalizer from running
    }
    
    // Protected virtual Dispose
    protected virtual void Dispose(bool disposing)
    {
        if (!disposed)
        {
            if (disposing)
            {
                // Dispose managed resources
                if (fileStream != null)
                {
                    fileStream.Dispose();
                    fileStream = null;
                }
            }
            // Dispose unmanaged resources here
            
            disposed = true;
            Console.WriteLine("Resource released");
        }
    }
    
    // Finalizer (backup in case Dispose wasn't called)
    ~ResourceHolder()
    {
        Dispose(false);
    }
}

class Program
{
    static void Main()
    {
        // Best practice: Use 'using' statement
        using (ResourceHolder resource = new ResourceHolder("test.txt"))
        {
            // Use resource
            Console.WriteLine("Using resource...");
        }  // Dispose() called automatically here
        
        Console.WriteLine("After using block");
    }
}
```

#### Output:
```
Resource acquired
Using resource...
Resource released
After using block
```

---

### Example 6: Dispose vs Destructor Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│           DESTRUCTOR vs DISPOSE                                  │
├─────────────────────────────────────────────────────────────────┤
│ Feature           │ Destructor/Finalizer │ Dispose              │
├───────────────────┼─────────────────────┼──────────────────────┤
│ Called by         │ GC (automatic)       │ Programmer (manual)  │
│ Timing            │ Non-deterministic    │ Deterministic        │
│ Syntax            │ ~ClassName()         │ Dispose()            │
│ Interface         │ None                 │ IDisposable          │
│ Control           │ No control           │ Full control         │
│ Parameters        │ Not allowed          │ Allowed              │
│ Performance       │ Overhead (2 GC pass) │ Efficient            │
│ Recommended       │ Rarely               │ Yes, use 'using'     │
└───────────────────┴─────────────────────┴──────────────────────┘
```

---

### Example 7: When to Call GC.Collect()

```csharp
using System;

class Program
{
    static void Main()
    {
        // Generally DON'T force GC - let runtime decide
        
        // Rare valid scenarios:
        // 1. After releasing large amount of memory
        ProcessLargeDataset();
        GC.Collect();
        
        // 2. Before performance-critical section (pre-emptive)
        GC.Collect();
        GC.WaitForPendingFinalizers();
        PerformCriticalOperation();
        
        // 3. In batch processing between batches
        for (int batch = 0; batch < 100; batch++)
        {
            ProcessBatch(batch);
            if (batch % 10 == 0)
            {
                GC.Collect();  // Clean up every 10 batches
            }
        }
    }
    
    static void ProcessLargeDataset() { /* ... */ }
    static void PerformCriticalOperation() { /* ... */ }
    static void ProcessBatch(int n) { /* ... */ }
}
```

---

## ⚡ Key Points to Remember

| Concept | Description |
|---------|-------------|
| Stack | Value types, fast, automatic cleanup |
| Heap | Reference types, managed by GC |
| Generation 0 | New objects, collected frequently |
| Generation 1 | Buffer generation |
| Generation 2 | Long-lived objects, collected rarely |
| Destructor | Called by GC, non-deterministic |
| IDisposable | Deterministic cleanup, use with `using` |
| GC.Collect() | Avoid unless specific scenario |

---

## ❌ Common Mistakes

### Mistake 1: Relying on destructor timing
```csharp
~MyClass() { /* cleanup */ }  // May never run or run late!
// Use IDisposable instead
```

### Mistake 2: Forgetting to dispose
```csharp
var stream = new FileStream(...);
// Process...
// Forgot stream.Dispose() - resource leak!

// CORRECT: Use 'using'
using var stream = new FileStream(...);
```

---

## 📝 Practice Questions

1. **What generation is a new object placed in?**
<details>
<summary>Answer</summary>
Generation 0
</details>

2. **What's the difference between GC.Collect() and GC.WaitForPendingFinalizers()?**
<details>
<summary>Answer</summary>
`GC.Collect()` initiates garbage collection. `GC.WaitForPendingFinalizers()` blocks until all finalizers have completed.
</details>

---

## 🔗 Related Topics
- [06_Boxing_Unboxing.md](06_Boxing_Unboxing.md) - Value vs reference types
- [14_Exception_Handling.md](14_Exception_Handling.md) - Try-finally for cleanup
