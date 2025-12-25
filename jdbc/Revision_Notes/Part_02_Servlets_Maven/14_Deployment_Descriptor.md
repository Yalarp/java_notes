# Deployment Descriptor and URL Mapping

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [web.xml Structure](#webxml-structure)
3. [Annotations](#annotations-deprecated)
4. [URL Mapping](#url-mapping)
5. [Code Examples](#code-examples)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

The **Deployment Descriptor** (`web.xml`) is an XML configuration file that tells the web container how to deploy and configure your web application. Since Servlet 3.0, most configurations can also be done via **annotations**.

---

## 📖 web.xml Structure

### Location

```
YourWebApp/
├── src/
├── WEB-INF/
│   ├── web.xml         ← Deployment Descriptor
│   ├── lib/            ← JAR files
│   └── classes/        ← Compiled classes
└── index.html
```

### Basic web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    
    <!-- Servlet Definition -->
    <servlet>
        <servlet-name>FirstServlet</servlet-name>
        <servlet-class>com.example.FirstServ</servlet-class>
    </servlet>
    
    <!-- URL Mapping -->
    <servlet-mapping>
        <servlet-name>FirstServlet</servlet-name>
        <url-pattern>/first</url-pattern>
    </servlet-mapping>
    
</web-app>
```

### URL Resolution Flow

```
Client requests: http://localhost:8080/app/first
                                          │
                                          ▼
                    Container reads web.xml
                                          │
                                          ▼
                    Finds url-pattern: /first
                                          │
                                          ▼
                    Gets servlet-name: FirstServlet
                                          │
                                          ▼
                    Gets servlet-class: com.example.FirstServ
                                          │
                                          ▼
                    Loads and executes servlet
```

---

## 📖 @WebServlet Annotation

### Modern Approach (Servlet 3.0+)

Instead of web.xml, use annotations directly in your class:

```java
@WebServlet("/FirstServ")
public class FirstServ extends HttpServlet {
    // ...
}
```

### Annotation vs web.xml

| Aspect | web.xml | @WebServlet |
|--------|---------|-------------|
| Configuration | External file | In Java code |
| Flexibility | Change without recompile | Requires recompile |
| Maintenance | Separate file | Same file as code |
| IDE Support | Manual sync needed | Auto-complete |
| Best For | Complex deployments | Simple mappings |

### @WebServlet Attributes

```java
@WebServlet(
    name = "MyServlet",           // Servlet name (optional)
    urlPatterns = {"/path1", "/path2"},  // Multiple URL patterns
    loadOnStartup = 1,            // Eager loading
    initParams = {
        @WebInitParam(name = "key", value = "value")
    }
)
public class MyServlet extends HttpServlet { }
```

---

## 📖 URL Mapping Patterns

### Pattern Types

| Pattern | Example | Matches |
|---------|---------|---------|
| **Exact** | `/login` | Only `/login` |
| **Directory** | `/admin/*` | `/admin/anything` |
| **Extension** | `*.do` | `/anything.do` |
| **Default** | `/` | All unmatched URLs |

### Examples

```xml
<!-- Exact match -->
<url-pattern>/login</url-pattern>
<!-- Matches: /login -->
<!-- Doesn't match: /Login, /login/, /login/page -->

<!-- Directory match (wildcard) -->
<url-pattern>/admin/*</url-pattern>
<!-- Matches: /admin, /admin/users, /admin/a/b/c -->

<!-- Extension match -->
<url-pattern>*.do</url-pattern>
<!-- Matches: /anything.do, /path/action.do -->
<!-- Doesn't match: /action.do.txt -->

<!-- Default servlet -->
<url-pattern>/</url-pattern>
<!-- Matches: everything not matched by other patterns -->
```

---

## 💻 Code Examples

### Using web.xml

**web.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="4.0"
         xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                             http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd">
    
    <!-- Define servlet -->
    <servlet>
        <servlet-name>PersonServlet</servlet-name>
        <servlet-class>com.example.PersonServ</servlet-class>
    </servlet>
    
    <!-- Map URL to servlet -->
    <servlet-mapping>
        <servlet-name>PersonServlet</servlet-name>
        <url-pattern>/PersonServ</url-pattern>
    </servlet-mapping>
    
    <!-- Welcome file list -->
    <welcome-file-list>
        <welcome-file>index.html</welcome-file>
        <welcome-file>index.jsp</welcome-file>
    </welcome-file-list>
    
</web-app>
```

### Using @WebServlet

```java
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/PersonServ")  // This replaces web.xml mapping
public class PersonServ extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();
        
        String name = request.getParameter("name");
        int age = Integer.parseInt(request.getParameter("age").trim());
        
        pw.println(name + " " + age);
    }
}
```

---

## ✅ Key Takeaways

1. **web.xml** is the traditional deployment descriptor
2. **@WebServlet** is the modern annotation approach (Servlet 3.0+)
3. **servlet-name** links servlet definition to URL mapping
4. **URL patterns**: exact (`/path`), directory (`/path/*`), extension (`*.do`)
5. **Both methods work** - can combine for complex configurations
6. Annotations require **no web.xml** for basic mappings

---

## 🎤 Interview Questions

**Q1: What is the deployment descriptor?**
> **A:** The deployment descriptor (`web.xml`) is an XML file in `WEB-INF/` that configures servlet mappings, initialization parameters, security constraints, and other deployment settings.

**Q2: How does the container resolve a URL to a servlet?**
> **A:** 
> 1. Container reads `web.xml` or scans annotations
> 2. Matches URL against `url-pattern`
> 3. Finds `servlet-name` from mapping
> 4. Gets `servlet-class` from servlet definition
> 5. Loads and executes the servlet

**Q3: What is the difference between @WebServlet and web.xml?**
> **A:** 
> - `@WebServlet`: Annotations in Java code, requires recompile to change, simpler for basic cases
> - `web.xml`: External file, can change without recompile, more verbose but flexible

**Q4: Explain URL pattern matching precedence.**
> **A:** 
> 1. **Exact match** checked first (`/login`)
> 2. **Longest path match** (`/admin/users/*` before `/admin/*`)
> 3. **Extension match** (`*.jsp`)
> 4. **Default servlet** (`/`) as fallback
