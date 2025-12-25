# Forward vs Redirect

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Request Forward](#request-forward)
3. [Response Redirect](#response-redirect)
4. [Comparison](#comparison)
5. [Code Examples](#code-examples)
6. [When to Use Which](#when-to-use-which)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Forward** and **Redirect** are two ways to navigate from one resource to another in web applications. Understanding their differences is crucial for proper web development.

---

## 📖 Request Forward

### Definition

Forward happens **server-side**. The request is passed to another resource internally without the browser knowing.

### How It Works

```
┌──────────┐   Request    ┌─────────────────────────────────────┐
│          │ ──────────►  │              SERVER                  │
│  Client  │              │  ┌─────────┐      ┌─────────┐       │
│          │              │  │Servlet A│ ───► │Servlet B│       │
│          │              │  └─────────┘      └─────────┘       │
│          │ ◄──────────  │       Forward (internal)            │
└──────────┘   Response   └─────────────────────────────────────┘
     
Browser URL: http://localhost/app/ServletA  (UNCHANGED!)
```

### Characteristics

| Feature | Forward |
|---------|---------|
| **Happens** | Server-side only |
| **Browser knows?** | No |
| **URL changes?** | No (stays original) |
| **Request object** | Same (shared) |
| **Data passing** | Via request attributes |
| **Speed** | Faster (no round-trip) |

### Syntax

```java
// Get RequestDispatcher
RequestDispatcher rd = request.getRequestDispatcher("TargetServlet");

// Forward request
rd.forward(request, response);
```

---

## 📖 Response Redirect

### Definition

Redirect sends a response to the browser telling it to make a **new request** to a different URL.

### How It Works

```
┌──────────┐   Request 1   ┌──────────┐
│          │ ──────────►   │          │
│  Client  │               │ Server   │
│          │ ◄──────────   │          │
└──────────┘   302 Redirect│          │
     │         Location: B └──────────┘
     │
     │   Request 2 (NEW)   ┌──────────┐
     └──────────────────►  │          │
                           │ Server   │
      ◄──────────────────  │          │
           Response        └──────────┘

Browser URL: http://localhost/app/ServletB  (CHANGED!)
```

### Characteristics

| Feature | Redirect |
|---------|----------|
| **Happens** | Client-side (through browser) |
| **Browser knows?** | Yes |
| **URL changes?** | Yes (shows new URL) |
| **Request object** | New request |
| **Data passing** | Via session or query params |
| **Speed** | Slower (extra round-trip) |

### Syntax

```java
// Redirect to another URL
response.sendRedirect("TargetServlet");

// Redirect to external site
response.sendRedirect("https://google.com");
```

---

## 📊 Comparison

| Aspect | Forward | Redirect |
|--------|---------|----------|
| **Mechanism** | Server internal | Browser round-trip |
| **URL in browser** | Unchanged | Updated |
| **Request object** | Same | New |
| **Request attributes** | Preserved | Lost |
| **Can go external?** | No | Yes |
| **HTTP status** | None | 302/303/307 |
| **Speed** | Faster | Slower |
| **POST data** | Preserved | Lost |

### Visual Comparison

```
FORWARD (Server-side):
    Client → Servlet A → Servlet B → Client
    [1 request, 1 response, URL unchanged]

REDIRECT (Client round-trip):
    Client → Servlet A → Client → Servlet B → Client
    [2 requests, 2 responses, URL changes]
```

---

## 💻 Code Examples

### Forward Example

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/ForwardDemo")
public class ForwardDemo extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Store data in request (will be available in target)
        request.setAttribute("message", "Hello from ForwardDemo!");
        request.setAttribute("timestamp", System.currentTimeMillis());
        
        // Forward to DisplayServlet
        RequestDispatcher rd = request.getRequestDispatcher("DisplayServlet");
        rd.forward(request, response);
        
        // Code after forward is NOT executed!
    }
}
```

### DisplayServlet.java (Target)

```java
@WebServlet("/DisplayServlet")
public class DisplayServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        // Read data from forwarded request
        String message = (String) request.getAttribute("message");
        Long timestamp = (Long) request.getAttribute("timestamp");
        
        pw.println("<h2>Display Servlet</h2>");
        pw.println("<p>Message: " + message + "</p>");
        pw.println("<p>Timestamp: " + timestamp + "</p>");
    }
}
```

### Redirect Example

```java
@WebServlet("/RedirectDemo")
public class RedirectDemo extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Process form data
        String name = request.getParameter("name");
        
        // Store in session (redirect creates new request)
        HttpSession session = request.getSession();
        session.setAttribute("name", name);
        
        // Redirect - browser makes NEW request
        response.sendRedirect("SuccessPage");
        
        // Code after redirect MAY execute (unlike forward)
        // But don't write to response!
    }
}
```

---

## 🤔 When to Use Which

### Use Forward When:

✅ Staying within the same application
✅ Need to share request attributes
✅ Want to preserve POST data
✅ URL shouldn't change (internal flow)
✅ Performance is important

**Example:** MVC - Controller forwards to View (JSP)

### Use Redirect When:

✅ Going to external website
✅ After form submission (PRG pattern)
✅ URL should reflect new resource
✅ Need browser to know the new location
✅ Bookmarkable result pages

**Example:** After login, redirect to dashboard

### POST-Redirect-GET (PRG) Pattern

```
1. User submits form (POST)
2. Server processes, then REDIRECTS (not forward)
3. Browser makes GET request to success page
4. User can refresh without re-submitting form
```

---

## ✅ Key Takeaways

1. **Forward** = server-side, same request, URL unchanged
2. **Redirect** = client round-trip, new request, URL changes
3. Use **request.setAttribute** with forward to pass data
4. Use **session.setAttribute** with redirect to pass data
5. **PRG pattern**: Redirect after POST to prevent re-submission
6. Forward cannot go to **external sites**

---

## 🎤 Interview Questions

**Q1: What is the difference between forward and redirect?**
> **A:**
> - **Forward**: Server-side, same request object, URL unchanged, faster
> - **Redirect**: Client round-trip, new request, URL changes, can go external

**Q2: Can you use request attributes with redirect?**
> **A:** No. Redirect creates a new request, so request attributes are lost. Use session attributes or query parameters instead.

**Q3: What is the PRG (Post-Redirect-Get) pattern?**
> **A:** After processing a POST request, send a redirect instead of forward. This way, if the user refreshes, they'll be refreshing a GET request, not re-submitting the form.

**Q4: What happens if you write to response before forward?**
> **A:** If any output is committed (flushed to client), forward throws `IllegalStateException`. Always forward before writing anything to response.

**Q5: Can you forward to an external website?**
> **A:** No. Forward only works within the same application. Use redirect for external URLs.
