# HTTP Methods - doGet vs doPost

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [GET Method](#get-method)
3. [POST Method](#post-method)
4. [Comparison Table](#comparison-table)
5. [Code Examples](#code-examples)
6. [When to Use Which](#when-to-use-which)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

HTTP defines several methods for client-server communication. The two most common in web applications are **GET** and **POST**. Understanding their differences is crucial for building secure and efficient web applications.

---

## 📖 GET Method

### Characteristics

| Aspect | Description |
|--------|-------------|
| **Data Location** | Appended to URL as query string |
| **Visibility** | Visible in browser address bar |
| **Data Size** | Limited (2KB-8KB depending on browser) |
| **Caching** | Can be cached by browser |
| **Bookmarking** | Can be bookmarked |
| **Security** | Less secure (data in URL) |
| **Idempotent** | Yes (same request = same result) |

### URL with Query String

```
http://example.com/search?name=John&age=25
                         └──────────────────┘
                              Query String
```

### doGet() Method

```java
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // Parameters from URL query string
    String name = request.getParameter("name");
    String age = request.getParameter("age");
    
    // Process and respond
    response.setContentType("text/html");
    PrintWriter pw = response.getWriter();
    pw.println("Name: " + name + ", Age: " + age);
}
```

### When GET is Called

```html
<!-- 1. Form with method="get" or no method (default is GET) -->
<form action="SearchServlet" method="get">
    <input type="text" name="query">
    <input type="submit">
</form>

<!-- 2. Hyperlink (always GET) -->
<a href="SearchServlet?query=java">Search Java</a>

<!-- 3. Direct URL in browser address bar -->
```

---

## 📖 POST Method

### Characteristics

| Aspect | Description |
|--------|-------------|
| **Data Location** | In request body (not visible in URL) |
| **Visibility** | Not visible in address bar |
| **Data Size** | Unlimited (theoretically) |
| **Caching** | Not cached |
| **Bookmarking** | Cannot bookmark with data |
| **Security** | More secure (data hidden from URL) |
| **Idempotent** | No (can have side effects) |

### doPost() Method

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // Parameters from request body
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Process (e.g., authenticate, save to database)
    // ...
    
    response.setContentType("text/html");
    PrintWriter pw = response.getWriter();
    pw.println("Login processed for: " + username);
}
```

### When POST is Called

```html
<!-- Form with method="post" -->
<form action="LoginServlet" method="post">
    Username: <input type="text" name="username"><br>
    Password: <input type="password" name="password"><br>
    <input type="submit" value="Login">
</form>
```

---

## 📊 Comparison Table

| Feature | GET | POST |
|---------|-----|------|
| Data in | URL | Body |
| Visible | Yes | No |
| Size limit | ~2-8 KB | Unlimited |
| Cached | Yes | No |
| Bookmarkable | Yes | No |
| Idempotent | Yes | No |
| Security | Lower | Higher |
| Browser back | Safe | May resubmit |
| File upload | No | Yes |

### Idempotent Explained

**Idempotent** means calling the method multiple times produces the same result.

```
GET /user/123     → Returns user 123 (always same result)
GET /user/123     → Returns user 123 (same)

POST /order       → Creates new order (order #1001)
POST /order       → Creates new order (order #1002) ← DIFFERENT!
```

---

## 💻 Code Examples

### HTML Form

```html
<!DOCTYPE html>
<html>
<head><title>Person Form</title></head>
<body>
    <h2>Add Person</h2>
    <form action="PersonServ" method="post">
        Name: <input type="text" name="name"><br><br>
        Age: <input type="text" name="age"><br><br>
        <input type="submit" value="Submit">
    </form>
</body>
</html>
```

### PersonServ.java

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/PersonServ")
public class PersonServ extends HttpServlet {
    
    // Handle POST request
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html");
        
        // Get PrintWriter for output
        PrintWriter pw = response.getWriter();
        
        // Extract parameters from request body
        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age").trim());
        
        // Process and respond
        pw.println("<html><body>");
        pw.println("<h2>Person Added</h2>");
        pw.println("<p>Name: " + name + "</p>");
        pw.println("<p>Age: " + age + "</p>");
        pw.println("</body></html>");
    }
    
    // Handle GET request (optional - shows form or data)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        pw.println("Use POST method to submit data");
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 12 | `response.setContentType("text/html")` | Tell browser content is HTML |
| 15 | `response.getWriter()` | Get output stream for text |
| 18-19 | `request.getParameter(...)` | Extract form data from POST body |
| 22-26 | `pw.println(...)` | Send HTML response |

---

## 🤔 When to Use Which

### Use GET For:

✅ Search queries
✅ Filtering/sorting data
✅ Navigation links
✅ Reading data (no modifications)
✅ When you want URL to be shareable

```
GET /products?category=electronics&sort=price
GET /users/123/profile
GET /search?q=java+tutorial
```

### Use POST For:

✅ Login forms (passwords!)
✅ File uploads
✅ Creating new resources
✅ Submitting sensitive data
✅ Large data payloads

```
POST /login (username, password in body)
POST /orders (create new order)
POST /upload (file data)
POST /user/register (registration data)
```

---

## ✅ Key Takeaways

1. **GET** = Data in URL, visible, limited size, cacheable
2. **POST** = Data in body, hidden, unlimited size, not cached
3. **GET** for reading data, **POST** for modifying data
4. **Never** send passwords via GET
5. **Directly typing URL** in browser = GET request
6. **Form with no method** attribute = GET (default)
7. Both methods use `request.getParameter()` to read data

---

## 🎤 Interview Questions

**Q1: What is the difference between GET and POST?**
> **A:**
> - **GET**: Data in URL, visible, limited size (~2KB), can be bookmarked/cached, for reading data
> - **POST**: Data in body, hidden, unlimited size, cannot be bookmarked, for creating/modifying data

**Q2: Why shouldn't passwords be sent via GET?**
> **A:** GET data appears in the URL, which:
> - Is visible in browser history
> - Gets logged by web servers
> - Can be cached by browsers
> - Appears in referrer headers
> - Is visible to anyone nearby

**Q3: What is idempotent? Is GET idempotent?**
> **A:** Idempotent means making the same request multiple times has the same effect as making it once. **GET is idempotent** (reading user/123 always returns same user). **POST is not** (posting twice may create two orders).

**Q4: How do you get request parameters in a servlet?**
> **A:** Using `request.getParameter("paramName")`. This works for both GET (from URL) and POST (from body). The same method works regardless of HTTP method.

**Q5: When does the browser send a GET vs POST request?**
> **A:**
> - **GET**: Clicking links, typing URL, form with `method="get"` or no method
> - **POST**: Form with `method="post"`, AJAX calls specifying POST

**Q6: Can you send a request body with GET?**
> **A:** Technically possible but against specification and not recommended. Most servers ignore GET body. Use POST if you need to send body data.
