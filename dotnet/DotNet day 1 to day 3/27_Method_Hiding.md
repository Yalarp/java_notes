# Method Hiding and Overriding in C#

## Overview
When a derived class has a method with the same signature as the base class, you can either **hide** the base method using `new` or **override** it using `virtual`/`override`. Understanding the difference is crucial for polymorphism.

---

## 1. Method Hiding with `new` Keyword

### What is Method Hiding?
When a derived class defines a method with the same name as the base class, it **hides** the base class version.

```csharp
class Parent
{
    public void Display()
    {
        Console.WriteLine("Parent Display");
    }
}

class Child : Parent
{
    // Using 'new' keyword explicitly hides parent method
    public new void Display()
    {
        Console.WriteLine("Child Display");
    }
}
```

### Behavior of Hidden Methods

```csharp
Child child = new Child();
child.Display();  // "Child Display" - calls Child's version

Parent parent = new Child();  // Parent reference, Child object
parent.Display();  // "Parent Display" - calls Parent's version!
```

**Key Point:** With hiding, the **reference type** determines which method is called.

---

## 2. Method Overriding with `virtual` and `override`

### What is Overriding?
The derived class **replaces** the base class implementation. Requires `virtual` in base and `override` in derived.

```csharp
class Parent
{
    public virtual void Display()  // Mark as virtual
    {
        Console.WriteLine("Parent Display");
    }
}

class Child : Parent
{
    public override void Display()  // Override the virtual method
    {
        Console.WriteLine("Child Display");
    }
}
```

### Behavior of Overridden Methods

```csharp
Child child = new Child();
child.Display();  // "Child Display"

Parent parent = new Child();  // Parent reference, Child object
parent.Display();  // "Child Display" - calls Child's version!
```

**Key Point:** With overriding, the **object type** (actual runtime type) determines which method is called. This is **polymorphism**.

---

## 3. Hiding vs Overriding Comparison

```csharp
class Animal
{
    public void MakeSound()  // Non-virtual - can be hidden
    {
        Console.WriteLine("Animal sound");
    }
    
    public virtual void Move()  // Virtual - can be overridden
    {
        Console.WriteLine("Animal moves");
    }
}

class Dog : Animal
{
    public new void MakeSound()  // HIDING
    {
        Console.WriteLine("Dog barks");
    }
    
    public override void Move()  // OVERRIDING
    {
        Console.WriteLine("Dog runs");
    }
}

// Test both behaviors
Dog dog = new Dog();
Animal animal = dog;  // Same object, different reference type

Console.WriteLine("=== Calling via Dog reference ===");
dog.MakeSound();  // Dog barks
dog.Move();       // Dog runs

Console.WriteLine("\n=== Calling via Animal reference ===");
animal.MakeSound();  // Animal sound (HIDING - reference type wins)
animal.Move();       // Dog runs (OVERRIDING - object type wins)
```

### Summary Table

| Aspect | Hiding (new) | Overriding (virtual/override) |
|--------|-------------|------------------------------|
| **Keywords** | `new` | `virtual` + `override` |
| **Binding** | Compile-time (static) | Runtime (dynamic) |
| **Reference Type** | Determines method called | ❌ Doesn't matter |
| **Object Type** | ❌ Ignored | ✅ Determines method called |
| **Polymorphism** | ❌ No | ✅ Yes |
| **Base virtual required** | No | Yes |

---

## 4. Without `new` Keyword - Compiler Warning

```csharp
class Parent
{
    public void Method()
    {
        Console.WriteLine("Parent");
    }
}

class Child : Parent
{
    // ⚠️ WARNING: 'Child.Method()' hides inherited member 'Parent.Method()'. 
    // Use the new keyword if hiding was intended.
    public void Method()
    {
        Console.WriteLine("Child");
    }
}
```

Fix by adding `new`:
```csharp
public new void Method()  // Warning gone
{
    Console.WriteLine("Child");
}
```

---

## 5. Calling Hidden/Overridden Parent Method

### Using `base` Keyword

```csharp
class Parent
{
    public virtual void Greet()
    {
        Console.WriteLine("Hello from Parent");
    }
}

class Child : Parent
{
    public override void Greet()
    {
        base.Greet();  // Call parent version first
        Console.WriteLine("Hello from Child");
    }
}

new Child().Greet();
// Output:
// Hello from Parent
// Hello from Child
```

### Works with Hiding Too

```csharp
class Parent
{
    public void Show()
    {
        Console.WriteLine("Parent Show");
    }
}

class Child : Parent
{
    public new void Show()
    {
        base.Show();  // Call hidden parent method
        Console.WriteLine("Child Show");
    }
}
```

---

## 6. Multi-Level Overriding

```csharp
class A
{
    public virtual void Method()
    {
        Console.WriteLine("A.Method");
    }
}

class B : A
{
    public override void Method()
    {
        Console.WriteLine("B.Method");
    }
}

class C : B
{
    public override void Method()
    {
        Console.WriteLine("C.Method");
    }
}

A obj = new C();
obj.Method();  // "C.Method" - most derived override is called
```

---

## 7. Sealing an Override

Use `sealed override` to prevent further overriding.

