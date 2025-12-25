# Tag Files

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Creating Tag Files](#creating-tag-files)
3. [Attributes](#attributes)
4. [Body Content](#body-content)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Tag Files** are JSP files that become custom tags. Simpler than Java-based tag handlers.

---

## 📖 Creating Tag Files

### Location

Place in `/WEB-INF/tags/` directory.

### hello.tag

```jsp
<%@ tag description="Says hello" pageEncoding="UTF-8"%>
<%@ attribute name="name" required="true" %>

<div class="greeting">
    <h2>Hello, ${name}!</h2>
</div>
```

### Usage

```jsp
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>

<my:hello name="John"/>
```

---

## 📖 Attributes

### Defining Attributes

```jsp
<%@ attribute name="title" required="true" %>
<%@ attribute name="color" required="false" %>
<%@ attribute name="admin" type="java.lang.Boolean" %>

<h3 style="color: ${empty color ? 'black' : color}">${title}</h3>
```

---

## 📖 Body Content

### panel.tag

```jsp
<%@ tag description="Panel component" %>
<%@ attribute name="title" required="true" %>

<div class="panel">
    <div class="panel-header">${title}</div>
    <div class="panel-body">
        <jsp:doBody/>  <%-- Renders body content --%>
    </div>
</div>
```

### Usage

```jsp
<my:panel title="Important">
    <p>This is panel content.</p>
</my:panel>
```

---

## ✅ Key Takeaways

1. Tag files go in `/WEB-INF/tags/`
2. Use `<%@ attribute %>` for tag attributes
3. Use `<jsp:doBody/>` for body content
4. Use `tagdir` in JSP to reference

---

## 🎤 Interview Questions

**Q1: What are tag files?**
> **A:** JSP files that become custom tags. Simpler alternative to Java-based tag handlers.

**Q2: Where do you place tag files?**
> **A:** In `/WEB-INF/tags/` directory.
