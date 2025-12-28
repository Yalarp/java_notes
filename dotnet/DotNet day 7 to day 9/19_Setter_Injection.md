# Setter/Property Injection in C#

## 📚 Introduction

Setter Injection (also called Property Injection) provides dependencies through public properties. This is useful for optional dependencies or when the dependency might change.

---

## 💻 Code Example

```csharp
using System;

public interface IService
{
    string ServiceMethod();
}

public class ClaimService : IService
{
    public string ServiceMethod()
    {
        return "ClaimService is running";
    }
}

// Setter/Property Injection
public class BusinessLogicImplementation
{
    private IService _client;
    
    // Property for dependency injection
    public IService Client
    {
        get { return _client; }
        set { _client = value; }
    }
    
    // Default constructor (no dependency required)
    public BusinessLogicImplementation() { }
    
    public void TestSetterInjection()
    {
        if (Client != null)
        {
            Console.WriteLine("Setter Injection ==> Current Service: {0}",
                             Client.ServiceMethod());
        }
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Create object first
        BusinessLogicImplementation bl = new BusinessLogicImplementation();
        
        // Inject dependency via property
        bl.Client = new ClaimService();
        
        // Use the injected dependency
        bl.TestSetterInjection();
    }
}
```

### Output:

```
Setter Injection ==> Current Service: ClaimService is running
```

---

## 📊 Setter vs Constructor Injection

| Feature | Constructor | Setter |
|---------|-------------|--------|
| **Required Dependency** | ✅ Yes | ❌ No (optional) |
| **Object Valid on Create** | ✅ Yes | ❌ Not guaranteed |
| **Null Check Needed** | ❌ No | ✅ Yes |
| **Use Case** | Required services | Optional features |

---

## 🔑 Key Points

1. **Property-based** - Set dependency after creation
2. **Optional dependencies** - Object can exist without it
3. **Must null-check** - Dependency might not be set
4. **Less preferred** - Constructor injection is safer

---

## 🔗 Next Topic
Next: [20_Interface_Injection.md](./20_Interface_Injection.md) - Interface Injection
