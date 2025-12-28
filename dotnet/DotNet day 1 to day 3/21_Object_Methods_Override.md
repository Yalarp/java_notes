# Overriding Object Methods in C#

## Overview
All classes in C# inherit from `System.Object`, which provides three important methods: `ToString()`, `Equals()`, and `GetHashCode()`. Overriding these methods allows you to customize how your objects are represented and compared.

---

## 1. The Object Class

Every class implicitly inherits from `System.Object`:

```csharp
class MyClass { }
// Equivalent to:
class MyClass : System.Object { }
```

### Object Class Methods

| Method | Default Behavior | When to Override |
|--------|------------------|------------------|
| `ToString()` | Returns type name | Custom string representation |
| `Equals(object)` | Reference equality | Value-based equality |
| `GetHashCode()` | Hash based on reference | When overriding Equals |
| `GetType()` | Returns Type object | Never override |
| `Finalize()` | Called during GC | Resource cleanup (rare) |
| `MemberwiseClone()` | Shallow copy | Create deep copy |

---

## 2. Overriding ToString()

### Default Behavior

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}

Person p = new Person { Name = "Raj", Age = 25 };
Console.WriteLine(p.ToString());  // "Namespace.Person"
Console.WriteLine(p);             // Same - Console.WriteLine calls ToString()
```

### After Override

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    
    public override string ToString()
    {
        return $"Person {{ Name = {Name}, Age = {Age} }}";
    }
}

Person p = new Person { Name = "Raj", Age = 25 };
Console.WriteLine(p);  // "Person { Name = Raj, Age = 25 }"
```

### Best Practices for ToString()

```csharp
class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Department { get; set; }
    public double Salary { get; set; }
    
    // Good: Informative and formatted
    public override string ToString()
    {
        return $"Employee[Id={Id}, Name={Name}, Dept={Department}, Salary={Salary:C}]";
    }
}

// For debugging, show all fields
public string ToDebugString()
{
    return $@"Employee {{
    Id = {Id},
    Name = ""{Name}"",
    Department = ""{Department}"",
    Salary = {Salary}
}}";
}
```

---

## 3. Overriding Equals()

### Default Behavior (Reference Equality)

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}

Person p1 = new Person { Name = "Raj", Age = 25 };
Person p2 = new Person { Name = "Raj", Age = 25 };
Person p3 = p1;

Console.WriteLine(p1.Equals(p2));  // False (different objects)
Console.WriteLine(p1.Equals(p3));  // True (same reference)
Console.WriteLine(p1 == p2);        // False
Console.WriteLine(p1 == p3);        // True
```

### After Override (Value Equality)

```csharp
class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    
    public override bool Equals(object obj)
    {
        // Check for null
        if (obj == null)
            return false;
        
        // Check for same type
        if (GetType() != obj.GetType())
            return false;
        
        // Cast and compare fields
        Person other = (Person)obj;
        return Name == other.Name && Age == other.Age;
    }
    
    // Must override GetHashCode when overriding Equals!
    public override int GetHashCode()
    {
        return HashCode.Combine(Name, Age);
    }
}

Person p1 = new Person { Name = "Raj", Age = 25 };
Person p2 = new Person { Name = "Raj", Age = 25 };

Console.WriteLine(p1.Equals(p2));  // True (same values)
```

### Modern Pattern with `is` Operator

```csharp
public override bool Equals(object obj)
{
    // Pattern matching - cleaner!
    if (obj is Person other)
    {
        return Name == other.Name && Age == other.Age;
    }
    return false;
}
```

### Implement IEquatable<T> for Better Performance

```csharp
class Person : IEquatable<Person>
{
    public string Name { get; set; }
    public int Age { get; set; }
    
    // IEquatable<Person>.Equals - no boxing, type-safe
    public bool Equals(Person other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return Name == other.Name && Age == other.Age;
    }
    
    // Object.Equals - for compatibility
    public override bool Equals(object obj)
    {
        return Equals(obj as Person);
    }
    
