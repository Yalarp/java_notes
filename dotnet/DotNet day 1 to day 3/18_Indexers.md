# Indexers in C#

## Overview
An indexer allows objects to be indexed like arrays using square bracket notation `[]`. It provides a way to access elements in a class using an index, making your custom collections feel more natural to use.

---

## 1. What is an Indexer?

### Definition
An **indexer** is a special property that allows instances of a class to be accessed using array-like syntax with square brackets.

### Real-World Analogy
```
Array:      int[] numbers = {1, 2, 3};
            int x = numbers[0];  // Built-in indexing
            
Custom:     MyCollection col = new MyCollection();
            var item = col[0];   // Custom indexing via indexer
```

---

## 2. Indexer Syntax

```csharp
public returnType this[parameterType parameter]
{
    get 
    { 
        // Return element at index
        return element; 
    }
    set 
    { 
        // Set element at index using 'value' keyword
        element = value; 
    }
}
```

### Key Points
- Uses **`this`** keyword (like constructor chaining, but different purpose)
- Can have **any parameter type** (int, string, enum, etc.)
- Can have **multiple parameters** (like 2D array access)
- Can be **overloaded** with different parameter types
- **Cannot be static** (always instance-level)

---

## 3. Basic Indexer Example

```csharp
using System;

class StringCollection
{
    // Private backing array
    private string[] data;
    
    // Constructor
    public StringCollection(int size)
    {
        data = new string[size];
    }
    
    // Indexer definition
    public string this[int index]
    {
        get
        {
            // Bounds checking
            if (index >= 0 && index < data.Length)
                return data[index];
            else
                throw new IndexOutOfRangeException($"Index {index} is out of range");
        }
        set
        {
            // Bounds checking
            if (index >= 0 && index < data.Length)
                data[index] = value;
            else
                throw new IndexOutOfRangeException($"Index {index} is out of range");
        }
    }
    
    // Property for length
    public int Length => data.Length;
}

class Program
{
    static void Main()
    {
        StringCollection names = new StringCollection(5);
        
        // Use indexer to SET values (calls set accessor)
        names[0] = "Raj";
        names[1] = "Priya";
        names[2] = "Amit";
        
        // Use indexer to GET values (calls get accessor)
        Console.WriteLine(names[0]);  // Raj
        Console.WriteLine(names[1]);  // Priya
        Console.WriteLine(names[2]);  // Amit
        
        // Loop through using indexer
        for (int i = 0; i < names.Length; i++)
        {
            if (names[i] != null)
                Console.WriteLine($"Index {i}: {names[i]}");
        }
        
        // Exception handling
        try
        {
            Console.WriteLine(names[10]);  // Out of range
        }
        catch (IndexOutOfRangeException ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
}
```

---

## 4. String-Based Indexer (Dictionary-like)

```csharp
using System;
using System.Collections.Generic;

class PhoneBook
{
    private Dictionary<string, string> contacts = new Dictionary<string, string>();
    
    // String indexer - access by name
    public string this[string name]
    {
        get
        {
            if (contacts.ContainsKey(name))
                return contacts[name];
            else
                return $"Contact '{name}' not found";
        }
        set
        {
            // Add or update contact
            contacts[name] = value;
        }
    }
    
    // Property to get count
    public int Count => contacts.Count;
    
    // Method to remove contact
    public bool Remove(string name)
    {
        return contacts.Remove(name);
    }
    
    // Method to display all
    public void DisplayAll()
    {
        Console.WriteLine("\n=== Phone Book ===");
        foreach (var contact in contacts)
        {
            Console.WriteLine($"{contact.Key}: {contact.Value}");
        }
    }
}

class Program
{
    static void Main()
    {
        PhoneBook book = new PhoneBook();
        
        // Add contacts using string indexer
        book["Raj"] = "123-456-7890";
        book["Priya"] = "987-654-3210";
        book["Amit"] = "555-123-4567";
        
        // Retrieve contacts
        Console.WriteLine($"Raj's number: {book["Raj"]}");
        Console.WriteLine($"Unknown: {book["Unknown"]}");
        
        // Update contact
        book["Raj"] = "111-222-3333";
        Console.WriteLine($"Raj's new number: {book["Raj"]}");
        
        book.DisplayAll();
    }
}
```

---

## 5. Multi-Parameter Indexer (Matrix-like)

