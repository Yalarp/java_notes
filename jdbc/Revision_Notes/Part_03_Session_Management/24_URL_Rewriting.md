# URL Rewriting

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is URL Rewriting](#what-is-url-rewriting)
3. [When to Use](#when-to-use)
4. [How It Works](#how-it-works)
5. [Code Example](#code-example)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**URL Rewriting** is a session tracking technique that appends the session ID to the URL when cookies are disabled. It's a fallback mechanism for maintaining sessions.

---

## 📖 What is URL Rewriting

### Definition

URL Rewriting embeds the session ID directly in the URL:

```
Before rewriting:
http://localhost:8080/app/SecondServlet

After rewriting:
http://localhost:8080/app/SecondServlet;jsessionid=ABC123XYZ789
```

### Why Needed?

- Some users **disable cookies** in their browser
- Some corporate **firewalls block cookies**
- Cookie-based session tracking **fails** in these cases
- URL rewriting provides a **fallback**

---

## 📖 When to Use

### Cookie vs URL Rewriting

```
Normal flow (cookies enabled):
    1. Server creates session
    2. Session ID sent via Set-Cookie header
    3. Browser stores cookie
    4. Cookie sent with every request
    
When cookies disabled:
    1. Server creates session
    2. Set-Cookie header sent but IGNORED by browser
    3. Next request has no session ID!
    4. Server thinks it's a NEW user
    
Solution - URL Rewriting:
    1. Server creates session
    2. Server appends session ID to ALL URLs
    3. User clicks link with embedded session ID
    4. Server extracts session ID from URL
```

---

## 📖 How It Works

### The response.encodeURL() Method

```java
// Encode URL to include session ID if needed
String encodedURL = response.encodeURL("SecondServlet");
```

**What it does:**
1. Checks if cookies are supported
2. If cookies work → returns URL unchanged
3. If cookies don't work → appends `;jsessionid=XXX` to URL

### Flow

```
Servlet 1:
┌──────────────────────────────────────────────────────────────┐
│  HttpSession session = request.getSession();                  │
│  session.setAttribute("gender", "male");                      │
│                                                               │
│  String url = response.encodeURL("Second");                   │
│  // If cookies disabled: "Second;jsessionid=ABC123"           │
│  // If cookies enabled: "Second"                              │
│                                                               │
│  out.println("<a href='" + url + "'>Go to Second</a>");      │
└──────────────────────────────────────────────────────────────┘
                            │
                            ▼
Servlet 2:
┌──────────────────────────────────────────────────────────────┐
│  HttpSession session = request.getSession(false);             │
│  // Session ID extracted from URL or cookie                   │
│  String gender = (String) session.getAttribute("gender");     │
└──────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Example

### First.java - Creating Session and Encoded Link

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/First")
public class First extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws IOException {
        
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        
        // Create session and store data
        HttpSession session = req.getSession();
        session.setAttribute("gender", "male");
        session.setAttribute("username", "John");
        
        // Encode URL - appends session ID if cookies disabled
        String encodedURL = res.encodeURL("Second");
        
        out.println("<html><body>");
        out.println("<h2>First Servlet</h2>");
        out.println("<p>Session Created with ID: " + session.getId() + "</p>");
        out.println("<p>Click to continue:</p>");
        
        // Use encoded URL in link
        out.println("<a href=\"" + encodedURL + "\">Go to Second Servlet</a>");
        
        out.println("</body></html>");
    }
}
```

### Second.java - Reading Session

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/Second")
public class Second extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) 
            throws IOException {
        
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();
        
        // Get session (session ID from URL or cookie)
        HttpSession session = req.getSession(false);
        
        out.println("<html><body>");
        out.println("<h2>Second Servlet</h2>");
        
        if (session != null) {
            String gender = (String) session.getAttribute("gender");
            String username = (String) session.getAttribute("username");
            
            out.println("<p>Welcome " + username + "!</p>");
            out.println("<p>Gender: " + gender + "</p>");
        } else {
            out.println("<p>No session found!</p>");
        }
        
        out.println("</body></html>");
    }
}
```

### Generated HTML (Cookies Disabled)

```html
<a href="Second;jsessionid=A1B2C3D4E5F6G7H8">Go to Second Servlet</a>
```

---

## ⚠️ Limitations

| Limitation | Description |
|------------|-------------|
| **Ugly URLs** | Session ID visible in URL |
| **Bookmarking issues** | Bookmarked URL may have expired session |
| **Must encode ALL links** | Easy to forget |
| **Security concern** | Session ID visible in browser history |
| **Referer header leak** | Session ID may be sent to external sites |

### Best Practice

Always use `encodeURL()` for internal links to ensure session works regardless of cookie settings.

---

## ✅ Key Takeaways

1. **URL Rewriting** = embedding session ID in URL
2. Use `response.encodeURL("path")` for all internal links
3. **Fallback** when cookies are disabled
4. Container automatically extracts session ID from URL
5. Always encode URLs to support both cookie and non-cookie clients

---

## 🎤 Interview Questions

**Q1: What is URL rewriting and when is it used?**
> **A:** URL rewriting appends the session ID to URLs when cookies are disabled. It's used as a fallback session tracking mechanism when the browser doesn't support or has disabled cookies.

**Q2: What does response.encodeURL() do?**
> **A:** It checks if the client supports cookies. If yes, returns the URL unchanged. If cookies are disabled, it appends `;jsessionid=XXX` to the URL to maintain session tracking.

**Q3: What is the difference between encodeURL() and encodeRedirectURL()?**
> **A:**
> - `encodeURL()`: For normal links within the response HTML
> - `encodeRedirectURL()`: For URLs used with `response.sendRedirect()`

**Q4: What are the disadvantages of URL rewriting?**
> **A:**
> - Session ID visible in URL (security concern)
> - URLs are longer and uglier
> - Session ID in browser history
> - Must remember to encode ALL links
> - Bookmarked URLs may have expired sessions
