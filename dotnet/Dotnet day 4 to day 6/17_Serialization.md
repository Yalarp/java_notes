# Serialization in C#

## 📚 Introduction

**Serialization** is the process of converting an object into a format that can be stored or transmitted. **Deserialization** is the reverse - reconstructing the object from that format.

---

## 🎯 Learning Objectives

- Understand serialization purpose
- Master JSON serialization with System.Text.Json
- Know when to use different serializers
- Learn serialization attributes

---

## 🔍 Serialization Formats

```
┌─────────────────────────────────────────────────────────────────┐
│                   SERIALIZATION FORMATS                          │
├─────────────────┬───────────────────────────────────────────────┤
│ Format          │ Use Case                                       │
├─────────────────┼───────────────────────────────────────────────┤
│ JSON            │ Web APIs, config files, human-readable        │
│ XML             │ Legacy systems, SOAP, config files            │
│ Binary          │ Performance-critical, .NET to .NET            │
│ Protocol Buffers│ High performance, cross-platform              │
└─────────────────┴───────────────────────────────────────────────┘
```

---

## 💻 Code Examples

### Example 1: JSON Serialization with System.Text.Json

```csharp
using System;
using System.Text.Json;

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public double Salary { get; set; }
    public DateTime HireDate { get; set; }
}

class Program
{
    static void Main()
    {
        Employee emp = new Employee
        {
            Id = 1,
            Name = "John Smith",
            Salary = 50000.00,
            HireDate = new DateTime(2020, 1, 15)
        };
        
        // Serialize to JSON string
        string json = JsonSerializer.Serialize(emp);
        Console.WriteLine("Serialized:");
        Console.WriteLine(json);
        
        // Deserialize from JSON
        Employee restored = JsonSerializer.Deserialize<Employee>(json);
        Console.WriteLine($"\nDeserialized: {restored.Name}, ${restored.Salary}");
    }
}
```

#### Output:
```
Serialized:
{"Id":1,"Name":"John Smith","Salary":50000,"HireDate":"2020-01-15T00:00:00"}

Deserialized: John Smith, $50000
```

---

### Example 2: Pretty-Print JSON

```csharp
using System;
using System.Text.Json;

class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
    public string[] Hobbies { get; set; }
}

class Program
{
    static void Main()
    {
        Person person = new Person
        {
            Name = "Alice",
            Age = 30,
            Hobbies = new[] { "Reading", "Gaming", "Cooking" }
        };
        
        // Configure options for pretty printing
        var options = new JsonSerializerOptions
        {
            WriteIndented = true
        };
        
        string json = JsonSerializer.Serialize(person, options);
        Console.WriteLine(json);
    }
}
```

#### Output:
```json
{
  "Name": "Alice",
  "Age": 30,
  "Hobbies": [
    "Reading",
    "Gaming",
    "Cooking"
  ]
}
```

---

### Example 3: JsonIgnore and Property Naming

```csharp
using System;
using System.Text.Json;
using System.Text.Json.Serialization;

class User
{
    public string Username { get; set; }
    
    [JsonIgnore]  // This property won't be serialized
    public string Password { get; set; }
    
    [JsonPropertyName("email_address")]  // Custom JSON name
    public string Email { get; set; }
    
    [JsonIgnore(Condition = JsonIgnoreCondition.WhenWritingNull)]
    public string PhoneNumber { get; set; }
}

class Program
{
    static void Main()
    {
        User user = new User
        {
            Username = "john_doe",
            Password = "secret123",
            Email = "john@example.com",
            PhoneNumber = null
        };
        
        var options = new JsonSerializerOptions { WriteIndented = true };
        string json = JsonSerializer.Serialize(user, options);
        Console.WriteLine(json);
    }
}
```

#### Output:
```json
{
  "Username": "john_doe",
  "email_address": "john@example.com"
}
```

Note: Password is ignored entirely, PhoneNumber is ignored because it's null.

---

### Example 4: Serializing Collections

```csharp
using System;
using System.Collections.Generic;
using System.Text.Json;

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
}

class Program
{
    static void Main()
    {
        List<Employee> employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Raj" },
            new Employee { Id = 2, Name = "Mona" },
            new Employee { Id = 3, Name = "Het" }
        };
        
        // Serialize list
        string json = JsonSerializer.Serialize(employees);
        Console.WriteLine(json);
        
        // Deserialize list
        List<Employee> restored = JsonSerializer.Deserialize<List<Employee>>(json);
        foreach (var emp in restored)
        {
            Console.WriteLine($"{emp.Id}: {emp.Name}");
        }
    }
}
```

