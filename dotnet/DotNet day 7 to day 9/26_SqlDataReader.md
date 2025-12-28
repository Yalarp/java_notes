# SqlDataReader in C#

## 📚 Introduction

`SqlDataReader` provides a forward-only, read-only way to read data from a database. It's the most efficient way to read data when you only need to iterate through results once, as it streams data directly from the server.

---

## 🎯 Learning Objectives

- Master reading data with SqlDataReader
- Understand typed vs untyped data access
- Learn to map data to objects (DTOs/POCOs)
- Handle NULL values properly

---

## 📖 Theory: How DataReader Works

```
┌────────────────────────────────────────────────────────────────┐
│                   SqlDataReader Mechanism                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Database                                                       │
│  ┌─────────────────────────────────────────┐                   │
│  │  Row 1: Id=1, Name="Raj", Salary=3000   │                   │
│  │  Row 2: Id=2, Name="Mona", Salary=75000 │                   │
│  │  Row 3: Id=3, Name="Sam", Salary=45000  │                   │
│  └─────────────────────────────────────────┘                   │
│              ↓ Network Stream                                  │
│  ┌─────────────────────────────────────────┐                   │
│  │  SqlDataReader (cursor position)        │                   │
│  │  ────────────────────────────────       │                   │
│  │  Initial: BEFORE first row              │                   │
│  │  Read():  Move to Row 1 → true          │                   │
│  │  Read():  Move to Row 2 → true          │                   │
│  │  Read():  Move to Row 3 → true          │                   │
│  │  Read():  Past last row → false         │                   │
│  └─────────────────────────────────────────┘                   │
│                                                                 │
│  Key Characteristics:                                          │
│  • Forward-only (cannot go back)                               │
│  • Read-only (cannot modify data)                              │
│  • Holds connection open while reading                         │
│  • Best performance for read-once scenarios                    │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 1: Basic DataReader Usage

```csharp
using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

public class ProductLayer
{
    private string _connectionString;
    