```csharp
using System;

class Matrix
{
    private int[,] data;
    private int rows, cols;
    
    public Matrix(int rows, int cols)
    {
        this.rows = rows;
        this.cols = cols;
        data = new int[rows, cols];
    }
    
    // Two-parameter indexer (like 2D array)
    public int this[int row, int col]
    {
        get
        {
            ValidateIndices(row, col);
            return data[row, col];
        }
        set
        {
            ValidateIndices(row, col);
            data[row, col] = value;
        }
    }
    
    private void ValidateIndices(int row, int col)
    {
        if (row < 0 || row >= rows || col < 0 || col >= cols)
            throw new IndexOutOfRangeException($"Invalid indices [{row},{col}]");
    }
    
    // Properties
    public int Rows => rows;
    public int Columns => cols;
    
    // Display method
    public void Display()
    {
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                Console.Write($"{data[i, j],4}");
            }
            Console.WriteLine();
        }
    }
}

class Program
{
    static void Main()
    {
        Matrix matrix = new Matrix(3, 3);
        
        // Set values using two-parameter indexer
        matrix[0, 0] = 1; matrix[0, 1] = 2; matrix[0, 2] = 3;
        matrix[1, 0] = 4; matrix[1, 1] = 5; matrix[1, 2] = 6;
        matrix[2, 0] = 7; matrix[2, 1] = 8; matrix[2, 2] = 9;
        
        Console.WriteLine("Matrix:");
        matrix.Display();
        
        // Access individual element
        Console.WriteLine($"\nmatrix[1,1] = {matrix[1, 1]}");  // 5
        
        // Modify element
        matrix[1, 1] = 50;
        Console.WriteLine($"After modification: matrix[1,1] = {matrix[1, 1]}");
    }
}
```

---

## 6. Overloaded Indexers

You can have multiple indexers with different parameter types:

```csharp
using System;
using System.Collections.Generic;

class StudentCollection
{
    private List<Student> students = new List<Student>();
    
    // Add student
    public void Add(Student s) => students.Add(s);
    
    // Indexer 1: Access by position (int)
    public Student this[int index]
    {
        get => (index >= 0 && index < students.Count) 
               ? students[index] 
               : null;
        set
        {
            if (index >= 0 && index < students.Count)
                students[index] = value;
        }
    }
    
    // Indexer 2: Access by roll number (string)
    public Student this[string rollNo]
    {
        get => students.Find(s => s.RollNo == rollNo);
    }
    
    // Indexer 3: Access by name and age (multiple params)
    public Student this[string name, int age]
    {
        get => students.Find(s => s.Name == name && s.Age == age);
    }
    
    public int Count => students.Count;
}

class Student
{
    public string RollNo { get; set; }
    public string Name { get; set; }
    public int Age { get; set; }
    
    public Student(string rollNo, string name, int age)
    {
        RollNo = rollNo;
        Name = name;
        Age = age;
    }
    
    public override string ToString() => $"[{RollNo}] {Name}, Age: {Age}";
}

class Program
{
    static void Main()
    {
        StudentCollection students = new StudentCollection();
        
        students.Add(new Student("R001", "Raj", 20));
        students.Add(new Student("R002", "Priya", 21));
        students.Add(new Student("R003", "Amit", 20));
        
        // Use different indexers
        Console.WriteLine("By index [0]: " + students[0]);
        Console.WriteLine("By roll no [R002]: " + students["R002"]);
        Console.WriteLine("By name & age [Amit, 20]: " + students["Amit", 20]);
    }
}
```

---

## 7. Read-Only Indexer

```csharp
class Fibonacci
{
    private int[] cache;
    
    public Fibonacci(int maxIndex)
    {
        cache = new int[maxIndex + 1];
        GenerateSequence(maxIndex);
    }
    
    private void GenerateSequence(int n)
    {
        if (n >= 0) cache[0] = 0;
        if (n >= 1) cache[1] = 1;
        
        for (int i = 2; i <= n; i++)
        {
            cache[i] = cache[i - 1] + cache[i - 2];
        }
    }
    
    // Read-only indexer (no set accessor)
    public int this[int index]
    {
        get
        {
            if (index >= 0 && index < cache.Length)
                return cache[index];
            throw new IndexOutOfRangeException();
        }
        // No set accessor - read-only
    }
    
    public int Length => cache.Length;
}

class Program
{
    static void Main()
    {
        Fibonacci fib = new Fibonacci(15);
        
        Console.WriteLine("Fibonacci Sequence:");
        for (int i = 0; i < fib.Length; i++)
        {
            Console.WriteLine($"F({i}) = {fib[i]}");
        }
        
        // ❌ Cannot set - read-only
        // fib[5] = 100;  // Compile error
    }
}
```

