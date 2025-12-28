# IoC Containers and DIP in C#

## 📚 Introduction

Inversion of Control (IoC) is the principle; Dependency Injection is the pattern. IoC Containers automate the creation and injection of dependencies.

---

## 📖 Key Concepts

### Dependency Inversion Principle (DIP)

```
┌────────────────────────────────────────────────────────────────┐
│              Dependency Inversion Principle                     │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. High-level modules should NOT depend on low-level modules  │
│     Both should depend on ABSTRACTIONS (interfaces)            │
│                                                                 │
│  2. Abstractions should NOT depend on details                  │
│     Details should depend on abstractions                      │
│                                                                 │
│  Before DIP:                                                   │
│  ┌─────────────────┐          ┌─────────────────┐             │
│  │  OrderService   │─────────→│  MySqlDatabase  │             │
│  │  (high-level)   │ depends  │  (low-level)    │             │
│  └─────────────────┘          └─────────────────┘             │
│                                                                 │
│  After DIP:                                                    │
│  ┌─────────────────┐          ┌─────────────────┐             │
│  │  OrderService   │─────────→│   IDatabase     │             │
│  │  (high-level)   │ depends  │  (abstraction)  │             │
│  └─────────────────┘          └────────┬────────┘             │
│                                         │                      │
│                               ┌─────────┴─────────┐            │
│                               │   MySqlDatabase   │            │
│                               │   (implements)    │            │
│                               └───────────────────┘            │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Popular IoC Containers

| Container | Platform | Features |
|-----------|----------|----------|
| **Microsoft.Extensions.DI** | .NET Core/5+ | Built-in, lightweight |
| **Autofac** | .NET | Feature-rich |
| **Ninject** | .NET | Convention-based |
| **Unity** | .NET | Microsoft (legacy) |

---

## 💻 .NET Core Built-in DI Example

```csharp
using Microsoft.Extensions.DependencyInjection;

// Register services
var services = new ServiceCollection();
services.AddTransient<IService, ClaimService>();
services.AddScoped<IRepository, SqlRepository>();
services.AddSingleton<ILogger, FileLogger>();

// Build provider
var provider = services.BuildServiceProvider();

// Resolve dependencies
var service = provider.GetService<IService>();
```

### Lifetime Scopes:

| Lifetime | Description |
|----------|-------------|
| **Transient** | New instance every time |
| **Scoped** | One per scope (web request) |
| **Singleton** | One for entire application |

---

## 🔑 Key Points

1. **IoC** - Principle of inverting control flow
2. **DI** - Pattern implementing IoC
3. **DIP** - SOLID principle for abstraction
4. **Container** - Automates DI configuration

---

## 🔗 Next Topic
Next: [23_ADO_NET_Introduction.md](./23_ADO_NET_Introduction.md) - ADO.NET Introduction
