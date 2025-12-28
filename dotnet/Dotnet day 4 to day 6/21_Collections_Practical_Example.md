# Collections Practical Example - Employee Service

## 📚 Introduction

This note provides a complete practical example of using collections in a real-world scenario - an Employee Management System that demonstrates `List<T>`, interfaces, and service patterns.

---

## 🎯 Learning Objectives

- Apply collections in real-world scenarios
- Implement service layer pattern
- Use interfaces for abstraction
- Master JSON serialization with collections

---

## 💻 Complete Example: Employee Management System

### Employee.cs - The Model

```csharp
using System;

namespace CA_collection
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Department { get; set; }
        public string Email { get; set; }
        
        // Constructor
        public Employee() { }
        
        public Employee(int id, string name, string dept, string email)
        {
            Id = id;
            Name = name;
            Department = dept;
            Email = email;
        }
        
        // Override ToString for readable output
        public override string ToString()
        {
            return $"ID: {Id}, Name: {Name}, Dept: {Department}, Email: {Email}";
        }
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 7-10 | Properties | Auto-implemented properties for employee data |
| 13 | `public Employee() { }` | Parameterless constructor needed for deserialization |
| 24-27 | `override string ToString()` | Provides readable string representation |

---

### IEmpService.cs - The Interface

```csharp
using System;
using System.Collections.Generic;

namespace CA_collection
{
    public interface IEmpService
    {
        // Get single employee by ID
        Employee GetEmpById(int id);
        
        // Get all employees
        List<Employee> GetAllEmployees();
        
        // Get employees by department
        List<Employee> GetByDept(string deptName);
        
        // Add new employee
        void Add(Employee emp);
        
        // Delete employee by ID
        void Delete(int id);
    }
}
```

**Why use an interface?**
- Enables dependency injection
- Allows different implementations (database, file, in-memory)
- Facilitates unit testing with mocks
- Follows SOLID principles

---

### EmployeeService.cs - The Implementation

```csharp
using System;
using System.Collections.Generic;

namespace CA_collection
{
    public class EmployeeService : IEmpService
    {
        // Private collection to store employees
        private List<Employee> _employees = new List<Employee>();
        
        // Constructor with sample data
        public EmployeeService()
        {
            _employees = new List<Employee>
            {
                new Employee(1, "Raj", "IT", "raj@company.com"),
                new Employee(2, "Mona", "HR", "mona@company.com"),
                new Employee(3, "Het", "IT", "het@company.com"),
                new Employee(4, "Amit", "Finance", "amit@company.com")
            };
        }
        
        // Get employee by ID using Find with Predicate
        public Employee GetEmpById(int id)
        {
            return _employees.Find(e => e.Id == id);
        }
        
        // Get all employees (return copy to protect internal list)
        public List<Employee> GetAllEmployees()
        {
            return new List<Employee>(_employees);
        }
        
        // Get employees by department using FindAll
        public List<Employee> GetByDept(string deptName)
        {
            return _employees.FindAll(e => 
                e.Department.Equals(deptName, StringComparison.OrdinalIgnoreCase));
        }
        
        // Add new employee
        public void Add(Employee emp)
        {
            // Validate
            if (emp == null)
                throw new ArgumentNullException(nameof(emp));
            
            // Check for duplicate ID
            if (_employees.Exists(e => e.Id == emp.Id))
                throw new InvalidOperationException($"Employee with ID {emp.Id} already exists");
            
            _employees.Add(emp);
        }
        
        // Delete employee by ID
        public void Delete(int id)
        {
            Employee toRemove = _employees.Find(e => e.Id == id);
            if (toRemove == null)
                throw new InvalidOperationException($"Employee with ID {id} not found");
            
            _employees.Remove(toRemove);
        }
    }
}
```

#### Key Methods Explained

| Method | Collection Operation | Purpose |
|--------|---------------------|---------|
| `GetEmpById` | `Find(Predicate)` | Returns first match or null |
| `GetAllEmployees` | `new List<T>(source)` | Returns defensive copy |
| `GetByDept` | `FindAll(Predicate)` | Returns all matches |
| `Add` | `Add(T)` | Adds with validation |
| `Delete` | `Find` + `Remove` | Find then remove |

---

### Program.cs - Using the Service

```csharp
using System;
using System.Collections.Generic;
using System.Text.Json;

