# Constructors in C#

## Overview
A constructor is a special method that initializes an object when it's created. Constructors have the same name as the class and no return type.

---

## 1. What is a Constructor?

### Definition
A **constructor** is a special method that is called automatically when an object is created using the `new` keyword.

### Characteristics
- Same name as the class
- No return type (not even void)
- Called automatically upon object creation
- Used to initialize object state

---

## 2. Default Constructor

### System-Provided Default Constructor

If you don't define any constructor, the compiler provides a default parameterless constructor.

```csharp
class Student
{
    public int rollNo;
    public string name;
    // No constructor defined - compiler provides default
}

class Program
{
    static void Main()
    {
        // Default constructor is called
        Student s = new Student();
        // rollNo = 0, name = null (default values)
    }
}
```

### User-Defined Default Constructor

```csharp
class Student
{
    public int rollNo;
    public string name;
    
    // User-defined default (no-args) constructor
    public Student()
    {
        Console.WriteLine("Constructor called!");
        rollNo = 1;
        name = "Unknown";
    }
}

class Program
{
    static void Main()
    {
        Student s = new Student();  // "Constructor called!"
        Console.WriteLine($"{s.rollNo}, {s.name}");  // 1, Unknown
    }
}
```

---

## 3. Parameterized Constructor

### Definition
A constructor that accepts parameters to initialize object with specific values.

```csharp
class Student
{
    public int rollNo;
    public string name;
    public double marks;
    
    // Parameterized constructor
    public Student(int r, string n, double m)
    {
        rollNo = r;
        name = n;
        marks = m;
    }
}

class Program
{
    static void Main()
    {
        // Must provide all arguments
        Student s1 = new Student(101, "Raj", 85.5);
        Student s2 = new Student(102, "Priya", 92.0);
        
        Console.WriteLine($"{s1.rollNo}, {s1.name}, {s1.marks}");
        Console.WriteLine($"{s2.rollNo}, {s2.name}, {s2.marks}");
    }
}
```

> **Important**: Once you define ANY constructor, the compiler no longer provides the default constructor!

---

## 4. Constructor Overloading

### Multiple Constructors with Different Parameters

```csharp
class Employee
{
    public int id;
    public string name;
    public double salary;
    
    // Constructor 1: No arguments
    public Employee()
    {
        id = 0;
        name = "Unknown";
        salary = 0;
    }
    
    // Constructor 2: One argument
    public Employee(string n)
    {
        id = 0;
        name = n;
        salary = 0;
    }
    
    // Constructor 3: Two arguments
    public Employee(string n, double s)
    {
        id = 0;
        name = n;
        salary = s;
    }
    
    // Constructor 4: Three arguments
    public Employee(int i, string n, double s)
    {
        id = i;
        name = n;
        salary = s;
    }
    
    public void Display()
    {
        Console.WriteLine($"ID: {id}, Name: {name}, Salary: {salary:C}");
    }
}

class Program
{
    static void Main()
    {
        Employee e1 = new Employee();
        Employee e2 = new Employee("Raj");
        Employee e3 = new Employee("Priya", 50000);
        Employee e4 = new Employee(101, "Amit", 75000);
        
        e1.Display();  // ID: 0, Name: Unknown, Salary: $0.00
        e2.Display();  // ID: 0, Name: Raj, Salary: $0.00
        e3.Display();  // ID: 0, Name: Priya, Salary: $50,000.00
        e4.Display();  // ID: 101, Name: Amit, Salary: $75,000.00
    }
}
```

---

## 5. The `this` Keyword

### Purpose
- Refers to the current instance of the class
- Differentiates between instance variables and parameters
- Used to call other constructors from within a constructor

### Using `this` for Field Access

```csharp
class Student
{
    private int rollNo;
    private string name;
    
    public Student(int rollNo, string name)
    {
        // Use 'this' to differentiate parameter from field
        this.rollNo = rollNo;  // this.rollNo = field, rollNo = parameter
        this.name = name;      // this.name = field, name = parameter
    }
}
```

### Without `this` - Name Shadowing Problem

```csharp
class Student
{
    private int rollNo;
    private string name;
    
    // ❌ BAD: Parameters shadow fields
    public Student(int rollNo, string name)
    {
        rollNo = rollNo;  // Assigns parameter to itself! Field unchanged.
        name = name;      // Same problem
    }
}
```

---

## 6. Constructor Chaining with `this`

### Calling Another Constructor

```csharp
class Employee
{
    private int id;
    private string name;
    private double salary;
    private string department;
    
    // Master constructor (does all the work)
    public Employee(int id, string name, double salary, string department)
    {
        this.id = id;
        this.name = name;
        this.salary = salary;
        this.department = department;
        Console.WriteLine("Master constructor called");
    }
    
    // Chain to master constructor
    public Employee() : this(0, "Unknown", 0, "General")
    {
        Console.WriteLine("Default constructor called");
    }
    
    // Chain to master constructor
    public Employee(string name) : this(0, name, 0, "General")
    {
        Console.WriteLine("Name-only constructor called");
    }
    
    // Chain to master constructor
    public Employee(string name, double salary) : this(0, name, salary, "General")
    {
        Console.WriteLine("Name-salary constructor called");
    }
    
    public void Display()
    {
        Console.WriteLine($"ID: {id}, Name: {name}, " +
                         $"Salary: {salary:C}, Dept: {department}");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Creating e1:");
        Employee e1 = new Employee();
        
        Console.WriteLine("\nCreating e2:");
        Employee e2 = new Employee("Raj");
        
        Console.WriteLine("\nCreating e3:");
        Employee e3 = new Employee("Priya", 50000);
        
        Console.WriteLine("\nCreating e4:");
        Employee e4 = new Employee(101, "Amit", 75000, "IT");
    }
}
```

