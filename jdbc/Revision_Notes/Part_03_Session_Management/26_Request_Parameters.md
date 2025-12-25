# Request Parameters

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Types of Parameters](#types-of-parameters)
3. [Getting Parameters](#getting-parameters)
4. [Code Examples](#code-examples)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Request Parameters** are name-value pairs sent from client to server, either through query strings (GET) or request body (POST).

---

## 📖 Types of Parameters

### Query String Parameters (GET)

```
http://localhost:8080/app/search?name=John&age=25
                                 └── Query String ──┘
```

### Form Data Parameters (POST)

```html
<form action="register" method="POST">
    <input type="text" name="name" value="John">
    <input type="text" name="age" value="25">
    <input type="submit">
</form>
```

### Comparison

| Feature | GET | POST |
|---------|-----|------|
| **Location** | URL query string | Request body |
| **Visible** | Yes (in URL) | No |
| **Bookmarkable** | Yes | No |
| **Size limit** | ~2KB | No limit |
| **Security** | Less secure | More secure |

---

## 📖 Getting Parameters

### Single Value

```java
// Gets first/only value for parameter
String name = request.getParameter("name");
```

### Multiple Values (Same Name)

```java
// For checkboxes, multi-select
String[] hobbies = request.getParameterValues("hobby");

if (hobbies != null) {
    for (String hobby : hobbies) {
        System.out.println(hobby);
    }
}
```

### All Parameter Names

```java
Enumeration<String> paramNames = request.getParameterNames();
while (paramNames.hasMoreElements()) {
    String name = paramNames.nextElement();
    String value = request.getParameter(name);
    System.out.println(name + " = " + value);
}
```

### Parameter Map

```java
Map<String, String[]> paramMap = request.getParameterMap();
for (Map.Entry<String, String[]> entry : paramMap.entrySet()) {
    String name = entry.getKey();
    String[] values = entry.getValue();
    System.out.println(name + " = " + Arrays.toString(values));
}
```

---

## 💻 Code Examples

### Complete Servlet

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;
import java.util.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        // Single value
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String age = request.getParameter("age");
        
        // Multiple values (checkboxes)
        String[] skills = request.getParameterValues("skill");
        
        pw.println("<h2>Registration Details</h2>");
        pw.println("<p>Name: " + name + "</p>");
        pw.println("<p>Email: " + email + "</p>");
        pw.println("<p>Age: " + age + "</p>");
        
        if (skills != null) {
            pw.println("<p>Skills:</p><ul>");
            for (String skill : skills) {
                pw.println("<li>" + skill + "</li>");
            }
            pw.println("</ul>");
        }
    }
}
```

### HTML Form

```html
<form action="register" method="POST">
    Name: <input type="text" name="name"><br>
    Email: <input type="text" name="email"><br>
    Age: <input type="number" name="age"><br>
    
    Skills:<br>
    <input type="checkbox" name="skill" value="Java"> Java<br>
    <input type="checkbox" name="skill" value="Python"> Python<br>
    <input type="checkbox" name="skill" value="JavaScript"> JavaScript<br>
    
    <input type="submit" value="Register">
</form>
```

---

## ✅ Key Takeaways

1. **getParameter()** - single value, returns null if not found
2. **getParameterValues()** - multiple values (checkboxes)
3. **getParameterNames()** - enumeration of all names
4. **getParameterMap()** - map of name to values array
5. Parameters work **same way** for GET and POST

---

## 🎤 Interview Questions

**Q1: What is the difference between getParameter() and getParameterValues()?**
> **A:** 
> - `getParameter()`: Returns first/single value as String
> - `getParameterValues()`: Returns all values as String[] (for checkboxes, multi-select)

**Q2: What does getParameter() return if parameter doesn't exist?**
> **A:** Returns `null`. Always check for null before using.

**Q3: Can we modify request parameters?**
> **A:** No, request parameters are read-only. Use request attributes (`setAttribute`) if you need to pass modified data.
