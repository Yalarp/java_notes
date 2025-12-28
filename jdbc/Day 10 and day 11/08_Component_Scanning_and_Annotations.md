# Component Scanning and Annotations

## Table of Contents
1. [Introduction](#1-introduction)
2. [The @Component Annotation](#2-the-component-annotation)
3. [Component Scanning](#3-component-scanning)
4. [The @Autowired Annotation](#4-the-autowired-annotation)
5. [Types of @Autowired Injection](#5-types-of-autowired-injection)
6. [The @Qualifier Annotation](#6-the-qualifier-annotation)
7. [Complete Code Examples](#7-complete-code-examples)
8. [Execution Flow](#8-execution-flow)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

**Component Scanning** is a powerful feature that allows Spring to automatically detect and register beans without explicit XML configuration.

> **Key Insight**: Instead of writing `<bean>` tags in XML, you can use annotations directly in your Java classes!

---

## 2. The @Component Annotation

### What is @Component?

The `@Component` annotation marks a class as a Spring-managed bean. Spring will automatically create an instance of this class.

### Equivalence with XML

```
┌─────────────────────────────────────────────────────────────┐
│                   @Component ANNOTATION                      │
│                                                              │
│   Java Code:                                                 │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class Author { ... }                         │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│                    IS SAME AS                                │
│                                                              │
│   XML Configuration:                                         │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  <bean id="author" class="mypack.Author"/>          │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   NOTE: Default bean ID = class name with lowercase first   │
│         letter (Author → author)                            │
└─────────────────────────────────────────────────────────────┘
```

### Specifying Custom Bean ID

```java
// Default ID: "author" (lowercase class name)
@Component
public class Author { ... }

// Custom ID: "mybook"
@Component(value="mybook")
public class Book { ... }

// OR simply:
@Component("mybook")
public class Book { ... }
```

### Equivalent XML

```xml
<!-- @Component with default ID -->
<bean id="author" class="mypack.Author"/>

<!-- @Component(value="mybook") -->
<bean id="mybook" class="mypack.Book"/>
```

---

## 3. Component Scanning

### What is Component Scanning?

Component scanning tells Spring to **automatically scan** specified packages for classes annotated with `@Component` (and related annotations) and register them as beans.

### The `<context:component-scan>` Tag

```xml
<context:component-scan base-package="mypack"/>
```

This instructs Spring to:
1. Scan the `mypack` package
2. Find all classes with `@Component` annotation
3. Register them as beans automatically

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│                  COMPONENT SCANNING                          │
│                                                              │
│   XML Configuration:                                         │
│   <context:component-scan base-package="mypack"/>           │
│                                                              │
│                         ↓                                    │
│                                                              │
│   Spring Container scans mypack package:                     │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  mypack/                                             │   │
│   │  ├── Author.java  (@Component) → Registered ✅      │   │
│   │  ├── Book.java    (@Component) → Registered ✅      │   │
│   │  ├── Main.java    (No annotation) → Ignored ❌      │   │
│   │  └── Utils.java   (No annotation) → Ignored ❌      │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Result: author and book beans are created automatically!  │
└─────────────────────────────────────────────────────────────┘
```

### XML Configuration with Component Scan

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.0.xsd">
    
    <!-- Enable component scanning for mypack package -->
    <context:component-scan base-package="mypack"/>
    
</beans>
```

> **Note**: You need to include the `context` namespace for component scanning!

---

## 4. The @Autowired Annotation

### What is @Autowired?

`@Autowired` tells Spring to automatically inject a dependency into a bean. It works **by type** (similar to `autowire="byType"` in XML).

### How @Autowired Works

```
┌─────────────────────────────────────────────────────────────┐
│                    @Autowired                                │
│                                                              │
│   Java Code:                                                 │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class Book {                                 │   │
│   │      @Autowired                                      │   │
│   │      private Author author;  ← Spring injects here  │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Spring Container:                                          │
│   1. Finds Book bean (has @Component)                       │
│   2. Sees @Autowired on 'author' field                      │
│   3. Looks for bean of type 'Author'                        │
│   4. Injects Author bean into Book                          │
│                                                              │
│   IMPORTANT: Author class MUST also have @Component         │
│   otherwise there's no bean to inject!                      │
└─────────────────────────────────────────────────────────────┘
```

### What Happens Without @Component on Dependency?

```java
@Component
public class Book {
    @Autowired
    private Author author;  // Will be NULL!
}

// ❌ Author class WITHOUT @Component
public class Author { ... }
```

> **Warning**: If `Author` doesn't have `@Component`, Spring won't create an Author bean, so `author` field will be `null` and you'll get `NullPointerException`!

---

## 5. Types of @Autowired Injection

`@Autowired` can be used in three places:

### 5.1 Field Injection (Property Injection)

```java
@Component
public class Book {
    
    @Autowired    // ← On field directly
    private Author author;
    
    // No setter needed!
}
```

**Pros**: Simplest, least code
**Cons**: Hard to test, cannot use final fields

---

### 5.2 Setter Injection

```java
@Component
public class Book {
    
    private Author author;
    
    @Autowired    // ← On setter method
    public void setAuthor(Author author) {
        this.author = author;
    }
}
```

**Pros**: Optional dependencies, testable
**Cons**: More code than field injection

---

### 5.3 Constructor Injection

```java
@Component
public class Book {
    
    private final Author author;  // Can be final!
    
    @Autowired    // ← On constructor
    public Book(Author author) {
        super();
        this.author = author;
        this.isbn = "85";
        this.year = "2000";
    }
}
```

**Pros**: Supports final fields, mandatory dependencies, most testable
**Cons**: More code, cannot handle circular dependencies

---

### Comparison Table

| Type | Annotation Placement | Final Fields | Testing | Best For |
|------|---------------------|--------------|---------|----------|
| **Field** | On field | ❌ | Hard | Quick development |
| **Setter** | On setter method | ❌ | Easy | Optional dependencies |
| **Constructor** | On constructor | ✅ | Easy | Mandatory dependencies |

---

## 6. The @Qualifier Annotation

### The Problem

When multiple beans of the same type exist, `@Autowired` (which works byType) gets confused:

```java
@Component
public class SavingAccount implements Account { }

@Component
public class CurrentAccount implements Account { }

@Component
public class AccountBean {
    @Autowired
    private Account account;  // ❌ Which one? SavingAccount or CurrentAccount?
}
```

**Error**: `No qualifying bean of type [Account]: expected single matching bean but found 2`

### The Solution: @Qualifier

```java
@Component
public class SavingAccount implements Account { }

@Component
public class CurrentAccount implements Account { }

@Component
public class AccountBean {
    @Autowired
    @Qualifier("currentAccount")  // ← Specify which bean!
    private Account account;
}
```

### How @Qualifier Works

```
┌─────────────────────────────────────────────────────────────┐
│                    @Qualifier                                │
│                                                              │
│   Multiple beans of same type:                               │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class SavingAccount implements Account {}   │   │
│   │  → Bean ID: "savingAccount"                         │   │
│   │                                                      │   │
│   │  @Component                                          │   │
│   │  public class CurrentAccount implements Account {}  │   │
│   │  → Bean ID: "currentAccount"                        │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Using @Qualifier to disambiguate:                          │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Autowired                                          │   │
│   │  @Qualifier("savingAccount")  ← Use this bean!      │   │
│   │  private Account account;                            │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Complete Code Examples

### Example: @Component + @Autowired Field Injection

**File: Author.java**
```java
package mypack;

import org.springframework.stereotype.Component;

// Line 3-5: @Component marks this class as a Spring bean
// Default bean ID = "author" (lowercase class name)
@Component
public class Author
{
    // Line 8: Private fields with default values
    private String name, address;
    
    // Line 10-14: Constructor initializes default values
    public Author()
    {
        name = "abc";
        address = "pune";
    }
    
    // Line 16-18: Getter for address
    public String getAddress() {
        return address;
    }

    // Line 20-23: toString method
    @Override
    public String toString()
    {
        return name + "\t" + address;
    }

    // Setters omitted for brevity...
}
```

---

**File: Book.java**
```java
package mypack;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

// Line 5: @Component marks this as a Spring bean
@Component
public class Book
{
    // Line 8-9: @Autowired on field - Spring injects Author bean here
    // This is FIELD INJECTION (Property Injection)
    @Autowired
    private Author author;
    
    // Line 11-12: Other fields
    private String isbn;
    private String year;
    
    // Line 14-17: Constructor sets default values
    public Book()
    {
        isbn = "70";
        year = "2010";
    }
    
    // Line 19-22: Getters
    public String getIsbn() {
        return isbn;
    }

    public String getYear() {
        return year;
    }

    // Line 25-29: toString uses the injected author!
    @Override
    public String toString()
    {
        System.out.println("Author's address is\t" + author.getAddress());
        return author + "\t" + isbn + "\t" + year;
    }
}
```

**Key Points:**
| Line | Code | Explanation |
|------|------|-------------|
| 8-9 | `@Autowired private Author author` | Spring automatically injects Author bean |
| 28 | `author.getAddress()` | Uses the injected author - NOT null because Author has @Component |

---

**File: tech.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-4.0.xsd">
    
    <!-- Line 9: Enable component scanning -->
    <!-- Spring scans mypack for @Component annotations -->
    <context:component-scan base-package="mypack"/>
    
</beans>
```

---

**File: Main.java**
```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        // Create container with component scanning enabled
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("tech.xml");
        
        // Get Book bean - Author is already injected!
        Book book = (Book) ctx.getBean("book");
        
        // Use the book - author field is populated
        System.out.println(book);
        
        ctx.close();
    }
}
```

---

## 8. Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│              COMPONENT SCANNING EXECUTION FLOW               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: Container starts with tech.xml                      │
│  ───────────────────────────────────                        │
│  Reads: <context:component-scan base-package="mypack"/>     │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Spring scans mypack package                         │
│  ───────────────────────────────────                        │
│  Finds:                                                      │
│  - Author.java has @Component → Register bean "author"      │
│  - Book.java has @Component → Register bean "book"          │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: Spring creates beans (EAGER)                        │
│  ────────────────────────────────────                       │
│  Creates Author: new Author()                               │
│  Creates Book: new Book()                                   │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: Spring processes @Autowired                         │
│  ───────────────────────────────────                        │
│  Sees @Autowired on Book.author field                       │
│  Looks for bean of type Author                              │
│  Finds "author" bean                                        │
│  Injects: book.author = authorBean                          │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: Container ready                                     │
│  ───────────────────────                                    │
│  Both beans created and wired!                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Common Interview Questions

### Q1: What is @Component annotation?
**A:** @Component marks a class as a Spring-managed bean. When component scanning is enabled, Spring automatically detects and registers classes with @Component as beans.

### Q2: What is component scanning?
**A:** Component scanning is a feature where Spring automatically scans specified packages for classes annotated with @Component (and related annotations) and registers them as beans without explicit XML configuration.

### Q3: What is @Autowired annotation?
**A:** @Autowired tells Spring to automatically inject a dependency. It works by type (byType) and can be placed on fields, setter methods, or constructors.

### Q4: What is @Qualifier used for?
**A:** @Qualifier is used with @Autowired to specify which bean to inject when multiple beans of the same type exist. It resolves ambiguity.

### Q5: What are the three types of @Autowired injection?
**A:** 
1. **Field injection**: @Autowired on field
2. **Setter injection**: @Autowired on setter method
3. **Constructor injection**: @Autowired on constructor

---

## 10. Key Takeaways

📌 **@Component** marks a class as a Spring bean (replaces `<bean>` in XML)

📌 **Component scanning** uses `<context:component-scan>` to auto-detect beans

📌 **@Autowired** works **byType** - looks for bean matching the type

📌 **@Autowired can be used on**: field, setter, or constructor

📌 **@Qualifier** resolves ambiguity when multiple beans of same type exist

📌 **Dependency class MUST have @Component** otherwise injection fails (null)

📌 **Constructor injection** is recommended for mandatory dependencies

📌 **No explicit wiring needed** - Spring handles everything automatically

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│        COMPONENT SCANNING QUICK REFERENCE                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ANNOTATIONS:                                                │
│  @Component         → Marks class as bean                   │
│  @Component("id")   → Marks with custom bean ID             │
│  @Autowired         → Injects dependency (byType)           │
│  @Qualifier("id")   → Specifies which bean to inject        │
│                                                              │
│  XML CONFIGURATION:                                          │
│  <context:component-scan base-package="mypack"/>            │
│                                                              │
│  INJECTION TYPES:                                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  @Autowired                                           │   │
│  │  private MyClass field;        // Field injection    │   │
│  │                                                       │   │
│  │  @Autowired                                           │   │
│  │  public void setField(MyClass f) // Setter injection │   │
│  │                                                       │   │
│  │  @Autowired                                           │   │
│  │  public MyClass(Dep d) { }     // Constructor inj.  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [07. Autowiring in Spring](./07_Autowiring_in_Spring.md)*

*Next: [09. Configuration Class and Method Beans](./09_Configuration_Class_and_Method_Beans.md)*