    public ProductLayer(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    public void DisplayProducts()
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand("SELECT Id, Name, Price, Qty FROM Product", con);
            
            con.Open();
            
            // Execute and get reader
            SqlDataReader rdr = cmd.ExecuteReader();
            
            Console.WriteLine("ID\tName\t\tPrice\t\tQty");
            Console.WriteLine(new string('-', 50));
            
            // Check if rows exist
            if (rdr.HasRows)
            {
                // Move through each row
                while (rdr.Read())
                {
                    // Access data by column name
                    Console.WriteLine("{0}\t{1}\t\t{2:C}\t\t{3}",
                        rdr["Id"],
                        rdr["Name"],
                        rdr["Price"],
                        rdr["Qty"]);
                }
            }
            else
            {
                Console.WriteLine("No products found.");
            }
            
            // Reader closed automatically with connection
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 19 | `SELECT Id, Name...` | Select specific columns (better than *) |
| 24 | `cmd.ExecuteReader()` | Returns DataReader, starts streaming |
| 30 | `rdr.HasRows` | Check if any data returned |
| 33 | `rdr.Read()` | Advance to next row, false when done |
| 37-40 | `rdr["ColumnName"]` | Access column by name (returns object) |

---

## 💻 Code Example 2: Typed Data Access Methods

```csharp
using System;
using System.Data;
using System.Data.SqlClient;

public class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Salary { get; set; }
    public DateTime? HireDate { get; set; }
    public bool IsActive { get; set; }
}

public class EmployeeDAL
{
    private string _connectionString;
    
    public List<Employee> GetAllEmployees()
    {
        var employees = new List<Employee>();
        
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT Id, Name, Salary, HireDate, IsActive FROM Employees", 
                con);
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            
            while (rdr.Read())
            {
                Employee emp = new Employee();
                
                // Method 1: GetXxx methods (type-safe, throws if wrong type)
                emp.Id = rdr.GetInt32(0);           // By ordinal position
                emp.Name = rdr.GetString(1);        // Strongly typed
                emp.Salary = rdr.GetDecimal(2);     // No casting needed
                
                // Method 2: Handle NULLs safely
                if (!rdr.IsDBNull(3))
                {
                    emp.HireDate = rdr.GetDateTime(3);
                }
                
                emp.IsActive = rdr.GetBoolean(4);
                
                employees.Add(emp);
            }
        }
        
        return employees;
    }
}
```

### Typed Accessor Methods:

| Method | Returns | SQL Type |
|--------|---------|----------|
| `GetInt32(i)` | int | int, smallint |
| `GetInt64(i)` | long | bigint |
| `GetString(i)` | string | varchar, nvarchar |
| `GetDecimal(i)` | decimal | decimal, money |
| `GetDateTime(i)` | DateTime | datetime, date |
| `GetBoolean(i)` | bool | bit |
| `GetGuid(i)` | Guid | uniqueidentifier |
| `GetFloat(i)` | float | real |
| `GetDouble(i)` | double | float |

---

## 💻 Code Example 3: Mapping to Objects with Index

```csharp
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

public class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public float Salary { get; set; }
}

public class EmpDAL
{
    private string _connectionString;
    
    public EmpDAL(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    public List<Employee> GetList()
    {
        var listEmployee = new List<Employee>();
        
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand("SP_emp_GET_LIST", con);
            cmd.CommandType = CommandType.StoredProcedure;
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            
            while (rdr.Read())
            {
                // Create new employee for each row
                Employee emp = new Employee
                {
                    Id = Convert.ToInt32(rdr[0]),      // Index 0 = Id
                    Name = rdr[1].ToString(),          // Index 1 = Name
                    Salary = Convert.ToSingle(rdr[2])  // Index 2 = Salary
                };
                
                listEmployee.Add(emp);
            }
        }
        
        return listEmployee;
    }
}
```

### Memory Flow Diagram:

```
┌──────────────────────────────────────────────────────────────────┐
│  Database Employees Table                                        │
│  ┌─────┬───────┬────────┐                                        │
│  │ Id  │ Name  │ Salary │                                        │
│  ├─────┼───────┼────────┤                                        │
│  │  1  │ Raj   │ 3000   │                                        │
│  │  2  │ Mona  │ 75000  │                                        │
│  │  3  │ Sam   │ 45000  │                                        │
│  └─────┴───────┴────────┘                                        │
│          ↓ ExecuteReader()                                       │
│  ┌───────────────────────────────────────────────────────────┐   │
│  │  SqlDataReader (streams rows one at a time)               │   │
│  │  ─────────────────────────────────────────               │   │
│  │  Read() → Position at Row 1                               │   │
│  │           rdr[0]=1, rdr[1]="Raj", rdr[2]=3000            │   │
│  │           → Create Employee{1, "Raj", 3000}              │   │
│  │           → Add to List                                   │   │
│  │                                                           │   │
│  │  Read() → Position at Row 2                               │   │
│  │           rdr[0]=2, rdr[1]="Mona", rdr[2]=75000          │   │
│  │           → Create Employee{2, "Mona", 75000}            │   │
│  │           → Add to List                                   │   │
│  │                                                           │   │
│  │  Read() → Position at Row 3... (continues)               │   │
│  └───────────────────────────────────────────────────────────┘   │
│          ↓                                                       │
│  List<Employee> = [                                              │
│      Employee{1, "Raj", 3000},                                   │
│      Employee{2, "Mona", 75000},                                 │
│      Employee{3, "Sam", 45000}                                   │
│  ]                                                               │
└──────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 4: Handling NULL Values

```csharp
public Employee GetEmployeeById(int id)
{
    Employee emp = null;
    
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        SqlCommand cmd = new SqlCommand(
            "SELECT Id, Name, Salary, Email, ManagerId FROM Employees WHERE Id = @Id", 
            con);
        cmd.Parameters.AddWithValue("@Id", id);
        
        con.Open();
        SqlDataReader rdr = cmd.ExecuteReader();
        
        if (rdr.Read())  // Single record expected
        {
            emp = new Employee
            {
                Id = rdr.GetInt32(0),
                Name = rdr.GetString(1),
                Salary = rdr.GetDecimal(2)
            };
            
            // Handle nullable columns
            
            // Method 1: IsDBNull check
            if (!rdr.IsDBNull(3))
                emp.Email = rdr.GetString(3);
            
            // Method 2: Conditional operator with as
            emp.ManagerId = rdr.IsDBNull(4) ? (int?)null : rdr.GetInt32(4);
            
            // Method 3: Using index and null check
            emp.Email = rdr[3] == DBNull.Value ? null : rdr[3].ToString();
        }
    }
    
    return emp;
}
```

### DBNull Handling Patterns:

```
┌────────────────────────────────────────────────────────────────┐
│                 DBNull Handling Patterns                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Pattern 1: IsDBNull (Recommended)                             │
│  ─────────────────────────────────                             │
│  if (!rdr.IsDBNull(columnIndex))                               │
│      value = rdr.GetString(columnIndex);                       │
│                                                                 │
│  Pattern 2: Compare to DBNull.Value                            │
│  ──────────────────────────────────                            │
│  if (rdr[columnIndex] != DBNull.Value)                         │
│      value = rdr[columnIndex].ToString();                      │
│                                                                 │
│  Pattern 3: Ternary with nullable                              │
│  ────────────────────────────────                              │
│  int? id = rdr.IsDBNull(0) ? (int?)null : rdr.GetInt32(0);    │
│                                                                 │
│  ⚠️ Common Mistake:                                            │
│  WRONG: if (rdr["Email"] != null)  // Won't work!             │
│  RIGHT: if (rdr["Email"] != DBNull.Value)                      │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Access Method Comparison

| Method | Example | Returns | Null Safe? | Performance |
|--------|---------|---------|------------|-------------|
| Index `rdr[0]` | `rdr[0]` | object | ❌ | Fastest |
| Column Name | `rdr["Name"]` | object | ❌ | Slower |
| GetXxx | `rdr.GetString(1)` | typed | ❌ | Fast |
| GetOrdinal | `rdr.GetOrdinal("Name")` | int | N/A | One-time lookup |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Forward-only** - Cannot move backwards to previous rows
2. **Read-only** - Cannot modify data through DataReader
3. **Connection open** - Connection stays open while reading
4. **Use GetXxx** - Faster than casting from object
5. **Always check DBNull** - Database NULL ≠ C# null
6. **Close reader** - Use "using" or call Close()

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Accessing by name in loop | Performance overhead | Use GetOrdinal once, then use index |
| Not checking DBNull | InvalidCastException | Use IsDBNull before GetXxx |
| Keeping reader open | Connection exhaustion | Close reader/connection promptly |
| Reading after close | InvalidOperationException | Access data before disposing |

---

## 📝 Interview Questions

1. **What's the difference between DataReader and DataSet?**
   - DataReader: Forward-only, connected, streaming, read-only
   - DataSet: Disconnected, in-memory, random access, editable

2. **Why is GetString() better than ToString()?**
   - GetString() is type-safe and faster
   - ToString() requires boxing/unboxing and casting

3. **How do you handle NULL values from database?**
   - Use IsDBNull(index) before accessing
   - Compare to DBNull.Value
   - Use nullable types (int?)

---

## 🔗 Next Topic
Next: [27_SQL_Injection_Prevention.md](./27_SQL_Injection_Prevention.md) - SQL Injection Prevention
