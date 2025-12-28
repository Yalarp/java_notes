# Inheritance Basics in C#

## Overview
Inheritance is a fundamental OOP concept that allows a class to inherit members from another class, promoting code reuse and establishing hierarchical relationships between types.

---

## 1. What is Inheritance?

### Definition
**Inheritance** is a mechanism where a new class (derived/child/sub class) acquires properties and behaviors from an existing class (base/parent/super class).

### Real-World Analogy
```
                    Vehicle (Base)
                    - Engine, Wheels
                    - Start(), Stop()
                        │
        ┌───────────────┼───────────────┐
        │               │               │
       Car            Bike          Truck
   - 4 wheels      - 2 wheels     - 6+ wheels
   - AC, Music     - Handle       - Cargo space
```

---

## 2. Inheritance Syntax

```csharp
// Base class (Parent)
class BaseClass
{
    // Members that can be inherited
}

// Derived class (Child) - uses colon (:) to inherit
class DerivedClass : BaseClass
{
    // Additional members
    // Inherited members are accessible based on access modifiers
}
```

---

## 3. Basic Example

```csharp
using System;

// Base class
class Animal
{
    // Fields
    public string Name { get; set; }
    public int Age { get; set; }
    
    // Constructor
    public Animal(string name, int age)
    {
        Name = name;
        Age = age;
        Console.WriteLine("Animal constructor called");
    }
    
    // Methods
    public void Eat()
    {
        Console.WriteLine($"{Name} is eating");
    }
    
    public void Sleep()
    {
        Console.WriteLine($"{Name} is sleeping");
    }
}

// Derived class - inherits from Animal
class Dog : Animal
{
    // Additional field specific to Dog
    public string Breed { get; set; }
    
    // Constructor - must call base constructor
    public Dog(string name, int age, string breed) : base(name, age)
    {
        Breed = breed;
        Console.WriteLine("Dog constructor called");
    }
    
    // Additional method specific to Dog
    public void Bark()
    {
        Console.WriteLine($"{Name} says Woof! Woof!");
    }
    
    // Method to display all info
    public void DisplayInfo()
    {
        Console.WriteLine($"Name: {Name}, Age: {Age}, Breed: {Breed}");
    }
}

class Program
{
    static void Main()
    {
        // Create Dog object
        Dog dog = new Dog("Buddy", 3, "Labrador");
        
        // Access inherited members
        dog.Eat();          // Inherited from Animal
        dog.Sleep();        // Inherited from Animal
        
        // Access Dog-specific members
        dog.Bark();         // Defined in Dog
        dog.DisplayInfo();  // Defined in Dog
    }
}
```

### Output:
```
Animal constructor called
Dog constructor called
Buddy is eating
Buddy is sleeping
Buddy says Woof! Woof!
Name: Buddy, Age: 3, Breed: Labrador
```

---

## 4. Types of Inheritance in C#

### 4.1 Single Inheritance
One class inherits from one base class.

```csharp
class A { }
class B : A { }  // B inherits from A only
```

### 4.2 Multi-Level Inheritance
Chain of inheritance where class C inherits B, which inherits A.

```csharp
class A { }
class B : A { }  // B inherits A
class C : B { }  // C inherits B (and indirectly A)
```

```csharp
// Example
class LivingBeing
{
    public void Breathe() => Console.WriteLine("Breathing");
}

class Animal : LivingBeing
{
    public void Move() => Console.WriteLine("Moving");
}

class Dog : Animal
{
    public void Bark() => Console.WriteLine("Barking");
}

Dog d = new Dog();
d.Breathe();  // From LivingBeing
d.Move();     // From Animal
d.Bark();     // From Dog
```

### 4.3 Hierarchical Inheritance
Multiple classes inherit from a single base class.

```csharp
class Animal { }
class Dog : Animal { }    // Dog inherits Animal
class Cat : Animal { }    // Cat inherits Animal
class Lion : Animal { }   // Lion inherits Animal
```

### 4.4 Multiple Inheritance - NOT Supported!
C# does NOT support multiple inheritance (one class inheriting from multiple classes).

```csharp
class A { }
class B { }

// ❌ ERROR: Cannot inherit from multiple classes
// class C : A, B { }
```

**Why Not?** Diamond problem - ambiguity when same member exists in both bases.

**Solution:** Use **Interfaces** for multiple inheritance-like behavior.

```csharp
interface IFlyable { void Fly(); }
interface ISwimmable { void Swim(); }

// ✅ Can implement multiple interfaces
class Duck : Animal, IFlyable, ISwimmable
{
    public void Fly() => Console.WriteLine("Flying");
    public void Swim() => Console.WriteLine("Swimming");
}
```

