# JSTL Core Tags

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Core Tags](#core-tags)
4. [Iteration](#iteration)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**JSTL (JSP Standard Tag Library)** provides standard tags for common tasks, eliminating scriptlets.

---

## 📖 Setup

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
```

---

## 📖 Core Tags

### c:out - Output

```jsp
<c:out value="${message}"/>
<c:out value="${user.name}" default="Guest"/>
```

### c:set - Set Variable

```jsp
<c:set var="count" value="10"/>
<c:set var="username" value="John" scope="session"/>
```

### c:if - Conditional

```jsp
<c:if test="${user != null}">
    <p>Welcome, ${user.name}!</p>
</c:if>
```

### c:choose - Multiple Conditions

```jsp
<c:choose>
    <c:when test="${score >= 90}">Grade: A</c:when>
    <c:when test="${score >= 80}">Grade: B</c:when>
    <c:otherwise>Grade: F</c:otherwise>
</c:choose>
```

---

## 📖 Iteration

### c:forEach

```jsp
<c:forEach var="item" items="${itemList}">
    <p>${item}</p>
</c:forEach>

<c:forEach var="item" items="${list}" varStatus="status">
    <p>${status.index}: ${item}</p>
</c:forEach>

<c:forEach var="i" begin="1" end="5">
    <p>Number: ${i}</p>
</c:forEach>
```

### c:url - URL Building

```jsp
<c:url var="searchUrl" value="/search">
    <c:param name="q" value="java"/>
</c:url>
<a href="${searchUrl}">Search</a>
```

---

## ✅ Key Takeaways

1. **c:out** - output with XSS protection
2. **c:set** - set variables
3. **c:if** - simple conditional (no else)
4. **c:choose/when/otherwise** - multiple conditions
5. **c:forEach** - iterate collections

---

## 🎤 Interview Questions

**Q1: What's the difference between c:if and c:choose?**
> **A:** c:if is single condition with no else; c:choose/when/otherwise supports multiple conditions.

**Q2: Why use c:out instead of ${value}?**
> **A:** c:out escapes HTML by default, preventing XSS attacks.
