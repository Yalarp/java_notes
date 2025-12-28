# Stored Procedures in ADO.NET

## 📚 Introduction

Stored procedures are precompiled SQL statements stored on the database server. They provide better performance (cached execution plans), enhanced security (reduced SQL injection risk), and improved maintainability (SQL logic separate from application code).

---

## 🎯 Learning Objectives

- Create and call stored procedures from C#
- Pass input and output parameters
- Handle return values
- Understand the benefits of stored procedures

---

## 📖 Theory: Stored Procedure Benefits

```
┌────────────────────────────────────────────────────────────────┐
│               Stored Procedure Benefits                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. PERFORMANCE                                                 │
│     • Precompiled execution plan                               │
│     • Cached and reused                                        │
│     • Reduced network traffic (send SP name, not SQL)          │
│                                                                 │
│  2. SECURITY                                                    │
│     • Parameters prevent SQL injection                         │
│     • Grant execute on SP, not table access                    │
│     • Business logic hidden from client                        │
│                                                                 │
│  3. MAINTAINABILITY                                             │
│     • Centralized SQL logic                                    │
│     • Change SQL without redeploying application               │
│     • Easy versioning and updates                              │
│                                                                 │
│  4. REUSABILITY                                                 │
│     • Called from multiple applications                        │
│     • Consistent data access                                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 1: Creating Stored Procedures (SQL)

```sql
-- Get all employees
CREATE PROCEDURE [dbo].[SP_emp_GET_LIST]
AS
BEGIN
    SELECT Id, Name, Salary
    FROM Employees
    ORDER BY Name
END
GO

-- Get products by name (with parameter)
CREATE PROCEDURE spGetProductsByName
    @ProductName NVARCHAR(100)
AS
BEGIN
    SELECT Id, Name, Price, Qty 
    FROM Products 
    WHERE Name LIKE @ProductName + '%'
END
GO

-- Insert product (with multiple parameters)
CREATE PROCEDURE spInsertProduct
    @Name NVARCHAR(100),
    @Price DECIMAL(18,2),
    @Qty INT,
    @NewId INT OUTPUT  -- Output parameter
AS
BEGIN
    INSERT INTO Products (Name, Price, Qty)
    VALUES (@Name, @Price, @Qty)
    
    SET @NewId = SCOPE_IDENTITY()  -- Return new ID
    
    RETURN @@ROWCOUNT  -- Return rows affected
END
GO
```

---

## 💻 Code Example 2: Calling SP with No Parameters

```csharp
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

public class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Salary { get; set; }
}

public class EmpDAL
{
    private string _connectionString;
    
