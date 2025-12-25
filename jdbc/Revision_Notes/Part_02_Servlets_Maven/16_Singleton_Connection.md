# Singleton Connection Pattern

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [The Singleton Pattern](#the-singleton-pattern)
3. [Singleton for Database Connection](#singleton-for-database-connection)
4. [Code Example](#code-example)
5. [Using in Servlets](#using-in-servlets)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

The **Singleton Pattern** ensures that only **one instance** of a class exists. When applied to database connections, it prevents creating multiple connections when only one is needed.

---

## 📖 The Singleton Pattern

### Core Concept

- Only **one instance** of the class can exist
- Provides a **global point of access** to that instance
- Useful for shared resources (connections, configs, caches)

### Key Elements

1. **Private constructor** - prevents direct instantiation
2. **Static instance** - holds the single instance
3. **Static method** - returns the instance

---

## 📖 Singleton for Database Connection

### Why Use Singleton for Connections?

| Problem | Solution |
|---------|----------|
| Creating connections is expensive | Reuse single connection |
| Multiple connections waste resources | Only one connection |
| Connection management is complex | Centralized management |

### Limitations

> **Note**: Singleton connection works for simple cases but has problems with:
> - Multi-threaded access (synchronization needed)
> - High concurrency (use Connection Pool instead)

---

## 💻 Code Example

### SingletonCon.java

```java
package mypack;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ResourceBundle;

public class SingletonCon {
    
    // Static connection - shared across all callers
    private static Connection con;
    private static ResourceBundle rb;
    
    // Static block - runs once when class is loaded
    static {
        try {
            // Load properties file
            rb = ResourceBundle.getBundle("mypack.myproperty");
            
            // Load JDBC driver
            Class.forName(rb.getString("driver"));
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    // Private constructor - prevents instantiation
    private SingletonCon() { }
    
    // Static method to get connection
    public static Connection getCon() {
        try {
            // Read connection properties
            String url = rb.getString("url");
            String user = rb.getString("user");
            String password = rb.getString("password");
            
            // Create connection (or return existing)
            if (con == null || con.isClosed()) {
                con = DriverManager.getConnection(url, user, password);
            }
            
        } catch(Exception ee) {
            System.out.println(ee);
        }
        return con;
    }
}
```

### Properties File (myproperty.properties)

```properties
driver=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/mydb
user=root
password=Root
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 10 | `private static Connection con` | Single shared connection |
| 14-23 | `static { ... }` | Runs once when class loads |
| 17 | `ResourceBundle.getBundle(...)` | Load config from properties file |
| 20 | `Class.forName(...)` | Load JDBC driver |
| 27 | `private SingletonCon()` | Prevent direct instantiation |
| 30 | `public static Connection getCon()` | Only way to get connection |
| 38-40 | `if (con == null || con.isClosed())` | Create only if needed |

---

## 📖 Using in Servlets

### FirstServ.java

```java
import jakarta.servlet.ServletConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mypack.SingletonCon;
import java.io.*;
import java.sql.*;

@WebServlet("/firstserv")
public class FirstServ extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private Connection con = null;
    
    @Override
    public void init(ServletConfig config) {
        try {
            // Get singleton connection
            con = SingletonCon.getCon();
            
        } catch(Exception ee) {
            ee.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            response.setContentType("text/html");
            PrintWriter pw = response.getWriter();
            
            pw.println("Using Properties<br>");
            
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM dept");
            
            while(rs.next()) {
                pw.println(rs.getInt(1) + " ");
                pw.println(rs.getString(2) + " ");
                pw.println(rs.getString(3) + "<br>");
            }
            
        } catch(Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Flow

```
1. Servlet initializes
        ↓
2. Calls SingletonCon.getCon()
        ↓
3. Static block runs (if not already):
   - Loads properties
   - Loads JDBC driver
        ↓
4. getCon() creates connection (if null)
        ↓
5. Returns same connection for all requests
```

---

## ✅ Key Takeaways

1. **Singleton** = only one instance of a class
2. **Static block** runs once when class loads
3. **Private constructor** prevents direct instantiation
4. **Static method** provides access to the single instance
5. Use with **properties file** for external configuration
6. For **high concurrency**, use Connection Pool instead

---

## 🎤 Interview Questions

**Q1: What is the Singleton pattern?**
> **A:** Singleton ensures only one instance of a class exists and provides a global point of access to it. It uses a private constructor and a static method to control instance creation.

**Q2: Why use Singleton for database connections?**
> **A:** Creating database connections is expensive. Singleton allows reusing a single connection, reducing resource usage and connection overhead.

**Q3: What is the purpose of the static block?**
> **A:** The static block runs once when the class is first loaded. It's used for one-time initialization like loading the JDBC driver or configuration files.

**Q4: What are the limitations of Singleton connection?**
> **A:**
> - Not thread-safe by default (needs synchronization)
> - Single connection may bottleneck concurrent requests
> - Connection may become stale or closed
> For production, use **Connection Pooling** instead.
