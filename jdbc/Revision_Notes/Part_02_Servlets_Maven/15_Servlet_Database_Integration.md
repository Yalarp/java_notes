# Servlet Database Integration

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [JDBC Driver in Web Applications](#jdbc-driver-in-web-applications)
3. [Database Connection in Servlets](#database-connection-in-servlets)
4. [Code Example](#code-example)
5. [Best Practices](#best-practices)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Integrating JDBC with servlets allows web applications to store and retrieve data from databases. However, there are important differences between standalone Java apps and web apps regarding classpath and connection management.

---

## 📖 JDBC Driver in Web Applications

### Standalone vs Web Application

| Aspect | Standalone Application | Web Application |
|--------|----------------------|-----------------|
| **Driver Location** | System classpath | `WEB-INF/lib/` folder |
| **How to Add** | Add to CLASSPATH env variable | Copy JAR to lib folder |
| **Why Different** | JVM loads from classpath | Container has its own classloader |

### Key Point

> **Setting system CLASSPATH for JDBC driver does NOT work in web apps!**
> You MUST copy the driver JAR to `WEB-INF/lib/`

### Folder Structure

```
YourWebApp/
├── src/
├── WEB-INF/
│   ├── web.xml
│   ├── lib/
│   │   └── mysql-connector-java-8.0.17.jar   ← Driver JAR here!
│   └── classes/
│       └── com/example/PersonServ.class
└── person.html
```

---

## 📖 Database Connection in Servlets

### Where to Create Connection?

| Method | When to Create | Pros/Cons |
|--------|---------------|-----------|
| `init()` | Once at startup | Reuse connection, but single connection |
| `doGet()/doPost()` | Each request | Fresh conn, but slow |
| **Connection Pool** | Managed | Best approach (see later notes) |

### Pattern: Connection in init()

```java
public class PersonServ extends HttpServlet {
    private Connection con;  // Instance variable
    
    @Override
    public void init() {
        // Create connection ONCE
        con = DriverManager.getConnection(url, user, pass);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) {
        // REUSE connection
        PreparedStatement pst = con.prepareStatement("INSERT...");
        // ...
    }
    
    @Override
    public void destroy() {
        // Close connection when servlet destroyed
        con.close();
    }
}
```

---

## 💻 Code Example

### HTML Form (person.html)

```html
<html>
<body>
<form action="PersonServ" method="post">
    Enter name: <input type="text" name="name"><br><br>
    Enter age: <input type="text" name="age"><br><br>
    <input type="submit">
</form>
</body>
</html>
```

### PersonServ.java (Full Example)

```java
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/PersonServ")
public class PersonServ extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private Connection con = null;  // Instance variable for connection
    
    @Override
    public void init(ServletConfig config) {
        try {
            // Load driver (optional in JDBC 4.0+)
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create database connection
            String url = "jdbc:mysql://localhost:3306/mydb";
            con = DriverManager.getConnection(url, "root", "root");
            
        } catch(Exception ee) {
            ee.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get form parameters
        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age").trim());
        
        try {
            // Prepare and execute INSERT
            PreparedStatement pst = con.prepareStatement(
                "INSERT INTO person(name, age) VALUES(?, ?)"
            );
            pst.setString(1, name);
            pst.setInt(2, age);
            
            int k = pst.executeUpdate();
            
            // Send response
            PrintWriter pw = response.getWriter();
            if(k > 0) {
                pw.println("Record added to database");
            } else {
                pw.println("Record not added");
            }
            
        } catch(Exception ee) {
            ee.printStackTrace();
        }
    }
    
    @Override
    public void destroy() {
        try {
            if(con != null) con.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 17 | `private Connection con` | Instance variable shared across requests |
| 21 | `Class.forName(...)` | Load JDBC driver (optional in JDBC 4.0+) |
| 25 | `DriverManager.getConnection(...)` | Create connection in init() |
| 38-39 | `request.getParameter(...)` | Get form data from POST |
| 43-46 | `con.prepareStatement(...)` | Reuse the connection created in init() |
| 63-67 | `con.close()` | Close connection when servlet is destroyed |

---

## 🛡️ Best Practices

### 1. Never Hardcode Credentials

```java
// ❌ BAD
con = DriverManager.getConnection(url, "root", "password123");

// ✅ GOOD - Use properties file
ResourceBundle rb = ResourceBundle.getBundle("dbconfig");
String url = rb.getString("url");
String user = rb.getString("user");
String password = rb.getString("password");
con = DriverManager.getConnection(url, user, password);
```

### 2. Use Connection Pool in Production

Creating new connections is expensive. Use connection pooling (covered in later notes).

### 3. Handle Exceptions Properly

```java
try {
    // Database operations
} catch(SQLException e) {
    // Log error
    logger.error("Database error", e);
    // Return appropriate error response
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
}
```

### 4. Close Resources

Always close connections, statements, and result sets in finally blocks or use try-with-resources.

---

## ✅ Key Takeaways

1. **Copy driver JAR** to `WEB-INF/lib/` (classpath won't work)
2. **Create connection in init()** for simple cases
3. **Use connection pooling** in production
4. **Never hardcode** credentials
5. **Close resources** in destroy() method
6. Instance variables are **shared across requests**

---

## 🎤 Interview Questions

**Q1: Why doesn't setting CLASSPATH work for JDBC in web apps?**
> **A:** Web containers (like Tomcat) use their own classloader hierarchy. The system CLASSPATH is not part of the web app's classloader. JAR files must be in `WEB-INF/lib/` to be loaded by the container.

**Q2: Should you create a database connection in doPost()?**
> **A:** For simple cases, create it in `init()` and reuse. Creating in `doPost()` for EVERY request is slow. In production, use a **connection pool** which provides pre-created connections.

**Q3: What happens if you don't close the connection?**
> **A:** Connection leak. The connection remains open consuming database resources. After many requests, you may run out of database connections, causing application failure.

**Q4: How do you share a database connection across multiple requests?**
> **A:** Store the Connection as an instance variable of the servlet. Create it in `init()`, use it in `doGet()`/`doPost()`, close it in `destroy()`. Note: a single connection may not handle concurrent requests well - use connection pooling instead.
