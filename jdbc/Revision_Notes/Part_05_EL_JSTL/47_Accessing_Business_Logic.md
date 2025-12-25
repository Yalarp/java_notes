# Accessing Business Logic from JSP

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [The Problem](#the-problem)
3. [Separation of Concerns](#separation-of-concerns)
4. [Accessing Service Layer](#accessing-service-layer)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

JSP should focus on **presentation only**. Business logic should be in separate Java classes (services, DAOs).

---

## 📖 The Problem

### Bad: Logic in JSP

```jsp
<%-- ❌ Business logic in JSP - BAD! --%>
<%
    Connection con = DriverManager.getConnection(...);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM users");
    while (rs.next()) {
        out.println(rs.getString("name"));
    }
%>
```

**Problems:**
- Hard to test
- Hard to maintain
- Mixes concerns
- Code duplication

---

## 📖 Separation of Concerns

### Good: MVC Pattern

```
Controller (Servlet)     →     Model (Service/DAO)     →     View (JSP)
   Handle request              Business logic              Display only
```

---

## 📖 Accessing Service Layer

### Service Class

```java
public class UserService {
    private UserDAO userDAO = new UserDAO();
    
    public List<User> getAllUsers() {
        return userDAO.findAll();
    }
    
    public User authenticate(String username, String password) {
        // Business logic here
    }
}
```

### Controller Servlet

```java
@WebServlet("/users")
public class UserController extends HttpServlet {
    private UserService userService = new UserService();
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res) {
        List<User> users = userService.getAllUsers();
        req.setAttribute("users", users);
        req.getRequestDispatcher("/users.jsp").forward(req, res);
    }
}
```

### JSP (View Only)

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<body>
    <h1>Users</h1>
    <ul>
        <c:forEach var="user" items="${users}">
            <li>${user.name} - ${user.email}</li>
        </c:forEach>
    </ul>
</body>
</html>
```

---

## ✅ Key Takeaways

1. **No business logic in JSP** - presentation only
2. Use **MVC pattern** for separation
3. Servlet calls Service → Service returns data → JSP displays
4. Makes code **testable and maintainable**

---

## 🎤 Interview Questions

**Q1: Why shouldn't you put business logic in JSP?**
> **A:** Violates separation of concerns, hard to test, maintain, and reuse. Mixes presentation with logic.

**Q2: How does JSP access business data?**
> **A:** Controller (Servlet) calls services, stores result in request attribute, forwards to JSP which displays using EL/JSTL.
