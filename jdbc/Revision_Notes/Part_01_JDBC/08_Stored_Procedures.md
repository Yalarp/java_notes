# Stored Procedures with CallableStatement

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is a Stored Procedure](#what-is-a-stored-procedure)
3. [Creating Stored Procedures](#creating-stored-procedures)
4. [Calling from Java](#calling-from-java)
5. [Parameter Types](#parameter-types)
6. [Code Examples](#code-examples)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

A **Stored Procedure** is a precompiled SQL program stored in the database. It can:
- Accept input parameters
- Return output parameters
- Execute complex business logic
- Be called from Java using `CallableStatement`

---

## 📖 What is a Stored Procedure

### Why Use Stored Procedures?

| Advantage | Description |
|-----------|-------------|
| **Performance** | Precompiled and cached in database |
| **Security** | Can grant execute permission without table access |
| **Reusability** | Same procedure called by multiple applications |
| **Reduced Traffic** | Multiple operations in single call |
| **Maintainability** | Change logic in database, not in all apps |

### Procedure vs Function

| Stored Procedure | Function |
|------------------|----------|
| May or may not return value | Must return a value |
| Can have OUT parameters | Returns through RETURN |
| Called with CALL | Can be used in SELECT |

---

## 🔧 Creating Stored Procedures

### MySQL Syntax

```sql
DELIMITER //

CREATE PROCEDURE procedure_name(
    IN param1 INT,           -- Input parameter
    OUT param2 VARCHAR(50)   -- Output parameter
)
BEGIN
    -- SQL statements here
    SELECT column INTO param2 FROM table WHERE id = param1;
END //

DELIMITER ;
```

### Example: MySQL Procedure

```sql
DELIMITER //

CREATE PROCEDURE mypro1(
    IN dept_id INT,
    OUT dept_name VARCHAR(30)
)
BEGIN
    SELECT dname INTO dept_name 
    FROM dept 
    WHERE deptno = dept_id;
END //

DELIMITER ;
```

### Oracle Syntax

```sql
CREATE OR REPLACE PROCEDURE mypro(
    no IN NUMBER,
    name IN VARCHAR2,
    place IN VARCHAR2
)
IS
BEGIN
    INSERT INTO dept VALUES(no, name, place);
END;
/
```

---

## 📞 Calling from Java

### JDBC Escape Syntax

```java
// Syntax: { call procedure_name(parameters) }
CallableStatement cst = con.prepareCall("{ call mypro1(?, ?) }");
```

### Three Steps

```java
// 1. Prepare the call
CallableStatement cst = con.prepareCall("{ call procedure_name(?, ?) }");

// 2. Set IN parameters, Register OUT parameters
cst.setInt(1, inputValue);              // IN parameter
cst.registerOutParameter(2, Types.VARCHAR);  // OUT parameter

// 3. Execute and retrieve
cst.execute();
String result = cst.getString(2);        // Get OUT value
```

---

## 📋 Parameter Types

### IN Parameters
Input values passed TO the procedure.

```java
cst.setInt(1, 100);          // Pass int value
cst.setString(2, "Delhi");   // Pass String value
```

### OUT Parameters
Output values returned FROM the procedure.

```java
// Must register before execute
cst.registerOutParameter(3, Types.VARCHAR);
cst.execute();
String result = cst.getString(3);
```

### INOUT Parameters
Both input and output.

```java
cst.setInt(1, 100);                      // Set input value
cst.registerOutParameter(1, Types.INTEGER);  // Also register as output
cst.execute();
int result = cst.getInt(1);               // Get modified value
```

---

## 💻 Code Examples

### Example 1: Procedure with IN and OUT

**MySQL Procedure:**
```sql
DELIMITER //
CREATE PROCEDURE mypro1(IN dept_id INT, OUT dept_name VARCHAR(30))
BEGIN
    SELECT dname INTO dept_name FROM dept WHERE deptno = dept_id;
END //
DELIMITER ;
```

**Java Code (App6.java):**
```java
import java.sql.*;

public class App6 {
    public static void main(String args[]) {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            
            // Prepare callable statement
            CallableStatement cst = con.prepareCall("{ call mypro1(?, ?) }");
            
            // Set IN parameter (1st ?)
            cst.setInt(1, 3);  // dept_id = 3
            
            // Register OUT parameter (2nd ?)
            cst.registerOutParameter(2, Types.VARCHAR);
            
            // Execute procedure
            cst.execute();
            
            // Get OUT parameter value
            String name = cst.getString(2);
            System.out.println("Department name: " + name);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 9 | `con.prepareCall("{ call mypro1(?, ?) }")` | Prepare procedure call with 2 params |
| 12 | `cst.setInt(1, 3)` | 1st ? = 3 (IN: dept_id) |
| 15 | `cst.registerOutParameter(2, Types.VARCHAR)` | 2nd ? is VARCHAR output |
| 18 | `cst.execute()` | Run the procedure |
| 21 | `cst.getString(2)` | Get value from 2nd parameter |

### Example 2: Procedure with Only IN Parameters

**Oracle Procedure:**
```sql
CREATE OR REPLACE PROCEDURE mypro(
    no IN NUMBER,
    name IN VARCHAR2,
    place IN VARCHAR2
)
IS
BEGIN
    INSERT INTO dept VALUES(no, name, place);
END;
/
```

**Java Code:**
```java
import java.sql.*;

public class InsertProcedure {
    public static void main(String[] args) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe", "system", "oracle"
            );
            
            // Prepare call with 3 IN parameters
            CallableStatement cst = con.prepareCall("{ call mypro(?, ?, ?) }");
            
            // Set all IN parameters
            cst.setInt(1, 44);           // dept number
            cst.setString(2, "Account"); // dept name
            cst.setString(3, "Pune");    // location
            
            // Execute
            cst.execute();
            System.out.println("Insert successful via procedure!");
            
            con.close();
            
        } catch (Exception ee) {
            ee.printStackTrace();
        }
    }
}
```

---

## ✅ Key Takeaways

1. **Use CallableStatement** for stored procedures
2. **JDBC escape syntax**: `{ call procedure_name(?, ?) }`
3. **IN parameters**: Set with `setXxx()` methods
4. **OUT parameters**: Must `registerOutParameter()` before execute
5. **execute()** runs the procedure
6. **Get OUT values** with `getXxx()` after execute
7. Parameter **index starts at 1**

---

## 🎤 Interview Questions

**Q1: What is a stored procedure and why use it?**
> **A:** A stored procedure is a precompiled SQL program stored in the database. Benefits include: better performance (precompiled), enhanced security (no direct table access needed), reusability across applications, reduced network traffic, and centralized business logic.

**Q2: How do you call a stored procedure from Java?**
> **A:** Using CallableStatement:
> 1. `con.prepareCall("{ call proc_name(?, ?) }")`
> 2. Set IN params: `cst.setInt(1, value)`
> 3. Register OUT params: `cst.registerOutParameter(2, Types.VARCHAR)`
> 4. Execute: `cst.execute()`
> 5. Get OUT values: `cst.getString(2)`

**Q3: What is the difference between IN, OUT, and INOUT parameters?**
> **A:**
> - **IN**: Input only - passes values to procedure
> - **OUT**: Output only - returns values from procedure
> - **INOUT**: Both - passes value in, procedure can modify and return it

**Q4: Why must we call registerOutParameter() for OUT parameters?**
> **A:** JDBC needs to know the SQL type of the output parameter before execution so it can properly receive and convert the returned value. Without registration, JDBC doesn't know what type to expect.
