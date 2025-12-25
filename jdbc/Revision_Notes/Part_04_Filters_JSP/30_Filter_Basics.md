# Filter Basics

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is a Filter](#what-is-a-filter)
3. [Filter Interface](#filter-interface)
4. [Filter Lifecycle](#filter-lifecycle)
5. [FilterChain](#filterchain)
6. [Configuration](#configuration)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Filters** are components that intercept requests and responses, allowing preprocessing and postprocessing for logging, authentication, compression, encryption, and more.

---

## 📖 What is a Filter

A Filter sits **between the client and servlet**, intercepting requests before they reach the servlet and responses before they go to the client.

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────┐
│  Client  │ ──► │ Filter 1 │ ──► │ Filter 2 │ ──► │ Servlet  │
│          │ ◄── │          │ ◄── │          │ ◄── │          │
└──────────┘     └──────────┘     └──────────┘     └──────────┘
```

---

## 📖 Filter Interface

```java
public interface Filter {
    void init(FilterConfig filterConfig) throws ServletException;
    void doFilter(ServletRequest req, ServletResponse res, FilterChain chain);
    void destroy();
}
```

| Method | When Called | Purpose |
|--------|-------------|---------|
| `init()` | Once at startup | Initialize resources |
| `doFilter()` | Each request | Process request/response |
| `destroy()` | Once at shutdown | Clean up resources |

---

## 📖 FilterChain

Calling `chain.doFilter()` passes the request to the next component:

```java
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
    // PREPROCESSING
    System.out.println("Before servlet");
    
    chain.doFilter(req, res);  // Next filter or servlet
    
    // POSTPROCESSING
    System.out.println("After servlet");
}
```

---

## 📖 Configuration

### web.xml

```xml
<filter>
    <filter-name>LoggingFilter</filter-name>
    <filter-class>com.example.LoggingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>LoggingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### @WebFilter Annotation

```java
@WebFilter("/*")
public class LoggingFilter implements Filter { ... }
```

---

## ✅ Key Takeaways

1. Filters **intercept** requests before servlet and responses after
2. **chain.doFilter()** passes to next filter or servlet
3. Code **before** chain.doFilter = preprocessing
4. Code **after** chain.doFilter = postprocessing

---

## 🎤 Interview Questions

**Q1: What is a Filter used for?**
> **A:** Logging, authentication, authorization, compression, encryption, input validation, caching.

**Q2: What happens if you don't call chain.doFilter()?**
> **A:** The request never reaches the servlet. The filter blocks the request.
