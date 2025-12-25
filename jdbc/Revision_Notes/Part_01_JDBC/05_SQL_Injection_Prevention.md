# SQL Injection Prevention

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is SQL Injection](#what-is-sql-injection)
3. [How SQL Injection Works](#how-sql-injection-works)
4. [Vulnerable Code Example](#vulnerable-code-example)
5. [Prevention with PreparedStatement](#prevention-with-preparedstatement)
6. [Common Attack Patterns](#common-attack-patterns)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**SQL Injection (SQLI)** is one of the most dangerous web application vulnerabilities. It allows attackers to manipulate database queries by injecting malicious SQL code through user input fields.

> **Definition**: SQL Injection means passing special symbols (like `--` or `'`) to SQL queries along with input values, changing the behavior of the query and the underlying application.

---

## 📖 What is SQL Injection

### The Attack Vector

When user input is directly concatenated into SQL queries, attackers can:
- **Bypass authentication** (login without password)
- **Access unauthorized data** (view other users' data)
- **Modify or delete data** (DROP TABLE, DELETE)
- **Execute admin operations** (create accounts)

### SQL Comment Syntax

In SQL, `--` is a **comment marker**:
```sql
SELECT * FROM users WHERE id = 5  -- everything after this is ignored
```

Attackers exploit this to **comment out** the rest of a query.

---

## ⚙️ How SQL Injection Works

### Vulnerable Login Query

```java
// User inputs: uname = "admin", password = "123"
String query = "SELECT count(*) FROM myaccount WHERE uname='" + uname + "' AND password='" + password + "'";
```

**Resulting Query:**
```sql
SELECT count(*) FROM myaccount WHERE uname='admin' AND password='123'
```
This works correctly ✅

### Attack Scenario

**Malicious Input:**
- Username: `admin'--`
- Password: `anything`

**Resulting Query:**
```sql
SELECT count(*) FROM myaccount WHERE uname='admin'--' AND password='anything'
                                            ↑
                               Everything after -- is IGNORED!
```

**Actual Query Executed:**
```sql
SELECT count(*) FROM myaccount WHERE uname='admin'
```

Password check is completely **bypassed**! ❌

---

## 💻 Vulnerable Code Example

### App1.txt (Vulnerable to SQL Injection)

```java
import java.sql.*;
import java.util.*;

public class App1 {
    public static void main(String args[]) {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            Statement st = con.createStatement();
            
            // Get user input
            System.out.println("Enter username and password:");
            Scanner sc = new Scanner(System.in);
            String uname = sc.next();
            String password = sc.next();
            
            // ❌ VULNERABLE: Direct string concatenation
            ResultSet rs = st.executeQuery(
                "SELECT count(*) FROM myaccount WHERE uname='" + uname + 
                "' AND password='" + password + "'"
            );
            
            rs.next();
            int count = rs.getInt(1);
            System.out.println("Records matching: " + count);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### What's Wrong

| Line | Problem |
|------|---------|
| 17-19 | User input (`uname`, `password`) is directly concatenated |
| 17-19 | No validation or sanitization of input |
| 17-19 | Attacker can inject `'` or `--` to manipulate query |

---

## 🛡️ Prevention with PreparedStatement

### Secure Code

```java
import java.sql.*;
import java.util.*;

public class SecureLogin {
    public static void main(String args[]) {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            
            // Get user input
            Scanner sc = new Scanner(System.in);
            System.out.println("Enter username and password:");
            String uname = sc.next();
            String password = sc.next();
            
            // ✅ SECURE: Use PreparedStatement with placeholders
            String sql = "SELECT count(*) FROM myaccount WHERE uname = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            
            // Set parameters - automatically escaped
            pst.setString(1, uname);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            
            rs.next();
            int count = rs.getInt(1);
            System.out.println("Records matching: " + count);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Why PreparedStatement Prevents Injection

With malicious input `admin'--`:

**Statement (Vulnerable):**
```sql
SELECT count(*) FROM myaccount WHERE uname='admin'--' AND password='x'
-- Becomes: SELECT count(*) FROM myaccount WHERE uname='admin'
```

**PreparedStatement (Secure):**
```sql
SELECT count(*) FROM myaccount WHERE uname = ? AND password = ?
-- Parameter 1 is set to: "admin'--" (treated as literal string)
-- Actual executed query:
SELECT count(*) FROM myaccount WHERE uname = 'admin''--' AND password = 'x'
--                                          ↑↑
--                              Single quote is ESCAPED to ''
```

The `'` in the input is **escaped** to `''` and treated as data, not SQL code!

---

## 🔥 Common Attack Patterns

### 1. Comment-based Bypass
```
Username: admin'--
Password: anything

Result: Password check is commented out
```

### 2. Always True Condition
```
Username: ' OR '1'='1
Password: ' OR '1'='1

Query becomes:
SELECT * FROM users WHERE uname='' OR '1'='1' AND password='' OR '1'='1'
-- '1'='1' is always TRUE, returns all users!
```

### 3. UNION-based Attack
```
Username: ' UNION SELECT username, password FROM admin_users--

Result: Returns data from admin_users table
```

### 4. DROP TABLE Attack
```
Username: '; DROP TABLE users;--

Result: Deletes the entire users table!
```

### 5. Time-based Blind Injection
```
Username: admin' AND SLEEP(5)--

Result: If response takes 5 seconds, injection is working
```

---

## ✅ Key Takeaways

1. **NEVER concatenate user input** into SQL queries
2. **ALWAYS use PreparedStatement** for any query with user input
3. PreparedStatement **treats input as data**, never as SQL code
4. `--` in SQL is a comment that ignores rest of query
5. `'` is the most common injection character
6. Prepared statements **escape** special characters automatically
7. Additional defense: Input validation, least privilege, WAF

---

## 🛠️ Defense Strategies

| Strategy | Description |
|----------|-------------|
| **PreparedStatement** | Primary defense - parameterized queries |
| **Input Validation** | Whitelist allowed characters |
| **Escape Special Characters** | Backup when PreparedStatement not possible |
| **Least Privilege** | Database user with minimal permissions |
| **Web Application Firewall** | Block known attack patterns |
| **Error Handling** | Don't expose SQL errors to users |

---

## 🎤 Interview Questions

**Q1: What is SQL Injection and how does it work?**
> **A:** SQL Injection is an attack where malicious SQL code is inserted into user input fields that are concatenated into SQL queries. The attacker uses special characters like `'` and `--` to manipulate the query structure, bypassing authentication or accessing unauthorized data.

**Q2: How does PreparedStatement prevent SQL Injection?**
> **A:** PreparedStatement uses parameterized queries where the SQL structure is fixed at compile time. User input is added via `setXxx()` methods and is treated as **data**, not SQL code. Special characters are automatically escaped, preventing them from altering the query logic.

**Q3: What does `--` do in an SQL injection attack?**
> **A:** `--` is the SQL comment marker. Everything after `--` in a query is ignored. Attackers use it to comment out the rest of a query, for example, commenting out the password check in a login query.

**Q4: Can SQL Injection occur even with input validation?**
> **A:** Yes, input validation alone is not sufficient. Attackers constantly find new ways to bypass filters. **PreparedStatement is the only reliable defense** because it fundamentally separates code from data.

**Q5: Write code that is vulnerable to SQL Injection and then fix it.**
> **A:**
> ```java
> // ❌ VULNERABLE
> String query = "SELECT * FROM users WHERE name='" + userInput + "'";
> Statement st = con.createStatement();
> ResultSet rs = st.executeQuery(query);
> 
> // ✅ FIXED
> String query = "SELECT * FROM users WHERE name = ?";
> PreparedStatement pst = con.prepareStatement(query);
> pst.setString(1, userInput);
> ResultSet rs = pst.executeQuery();
> ```
