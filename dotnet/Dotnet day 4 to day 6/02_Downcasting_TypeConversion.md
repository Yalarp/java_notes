# Downcasting and Type Conversion in C#

## 📚 Introduction

**Downcasting** is the process of converting a base class reference to a derived class reference. While **upcasting** (child to parent) is implicit and always safe, downcasting requires explicit casting and can fail at runtime if the object isn't actually of the derived type.

### Real-World Analogy
Think of a zoo where all animals are stored in an "Animal" list. To feed a specific animal type (like a lion), you need to know it's actually a lion before calling `RoarAndEat()` - that's downcasting.

---

## 🎯 Learning Objectives

- Understand the difference between upcasting and downcasting
- Master the `is` and `as` operators
- Learn safe downcasting patterns
- Understand when downcasting is necessary

---

## 🔍 Conceptual Overview

### Upcasting vs Downcasting

```
Object Hierarchy           Casting Direction
    ┌────────┐
    │ Shape  │ ◄───────── UPCASTING (implicit, safe)
    └────┬───┘              Child → Parent
         │                  Always succeeds
    ┌────┴───┐
    │ Square │ ◄───────── DOWNCASTING (explicit, risky)
    └────────┘              Parent → Child
                            May fail at runtime
```

### Why Downcasting is Needed

When you store derived objects in base class references (common in collections), you lose access to derived-specific members. Downcasting restores that access.

```csharp
Shape s = new Circle(10, 20);  // Upcasting - OK
// s.FillCircle();  // ERROR! Shape doesn't know FillCircle()

Circle c = (Circle)s;  // Downcasting - OK (s is actually a Circle)
c.FillCircle();        // Now we can call Circle-specific methods
```

---

## 💻 Code Examples

### Example 1: Complete Shape Hierarchy with Polymorphism

```csharp
public class Shape
{
    protected int m_xpos;
    protected int m_ypos;
    
    public Shape() { }
    
    public Shape(int x, int y)
    {
        m_xpos = x;
        m_ypos = y;
    }
    
    public virtual void Draw()
    {
        Console.WriteLine("Drawing a SHAPE at {0},{1}", m_xpos, m_ypos);
    }
}

public class Square : Shape
{
    public Square() { }
    
    public Square(int x, int y) : base(x, y) { }
    
    public override void Draw()
    {
        Console.WriteLine("Drawing a SQUARE at {0},{1}", m_xpos, m_ypos);
    }
}

public class Circle : Shape
{
    public Circle() { }
    
    public Circle(int x, int y) : base(x, y) { }
    
    public override void Draw()
    {
        Console.WriteLine("Drawing a CIRCLE at {0},{1}", m_xpos, m_ypos);
    }
}

class Program
{
    static void Main(string[] args)
    {
        Shape[] shapes = new Shape[3];
        shapes[0] = new Shape(100, 100);
        shapes[1] = new Square(200, 200);
        shapes[2] = new Circle(300, 300);
        
        foreach (Shape shape in shapes)
            shape.Draw();
    }
}
```

#### Output:
```
Drawing a SHAPE at 100,100
Drawing a SQUARE at 200,200
Drawing a CIRCLE at 300,300
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 3-4 | `protected int m_xpos, m_ypos;` | Protected members accessible in derived classes |
| 14, 27, 40 | `public override void Draw()` | Each class overrides Draw() with specific behavior |
| 47-50 | `Shape[] shapes = ...` | Array stores different shape types through upcasting |
| 52-53 | `foreach...shape.Draw()` | Polymorphism: correct Draw() called for each object |

#### Memory Layout
```
shapes[]
┌─────┐     ┌─────────────────┐
│ [0] │────►│ Shape           │
└─────┘     │ x=100, y=100    │
┌─────┐     └─────────────────┘
│ [1] │────►┌─────────────────┐
└─────┘     │ Square          │
            │ x=200, y=200    │
┌─────┐     └─────────────────┘
│ [2] │────►┌─────────────────┐
└─────┘     │ Circle          │
            │ x=300, y=300    │
            └─────────────────┘
```

---

### Example 2: Understanding Upcasting

```csharp
Shape s = new Circle(100, 100);  // Upcasting: Circle → Shape