```csharp
class A
{
    public virtual void Method()
    {
        Console.WriteLine("A.Method");
    }
}

class B : A
{
    public sealed override void Method()  // Cannot be overridden further
    {
        Console.WriteLine("B.Method");
    }
}

class C : B
{
    // ❌ ERROR: Cannot override sealed method
    // public override void Method() { }
    
    // ✅ But can hide it with new
    public new void Method()
    {
        Console.WriteLine("C.Method (hidden)");
    }
}
```

---

## 8. Hiding Properties and Fields

### Hiding Properties

```csharp
class Parent
{
    public int Value { get; set; }
    public virtual int VirtualValue { get; set; }
}

class Child : Parent
{
    public new int Value { get; set; }  // Hides parent property
    public override int VirtualValue { get; set; }  // Overrides
}

Child c = new Child();
c.Value = 10;               // Child's Value
c.VirtualValue = 20;        // Child's VirtualValue

Parent p = c;
p.Value = 30;               // Parent's Value (hiding)
p.VirtualValue = 40;        // Child's VirtualValue (overriding)
```

### Hiding Fields

```csharp
class Parent
{
    public string name = "Parent";
}

class Child : Parent
{
    public new string name = "Child";  // Hides parent field
}

Child c = new Child();
Console.WriteLine(c.name);  // "Child"

Parent p = c;
Console.WriteLine(p.name);  // "Parent" (hiding)
```

---

## 9. Static Members and Hiding

Static members can be hidden but not overridden.

```csharp
class Parent
{
    public static void StaticMethod()
    {
        Console.WriteLine("Parent Static");
    }
}

class Child : Parent
{
    public new static void StaticMethod()  // Must use 'new'
    {
        Console.WriteLine("Child Static");
    }
}

Parent.StaticMethod();  // "Parent Static"
Child.StaticMethod();   // "Child Static"

// Note: static members are called on TYPE, not instance
```

---

## 10. Complete Polymorphism Example

```csharp
using System;

abstract class Shape
{
    public string Name { get; set; }
    
    public Shape(string name) => Name = name;
    
    // Virtual method for polymorphism
    public virtual double CalculateArea()
    {
        return 0;
    }
    
    // Non-virtual method
    public void Display()
    {
        Console.WriteLine($"Shape: {Name}");
    }
}

class Circle : Shape
{
    public double Radius { get; set; }
    
    public Circle(double radius) : base("Circle") 
    { 
        Radius = radius; 
    }
    
    public override double CalculateArea()
    {
        return Math.PI * Radius * Radius;
    }
    
    public new void Display()  // Hiding Display
    {
        Console.WriteLine($"Circle with radius {Radius}");
    }
}

class Rectangle : Shape
{
    public double Width { get; set; }
    public double Height { get; set; }
    
    public Rectangle(double width, double height) : base("Rectangle")
    {
        Width = width;
        Height = height;
    }
    
    public override double CalculateArea()
    {
        return Width * Height;
    }
}

class Program
{
    static void Main()
    {
        // Polymorphic array
        Shape[] shapes = new Shape[]
        {
            new Circle(5),
            new Rectangle(4, 6),
            new Circle(3)
        };
        
        Console.WriteLine("=== Using Shape reference (Polymorphism) ===");
        foreach (Shape shape in shapes)
        {
            shape.Display();  // Always calls Shape.Display (hiding)
            Console.WriteLine($"Area: {shape.CalculateArea():F2}");  // Polymorphic call
            Console.WriteLine();
        }
        
        Console.WriteLine("=== Using actual type reference ===");
        Circle c = new Circle(5);
        c.Display();  // Calls Circle.Display
        Console.WriteLine($"Area: {c.CalculateArea():F2}");
    }
}
```

---

## 11. Memory/Execution Flow Diagram

```
Shape shape = new Circle(5);
shape.CalculateArea();  // How is this resolved?

┌─────────────────────────────────────────────────────────┐
│ 1. shape.CalculateArea() is called                      │
│ 2. Compiler sees shape is type Shape                    │
│ 3. Shape.CalculateArea is marked virtual                │
│ 4. At RUNTIME, CLR checks actual object type            │
│ 5. Actual type is Circle                                │
│ 6. Circle has override CalculateArea                    │
│ 7. Circle.CalculateArea() is executed                   │
└─────────────────────────────────────────────────────────┘

Result: Circle's CalculateArea returns π * 5² = 78.54
```

---

## Key Points Summary

1. **Method Hiding (`new`)**: Reference type determines method called
2. **Method Overriding (`virtual`/`override`)**: Object type determines method called
3. **virtual** in base class → **override** in derived class
4. Without `new` keyword → compiler warning
5. **base** keyword calls parent version
6. **sealed override** prevents further overriding
7. Static members can only be hidden, not overridden
8. Overriding enables **polymorphism**

---

## Common Mistakes to Avoid

1. ❌ Using `override` without `virtual` in base class
2. ❌ Forgetting `new` and getting compiler warning
3. ❌ Expecting hiding to work like overriding
4. ❌ Trying to override a sealed method
5. ❌ Confusing compile-time vs runtime binding

---

## Practice Questions

1. What is the difference between hiding and overriding?
2. What determines which method is called in hiding? In overriding?
3. What keywords are required for overriding?
4. What happens if you don't use `new` when hiding?
5. How do you prevent a virtual method from being overridden?
6. Can static methods be overridden?
7. How do you call the hidden/overridden parent method?
