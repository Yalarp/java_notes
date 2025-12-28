# SQL Injection Prevention in C#

## 📚 Introduction

SQL Injection is one of the most critical security vulnerabilities in web applications. It occurs when attackers can insert malicious SQL code through user input, potentially accessing, modifying, or deleting data. Parameterized queries are the primary defense.

---

## 🎯 Learning Objectives

- Understand how SQL Injection attacks work
- Learn to use parameterized queries for protection
- Implement stored procedures for additional security
- Know best practices for secure database access

---

## 📖 Theory: How SQL Injection Works

```
┌────────────────────────────────────────────────────────────────┐
│                    SQL Injection Attack                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  User Input: "D'; DELETE FROM Product; SELECT * FROM Product   │
│              WHERE Name LIKE 'd"                               │
│                                                                 │
│  Vulnerable Code:                                              │
│  ──────────────                                                │
│  string sql = "SELECT * FROM Products WHERE Name LIKE '"       │
│               + pname + "%'";                                   │
│                                                                 │
│  Resulting SQL (3 statements!):                                │
│  ────────────────────────────────                              │
│  SELECT * FROM Products WHERE Name LIKE 'D';                   │
│  DELETE FROM Product;  ← ⚠️ DESTRUCTIVE!                       │
│  SELECT * FROM Product WHERE Name LIKE 'd%'                    │
│                                                                 │
│  Impact:                                                        │
│  • Data theft                                                   │
│  • Data deletion                                                │
│  • Authentication bypass                                        │
│  • Full database compromise                                     │
└────────────────────────────────────────────────────────────────┘
```

---

## ❌ Code Example 1: VULNERABLE Code

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
    
    // ❌ VULNERABLE: String concatenation with user input
    public void DisplayProducts_VULNERABLE(string pname)
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // ⚠️ DANGEROUS: User input directly concatenated into SQL
            SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Products WHERE Name LIKE '" + pname + "%'", 
                con);
            
            con.Open();
            SqlDataReader rd = cmd.ExecuteReader();
            
            while (rd.Read())
            {
                Console.WriteLine("{0} {1} {2}", 
                    rd["Id"], rd["Name"], rd["Price"]);
            }
        }
    }
}
```

### Attack Demonstration:

```
Normal Input: "iPhone"
Resulting SQL: SELECT * FROM Products WHERE Name LIKE 'iPhone%'
→ Works correctly, shows iPhones

Attack Input: "D'; DELETE FROM Product; --"
Resulting SQL: 
  SELECT * FROM Products WHERE Name LIKE 'D';
  DELETE FROM Product;
  --'  (comment ignores rest)
→ ⚠️ ALL PRODUCTS DELETED!

Authentication Bypass Input: "' OR '1'='1"
SELECT * FROM Users WHERE Username='' OR '1'='1' AND Password=''
→ ⚠️ Returns ALL users, bypasses login!
```

---

## ✅ Code Example 2: SAFE Parameterized Query

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
    
    // ✅ SAFE: Using parameterized query
    public void DisplayProducts_SAFE(string pname)
    {
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            // Use @parameter placeholder in SQL
            SqlCommand cmd = new SqlCommand(
                "SELECT * FROM Employees WHERE Name LIKE @ProductName", 
                con);
            
            // Add parameter - value is treated as DATA, not SQL code
            cmd.Parameters.AddWithValue("@ProductName", pname + "%");
            
            con.Open();
            SqlDataReader rd = cmd.ExecuteReader();
            
            while (rd.Read())
            {
                Console.WriteLine("{0} {1} {2}", 
                    rd["Id"], rd["Name"], rd["Salary"]);
            }
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 21 | `@ProductName` | Parameter placeholder in SQL |
| 25 | `Parameters.AddWithValue` | Binds value to parameter |
| 25 | `pname + "%"` | Entire value treated as string literal |

### How Parameters Protect:

```
┌────────────────────────────────────────────────────────────────┐
│              How Parameterized Queries Protect                  │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Attack Input: "D'; DELETE FROM Product; --"                   │
│                                                                 │
│  With String Concatenation (VULNERABLE):                       │
│  ─────────────────────────────────────────                     │
│  SQL: "...LIKE 'D'; DELETE FROM Product; --%'"                 │
│  → Executed as 3 separate SQL statements!                      │
│                                                                 │
│  With Parameters (SAFE):                                       │
│  ──────────────────────                                        │
│  SQL: "...LIKE @ProductName"                                   │
│  Parameter Value: "D'; DELETE FROM Product; --"                │
│  → Entire attack string is searched for AS A LITERAL STRING   │
│  → Searches for product named "D'; DELETE FROM Product; --"   │
│  → Finds nothing (safe!)                                       │
│                                                                 │
│  Key: Parameters are NEVER interpreted as SQL code             │
│       They are always treated as literal data values           │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example 3: Using SqlParameter Explicitly

