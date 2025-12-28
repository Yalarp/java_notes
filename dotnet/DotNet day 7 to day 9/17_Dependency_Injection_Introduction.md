# Dependency Injection Introduction in C#

## 📚 Introduction

Dependency Injection (DI) is a design pattern that removes hard-coded dependencies between classes, making the code more modular, testable, and maintainable.

---

## 🎯 Learning Objectives

- Understand what dependency injection solves
- Know the types of DI: Constructor, Setter, Interface, Service Locator
- Recognize the benefits of loose coupling

---

## 📖 Theory: The Problem

### Tight Coupling (Bad)

```csharp
// BusinessLogic directly creates its dependencies
public class BusinessLogic
{
    private ClaimService _service;
    
    public BusinessLogic()
    {
        _service = new ClaimService();  // ❌ Hard-coded dependency
    }
}
```

**Problems:**
- Cannot easily swap implementations
- Difficult to unit test (can't mock ClaimService)
- Changes to ClaimService affect BusinessLogic

### Loose Coupling (Good)

```csharp
// Dependency is injected from outside
public class BusinessLogic
{
    private IService _service;
    
    public BusinessLogic(IService service)  // ✅ Injected dependency
    {
        _service = service;
    }
}
```

---

## 📊 DI Types Overview

```
┌────────────────────────────────────────────────────────────────┐
│              Types of Dependency Injection                      │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Constructor Injection                                       │
│     → Dependencies passed via constructor                       │
│     → Most common, recommended                                  │
│                                                                 │
│  2. Setter/Property Injection                                   │
│     → Dependencies set via properties                           │
│     → Optional dependencies                                     │
│                                                                 │
│  3. Interface Injection                                         │
│     → Interface defines setter method                           │
│     → Less common                                               │
│                                                                 │
│  4. Service Locator                                             │
│     → Central registry for services                             │
│     → Anti-pattern in modern DI                                 │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Benefits of DI

| Benefit | Description |
|---------|-------------|
| **Loose Coupling** | Classes don't create their dependencies |
| **Testability** | Easy to inject mock objects for testing |
| **Maintainability** | Change implementation without changing consumers |
| **Flexibility** | Swap implementations at runtime |
| **Single Responsibility** | Classes focus on their job, not creating dependencies |

---

## 🔗 Next Topic
Next: [18_Constructor_Injection.md](./18_Constructor_Injection.md) - Constructor Injection Details