---

### Example 5: File-Based Serialization

```csharp
using System;
using System.IO;
using System.Text.Json;

class Config
{
    public string AppName { get; set; }
    public int Port { get; set; }
    public bool DebugMode { get; set; }
}

class Program
{
    static void Main()
    {
        Config config = new Config
        {
            AppName = "MyApp",
            Port = 8080,
            DebugMode = true
        };
        
        string path = "config.json";
        
        // Save to file
        string json = JsonSerializer.Serialize(config, 
            new JsonSerializerOptions { WriteIndented = true });
        File.WriteAllText(path, json);
        Console.WriteLine($"Saved to {path}");
        
        // Load from file
        string loadedJson = File.ReadAllText(path);
        Config loadedConfig = JsonSerializer.Deserialize<Config>(loadedJson);
        Console.WriteLine($"Loaded: {loadedConfig.AppName} on port {loadedConfig.Port}");
    }
}
```

---

### Example 6: Handling Complex Object Graphs

```csharp
using System;
using System.Collections.Generic;
using System.Text.Json;

class Department
{
    public string Name { get; set; }
    public List<Employee> Employees { get; set; } = new();
}

class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public Department Department { get; set; }  // Circular reference!
}

class Program
{
    static void Main()
    {
        var dept = new Department { Name = "IT" };
        var emp = new Employee { Id = 1, Name = "John", Department = dept };
        dept.Employees.Add(emp);
        
        // Handle circular references
        var options = new JsonSerializerOptions
        {
            WriteIndented = true,
            ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.Preserve
        };
        
        string json = JsonSerializer.Serialize(dept, options);
        Console.WriteLine(json);
    }
}
```

---

### Example 7: Binary Serialization Warning

```csharp
// ⚠️ WARNING: BinaryFormatter is DANGEROUS and OBSOLETE!
// It can lead to remote code execution vulnerabilities
// DO NOT USE in new applications!

// Use these safe alternatives:
// 1. System.Text.Json (recommended for most cases)
// 2. XmlSerializer
// 3. DataContractSerializer
// 4. Protocol Buffers (for high performance)

// If you see old code like this, migrate away from it:
// [Serializable] attribute with BinaryFormatter is deprecated
```

---

## 📊 Serializer Comparison

| Feature | System.Text.Json | Newtonsoft.Json | XmlSerializer |
|---------|-----------------|-----------------|---------------|
| Speed | Fastest | Fast | Slow |
| Built-in | .NET Core 3+ | NuGet package | Built-in |
| Readability | Good | Good | Verbose |
| Size | Compact | Compact | Large |
| Customization | Growing | Extensive | Limited |

---

## ⚡ Key Attributes

| Attribute | Purpose |
|-----------|---------|
| `[JsonIgnore]` | Exclude property from serialization |
| `[JsonPropertyName]` | Custom JSON property name |
| `[JsonInclude]` | Include private/protected property |
| `[JsonIgnore(Condition=...)]` | Conditional ignore |

---

## ❌ Common Mistakes

### Mistake 1: Missing parameterless constructor
```csharp
class Bad
{
    public Bad(int x) { }  // No parameterless constructor!
}
// JsonSerializer.Deserialize<Bad>(...) will fail!
```

### Mistake 2: Using BinaryFormatter (security risk)
```csharp
// NEVER use BinaryFormatter - security vulnerability!
var formatter = new BinaryFormatter();  // ⚠️ DANGEROUS
```

---

## 📝 Practice Questions

1. **How do you exclude a property from JSON serialization?**
<details>
<summary>Answer</summary>
Use the `[JsonIgnore]` attribute on the property.
</details>

2. **What's the output for a null property with default options?**
<details>
<summary>Answer</summary>
Property appears with `null` value. Use `JsonIgnoreCondition.WhenWritingNull` to exclude.
</details>

---

## 🔗 Related Topics
- [16_File_Handling_IO.md](16_File_Handling_IO.md) - File operations
- [18_Attributes_Metadata.md](18_Attributes_Metadata.md) - Custom attributes
