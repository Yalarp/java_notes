# ADO.NET Introduction in C#

## 📚 Introduction

ADO.NET (ActiveX Data Objects .NET) is the data access technology for .NET applications. It provides classes for connecting to databases, executing commands, and retrieving results.

---

## 🎯 Learning Objectives

- Understand connected vs disconnected architecture
- Know the core ADO.NET objects
- Set up connection strings in .NET Core

---

## 📖 Theory: Two Architectures

```
┌────────────────────────────────────────────────────────────────┐
│                   ADO.NET Architectures                         │
├──────────────────────────────┬─────────────────────────────────┤
│      CONNECTED LAYER         │      DISCONNECTED LAYER         │
├──────────────────────────────┼─────────────────────────────────┤
│ Connection stays OPEN        │ Connection opens/closes quickly │
│ Real-time data access        │ Data cached in DataSet          │
│ Uses DataReader (forward)    │ Uses DataAdapter + DataSet      │
│ Best for read-once ops       │ Best for offline editing        │
│                              │                                 │
│ Objects:                     │ Objects:                        │
│ • SqlConnection              │ • SqlDataAdapter                │
│ • SqlCommand                 │ • DataSet                       │
│ • SqlDataReader              │ • DataTable                     │
└──────────────────────────────┴─────────────────────────────────┘
```

---

## 📊 Core Objects

| Object | Purpose |
|--------|---------|
| **SqlConnection** | Opens connection to database |
| **SqlCommand** | Executes SQL or stored procedure |
| **SqlDataReader** | Reads data (forward-only, read-only) |
| **SqlDataAdapter** | Fills DataSet/DataTable |
| **DataSet** | In-memory cache of data |

---

## 💻 .NET Core Setup

### Required NuGet Packages:

```
Microsoft.Extensions.Configuration
Microsoft.Extensions.Configuration.FileExtensions
Microsoft.Extensions.Configuration.Json
System.Data.SqlClient
```

### appsettings.json:

```json
{
  "ConnectionStrings": {
    "Default": "Data Source=(localdb)\\ProjectModels;Initial Catalog=StudentData;Integrated Security=True;"
  }
}
```

---

## 🔑 Key Points

1. **Connected** - Fast reads, use DataReader
2. **Disconnected** - Offline editing, use DataSet
3. **Use "using"** - Auto-close connections
4. **Store connection strings** - In appsettings.json

---

## 🔗 Next Topic
Next: [24_SqlConnection_Configuration.md](./24_SqlConnection_Configuration.md) - SqlConnection Setup
