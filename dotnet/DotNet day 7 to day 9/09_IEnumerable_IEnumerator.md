# IEnumerable<T> and IEnumerator<T> in C#

## 📚 Introduction

`IEnumerable<T>` and `IEnumerator<T>` are the foundation of iteration in C#. Any class implementing `IEnumerable<T>` can be used with `foreach` loops. Understanding these interfaces helps you create custom collections.

---

## 🎯 Learning Objectives

- Understand how foreach works internally
- Implement IEnumerable and IEnumerator
- Create custom iterable collections

---

## 📖 Theory: How foreach Works

```
┌────────────────────────────────────────────────────────────────┐
│                    foreach Internal Working                     │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  foreach (Employee e in collection)                            │
│  {                                                              │
│      Console.WriteLine(e);                                     │
│  }                                                              │
│                                                                 │
│  Compiler translates to:                                       │
│                                                                 │
│  IEnumerator enumerator = collection.GetEnumerator();          │
│  while (enumerator.MoveNext())                                 │
│  {                                                              │
│      Employee e = (Employee)enumerator.Current;                │
│      Console.WriteLine(e);                                     │
│  }                                                              │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

### Interface Definitions

```csharp
// IEnumerable - "I can be iterated"
public interface IEnumerable
{
    IEnumerator GetEnumerator();
}

// IEnumerator - "I know how to iterate"
public interface IEnumerator
{
    bool MoveNext();      // Move to next element
    object Current { get; }  // Get current element
    void Reset();         // Reset to beginning
}
```

---

## 💻 Code Example: Custom Iterable Collection

```csharp
using System;
using System.Collections;

namespace ConsoleApplication1
{
    // Employee class
    class Employee
    {
        public string Name { get; set; }

        public override string ToString()
        {
            return Name;
        }
    }
    
    // Company contains a list of employees
    class Company
    {
        public List s = new List();  // Our custom List
        
        public void add(Object emp)
        {
            s.Add(emp);
        }
    }
    
    // Custom List implementing IEnumerable
    public class List : IEnumerable
    {
        private static object[] _objects;
        static int c = 0;
        
        public List()
        {
            _objects = new object[3];  // Fixed size for demo
        }
        
        public void Add(object obj)
        {
            _objects[c++] = obj;
        }
        
        // Required by IEnumerable
        public IEnumerator GetEnumerator()
        {
            return new ListEnumerator();
        }
        
        // Nested Enumerator class
        public class ListEnumerator : IEnumerator
        {
            private int _currentIndex = -1;  // Start before first element

            // Move to next element
            public bool MoveNext()
            {
                _currentIndex++;
                return (_currentIndex < _objects.Length);
            }

            // Get current element
            public object Current
            {
                get
                {
                    try
                    {
                        return _objects[_currentIndex];
                    }
                    catch (IndexOutOfRangeException)
                    {
                        throw new InvalidOperationException();
                    }
                }
            }
            
            // Reset to beginning
            public void Reset()
            {
                _currentIndex = -1;
            }
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Company c = new Company();
            c.add(new Employee() { Name = "Raj" });
            c.add(new Employee() { Name = "Geeta" });
            
            // Using the enumerator directly
            var enumerator = c.s.GetEnumerator();
            while (enumerator.MoveNext())
            {
                Console.WriteLine(enumerator.Current);
            }
            // Output:
            // Raj
            // Geeta
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 28 | `class List : IEnumerable` | Custom List implements IEnumerable |
| 30 | `object[] _objects` | Internal array storage |
| 44-47 | `GetEnumerator()` | Returns new enumerator instance |
| 50 | `class ListEnumerator : IEnumerator` | Nested class handles iteration |
| 52 | `_currentIndex = -1` | Start before first element |
| 55-58 | `MoveNext()` | Increment index, return true if valid |
| 61-74 | `Current` | Return element at current index |
| 77-80 | `Reset()` | Set index back to -1 |

### Execution Flow:

```
┌────────────────────────────────────────────────────────────────┐
│  Step 1: GetEnumerator() called                                │
│          _currentIndex = -1                                    │
│                                                                │
│  Step 2: MoveNext() called                                     │
│          _currentIndex = 0                                     │
│          Returns true (0 < 3)                                  │
│                                                                │
│  Step 3: Current accessed                                      │
│          Returns _objects[0] = "Raj"                           │
│                                                                │
│  Step 4: MoveNext() called                                     │
│          _currentIndex = 1                                     │
│          Returns true (1 < 3)                                  │
│                                                                │
│  Step 5: Current accessed                                      │
│          Returns _objects[1] = "Geeta"                         │
│                                                                │
│  Step 6: MoveNext() called                                     │
│          _currentIndex = 2                                     │
│          Returns true (2 < 3) - but null                       │
│                                                                │
│  Step 7: MoveNext() called                                     │
│          _currentIndex = 3                                     │
│          Returns false (3 >= 3) - loop ends                    │
└────────────────────────────────────────────────────────────────┘
```

### Memory Diagram:

```
_objects array:
┌─────────┬─────────┬─────────┐
│    0    │    1    │    2    │
│   Raj   │  Geeta  │  null   │
└─────────┴─────────┴─────────┘
     ↑
_currentIndex moves through array

Enumerator State:
Initial:    _currentIndex = -1  (before first)
After 1st:  _currentIndex = 0   → Current = "Raj"
After 2nd:  _currentIndex = 1   → Current = "Geeta"
After 3rd:  _currentIndex = 2   → Current = null
After 4th:  _currentIndex = 3   → MoveNext returns false
```

---

## 📊 IEnumerable vs IEnumerator

| Interface | Purpose | Key Members |
|-----------|---------|-------------|
| **IEnumerable** | "I can be iterated" | `GetEnumerator()` |
| **IEnumerator** | "I know how to iterate" | `MoveNext()`, `Current`, `Reset()` |

---

## 💻 Code Example 2: Using foreach (Simpler)

```csharp
// If your class implements IEnumerable, foreach works automatically
Company c = new Company();
c.add(new Employee() { Name = "Raj" });
c.add(new Employee() { Name = "Geeta" });

// This works because c.s implements IEnumerable
foreach (Employee emp in c.s)
{
    Console.WriteLine(emp.Name);
}

// Compiler converts above to:
IEnumerator enumerator = c.s.GetEnumerator();
try
{
    while (enumerator.MoveNext())
    {
        Employee emp = (Employee)enumerator.Current;
        Console.WriteLine(emp.Name);
    }
}
finally
{
    // Dispose if IDisposable
    if (enumerator is IDisposable disposable)
        disposable.Dispose();
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **IEnumerable** - Implement to enable foreach
2. **IEnumerator** - The actual iterator with state
3. **_currentIndex = -1** - Start before first element
4. **MoveNext()** - Called first, advances position
5. **Current** - Only valid after MoveNext returns true
6. **foreach** - Compiler converts to while loop with enumerator

---

## 📝 Interview Questions

1. **What is the difference between IEnumerable and IEnumerator?**
   - IEnumerable: Factory that creates IEnumerator
   - IEnumerator: Iterator with state (Current, MoveNext)

2. **Why does _currentIndex start at -1?**
   - MoveNext() is called before first access
   - Incrementing from -1 gives 0 (first element)

3. **Can you modify collection during foreach?**
   - No! Throws InvalidOperationException
   - Collection tracks modification count

4. **What happens if you call Current before MoveNext?**
   - Undefined behavior (depends on implementation)
   - Should throw InvalidOperationException

---

## 🔗 Next Topic
Next: [10_Threading_Fundamentals.md](./10_Threading_Fundamentals.md) - Threading & Tasks
