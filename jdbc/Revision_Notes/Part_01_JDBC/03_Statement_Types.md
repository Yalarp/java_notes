# Statement Types in JDBC

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Statement Interface](#statement-interface)
3. [PreparedStatement Interface](#preparedstatement-interface)
4. [CallableStatement Interface](#callablestatement-interface)
5. [Comparison Table](#comparison-table)
6. [Code Examples](#code-examples)
7. [Execution Flow](#execution-flow)
8. [Key Takeaways](#key-takeaways)
9. [Common Mistakes](#common-mistakes)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

JDBC provides **three interfaces** for executing SQL commands:

| Interface | Purpose | Use Case |
|-----------|---------|----------|
| `Statement` | Execute static SQL queries | Simple, one-time queries |
| `PreparedStatement` | Execute parameterized, precompiled queries | Repeated queries, user input |
| `CallableStatement` | Call stored procedures | Database procedures/functions |

All three extend from `Statement`:
```
Statement (interface)
    ├── PreparedStatement (interface)
    │       └── CallableStatement (interface)
```

---

## 📖 Statement Interface

### What is Statement?

Statement is the **simplest** interface for executing SQL queries. Each time you execute a query, the database must:
1. Parse the SQL
2. Optimize it
3. Compile it
4. Execute it

### Creating Statement

```java
Statement st = con.createStatement();
```

### Executing Queries

| Method | Use For | Returns |
|--------|---------|---------|
| `executeQuery(sql)` | SELECT queries | ResultSet |
| `executeUpdate(sql)` | INSERT, UPDATE, DELETE, DDL | int (rows affected) |
| `execute(sql)` | Any SQL (when type unknown) | boolean |

### Code Example: Statement

```java
import java.sql.*;

public class StatementDemo {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(url, "root", "root")) {
            // Create Statement
            Statement st = con.createStatement();
            
            // SELECT query - returns ResultSet
            ResultSet rs = st.executeQuery("select * from dept");
            while (rs.next()) {
                System.out.println(rs.getInt("deptno") + " " + rs.getString("dname"));
            }
            
            // UPDATE query - returns affected rows count
            int rows = st.executeUpdate("update dept set loc='bombay'");
            System.out.println(rows + " rows updated");
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

### When to Use Statement

✅ Use Statement when:
- Query is executed **only once**
- No user input in query
- Simple, static SQL

❌ Avoid Statement when:
- Query has user input (SQL injection risk!)
- Same query executed multiple times (performance issue)

---

## 📖 PreparedStatement Interface

### What is PreparedStatement?

PreparedStatement is a **precompiled** SQL statement with **placeholders** for parameters. It provides:
1. **Better performance** - Query compiled once, executed many times
2. **Security** - Prevents SQL injection attacks
3. **Convenience** - Easy parameter handling

### How PreparedStatement Works

**With Statement (inefficient):**
```
Execute query 1: Parse → Optimize → Compile → Execute
Execute query 2: Parse → Optimize → Compile → Execute
Execute query 3: Parse → Optimize → Compile → Execute
```

**With PreparedStatement (efficient):**
```
Create PreparedStatement: Parse → Optimize → Compile (once)
Execute query 1: Execute only
Execute query 2: Execute only
Execute query 3: Execute only
```

### Creating PreparedStatement

```java
// Query with ? placeholders
PreparedStatement pst = con.prepareStatement("SELECT * FROM dept WHERE deptno = ?");

// Set parameter value (index starts from 1)
pst.setInt(1, 10);

// Execute
ResultSet rs = pst.executeQuery();
```

### Syntax Comparison

```java
// Statement - query in execute method
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("select * from dept");

// PreparedStatement - query in prepare method, execute is empty
PreparedStatement pst = con.prepareStatement("select * from dept");
ResultSet rs = pst.executeQuery();  // No argument here!
```

### Parameter Setter Methods

| Method | For Data Type |
|--------|---------------|
| `setInt(index, value)` | int, INTEGER |
| `setString(index, value)` | String, VARCHAR |
| `setDouble(index, value)` | double, DOUBLE |
| `setDate(index, value)` | java.sql.Date |
| `setTimestamp(index, value)` | TIMESTAMP |
| `setNull(index, type)` | NULL values |

### Code Example: PreparedStatement with Parameters

```java
import java.sql.*;

public class PreparedStatementDemo {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(url, "root", "root")) {
            
            // Query with TWO placeholders
            String sql = "UPDATE dept SET loc = ? WHERE deptno = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            
            // Set parameters (index 1 = first ?, index 2 = second ?)
            pst.setString(1, "bangalore");  // Replace 1st ? with "bangalore"
            pst.setInt(2, 3);               // Replace 2nd ? with 3
            
            // Execute update
            int rowsAffected = pst.executeUpdate();
            System.out.println(rowsAffected + " rows updated");
            
            // Reuse with different values
            pst.setString(1, "delhi");
            pst.setInt(2, 4);
            pst.executeUpdate();  // No recompilation needed!
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `"UPDATE dept SET loc = ? WHERE deptno = ?"` | SQL with 2 placeholders |
| 9 | `con.prepareStatement(sql)` | Compiles query ONCE |
| 12 | `pst.setString(1, "bangalore")` | 1st ? → "bangalore" |
| 13 | `pst.setInt(2, 3)` | 2nd ? → 3 |
| 16 | `pst.executeUpdate()` | Execute (no SQL argument) |
| 19-20 | Set + Execute again | Reuse without recompiling |

---

## 📖 CallableStatement Interface

### What is CallableStatement?

CallableStatement is used to **call stored procedures and functions** in the database.

### Stored Procedure Example (MySQL)

```sql
-- Create a stored procedure
DELIMITER //
CREATE PROCEDURE mypro1(IN dept_id INT, OUT dept_name VARCHAR(30))
BEGIN
    SELECT dname INTO dept_name FROM dept WHERE deptno = dept_id;
END //
DELIMITER ;
```

### Creating CallableStatement

```java
// Syntax: { call procedure_name(parameters) }
CallableStatement cst = con.prepareCall("{ call mypro1(?, ?) }");
```

### Parameter Types

| Type | Description | How to Set |
|------|-------------|------------|
| **IN** | Input parameter | `setXxx(index, value)` |
| **OUT** | Output parameter | `registerOutParameter(index, type)` |
| **INOUT** | Both input and output | Both methods |

### Code Example: CallableStatement

```java
import java.sql.*;

public class CallableStatementDemo {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(url, "root", "root")) {
            
            // Prepare callable statement
            CallableStatement cst = con.prepareCall("{ call mypro1(?, ?) }");
            
            // Set IN parameter (1st argument is input)
            cst.setInt(1, 3);  // Pass dept_id = 3
            
            // Register OUT parameter (2nd argument is output)
            cst.registerOutParameter(2, Types.VARCHAR);
            
            // Execute the procedure
            cst.execute();
            
            // Get the OUT parameter value
            String deptName = cst.getString(2);
            System.out.println("Department name: " + deptName);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 10 | `con.prepareCall("{ call mypro1(?, ?) }")` | Prepare procedure call with 2 parameters |
| 13 | `cst.setInt(1, 3)` | Set input: 1st ? = 3 (dept_id) |
| 16 | `cst.registerOutParameter(2, Types.VARCHAR)` | Register 2nd ? as VARCHAR output |
| 19 | `cst.execute()` | Execute the stored procedure |
| 22 | `cst.getString(2)` | Retrieve output from 2nd parameter |

---

## 📊 Comparison Table

| Feature | Statement | PreparedStatement | CallableStatement |
|---------|-----------|-------------------|-------------------|
| **SQL Type** | Static | Parameterized | Stored Procedures |
| **Precompilation** | No | Yes | Yes |
| **Placeholders** | No | Yes (?) | Yes (?) |
| **Performance** | Slow (recompiles) | Fast (cached) | Fast (cached) |
| **SQL Injection** | Vulnerable | Protected | Protected |
| **Reusability** | Low | High | High |
| **Creation Method** | `createStatement()` | `prepareStatement(sql)` | `prepareCall(sql)` |
| **Execute Method** | `executeQuery(sql)` | `executeQuery()` | `execute()` |

---

## 🔄 Execution Flow

### Statement vs PreparedStatement

```
┌─────────────────────────────────────────────────────────────────┐
│                        STATEMENT                                 │
│                                                                  │
│  Query 1: "SELECT * FROM dept"                                  │
│      → Parse → Optimize → Compile → Execute                     │
│                                                                  │
│  Query 2: "SELECT * FROM dept"                                  │
│      → Parse → Optimize → Compile → Execute                     │
│      (Same query parsed again!)                                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                   PREPARED STATEMENT                             │
│                                                                  │
│  Create: prepareStatement("SELECT * FROM dept WHERE id = ?")    │
│      → Parse → Optimize → Compile (ONCE)                        │
│                                                                  │
│  Execute 1: setInt(1, 10) → executeQuery()                      │
│      → Execute only (plan reused)                               │
│                                                                  │
│  Execute 2: setInt(1, 20) → executeQuery()                      │
│      → Execute only (plan reused)                               │
└─────────────────────────────────────────────────────────────────┘
```

---

## ✅ Key Takeaways

1. **Use PreparedStatement by default** - safer and faster
2. **Statement is ONLY for one-time static queries** without user input
3. **PreparedStatement placeholders (?)** start at index 1, not 0
4. **CallableStatement** is only for stored procedures
5. **Query goes in prepareStatement()**, not in executeQuery()
6. **Precompilation** = Parse + Optimize + Compile once, execute many times

---

## ⚠️ Common Mistakes

### 1. Mixing Up Syntax

```java
// ❌ WRONG - Query in both places
PreparedStatement pst = con.prepareStatement("select * from dept");
ResultSet rs = pst.executeQuery("select * from dept");  // ERROR or ignored

// ✅ CORRECT
PreparedStatement pst = con.prepareStatement("select * from dept");
ResultSet rs = pst.executeQuery();  // No argument
```

### 2. Starting Index at 0

```java
// ❌ WRONG - Index starts at 1, not 0
pst.setInt(0, 10);  // SQLException!

// ✅ CORRECT
pst.setInt(1, 10);  // First parameter
```

### 3. Forgetting to Register OUT Parameter

```java
// ❌ WRONG - OUT parameter not registered
CallableStatement cst = con.prepareCall("{ call mypro(?, ?) }");
cst.setInt(1, 5);
cst.execute();
String result = cst.getString(2);  // Error or null!

// ✅ CORRECT
cst.registerOutParameter(2, Types.VARCHAR);  // Must register!
cst.execute();
String result = cst.getString(2);
```

---

## 🎤 Interview Questions

**Q1: What is the difference between Statement and PreparedStatement?**
> **A:**
> - **Statement**: Query is compiled every time it's executed. Vulnerable to SQL injection.
> - **PreparedStatement**: Query is precompiled once and cached. Uses placeholders (?) for parameters. Prevents SQL injection. Better performance for repeated queries.

**Q2: Why is PreparedStatement faster than Statement?**
> **A:** With Statement, the database parses, optimizes, and compiles the query every execution. With PreparedStatement, this happens only once during `prepareStatement()`. Subsequent executions reuse the cached execution plan, saving significant processing time.

**Q3: How does PreparedStatement prevent SQL injection?**
> **A:** PreparedStatement treats parameter values as **data**, never as SQL code. The query structure is fixed during compilation. When you set parameters with `setString()` or `setInt()`, they're inserted as literal values, not interpreted as SQL. Special characters are automatically escaped.

**Q4: What is CallableStatement used for?**
> **A:** CallableStatement is used to execute stored procedures and functions in the database. It supports IN parameters (input), OUT parameters (output), and INOUT parameters (both).

**Q5: Explain the syntax `{ call procedure_name(?) }`.**
> **A:** This is the **JDBC escape syntax** for calling stored procedures:
> - `{ }` - JDBC escape sequence markers
> - `call` - keyword to invoke procedure
> - `procedure_name` - name of the stored procedure
> - `(?)` - placeholders for parameters

**Q6: Why do PreparedStatement parameters start at index 1?**
> **A:** This follows the JDBC specification and SQL standard, where column indices are 1-based. It also aligns with how ResultSet column access works (`rs.getInt(1)` for first column).