s.Draw();  // Polymorphic call - which Draw() is called?
```

#### Execution Flow
```
Step 1: new Circle(100, 100) creates Circle object on heap
Step 2: Shape s = ... stores reference as Shape type
Step 3: s.Draw() called
        └─► CLR checks: What is actual object type? → Circle
        └─► Does Circle override Draw()? → YES
        └─► Call Circle.Draw()

Output: "Drawing a CIRCLE at 100,100"
```

**If Circle declared Draw() with `new` instead of `override`:**
```csharp
public new void Draw() { ... }  // HIDING, not overriding
// Output would be: "Drawing a SHAPE at 100,100"
```

---

### Example 3: Downcasting to Access Derived Members

```csharp
public class Circle : Shape
{
    public Circle(int x, int y) : base(x, y) { }
    
    public override void Draw()
    {
        Console.WriteLine("Drawing a CIRCLE at {0},{1}", m_xpos, m_ypos);
    }
    
    // Circle-specific method - NOT in Shape
    public void FillCircle()
    {
        Console.WriteLine("Filling CIRCLE at {0},{1}", m_xpos, m_ypos);
    }
}

class Program
{
    static void Main()
    {
        Shape s = new Circle(100, 100);  // Upcasting
        
        s.Draw();           // OK - Draw() is in Shape (virtual)
        // s.FillCircle();  // ERROR! Shape doesn't have FillCircle()
        
        // Solution: Downcast to Circle
        Circle c;
        c = (Circle)s;      // Explicit downcast
        c.FillCircle();     // Now OK!
        
        // Or in one line:
        ((Circle)s).FillCircle();
    }
}
```

#### Output:
```
Drawing a CIRCLE at 100,100
Filling CIRCLE at 100,100
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 11-14 | `public void FillCircle()` | Circle-specific method not available through Shape reference |
| 21 | `Shape s = new Circle(100, 100);` | Upcasting - Shape reference to Circle object |
| 23 | `s.Draw();` | Works - Draw() is virtual in Shape |
| 24 | `// s.FillCircle();` | Won't compile - Shape doesn't know FillCircle() |
| 27-28 | `c = (Circle)s;` | Explicit downcast to Circle |
| 32 | `((Circle)s).FillCircle();` | Inline downcast and method call |

---

### Example 4: The Problem with Unsafe Downcasting

```csharp
Shape s = new Square(100, 100);  // s actually holds a Square
Circle c = (Circle)s;            // Runtime ERROR! InvalidCastException
```

**This compiles but crashes at runtime!** The compiler allows it because Square and Circle are both Shapes, but at runtime the CLR discovers s isn't actually a Circle.

---

### Example 5: Safe Downcasting with `is` Operator

```csharp
public abstract class Shape
{
    protected int m_xpos;
    protected int m_ypos;
    
    public Shape(int x, int y)
    {
        m_xpos = x;
        m_ypos = y;
    }
    
    public abstract void Draw();
}

public class Square : Shape
{
    public Square(int x, int y) : base(x, y) { }
    
    public override void Draw()
    {
        Console.WriteLine("Drawing a SQUARE at {0},{1}", m_xpos, m_ypos);
    }
    
    public void FillSquare()
    {
        Console.WriteLine("Filling SQUARE at {0},{1}", m_xpos, m_ypos);
    }
}

public class Circle : Shape
{
    public Circle(int x, int y) : base(x, y) { }
    
    public override void Draw()
    {
        Console.WriteLine("Drawing a CIRCLE at {0},{1}", m_xpos, m_ypos);
    }
    
    public void FillCircle()
    {
        Console.WriteLine("Filling CIRCLE at {0},{1}", m_xpos, m_ypos);
    }
}

class Program
{
    static void Main(string[] args)
    {
        Shape[] shapes = new Shape[2];
        shapes[0] = new Square(200, 200);
        shapes[1] = new Circle(300, 300);
        
        foreach (Shape shape in shapes)
        {
            shape.Draw();
            
            // Safe downcasting with 'is'
            if (shape is Circle)
                ((Circle)shape).FillCircle();
            
            if (shape is Square)
                ((Square)shape).FillSquare();
        }
    }
}
```

