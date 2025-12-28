# Collection CRUD Pattern in C#

## 📚 Introduction

This pattern demonstrates how to implement in-memory CRUD (Create, Read, Update, Delete) operations using collections and interfaces. It's a foundation for understanding service layers and repository patterns.

---

## 🎯 Learning Objectives

- Implement interface-based service design
- Master in-memory CRUD operations with List<T>
- Understand POCO classes and service separation

---

## 📖 Architecture Overview

```
┌────────────────────────────────────────────────────────────────┐
│                    Layered Architecture                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────────┐                                          │
│   │   Entry Point   │  Program.cs / Main()                     │
│   └────────┬────────┘                                          │
│            ↓                                                    │
│   ┌─────────────────┐                                          │
│   │    Interface    │  IEmpService (contract)                  │
│   └────────┬────────┘                                          │
│            ↓                                                    │
│   ┌─────────────────┐                                          │
│   │   Service Layer │  EmployeeService (implementation)        │
│   └────────┬────────┘                                          │
│            ↓                                                    │
│   ┌─────────────────┐                                          │
│   │   Data Storage  │  List<Employee> (in-memory)              │
│   └─────────────────┘                                          │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Complete Implementation

### Step 1: POCO Class (Model)

```csharp
using System;

// Enum for departments
public enum Dept
{
    HR,
    Payroll,
    IT
}

// POCO (Plain Old CLR Object) class
internal class Employee
{
    static int getid;    // Static counter for auto-increment
    int id;
    
    internal Employee()
    {
        id = ++getid;    // Auto-increment ID on creation
    }
    
    public string Name { get; set; }
    
    public int Id
    {
        get { return id; }
    }
    
    public string Email { get; set; }
    
    public Dept? Department { get; set; }  // Nullable enum

    public override string ToString()
    {
        return String.Format("{0} {1} {2} {3}", Id, Name, Email, Department);
    }
}
```

### Step 2: Interface (Contract)

```csharp
using System.Collections.Generic;

// Service interface defines the contract
internal interface IEmpService
{
    Employee GetEmployee(int Id);                    // Get by ID
    IEnumerable<Employee> GetEmployee(string name);  // Get by name
    IEnumerable<Employee> GetAllEmployee();          // Get all
    Employee Add(Employee employee);                 // Create
    Employee Delete(int Id);                         // Delete
}
```

### Step 3: Service Implementation

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

internal class EmployeeService : IEmpService
{
    // In-memory storage
    private static List<Employee> _employeeList;

    public EmployeeService()
    {
        // Initialize with sample data
        _employeeList = new List<Employee>
        {
            new Employee { Name = "Mary", Department = Dept.HR, 
                          Email = "mary@CDACtech.com" },
            new Employee { Name = "John", Department = Dept.IT, 
                          Email = "john@CDACtech.com" },
            new Employee { Name = "Sam", Department = Dept.IT, 
                          Email = "sam@CDACtech.com" }
        };
    }
    
    // CREATE: Add new employee
    public Employee Add(Employee employee)
    {
        _employeeList.Add(employee);
        return employee;
    }
    
    // DELETE: Remove by ID
    public Employee Delete(int Id)
    {
        Employee employee = _employeeList.Find(e => e.Id == Id);
        
        if (employee != null)
        {
            _employeeList.Remove(employee);
        }
        return employee;  // Returns deleted employee or null
    }
    
    // READ: Get all employees
    public IEnumerable<Employee> GetAllEmployee()
    {
        return _employeeList;
    }
    
    // READ: Get by ID
    public Employee GetEmployee(int Id)
    {
        Employee employee = _employeeList.Find(e => e.Id == Id);
        return employee;
    }
    
    // READ: Get by name (returns multiple)
    public IEnumerable<Employee> GetEmployee(string name)
    {
        return _employeeList.FindAll(e => e.Name == name);
    }
}
```

### Step 4: Entry Point (Program)

```csharp
using System;
using System.Collections.Generic;
using System.Text.Json;
using System.Text.Json.Serialization;

class Program
{
    static void Main(string[] args)
    {
        // Create service instance via interface
        IEmpService empService = new EmployeeService();
        
        // CREATE: Add employees
        Employee e1 = empService.Add(
            new Employee { Name = "Sonam", Department = Dept.IT, 
                          Email = "som@CDACtech.com" });
        Console.WriteLine($"{e1} Added in collection");
        
        e1 = empService.Add(
            new Employee { Name = "Mona", Department = Dept.HR, 
                          Email = "sonam@CDACtech.com" });
        Console.WriteLine($"{e1} Added in collection");
        
        // DELETE: Remove employee with ID 3
        e1 = empService.Delete(3);
        Console.WriteLine($"{e1} Deleted from collection");
        
        // READ: Get by ID
        e1 = empService.GetEmployee(1);
        Console.WriteLine($"Record of {e1.Id} ==> {e1}");
        
        // READ: Get by name
        IEnumerable<Employee> list = empService.GetEmployee("Sonam");
        Console.WriteLine("Records with name Sonam:");
        foreach (Employee emp in list)
        {
            Console.WriteLine(emp);
        }
        
        // READ: Get all with JSON serialization
        list = empService.GetAllEmployee();
        var options = new JsonSerializerOptions
        {
            WriteIndented = true
        };
        
        foreach (Employee emp in list)
        {
            Console.WriteLine(JsonSerializer.Serialize(emp, options));
        }
    }
}
```

---

## 📊 CRUD Operations Summary

| Operation | Method | LINQ Used |
|-----------|--------|-----------|
| **Create** | `Add(employee)` | `List.Add()` |
| **Read One** | `GetEmployee(id)` | `List.Find()` |
| **Read Many** | `GetEmployee(name)` | `List.FindAll()` |
| **Read All** | `GetAllEmployee()` | Return list |
| **Delete** | `Delete(id)` | `Find()` + `Remove()` |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Interface-based design** - Enables loose coupling
2. **POCO classes** - Simple data containers
3. **Find() vs FindAll()** - Single vs multiple results
4. **Auto-increment pattern** - Use static counter
5. **Return deleted object** - For confirmation

---

## 🔗 Next Topic
Next: [17_Dependency_Injection_Introduction.md](./17_Dependency_Injection_Introduction.md) - Dependency Injection
