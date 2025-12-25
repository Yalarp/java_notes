# Expression Language (EL)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [EL Syntax](#el-syntax)
3. [Implicit Objects](#implicit-objects)
4. [Accessing Properties](#accessing-properties)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Expression Language (EL)** provides a simpler way to access data in JSP without scriptlets.

---

## 📖 EL Syntax

```jsp
${ expression }
```

### Comparison

```jsp
<%-- Scriptlet (old) --%>
<%= ((User)request.getAttribute("user")).getName() %>

<%-- EL (modern) --%>
${user.name}
```

---

## 📖 Implicit Objects

| Object | Description |
|--------|-------------|
| `pageScope` | Page scope attributes |
| `requestScope` | Request scope attributes |
| `sessionScope` | Session scope attributes |
| `applicationScope` | Application scope attributes |
| `param` | Request parameters |
| `paramValues` | Request parameter arrays |
| `cookie` | Cookies |
| `header` | HTTP headers |
| `initParam` | Context init parameters |

---

## 📖 Accessing Properties

```jsp
<%-- Bean property --%>
${user.name}           <%-- Calls user.getName() --%>

<%-- Map entry --%>
${myMap.key}
${myMap["key"]}

<%-- List element --%>
${myList[0]}

<%-- Request parameter --%>
${param.username}
```

---

## ✅ Key Takeaways

1. **EL syntax**: `${expression}`
2. Auto-searches scopes: page → request → session → application
3. Use **dot notation** for beans: `${user.name}`
4. Use **bracket notation** for maps/arrays: `${map["key"]}`

---

## 🎤 Interview Questions

**Q1: What is Expression Language?**
> **A:** EL is a simplified way to access data in JSP using `${expression}` syntax.

**Q2: How does EL access bean properties?**
> **A:** `${user.name}` calls `user.getName()`. Follows JavaBean conventions.
