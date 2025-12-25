# Load-on-Startup

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Load Order](#load-order)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

By default, servlets are loaded **on first request** (lazy). **Load-on-Startup** forces loading when the server **starts up**.

---

## 📖 Default vs Eager Loading

| Default (Lazy) | Load-on-Startup |
|----------------|-----------------|
| Load on first request | Load at startup |
| First user waits | Ready immediately |
| Delay in init() | Init done before requests |

---

## 📖 Configuration

### web.xml

```xml
<servlet>
    <servlet-name>InitServlet</servlet-name>
    <servlet-class>com.example.InitServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
```

### Annotation

```java
@WebServlet(urlPatterns = "/init", loadOnStartup = 1)
public class InitServlet extends HttpServlet { }
```

---

## 📖 Load Order

| Value | Behavior |
|-------|----------|
| **< 0 or absent** | Lazy load (on first request) |
| **0** | Eager load, no specific order |
| **1, 2, 3...** | Eager load in numeric order (1 first) |

---

## ✅ Key Takeaways

1. **load-on-startup**: Load when server starts
2. **Lower numbers** load first
3. Good for expensive init() operations
4. Eliminates first-user delay

---

## 🎤 Interview Questions

**Q1: What is load-on-startup?**
> **A:** Configuration to load servlet at server startup instead of first request, eliminating first-user delay.

**Q2: What values can load-on-startup have?**
> **A:** Negative/absent = lazy; 0+ = eager; positive values specify order (lower first).