---

## 5. What Gets Inherited?

### Inherited Members

| Member Type | Inherited? | Notes |
|-------------|------------|-------|
| public fields/properties | ✅ Yes | Accessible in derived class |
| protected fields/properties | ✅ Yes | Accessible in derived class |
| public methods | ✅ Yes | Can be called on derived object |
| protected methods | ✅ Yes | Accessible in derived class |
| internal members | ✅ Yes* | Only if derived class in same assembly |
| private members | ❌ No | Not accessible in derived class |
| Constructors | ❌ No | Must define own constructors |
| Static constructors | ❌ No | Not inherited |
| Destructors | ❌ No | Not inherited |

### Example

```csharp
class Parent
{
    public int PublicField = 1;
    protected int ProtectedField = 2;
    private int PrivateField = 3;  // Not inherited
    internal int InternalField = 4;
    
    public void PublicMethod() { }
    protected void ProtectedMethod() { }
    private void PrivateMethod() { }  // Not inherited
}

class Child : Parent
{
    public void Test()
    {
        Console.WriteLine(PublicField);      // ✅ Accessible
        Console.WriteLine(ProtectedField);   // ✅ Accessible
        // Console.WriteLine(PrivateField);  // ❌ Error
        Console.WriteLine(InternalField);    // ✅ Accessible
        
        PublicMethod();     // ✅ Accessible
        ProtectedMethod();  // ✅ Accessible
        // PrivateMethod(); // ❌ Error
    }
}
```

---

## 6. Access Modifiers in Inheritance

```
┌────────────────────────────────────────────────────────────────────┐
│                     ACCESS MODIFIER VISIBILITY                      │
├───────────────┬─────────┬───────────┬──────────────┬───────────────┤
│   Modifier    │ Same    │ Derived   │ Same         │ Outside       │
│               │ Class   │ Class     │ Assembly     │ Assembly      │
├───────────────┼─────────┼───────────┼──────────────┼───────────────┤
│ public        │   ✅    │    ✅     │     ✅       │      ✅       │
│ private       │   ✅    │    ❌     │     ❌       │      ❌       │
│ protected     │   ✅    │    ✅     │     ❌       │      ❌       │
│ internal      │   ✅    │    ✅*    │     ✅       │      ❌       │
│ prot internal │   ✅    │    ✅     │     ✅       │      ❌       │
│ priv protected│   ✅    │    ✅**   │     ❌       │      ❌       │
└───────────────┴─────────┴───────────┴──────────────┴───────────────┘
* Only if derived class in same assembly
** Only if derived class in same assembly
```

---

## 7. The `base` Keyword

### Purpose
- Access parent class members from derived class
- Call parent class constructor
- Invoke parent version of overridden method

### Accessing Parent Members

```csharp
class Parent
{
    protected string name = "Parent";
    
    public virtual void Display()
    {
        Console.WriteLine("Parent Display");
    }
}

class Child : Parent
{
    private string name = "Child";  // Hides parent's name
    
    public void ShowNames()
    {
        Console.WriteLine($"Child name: {this.name}");   // Child
        Console.WriteLine($"Parent name: {base.name}");  // Parent
    }
    
    public override void Display()
    {
        base.Display();  // Call parent version first
        Console.WriteLine("Child Display");
    }
}
```

---

## 8. The `sealed` Keyword

### Prevent Inheritance

```csharp
sealed class FinalClass
{
    // This class cannot be inherited
}

// ❌ ERROR: Cannot inherit from sealed class
// class Derived : FinalClass { }
```

### Seal a Method (Prevent Override)

```csharp
class A
{
    public virtual void Method() { }
}

class B : A
{
    public sealed override void Method() { }  // Can override but seal it
}

class C : B
{
    // ❌ ERROR: Cannot override sealed method
    // public override void Method() { }
}
```

---

## 9. Object Class - Ultimate Base

Every class in C# implicitly inherits from `System.Object`.

```csharp
class MyClass { }
// Equivalent to:
class MyClass : System.Object { }
```

### Object Class Methods (Available to All)

```csharp
class Demo
{
    public void ShowObjectMethods()
    {
        object obj = this;
        
        // All objects have these methods:
        string str = obj.ToString();           // String representation
        Type type = obj.GetType();             // Runtime type info
        int hash = obj.GetHashCode();          // Hash code
        bool equal = obj.Equals(someOther);    // Equality check
    }
}
```

---

## 10. IS-A Relationship

Inheritance creates an "IS-A" relationship.

