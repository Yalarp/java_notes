# Arrays in C#

## Overview
Arrays are collections of elements of the same type stored in contiguous memory locations. This chapter covers single-dimensional, multi-dimensional, and jagged arrays with their methods.

---

## 1. What is an Array?

### Definition
An **array** is a data structure that stores a fixed-size collection of elements of the same type.

### Characteristics
- Fixed size (cannot grow or shrink after creation)
- Zero-indexed (first element at index 0)
- Reference type (stored on heap)
- Contiguous memory allocation

---

## 2. Single-Dimensional Arrays

### Declaration and Initialization

```csharp
// Method 1: Declaration then initialization
int[] numbers;
numbers = new int[5];  // Creates array of 5 integers (all 0)

// Method 2: Declaration with initialization
int[] numbers2 = new int[5];

// Method 3: With initial values
int[] numbers3 = new int[] { 1, 2, 3, 4, 5 };

// Method 4: Shorthand (size inferred)
int[] numbers4 = { 1, 2, 3, 4, 5 };

// Method 5: Using new with size and values
int[] numbers5 = new int[5] { 10, 20, 30, 40, 50 };
```

### Accessing Elements

```csharp
int[] arr = { 10, 20, 30, 40, 50 };

// Access by index
Console.WriteLine(arr[0]);  // 10 (first element)
Console.WriteLine(arr[4]);  // 50 (last element)

// Modify element
arr[2] = 100;
Console.WriteLine(arr[2]);  // 100

// Array length
Console.WriteLine(arr.Length);  // 5
```

### Memory Diagram

```
Stack                    Heap
┌──────────┐            ┌─────────────────────────────┐
│   arr    │───────────>│ [0] │ [1] │ [2] │ [3] │ [4] │
│ (address)│            │  10 │  20 │ 100 │  40 │  50 │
└──────────┘            └─────────────────────────────┘
                             Index positions
```

---

## 3. Looping Through Arrays

### Using for Loop

```csharp
int[] numbers = { 1, 2, 3, 4, 5 };

for (int i = 0; i < numbers.Length; i++)
{
    Console.WriteLine($"numbers[{i}] = {numbers[i]}");
}
```

### Using foreach Loop

```csharp
int[] numbers = { 1, 2, 3, 4, 5 };

foreach (int num in numbers)
{
    Console.WriteLine(num);
}
```

### Using for Loop (Backward)

```csharp
for (int i = numbers.Length - 1; i >= 0; i--)
{
    Console.WriteLine(numbers[i]);
}
```

---

## 4. Two-Dimensional Arrays

### Declaration and Initialization

```csharp
// Method 1: Declaration with size
int[,] matrix = new int[3, 4];  // 3 rows, 4 columns

// Method 2: With initial values
int[,] matrix2 = new int[,]
{
    { 1, 2, 3, 4 },
    { 5, 6, 7, 8 },
    { 9, 10, 11, 12 }
};

// Method 3: Shorthand
int[,] matrix3 = 
{
    { 1, 2, 3 },
    { 4, 5, 6 }
};
```

### Accessing Elements

```csharp
int[,] matrix = 
{
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
};

// Access element
Console.WriteLine(matrix[0, 0]);  // 1 (row 0, col 0)
Console.WriteLine(matrix[1, 2]);  // 6 (row 1, col 2)
Console.WriteLine(matrix[2, 1]);  // 8 (row 2, col 1)

// Dimensions
Console.WriteLine(matrix.GetLength(0));  // 3 (rows)
Console.WriteLine(matrix.GetLength(1));  // 3 (columns)
Console.WriteLine(matrix.Length);         // 9 (total elements)
```

### Looping Through 2D Array

```csharp
int[,] matrix = 
{
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 }
};

int rows = matrix.GetLength(0);
int cols = matrix.GetLength(1);

for (int i = 0; i < rows; i++)
{
    for (int j = 0; j < cols; j++)
    {
        Console.Write($"{matrix[i, j]} ");
    }
    Console.WriteLine();
}
```

### Output:
```
1 2 3
4 5 6
7 8 9
```

---

## 5. Jagged Arrays (Array of Arrays)

### Declaration and Initialization

```csharp
// Jagged array - each row can have different length
int[][] jagged = new int[3][];

// Initialize each row
jagged[0] = new int[] { 1, 2 };
jagged[1] = new int[] { 3, 4, 5, 6 };
jagged[2] = new int[] { 7, 8, 9 };
```

### Shorthand Initialization

```csharp
int[][] jagged = new int[][]
{
    new int[] { 1, 2 },
    new int[] { 3, 4, 5, 6 },
    new int[] { 7, 8, 9 }
};
```

### Memory Diagram

```
Stack              Heap
┌──────────┐      ┌─────────────┐
│  jagged  │─────>│ [0] ───────>│ 1 │ 2 │
│          │      │ [1] ───────>│ 3 │ 4 │ 5 │ 6 │
│          │      │ [2] ───────>│ 7 │ 8 │ 9 │
└──────────┘      └─────────────┘
```

### Looping Through Jagged Array

