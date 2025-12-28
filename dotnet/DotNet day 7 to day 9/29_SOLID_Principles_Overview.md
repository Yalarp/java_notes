# SOLID Principles Overview in C#

## 📚 Introduction

SOLID is an acronym for five design principles introduced by Robert C. Martin (Uncle Bob). These principles help create software that is easy to maintain, understand, and extend.

---

## 🎯 Learning Objectives

- Understand each SOLID principle
- Know when and why to apply each principle
- Recognize violations and how to fix them

---

## 📖 The Five SOLID Principles

```
┌────────────────────────────────────────────────────────────────┐
│                      SOLID Principles                           │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  S - Single Responsibility Principle (SRP)                     │
│      "A class should have only one reason to change"           │
│      → One class = one job                                     │
│                                                                 │
│  O - Open/Closed Principle (OCP)                               │
│      "Open for extension, closed for modification"             │
│      → Add new features without changing existing code         │
│                                                                 │
│  L - Liskov Substitution Principle (LSP)                       │
│      "Subtypes must be substitutable for their base types"     │
│      → Derived classes can replace base classes                │
│                                                                 │
│  I - Interface Segregation Principle (ISP)                     │
│      "Many specific interfaces are better than one general"    │
│      → Don't force clients to depend on unused methods         │
│                                                                 │
│  D - Dependency Inversion Principle (DIP)                      │
│      "Depend on abstractions, not concretions"                 │
│      → High-level modules shouldn't depend on low-level        │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Principle Summary Table

| Principle | Focus | Violation Sign | Benefit |
|-----------|-------|----------------|---------|
| **SRP** | Responsibility | Class does too many things | Easy to understand |
| **OCP** | Extension | Must modify class for new features | Stable codebase |
| **LSP** | Substitution | Subclass breaks parent contract | Reliable inheritance |
| **ISP** | Interfaces | Implements unused methods | Focused APIs |
| **DIP** | Dependencies | Creates concrete classes directly | Loose coupling |

---

## 💻 Quick Examples

### S - Single Responsibility

```csharp
// ❌ BAD: Class does multiple things
public class Employee
{
    public void CalculateSalary() { }
    public void SaveToDatabase() { }
    public void GenerateReport() { }
}

// ✅ GOOD: Separate responsibilities
public class Employee { public decimal Salary { get; set; } }
public class SalaryCalculator { public decimal Calculate(Employee e) { } }
public class EmployeeRepository { public void Save(Employee e) { } }
public class ReportGenerator { public void Generate(Employee e) { } }
```

### O - Open/Closed

```csharp
// ❌ BAD: Must modify class for new shapes
public class AreaCalculator
{
    public double Calculate(object shape)
    {
        if (shape is Rectangle r) return r.Width * r.Height;
        if (shape is Circle c) return Math.PI * c.Radius * c.Radius;
        // Must add more if statements for new shapes!
    }
}

// ✅ GOOD: Open for extension via inheritance
public interface IShape { double CalculateArea(); }
public class Rectangle : IShape { public double CalculateArea() => Width * Height; }
public class Circle : IShape { public double CalculateArea() => Math.PI * Radius * Radius; }
// Add new shapes without modifying existing code!
```

### L - Liskov Substitution

```csharp
// ❌ BAD: Square violates Rectangle contract
public class Rectangle
{
    public virtual int Width { get; set; }
    public virtual int Height { get; set; }
}
public class Square : Rectangle
{
    public override int Width { set { base.Width = base.Height = value; } }
    // Setting Width changes Height - violates expectations!
}

// ✅ GOOD: Separate types
public interface IShape { int CalculateArea(); }
public class Rectangle : IShape { /* independent width/height */ }
public class Square : IShape { /* single side property */ }
```

### I - Interface Segregation

```csharp
// ❌ BAD: Fat interface
public interface IWorker
{
    void Work();
    void Eat();
    void Sleep();
}
public class Robot : IWorker
{
    public void Work() { }
    public void Eat() { /* Robots don't eat! */ }
    public void Sleep() { /* Robots don't sleep! */ }
}

// ✅ GOOD: Segregated interfaces
public interface IWorkable { void Work(); }
public interface IEatable { void Eat(); }
public class Robot : IWorkable { public void Work() { } }
public class Human : IWorkable, IEatable { /* implements both */ }
```

### D - Dependency Inversion

```csharp
// ❌ BAD: Depends on concrete class
public class OrderService
{
    private SqlDatabase _db = new SqlDatabase();  // Tight coupling!
}

// ✅ GOOD: Depends on abstraction
public interface IDatabase { void Save(Order order); }
public class OrderService
{
    private readonly IDatabase _db;
    public OrderService(IDatabase db) { _db = db; }  // Injected!
}
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **SRP** - One class, one responsibility, one reason to change
2. **OCP** - Add features by adding code, not changing it
3. **LSP** - Subclasses must honor parent class contracts
4. **ISP** - Small, focused interfaces over large, general ones
5. **DIP** - Depend on interfaces, inject dependencies

---

## 📝 Interview Questions

1. **What is SOLID?**
   - Five design principles for maintainable OOP code

2. **Why is SRP important?**
   - Makes classes easier to understand, test, and maintain
   - Changes to one responsibility don't affect others

3. **How does DIP relate to Dependency Injection?**
   - DIP is the principle (depend on abstractions)
   - DI is the pattern that implements DIP

---

## 🔗 Next Topic
Next: [30_Single_Responsibility_Principle.md](./30_Single_Responsibility_Principle.md) - SRP in Detail
