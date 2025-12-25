# Session Timeout Configuration

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is Session Timeout](#what-is-session-timeout)
3. [Configuration Methods](#configuration-methods)
4. [Code Examples](#code-examples)
5. [Best Practices](#best-practices)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Session timeout** determines how long an inactive session remains valid. After the timeout period, the session is automatically invalidated by the container.

---

## 📖 What is Session Timeout

### Definition

Session timeout = time of **inactivity** after which the session is destroyed.

```
Session Created → User Active → User Inactive → Timeout → Session Destroyed
                     ↑                ↑
               Timer resets    Timer starts
```

### Default Timeout

- Tomcat default: **30 minutes**
- Configurable at application or servlet level

### What Happens at Timeout

1. Session object is destroyed
2. All session attributes are removed
3. `session.invalidate()` is called internally
4. Next request gets a **new session**

---

## 📖 Configuration Methods

### Method 1: web.xml (Application-wide)

```xml
<web-app>
    <session-config>
        <session-timeout>30</session-timeout>  <!-- In MINUTES -->
    </session-config>
</web-app>
```

### Method 2: Programmatically (Per-session)

```java
// Get session
HttpSession session = request.getSession();

// Set timeout in SECONDS
session.setMaxInactiveInterval(1800);  // 30 minutes

// Get current timeout setting
int timeout = session.getMaxInactiveInterval();  // Returns seconds
```

### Method 3: Tomcat server.xml (Server-wide)

```xml
<Context path="/myapp" docBase="...">
    <Manager sessionTimeout="30" />
</Context>
```

### Priority Order

```
Programmatic (setMaxInactiveInterval)
        ↓ overrides
    web.xml (session-config)
        ↓ overrides
    Server default (30 min)
```

---

## 💻 Code Examples

### Setting Timeout Programmatically

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Create session
        HttpSession session = request.getSession();
        
        // Set 15 minute timeout (in seconds)
        session.setMaxInactiveInterval(15 * 60);
        
        // Store user data
        session.setAttribute("username", "John");
        session.setAttribute("loginTime", System.currentTimeMillis());
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("Logged in. Session timeout: " + 
                   (session.getMaxInactiveInterval() / 60) + " minutes");
    }
}
```

### Checking Session Status

```java
@WebServlet("/SessionCheck")
public class SessionCheck extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            long creationTime = session.getCreationTime();
            long lastAccessed = session.getLastAccessedTime();
            int maxInactive = session.getMaxInactiveInterval();
            
            pw.println("<h2>Session Info</h2>");
            pw.println("Session ID: " + session.getId() + "<br>");
            pw.println("Created: " + new java.util.Date(creationTime) + "<br>");
            pw.println("Last Accessed: " + new java.util.Date(lastAccessed) + "<br>");
            pw.println("Timeout: " + maxInactive + " seconds<br>");
            pw.println("Is New: " + session.isNew());
        } else {
            pw.println("<p>No active session. Please login.</p>");
        }
    }
}
```

### web.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0">
    
    <!-- Session configuration -->
    <session-config>
        <!-- Timeout in MINUTES (not seconds!) -->
        <session-timeout>30</session-timeout>
        
        <!-- Cookie configuration -->
        <cookie-config>
            <http-only>true</http-only>
            <secure>true</secure>
        </cookie-config>
        
        <!-- Session tracking mode -->
        <tracking-mode>COOKIE</tracking-mode>
    </session-config>
    
</web-app>
```

---

## 🛡️ Best Practices

### 1. Set Appropriate Timeouts

| Application Type | Recommended Timeout |
|------------------|-------------------|
| Banking/Finance | 5-10 minutes |
| E-commerce | 20-30 minutes |
| Social Media | 30-60 minutes |
| Admin Portals | 15-30 minutes |

### 2. Handle Session Expiry Gracefully

```java
HttpSession session = request.getSession(false);

if (session == null) {
    // Session expired - redirect to login
    response.sendRedirect("login.html");
    return;
}
```

### 3. Provide "Remember Me" Option

For longer sessions, use persistent cookies with secure tokens instead of extending session timeout.

### 4. Use HTTPS with Secure Cookies

```xml
<cookie-config>
    <http-only>true</http-only>
    <secure>true</secure>
</cookie-config>
```

---

## ✅ Key Takeaways

1. **Default timeout**: 30 minutes (Tomcat)
2. **web.xml**: Configure in **MINUTES**
3. **setMaxInactiveInterval()**: Configure in **SECONDS**
4. **Timeout = inactivity time**, not total session life
5. Each request **resets the timer**
6. Balance security (short) vs. convenience (long)

---

## 🎤 Interview Questions

**Q1: How do you configure session timeout?**
> **A:** Three ways:
> - web.xml: `<session-timeout>30</session-timeout>` (in minutes)
> - Programmatic: `session.setMaxInactiveInterval(1800)` (in seconds)
> - Server config: Tomcat context settings

**Q2: What is the difference between session-timeout in web.xml and setMaxInactiveInterval()?**
> **A:**
> - web.xml uses **minutes**
> - setMaxInactiveInterval uses **seconds**
> - Programmatic setting overrides web.xml for that specific session

**Q3: What happens when a session times out?**
> **A:** The container destroys the session, removes all attributes, and subsequent requests receive a new session. The old session ID becomes invalid.

**Q4: How can you check if a session is expired?**
> **A:** Call `request.getSession(false)`. If it returns null, no valid session exists (expired or never created). Using `getSession()` or `getSession(true)` would create a new session instead.

**Q5: Does each request reset the timeout counter?**
> **A:** Yes. The timeout is measured from the **last request**. Every request that accesses the session resets the inactivity timer.
