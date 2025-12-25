# Request Filter

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Request Preprocessing](#request-preprocessing)
3. [Authentication Filter](#authentication-filter)
4. [Logging Filter](#logging-filter)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Request Filters** process the request BEFORE it reaches the servlet. Common uses include authentication, logging, encoding, and validation.

---

## 📖 Request Preprocessing

```java
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
    // ════════════════════════════════════════════
    // REQUEST PREPROCESSING (before servlet)
    // ════════════════════════════════════════════
    
    HttpServletRequest httpReq = (HttpServletRequest) req;
    String uri = httpReq.getRequestURI();
    System.out.println("Incoming request: " + uri);
    
    // Set encoding
    req.setCharacterEncoding("UTF-8");
    
    // Validate, authenticate, etc.
    
    chain.doFilter(req, res);  // Continue to servlet
}
```

---

## 📖 Authentication Filter

```java
@WebFilter("/secure/*")
public class AuthFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpReq = (HttpServletRequest) req;
        HttpServletResponse httpRes = (HttpServletResponse) res;
        HttpSession session = httpReq.getSession(false);
        
        // Check if logged in
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in - redirect to login
            httpRes.sendRedirect(httpReq.getContextPath() + "/login.jsp");
            return;  // Don't call chain.doFilter - block request
        }
        
        // Logged in - continue
        chain.doFilter(req, res);
    }
}
```

---

## 📖 Logging Filter

```java
@WebFilter("/*")
public class LoggingFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpReq = (HttpServletRequest) req;
        
        String method = httpReq.getMethod();
        String uri = httpReq.getRequestURI();
        String ip = httpReq.getRemoteAddr();
        long startTime = System.currentTimeMillis();
        
        System.out.println("[" + method + "] " + uri + " from " + ip);
        
        chain.doFilter(req, res);
        
        long duration = System.currentTimeMillis() - startTime;
        System.out.println("Completed in " + duration + "ms");
    }
}
```

---

## ✅ Key Takeaways

1. Request filters process **before** servlet executes
2. Can **block requests** by not calling chain.doFilter()
3. Can **modify request** (encoding, headers)
4. Common: authentication, logging, validation

---

## 🎤 Interview Questions

**Q1: How do you block a request in a filter?**
> **A:** Don't call `chain.doFilter()`. The request stops at the filter.

**Q2: Can filters modify the request?**
> **A:** Yes. You can wrap the request using `HttpServletRequestWrapper` to modify parameters or headers.
