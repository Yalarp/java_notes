# Constructor Injection in C#

## 📚 Introduction

Constructor Injection is the most common and recommended form of dependency injection. Dependencies are provided through the class constructor, ensuring the object is always in a valid state.

---

## 💻 Code Example

```csharp
using System;

// Step 1: Define interface (contract)
public interface IService
{
    string ServiceMethod();
}

// Step 2: Implement interface
public class ClaimService : IService
{
    public string ServiceMethod()
    {
        return "ClaimService is running";
    }
}

public class PolicyService : IService
{
    public string ServiceMethod()
    {
        return "PolicyService is running";
    }
}

// Step 3: Consumer class with constructor injection
public class BusinessLogicImplementation
{
    private IService _client;

    // Constructor receives dependency
    public BusinessLogicImplementation(IService client)
    {
        this._client = client;
        Console.WriteLine("Constructor Injection ==> Current Service: {0}",
                         _client.ServiceMethod());
    }
    
    public void DoWork()
    {
        Console.WriteLine("Working with: " + _client.ServiceMethod());
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Inject ClaimService
        IService claimService = new ClaimService();
        BusinessLogicImplementation bl1 = 
            new BusinessLogicImplementation(claimService);
        
        // Inject PolicyService (different implementation)
        IService policyService = new PolicyService();
        BusinessLogicImplementation bl2 = 
            new BusinessLogicImplementation(policyService);
    }
}
```

### Output:

```
Constructor Injection ==> Current Service: ClaimService is running
Constructor Injection ==> Current Service: PolicyService is running
```

---

## 📊 Flow Diagram

```
┌──────────────┐         ┌──────────────┐
│   Caller     │         │  IService    │
│   (Main)     │◄────────│  (interface) │
└──────┬───────┘         └──────────────┘
       │                        ▲
       │ creates                │ implements
       ▼                        │
┌──────────────┐         ┌──────────────┐
│BusinessLogic │◄────────│ClaimService  │
│   (needs     │ injected│              │
│  IService)   │         │PolicyService │
└──────────────┘         └──────────────┘
```

---

## 🔑 Key Points

1. **Constructor parameter** - Dependency passed at creation
2. **Object always valid** - Cannot create without dependency
3. **Immutable reference** - Typically stored in readonly field
4. **Most recommended** - Use as default DI approach

---

## 🔗 Next Topic
Next: [19_Setter_Injection.md](./19_Setter_Injection.md) - Setter/Property Injection