```csharp
int[][] jagged = new int[][]
{
    new int[] { 1, 2 },
    new int[] { 3, 4, 5, 6 },
    new int[] { 7, 8, 9 }
};

for (int i = 0; i < jagged.Length; i++)
{
    Console.Write($"Row {i}: ");
    for (int j = 0; j < jagged[i].Length; j++)
    {
        Console.Write($"{jagged[i][j]} ");
    }
    Console.WriteLine();
}
```

---

## 6. Array Methods

### Common Array Methods

```csharp
using System;

class ArrayMethodsDemo
{
    static void Main()
    {
        int[] numbers = { 5, 2, 8, 1, 9, 3 };
        
        // Length
        Console.WriteLine($"Length: {numbers.Length}");  // 6
        
        // Sort
        int[] sorted = (int[])numbers.Clone();
        Array.Sort(sorted);
        Console.WriteLine($"Sorted: {string.Join(", ", sorted)}");  // 1, 2, 3, 5, 8, 9
        
        // Reverse
        Array.Reverse(sorted);
        Console.WriteLine($"Reversed: {string.Join(", ", sorted)}");  // 9, 8, 5, 3, 2, 1
        
        // IndexOf
        int index = Array.IndexOf(numbers, 8);
        Console.WriteLine($"Index of 8: {index}");  // 2
        
        // Find
        int found = Array.Find(numbers, x => x > 5);
        Console.WriteLine($"First > 5: {found}");  // 8
        
        // FindAll
        int[] allGreater = Array.FindAll(numbers, x => x > 3);
        Console.WriteLine($"All > 3: {string.Join(", ", allGreater)}");  // 5, 8, 9
        
        // Exists
        bool hasNegative = Array.Exists(numbers, x => x < 0);
        Console.WriteLine($"Has negative: {hasNegative}");  // False
        
        // TrueForAll
        bool allPositive = Array.TrueForAll(numbers, x => x > 0);
        Console.WriteLine($"All positive: {allPositive}");  // True
        
        // Clear
        int[] toClear = { 1, 2, 3, 4, 5 };
        Array.Clear(toClear, 1, 3);  // Clear from index 1, 3 elements
        Console.WriteLine($"Cleared: {string.Join(", ", toClear)}");  // 1, 0, 0, 0, 5
    }
}
```

---

## 7. CopyTo and Clone

### CopyTo Method

```csharp
int[] source = { 1, 2, 3 };
int[] dest = new int[6];

// Copy source to dest starting at index 2
source.CopyTo(dest, 2);

Console.WriteLine(string.Join(", ", dest));  // 0, 0, 1, 2, 3, 0
```

### Clone Method

```csharp
int[] original = { 1, 2, 3, 4, 5 };

// Clone creates a shallow copy
int[] copy = (int[])original.Clone();

copy[0] = 100;

Console.WriteLine(string.Join(", ", original));  // 1, 2, 3, 4, 5 (unchanged)
Console.WriteLine(string.Join(", ", copy));       // 100, 2, 3, 4, 5
```

### Copy (Static Method)

```csharp
int[] source = { 1, 2, 3, 4, 5 };
int[] dest = new int[5];

// Copy 3 elements
Array.Copy(source, dest, 3);
Console.WriteLine(string.Join(", ", dest));  // 1, 2, 3, 0, 0

// Copy with source and destination indices
int[] dest2 = new int[7];
Array.Copy(source, 1, dest2, 3, 3);  // Copy 3 elements from source[1] to dest2[3]
Console.WriteLine(string.Join(", ", dest2));  // 0, 0, 0, 2, 3, 4, 0
```

---

## 8. Resize Array

```csharp
int[] arr = { 1, 2, 3 };
Console.WriteLine($"Before: {arr.Length}");  // 3

// Resize creates new array and copies elements
Array.Resize(ref arr, 5);
Console.WriteLine($"After expand: {arr.Length}");  // 5
Console.WriteLine(string.Join(", ", arr));  // 1, 2, 3, 0, 0

Array.Resize(ref arr, 2);
Console.WriteLine($"After shrink: {arr.Length}");  // 2
Console.WriteLine(string.Join(", ", arr));  // 1, 2
```

---

## 9. Array Class Properties

```csharp
int[,] matrix = new int[3, 4];

Console.WriteLine($"Rank: {matrix.Rank}");           // 2 (dimensions)
Console.WriteLine($"Length: {matrix.Length}");       // 12 (total elements)
Console.WriteLine($"LongLength: {matrix.LongLength}"); // 12
Console.WriteLine($"Rows: {matrix.GetLength(0)}");   // 3
Console.WriteLine($"Columns: {matrix.GetLength(1)}"); // 4
Console.WriteLine($"Lower bound: {matrix.GetLowerBound(0)}"); // 0
Console.WriteLine($"Upper bound: {matrix.GetUpperBound(0)}"); // 2
```

---

## 10. Arrays as Method Parameters

### Passing Array to Method