    public override int GetHashCode()
    {
        return HashCode.Combine(Name, Age);
    }
    
    // Optional: Also override == and !=
    public static bool operator ==(Person left, Person right)
    {
        if (left is null) return right is null;
        return left.Equals(right);
    }
    
    public static bool operator !=(Person left, Person right)
    {
        return !(left == right);
    }
}
```

---

## 4. Overriding GetHashCode()

### Why Override GetHashCode?

**Rule:** If you override `Equals()`, you **MUST** override `GetHashCode()`.

**Reason:** Hash-based collections (Dictionary, HashSet) use hash codes to locate objects.

```csharp
// If Equals is overridden but GetHashCode is not:
HashSet<Person> set = new HashSet<Person>();
Person p1 = new Person { Name = "Raj", Age = 25 };
Person p2 = new Person { Name = "Raj", Age = 25 };

set.Add(p1);
Console.WriteLine(set.Contains(p2));  // Wrong! Might be False even though p1.Equals(p2)
```

### Hash Code Contract

1. **Equal objects MUST have equal hash codes**
   - If `a.Equals(b)` returns true, then `a.GetHashCode()` must equal `b.GetHashCode()`

2. **Hash code should be consistent**
   - Same object should return same hash code during its lifetime (if mutable fields don't change)

3. **Unequal objects MAY have equal hash codes** (collisions are allowed)

### Implementing GetHashCode

```csharp
// Method 1: Using HashCode.Combine (C# 7+) - Recommended
public override int GetHashCode()
{
    return HashCode.Combine(Name, Age);
}

// For more fields:
public override int GetHashCode()
{
    return HashCode.Combine(Field1, Field2, Field3, Field4);
}

// Method 2: Manual calculation (older approach)
public override int GetHashCode()
{
    unchecked  // Allow overflow
    {
        int hash = 17;
        hash = hash * 23 + (Name?.GetHashCode() ?? 0);
        hash = hash * 23 + Age.GetHashCode();
        return hash;
    }
}

// Method 3: Using tuple
public override int GetHashCode()
{
    return (Name, Age).GetHashCode();
}
```

---

## 5. Using in Collections

### Without Proper Overrides

```csharp
class Point  // No overrides
{
    public int X { get; set; }
    public int Y { get; set; }
}

Dictionary<Point, string> dict = new Dictionary<Point, string>();
Point p1 = new Point { X = 1, Y = 2 };
dict[p1] = "Point A";

Point p2 = new Point { X = 1, Y = 2 };  // Same values
Console.WriteLine(dict.ContainsKey(p2));  // False! Different reference
```

### With Proper Overrides

```csharp
class Point : IEquatable<Point>
{
    public int X { get; set; }
    public int Y { get; set; }
    
    public bool Equals(Point other)
    {
        if (other is null) return false;
        return X == other.X && Y == other.Y;
    }
    
    public override bool Equals(object obj) => Equals(obj as Point);
    
    public override int GetHashCode() => HashCode.Combine(X, Y);
}

Dictionary<Point, string> dict = new Dictionary<Point, string>();
Point p1 = new Point { X = 1, Y = 2 };
dict[p1] = "Point A";

Point p2 = new Point { X = 1, Y = 2 };
Console.WriteLine(dict.ContainsKey(p2));  // True! Same values
Console.WriteLine(dict[p2]);               // "Point A"
```

---

## 6. Complete Example

```csharp
using System;
using System.Collections.Generic;

class Student : IEquatable<Student>
{
    public string RollNo { get; set; }
    public string Name { get; set; }
    public double Marks { get; set; }
    
    public Student(string rollNo, string name, double marks)
    {
        RollNo = rollNo;
        Name = name;
        Marks = marks;
    }
    
    // ToString: Human-readable representation
    public override string ToString()
    {
        return $"Student[RollNo={RollNo}, Name={Name}, Marks={Marks:F1}]";
    }
    
    // Equals: Two students are equal if they have same RollNo
    public bool Equals(Student other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return RollNo == other.RollNo;
    }
    
