# Tag Library Descriptors (TLD)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [TLD Structure](#tld-structure)
3. [Tag Definition](#tag-definition)
4. [Attribute Definition](#attribute-definition)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**TLD (Tag Library Descriptor)** is an XML file that describes a custom tag library.

---

## 📖 TLD Structure

### mytags.tld

```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib xmlns="http://java.sun.com/xml/ns/javaee"
        version="2.1">
    
    <tlib-version>1.0</tlib-version>
    <short-name>my</short-name>
    <uri>http://example.com/mytags</uri>
    
    <!-- Tag definitions here -->
    
</taglib>
```

### Location

Place in `/WEB-INF/` or `/WEB-INF/tlds/`

---

## 📖 Tag Definition

```xml
<tag>
    <name>hello</name>
    <tag-class>com.example.tags.HelloTag</tag-class>
    <body-content>empty</body-content>
    <description>Says hello</description>
</tag>
```

### body-content Values

| Value | Meaning |
|-------|---------|
| `empty` | No body allowed |
| `scriptless` | Body allowed, no scriptlets |
| `tagdependent` | Body not processed |
| `JSP` | Body with JSP (classic tags) |

---

## 📖 Attribute Definition

```xml
<tag>
    <name>greet</name>
    <tag-class>com.example.tags.GreetTag</tag-class>
    <body-content>empty</body-content>
    
    <attribute>
        <name>name</name>
        <required>true</required>
        <rtexprvalue>true</rtexprvalue>
        <type>java.lang.String</type>
        <description>Name to greet</description>
    </attribute>
</tag>
```

| Element | Description |
|---------|-------------|
| `required` | Is attribute mandatory? |
| `rtexprvalue` | Allow EL/expressions? |
| `type` | Java type |

---

## ✅ Key Takeaways

1. TLD is **XML file** describing tag library
2. Defines **tag name**, **class**, **attributes**
3. Place in `/WEB-INF/`
4. Reference via **uri** in JSP taglib directive

---

## 🎤 Interview Questions

**Q1: What is a TLD file?**
> **A:** Tag Library Descriptor - XML file that describes custom tags, their classes, and attributes.

**Q2: What does rtexprvalue mean?**
> **A:** "Runtime Expression Value" - if true, attribute can accept EL expressions; if false, only static values.
