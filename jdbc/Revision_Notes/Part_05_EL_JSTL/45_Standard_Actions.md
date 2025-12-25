# Standard Actions

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [jsp:useBean](#jspusebean)
3. [jsp:setProperty and getProperty](#jspsetproperty-and-getproperty)
4. [jsp:include](#jspinclude)
5. [jsp:forward](#jspforward)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Standard Actions** are built-in JSP tags with `jsp:` prefix for common tasks.

---

## 📖 jsp:useBean

Creates or retrieves a JavaBean:

```jsp
<jsp:useBean id="user" class="com.example.User" scope="session"/>
```

| Attribute | Description |
|-----------|-------------|
| `id` | Variable name |
| `class` | Fully qualified class name |
| `scope` | page, request, session, application |

---

## 📖 jsp:setProperty and getProperty

```jsp
<%-- Set specific property --%>
<jsp:setProperty name="user" property="name" value="John"/>

<%-- Set from request parameter --%>
<jsp:setProperty name="user" property="email" param="email"/>

<%-- Auto-populate ALL from request --%>
<jsp:setProperty name="user" property="*"/>

<%-- Get property --%>
<jsp:getProperty name="user" property="name"/>
```

---

## 📖 jsp:include

Include page at **request time**:

```jsp
<jsp:include page="header.jsp"/>

<jsp:include page="widget.jsp">
    <jsp:param name="title" value="My Widget"/>
</jsp:include>
```

---

## 📖 jsp:forward

Forward to another page:

```jsp
<jsp:forward page="display.jsp"/>

<jsp:forward page="result.jsp">
    <jsp:param name="status" value="success"/>
</jsp:forward>
```

---

## ✅ Key Takeaways

1. **jsp:useBean** - creates/retrieves JavaBean
2. **jsp:setProperty property="*"** - auto-populate from form
3. **jsp:include** - runtime include (dynamic)
4. **jsp:forward** - server-side forward

---

## 🎤 Interview Questions

**Q1: What does jsp:setProperty property="*" do?**
> **A:** Automatically sets all bean properties from request parameters where names match.

**Q2: Difference between include directive and jsp:include?**
> **A:** Directive is translation-time (static); action is request-time (dynamic).