### Output:
```
Creating e1:
Master constructor called
Default constructor called

Creating e2:
Master constructor called
Name-only constructor called

Creating e3:
Master constructor called
Name-salary constructor called

Creating e4:
Master constructor called
```

### Benefits of Constructor Chaining
1. **DRY Principle**: Don't Repeat Yourself
2. **Single point of initialization**: All validation in one place
3. **Easier maintenance**: Change logic in one place

---

## 7. Constructor with Validation

```csharp
class Account
{
    private static int counter;
    private int id;
    private string name;
    private double balance;
    
    public Account(string name, double balance)
    {
        // Validation
        if (string.IsNullOrEmpty(name) || name.Length < 3)
        {
            throw new ArgumentException("Name must be at least 3 characters");
        }
        
        if (balance < 0)
        {
            throw new ArgumentException("Balance cannot be negative");
        }
        
        counter++;
        this.id = counter;
        this.name = name;
        this.balance = balance;
    }
    
    public override string ToString()
    {
        return $"ID: {id}, Name: {name}, Balance: {balance:C}";
    }
}

class Program
{
    static void Main()
    {
        try
        {
            Account a1 = new Account("Raj", 10000);  // OK
            Console.WriteLine(a1);
            
            Account a2 = new Account("AB", 5000);  // Exception!
        }
        catch (ArgumentException ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
        }
    }
}
```

---

## 8. Private Constructor

### Preventing Object Creation

```csharp
class UtilityClass
{
    // Private constructor - cannot create instances
    private UtilityClass()
    {
    }
    
    // Only static methods
    public static int Add(int a, int b) => a + b;
    public static int Multiply(int a, int b) => a * b;
}

class Program
{
    static void Main()
    {
        // ❌ Cannot create instance
        // UtilityClass obj = new UtilityClass();  // Error!
        
        // ✅ Can use static methods
        Console.WriteLine(UtilityClass.Add(5, 3));
    }
}
```

---

## 9. Copy Constructor

### Creating Copy of Object

```csharp
class Student
{
    public int rollNo;
    public string name;
    public double marks;
    
    // Regular constructor
    public Student(int rollNo, string name, double marks)
    {
        this.rollNo = rollNo;
        this.name = name;
        this.marks = marks;
    }
    
    // Copy constructor
    public Student(Student other)
    {
        this.rollNo = other.rollNo;
        this.name = other.name;
        this.marks = other.marks;
    }
    
    public override string ToString()
    {
        return $"RollNo: {rollNo}, Name: {name}, Marks: {marks}";
    }
}

class Program
{
    static void Main()
    {
        Student s1 = new Student(101, "Raj", 85.5);
        
        // Create copy
        Student s2 = new Student(s1);
        
        // Modify copy
        s2.name = "Priya";
        s2.marks = 90.0;
        
        Console.WriteLine(s1);  // RollNo: 101, Name: Raj, Marks: 85.5
        Console.WriteLine(s2);  // RollNo: 101, Name: Priya, Marks: 90
    }
}
```

---

## 10. Constructor Execution Order

```csharp
class Demo
{
    // Static field
    static int staticValue = InitStatic();
    
    // Instance field
    int instanceValue = InitInstance();
    
    static int InitStatic()
    {
        Console.WriteLine("1. Static field initialized");
        return 1;
    }
    
    int InitInstance()
    {
        Console.WriteLine("3. Instance field initialized");
        return 2;
    }
    
    // Static constructor
    static Demo()
    {
        Console.WriteLine("2. Static constructor executed");
    }
    
    // Instance constructor
    public Demo()
    {
        Console.WriteLine("4. Instance constructor executed");
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Creating first object:");
        Demo d1 = new Demo();
        
        Console.WriteLine("\nCreating second object:");
        Demo d2 = new Demo();
    }
}
```

### Output:
```
Creating first object:
1. Static field initialized
2. Static constructor executed
3. Instance field initialized
4. Instance constructor executed

Creating second object:
3. Instance field initialized
4. Instance constructor executed
```

---

## Key Points Summary

1. **Constructor** = Special method to initialize objects
2. **Same name as class** with no return type
3. **Default constructor** provided if no constructor defined
4. **Parameterized constructor** accepts arguments
5. **Constructor overloading** = Multiple constructors with different parameters
6. **`this` keyword** = Reference to current object
7. **`this()` call** = Constructor chaining
8. **Private constructor** = Prevents instantiation
9. **Copy constructor** = Creates copy of existing object
10. **Static constructor** runs once, before instance constructors

---

## Practice Questions

1. What is the difference between constructor and method?
2. What happens if you define a parameterized constructor but no default constructor?
3. How does constructor chaining work?
4. What is the purpose of the `this` keyword in constructors?
5. In what order are static and instance constructors called?
6. What is a copy constructor?
7. When would you use a private constructor?
