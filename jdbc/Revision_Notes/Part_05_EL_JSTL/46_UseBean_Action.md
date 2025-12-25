# UseBean Action

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [How useBean Works](#how-usebean-works)
3. [Attributes](#attributes)
4. [Complete Example](#complete-example)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**jsp:useBean** creates or retrieves a JavaBean object and makes it available as a scripting variable.

---

## 📖 How useBean Works

```
1. Look for bean with id="user" in specified scope
2. If found: Use existing bean
3. If not found: 
   - Create new instance using class
   - Store in scope with given id
```

---

## 📖 Attributes

| Attribute | Required | Description |
|-----------|----------|-------------|
| `id` | Yes | Variable name |
| `class` | * | Fully qualified class name |
| `type` | * | Variable type (interface/superclass) |
| `scope` | No | page, request, session, application |
| `beanName` | * | For factory instantiation |

*At least one of class, type, or beanName required

---

## 📖 Complete Example

### User.java

```java
public class User {
    private String name;
    private String email;
    
    public User() {}  // Required no-arg constructor
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
```

### form.html

```html
<form action="process.jsp" method="POST">
    Name: <input type="text" name="name"><br>
    Email: <input type="text" name="email"><br>
    <input type="submit">
</form>
```

### process.jsp

```jsp
<jsp:useBean id="user" class="com.example.User" scope="request"/>
<jsp:setProperty name="user" property="*"/>
<jsp:forward page="display.jsp"/>
```

### display.jsp

```jsp
<jsp:useBean id="user" class="com.example.User" scope="request"/>
<p>Name: <jsp:getProperty name="user" property="name"/></p>
<p>Email: ${user.email}</p>
```

---

## ✅ Key Takeaways

1. Bean needs **no-arg constructor**
2. Bean needs **getters/setters** following naming convention
3. useBean **creates OR retrieves** existing bean
4. property="*" auto-maps request params to properties

---

## 🎤 Interview Questions

**Q1: What are the requirements for a JavaBean?**
> **A:** Public no-arg constructor, public getters/setters, optionally Serializable.

**Q2: When is the body of jsp:useBean executed?**
> **A:** Only when bean is newly created. If existing bean found in scope, body is skipped.
