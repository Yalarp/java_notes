# Service Locator Pattern in C#

## 📚 Introduction

Service Locator provides a central registry where services can be registered and retrieved. While historically used, it's now considered an anti-pattern in modern DI because it hides dependencies.

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

// Service Locator (static registry)
public class ServiceLocator
{
    private static IService _clientLocator;
    
    public static IService GetService()
    {
        return _clientLocator;
    }
    
    public static void SetService(IService clientSL)
    {
        _clientLocator = clientSL;
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Register service
        ServiceLocator.SetService(new ClaimService());
        
        // Retrieve service anywhere in code
        IService service = ServiceLocator.GetService();
        Console.WriteLine("Service Locator ==> Current Service: {0}",
                         service.ServiceMethod());
    }
}
```

---

## ⚠️ Why It's an Anti-Pattern

| Problem | Description |
|---------|-------------|
| **Hidden dependencies** | Class doesn't declare what it needs |
| **Runtime errors** | Service might not be registered |
| **Hard to test** | Must set up locator for tests |
| **Prefer DI** | Constructor injection is clearer |

---

## 🔗 Next Topic
Next: [22_IoC_Containers.md](./22_IoC_Containers.md) - IoC Containers
