# SqlCommand Execution in C#

## 📚 Introduction

`SqlCommand` is the core class for executing SQL statements and stored procedures against a SQL Server database. It provides different execute methods depending on the type of query and expected results.

---

## 🎯 Learning Objectives

- Master the three Execute methods: ExecuteReader, ExecuteNonQuery, ExecuteScalar
- Understand when to use each method
- Learn proper command construction and parameter handling

---

## 📖 Theory: Command Execution Methods

```
┌────────────────────────────────────────────────────────────────┐
│                    SqlCommand Execute Methods                   │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ExecuteReader()                                               │
│  ───────────────                                               │
│  → Returns: SqlDataReader                                      │
│  → Use for: SELECT queries that return rows                   │
│  → Iterates through result set row by row                     │
│                                                                 │
│  ExecuteNonQuery()                                             │
│  ─────────────────                                             │
│  → Returns: int (number of rows affected)                     │
│  → Use for: INSERT, UPDATE, DELETE                            │
│  → No data returned, just affected count                      │
│                                                                 │
│  ExecuteScalar()                                               │
│  ───────────────                                               │
│  → Returns: object (first column of first row)                │
│  → Use for: Aggregate queries (COUNT, SUM, MAX, AVG)          │
│  → Efficient for single value retrieval                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 1: ExecuteReader - SELECT Queries

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
    
    public void GetAllProducts()
    {
        // Using statement ensures connection is closed
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // Create command with SQL and connection
            SqlCommand cmd = new SqlCommand("SELECT * FROM Product", con);
            
            // Open connection
            con.Open();
            
            // Execute and get reader
            SqlDataReader rdr = cmd.ExecuteReader();
            
            // Check if any rows returned
            if (rdr.HasRows)
            {
                // Read row by row
                while (rdr.Read())
                {
                    // Access columns by name or index
                    Console.WriteLine("{0} {1} {2} {3}",
                        rdr["Id"],      // By column name
                        rdr["Name"],    // By column name
                        rdr[2],         // By index (Price)
                        rdr[3]);        // By index (Qty)
                }
            }
            else
            {
                Console.WriteLine("No records found.");
            }
            
            // Reader closed automatically at end of using
        }
        // Connection closed automatically at end of using
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 18 | `using (SqlConnection...)` | Creates connection, auto-closes on exit |
| 21 | `new SqlCommand(sql, con)` | Associates SQL with connection |
| 24 | `con.Open()` | Opens database connection |
| 27 | `cmd.ExecuteReader()` | Executes SELECT, returns DataReader |
| 30 | `rdr.HasRows` | Check if query returned any rows |
| 33 | `rdr.Read()` | Advances to next row, returns false when done |
| 36-39 | `rdr["Name"]` or `rdr[0]` | Access column by name or zero-based index |

### Execution Flow:

```
┌─────────────────────────────────────────────────────────────────┐
│  1. SqlConnection created (not yet open)                        │
│             ↓                                                   │
│  2. SqlCommand created with SQL text                           │
│             ↓                                                   │
│  3. Connection opened → Database connection established        │
│             ↓                                                   │
│  4. ExecuteReader() → SQL sent to server                       │
│             ↓                                                   │
│  5. SqlDataReader returned (cursor at before first row)        │
│             ↓                                                   │
│  6. Read() → Moves to first row (returns true if exists)       │
│             ↓                                                   │
│  7. Access columns via rdr["column"] or rdr[index]             │
│             ↓                                                   │
│  8. Read() → Moves to next row until false                     │
│             ↓                                                   │
│  9. Using block ends → Connection automatically closed         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 2: ExecuteNonQuery - INSERT, UPDATE, DELETE

```csharp
using System;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

public class ProductLayer
{
    private string _connectionString;
    
    public ProductLayer(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    // INSERT Operation
    public void InsertProduct()
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // Create INSERT command
            SqlCommand cmd = new SqlCommand(
                "INSERT INTO Product (Id, Name, Price, Qty) VALUES (1, 'iPhone', 75000, 2)", 
                con);
            
            con.Open();
            
            // ExecuteNonQuery returns number of rows affected
            int rowsAffected = cmd.ExecuteNonQuery();
            
            Console.WriteLine("Inserted Rows = " + rowsAffected);
            // Output: Inserted Rows = 1
        }
    }
    
    // UPDATE Operation
    public void UpdateProduct()
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // Reuse command by changing CommandText
            SqlCommand cmd = new SqlCommand(con);
            cmd.Connection = con;
            cmd.CommandText = "UPDATE Product SET Price = 15000 WHERE Id = 2";
            
            con.Open();
            
            int rowsAffected = cmd.ExecuteNonQuery();
            
            Console.WriteLine("Updated Rows = " + rowsAffected);
            // Output: Updated Rows = 1 (if record exists)
        }
    }
    
    // DELETE Operation
    public void DeleteProduct(int productId)
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand(
                "DELETE FROM Product WHERE Id = " + productId, 
                con);
            
            con.Open();
            
            int rowsAffected = cmd.ExecuteNonQuery();
            
            if (rowsAffected > 0)
                Console.WriteLine($"Deleted {rowsAffected} row(s)");
            else
                Console.WriteLine("No record found to delete");
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 20-22 | `INSERT INTO...` | SQL INSERT statement |
| 27 | `ExecuteNonQuery()` | Returns count of affected rows |
| 42 | `cmd.CommandText = ...` | Change SQL text on existing command |
| 59 | String concatenation | ⚠️ DANGEROUS - SQL Injection risk! |

### Return Value Meaning:

```
┌────────────────────────────────────────────────────────────────┐
│           ExecuteNonQuery Return Values                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Return Value    Meaning                                        │
│  ─────────────   ──────────────────────────────────────────    │
│      > 0         Number of rows affected by INSERT/UPDATE/DELETE│
│      = 0         No rows were affected                          │
│      -1          For statements that don't affect rows          │
│                  (CREATE TABLE, DROP, ALTER)                    │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 3: ExecuteScalar - Aggregate Queries

