# Servlet Hierarchy

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Servlet Interface](#servlet-interface)
3. [GenericServlet Class](#genericservlet-class)
4. [HttpServlet Class](#httpservlet-class)
5. [Class Hierarchy](#class-hierarchy)
6. [Code Example](#code-example)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

The Servlet API provides a hierarchy of interfaces and classes designed for handling different types of requests. Understanding this hierarchy is essential for writing effective servlets.

**Package**: `jakarta.servlet` (formerly `javax.servlet`)

---

## 📖 Servlet Interface

### Purpose

`Servlet` is the **root interface** that defines the contract for all servlets. It declares the core lifecycle methods that every servlet must implement.

### Methods

```java
public interface Servlet {
    void init(ServletConfig config) throws ServletException;
    void service(ServletRequest req, ServletResponse res) throws ServletException, IOException;
    void destroy();
    ServletConfig getServletConfig();
    String getServletInfo();
}
```

| Method | Purpose |
|--------|---------|
| `init()` | Called once when servlet is first loaded |
| `service()` | Called for each request |
| `destroy()` | Called when servlet is removed |
| `getServletConfig()` | Returns configuration |
| `getServletInfo()` | Returns servlet info |

---

## 📖 GenericServlet Class

### Purpose

`GenericServlet` is an **abstract class** that:
- Implements `Servlet` interface
- Provides default implementations for most methods
- Is **protocol-independent** (can handle any type of request)

### Key Features

```java
public abstract class GenericServlet implements Servlet, ServletConfig, Serializable {
    // Default implementation of init()
    public void init(ServletConfig config) throws ServletException { ... }
    
    // Convenience method
    public void init() throws ServletException { }
    
    // Still abstract - must override
    public abstract void service(ServletRequest req, ServletResponse res);
    
    // Default implementation
    public void destroy() { }
}
```

### Why "Generic"?

GenericServlet was designed to handle **any protocol**:
- HTTP
- FTP
- SMTP
- Custom protocols

However, since HTTP dominates web traffic, HttpServlet is more commonly used.

---

## 📖 HttpServlet Class

### Purpose

`HttpServlet` is an **abstract class** extending GenericServlet that:
- Is specifically designed for **HTTP protocol**
- Provides `doGet()`, `doPost()`, `doPut()`, `doDelete()` methods
- Handles HTTP-specific features (headers, methods, status codes)

### Key Features

```java
public abstract class HttpServlet extends GenericServlet {
    
    // HTTP-specific service method
    protected void service(HttpServletRequest req, HttpServletResponse res) {
        String method = req.getMethod();
        if (method.equals("GET")) {
            doGet(req, res);
        } else if (method.equals("POST")) {
            doPost(req, res);
        }
        // ... other HTTP methods
    }
    
    // Override these in your servlet
    protected void doGet(HttpServletRequest req, HttpServletResponse res) { ... }
    protected void doPost(HttpServletRequest req, HttpServletResponse res) { ... }
    protected void doPut(HttpServletRequest req, HttpServletResponse res) { ... }
    protected void doDelete(HttpServletRequest req, HttpServletResponse res) { ... }
}
```

### HTTP Methods

| Method | When Called | Purpose |
|--------|-------------|---------|
| `doGet()` | GET requests | Retrieve data |
| `doPost()` | POST requests | Submit data |
| `doPut()` | PUT requests | Update resource |
| `doDelete()` | DELETE requests | Remove resource |
| `doHead()` | HEAD requests | Get headers only |
| `doOptions()` | OPTIONS requests | Get supported methods |

---

## 🏗️ Class Hierarchy

```
                    «interface»
                      Servlet
                         │
                         │ implements
                         ▼
                  GenericServlet
                  (abstract class)
                  - protocol independent
                  - implements most methods
                         │
                         │ extends
                         ▼
                   HttpServlet
                  (abstract class)
                  - HTTP specific
                  - doGet, doPost, etc.
                         │
                         │ extends
                         ▼
                   YourServlet
                  (concrete class)
                  - Your implementation
```

### Why This Design?

| Class | Responsibility |
|-------|---------------|
| **Servlet** | Contract - what any servlet must do |
| **GenericServlet** | Default implementations, protocol-independent |
| **HttpServlet** | HTTP-specific behavior, method routing |
| **Your Servlet** | Business logic only |

This separation follows the **Template Method** design pattern - the framework handles the boilerplate, you focus on business logic.

---

## 💻 Code Example

### Creating Your Servlet

```java
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/FirstServ")
public class FirstServ extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("<h1>Welcome to Servlet World</h1>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle POST requests
        doGet(request, response);  // Often delegates to doGet
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 1-7 | `import ...` | Import servlet packages |
| 9 | `@WebServlet("/FirstServ")` | Map servlet to URL `/FirstServ` |
| 10 | `extends HttpServlet` | Inherit HTTP handling capabilities |
| 12 | `serialVersionUID` | Required for serialization |
| 15-20 | `doGet(...)` | Handle GET requests |
| 17 | `response.setContentType("text/html")` | Set response MIME type |
| 18 | `response.getWriter()` | Get output stream for text |

---

## ✅ Key Takeaways

1. **Servlet** is the core interface (contract)
2. **GenericServlet** is protocol-independent (rarely used directly)
3. **HttpServlet** is for HTTP (what you actually extend)
4. **Your servlets extend HttpServlet**
5. Override **doGet()** for GET requests, **doPost()** for POST
6. `service()` automatically routes to appropriate doXxx() method
7. HttpServlet is **abstract** to force you to override at least one method

---

## 🎤 Interview Questions

**Q1: What is the servlet class hierarchy?**
> **A:** Servlet (interface) → GenericServlet (abstract) → HttpServlet (abstract) → YourServlet. Servlet defines the contract, GenericServlet provides default implementations, HttpServlet adds HTTP-specific methods, and your servlet implements business logic.

**Q2: Why is GenericServlet protocol-independent?**
> **A:** GenericServlet was designed to handle any type of request (HTTP, FTP, SMTP, etc.). It uses generic `ServletRequest` and `ServletResponse` interfaces. However, since HTTP dominates, HttpServlet is more commonly used.

**Q3: Why do we extend HttpServlet instead of implementing Servlet?**
> **A:** Implementing Servlet directly requires implementing all 5 methods. HttpServlet already handles lifecycle methods, HTTP method routing, and provides convenient doXxx() methods. You only override what you need (usually doGet/doPost).

**Q4: How does the service() method work in HttpServlet?**
> **A:** The `service()` method in HttpServlet checks the HTTP method (GET, POST, PUT, etc.) and routes to the corresponding doXxx() method. You typically don't override `service()` - just override `doGet()` or `doPost()`.

**Q5: Can you use GenericServlet instead of HttpServlet?**
> **A:** Yes, but it's rare. You'd need to handle request type checking yourself and lose HTTP-specific conveniences. GenericServlet is useful only for non-HTTP protocols.
