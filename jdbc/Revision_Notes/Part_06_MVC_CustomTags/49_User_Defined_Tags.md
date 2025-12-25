# User Defined Tags

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Types of Custom Tags](#types-of-custom-tags)
3. [Simple Tag Handler](#simple-tag-handler)
4. [Tag with Attributes](#tag-with-attributes)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**User Defined Tags** (Custom Tags) allow creating reusable JSP components without scriptlets.

---

## 📖 Types of Custom Tags

| Type | Description |
|------|-------------|
| **Tag Files** | JSP-based, simple, in `/WEB-INF/tags/` |
| **Tag Handlers** | Java-based, more control |

---

## 📖 Simple Tag Handler

### HelloTag.java

```java
public class HelloTag extends SimpleTagSupport {
    
    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        out.println("<h2>Hello from Custom Tag!</h2>");
    }
}
```

### TLD File (mytags.tld)

```xml
<taglib>
    <tlib-version>1.0</tlib-version>
    <short-name>my</short-name>
    <uri>http://example.com/mytags</uri>
    
    <tag>
        <name>hello</name>
        <tag-class>com.example.tags.HelloTag</tag-class>
        <body-content>empty</body-content>
    </tag>
</taglib>
```

### Usage

```jsp
<%@ taglib prefix="my" uri="http://example.com/mytags" %>
<my:hello/>
```

---

## 📖 Tag with Attributes

```java
public class GreetTag extends SimpleTagSupport {
    private String name;
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public void doTag() throws JspException, IOException {
        getJspContext().getOut().println("Hello, " + name + "!");
    }
}
```

### TLD

```xml
<tag>
    <name>greet</name>
    <tag-class>com.example.tags.GreetTag</tag-class>
    <body-content>empty</body-content>
    <attribute>
        <name>name</name>
        <required>true</required>
    </attribute>
</tag>
```

---

## ✅ Key Takeaways

1. Extend **SimpleTagSupport** for custom tags
2. **TLD file** defines tag library
3. Use **setter methods** for attributes
4. Place TLD in `/WEB-INF/`

---

## 🎤 Interview Questions

**Q1: How do you create a custom tag?**
> **A:** Extend SimpleTagSupport, override doTag(), create TLD file, use in JSP.

**Q2: What is a TLD file?**
> **A:** Tag Library Descriptor - XML file describing tag names, classes, and attributes.
