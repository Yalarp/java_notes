# 🚀 Advanced Java - Complete World-Class Notes

> **Comprehensive Revision Guide** covering JDBC, Servlets, JSP, Hibernate & Jakarta EE  
> 📅 8 Days of Content | 🎯 Exam + Viva Ready | 💡 Memory Tricks Included

---

## 📑 Table of Contents

1. [Day 1: JDBC - Java Database Connectivity](#day-1-jdbc---java-database-connectivity)
2. [Day 2: Servlets & Web Application Structure](#day-2-servlets--web-application-structure)
3. [Day 3: Servlet Parameters, Forward/Redirect & Session Management](#day-3-servlet-parameters-forwardredirect--session-management)
4. [Day 4: Filters, Thread Safety & Load Balancing](#day-4-filters-thread-safety--load-balancing)
5. [Day 5: JSP - Java Server Pages](#day-5-jsp---java-server-pages)
6. [Day 6: JSP Scopes, EL & JSTL](#day-6-jsp-scopes-el--jstl)
7. [Day 7: MVC Architecture & Custom Tags](#day-7-mvc-architecture--custom-tags)
8. [Day 8: Hibernate ORM Framework](#day-8-hibernate-orm-framework)

---

# Day 1: JDBC - Java Database Connectivity

## 🎯 What is JDBC?

```
┌─────────────────────────────────────────────────────────────────┐
│  JDBC = Java Database Connectivity                              │
│  ▸ Standard Java API to connect with relational databases      │
│  ▸ Acts as BRIDGE between Java application and database        │
│  ▸ Located in java.sql and javax.sql packages                  │
└─────────────────────────────────────────────────────────────────┘
```

### JDBC Architecture Flow

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  Java            │ ──▶ │  JDBC API        │ ──▶ │  JDBC Driver     │ ──▶ │  Database        │
│  Application     │     │  (Interfaces)    │     │  (Implementation)│     │  (MySQL/Oracle)  │
└──────────────────┘     └──────────────────┘     └──────────────────┘     └──────────────────┘
```

## 🔌 Types of JDBC Drivers

| Type | Name | Description | Speed | Usage |
|:----:|------|-------------|:-----:|-------|
| **Type 1** | JDBC-ODBC Bridge | Uses ODBC, Deprecated after JDK 8 | Slow | ❌ Obsolete |
| **Type 2** | Native API | Requires client libraries | Medium | ❌ Not Portable |
| **Type 3** | Network Protocol | Uses middleware server | Medium | ⚠️ Extra Layer |
| **Type 4** | Thin Driver ⭐ | Pure Java, Direct to DB | **Fastest** | ✅ **Most Used** |

> 💡 **Memory Trick**: "**Type 4 = Pure Four-ever Java**" - Pure Java, Fast, Preferred Forever!

## 🔗 Database URL Format

```java
jdbc:mysql://localhost:3306/mydb
│     │      │          │    │
│     │      │          │    └── Database Name
│     │      │          └─────── Port Number
│     │      └────────────────── Server/Host
│     └───────────────────────── Database Type
└─────────────────────────────── Protocol
```

## 📊 JDBC Interfaces Comparison

### Statement vs PreparedStatement vs CallableStatement

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              JDBC STATEMENTS                                 │
├─────────────────────┬─────────────────────┬─────────────────────────────────┤
│     Statement       │  PreparedStatement  │     CallableStatement           │
├─────────────────────┼─────────────────────┼─────────────────────────────────┤
│ Static SQL          │ Dynamic SQL         │ Stored Procedures               │
│ No placeholders     │ Uses ? placeholders │ IN, OUT, INOUT params           │
│ Compiled each time  │ Compiled ONCE ⭐    │ Executes inside DB              │
│ Slower              │ FASTER ⭐           │ Fastest for complex ops         │
│ SQL Injection ⚠️    │ SAFE ✅             │ SAFE ✅                         │
└─────────────────────┴─────────────────────┴─────────────────────────────────┘
```

### Code Comparison

```java
// ❌ Statement - NOT Recommended
Statement stmt = con.createStatement();
String sql = "SELECT * FROM users WHERE id = " + userId; // SQL Injection Risk!
ResultSet rs = stmt.executeQuery(sql);

// ✅ PreparedStatement - RECOMMENDED
PreparedStatement pstmt = con.prepareStatement("SELECT * FROM users WHERE id = ?");
pstmt.setInt(1, userId);
ResultSet rs = pstmt.executeQuery();

// ✅ CallableStatement - For Stored Procedures
CallableStatement cstmt = con.prepareCall("{call getUser(?)}");
cstmt.setInt(1, userId);
ResultSet rs = cstmt.executeQuery();
```

## 📈 executeQuery() vs executeUpdate()

| Method | Used For | Returns |
|--------|----------|---------|
| `executeQuery()` | SELECT statements | `ResultSet` |
| `executeUpdate()` | INSERT, UPDATE, DELETE | `int` (rows affected) |

## 🔄 Transaction Management

```java
// Manual Transaction Control
con.setAutoCommit(false);  // Disable auto-commit

try {
    // Database operations
    pstmt1.executeUpdate();
    pstmt2.executeUpdate();
    
    con.commit();    // ✅ Save permanently
} catch (SQLException e) {
    con.rollback();  // ❌ Undo all changes
}
```

> 💡 **Viva Point**: `commit()` saves changes permanently, `rollback()` cancels changes on error.

---

# Day 2: Servlets & Web Application Structure

## 🌐 Static vs Dynamic Content

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         WEB CONTENT TYPES                                    │
├─────────────────────────────────┬───────────────────────────────────────────┤
│          STATIC                 │              DYNAMIC                       │
├─────────────────────────────────┼───────────────────────────────────────────┤
│ Same response for all users     │ Different response per user               │
│ No processing logic             │ Business logic involved                   │
│ Example: Simple HTML page       │ Example: Login page, Registration         │
└─────────────────────────────────┴───────────────────────────────────────────┘
```

## 🆚 Servlet/JSP vs CGI

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      CGI vs SERVLET/JSP                                      │
├──────────────────────────────────┬──────────────────────────────────────────┤
│             CGI                  │           SERVLET/JSP                     │
├──────────────────────────────────┼──────────────────────────────────────────┤
│ New PROCESS per request          │ New THREAD per request ⭐                │
│ Heavy weight                     │ Light weight                             │
│ Slow performance                 │ Fast performance ⭐                      │
│ More memory usage                │ Less memory usage                        │
│ Poor scalability                 │ Better scalability ⭐                    │
└──────────────────────────────────┴──────────────────────────────────────────┘
```

> 💡 **Memory Trick**: "**CGI = Creating Giant Instances**" (heavy processes), "**Servlet = Swift Light Threads**"

## 📦 Servlet Hierarchy

```
          ┌────────────────────┐
          │   Servlet          │  ◀── Interface (parent)
          │   (Interface)      │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │  GenericServlet    │  ◀── Protocol Independent
          │  (Abstract Class)  │
          └─────────┬──────────┘
                    │
          ┌─────────▼──────────┐
          │   HttpServlet      │  ◀── HTTP Protocol (MOST USED ⭐)
          │  (Abstract Class)  │
          └────────────────────┘
```

## 🔄 Servlet Life Cycle

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SERVLET LIFE CYCLE                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│    ┌─────────┐        ┌─────────┐        ┌─────────────────┐                │
│    │ init()  │ ─────▶ │service()│ ─────▶ │ doGet()/doPost()│                │
│    │ [ONCE]  │        │ [EVERY  │        │  [EVERY REQUEST]│                │
│    └─────────┘        │ REQUEST]│        └─────────────────┘                │
│         │             └─────────┘                                           │
│         │                                       │                           │
│         │                                       │                           │
│         │             ┌───────────┐             │                           │
│         └───────────▶ │ destroy() │ ◀───────────┘                           │
│                       │  [ONCE]   │                                         │
│                       └───────────┘                                         │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

✦ init()     → Called ONCE when servlet is loaded (initialization)
✦ service()  → Called for EVERY request (delegates to doGet/doPost)
✦ destroy()  → Called ONCE when server shuts down (cleanup)
```

## 📂 Web Application Structure

```
webapps/
└── myapp/                          ◀── Context Name (appears in URL)
    ├── index.html                  ◀── PUBLIC resources (client accessible)
    ├── login.jsp                   ◀── PUBLIC resources
    │
    └── WEB-INF/                    ◀── PRIVATE (NOT directly accessible ⭐)
        ├── web.xml                 ◀── Deployment Descriptor (HEART of app)
        ├── classes/                ◀── Compiled .class files
        │   └── mypack/
        │       └── MyServlet.class
        │
        └── lib/                    ◀── JAR files (dependencies)
            └── mysql-connector.jar
```

> 🚨 **IMPORTANT**: If user tries to access `WEB-INF` via URL → **404 Error**!

## 🔧 Maven - Build & Dependency Management

### Maven Repository Search Order

```
     ┌─────────────────┐
     │ 1. LOCAL REPO   │ ◀── c:\users\username\.m2\repository
     │    (First)      │
     └────────┬────────┘
              │ Not Found?
              ▼
     ┌─────────────────┐
     │ 2. CENTRAL REPO │ ◀── Maven Community (Internet)
     │    (Second)     │
     └────────┬────────┘
              │ Not Found?
              ▼
     ┌─────────────────┐
     │ 3. REMOTE REPO  │ ◀── Custom/Organization Repo
     │    (Third)      │
     └─────────────────┘
```

### POM.xml - Project Object Model

```xml
<project>
    <groupId>com.company.bank</groupId>      <!-- Organization -->
    <artifactId>consumer-banking</artifactId> <!-- Project Name -->
    <version>1.0</version>                    <!-- Version -->
    
    <dependencies>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.28</version>
        </dependency>
    </dependencies>
</project>
```

> 💡 **Unique ID**: `groupId : artifactId : version` uniquely identifies any Maven project

---

# Day 3: Servlet Parameters, Forward/Redirect & Session Management

## 📋 Types of Parameters

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SERVLET PARAMETERS                                 │
├─────────────────────┬─────────────────────┬─────────────────────────────────┤
│  REQUEST Parameter  │   INIT Parameter    │     CONTEXT Parameter           │
├─────────────────────┼─────────────────────┼─────────────────────────────────┤
│ From: Client/Form   │ From: web.xml       │ From: web.xml                   │
│ Scope: One request  │ Scope: One servlet  │ Scope: Whole application        │
│ Object: HttpServlet │ Object: Servlet     │ Object: ServletContext          │
│         Request     │         Config      │                                 │
│ Method: getParam()  │ Method: getInitPar()│ Method: getInitParameter()      │
└─────────────────────┴─────────────────────┴─────────────────────────────────┘
```

> 💡 **Memory Trick**: "**Request = User data, Config = Servlet data, Context = App data**"

## 🔄 Parameter vs Attribute

| Feature | Parameter | Attribute |
|---------|-----------|-----------|
| **Read/Write** | Read-only | Read & Write |
| **Set By** | Client/web.xml | Servlet code |
| **Data Type** | String only | Any Java Object |
| **Purpose** | Input/Config | Data Sharing |
| **Methods** | `getParameter()` | `setAttribute()`, `getAttribute()` |

## ↔️ Forward vs Redirect

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       FORWARD vs REDIRECT                                    │
├─────────────────────────────────────┬───────────────────────────────────────┤
│            FORWARD                  │            REDIRECT                    │
├─────────────────────────────────────┼───────────────────────────────────────┤
│ SERVER-side transfer                │ CLIENT-side transfer                  │
│ Same request & response             │ NEW request created                   │
│ URL does NOT change                 │ URL CHANGES                           │
│ Data sharing possible               │ Data is LOST                          │
│ FASTER                              │ Slower (extra round trip)             │
│ RequestDispatcher.forward()         │ response.sendRedirect()               │
│ Use: Internal (MVC)                 │ Use: External URLs, Prevent resubmit  │
└─────────────────────────────────────┴───────────────────────────────────────┘
```

### Visual Flow

```
FORWARD:                              REDIRECT:
┌────────┐     ┌──────────┐          ┌────────┐     ┌──────────┐     ┌────────┐
│ Client │ ──▶ │ Servlet1 │          │ Client │ ──▶ │ Servlet1 │ ──▶ │ Client │
└────────┘     └────┬─────┘          └────────┘     └──────────┘     └────┬───┘
                    │ (internal)                                          │ (new request)
               ┌────▼─────┐                                         ┌─────▼────┐
               │ Servlet2 │                                         │ Servlet2 │
               └────┬─────┘                                         └────┬─────┘
                    │                                                    │
               ┌────▼─────┐                                         ┌────▼─────┐
               │ Response │                                         │ Response │
               └──────────┘                                         └──────────┘
```

## 🔐 Session Tracking Techniques

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      SESSION TRACKING TECHNIQUES                             │
├───────────────────┬─────────────────────────────────────────────────────────┤
│                   │                                                          │
│  ┌─────────────┐  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   HIDDEN    │  │  │   COOKIES   │  │ HttpSession │  │    URL      │     │
│  │   FIELDS    │  │  │             │  │     ⭐      │  │ REWRITING   │     │
│  └──────┬──────┘  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘     │
│         │         │         │                │                │            │
│ Storage: HTML     │ Storage: Client   Storage: Server    Storage: URL      │
│ Data: String      │ Data: String      Data: Any Object   Data: Session ID  │
│ Security: ❌ Low  │ Security: ❌ Low  Security: ✅ HIGH  Security: ❌ Low  │
│                   │                                                          │
└───────────────────┴─────────────────────────────────────────────────────────┘
```

### Cookie Example

```java
// Creating Cookie (Response)
Cookie c = new Cookie("username", "John");
c.setMaxAge(3600);           // 1 hour (persistent)
response.addCookie(c);

// Reading Cookie (Request)
Cookie[] cookies = request.getCookies();
for(Cookie cookie : cookies) {
    if(cookie.getName().equals("username")) {
        String user = cookie.getValue();
    }
}
```

### HttpSession Example

```java
// Creating/Getting Session
HttpSession session = request.getSession();     // Create or get
HttpSession session = request.getSession(false);// Get only, or null

// Storing Data
session.setAttribute("user", userObject);       // Can store ANY object!

// Reading Data
Object obj = session.getAttribute("user");

// Session Timeout
session.setMaxInactiveInterval(300);  // 5 minutes (in seconds)

// Destroying Session (Logout)
session.invalidate();
```

### URL Rewriting

```java
// When cookies are disabled
String url = response.encodeURL("nextPage.jsp");
// Output: nextPage.jsp;jsessionid=ABC123
```

> 💡 **Viva Point**: "HttpSession is server-side, secure, stores objects. Cookie is client-side, stores text only."

---

# Day 4: Filters, Thread Safety & Load Balancing

## 🔍 Servlet Filters

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        FILTER EXECUTION FLOW                                 │
│                                                                              │
│  Client ──▶ Filter1 ──▶ Filter2 ──▶ SERVLET ──▶ Filter2 ──▶ Filter1 ──▶ Client │
│             ▲                         │                          │          │
│             │     REQUEST FLOW        │      RESPONSE FLOW       │          │
│             └─────────────────────────┴──────────────────────────┘          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Filter Types

```java
// REQUEST FILTER - Logic BEFORE chain.doFilter()
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
    // ✅ REQUEST FILTER LOGIC (runs BEFORE servlet)
    String user = req.getParameter("user");
    if(user.equals("admin")) {
        chain.doFilter(req, res);  // Allow request
    } else {
        out.println("Access Denied"); // Block request
    }
}

// RESPONSE FILTER - Logic AFTER chain.doFilter()
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
    chain.doFilter(req, res);  // Let servlet execute first
    
    // ✅ RESPONSE FILTER LOGIC (runs AFTER servlet)
    PrintWriter out = res.getWriter();
    out.println("<!-- Response modified by filter -->");
}
```

### Filter Interface Methods

| Method | When Called | Purpose |
|--------|-------------|---------|
| `init(FilterConfig)` | Once (loading) | Initialization |
| `doFilter()` | Every request | Main filter logic |
| `destroy()` | Once (unloading) | Cleanup |

## 🧵 Thread Safety in Servlets

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SERVLET THREADING MODEL                                   │
│                                                                              │
│     ┌──────────────────────────────────────────────────────────────┐        │
│     │                    SINGLE SERVLET INSTANCE                    │        │
│     │  ┌────────────┐         (Shared Object)                      │        │
│     │  │  Instance  │ ◀── NOT Thread-Safe ⚠️                       │        │
│     │  │  Variables │                                              │        │
│     │  └────────────┘                                              │        │
│     │                                                              │        │
│     │   ┌──────────┐  ┌──────────┐  ┌──────────┐                  │        │
│     │   │ Thread 1 │  │ Thread 2 │  │ Thread 3 │                  │        │
│     │   │ (Request1)│  │ (Request2)│  │ (Request3)│                  │        │
│     │   │  Local    │  │  Local    │  │  Local    │ ◀── Thread-Safe ✅│        │
│     │   │  Variables│  │  Variables│  │  Variables│                  │        │
│     │   └──────────┘  └──────────┘  └──────────┘                  │        │
│     └──────────────────────────────────────────────────────────────┘        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Thread Safety Rules

```java
// ❌ NOT THREAD-SAFE - Instance Variable
public class TestServlet extends HttpServlet {
    int count = 0;  // SHARED by all threads!
    
    protected void doGet(...) {
        count++;    // ⚠️ Race condition!
    }
}

// ✅ THREAD-SAFE - Local Variable
public class TestServlet extends HttpServlet {
    protected void doGet(...) {
        int count = 0;  // Each thread gets own copy
        count++;        // ✅ Safe!
    }
}
```

| Safe to Share | NOT Safe to Share |
|---------------|-------------------|
| Constants (`final`) | Instance variables |
| Read-only objects | Mutable objects |
| Configuration data | Database connections |
| | I/O streams |

## ⚖️ Load Balancing

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        LOAD BALANCING                                        │
│                                                                              │
│                    ┌─────────────────┐                                      │
│                    │  Client Requests │                                      │
│                    └────────┬────────┘                                      │
│                             │                                               │
│                    ┌────────▼────────┐                                      │
│                    │  LOAD BALANCER  │                                      │
│                    └────────┬────────┘                                      │
│                             │                                               │
│              ┌──────────────┼──────────────┐                                │
│              │              │              │                                │
│        ┌─────▼────┐   ┌─────▼────┐   ┌─────▼────┐                          │
│        │ Server 1 │   │ Server 2 │   │ Server 3 │                          │
│        │   JVM 1  │   │   JVM 2  │   │   JVM 3  │                          │
│        │ Servlet  │   │ Servlet  │   │ Servlet  │                          │
│        │ Instance │   │ Instance │   │ Instance │                          │
│        └──────────┘   └──────────┘   └──────────┘                          │
│                                                                              │
│  ⭐ ONE servlet instance per JVM, but MULTIPLE JVMs exist                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Session Problem in Load Balancing

| Problem | Solution |
|---------|----------|
| Session created on Server 1 | **Sticky Sessions**: Same client → Same server |
| Next request to Server 2 | **Session Replication**: Copy session to all servers |
| Session not found! ❌ | **Central Store**: Database/Redis/Cache |

> 💡 **Memory Trick**: "**Servlet → one object per JVM, Threads → multiple requests, Load balancer → multiple JVMs**"

---

# Day 5: JSP - Java Server Pages

## 📄 What is JSP?

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  JSP = Java Server Pages                                                     │
│  ▸ Server-side technology (runs on server, not browser)                     │
│  ▸ Allows mixing HTML + Java code                                           │
│  ▸ Used for PRESENTATION layer (View in MVC)                                │
│  ▸ Internally converted to Servlet                                          │
│  ▸ File extension: .jsp                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 🆚 JSP vs Servlet

| Feature | JSP | Servlet |
|---------|-----|---------|
| Primary Use | View (UI) | Controller (Logic) |
| Code Style | HTML + Java | Pure Java |
| Development | Faster, easier | More coding |
| Best For | Presentation | Business logic |

## 🔄 JSP Life Cycle

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        JSP LIFE CYCLE                                        │
│                                                                              │
│  FIRST REQUEST:                                                              │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐   │
│  │ JSP     │ ──▶│ Convert │ ──▶│ Compile │ ──▶│ Load    │ ──▶│ jspInit │   │
│  │ (.jsp)  │    │ to      │    │ (.class)│    │ Class   │    │()       │   │
│  └─────────┘    │ Servlet │    └─────────┘    └─────────┘    └────┬────┘   │
│                 └─────────┘                                       │        │
│                                                                   ▼        │
│                                                           ┌─────────────┐  │
│                                                           │_jspService()│  │
│                                                           └─────────────┘  │
│  SUBSEQUENT REQUESTS:                                                       │
│  Only _jspService() is called (no recompilation)                           │
│                                                                              │
│  SHUTDOWN:                                                                   │
│  jspDestroy() is called                                                      │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### JSP Life Cycle Methods

| Method | Called | Can Override? |
|--------|--------|---------------|
| `jspInit()` | Once (initialization) | ✅ Yes |
| `_jspService()` | Every request | ❌ No |
| `jspDestroy()` | Once (cleanup) | ✅ Yes |

## 📦 JSP Elements

### 1. Declaration `<%! ... %>`

```jsp
<%!
    int count = 0;
    public int getCount() {
        return count;
    }
%>
```
> Used for: Instance variables and methods

### 2. Expression `<%= ... %>`

```jsp
<%= new java.util.Date() %>
<%= 10 + 20 %>
```
> Output goes directly to `out.println()`

### 3. Scriptlet `<% ... %>`

```jsp
<%
    int a = 10;
    int b = 20;
    out.println(a + b);
%>
```
> Code goes into `_jspService()` method

### 4. Directives `<%@ ... %>`

```jsp
<%@ page import="java.util.*" %>
<%@ page errorPage="error.jsp" %>
<%@ include file="header.jsp" %>
<%@ taglib uri="..." prefix="c" %>
```

### 5. Standard Actions `<jsp:... />`

```jsp
<jsp:include page="header.jsp" />
<jsp:forward page="result.jsp" />
<jsp:useBean id="user" class="com.User" scope="session" />
<jsp:param name="key" value="value" />
```

## 🔌 JSP Implicit Objects

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       JSP IMPLICIT OBJECTS                                   │
├────────────────────┬────────────────────────┬───────────────────────────────┤
│  Implicit Object   │      API Class         │         Purpose               │
├────────────────────┼────────────────────────┼───────────────────────────────┤
│  out               │  JspWriter             │  Output to browser            │
│  request           │  HttpServletRequest    │  Client request data          │
│  response          │  HttpServletResponse   │  Server response              │
│  session           │  HttpSession           │  Session management           │
│  application       │  ServletContext        │  Application data             │
│  config            │  ServletConfig         │  Servlet configuration        │
│  pageContext       │  PageContext           │  Page-level info              │
│  page              │  Object                │  Current JSP instance         │
│  exception         │  Throwable             │  Error page only              │
└────────────────────┴────────────────────────┴───────────────────────────────┘
```

---

# Day 6: JSP Scopes, EL & JSTL

## 🎯 JSP Scopes (Attributes)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           JSP SCOPES                                         │
├───────────────┬─────────────────┬───────────────────────────────────────────┤
│    Scope      │  Object Used    │  Lifetime                                 │
├───────────────┼─────────────────┼───────────────────────────────────────────┤
│    page       │  pageContext    │  One JSP page only                        │
│    request    │  request        │  One request (forward/include)            │
│    session    │  session        │  User session (multiple requests)         │
│    application│  application    │  Entire application (all users)           │
└───────────────┴─────────────────┴───────────────────────────────────────────┘
```

```
                                INCREASING SCOPE
    ┌────────┐    ┌────────────┐    ┌────────────┐    ┌────────────────┐
    │  page  │ ──▶│  request   │ ──▶│  session   │ ──▶│  application   │
    │        │    │            │    │            │    │                │
    │ 1 JSP  │    │ 1 Request  │    │ 1 User     │    │ All Users      │
    └────────┘    └────────────┘    └────────────┘    └────────────────┘
```

## 📝 Expression Language (EL)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     EXPRESSION LANGUAGE (EL)                                 │
│  Syntax: ${expression}                                                       │
│  Purpose: Access data without scriptlets                                     │
│  Feature: NULL-SAFE (no NullPointerException!)                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### EL Implicit Objects

```jsp
<!-- SCOPE ATTRIBUTES -->
${pageScope.var}          <%-- Page scope --%>
${requestScope.var}       <%-- Request scope --%>
${sessionScope.var}       <%-- Session scope --%>
${applicationScope.var}   <%-- Application scope --%>

<!-- REQUEST PARAMETERS -->
${param.name}             <%-- Single value --%>
${paramValues.name[0]}    <%-- Multiple values (array) --%>

<!-- COOKIES -->
${cookie.name.value}      <%-- Cookie value --%>

<!-- INIT PARAMS -->
${initParam.dbname}       <%-- Context parameter from web.xml --%>
```

### EL Search Order

```
page ──▶ request ──▶ session ──▶ application
```
> If you use `${var}` without scope prefix, EL searches in this order.

## 🏷️ JSTL - JSP Standard Tag Library

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
```

### Core JSTL Tags

```jsp
<!-- c:out - Print output -->
<c:out value="Welcome" />

<!-- c:set - Set variable -->
<c:set var="x" value="10" scope="request" />

<!-- c:if - Conditional -->
<c:if test="${x > 5}">
    X is greater than 5
</c:if>

<!-- c:choose/when/otherwise - Switch case -->
<c:choose>
    <c:when test="${x == 10}">Ten</c:when>
    <c:when test="${x == 20}">Twenty</c:when>
    <c:otherwise>Other</c:otherwise>
</c:choose>

<!-- c:forEach - Loop -->
<c:forEach var="i" begin="1" end="5">
    ${i}
</c:forEach>

<!-- c:forEach with collection -->
<c:forEach var="item" items="${itemList}">
    ${item.name}
</c:forEach>

<!-- c:forTokens - String split -->
<c:forTokens items="Java,Python,C++" delims="," var="lang">
    ${lang}<br>
</c:forTokens>

<!-- c:url - URL rewriting -->
<c:url value="/nextPage.jsp" />
```

### JSTL vs Scriptlet

| Scriptlet | JSTL |
|-----------|------|
| Java code in JSP | No Java code |
| Hard to read | Clean & readable |
| Not MVC friendly | MVC friendly ✅ |

> 💡 **Viva Point**: "JSTL provides standard tags to perform logic in JSP without using Java code"

---

# Day 7: MVC Architecture & Custom Tags

## 🏗️ Model 1 vs Model 2 (MVC)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    MODEL 1 ARCHITECTURE                                      │
│                                                                              │
│     Client ──▶ JSP/Servlet ──▶ Database                                      │
│                    │                                                         │
│                    │ (Everything in one place!)                              │
│                    ▼                                                         │
│              ┌───────────────┐                                              │
│              │ • Request     │                                              │
│              │ • Logic       │  ❌ Hard to maintain                          │
│              │ • Database    │  ❌ Poor separation                           │
│              │ • Response    │  ❌ Not scalable                              │
│              └───────────────┘                                              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                    MODEL 2 (MVC) ARCHITECTURE ⭐                             │
│                                                                              │
│                         ┌─────────────┐                                     │
│              ┌─────────▶│    VIEW     │◀─────────┐                          │
│              │          │   (JSP)     │          │                          │
│              │          └─────────────┘          │                          │
│              │                                   │ (data to display)        │
│    (request) │                                   │                          │
│              │                                   │                          │
│     ┌────────┴────────┐              ┌──────────┴───────┐                   │
│     │   CONTROLLER    │──────────────│     MODEL        │                   │
│     │   (Servlet)     │  (calls)     │  (JavaBean/DAO)  │                   │
│     │                 │◀─────────────│                  │                   │
│     └─────────────────┘  (returns)   └──────────────────┘                   │
│              ▲                                   │                          │
│              │                                   │                          │
│     ┌────────┴────────┐                   ┌──────▼──────┐                   │
│     │     CLIENT      │                   │   DATABASE  │                   │
│     └─────────────────┘                   └─────────────┘                   │
│                                                                              │
│     ✅ Separation of concerns    ✅ Easy maintenance    ✅ Scalable          │
└─────────────────────────────────────────────────────────────────────────────┘
```

### MVC Components

| Component | Role | Technology |
|-----------|------|------------|
| **Model** | Business logic, Data | JavaBean, DAO classes |
| **View** | Presentation, UI | JSP, HTML |
| **Controller** | Request handling, Flow control | Servlet |

## 🏷️ Custom JSP Tags

### Files Required

```
1. JSP File      ──▶ Uses the custom tag
2. TLD File      ──▶ Maps tag name to Java class (Bridge)
3. Tag Handler   ──▶ Contains tag logic (Java class)
```

### Example Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  JSP: <abc:hello />                                                          │
│           │                                                                  │
│           ▼                                                                  │
│  TLD: hello.tld                                                              │
│       <name>hello</name>                                                     │
│       <tag-class>mypack.HelloTag</tag-class>                                │
│           │                                                                  │
│           ▼                                                                  │
│  Java: HelloTag.java                                                         │
│       public void doTag() {                                                  │
│           getJspContext().getOut().print("Hello World!");                   │
│       }                                                                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### TLD File Structure

```xml
<taglib>
    <tag>
        <name>hello</name>
        <tag-class>mypack.HelloTag</tag-class>
        <body-content>empty</body-content>
    </tag>
</taglib>
```

### Tag Handler Class

```java
public class HelloTag extends SimpleTagSupport {
    @Override
    public void doTag() throws IOException {
        getJspContext().getOut().print("Hello Custom Tag!");
    }
}
```

> 💡 **Viva Point**: "TLD acts as a bridge between JSP and Java class. doTag() is called every time the tag is used."

---

# Day 8: Hibernate ORM Framework

## 🔄 Object Relational Mapping (ORM)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    OBJECT RELATIONAL MAPPING                                 │
│                                                                              │
│     JAVA WORLD                              DATABASE WORLD                   │
│     ┌─────────────┐                        ┌─────────────┐                  │
│     │   Class     │  ◀──────────────────▶  │   Table     │                  │
│     │   Object    │  ◀──────────────────▶  │   Row       │                  │
│     │   Field     │  ◀──────────────────▶  │   Column    │                  │
│     └─────────────┘                        └─────────────┘                  │
│                                                                              │
│     Hibernate handles the mapping automatically!                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 🏗️ Hibernate Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      HIBERNATE ARCHITECTURE                                  │
│                                                                              │
│  ┌──────────────┐    ┌──────────────────┐    ┌─────────────────┐           │
│  │ Configuration │───▶│  SessionFactory  │───▶│    Session      │           │
│  │              │    │   (Heavy, Once)   │    │  (Lightweight)  │           │
│  │ hibernate.   │    │                  │    │                 │           │
│  │ cfg.xml      │    │ Thread-safe ✅   │    │ NOT thread-safe │           │
│  └──────────────┘    └──────────────────┘    └────────┬────────┘           │
│                                                        │                    │
│                                              ┌─────────▼─────────┐          │
│                                              │   Transaction     │          │
│                                              │                   │          │
│                                              │ begin() → commit()│          │
│                                              │         → rollback│          │
│                                              └─────────┬─────────┘          │
│                                                        │                    │
│                                              ┌─────────▼─────────┐          │
│                                              │     DATABASE       │          │
│                                              └───────────────────┘          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 📊 Object States in Hibernate

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       HIBERNATE OBJECT STATES                                │
│                                                                              │
│  ┌─────────────┐        ┌─────────────┐        ┌─────────────┐             │
│  │  TRANSIENT  │ ─────▶ │  PERSISTENT │ ─────▶ │  DETACHED   │             │
│  │             │ save() │             │ close()│             │             │
│  │ new Object()│persist │ In Session  │        │ Session     │             │
│  │             │   ()   │ Tracked ✅  │        │ Closed      │             │
│  │ Not in DB   │        │ Auto sync   │        │ Not tracked │             │
│  └─────────────┘        └─────────────┘        └─────────────┘             │
│                                                        │                    │
│                                                        │ merge()/update()   │
│                                                        │                    │
│                                              ┌─────────▼─────────┐          │
│                                              │   PERSISTENT      │          │
│                                              │   (Re-attached)   │          │
│                                              └───────────────────┘          │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

| State | Description | In DB? | In Session? |
|-------|-------------|--------|-------------|
| **Transient** | New object, not saved | ❌ No | ❌ No |
| **Persistent** | Saved, tracked by session | ✅ Yes | ✅ Yes |
| **Detached** | Was persistent, session closed | ✅ Yes | ❌ No |

## 🔧 Hibernate Operations

```java
// CONFIGURATION
Configuration cfg = new Configuration();
cfg.configure("hibernate.cfg.xml");

// SESSION FACTORY (Create ONCE)
SessionFactory factory = cfg.buildSessionFactory();

// SESSION (Create for each unit of work)
Session session = factory.openSession();
Transaction tx = session.beginTransaction();

// PERSIST (Insert)
Employee e = new Employee();
e.setName("John");
session.persist(e);     // Object becomes Persistent

// GET (Select - returns null if not found)
Employee e = session.get(Employee.class, 1);

// LOAD (Select - throws exception if not found)
Employee e = session.load(Employee.class, 1);

// UPDATE (Manual re-attach detached object)
session.update(detachedEmployee);

// MERGE (Safer update for detached objects)
session.merge(detachedEmployee);

// REFRESH (Reload from DB, discard memory changes)
session.refresh(employee);

// DELETE
session.delete(employee);

// COMMIT
tx.commit();  // SQL executed here!
session.close();
```

## ✨ Automatic Dirty Checking

```java
// Hibernate automatically detects changes!
Employee e = session.get(Employee.class, 1);  // Persistent
e.setSalary(50000);                           // Modified in memory

tx.commit();   // Hibernate auto-detects change and fires UPDATE!
               // No explicit update() needed for persistent objects!
```

> 💡 **Key Point**: Dirty checking works ONLY for persistent objects in an active session!

## 📋 Entity Class Annotations

```java
@Entity
@Table(name = "employee")
public class Employee {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "emp_id")
    private int id;
    
    @Column(name = "emp_name", nullable = false)
    private String name;
    
    @Column(name = "salary")
    private double salary;
    
    // Getters and Setters (REQUIRED even for auto-generated ID!)
}
```

> ⚠️ **Important**: Even with `@GeneratedValue`, setter method is REQUIRED because Hibernate uses it to set the generated ID back to the object!

---

# 📚 Quick Reference Tables

## 🔄 JDBC vs Hibernate

| Feature | JDBC | Hibernate |
|---------|------|-----------|
| SQL | Write manually | Auto-generated |
| Mapping | Manual | Automatic (ORM) |
| Caching | None | First & Second level |
| Transactions | Manual | Managed |
| Boilerplate | Lot of code | Less code |

## 📦 Scope Comparison

| Scope | Duration | Use Case |
|-------|----------|----------|
| Page | One JSP | Temp calculations |
| Request | One request | Forward data |
| Session | User session | Login info |
| Application | Entire app | App config |

## 🔐 Session Tracking Comparison

| Technique | Storage | Security | Data Type |
|-----------|---------|----------|-----------|
| Hidden Fields | HTML | ❌ Low | String |
| Cookies | Client | ❌ Low | String |
| HttpSession | Server | ✅ High | Any Object |
| URL Rewriting | URL | ❌ Low | String |

---

# 🎯 Ultimate Memory Tricks

```
📌 JDBC
   "Type 4 = Turbo Four" (Pure Java, Fastest)
   "Prepared = Protected" (SQL injection safe)

📌 Servlets
   "Once Init, Many Service, Once Destroy"
   "Thread = Light, Process = Heavy" (Servlet vs CGI)

📌 JSP
   "JSP = Just Servlet Pretending" (internally servlet)
   "Declaration = Define, Expression = Display, Scriptlet = Script"

📌 Scopes
   "Page < Request < Session < Application" (increasing lifetime)

📌 MVC
   "Model = Data, View = Display, Controller = Direct"

📌 Hibernate
   "Transient → Persistent → Detached" (object lifecycle)
   "SessionFactory = Heavy (once), Session = Light (many)"
```

---

# ✅ Viva One-Liners (Quick Revision)

1. **JDBC** connects Java applications with relational databases using drivers.
2. **Type 4 driver** is pure Java and fastest.
3. **PreparedStatement** is faster and prevents SQL injection.
4. **Servlet** is initialized once and serves multiple requests via threads.
5. **Forward** is server-side; **Redirect** is client-side.
6. **HttpSession** stores data on server; **Cookie** stores on client.
7. **Filter** processes requests before and after servlet execution.
8. **Servlets are NOT thread-safe** by default (use local variables).
9. **JSP** is internally converted to Servlet on first request.
10. **EL** is null-safe and avoids NullPointerException.
11. **JSTL** provides standard tags to avoid Java code in JSP.
12. **MVC** separates Model (data), View (UI), Controller (flow).
13. **Hibernate** is an ORM framework that maps objects to tables.
14. **Dirty Checking** auto-detects changes to persistent objects.
15. **SessionFactory** is thread-safe and created once; **Session** is not.

---

> 📝 **Created**: December 25, 2025  
> 🎓 **Purpose**: CDAC/Jakarta EE Exam Preparation  
> ⭐ **Tip**: Review memory tricks before exam!
