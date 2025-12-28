# Java-Based Configuration (@Configuration and @Bean)

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Java-Based Configuration](#2-what-is-java-based-configuration)
3. [The @Configuration Annotation](#3-the-configuration-annotation)
4. [The @Bean Annotation](#4-the-bean-annotation)
5. [Complete Code Example](#5-complete-code-example)
6. [Configuration vs Component](#6-configuration-vs-component)
7. [Execution Flow](#7-execution-flow)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

**Java-Based Configuration** is an alternative to XML configuration where beans are defined using Java code with annotations `@Configuration` and `@Bean`.

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
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   2. Annotation-Based (Component Scanning)                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Component                                          │   │
│   │  public class MyBean { }                             │   │
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

### Why Use Java-Based Configuration?

| Advantage | Description |
|-----------|-------------|
| **Type Safety** | Compile-time checking of bean definitions |
| **IDE Support** | Autocomplete, refactoring, navigation |
| **No XML** | Pure Java, no XML parsing |
| **Conditional Beans** | Easy to add logic around bean creation |
| **Testability** | Easy to mock and test configurations |

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

### Key Points

- Class marked with `@Configuration` is processed by Spring container
- Contains one or more `@Bean` annotated methods
- Acts like a factory for creating beans
- Spring creates a CGLIB proxy of this class internally

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

### Key Points

- Applied to a **method** inside a `@Configuration` class
- The method **returns** the bean instance
- Method name becomes the **default bean ID**
- Method is called **only once** (singleton by default)

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

### Specifying Custom Bean ID

```java
@Bean(name = "myCustomBean")
public MyBean getMyDAOBean() {
    return new MyBean();
}
```

---

## 5. Complete Code Example

### Example: Java-Based Configuration

**File: MyBean.java**
```java
package mypack;

public class MyBean {
    
    public MyBean() {
        System.out.println("MyBean constructor called");
    }
    
    public void doSomething() {
        System.out.println("MyBean doing something...");
    }
}
```

---

**File: MyAppConfiguration.java**
```java
package mypack;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// Line 6: @Configuration marks this class as a source of bean definitions
// This is equivalent to a Spring XML configuration file
@Configuration
public class MyAppConfiguration {

    // Line 9-14: @Bean annotation makes the return value a Spring bean
    // Method name "getMyDAOBean" becomes the bean ID
    // This method is called ONLY ONCE (singleton by default)
    @Bean  // makes MyBean as a component
    public MyBean getMyDAOBean() // gets called only once
    {
        System.out.println("inside getMyDAOBean method");
        return new MyBean();
    }
}
```

**Line-by-Line Explanation:**

| Line | Code | Explanation |
|------|------|-------------|
| 6 | `@Configuration` | Marks class as bean definition source |
| 9 | `@Bean` | Method return value is registered as bean |
| 10 | `public MyBean getMyDAOBean()` | Method name = bean ID |
| 12 | `System.out.println(...)` | Shows when method is called (only once) |
| 13 | `return new MyBean()` | Returns the bean instance to register |

---

**File: Main.java**
```java
package mypack;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Main {
    public static void main(String[] args) {
        // Create container using Java configuration class
        AnnotationConfigApplicationContext ctx = 
            new AnnotationConfigApplicationContext(MyAppConfiguration.class);
        
        System.out.println("Container created");
        
        // Get bean by method name (bean ID)
        MyBean bean1 = (MyBean) ctx.getBean("getMyDAOBean");
        MyBean bean2 = (MyBean) ctx.getBean("getMyDAOBean");
        
        // Same instance (singleton by default)
        System.out.println("bean1 == bean2: " + (bean1 == bean2));
        
        bean1.doSomething();
        
        ctx.close();
    }
}
```

**Key Points:**
- Uses `AnnotationConfigApplicationContext` instead of `ClassPathXmlApplicationContext`
- Pass the configuration class (not XML file) to constructor
- Bean ID is the method name `getMyDAOBean`

---

### Expected Output

```
inside getMyDAOBean method
MyBean constructor called
Container created
bean1 == bean2: true
MyBean doing something...
```

> **Notice**: "inside getMyDAOBean method" is printed only ONCE even though we call `getBean()` twice! This proves singleton behavior.

---

## 6. Configuration vs Component

### When to Use What?

```
┌─────────────────────────────────────────────────────────────┐
│          @Configuration vs @Component                        │
│                                                              │
│   @Component (Class-level annotation)                        │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Used when YOU own the class                       │   │
│   │  • Class IS the bean                                 │   │
│   │  • Simple bean with no special initialization        │   │
│   │                                                      │   │
│   │  @Component                                          │   │
│   │  public class MyService { }                          │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   @Bean in @Configuration (Method-level)                     │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Used when you DON'T own the class (3rd party)     │   │
│   │  • Class from external library                       │   │
│   │  • Need complex initialization logic                 │   │
│   │  • Need conditional bean creation                    │   │
│   │                                                      │   │
│   │  @Configuration                                      │   │
│   │  public class AppConfig {                            │   │
│   │      @Bean                                           │   │
│   │      public DataSource dataSource() {                │   │
│   │          // Complex setup for external library       │   │
│   │          return new HikariDataSource();              │   │
│   │      }                                               │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Comparison Table

| Aspect | @Component | @Bean (in @Configuration) |
|--------|------------|---------------------------|
| **Level** | Class-level | Method-level |
| **Bean per** | Class | Method |
| **Use when** | Own the class | Don't own class (3rd party) |
| **Logic** | Simple instantiation | Can have complex logic |
| **Container** | Needs component-scan | Needs config class |

---

## 7. Execution Flow

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
│  Spring sees: @Bean on getMyDAOBean()                       │
│  Spring calls: getMyDAOBean() method                        │
│  OUTPUT: "inside getMyDAOBean method"                       │
│  OUTPUT: "MyBean constructor called"                        │
│  Spring registers: bean "getMyDAOBean" = MyBean instance    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: Container Ready                                     │
│  ───────────────────────                                    │
│  All @Bean methods processed and beans registered           │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: getBean("getMyDAOBean")                             │
│  ───────────────────────────────                            │
│  Returns the SAME pre-created bean (singleton)              │
│  @Bean method NOT called again!                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Common Interview Questions

### Q1: What is @Configuration annotation?
**A:** @Configuration marks a class as a source of bean definitions. It's the Java equivalent of a Spring XML configuration file. The class contains @Bean methods that define and configure beans.

### Q2: What is @Bean annotation?
**A:** @Bean is a method-level annotation used inside @Configuration classes. The method's return value is registered as a Spring bean. The method name becomes the default bean ID.

### Q3: What container class is used with Java-based configuration?
**A:** `AnnotationConfigApplicationContext` is used instead of `ClassPathXmlApplicationContext`. You pass the configuration class to its constructor.

### Q4: How many times is a @Bean method called?
**A:** By default, only ONCE (singleton scope). Spring caches the result and returns the same instance for subsequent requests.

### Q5: When should I use @Bean instead of @Component?
**A:** Use @Bean when:
- You don't own the class (third-party library)
- You need complex initialization logic
- You need conditional bean creation
- You want to configure beans from external libraries

---

## 9. Key Takeaways

📌 **@Configuration** marks a class as a bean definition source (like XML file)

📌 **@Bean** on a method registers the return value as a Spring bean

📌 **Method name** becomes the **bean ID** by default

📌 **@Bean method** is called **only once** (singleton by default)

📌 Use **AnnotationConfigApplicationContext** for Java-based config

📌 Use **@Bean** for **third-party classes** you don't own

📌 Use **@Component** for **your own classes** with simple instantiation

📌 **Type-safe** - compile-time checking unlike XML

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│         JAVA-BASED CONFIGURATION QUICK REFERENCE             │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BASIC SYNTAX:                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  @Configuration                                      │    │
│  │  public class MyConfig {                             │    │
│  │                                                      │    │
│  │      @Bean                                           │    │
│  │      public MyBean myBean() {                        │    │
│  │          return new MyBean();                        │    │
│  │      }                                               │    │
│  │                                                      │    │
│  │      @Bean(name = "customId")                        │    │
│  │      public OtherBean otherBean() {                  │    │
│  │          return new OtherBean();                     │    │
│  │      }                                               │    │
│  │  }                                                   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  CONTAINER CREATION:                                         │
│  AnnotationConfigApplicationContext ctx =                    │
│      new AnnotationConfigApplicationContext(MyConfig.class); │
│                                                              │
│  EQUIVALENCE:                                                │
│  @Configuration class ≈ <beans> XML file                    │
│  @Bean method        ≈ <bean> XML tag                       │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [08. Component Scanning and Annotations](./08_Component_Scanning_and_Annotations.md)*

*Next: [10. Introduction to AOP](./10_Introduction_to_AOP.md)*
