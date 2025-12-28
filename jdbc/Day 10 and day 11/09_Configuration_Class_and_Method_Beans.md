# Java-Based Configuration (@Configuration, @Bean, @Value)

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Java-Based Configuration](#2-what-is-java-based-configuration)
3. [The @Configuration Annotation](#3-the-configuration-annotation)
4. [The @Bean Annotation](#4-the-bean-annotation)
5. [The @Value Annotation](#5-the-value-annotation)
6. [Complete Code Examples](#6-complete-code-examples)
7. [Configuration vs Component](#7-configuration-vs-component)
8. [Execution Flow](#8-execution-flow)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

**Java-Based Configuration** is an alternative to XML configuration where beans are defined using Java code with annotations `@Configuration`, `@Bean`, and `@Value`.

> **Key Insight**: Java-based configuration provides type-safety, IDE support, and refactoring capabilities that XML lacks!

---

## 2. What is Java-Based Configuration

### The Three Configuration Approaches

```
┌─────────────────────────────────────────────────────────────┐
│             SPRING CONFIGURATION APPROACHES                  │
│                                                              │
│   1. XML-Based Configuration                                 │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  <bean id="myBean" class="mypack.MyBean"/>          │   │
│   │  <property name="message" value="Hello"/>           │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   2. Annotation-Based (Component Scanning)                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class MyBean {                               │   │
│   │      @Value("Hello")                                 │   │
│   │      private String message;                         │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   3. Java-Based Configuration                                │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Configuration                                      │   │
│   │  public class AppConfig {                            │   │
│   │      @Bean                                           │   │
│   │      public MyBean myBean() { return new MyBean(); } │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. The @Configuration Annotation

### What is @Configuration?

`@Configuration` marks a class as a source of bean definitions. It's the Java equivalent of a Spring XML configuration file.

```java
@Configuration
public class MyAppConfiguration {
    // Bean definitions go here using @Bean methods
}
```

### @Configuration = XML Configuration File

```
┌─────────────────────────────────────────────────────────────┐
│           @Configuration EQUIVALENCE                         │
│                                                              │
│   Java:                                                      │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Configuration                                      │   │
│   │  public class AppConfig {                            │   │
│   │      // Bean definitions                             │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│                       IS SIMILAR TO                          │
│                                                              │
│   XML:                                                       │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  <beans xmlns="...">                                │   │
│   │      <!-- Bean definitions -->                      │   │
│   │  </beans>                                           │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. The @Bean Annotation

### What is @Bean?

`@Bean` is used on a method to indicate that the method returns an object that should be registered as a Spring bean.

```java
@Bean
public MyBean getMyBean() {
    return new MyBean();
}
```

### @Bean = `<bean>` Tag in XML

```
┌─────────────────────────────────────────────────────────────┐
│               @Bean EQUIVALENCE                              │
│                                                              │
│   Java:                                                      │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Bean                                               │   │
│   │  public MyBean getMyDAOBean() {                      │   │
│   │      return new MyBean();                            │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│                       IS SAME AS                             │
│                                                              │
│   XML:                                                       │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  <bean id="getMyDAOBean" class="mypack.MyBean"/>    │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   NOTE: Method name "getMyDAOBean" becomes the bean ID      │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. The @Value Annotation

### What is @Value?

`@Value` is used to inject **primitive values** directly into fields without using XML `<property>` tags. It's an alternative to setter/constructor injection for simple values.

### @Value = `<property>` Tag in XML

```
┌─────────────────────────────────────────────────────────────┐
│               @Value EQUIVALENCE                             │
│                                                              │
│   Using @Value (Annotation):                                 │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class Student {                              │   │
│   │      @Value("Mr.India")                              │   │
│   │      private String name;                            │   │
│   │                                                      │   │
│   │      @Value("100")                                   │   │
│   │      private int age;                                │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│                       IS SAME AS                             │
│                                                              │
│   Using XML:                                                 │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  <bean id="student" class="mypack.Student">         │   │
│   │      <property name="name" value="Mr.India"/>       │   │
│   │      <property name="age" value="100"/>             │   │
│   │  </bean>                                            │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### @Value Features

| Feature | Example | Description |
|---------|---------|-------------|
| Literal values | `@Value("Hello")` | Injects string directly |
| Numeric values | `@Value("100")` | Auto-converts to int/double |
| Property placeholder | `@Value("${db.url}")` | Reads from properties file |
| SpEL expressions | `@Value("#{systemProperties['user.name']}")` | Spring Expression Language |

---

## 6. Complete Code Examples

### Example 1: @Configuration and @Bean

**File: MyAppConfiguration.java**
```java
package mypack;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// Line 6: @Configuration marks this class as a source of bean definitions
@Configuration
public class MyAppConfiguration {

    // Line 9-14: @Bean annotation makes the return value a Spring bean
    // Method name "getMyDAOBean" becomes the bean ID
    @Bean  // makes MyBean as a component
    public MyBean getMyDAOBean() // gets called only once
    {
        System.out.println("inside getMyDAOBean method");
        return new MyBean();
    }
}
```

---

### Example 2: @Value with @Component

**File: Student.java**
```java
package mypack;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

// Line 6: @Component marks this class as a Spring bean
@Component
public class Student 
{
    // Line 9: @Value injects "Mr.India" directly into this field
    // This is an ALTERNATIVE to <property name="name" value="Mr.India"/>
    @Value("Mr.India")
    private String name;
    
    // Line 12: @Value can inject numeric values too (auto-conversion)
    @Value("100")
    private int age;
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public int getAge() {
        return age;
    }
    
    public void setAge(int age) {
        this.age = age;
    }
    
    @Override
    public String toString() {
        return "Student [name=" + name + ", age=" + age + "]";
    }
}
```

**Key Points:**
| Line | Code | Explanation |
|------|------|-------------|
| 9 | `@Value("Mr.India")` | Injects string value directly into `name` field |
| 12 | `@Value("100")` | Injects int value, Spring auto-converts String to int |
| - | No setter needed | @Value on field doesn't require setter method |

---

### Example 3: @Value with Property Placeholders

**File: application.properties**
```properties
db.url=jdbc:mysql://localhost:3306/mydb
db.username=root
db.password=secret
app.name=MyApplication
```

**File: DatabaseConfig.java**
```java
@Configuration
@PropertySource("classpath:application.properties")
public class DatabaseConfig {

    @Value("${db.url}")
    private String dbUrl;
    
    @Value("${db.username}")
    private String username;
    
    @Value("${db.password}")
    private String password;
    
    @Bean
    public DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();
        ds.setJdbcUrl(dbUrl);
        ds.setUsername(username);
        ds.setPassword(password);
        return ds;
    }
}
```

---

## 7. Configuration vs Component

### When to Use What?

```
┌─────────────────────────────────────────────────────────────┐
│          @Configuration vs @Component                        │
│                                                              │
│   @Component + @Value (Class-level)                          │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Used when YOU own the class                       │   │
│   │  • Class IS the bean                                 │   │
│   │  • Use @Value for simple value injection             │   │
│   │                                                      │   │
│   │  @Component                                          │   │
│   │  public class MyService {                            │   │
│   │      @Value("${service.timeout}")                    │   │
│   │      private int timeout;                            │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   @Bean in @Configuration (Method-level)                     │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Used when you DON'T own the class (3rd party)     │   │
│   │  • Need complex initialization logic                 │   │
│   │                                                      │   │
│   │  @Configuration                                      │   │
│   │  public class AppConfig {                            │   │
│   │      @Bean                                           │   │
│   │      public DataSource dataSource() {                │   │
│   │          return new HikariDataSource();              │   │
│   │      }                                               │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│           JAVA-BASED CONFIGURATION FLOW                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: Create Container                                    │
│  ────────────────────────                                   │
│  AnnotationConfigApplicationContext ctx =                    │
│      new AnnotationConfigApplicationContext(                 │
│          MyAppConfiguration.class);                          │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Process @Configuration class                        │
│  ────────────────────────────────────                       │
│  Spring sees: @Configuration on MyAppConfiguration          │
│  Spring creates a CGLIB proxy of this class                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: Process @Bean methods                               │
│  ─────────────────────────────                              │
│  Spring calls: getMyDAOBean() method                        │
│  OUTPUT: "inside getMyDAOBean method"                       │
│  Registers: bean "getMyDAOBean" = MyBean instance           │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: Process @Value annotations                          │
│  ──────────────────────────────────                         │
│  For @Component classes with @Value:                        │
│  Injects "Mr.India" → name field                            │
│  Injects "100" → age field (converts to int)                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Common Interview Questions

### Q1: What is @Configuration annotation?
**A:** @Configuration marks a class as a source of bean definitions. It's the Java equivalent of a Spring XML configuration file.

### Q2: What is @Bean annotation?
**A:** @Bean is a method-level annotation. The return value is registered as a Spring bean. Method name = default bean ID.

### Q3: What is @Value annotation?
**A:** @Value injects primitive values directly into fields. It's an alternative to `<property>` tag in XML. Can also read from properties files using `${property.name}`.

### Q4: How many times is a @Bean method called?
**A:** Only ONCE (singleton by default). Spring caches the result.

### Q5: Can @Value inject from properties file?
**A:** Yes, using `@Value("${property.name}")` syntax. Requires `@PropertySource` annotation on configuration class.

---

## 10. Key Takeaways

📌 **@Configuration** marks a class as bean definition source

📌 **@Bean** on a method registers return value as Spring bean

📌 **@Value** injects primitive values directly into fields

📌 **@Value** is an alternative to `<property>` tag in XML

📌 **@Value("${prop}")** reads from properties files

📌 Use **AnnotationConfigApplicationContext** for Java config

📌 **Method name** becomes the **bean ID** by default

📌 Use **@Bean** for **third-party classes**, **@Component + @Value** for your own

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│         JAVA-BASED CONFIGURATION QUICK REFERENCE             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  @Configuration  → Marks class as bean definition source    │
│  @Bean           → Method return value is a bean            │
│  @Value("text")  → Injects literal value                    │
│  @Value("${x}")  → Injects from properties file             │
│                                                              │
│  EQUIVALENCE:                                                │
│  @Value("Hello") ≈ <property name="x" value="Hello"/>       │
│  @Bean           ≈ <bean id="..." class="..."/>             │
│  @Configuration  ≈ <beans>...</beans>                       │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [08. Component Scanning and Annotations](./08_Component_Scanning_and_Annotations.md)*

*Next: [10. AOP Fundamentals](./10_AOP_Fundamentals.md)*
