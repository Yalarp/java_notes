# Interface Injection in C#

## 📚 Introduction

Interface Injection uses a dedicated interface to define the injection method. The consumer implements this interface, providing a contract for how dependencies should be set.

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

// Interface that defines injection method
interface ISetService
{
    void SetServiceAndRun(IService client);
}

// Consumer implements the injection interface
public class BusinessLogicImplementation : ISetService
{
    IService _client;

    // Implementation of injection interface
    public void SetServiceAndRun(IService client)
    {
        _client = client;
        Console.WriteLine("Interface Injection ==> Current Service: {0}",
                         _client.ServiceMethod());
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Create consumer
        ISetService bl = new BusinessLogicImplementation();
        
        // Inject through interface method
        bl.SetServiceAndRun(new ClaimService());
    }
}
```

### Output:

```
Interface Injection ==> Current Service: ClaimService is running
```

---

## 🔑 Key Points

1. **Interface contract** - Defines how to inject
2. **Less common** - Constructor injection preferred
3. **Framework use** - Sometimes used by DI frameworks

---

## 🔗 Next Topic
Next: [21_Service_Locator_Pattern.md](./21_Service_Locator_Pattern.md) - Service Locator