    public EmpDAL(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    public List<Employee> GetAllEmployees()
    {
        var employees = new List<Employee>();
        
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // Use stored procedure name as command text
            SqlCommand cmd = new SqlCommand("SP_emp_GET_LIST", con);
            
            // IMPORTANT: Set command type to StoredProcedure
            cmd.CommandType = CommandType.StoredProcedure;
            
            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();
            
            while (rdr.Read())
            {
                employees.Add(new Employee
                {
                    Id = Convert.ToInt32(rdr["Id"]),
                    Name = rdr["Name"].ToString(),
                    Salary = Convert.ToDecimal(rdr["Salary"])
                });
            }
        }
        
        return employees;
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 30 | `"SP_emp_GET_LIST"` | Stored procedure name (not SELECT statement) |
| 33 | `CommandType.StoredProcedure` | Critical - tells ADO.NET it's a SP |
| 36 | `ExecuteReader()` | Same execution method as regular query |

---

## 💻 Code Example 3: Calling SP with Input Parameters

```csharp
public List<Product> GetProductsByName(string productName)
{
    var products = new List<Product>();
    
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        SqlCommand cmd = new SqlCommand("spGetProductsByName", con);
        cmd.CommandType = CommandType.StoredProcedure;
        
        // Add input parameter
        // Method 1: AddWithValue (simple)
        cmd.Parameters.AddWithValue("@ProductName", productName);
        
        // Method 2: SqlParameter with explicit type (recommended)
        // SqlParameter param = new SqlParameter("@ProductName", SqlDbType.NVarChar, 100);
        // param.Value = productName;
        // cmd.Parameters.Add(param);
        
        con.Open();
        SqlDataReader rdr = cmd.ExecuteReader();
        
        while (rdr.Read())
        {
            products.Add(new Product
            {
                Id = Convert.ToInt32(rdr["Id"]),
                Name = rdr["Name"].ToString(),
                Price = Convert.ToDecimal(rdr["Price"]),
                Quantity = Convert.ToInt32(rdr["Qty"])
            });
        }
    }
    
    return products;
}
```

### Execution Flow:

```
┌─────────────────────────────────────────────────────────────────┐
│  C# Application                      SQL Server                 │
│  ──────────────                      ──────────                 │
│                                                                 │
│  cmd = "spGetProductsByName"    →    Server receives:          │
│  @ProductName = "iPhone"             EXEC spGetProductsByName   │
│  CommandType = SP                         @ProductName='iPhone' │
│           │                                      │              │
│           │                                      ↓              │
│           │                         Stored Procedure executes: │
│           │                         SELECT * FROM Products     │
│           │                         WHERE Name LIKE 'iPhone%'  │
│           │                                      │              │
│           ↓                                      ↓              │
│  SqlDataReader  ←──────────────────  Result Set returned       │
│  (streaming rows)                                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 4: SP with Output Parameters

```csharp
public int InsertProduct(string name, decimal price, int qty)
{
    int newId = 0;
    
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        SqlCommand cmd = new SqlCommand("spInsertProduct", con);
        cmd.CommandType = CommandType.StoredProcedure;
        
        // Input parameters
        cmd.Parameters.AddWithValue("@Name", name);
        cmd.Parameters.AddWithValue("@Price", price);
        cmd.Parameters.AddWithValue("@Qty", qty);
        
        // Output parameter - must specify direction
        SqlParameter outputParam = new SqlParameter("@NewId", SqlDbType.Int);
        outputParam.Direction = ParameterDirection.Output;
        cmd.Parameters.Add(outputParam);
        
        con.Open();
        
        // ExecuteNonQuery for INSERT
        int rowsAffected = cmd.ExecuteNonQuery();
        
        // Read output parameter AFTER execution
        if (outputParam.Value != DBNull.Value)
        {
            newId = (int)outputParam.Value;
        }
        
        Console.WriteLine($"Inserted {rowsAffected} row(s). New ID: {newId}");
    }
    
    return newId;
}
```

### Parameter Direction Types:

```
┌────────────────────────────────────────────────────────────────┐
│                  ParameterDirection Values                      │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Input (default)                                               │
│  • Value passed TO stored procedure                            │
│  • Cannot read value after execution                           │
│                                                                 │
│  Output                                                         │
│  • Value set BY stored procedure                               │
│  • Read value AFTER execution                                  │
│  • Example: @NewId INT OUTPUT                                  │
│                                                                 │
│  InputOutput                                                    │
│  • Pass value IN, get modified value OUT                       │
│  • Both directions                                             │
│                                                                 │
│  ReturnValue                                                    │
│  • For RETURN statement value                                  │
│  • Always INT type                                             │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 5: SP with Return Value

```csharp
public int InsertProductWithReturn(string name, decimal price, int qty)
{
    int newId = 0;
    int returnValue = 0;
    
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        SqlCommand cmd = new SqlCommand("spInsertProduct", con);
        cmd.CommandType = CommandType.StoredProcedure;
        
        // Return value parameter - must be added FIRST
        SqlParameter returnParam = new SqlParameter();
        returnParam.Direction = ParameterDirection.ReturnValue;
        cmd.Parameters.Add(returnParam);
        
        // Input parameters
        cmd.Parameters.AddWithValue("@Name", name);
        cmd.Parameters.AddWithValue("@Price", price);
        cmd.Parameters.AddWithValue("@Qty", qty);
        
        // Output parameter
        SqlParameter outputParam = new SqlParameter("@NewId", SqlDbType.Int);
        outputParam.Direction = ParameterDirection.Output;
        cmd.Parameters.Add(outputParam);
        
        con.Open();
        cmd.ExecuteNonQuery();
        
        // Read return value
        returnValue = (int)returnParam.Value;
        
        // Read output parameter
        newId = (int)outputParam.Value;
        
        Console.WriteLine($"Return Value: {returnValue}, New ID: {newId}");
    }
    
    return newId;
}
```

---

## 📊 Best Practices

| Practice | Description |
|----------|-------------|
| **Use meaningful names** | sp_GetCustomerById, not sp_1 |
| **Prefix with sp or usp** | Distinguishes from tables |
| **Set CommandType** | Always set to StoredProcedure |
| **Use explicit SqlParameter** | Better than AddWithValue for types |
| **Handle NULLs** | Check DBNull.Value for outputs |
| **Transaction support** | SPs can encapsulate transactions |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Set CommandType** - Must be `StoredProcedure`
2. **Output parameters** - Set `Direction = ParameterDirection.Output`
3. **Read after execute** - Output values available after ExecuteXxx()
4. **Return value first** - Add ReturnValue parameter before others
5. **Performance** - Cached execution plans
6. **Security** - Parameters always safe from injection

---

## 📝 Interview Questions

1. **What's CommandType.StoredProcedure?**
   - Tells ADO.NET to execute a stored procedure, not raw SQL
   - Without it, it tries to execute SP name as SQL statement

2. **Difference between Output and Return parameters?**
   - Output: Can be any type, set via SET @Param = value
   - Return: Always INT, set via RETURN statement

3. **When to use stored procedures vs inline SQL?**
   - SP: Complex logic, security-critical, frequently called
   - Inline: Simple queries, dynamic SQL needed, ORM used

---

## 🔗 Next Topic
Next: [29_SOLID_Principles_Overview.md](./29_SOLID_Principles_Overview.md) - SOLID Principles
