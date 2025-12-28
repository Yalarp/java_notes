# Polymorphism and Virtual Methods in C#

## 📚 Introduction

**Polymorphism** is one of the four fundamental pillars of Object-Oriented Programming (OOP). The word comes from Greek meaning "many forms." In C#, polymorphism allows objects of different types to be treated as objects of a common base type, enabling a single interface to represent different underlying implementations.

### Why Polymorphism Matters
- Enables writing flexible and extensible code
- Allows runtime method resolution (late binding)
- Supports the Open/Closed Principle (open for extension, closed for modification)
- Facilitates code reuse through inheritance hierarchies

---

## 🎯 Learning Objectives

By the end of this note, you will understand:
- The difference between compile-time and runtime polymorphism
- How `virtual` and `override` keywords work
- Method resolution at runtime
- Upcasting and its relationship with polymorphism
- When to use virtual methods vs abstract methods

---

## 🔍 Conceptual Overview

### Types of Polymorphism in C#

```
┌─────────────────────────────────────────────────────────────┐
│                    POLYMORPHISM                              │
├────────────────────────────┬────────────────────────────────┤
│   Compile-Time (Static)    │    Runtime (Dynamic)           │
│   - Method Overloading     │    - Method Overriding         │
│   - Operator Overloading   │    - Virtual Methods           │
│   Resolved at compile time │    Resolved at runtime         │
└────────────────────────────┴────────────────────────────────┘
```

### Key Concepts

#### 1. Sealed Methods by Default
In C#, **all methods are sealed by default**, meaning they cannot be overridden. This is different from Java where methods are virtual by default.

```csharp
// In C#, this method CANNOT be overridden
public void Display() { }

// This method CAN be overridden
public virtual void Display() { }
```

#### 2. Virtual Keyword
The `virtual` keyword marks a method as overridable. It provides a default implementation that child classes can optionally replace.

#### 3. Override Keyword
The `override` keyword is used in a derived class to provide a new implementation for a virtual method.

#### 4. Method Resolution at Runtime
When you call a virtual method through a base class reference, the CLR determines at runtime which implementation to call based on the actual object type.

---

## 💻 Code Examples

### Example 1: Understanding Reference Type Compatibility

```csharp
// This program will not compile - demonstrates incompatible references
class Animal
{
    int a;
    public Animal(int i) { a = i; }
}

class Human
{
    int a;
    public Human(int i) { a = i; }
}

class IncompatibleRef
{
    public static void Main()
    {
        Animal a = new Animal(10);
        Human h = new Human(5);
        Animal a2;
        
        a2 = a;   // OK, both of same type
        a2 = h;   // ERROR! Cannot assign Human to Animal
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 1-5 | `class Animal { ... }` | Defines Animal class with integer field `a` and constructor |
| 7-11 | `class Human { ... }` | Defines Human class with same structure but different type |
| 15 | `Animal a = new Animal(10);` | Creates Animal object, `a` points to it |
| 16 | `Human h = new Human(5);` | Creates Human object, `h` points to it |
| 17 | `Animal a2;` | Declares reference variable of type Animal |
| 19 | `a2 = a;` | Valid: Both are Animal type |
| 20 | `a2 = h;` | **COMPILE ERROR**: Cannot convert Human to Animal |

#### Memory Diagram
```
Stack                     Heap
┌─────┐                  ┌──────────┐
│  a  │ ───────────────► │ a = 10   │ Animal
└─────┘                  └──────────┘
┌─────┐                  ┌──────────┐
│  h  │ ───────────────► │ a = 5    │ Human
└─────┘                  └──────────┘
┌─────┐
│ a2  │ ─── Cannot point to Human!
└─────┘
```

**Key Insight**: You cannot assign incompatible types even if they have similar structure. Type compatibility requires inheritance relationship.

---

### Example 2: Base Class Reference to Derived Class Object (Upcasting)

```csharp
using System;

class Mammal
{
    public int a;
    public Mammal(int i)
    {
        a = i;
    }
}

class Animal : Mammal
{
    public int b;
    public Animal(int i, int j) : base(j)
    {
        b = i;
    }
}

