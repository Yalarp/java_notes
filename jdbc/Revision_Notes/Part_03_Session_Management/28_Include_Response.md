# Include Response

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [RequestDispatcher Include](#requestdispatcher-include)
3. [Include vs Forward](#include-vs-forward)
4. [Code Examples](#code-examples)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Include** allows a servlet to include content from another resource (servlet, JSP, HTML) in its response. Unlike forward, the original servlet **continues processing** after include.

---

## 📖 RequestDispatcher Include

### Syntax

```java
RequestDispatcher rd = request.getRequestDispatcher("page.jsp");
rd.include(request, response);
```

### Flow

```
┌──────────────────────────────────────────────────────────────┐
│                      MainServlet                              │
│                                                               │
│   1. Write "Start"                                            │
│             ↓                                                 │
│   2. rd.include("other.jsp")  ─────►  [Other.jsp output]     │
│             ↓                              inserted here      │
│   3. Write "End"                                              │
│                                                               │
│   Final output: "Start" + [included content] + "End"         │
└──────────────────────────────────────────────────────────────┘
```

---

## 📖 Include vs Forward

| Feature | Include | Forward |
|---------|---------|---------|
| **Control returns** | Yes, to original | No |
| **Original can write** | Before AND after | Only before |
| **Headers** | Can set before | Can set before |
| **URL** | Original URL | Original URL |
| **Use case** | Combine content | Delegate completely |

### Visual Comparison

```
FORWARD:
    Servlet A    →    JSP
    (stopped)         (generates response)

INCLUDE:
    Servlet A    →    JSP    →    Servlet A continues
    (paused)     (included)       (resumes)
```

---

## 💻 Code Examples

### Main Servlet with Include

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/main")
public class MainServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        // Write header
        pw.println("<html><body>");
        pw.println("<h1>Main Page</h1>");
        
        // Include header component
        RequestDispatcher headerRd = request.getRequestDispatcher("header.jsp");
        headerRd.include(request, response);
        
        // Write content
        pw.println("<div class='content'>");
        pw.println("<p>This is the main content.</p>");
        pw.println("</div>");
        
        // Include footer component
        RequestDispatcher footerRd = request.getRequestDispatcher("footer.jsp");
        footerRd.include(request, response);
        
        pw.println("</body></html>");
    }
}
```

### header.jsp

```jsp
<header>
    <nav>
        <a href="/">Home</a> | 
        <a href="/about">About</a> | 
        <a href="/contact">Contact</a>
    </nav>
</header>
<hr>
```

### footer.jsp

```jsp
<hr>
<footer>
    <p>&copy; 2024 My Company. All rights reserved.</p>
</footer>
```

### Passing Data to Included Resource

```java
// Set attribute before include
request.setAttribute("currentPage", "Home");

RequestDispatcher rd = request.getRequestDispatcher("nav.jsp");
rd.include(request, response);
```

### In nav.jsp

```jsp
<nav>
    <a href="/" class="${currentPage == 'Home' ? 'active' : ''}">Home</a>
</nav>
```

---

## ✅ Key Takeaways

1. **include()** inserts content from another resource
2. Control **returns** to original servlet after include
3. Original servlet can write **before and after** include
4. Same request/response objects shared
5. Good for **reusable components** (headers, footers, sidebars)

---

## 🎤 Interview Questions

**Q1: What is the difference between include() and forward()?**
> **A:**
> - `include()`: Includes content, control returns, can write before/after
> - `forward()`: Transfers completely, control doesn't return

**Q2: Can you modify headers after calling include()?**
> **A:** No. If content has been written or committed, headers cannot be modified. Set headers before any output.

**Q3: What happens if included resource throws exception?**
> **A:** The exception propagates to the including servlet. Handle with try-catch if needed.
