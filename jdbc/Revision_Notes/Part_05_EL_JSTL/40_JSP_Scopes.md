# JSP Scopes

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Four Scopes](#four-scopes)
3. [Scope Comparison](#scope-comparison)
4. [Code Examples](#code-examples)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Scopes** define the **lifetime and visibility** of data stored as attributes in JSP/Servlets.

---

## 📖 Four Scopes

| Scope | Object | Visibility | Lifetime |
|-------|--------|------------|----------|
| **Page** | `pageContext` | Current JSP only | Page processing |
| **Request** | `request` | Request + forwards | Until response |
| **Session** | `session` | User's session | Session lifetime |
| **Application** | `application` | All users | App lifetime |

---

## 📖 Scope Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                      APPLICATION SCOPE                       │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                    SESSION SCOPE                        │ │
│  │  ┌───────────────────────────────────────────────────┐ │ │
│  │  │                  REQUEST SCOPE                     │ │ │
│  │  │  ┌──────────────────────────────────────────────┐ │ │ │
│  │  │  │               PAGE SCOPE                      │ │ │ │
│  │  │  └──────────────────────────────────────────────┘ │ │ │
│  │  └───────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 💻 Code Examples

```java
// Request scope
request.setAttribute("user", userObject);

// Session scope
session.setAttribute("username", "John");

// Application scope
getServletContext().setAttribute("appName", "MyApp");
```

### EL Scope Search

EL searches scopes in order: page → request → session → application

```jsp
${name}                    <%-- Searches all scopes --%>
${sessionScope.username}   <%-- Explicit scope --%>
```

---

## ✅ Key Takeaways

1. **Page** = current JSP only
2. **Request** = survives forwards
3. **Session** = user-specific across requests
4. **Application** = all users, entire app

---

## 🎤 Interview Questions

**Q1: What are the four JSP scopes?**
> **A:** Page, Request, Session, Application - ordered from smallest to largest scope.

**Q2: In what order does EL search for attributes?**
> **A:** Page → Request → Session → Application. Returns first match.
