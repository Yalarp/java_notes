# Hidden Fields

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What are Hidden Fields](#what-are-hidden-fields)
3. [How It Works](#how-it-works)
4. [Code Example](#code-example)
5. [Limitations](#limitations)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Hidden Fields** are the simplest form of session tracking. They use HTML `<input type="hidden">` elements to pass data between pages through forms.

---

## 📖 What are Hidden Fields

### Definition

Hidden fields are form inputs that are:
- **Not visible** to users on the page
- **Included in form submission** when form is posted
- Used to **carry data** from one page to another

### HTML Syntax

```html
<input type="hidden" name="userId" value="123">
```

This field:
- Won't appear on screen
- Will be sent when form is submitted
- Carries `userId=123` to the server

---

## 📖 How It Works

### Flow Diagram

```
Page 1 (Form):
┌──────────────────────────────────────┐
│  Name: [John___________]             │
│  Email: [john@email.com]             │
│                                      │
│  <hidden name="step" value="1">      │ ← User doesn't see this
│                                      │
│  [Next →]                            │
└──────────────────────────────────────┘
                    │
                    ▼ Form submitted with step=1

Page 2 (Servlet generates):
┌──────────────────────────────────────┐
│  Thanks, John!                       │
│  Phone: [_______________]            │
│                                      │
│  <hidden name="name" value="John">   │ ← Carry forward from page 1
│  <hidden name="email" value="...">   │ ← Carry forward
│  <hidden name="step" value="2">      │
│                                      │
│  [Submit]                            │
└──────────────────────────────────────┘
                    │
                    ▼ All data submitted together
                    
Server receives: name, email, phone, step
```

---

## 💻 Code Example

### Step 1: Initial Form (form1.html)

```html
<!DOCTYPE html>
<html>
<head><title>Step 1</title></head>
<body>
    <h2>Registration - Step 1</h2>
    <form action="Step1Servlet" method="post">
        Name: <input type="text" name="name"><br><br>
        Email: <input type="text" name="email"><br><br>
        <input type="submit" value="Next">
    </form>
</body>
</html>
```

### Step 2: Servlet Generates Page with Hidden Fields

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/Step1Servlet")
public class Step1Servlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get data from Step 1
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        // Generate Step 2 form with hidden fields
        pw.println("<html><body>");
        pw.println("<h2>Registration - Step 2</h2>");
        pw.println("<p>Welcome, " + name + "!</p>");
        pw.println("<form action='Step2Servlet' method='post'>");
        
        // Hidden fields carry Step 1 data
        pw.println("<input type='hidden' name='name' value='" + name + "'>");
        pw.println("<input type='hidden' name='email' value='" + email + "'>");
        
        pw.println("Phone: <input type='text' name='phone'><br><br>");
        pw.println("<input type='submit' value='Submit'>");
        pw.println("</form></body></html>");
    }
}
```

### Step 3: Final Servlet Receives All Data

```java
@WebServlet("/Step2Servlet")
public class Step2Servlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get ALL data including hidden fields
        String name = request.getParameter("name");    // From hidden field
        String email = request.getParameter("email");  // From hidden field
        String phone = request.getParameter("phone");  // From visible field
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        pw.println("<html><body>");
        pw.println("<h2>Registration Complete!</h2>");
        pw.println("<p>Name: " + name + "</p>");
        pw.println("<p>Email: " + email + "</p>");
        pw.println("<p>Phone: " + phone + "</p>");
        pw.println("</body></html>");
    }
}
```

---

## ⚠️ Limitations

### Problems with Hidden Fields

| Limitation | Description |
|------------|-------------|
| **Only works with forms** | Can't use with hyperlinks |
| **Not secure** | Value visible in page source (View Source) |
| **Form required on every page** | Breaks if user navigates away |
| **Limited data** | Not suitable for large amounts |
| **Lost on browser back** | Data may be lost if user goes back |

### Security Concern

```html
<!-- User can see this in "View Page Source" -->
<input type="hidden" name="userId" value="123">
<input type="hidden" name="discount" value="50">

<!-- User could modify and resubmit! -->
```

**Never use hidden fields for:**
- Passwords
- Sensitive IDs
- Pricing/discount data
- Security tokens

---

## ✅ Key Takeaways

1. Hidden fields are **invisible to users** but **visible in source**
2. Only work with **form submissions**
3. Good for **multi-step forms**
4. **Not secure** - data can be viewed and modified
5. Better alternatives: **HttpSession**, **Cookies**

---

## 🎤 Interview Questions

**Q1: What are hidden fields and how are they used for session tracking?**
> **A:** Hidden fields are HTML inputs with `type="hidden"` that the user doesn't see. They carry data from one page to another through form submissions. Each page includes hidden fields containing data from previous pages.

**Q2: What are the limitations of hidden fields?**
> **A:**
> - Only work with forms (not hyperlinks)
> - Not secure (visible in page source)
> - Data lost if user navigates away
> - Every page needs a form
> - Not suitable for sensitive data

**Q3: When would you use hidden fields?**
> **A:** For multi-step forms where:
> - Data isn't sensitive
> - All navigation is through form buttons
> - Limited data needs to be carried
> - Server-side session is not preferred

**Q4: Are hidden fields secure?**
> **A:** No. While users don't see them on the page, they're visible in "View Source" and can be modified using browser developer tools before submission.
