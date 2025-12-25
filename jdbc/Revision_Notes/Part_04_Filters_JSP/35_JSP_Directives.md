# JSP Directives

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Page Directive](#page-directive)
3. [Include Directive](#include-directive)
4. [Taglib Directive](#taglib-directive)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**JSP Directives** provide instructions to the container about processing the JSP.

| Directive | Purpose |
|-----------|---------|
| `page` | Page-wide settings |
| `include` | Include file content at translation |
| `taglib` | Declare tag library |

---

## 📖 Page Directive

```jsp
<%@ page import="java.util.*, java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="false" %>
<%@ page errorPage="error.jsp" %>
<%@ page isErrorPage="true" %>
```

| Attribute | Description |
|-----------|-------------|
| `import` | Java imports |
| `contentType` | MIME type |
| `session` | Need session? |
| `errorPage` | Error handler JSP |
| `isErrorPage` | Is this error page? |

---

## 📖 Include Directive

```jsp
<%@ include file="header.jsp" %>
<main>Content here</main>
<%@ include file="footer.jsp" %>
```

Includes content at **translation time** (static).

---

## 📖 Taglib Directive

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
```

---

## ✅ Key Takeaways

1. **page**: Page configuration (imports, encoding, error page)
2. **include**: Static file inclusion at translation time
3. **taglib**: Declare tag libraries (JSTL, custom)

---

## 🎤 Interview Questions

**Q1: What is the difference between include directive and jsp:include?**
> **A:** Directive is translation time (static merge); action is request time (dynamic call).

**Q2: What does isErrorPage="true" do?**
> **A:** Makes the `exception` implicit object available in that JSP.
