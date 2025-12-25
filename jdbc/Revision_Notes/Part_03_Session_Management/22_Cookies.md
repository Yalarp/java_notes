# Cookies in Servlets

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What are Cookies](#what-are-cookies)
3. [How Cookies Work](#how-cookies-work)
4. [Cookie API](#cookie-api)
5. [Code Examples](#code-examples)
6. [Cookie Properties](#cookie-properties)
7. [Limitations](#limitations)
8. [Key Takeaways](#key-takeaways)
9. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Cookies** are small pieces of data stored on the **client's browser** and sent with every request to the server. They're commonly used for session tracking, user preferences, and remembering login state.

---

## 📖 What are Cookies

### Definition

A cookie is a **name-value pair** stored by the browser and automatically sent to the server with each request.

```
Cookie: username=John; theme=dark; sessionId=ABC123
```

### Characteristics

| Feature | Description |
|---------|-------------|
| **Storage** | Client-side (browser) |
| **Size limit** | ~4KB per cookie |
| **Count limit** | ~20-50 cookies per domain |
| **Sent automatically** | Every request to same domain |
| **Persistence** | Until expiry or deletion |

---

## 📖 How Cookies Work

### Flow Diagram

```
1. First Request (no cookies):
┌──────────┐           Request           ┌──────────┐
│          │ ─────────────────────────► │          │
│  Client  │     (no Cookie header)     │  Server  │
│          │ ◄───────────────────────── │          │
└──────────┘  Set-Cookie: user=John     └──────────┘

2. Subsequent Requests (with cookie):
┌──────────┐  Request + Cookie: user=John ┌──────────┐
│          │ ─────────────────────────► │          │
│  Client  │                            │  Server  │
│          │ ◄───────────────────────── │  (knows  │
└──────────┘        Response            │   John!) │
                                        └──────────┘
```

### Key Points

- Server **creates** cookies with `Set-Cookie` response header
- Browser **stores** cookies locally
- Browser **sends** cookies automatically with each request
- Server **reads** cookies from request

---

## 📖 Cookie API

### Creating Cookies

```java
// Create a cookie
Cookie cookie = new Cookie("username", "John");

// Set properties (optional)
cookie.setMaxAge(3600);        // 1 hour in seconds
cookie.setPath("/");           // All URLs
cookie.setHttpOnly(true);      // Not accessible by JavaScript

// Add to response
response.addCookie(cookie);
```

### Reading Cookies

```java
// Get all cookies from request
Cookie[] cookies = request.getCookies();

if (cookies != null) {
    for (Cookie c : cookies) {
        String name = c.getName();
        String value = c.getValue();
        System.out.println(name + " = " + value);
    }
}
```

### Deleting Cookies

```java
// To delete, set maxAge to 0
Cookie cookie = new Cookie("username", "");
cookie.setMaxAge(0);  // Delete immediately
response.addCookie(cookie);
```

---

## 💻 Code Examples

### CustomCookieServ.java - Complete Example

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/CookieDemo")
public class CustomCookieServ extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Read existing cookies
        Cookie[] cookieList = request.getCookies();
        
        if (cookieList != null) {
            // Returning user - show their cookies
            out.println("<h2>Welcome Back!</h2>");
            out.println("<p>Your cookies:</p>");
            
            for (Cookie c : cookieList) {
                out.println(c.getName() + " = " + c.getValue() + "<br>");
            }
            
        } else {
            // New user - create cookie
            Cookie c = new Cookie("username", "John");
            c.setMaxAge(60 * 60);  // 1 hour
            response.addCookie(c);
            
            out.println("<h2>Welcome, New User!</h2>");
            out.println("<p>A cookie has been created for you.</p>");
        }
        
        out.close();
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 16 | `request.getCookies()` | Get array of all cookies sent by browser |
| 18 | `if (cookieList != null)` | Check if any cookies exist |
| 23-25 | `for (Cookie c : cookieList)` | Iterate through all cookies |
| 29 | `new Cookie("username", "John")` | Create new cookie |
| 30 | `c.setMaxAge(60 * 60)` | Set expiry to 1 hour |
| 31 | `response.addCookie(c)` | Send cookie to browser |

---

## 📖 Cookie Properties

### setMaxAge(seconds)

| Value | Behavior |
|-------|----------|
| **Positive** | Cookie persists for that many seconds |
| **Negative (default)** | Session cookie - deleted when browser closes |
| **Zero** | Delete the cookie immediately |

```java
cookie.setMaxAge(3600);    // Lasts 1 hour
cookie.setMaxAge(-1);      // Session only (default)
cookie.setMaxAge(0);       // Delete now
```

### Other Properties

| Method | Purpose |
|--------|---------|
| `setPath("/")` | Cookie sent to all URLs under path |
| `setDomain(".example.com")` | Cookie sent to subdomains |
| `setSecure(true)` | Only sent over HTTPS |
| `setHttpOnly(true)` | Not accessible by JavaScript (XSS protection) |

---

## ⚠️ Limitations

### Cookie Limitations

| Limitation | Description |
|------------|-------------|
| **Size** | ~4KB per cookie |
| **Count** | ~20-50 per domain |
| **Client-side** | User can disable or delete |
| **Security** | Transmitted in every request |
| **Privacy** | Can be blocked by browsers |

### When NOT to Use Cookies

- Large amounts of data (use session instead)
- Sensitive data (use server-side session)
- When user may disable cookies
- Cross-domain scenarios (strict rules)

---

## ✅ Key Takeaways

1. Cookies are **stored on client browser**
2. **Automatically sent** with each request
3. Created with `new Cookie()`, added with `response.addCookie()`
4. Read with `request.getCookies()` (returns array)
5. **setMaxAge(0)** deletes the cookie
6. **Negative maxAge** = session cookie (until browser closes)
7. Use **HttpOnly** and **Secure** for security

---

## 🎤 Interview Questions

**Q1: What is a cookie and how does it work?**
> **A:** A cookie is a small piece of data (name-value pair) stored on the client's browser. The server creates cookies via `Set-Cookie` response header. The browser stores them and automatically sends them with every subsequent request to the same domain.

**Q2: What is the difference between session cookies and persistent cookies?**
> **A:**
> - **Session cookie**: No expiry set (or negative maxAge), deleted when browser closes
> - **Persistent cookie**: Has expiry date (positive maxAge), survives browser restart

**Q3: How do you delete a cookie?**
> **A:** Create a cookie with the same name and call `setMaxAge(0)`, then add it to the response:
> ```java
> Cookie c = new Cookie("name", "");
> c.setMaxAge(0);
> response.addCookie(c);
> ```

**Q4: What is the purpose of setHttpOnly(true)?**
> **A:** It makes the cookie inaccessible to JavaScript (`document.cookie`). This protects against XSS attacks where malicious scripts try to steal cookies.

**Q5: What are the limitations of cookies?**
> **A:** Size (~4KB), count per domain (~20-50), can be disabled by users, sent with every request (bandwidth), privacy concerns, not suitable for sensitive data.
