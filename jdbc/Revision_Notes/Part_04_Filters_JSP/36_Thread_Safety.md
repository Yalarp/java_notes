# Thread Safety in Servlets

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [The Problem](#the-problem)
3. [What is NOT Thread-Safe](#what-is-not-thread-safe)
4. [Solutions](#solutions)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Servlets are **multi-threaded**. One servlet instance handles multiple concurrent requests, each in a separate thread, creating potential thread-safety issues.

---

## 📖 The Problem

```
                    ┌────────────────────────────────────┐
                    │  MyServlet (1 instance)            │
                    │  instance variable: count = ?      │
Thread-1 ──────────►│                                    │
Thread-2 ──────────►│  All threads share instance vars! │
Thread-3 ──────────►│                                    │
                    └────────────────────────────────────┘
```

---

## 📖 What is NOT Thread-Safe

```java
public class UnsafeServlet extends HttpServlet {
    // ❌ NOT thread-safe - shared
    private int count = 0;           // Instance variable
    private Connection con;          // Shared connection
    private List<String> items;      // Shared collection
}
```

---

## 📖 Solutions

### 1. Use Local Variables

```java
protected void doGet(HttpServletRequest req, HttpServletResponse res) {
    // ✅ Thread-safe - each thread has its own
    int localCount = 0;
    String name = req.getParameter("name");
}
```

### 2. Use Thread-Safe Classes

```java
private AtomicInteger count = new AtomicInteger(0);
private ConcurrentHashMap<String, Object> cache = new ConcurrentHashMap<>();
```

### 3. Synchronize Critical Sections

```java
synchronized(this) {
    count++;
}
```

---

## ✅ Key Takeaways

1. **Instance variables are shared** - NOT thread-safe
2. **Local variables are thread-local** - thread-safe
3. Use **synchronized** or atomic classes for shared state
4. Each request has its own **request/response** objects

---

## 🎤 Interview Questions

**Q1: Why are servlets not thread-safe by default?**
> **A:** One instance with multiple threads. Instance variables are shared causing race conditions.

**Q2: How do you make a servlet thread-safe?**
> **A:** Use local variables, synchronize, or use thread-safe classes like AtomicInteger.
