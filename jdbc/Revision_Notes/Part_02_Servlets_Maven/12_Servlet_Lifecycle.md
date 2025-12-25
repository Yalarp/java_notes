# Servlet Lifecycle

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Lifecycle Methods](#lifecycle-methods)
3. [First Request vs Subsequent Requests](#first-request-vs-subsequent-requests)
4. [Container's Role](#containers-role)
5. [Code Example](#code-example)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

The **servlet lifecycle** is completely managed by the **web container** (like Tomcat). As a developer, you don't create or destroy servlets yourself - you just override the lifecycle methods.

**Key Insight**: Servlets are **NOT standalone applications**. They run **inside** a server, which is why there's no `main()` method.

---

## 📖 Lifecycle Methods

### Three Core Lifecycle Methods

| Method | Called | Times Called | Purpose |
|--------|--------|--------------|---------|
| `init()` | After instantiation | **Once** | Initialize resources |
| `service()` | For each request | **Many** | Handle requests |
| `destroy()` | Before removal | **Once** | Clean up resources |

### init() Method

```java
public void init(ServletConfig config) throws ServletException {
    // Called ONCE when servlet is first loaded
    // Use for:
    // - Creating database connections
    // - Loading configuration
    // - Looking up JNDI resources
    // - One-time expensive operations
}

// Convenience method (no-arg version)
public void init() throws ServletException {
    // Override this for simpler initialization
}
```

### service() Method

```java
public void service(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    // Called for EACH request
    // Routes to doGet(), doPost(), etc. based on HTTP method
    // Usually NOT overridden - let HttpServlet handle routing
}
```

### destroy() Method

```java
public void destroy() {
    // Called ONCE when servlet is being removed
    // Called when:
    // - Server shuts down
    // - Application is undeployed
    // - Container needs to reclaim memory
    // Use for:
    // - Closing database connections
    // - Releasing file handles
    // - Saving state
}
```

---

## 🔄 First Request vs Subsequent Requests

### First Request Execution Flow

```
1. Client sends request: http://localhost:8080/app/FirstServ
        ↓
2. Container opens web.xml (or reads annotations)
        ↓
3. Finds servlet class for URL pattern
        ↓
4. LOADS servlet class (FirstServ.class)
        ↓
5. INSTANTIATES servlet (using Reflection API, no-arg constructor)
        ↓
6. Calls init() method (ONCE)
        ↓
7. Retrieves thread from thread pool
        ↓
8. Creates HttpServletRequest and HttpServletResponse objects
        ↓
9. Calls service() → routes to doGet() or doPost()
        ↓
10. Response sent to client
```

### Subsequent Requests

```
1. Client sends another request
        ↓
2. Steps 1-6 SKIPPED (servlet already loaded and initialized)
        ↓
7. Retrieves thread from thread pool
        ↓
8. Creates new HttpServletRequest/Response objects
        ↓
9. Calls service() → routes to doGet() or doPost()
        ↓
10. Response sent to client
```

### Visual Diagram

```
                    First Request Only
                    ══════════════════
        ┌─────────────────────────────────────────────┐
        │  1. Load servlet class                       │
        │  2. Instantiate (using Reflection)           │
        │  3. Call init()                              │
        └────────────────────┬────────────────────────┘
                             │
                             ▼
                    Every Request
                    ═════════════
        ┌─────────────────────────────────────────────┐
        │  4. Get thread from pool                     │
        │  5. Create request/response objects          │
        │  6. Call service() → doGet()/doPost()        │
        │  7. Return thread to pool                    │
        └─────────────────────────────────────────────┘
                             
                    On Shutdown Only  
                    ════════════════
        ┌─────────────────────────────────────────────┐
        │  8. Call destroy()                           │
        │  9. Garbage collect servlet instance         │
        └─────────────────────────────────────────────┘
```

---

## 🏭 Container's Role

### What the Container (Tomcat) Does

| Step | Container Action |
|------|------------------|
| **Load** | Uses `Class.forName()` to load servlet class |
| **Instantiate** | Uses Reflection to call no-arg constructor |
| **Initialize** | Calls `init(ServletConfig)` |
| **Create Objects** | Creates request/response wrapper objects |
| **Thread Pool** | Manages thread allocation for requests |
| **Method Routing** | `service()` routes to `doGet`/`doPost` |
| **Cleanup** | Calls `destroy()` before removal |

### Why No main() Method?

- Servlets are **managed by the container**
- Container handles threading, lifecycle, resources
- Similar to why there's no `main()` in Android Activities

---

## 💻 Code Example

### Servlet with All Lifecycle Methods

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/LifecycleDemo")
public class LifecycleDemo extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Called ONCE when servlet is first loaded
    @Override
    public void init() throws ServletException {
        System.out.println("init() called - One time initialization");
        // Example: Open database connection
    }
    
    // Called for EACH request
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("doGet() called - Thread: " + Thread.currentThread().getName());
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("<h1>Servlet Lifecycle Demo</h1>");
        pw.println("<p>Check server console for lifecycle messages</p>");
    }
    
    // Called ONCE when servlet is being destroyed
    @Override
    public void destroy() {
        System.out.println("destroy() called - Cleanup resources");
        // Example: Close database connection
    }
}
```

### Console Output

```
# First request
init() called - One time initialization
doGet() called - Thread: http-nio-8080-exec-1

# Second request  
doGet() called - Thread: http-nio-8080-exec-2

# Third request
doGet() called - Thread: http-nio-8080-exec-3

# Server shutdown
destroy() called - Cleanup resources
```

**Notice**: `init()` called only once, `doGet()` called for each request with different threads.

---

## ✅ Key Takeaways

1. **Container manages lifecycle** - not you
2. **init()** called **once** at first load
3. **service()** called for **every request**
4. **destroy()** called **once** at shutdown/undeploy
5. First request = Load + Instantiate + init + service
6. Subsequent requests = Only service (reuse instance)
7. **One servlet instance**, **multiple threads**
8. No `main()` method - servlets run inside container

---

## 🎤 Interview Questions

**Q1: Explain the servlet lifecycle.**
> **A:** 
> 1. **Loading**: Container loads servlet class
> 2. **Instantiation**: Container creates instance via no-arg constructor
> 3. **Initialization**: `init()` called once
> 4. **Request Handling**: `service()` called for each request, routes to `doGet()`/`doPost()`
> 5. **Destruction**: `destroy()` called once during shutdown/undeploy

**Q2: How many times is init() called?**
> **A:** Just **once** - when the servlet is first loaded into the container. It's not called again for subsequent requests.

**Q3: Who creates the servlet instance?**
> **A:** The **web container** (e.g., Tomcat) creates the servlet instance using **Reflection API**. It calls the public no-arg constructor. That's why your servlet must have a public default constructor.

**Q4: What happens if init() throws an exception?**
> **A:** The servlet fails to initialize and is marked as unavailable. The container will return an error to clients. The `destroy()` method is NOT called because the servlet was never fully initialized.

**Q5: Why don't we override the service() method?**
> **A:** HttpServlet's `service()` method already handles routing based on HTTP method (GET→doGet, POST→doPost). Overriding it would lose this automatic routing. Just override `doGet()` or `doPost()` instead.

**Q6: Is servlet multi-threaded or single-threaded?**
> **A:** By default, servlets are **multi-threaded**. One servlet instance handles multiple requests via different threads. This is why you must be careful with instance variables (they're shared).