    public override bool Equals(object obj)
    {
        return Equals(obj as Student);
    }
    
    // GetHashCode: Based on RollNo (the equality field)
    public override int GetHashCode()
    {
        return RollNo?.GetHashCode() ?? 0;
    }
    
    // Operator overloads for consistency
    public static bool operator ==(Student left, Student right)
    {
        if (left is null) return right is null;
        return left.Equals(right);
    }
    
    public static bool operator !=(Student left, Student right)
    {
        return !(left == right);
    }
}

class Program
{
    static void Main()
    {
        Student s1 = new Student("R001", "Raj", 85.5);
        Student s2 = new Student("R001", "Raj Kumar", 90.0);  // Same RollNo
        Student s3 = new Student("R002", "Priya", 92.0);
        
        // ToString
        Console.WriteLine("=== ToString ===");
        Console.WriteLine(s1);
        Console.WriteLine(s2);
        Console.WriteLine(s3);
        
        // Equals
        Console.WriteLine("\n=== Equals ===");
        Console.WriteLine($"s1.Equals(s2): {s1.Equals(s2)}");  // True (same RollNo)
        Console.WriteLine($"s1.Equals(s3): {s1.Equals(s3)}");  // False
        Console.WriteLine($"s1 == s2: {s1 == s2}");            // True
        
        // In collections
        Console.WriteLine("\n=== In Collections ===");
        HashSet<Student> students = new HashSet<Student>();
        students.Add(s1);
        students.Add(s2);  // Won't add - equals s1
        students.Add(s3);
        
        Console.WriteLine($"Set count: {students.Count}");  // 2
        
        foreach (Student s in students)
        {
            Console.WriteLine($"  {s}");
        }
        
        // Dictionary
        Dictionary<Student, string> grades = new Dictionary<Student, string>();
        grades[s1] = "A";
        grades[s3] = "A+";
        
        // Can find by equal object
        Student lookup = new Student("R001", "Different Name", 0);
        Console.WriteLine($"\nLookup R001: {grades[lookup]}");  // "A"
    }
}
```

### Output:
```
=== ToString ===
Student[RollNo=R001, Name=Raj, Marks=85.5]
Student[RollNo=R001, Name=Raj Kumar, Marks=90.0]
Student[RollNo=R002, Name=Priya, Marks=92.0]

=== Equals ===
s1.Equals(s2): True
s1.Equals(s3): False
s1 == s2: True

=== In Collections ===
Set count: 2
  Student[RollNo=R001, Name=Raj, Marks=85.5]
  Student[RollNo=R002, Name=Priya, Marks=92.0]

Lookup R001: A
```

---

## 7. Checklist for Overriding

| Task | Required? | Notes |
|------|-----------|-------|
| Override `ToString()` | Recommended | For debugging and display |
| Override `Equals(object)` | If value equality needed | Check null, type, fields |
| Override `GetHashCode()` | **If Equals overridden** | Use same fields as Equals |
| Implement `IEquatable<T>` | Recommended | Better performance |
| Override `==` and `!=` | Optional | For consistency |

---

## Key Points Summary

1. All classes inherit from **Object**
2. **ToString()**: Return meaningful string representation
3. **Equals()**: Define when objects are "equal"
4. **GetHashCode()**: MUST override if overriding Equals
5. **Equal objects** must have **equal hash codes**
6. Use **HashCode.Combine()** for hash code generation
7. Implement **IEquatable<T>** for type safety
8. Override **==** and **!=** for consistency

---

## Common Mistakes to Avoid

1. ❌ Overriding Equals without GetHashCode
2. ❌ Using mutable fields in GetHashCode
3. ❌ Not checking for null in Equals
4. ❌ Not checking type in Equals
5. ❌ Inconsistent Equals and == behavior

---

## Practice Questions

1. Why must you override GetHashCode when overriding Equals?
2. What is the default behavior of Equals?
3. What happens if two equal objects have different hash codes?
4. How does ToString help in debugging?
5. What interface should you implement for type-safe equality?
6. What is the relationship between == and Equals?