```csharp
using System;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

public class ProductLayer
{
    private string _connectionString;
    
    public ProductLayer(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    // Get total count of products
    public int GetProductCount()
    {
        int totalRows = 0;
        
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand("SELECT COUNT(Id) FROM Product", con);
            
            con.Open();
            
            // ExecuteScalar returns object, cast to appropriate type
            object result = cmd.ExecuteScalar();
            
            if (result != null && result != DBNull.Value)
            {
                totalRows = Convert.ToInt32(result);
            }
        }
        
        return totalRows;
    }
    
    // Get maximum price
    public decimal GetMaxPrice()
    {
        decimal maxPrice = 0;
        
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand("SELECT MAX(Price) FROM Product", con);
            
            con.Open();
            
            object result = cmd.ExecuteScalar();
            
            if (result != null && result != DBNull.Value)
            {
                maxPrice = Convert.ToDecimal(result);
            }
        }
        
        return maxPrice;
    }
    
    // Get total inventory value
    public decimal GetTotalInventoryValue()
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            SqlCommand cmd = new SqlCommand(
                "SELECT SUM(Price * Qty) FROM Product", con);
            
            con.Open();
            
            object result = cmd.ExecuteScalar();
            
            return result != DBNull.Value ? Convert.ToDecimal(result) : 0;
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 21 | `SELECT COUNT(Id)` | SQL aggregate function |
| 26 | `cmd.ExecuteScalar()` | Returns first column of first row as object |
| 28 | `result != DBNull.Value` | Check for database NULL |
| 30 | `Convert.ToInt32(result)` | Cast object to expected type |

### When to Use ExecuteScalar:

```
┌────────────────────────────────────────────────────────────────┐
│                 ExecuteScalar Use Cases                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ Good Uses:                                                  │
│  • SELECT COUNT(*) FROM table                                  │
│  • SELECT MAX(column) FROM table                               │
│  • SELECT SUM(column) FROM table                               │
│  • SELECT AVG(column) FROM table                               │
│  • SELECT column FROM table WHERE id = @id (single value)      │
│  • Getting auto-generated ID after INSERT                      │
│                                                                 │
│  ❌ Don't Use:                                                  │
│  • Multiple rows expected (use ExecuteReader)                  │
│  • Multiple columns needed (use ExecuteReader)                 │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Method Comparison Summary

| Method | Returns | Use For | Performance |
|--------|---------|---------|-------------|
| `ExecuteReader()` | SqlDataReader | SELECT (multiple rows) | Good for streaming |
| `ExecuteNonQuery()` | int | INSERT, UPDATE, DELETE | Fastest (no data returned) |
| `ExecuteScalar()` | object | Aggregates (COUNT, SUM) | Efficient for single value |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **ExecuteReader** - For SELECT queries returning rows
2. **ExecuteNonQuery** - For INSERT/UPDATE/DELETE, returns affected count
3. **ExecuteScalar** - For single value (aggregates), returns object
4. **Always use "using"** - Ensures proper resource cleanup
5. **Check for DBNull** - Database NULL ≠ C# null

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Not opening connection | InvalidOperationException | Call `con.Open()` before execute |
| Not checking DBNull | NullReferenceException | Check `!= DBNull.Value` |
| Wrong execute method | Runtime exception or empty result | Match method to query type |
| Not closing connection | Connection pool exhaustion | Use `using` statement |

---

## 📝 Interview Questions

1. **What's the difference between ExecuteReader, ExecuteNonQuery, and ExecuteScalar?**
   - ExecuteReader: Returns DataReader for SELECT with multiple rows
   - ExecuteNonQuery: Returns int (affected rows) for INSERT/UPDATE/DELETE
   - ExecuteScalar: Returns object (first column, first row) for aggregates

2. **What does ExecuteNonQuery return for CREATE TABLE?**
   - Returns -1 (statements that don't affect rows)

3. **Why is "using" important with SqlConnection?**
   - Ensures connection is closed even if exception occurs
   - Returns connection to pool immediately

---

## 🔗 Next Topic
Next: [26_SqlDataReader.md](./26_SqlDataReader.md) - SqlDataReader Details