#### Output:
```
Drawing a SQUARE at 200,200
Filling SQUARE at 200,200
Drawing a CIRCLE at 300,300
Filling CIRCLE at 300,300
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 11 | `public abstract void Draw();` | Abstract class - cannot instantiate Shape directly |
| 57 | `if (shape is Circle)` | Runtime type check - returns true/false |
| 58 | `((Circle)shape).FillCircle();` | Safe to cast - we verified type first |
| 60 | `if (shape is Square)` | Check for Square type |

---

### Example 6: Safe Downcasting with `as` Operator

```csharp
// Using 'as' operator
Circle c = shape as Circle;

if (c != null)
    c.FillCircle();

// Modern one-liner with null-conditional operator
(shape as Circle)?.FillCircle();
```

#### `is` vs `as` Comparison

| Feature | `is` Operator | `as` Operator |
|---------|--------------|---------------|
| Returns | `bool` (true/false) | Object reference or `null` |
| Usage | `if (obj is Type)` | `Type t = obj as Type;` |
| On failure | Returns `false` | Returns `null` |
| Type check + cast | Two operations | Single operation |
| Works with value types | Yes | No (value types can't be null) |

#### Pattern Matching (C# 7+)
```csharp
// Combines 'is' check and cast in one line
if (shape is Circle circle)
{
    circle.FillCircle();  // 'circle' is already cast
}
```

---

## 🔄 Execution Flow Diagram

```
                     ┌──────────────────────────────────┐
                     │       shape.Draw() called        │
                     └────────────────┬─────────────────┘
                                      │
                     ┌────────────────▼─────────────────┐
                     │  CLR checks actual object type   │
                     └────────────────┬─────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
        ┌──────────┐            ┌──────────┐            ┌──────────┐
        │  Square  │            │  Circle  │            │   Shape  │
        └────┬─────┘            └────┬─────┘            └────┬─────┘
             │                       │                       │
    Call Square.Draw()        Call Circle.Draw()       Call Shape.Draw()
             │                       │                       │
    "Drawing SQUARE..."       "Drawing CIRCLE..."      "Drawing SHAPE..."
```

---

## ⚡ Key Points to Remember

1. **Upcasting (Child → Parent)**
   - Always implicit and safe
   - `Shape s = new Circle();` ✓
   
2. **Downcasting (Parent → Child)**
   - Must be explicit: `Circle c = (Circle)s;`
   - Can fail at runtime with `InvalidCastException`
   
3. **Use `is` or `as` for safe downcasting**
   - `is` returns boolean
   - `as` returns casted object or null

4. **Why downcast?**
   - Access derived class-specific members
   - Common when working with collections of base type

---

## ❌ Common Mistakes

### Mistake 1: Downcasting without type check
```csharp
// DANGEROUS - may throw InvalidCastException
Circle c = (Circle)shape;
```

### Mistake 2: Using `as` with value types
```csharp
int? x = obj as int;  // ERROR: 'as' doesn't work with value types
```

### Mistake 3: Forgetting null check after `as`
```csharp
Circle c = shape as Circle;
c.FillCircle();  // NullReferenceException if shape wasn't Circle!
```

---

## 📝 Practice Questions

1. **What is the output?**
```csharp
Shape s = new Square(5, 5);
if (s is Circle)
    Console.WriteLine("Circle");
else
    Console.WriteLine("Not Circle");
```
<details>
<summary>Answer</summary>
Output: `Not Circle` - s is actually a Square, not a Circle.
</details>

2. **True or False: Upcasting can fail at runtime.**
<details>
<summary>Answer</summary>
False. Upcasting is always safe because a child IS-A parent.
</details>

3. **What happens when `as` cast fails?**
<details>
<summary>Answer</summary>
Returns `null` instead of throwing an exception.
</details>

---

## 🔗 Related Topics

- [01_Polymorphism_Virtual_Methods.md](01_Polymorphism_Virtual_Methods.md) - Virtual methods and runtime polymorphism
- [03_Abstract_Classes_Methods.md](03_Abstract_Classes_Methods.md) - Abstract classes
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - Interface-based programming
