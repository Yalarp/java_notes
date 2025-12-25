# JSP Elements (Scriptlets, Expressions, Declarations)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Scriptlets](#scriptlets)
3. [Expressions](#expressions)
4. [Declarations](#declarations)
5. [Comparison](#comparison)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

JSP provides three scripting elements to embed Java code:

| Element | Syntax | Purpose |
|---------|--------|---------|
| **Scriptlet** | `<% code %>` | Execute Java code |
| **Expression** | `<%= value %>` | Output a value |
| **Declaration** | `<%! code %>` | Declare methods/variables |

---

## 📖 Scriptlets

```jsp
<%
    String name = request.getParameter("name");
    for (int i = 0; i < 5; i++) {
        out.println(i);
    }
%>
```

---

## 📖 Expressions

```jsp
<p>Name: <%= name %></p>
<p>Time: <%= new java.util.Date() %></p>
```

**Note:** No semicolon in expressions!

---

## 📖 Declarations

```jsp
<%!
    private int visitCount = 0;
    
    public String greet(String name) {
        return "Hello, " + name;
    }
%>
```

---

## 📊 Comparison

| Feature | Scriptlet | Expression | Declaration |
|---------|-----------|------------|-------------|
| **Location** | _jspService() | _jspService() | Class level |
| **Semicolon** | Yes | NO | Yes |
| **Output** | Manual | Automatic | No output |

---

## ✅ Key Takeaways

1. **Scriptlet** `<% %>`: Execute code, ends with semicolon
2. **Expression** `<%= %>`: Output value, NO semicolon
3. **Declaration** `<%! %>`: Class-level methods/variables

---

## 🎤 Interview Questions

**Q1: What is the difference between scriptlet and expression?**
> **A:** Scriptlet executes code; Expression evaluates and outputs value. Expression has no semicolon.

**Q2: Where does declaration code appear in the generated servlet?**
> **A:** At class level, outside any method.
