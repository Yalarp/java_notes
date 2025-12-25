# Error Pages

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Error Attributes](#error-attributes)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Error pages** define custom responses for HTTP errors and exceptions instead of default container error pages.

---

## 📖 Configuration

### HTTP Error Codes

```xml
<error-page>
    <error-code>404</error-code>
    <location>/error/404.jsp</location>
</error-page>

<error-page>
    <error-code>500</error-code>
    <location>/error/500.jsp</location>
</error-page>
```

### Exception Types

```xml
<error-page>
    <exception-type>java.lang.NullPointerException</exception-type>
    <location>/error/null-error.jsp</location>
</error-page>

<error-page>
    <exception-type>java.lang.Exception</exception-type>
    <location>/error/generic-error.jsp</location>
</error-page>
```

---

## 📖 Error Attributes

Available in error pages via request:

```jsp
Status: <%= request.getAttribute("jakarta.servlet.error.status_code") %>
URI: <%= request.getAttribute("jakarta.servlet.error.request_uri") %>
Message: <%= request.getAttribute("jakarta.servlet.error.message") %>
Exception: <%= request.getAttribute("jakarta.servlet.error.exception") %>
```

### 404.jsp Example

```jsp
<%@ page isErrorPage="true" %>
<html>
<body>
    <h1>404 - Page Not Found</h1>
    <p>Requested: <%= request.getAttribute("jakarta.servlet.error.request_uri") %></p>
    <a href="/">Go Home</a>
</body>
</html>
```

---

## ✅ Key Takeaways

1. Use `<error-code>` for HTTP errors (404, 500)
2. Use `<exception-type>` for Java exceptions
3. Error attributes available via request
4. Use `isErrorPage="true"` for exception access

---

## 🎤 Interview Questions

**Q1: How do you configure custom 404 page?**
> **A:** Using `<error-page><error-code>404</error-code><location>/path</location></error-page>`

**Q2: What is the difference between error-code and exception-type?**
> **A:** error-code handles HTTP status codes; exception-type handles Java exceptions.