```csharp
class Animal { }
class Dog : Animal { }
class Cat : Animal { }

Dog dog = new Dog();

// A Dog IS-A Animal
Console.WriteLine(dog is Animal);  // True

// An Animal is NOT necessarily a Dog
Animal animal = new Animal();
Console.WriteLine(animal is Dog);  // False

// Polymorphism: Parent reference can hold child object
Animal myPet = new Dog();  // Valid: Dog IS-A Animal
// Dog d = new Animal();   // ❌ Invalid: Animal is NOT a Dog
```

---

## 11. Complete Example: Employee Hierarchy

```csharp
using System;

// Base class
class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double BaseSalary { get; protected set; }
    
    public Employee(int id, string name, double salary)
    {
        Id = id;
        Name = name;
        BaseSalary = salary;
    }
    
    public virtual double CalculateSalary()
    {
        return BaseSalary;
    }
    
    public virtual void DisplayInfo()
    {
        Console.WriteLine($"ID: {Id}");
        Console.WriteLine($"Name: {Name}");
        Console.WriteLine($"Salary: {CalculateSalary():C}");
    }
}

// Derived class
class Manager : Employee
{
    public int TeamSize { get; set; }
    public double Bonus { get; set; }
    
    public Manager(int id, string name, double salary, int teamSize, double bonus) 
        : base(id, name, salary)
    {
        TeamSize = teamSize;
        Bonus = bonus;
    }
    
    public override double CalculateSalary()
    {
        return BaseSalary + Bonus + (TeamSize * 1000);  // Extra per team member
    }
    
    public override void DisplayInfo()
    {
        base.DisplayInfo();
        Console.WriteLine($"Team Size: {TeamSize}");
        Console.WriteLine($"Bonus: {Bonus:C}");
    }
}

// Another derived class
class Developer : Employee
{
    public string Technology { get; set; }
    public int ProjectsCompleted { get; set; }
    
    public Developer(int id, string name, double salary, string tech, int projects)
        : base(id, name, salary)
    {
        Technology = tech;
        ProjectsCompleted = projects;
    }
    
    public override double CalculateSalary()
    {
        return BaseSalary + (ProjectsCompleted * 500);  // Bonus per project
    }
    
    public override void DisplayInfo()
    {
        base.DisplayInfo();
        Console.WriteLine($"Technology: {Technology}");
        Console.WriteLine($"Projects: {ProjectsCompleted}");
    }
}

class Program
{
    static void Main()
    {
        // Polymorphism: Array of base type holding derived objects
        Employee[] employees = new Employee[]
        {
            new Employee(1, "Raj", 40000),
            new Manager(2, "Priya", 60000, 5, 10000),
            new Developer(3, "Amit", 50000, "C#", 8)
        };
        
        Console.WriteLine("=== Employee Details ===\n");
        
        foreach (Employee emp in employees)
        {
            emp.DisplayInfo();  // Calls appropriate override
            Console.WriteLine();
        }
    }
}
```

---

## 12. Memory Diagram for Inheritance

```
Dog dog = new Dog("Buddy", 3, "Labrador");

Stack                          Heap
┌──────────────┐              ┌───────────────────────────┐
│    dog       │─────────────>│     Dog Object            │
│  (reference) │              │  ┌─────────────────────┐  │
└──────────────┘              │  │ Animal Part (Base)  │  │
                              │  │  Name = "Buddy"     │  │
                              │  │  Age = 3            │  │
                              │  ├─────────────────────┤  │
                              │  │ Dog Part (Derived)  │  │
                              │  │  Breed = "Labrador" │  │
                              │  └─────────────────────┘  │
                              └───────────────────────────┘
```

---

## Key Points Summary

1. **Inheritance** = Child class acquires members of parent class
2. **Single inheritance only** in C# (use interfaces for multiple)
3. **Colon (:)** syntax to inherit
4. **private members** not inherited
5. **protected members** accessible in derived class
6. **base keyword** accesses parent members/constructor
7. **sealed** prevents inheritance
8. All classes inherit from **Object**
9. Creates **IS-A** relationship
10. Enables **polymorphism** (parent reference → child object)

---

## Common Mistakes to Avoid

1. ❌ Trying to inherit from multiple classes
2. ❌ Forgetting to call base constructor when needed
3. ❌ Trying to access private members from derived class
4. ❌ Circular inheritance (A:B, B:A)
5. ❌ Inheriting from sealed class

---

## Practice Questions

1. What types of inheritance does C# support?
2. What is the diamond problem and how does C# avoid it?
3. What is the difference between private and protected?
4. Can a derived class access private members of base class?
5. What is the purpose of the sealed keyword?
6. What does the base keyword do?
7. What class do all C# classes inherit from?
8. Explain the IS-A relationship with an example.