```csharp
class ArrayMethods
{
    // Array passed by reference (default)
    static void ModifyArray(int[] arr)
    {
        arr[0] = 100;  // Modifies original array
    }
    
    // Return array from method
    static int[] CreateArray(int size)
    {
        int[] arr = new int[size];
        for (int i = 0; i < size; i++)
            arr[i] = i * 10;
        return arr;
    }
    
    // params keyword for variable arguments
    static int Sum(params int[] numbers)
    {
        int total = 0;
        foreach (int n in numbers)
            total += n;
        return total;
    }
    
    static void Main()
    {
        int[] myArr = { 1, 2, 3 };
        ModifyArray(myArr);
        Console.WriteLine(myArr[0]);  // 100 (modified)
        
        int[] newArr = CreateArray(5);
        Console.WriteLine(string.Join(", ", newArr));  // 0, 10, 20, 30, 40
        
        // Using params
        Console.WriteLine(Sum(1, 2, 3, 4, 5));  // 15
        Console.WriteLine(Sum(10, 20));          // 30
    }
}
```

---

## 11. Common Array Algorithms

### Find Maximum and Minimum

```csharp
int[] numbers = { 45, 12, 78, 34, 89, 23 };

int max = numbers[0];
int min = numbers[0];

foreach (int num in numbers)
{
    if (num > max) max = num;
    if (num < min) min = num;
}

Console.WriteLine($"Max: {max}, Min: {min}");  // Max: 89, Min: 12

// Using Array methods
Console.WriteLine($"Max: {numbers.Max()}");
Console.WriteLine($"Min: {numbers.Min()}");
```

### Calculate Sum and Average

```csharp
int[] numbers = { 10, 20, 30, 40, 50 };

int sum = 0;
foreach (int num in numbers)
    sum += num;

double average = (double)sum / numbers.Length;

Console.WriteLine($"Sum: {sum}, Average: {average}");

// Using LINQ
Console.WriteLine($"Sum: {numbers.Sum()}");
Console.WriteLine($"Average: {numbers.Average()}");
```

---

## 12. Complete Example

```csharp
using System;
using System.Linq;

class StudentMarks
{
    static void Main()
    {
        // Create array of student marks
        double[] marks = { 85.5, 92.0, 78.3, 88.7, 95.2, 72.4, 89.1 };
        
        Console.WriteLine("=== Student Marks Analysis ===\n");
        
        // Display all marks
        Console.WriteLine("All Marks:");
        for (int i = 0; i < marks.Length; i++)
        {
            Console.WriteLine($"Student {i + 1}: {marks[i]:F1}");
        }
        
        // Statistics
        Console.WriteLine($"\nTotal Students: {marks.Length}");
        Console.WriteLine($"Sum: {marks.Sum():F1}");
        Console.WriteLine($"Average: {marks.Average():F2}");
        Console.WriteLine($"Highest: {marks.Max():F1}");
        Console.WriteLine($"Lowest: {marks.Min():F1}");
        
        // Sort and display
        double[] sorted = (double[])marks.Clone();
        Array.Sort(sorted);
        Console.WriteLine($"\nSorted (Ascending): {string.Join(", ", sorted.Select(m => m.ToString("F1")))}");
        
        Array.Reverse(sorted);
        Console.WriteLine($"Sorted (Descending): {string.Join(", ", sorted.Select(m => m.ToString("F1")))}");
        
        // Find students above average
        double avg = marks.Average();
        double[] aboveAvg = Array.FindAll(marks, m => m > avg);
        Console.WriteLine($"\nAbove Average ({avg:F2}):");
        foreach (double m in aboveAvg)
            Console.WriteLine($"  {m:F1}");
        
        // Grade distribution
        int[] gradeCount = new int[5]; // A, B, C, D, F
        foreach (double m in marks)
        {
            if (m >= 90) gradeCount[0]++;
            else if (m >= 80) gradeCount[1]++;
            else if (m >= 70) gradeCount[2]++;
            else if (m >= 60) gradeCount[3]++;
            else gradeCount[4]++;
        }
        
        Console.WriteLine($"\nGrade Distribution:");
        Console.WriteLine($"A (90+): {gradeCount[0]}");
        Console.WriteLine($"B (80-89): {gradeCount[1]}");
        Console.WriteLine($"C (70-79): {gradeCount[2]}");
        Console.WriteLine($"D (60-69): {gradeCount[3]}");
        Console.WriteLine($"F (<60): {gradeCount[4]}");
    }
}
```

---

## Key Points Summary

1. **Arrays** = Fixed-size collection of same type
2. **Zero-indexed** = First element at index 0
3. **Reference type** = Stored on heap
4. **1D array** = `int[] arr = { 1, 2, 3 };`
5. **2D array** = `int[,] matrix = new int[3,4];`
6. **Jagged array** = `int[][] jagged` (array of arrays)
7. **Length** = Total elements, **GetLength(n)** = Size of dimension n
8. **Sort, Reverse, Copy, Clone** = Common array operations
9. **params** = Variable number of arguments
10. **Arrays passed by reference** = Modifications affect original

---

## Practice Questions

1. What is the difference between 2D array and jagged array?
2. How do you copy an array without affecting the original?
3. What does Array.Resize do?
4. How do you find the number of rows in a 2D array?
5. What is the params keyword used for?
6. Are arrays value types or reference types?
