# HttpSession

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is HttpSession](#what-is-httpsession)
3. [How Sessions Work](#how-sessions-work)
4. [Session API](#session-api)
5. [Code Examples](#code-examples)
6. [Session Lifecycle](#session-lifecycle)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**HttpSession** is the most powerful session tracking mechanism. It stores data **server-side** and only uses a small session ID (via cookie or URL) to identify the user.

---

## 📖 What is HttpSession

### Definition

HttpSession is a server-side object that stores user-specific data across multiple requests. Each user gets their own session with a unique session ID.

### Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                          SERVER                                 │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │                   Session Store                          │  │
│  │                                                          │  │
│  │   Session ABC123        Session XYZ789                   │  │
│  │   ┌──────────────┐     ┌──────────────┐                 │  │
│  │   │ user: John   │     │ user: Jane   │                 │  │
│  │   │ cart: [...]  │     │ cart: [...]  │                 │  │
│  │   │ role: admin  │     │ role: user   │                 │  │
│  │   └──────────────┘     └──────────────┘                 │  │
│  └─────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
                         ▲                    ▲
                         │                    │
        Cookie: JSESSIONID=ABC123    Cookie: JSESSIONID=XYZ789
                         │                    │
                   ┌─────────┐          ┌─────────┐
                   │ Client 1│          │ Client 2│
                   │ (John)  │          │ (Jane)  │
                   └─────────┘          └─────────┘
```

### Session vs Cookies

| Aspect | Cookies | HttpSession |
|--------|---------|-------------|
| **Storage** | Client browser | Server memory |
| **Data size** | ~4KB limit | Unlimited |
| **Security** | Visible to user | Hidden on server |
| **Data types** | Strings only | Any Java object |
| **ID** | Data itself | Just session ID |

---

## 📖 How Sessions Work

### Flow

```
1. First Request (no session):
    Client → Server
    Server: Creates HttpSession with ID=ABC123
    Server: Stores session data in memory
    Server: Sends cookie JSESSIONID=ABC123
    Response → Client (with Set-Cookie header)

2. Subsequent Requests:
    Client → Server (with Cookie: JSESSIONID=ABC123)
    Server: Finds session by ID ABC123
    Server: Access/modify session data
    Response → Client
```

### The JSESSIONID Cookie

```http
Set-Cookie: JSESSIONID=ABC123ABC123ABC123; Path=/app; HttpOnly
```

- **JSESSIONID**: Standard name for session ID cookie
- **Value**: Unique identifier for this session
- **HttpOnly**: Not accessible by JavaScript (security)

---

## 📖 Session API

### Getting a Session

```java
// Create new session OR get existing
HttpSession session = request.getSession();
// OR
HttpSession session = request.getSession(true);

// Get existing session only (returns null if none)
HttpSession session = request.getSession(false);
```

### Storing Data

```java
// Store any object
session.setAttribute("username", "John");
session.setAttribute("cart", new ArrayList<Product>());
session.setAttribute("loginTime", new Date());
```

### Retrieving Data

```java
// Get attribute (returns Object, needs casting)
String username = (String) session.getAttribute("username");
ArrayList<Product> cart = (ArrayList) session.getAttribute("cart");

// Returns null if attribute doesn't exist
```

### Removing Data

```java
// Remove specific attribute
session.removeAttribute("cart");

// Invalidate entire session (logout)
session.invalidate();
```

### Session Information

```java
session.getId();              // Get session ID
session.isNew();              // True if just created
session.getCreationTime();    // When created (milliseconds)
session.getLastAccessedTime(); // Last access time
```

---

## 💻 Code Examples

### SessionServ1.java - Creating Session

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/SessionServ1")
public class SessionServ1 extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Create or get session
        HttpSession session = request.getSession();
        
        // Store data in session
        session.setAttribute("book", "Complete_Reference");
        session.setAttribute("username", "John");
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        pw.println("<h2>Session Created!</h2>");
        pw.println("<p>Session ID: " + session.getId() + "</p>");
        pw.println("<p>Is New: " + session.isNew() + "</p>");
        pw.println("<a href='SessionServ2'>Go to Servlet 2</a>");
    }
}
```

### SessionServ2.java - Reading Session

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/SessionServ2")
public class SessionServ2 extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get existing session (false = don't create new)
        HttpSession session = request.getSession(false);
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        if (session != null) {
            // Session exists - read data
            String book = (String) session.getAttribute("book");
            String username = (String) session.getAttribute("username");
            
            pw.println("<h2>Session Data</h2>");
            pw.println("<p>Book: " + book + "</p>");
            pw.println("<p>Username: " + username + "</p>");
            pw.println("<a href='LogoutServlet'>Logout</a>");
            
        } else {
            pw.println("<p>No session found! Please login.</p>");
        }
    }
}
```

### LogoutServlet.java - Invalidating Session

```java
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate();  // Destroy session
        }
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("<h2>Logged Out Successfully!</h2>");
        pw.println("<a href='SessionServ1'>Login Again</a>");
    }
}
```

---

## 📖 Session Lifecycle

### Session States

```
┌─────────────┐     request.getSession()    ┌─────────────┐
│  No Session │ ─────────────────────────► │   Active    │
└─────────────┘                             └──────┬──────┘
                                                   │
                            ┌──────────────────────┴───────────────────┐
                            │                                          │
                            ▼                                          ▼
                    session.invalidate()                         Session Timeout
                            │                                          │
                            └──────────────┬───────────────────────────┘
                                           │
                                           ▼
                                    ┌─────────────┐
                                    │  Destroyed  │
                                    └─────────────┘
```

### Session Timeout

Default session timeout: 30 minutes of inactivity

```java
// Set timeout programmatically (in seconds)
session.setMaxInactiveInterval(1800);  // 30 minutes

// Set in web.xml (in minutes)
// <session-config>
//     <session-timeout>30</session-timeout>
// </session-config>
```

---

## ✅ Key Takeaways

1. **Data stored on server** - only session ID sent to client
2. **getSession()** creates new or returns existing session
3. **getSession(false)** returns null if no session exists
4. **setAttribute/getAttribute** for storing/retrieving data
5. **invalidate()** destroys the session (logout)
6. Session identified by **JSESSIONID** cookie
7. Session expires after **timeout** (default 30 min)

---

## 🎤 Interview Questions

**Q1: What is the difference between getSession() and getSession(false)?**
> **A:**
> - `getSession()` or `getSession(true)`: Returns existing session or creates new
> - `getSession(false)`: Returns existing session or null (never creates)

**Q2: How does HttpSession maintain state across requests?**
> **A:** Server creates a session and assigns a unique ID (JSESSIONID). This ID is sent to the client as a cookie. On subsequent requests, the browser sends this cookie, and the server uses it to locate the user's session data.

**Q3: What happens when you call session.invalidate()?**
> **A:** The session is destroyed - all attributes are removed, the session ID becomes invalid, and a new session will be created on the next getSession() call. Typically used for logout.

**Q4: What is session timeout and how do you configure it?**
> **A:** Session timeout is how long a session stays alive after last access. Default is usually 30 minutes. Configure via:
> - `session.setMaxInactiveInterval(seconds)` in Java
> - `<session-timeout>minutes</session-timeout>` in web.xml

**Q5: Is HttpSession thread-safe?**
> **A:** The HttpSession object itself is thread-safe for setAttribute/getAttribute, but the objects stored in it are not automatically synchronized. If multiple requests modify the same attribute concurrently, you need synchronization.
