# JSP Introduction

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is JSP](#what-is-jsp)
3. [JSP vs Servlet](#jsp-vs-servlet)
4. [How JSP Works](#how-jsp-works)
5. [JSP Lifecycle](#jsp-lifecycle)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**JavaServer Pages (JSP)** is a server-side technology that simplifies creating dynamic web content by embedding Java code in HTML.

---

## 📖 What is JSP

JSP is an **HTML page with embedded Java code**. It gets converted to a servlet behind the scenes.

```jsp
<!DOCTYPE html>
<html>
<body>
    <h1>Welcome</h1>
    <p>Current time: <%= new java.util.Date() %></p>
</body>
</html>
```

---

## 📖 JSP vs Servlet

| Feature | Servlet | JSP |
|---------|---------|-----|
| **Primary** | Java with HTML | HTML with Java |
| **Best for** | Controller logic | View/presentation |
| **Compilation** | Manual | Automatic |

---

## 📖 How JSP Works

```
┌─────────────┐  Translation  ┌─────────────┐  Compile  ┌─────────────┐
│  hello.jsp  │ ───────────► │ hello_jsp   │ ────────► │ hello_jsp   │
│             │              │   .java     │           │  .class     │
└─────────────┘              └─────────────┘           └─────────────┘
```

1. First request: Container translates JSP to servlet
2. Servlet compiled to .class
3. Subsequent requests: Compiled servlet reused (fast)

---

## 📖 JSP Lifecycle

| Method | When Called |
|--------|-------------|
| `jspInit()` | Once, after loading |
| `_jspService()` | For each request |
| `jspDestroy()` | Once, before destruction |

---

## ✅ Key Takeaways

1. JSP = HTML with embedded Java
2. JSP is **translated to servlet** by container
3. First request is slow (translation + compilation)
4. Use JSP for views, servlets for controllers

---

## 🎤 Interview Questions

**Q1: What is JSP and how is it different from Servlet?**
> **A:** JSP is HTML with embedded Java; Servlets are Java with HTML. JSP is easier for views, gets converted to Servlet internally.

**Q2: Why is the first request to a JSP slow?**
> **A:** Container must translate to servlet, compile, and load. Subsequent requests use cached class.