---

## 8. Expression-Bodied Indexers (C# 7+)

```csharp
class Days
{
    private string[] days = 
    {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    };
    
    // Expression-bodied read-only indexer
    public string this[int index] => days[index % 7];
    
    // Expression-bodied get and set (C# 7+)
    public string this[DayOfWeek day]
    {
        get => days[(int)day];
        set => days[(int)day] = value;
    }
}

class Program
{
    static void Main()
    {
        Days d = new Days();
        
        Console.WriteLine(d[0]);     // Sunday
        Console.WriteLine(d[7]);     // Sunday (wraps around)
        Console.WriteLine(d[DayOfWeek.Friday]);  // Friday
        
        d[DayOfWeek.Monday] = "Moon Day";
        Console.WriteLine(d[1]);     // Moon Day
    }
}
```

---

## 9. Indexer vs Property Comparison

| Aspect | Property | Indexer |
|--------|----------|---------|
| **Syntax** | `obj.PropertyName` | `obj[index]` |
| **Name** | Has explicit name | Uses `this` keyword |
| **Parameters** | None | One or more |
| **Overloading** | Cannot overload | Can overload |
| **Static** | Can be static | Cannot be static |
| **Use Case** | Single value access | Collection-like access |

---

## 10. Complete Example: Custom List

```csharp
using System;

class CustomList<T>
{
    private T[] items;
    private int count;
    private const int InitialCapacity = 4;
    
    public CustomList()
    {
        items = new T[InitialCapacity];
        count = 0;
    }
    
    // Indexer with bounds checking
    public T this[int index]
    {
        get
        {
            if (index < 0 || index >= count)
                throw new IndexOutOfRangeException($"Index {index} out of range [0, {count - 1}]");
            return items[index];
        }
        set
        {
            if (index < 0 || index >= count)
                throw new IndexOutOfRangeException($"Index {index} out of range [0, {count - 1}]");
            items[index] = value;
        }
    }
    
    public int Count => count;
    
    public void Add(T item)
    {
        EnsureCapacity();
        items[count++] = item;
    }
    
    private void EnsureCapacity()
    {
        if (count >= items.Length)
        {
            T[] newItems = new T[items.Length * 2];
            Array.Copy(items, newItems, items.Length);
            items = newItems;
        }
    }
    
    public bool Remove(T item)
    {
        int index = Array.IndexOf(items, item, 0, count);
        if (index >= 0)
        {
            RemoveAt(index);
            return true;
        }
        return false;
    }
    
    public void RemoveAt(int index)
    {
        if (index < 0 || index >= count)
            throw new IndexOutOfRangeException();
        
        for (int i = index; i < count - 1; i++)
        {
            items[i] = items[i + 1];
        }
        items[--count] = default;
    }
}

class Program
{
    static void Main()
    {
        CustomList<string> names = new CustomList<string>();
        
        names.Add("Raj");
        names.Add("Priya");
        names.Add("Amit");
        names.Add("Sneha");
        
        Console.WriteLine("List contents:");
        for (int i = 0; i < names.Count; i++)
        {
            Console.WriteLine($"  [{i}] = {names[i]}");
        }
        
        // Modify using indexer
        names[1] = "Priya Sharma";
        Console.WriteLine($"\nModified [1]: {names[1]}");
        
        // Remove
        names.RemoveAt(2);
        Console.WriteLine($"\nAfter removing index 2:");
        for (int i = 0; i < names.Count; i++)
        {
            Console.WriteLine($"  [{i}] = {names[i]}");
        }
    }
}
```

---

## Key Points Summary

1. **Indexer** = Allows `[]` notation on objects
2. Uses **`this`** keyword with parameters
3. Can have **any parameter type** (int, string, etc.)
4. Can have **multiple parameters** (like matrix)
5. Can be **overloaded** with different signatures
6. **Cannot be static**
7. Supports **get-only** (read-only) indexers
8. Enables **natural collection syntax**

---

## Common Mistakes to Avoid

1. ❌ Forgetting bounds checking in indexer
2. ❌ Trying to make indexer static
3. ❌ Not handling null/invalid indices
4. ❌ Confusing indexer with property

---

## Practice Questions

1. What is an indexer and how does it differ from a property?
2. Can an indexer be static? Why or why not?
3. How do you create a multi-parameter indexer?
4. How do you create a read-only indexer?
5. Can you have multiple indexers in the same class?
6. What keyword is used to define an indexer?
7. Can indexers be overloaded?
