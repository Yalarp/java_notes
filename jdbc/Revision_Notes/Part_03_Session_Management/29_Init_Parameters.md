# Init Parameters (ServletConfig & ServletContext)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [ServletConfig](#servletconfig)
3. [ServletContext](#servletcontext)
4. [Comparison](#comparison)
5. [Code Examples](#code-examples)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Init parameters** are configuration values defined in `web.xml` or annotations that can be read by servlets. They allow externalizing configuration without hardcoding values.

| Type | Scope | Interface |
|------|-------|-----------|
| **ServletConfig** | Single servlet | `ServletConfig` |
| **ServletContext** | Entire application | `ServletContext` |

---

## 📖 ServletConfig

### Definition

**ServletConfig** provides configuration information specific to a **single servlet**.

### Configuration in web.xml

```xml
<servlet>
    <servlet-name>MyServlet</servlet-name>
    <servlet-class>com.example.MyServlet</servlet-class>
    <init-param>
        <param-name>adminEmail</param-name>
        <param-value>admin@example.com</param-value>
    </init-param>
    <init-param>
        <param-name>pageSize</param-name>
        <param-value>20</param-value>
    </init-param>
</servlet>
```

### Reading Parameters

```java
public class MyServlet extends HttpServlet {
    
    private String adminEmail;
    private int pageSize;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        adminEmail = config.getInitParameter("adminEmail");
        pageSize = Integer.parseInt(config.getInitParameter("pageSize"));
    }
}
```

---

## 📖 ServletContext

### Definition

**ServletContext** represents the **entire web application**. Parameters defined here are available to ALL servlets.

### Configuration in web.xml

```xml
<web-app>
    <context-param>
        <param-name>companyName</param-name>
        <param-value>My Company Inc.</param-value>
    </context-param>
    <context-param>
        <param-name>dbUrl</param-name>
        <param-value>jdbc:mysql://localhost:3306/mydb</param-value>
    </context-param>
</web-app>
```

### Reading Context Parameters

```java
public class AnyServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) {
        ServletContext context = getServletContext();
        String company = context.getInitParameter("companyName");
        String dbUrl = context.getInitParameter("dbUrl");
    }
}
```

---

## 📊 Comparison

| Aspect | ServletConfig | ServletContext |
|--------|--------------|----------------|
| **Scope** | Single servlet | Entire application |
| **Defined in** | `<servlet>/<init-param>` | `<context-param>` |
| **Access** | One servlet only | All servlets |
| **Get method** | `getServletConfig().getInitParameter()` | `getServletContext().getInitParameter()` |

---

## 💻 Code Examples

### Complete web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" version="4.0">
    
    <context-param>
        <param-name>dbUrl</param-name>
        <param-value>jdbc:mysql://localhost:3306/mydb</param-value>
    </context-param>
    
    <servlet>
        <servlet-name>UserServlet</servlet-name>
        <servlet-class>com.example.UserServlet</servlet-class>
        <init-param>
            <param-name>defaultRole</param-name>
            <param-value>guest</param-value>
        </init-param>
    </servlet>
    
</web-app>
```

### Reading Both Types

```java
@WebServlet("/ConfigDemo")
public class ConfigDemo extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        // Servlet-specific
        ServletConfig config = getServletConfig();
        
        // Application-wide
        ServletContext context = getServletContext();
        
        pw.println("<h2>Configuration</h2>");
        pw.println("<p>DB URL: " + context.getInitParameter("dbUrl") + "</p>");
        pw.println("<p>Servlet Name: " + config.getServletName() + "</p>");
    }
}
```

---

## ✅ Key Takeaways

1. **ServletConfig** = servlet-specific, `<init-param>` inside `<servlet>`
2. **ServletContext** = application-wide, `<context-param>` at root level
3. Context parameters accessible from **ALL** servlets
4. Config parameters accessible only from **owning** servlet

---

## 🎤 Interview Questions

**Q1: What is the difference between ServletConfig and ServletContext?**
> **A:**
> - **ServletConfig**: Per-servlet configuration, accessible only by that servlet
> - **ServletContext**: Per-application configuration, accessible by all servlets

**Q2: Where do you define init parameters in web.xml?**
> **A:**
> - ServletConfig params: Inside `<servlet>` → `<init-param>`
> - ServletContext params: At root `<web-app>` → `<context-param>`

**Q3: Can you change init parameters at runtime?**
> **A:** No. Init parameters are read-only. To change, modify web.xml and redeploy.