class BaseRef
{
    public static void Main()
    {
        Mammal m = new Mammal(10);
        Mammal m2;
        Animal anim = new Animal(5, 6);
        
        m2 = m;     // OK, both of same type
        Console.WriteLine("m2.a: " + m2.a);  // Output: 10
        
        m2 = anim;  // OK! Animal is derived from Mammal
        Console.WriteLine("m2.a: " + m2.a);  // Output: 6
        
        m2.a = 19;  // OK - Mammal knows about 'a'
        // m2.b = 27;  // ERROR! m2 doesn't know about 'b'
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 3-9 | `class Mammal` | Base class with public field `a` and constructor |
| 11-18 | `class Animal : Mammal` | Derived class inheriting from Mammal, adds field `b` |
| 15 | `: base(j)` | Calls parent constructor with value `j` |
| 24 | `Mammal m = new Mammal(10);` | Creates Mammal object with a=10 |
| 26 | `Animal anim = new Animal(5, 6);` | Creates Animal with b=5, a=6 |
| 28 | `m2 = m;` | Both Mammal type, assignment OK |
| 31 | `m2 = anim;` | **UPCASTING**: Parent reference can hold child object |
| 34 | `m2.a = 19;` | OK: Mammal reference knows about field `a` |
| 35 | `// m2.b = 27;` | **ERROR**: Mammal reference doesn't know field `b` |

#### Memory Diagram
```
Stack                          Heap
┌─────┐                       ┌──────────────────┐
│  m  │ ─────────────────────►│ a = 10           │ Mammal
└─────┘                       └──────────────────┘
┌─────┐                       ┌──────────────────┐
│anim │ ─────────────────────►│ a = 6 → 19       │
└─────┘                       │ b = 5            │ Animal
┌─────┐                       │                  │
│ m2  │ ─────────────────────►└──────────────────┘
└─────┘
```

**Key Rule**: `Parent p = new Child();` is valid because child IS-A parent. However, `p` can only access members known to Parent.

---

### Example 3: Virtual Method Without Override (Method Hiding)

```csharp
using System;
namespace ConsoleApplication7
{
    class Shape
    {
        public int H;
        public int W;
        
        public Shape(int h, int w)
        {
            H = h;
            W = w;
        }
        
        public virtual double Area()  // Virtual - can be overridden
        {
            return 0;
        }
    }
    
    class Rectangle : Shape
    {
        public Rectangle(int p, int q) : base(p, q) { }
        
        public double Area()  // NO override keyword - HIDES parent method
        {
            return H * W;
        }
    }
    
    class Triangle : Shape
    {
        public Triangle(int p, int q) : base(p, q) { }
        
        public double Area()  // NO override keyword - HIDES parent method
        {
            return (H * W) / 2.0;
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Shape s1 = new Triangle(5, 5);
            Console.WriteLine(s1.Area());  // Output: 0 (NOT 12.5!)
            
            Shape s2 = new Rectangle(5, 5);
            Console.WriteLine(s2.Area());  // Output: 0 (NOT 25!)
        }
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 15 | `public virtual double Area()` | Declares virtual method - can be overridden |
| 25 | `public double Area()` | **HIDES** parent method (no override keyword) |
| 45 | `Shape s1 = new Triangle(5, 5);` | Upcasting: Shape reference to Triangle object |
| 46 | `s1.Area();` | Calls **Shape.Area()** returning 0! |

#### Why Does This Happen?

```
┌───────────────────────────────────────────────────────────────┐
│  Without 'override' keyword:                                   │
│  - Child method HIDES parent method                           │
│  - Parent reference calls PARENT'S method                     │
│  - Compiler warning: "...hides inherited member..."           │
├───────────────────────────────────────────────────────────────┤
│  With 'override' keyword:                                      │
│  - Child method OVERRIDES parent method                       │
│  - Parent reference calls CHILD'S method (runtime resolution) │
│  - True polymorphism achieved                                 │
└───────────────────────────────────────────────────────────────┘
```

**Important**: Virtual members cannot be `private`.

---

### Example 4: Proper Polymorphism with Override

```csharp
using System;
namespace ConsoleApplication7
{
    class Shape
    {
        public int H;
        public int W;
        
        public Shape(int h, int w)
        {
            H = h;
            W = w;
        }
        
        public virtual double Area()
        {
            return 0;
        }
    }
    
    class Rectangle : Shape
    {
        public Rectangle(int p, int q) : base(p, q) { }
        
        public override double Area()  // OVERRIDE keyword added
        {
            return H * W;
        }
    }
    
    class Triangle : Shape
    {
        public Triangle(int p, int q) : base(p, q) { }
        
        public override double Area()  // OVERRIDE keyword added
        {
            return (H * W) / 2.0;
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Shape s1 = new Triangle(5, 5);
            Console.WriteLine(s1.Area());  // Output: 12.5 ✓
            
            s1 = new Rectangle(4, 2);
            Console.WriteLine(s1.Area());  // Output: 8 ✓
        }
    }
}
```

#### Execution Flow

```
1. Shape s1 = new Triangle(5, 5);
   ┌─────────────────────────────────────────────────────┐
   │ Stack: s1 (Shape reference)                         │
   │ Heap:  Triangle object { H=5, W=5 }                 │
   │        + method table pointing to Triangle.Area()   │
   └─────────────────────────────────────────────────────┘

2. s1.Area() called
   ┌─────────────────────────────────────────────────────┐
   │ CLR checks: What is the ACTUAL type of object?      │
   │ Answer: Triangle                                     │
   │ CLR checks: Does Triangle override Area()?          │
   │ Answer: YES → Call Triangle.Area()                  │
   │ Result: (5 * 5) / 2.0 = 12.5                        │
   └─────────────────────────────────────────────────────┘
```

---

### Example 5: Polymorphism with Method Parameter

```csharp
using System;

class Shape
{
    public int H;
    public int W;
    
    public Shape(int h, int w)
    {
        H = h;
        W = w;
    }
    
    public virtual double Area()
    {
        return 0;
    }
}

class Rectangle : Shape
{
    public Rectangle(int p, int q) : base(p, q) { }
    
    public override double Area()
    {
        return H * W;
    }
}

class Triangle : Shape
{
    public Triangle(int p, int q) : base(p, q) { }
    
    public override double Area()
    {
        return (H * W) / 2.0;
    }
}

class ShowPoly
{
    public void Call(Shape s)  // Accepts any Shape or derived type
    {
        Console.WriteLine(s.Area());  // Polymorphic call
    }
}

class Program
{
    static void Main(string[] args)
    {
        ShowPoly pol = new ShowPoly();
        
        Triangle s1 = new Triangle(5, 5);
        Rectangle s2 = new Rectangle(5, 5);
        
        pol.Call(s1);  // Outputs: 12.5
        pol.Call(s2);  // Outputs: 25
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 41 | `public void Call(Shape s)` | Method accepts any Shape or subclass |
| 43 | `Console.WriteLine(s.Area());` | Polymorphic call - actual type determines method |
| 54 | `pol.Call(s1);` | Passes Triangle, calls Triangle.Area() |
| 55 | `pol.Call(s2);` | Passes Rectangle, calls Rectangle.Area() |

**This is TRUE Polymorphism**: The `Call` method doesn't know (or care) which specific shape it receives. It just calls `Area()` and the correct implementation executes automatically.

---

### Example 6: Overriding Object.ToString()

```csharp
using System;
namespace ConsoleApplication7
{
    class Employee : Object  // All classes inherit from Object
    {
        int id;
        string name;
        double salary;
        
        public Employee(int id, string nm, double sal)
        {
            this.id = id;
            name = nm;
            salary = sal;
        }
        
        public override string ToString()
        {
            return id + " " + name + " " + salary;
        }
    }
    
    class Program
    {
        static void Main(string[] args)
        {
            Employee e1 = new Employee(1, "Raj", 5000);
            object e2 = new Employee(2, "Mona", 9000);
            
            Console.WriteLine(e1);  // Output: 1 Raj 5000
            Console.WriteLine(e2);  // Output: 2 Mona 9000
        }
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 4 | `class Employee : Object` | All classes inherit from Object (implicit) |
| 17 | `public override string ToString()` | Overrides Object.ToString() virtual method |
| 27 | `object e2 = new Employee(...)` | Upcasting to Object reference |
| 30 | `Console.WriteLine(e1);` | Internally calls e1.ToString() |

**Key Point**: If you don't override `ToString()`, it returns `Namespace.ClassName` (e.g., "ConsoleApplication7.Employee").

---

## ⚡ Key Points to Remember

| Concept | Explanation |
|---------|-------------|
| **Default behavior** | All methods in C# are sealed (non-virtual) by default |
| **virtual keyword** | Makes a method overridable; provides default implementation |
| **override keyword** | Replaces parent's virtual method with new implementation |
| **new keyword** | Explicitly hides parent method (not polymorphic) |
| **Runtime resolution** | CLR determines which method to call based on actual object type |
| **Virtual cannot be private** | Virtual members must be accessible to derived classes |
| **Optional override** | Child class may choose not to override virtual method |

### Virtual vs Abstract

| Virtual Method | Abstract Method |
|----------------|-----------------|
| Has default implementation | No implementation |
| Child may or may not override | Child MUST override |
| Class can be instantiated | Class cannot be instantiated |
| Uses `virtual` keyword | Uses `abstract` keyword |

---

## ❌ Common Mistakes

### Mistake 1: Forgetting the `override` keyword
```csharp
// WRONG - Method hiding, not polymorphism
public double Area() { return H * W; }

// CORRECT - True polymorphism
public override double Area() { return H * W; }
```

### Mistake 2: Using `new` instead of `override`
```csharp
// This HIDES the parent method
public new double Area() { return H * W; }  // Warning: Intentional hiding
```

### Mistake 3: Trying to access derived class members through base reference
```csharp
Shape s = new Rectangle(5, 5);
// s.GetPerimeter();  // ERROR if GetPerimeter is only in Rectangle
```

### Mistake 4: Making virtual methods private
```csharp
// COMPILE ERROR - virtual members cannot be private
private virtual void Display() { }
```

---

## 📝 Practice Questions

1. **What is the output of this code?**
```csharp
class A { public virtual void Show() { Console.Write("A "); } }
class B : A { public override void Show() { Console.Write("B "); } }
class C : B { public new void Show() { Console.Write("C "); } }

A obj = new C();
obj.Show();  // Output: ?
```
<details>
<summary>Answer</summary>
Output: `B` - The CLR finds that B overrides A's Show(). C uses `new` which hides but doesn't override, so polymorphism stops at B.
</details>

2. **Why does the following print "0" instead of "25"?**
```csharp
Shape s = new Rectangle(5, 5);
Console.WriteLine(s.Area());
// Rectangle.Area() returns H * W but doesn't use override
```
<details>
<summary>Answer</summary>
Without `override`, Rectangle.Area() hides Shape.Area(). When called through Shape reference, Shape's virtual Area() (returning 0) is called.
</details>

3. **Is it compulsory to override a parent's virtual method?**
<details>
<summary>Answer</summary>
No. Virtual methods provide an optional override. If you want to force overriding, use `abstract` instead.
</details>

---

## 🔗 Related Topics

- [02_Downcasting_TypeConversion.md](02_Downcasting_TypeConversion.md) - Deep dive into is/as operators
- [03_Abstract_Classes_Methods.md](03_Abstract_Classes_Methods.md) - When virtual isn't enough
- [04_Sealed_Classes_Methods.md](04_Sealed_Classes_Methods.md) - Preventing further overriding

---

## 📖 Summary

Polymorphism with virtual methods allows C# to determine at runtime which method implementation to execute. The `virtual` keyword in the base class signals that a method can be overridden, while `override` in the derived class provides the new implementation. This powerful mechanism enables flexible, extensible code where you can work with base class references while automatically getting derived class behavior.

```
Remember: Parent p = new Child();
          p.VirtualMethod();  →  Calls Child's override (if exists)
```