```csharp
public void InsertProduct_SAFE(string name, decimal price, int quantity)
{
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        SqlCommand cmd = new SqlCommand(
            "INSERT INTO Products (Name, Price, Qty) VALUES (@Name, @Price, @Qty)", 
            con);
        
        // Method 1: AddWithValue (convenient but less precise)
        cmd.Parameters.AddWithValue("@Name", name);
        
        // Method 2: SqlParameter with explicit type (recommended)
        SqlParameter priceParam = new SqlParameter("@Price", SqlDbType.Decimal);
        priceParam.Value = price;
        priceParam.Precision = 18;
        priceParam.Scale = 2;
        cmd.Parameters.Add(priceParam);
        
        // Method 3: Inline creation
        cmd.Parameters.Add(new SqlParameter("@Qty", SqlDbType.Int) { Value = quantity });
        
        con.Open();
        int rowsAffected = cmd.ExecuteNonQuery();
        
        Console.WriteLine($"Inserted {rowsAffected} row(s)");
    }
}
```

### Parameter Methods Comparison:

| Method | Pros | Cons |
|--------|------|------|
| `AddWithValue` | Simple, one line | Type inference may be wrong |
| `SqlParameter` | Explicit type control | More verbose |
| `Add(name, type)` | Clear, type-safe | Requires separate value assignment |

---

## 💻 Code Example 4: Stored Procedure (Additional Protection)

```csharp
// SQL Server Stored Procedure
/*
CREATE PROCEDURE spGetProductsByName
    @ProductName NVARCHAR(100)
AS
BEGIN
    SELECT Id, Name, Price, Qty 
    FROM Products 
    WHERE Name LIKE @ProductName + '%'
END
*/

public void DisplayProducts_StoredProcedure(string pname)
{
    using (SqlConnection con = new SqlConnection(_connectionString))
    {
        // Use stored procedure name instead of SQL
        SqlCommand cmd = new SqlCommand("spGetProductsByName", con);
        
        // IMPORTANT: Set CommandType to StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        
        // Add parameter
        cmd.Parameters.AddWithValue("@ProductName", pname);
        
        con.Open();
        SqlDataReader rd = cmd.ExecuteReader();
        
        while (rd.Read())
        {
            Console.WriteLine("{0} {1} {2:C} {3}", 
                rd["Id"], rd["Name"], rd["Price"], rd["Qty"]);
        }
    }
}
```

### Why Stored Procedures Help:

```
┌────────────────────────────────────────────────────────────────┐
│           Stored Procedure Security Benefits                    │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. SQL is precompiled on server                               │
│     → Attack strings cannot alter the SQL structure            │
│                                                                 │
│  2. Parameters are always treated as data                      │
│     → Same protection as parameterized queries                 │
│                                                                 │
│  3. Permissions can be granted on SP only                      │
│     → User doesn't need direct table access                    │
│                                                                 │
│  4. SQL logic hidden from client                               │
│     → Attackers can't see table structures                     │
│                                                                 │
│  5. Centralized security                                       │
│     → One place to validate and sanitize                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Best Practices Summary

| Practice | Description |
|----------|-------------|
| **Always use parameters** | Never concatenate user input into SQL |
| **Use stored procedures** | For additional layer of protection |
| **Validate input** | Check format, length, type before use |
| **Use least privilege** | Database user should have minimum permissions |
| **Handle errors properly** | Don't expose SQL errors to users |
| **Use ORM** | Entity Framework prevents SQL injection by default |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Never concatenate** - User input into SQL strings
2. **Always parameterize** - Use @parameters in queries
3. **Parameters = data** - Treated as values, not code
4. **Stored procedures** - Add extra security layer
5. **ORM protects** - EF Core uses parameters internally
6. **Validate everything** - Don't trust user input

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| String concatenation | SQL injection possible | Use parameters |
| Trusting client validation | Client-side can be bypassed | Validate on server |
| Exposing error details | Reveals database structure | Use generic error messages |
| Using sa account | Full database access | Use limited user account |

---

## 📝 Interview Questions

1. **What is SQL Injection?**
   - Attack where malicious SQL code is inserted through user input
   - Can read, modify, or delete data
   - Can bypass authentication

2. **How do parameterized queries prevent SQL Injection?**
   - Parameters are treated as literal data values
   - Never interpreted as SQL code
   - Database engine handles escaping

3. **What's the difference between AddWithValue and SqlParameter?**
   - AddWithValue: Infers type, convenient but can cause issues
   - SqlParameter: Explicit type, more control and precision

4. **Why use stored procedures?**
   - Precompiled SQL, parameters enforced
   - Can hide table structure
   - Centralized security logic

---

## 🔗 Next Topic
Next: [28_Stored_Procedures.md](./28_Stored_Procedures.md) - Stored Procedures in Detail