namespace CA_collection
{
    class Program
    {
        static void Main(string[] args)
        {
            // Create service instance
            IEmpService service = new EmployeeService();
            
            Console.WriteLine("=== All Employees ===");
            List<Employee> allEmployees = service.GetAllEmployees();
            foreach (var emp in allEmployees)
            {
                Console.WriteLine(emp);
            }
            
            Console.WriteLine("\n=== IT Department ===");
            List<Employee> itEmployees = service.GetByDept("IT");
            foreach (var emp in itEmployees)
            {
                Console.WriteLine(emp);
            }
            
            Console.WriteLine("\n=== Find Employee by ID ===");
            Employee found = service.GetEmpById(2);
            Console.WriteLine(found != null ? found.ToString() : "Not found");
            
            Console.WriteLine("\n=== Add New Employee ===");
            Employee newEmp = new Employee(5, "Sara", "Marketing", "sara@company.com");
            service.Add(newEmp);
            Console.WriteLine($"Added: {newEmp}");
            
            Console.WriteLine("\n=== Delete Employee ===");
            service.Delete(1);
            Console.WriteLine("Deleted employee with ID 1");
            
            Console.WriteLine("\n=== Remaining Employees ===");
            foreach (var emp in service.GetAllEmployees())
            {
                Console.WriteLine(emp);
            }
            
            // JSON Serialization
            Console.WriteLine("\n=== JSON Serialization ===");
            string json = JsonSerializer.Serialize(
                service.GetAllEmployees(),
                new JsonSerializerOptions { WriteIndented = true }
            );
            Console.WriteLine(json);
        }
    }
}
```

#### Output:
```
=== All Employees ===
ID: 1, Name: Raj, Dept: IT, Email: raj@company.com
ID: 2, Name: Mona, Dept: HR, Email: mona@company.com
ID: 3, Name: Het, Dept: IT, Email: het@company.com
ID: 4, Name: Amit, Dept: Finance, Email: amit@company.com

=== IT Department ===
ID: 1, Name: Raj, Dept: IT, Email: raj@company.com
ID: 3, Name: Het, Dept: IT, Email: het@company.com

=== Find Employee by ID ===
ID: 2, Name: Mona, Dept: HR, Email: mona@company.com

=== Add New Employee ===
Added: ID: 5, Name: Sara, Dept: Marketing, Email: sara@company.com

=== Delete Employee ===
Deleted employee with ID 1

=== Remaining Employees ===
ID: 2, Name: Mona, Dept: HR, Email: mona@company.com
ID: 3, Name: Het, Dept: IT, Email: het@company.com
ID: 4, Name: Amit, Dept: Finance, Email: amit@company.com
ID: 5, Name: Sara, Dept: Marketing, Email: sara@company.com

=== JSON Serialization ===
[
  {
    "Id": 2,
    "Name": "Mona",
    "Department": "HR",
    "Email": "mona@company.com"
  },
  ...
]
```

---

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Program.cs                                │
│                     (Client/Consumer)                            │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Uses
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                       IEmpService                                │
│                       (Interface)                                │
│  + GetEmpById(id): Employee                                     │
│  + GetAllEmployees(): List<Employee>                            │
│  + GetByDept(dept): List<Employee>                              │
│  + Add(emp): void                                               │
│  + Delete(id): void                                             │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Implements
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                     EmployeeService                              │
│                    (Implementation)                              │
│  - _employees: List<Employee>                                   │
│  (Uses List<T> methods: Find, FindAll, Add, Remove, Exists)    │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Stores
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Employee                                  │
│                        (Model)                                   │
│  + Id: int                                                      │
│  + Name: string                                                 │
│  + Department: string                                           │
│  + Email: string                                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Key Patterns Demonstrated

1. **Interface-based programming** - `IEmpService` defines contract
2. **Defensive copying** - `GetAllEmployees` returns new list
3. **Input validation** - Check null and duplicates before Add
4. **Predicate usage** - Lambda expressions with Find/FindAll
5. **Exception handling** - Meaningful exceptions for invalid operations

---

## ❌ Common Mistakes

### Mistake 1: Returning internal collection directly
```csharp
// BAD - caller can modify internal list!
public List<Employee> GetAllEmployees() => _employees;

// GOOD - return copy
public List<Employee> GetAllEmployees() => new List<Employee>(_employees);
```

### Mistake 2: Not checking for null in Find result
```csharp
Employee emp = service.GetEmpById(999);
Console.WriteLine(emp.Name);  // NullReferenceException!

// CORRECT
if (emp != null)
    Console.WriteLine(emp.Name);
```

---

## 📝 Practice Questions

1. **Why create a new List in GetAllEmployees?**
<details>
<summary>Answer</summary>
To prevent external code from modifying the internal collection (defensive copying).
</details>

2. **What collection method uses Predicate<T>?**
<details>
<summary>Answer</summary>
`Find`, `FindAll`, `Exists`, `RemoveAll`, `TrueForAll` all use `Predicate<T>`.
</details>

---

## 🔗 Related Topics
- [20_Collections_Complete_Guide.md](20_Collections_Complete_Guide.md) - Collection types
- [07_Interfaces_Fundamentals.md](07_Interfaces_Fundamentals.md) - Interfaces
- [17_Serialization.md](17_Serialization.md) - JSON serialization
