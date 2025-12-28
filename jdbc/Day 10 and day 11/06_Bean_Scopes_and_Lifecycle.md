# Bean Scopes and Lifecycle

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Bean Scope](#2-what-is-bean-scope)
3. [Singleton Scope (Default)](#3-singleton-scope-default)
4. [Prototype Scope](#4-prototype-scope)
5. [Web Application Scopes](#5-web-application-scopes)
6. [Eager vs Lazy Initialization](#6-eager-vs-lazy-initialization)
7. [Bean Lifecycle](#7-bean-lifecycle)
8. [Complete Code Examples](#8-complete-code-examples)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

**Bean Scope** determines:
- **How many instances** of a bean are created
- **How long** those instances live
- **Who shares** the same instance

> **Key Point**: Understanding scopes is crucial for managing memory, thread safety, and application behavior.

---

## 2. What is Bean Scope

### Definition

Bean scope defines the **lifecycle and visibility** of a bean within the Spring container.

```
┌─────────────────────────────────────────────────────────────┐
│                      BEAN SCOPES                             │
│                                                              │
│   <bean id="a1" class="mypack.MyClass" />                   │
│                                     ↑                        │
│                       Scope of bean "a1"                     │
│                                                              │
│   SCOPE DETERMINES:                                          │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • How many objects are created?                    │   │
│   │  • When are they created?                           │   │
│   │  • When are they destroyed?                         │   │
│   │  • Who gets which instance?                         │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Available Scopes in Spring

| Scope | Instances | Availability |
|-------|-----------|--------------|
| **singleton** | One per container | All applications |
| **prototype** | New one each request | All applications |
| **request** | One per HTTP request | Web only |
| **session** | One per HTTP session | Web only |
| **global-session** | One per global session | Portlet only |

---

## 3. Singleton Scope (Default)

### What is Singleton Scope?

- **Only ONE instance** is created per Spring IOC container
- Same object is returned for every `getBean()` call
- **Default scope** - if you don't specify scope, it's singleton
- Instance is created **eagerly** (at container startup)

### Syntax

```xml
<!-- Method 1: Implicit singleton (default) -->
<bean id="a1" class="mypack.MyClass"/>

<!-- Method 2: Explicit singleton -->
<bean id="a1" class="mypack.MyClass" scope="singleton"/>
```

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│                    SINGLETON SCOPE                           │
│                                                              │
│   ┌───────────────────────────────────────────────────┐     │
│   │              IOC CONTAINER                         │     │
│   │                                                    │     │
│   │   <bean id="a1" class="MyClass" scope="singleton"/>│    │
│   │                                                    │     │
│   │         ┌─────────────────┐                       │     │
│   │         │   MyClass       │ ◄── Only ONE instance │     │
│   │         │   instance      │     for entire        │     │
│   │         │   (id="a1")     │     container         │     │
│   │         └─────────────────┘                       │     │
│   │              ▲   ▲   ▲                            │     │
│   │              │   │   │                            │     │
│   └──────────────│───│───│────────────────────────────┘     │
│                  │   │   │                                   │
│   getBean("a1") ─┘   │   └─ getBean("a1")                   │
│                      │                                       │
│   getBean("a1") ─────┘                                      │
│                                                              │
│   ALL calls return the SAME object!                          │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

```java
BeanFactory factory = new ClassPathXmlApplicationContext("beans.xml");

// All three get the SAME object
MyClass obj1 = (MyClass) factory.getBean("a1");
MyClass obj2 = (MyClass) factory.getBean("a1");
MyClass obj3 = (MyClass) factory.getBean("a1");

System.out.println(obj1 == obj2);  // true
System.out.println(obj2 == obj3);  // true
// Same hashcode for all!
```

### When to Use Singleton

✅ Stateless beans (no instance variables that change)
✅ Service classes
✅ DAO/Repository classes
✅ Utility classes
✅ Configuration classes

### When NOT to Use Singleton

❌ Stateful beans (instance variables that change per user)
❌ Beans that store user-specific data
❌ Non-thread-safe beans

---

## 4. Prototype Scope

### What is Prototype Scope?

- **New instance** is created for every `getBean()` call
- Container creates the object but **does NOT manage** its complete lifecycle
- Instance is created **lazily** (only when requested)

### Syntax

```xml
<bean id="a1" class="mypack.MyClass" scope="prototype"/>
```

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│                    PROTOTYPE SCOPE                           │
│                                                              │
│   ┌───────────────────────────────────────────────────┐     │
│   │              IOC CONTAINER                         │     │
│   │                                                    │     │
│   │   <bean id="a1" class="MyClass" scope="prototype"/>│    │
│   │                                                    │     │
│   │   getBean("a1") → Creates new MyClass instance #1 │     │
│   │   getBean("a1") → Creates new MyClass instance #2 │     │
│   │   getBean("a1") → Creates new MyClass instance #3 │     │
│   │                                                    │     │
│   └───────────────────────────────────────────────────┘     │
│                                                              │
│   Each call creates a DIFFERENT object!                      │
│                                                              │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐                   │
│   │ obj1    │   │ obj2    │   │ obj3    │                   │
│   │ #hash1  │   │ #hash2  │   │ #hash3  │                   │
│   └─────────┘   └─────────┘   └─────────┘                   │
│       ↑             ↑             ↑                          │
│       │             │             │                          │
│   getBean()     getBean()     getBean()                     │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

```java
BeanFactory factory = new ClassPathXmlApplicationContext("beans.xml");

// Each call creates a NEW object
MyClass obj1 = (MyClass) factory.getBean("a1");
MyClass obj2 = (MyClass) factory.getBean("a1");
MyClass obj3 = (MyClass) factory.getBean("a1");

System.out.println(obj1 == obj2);  // false
System.out.println(obj2 == obj3);  // false
// Different hashcode for each!
```

### When to Use Prototype

✅ Stateful beans
✅ Beans that store user-specific data
✅ When each request needs a fresh object
✅ Non-thread-safe beans

---

## 5. Web Application Scopes

### Request Scope

- **One instance per HTTP request**
- Object destroyed when request completes
- Available only in web-aware Spring `ApplicationContext`

```xml
<bean id="loginAction" class="mypack.LoginAction" scope="request"/>
```

```
┌─────────────────────────────────────────────────────────────┐
│                     REQUEST SCOPE                            │
│                                                              │
│   HTTP Request #1 ─────┐                                    │
│                        ▼                                    │
│                   ┌─────────┐                               │
│                   │ obj #1  │ ← Lives until request ends   │
│                   └─────────┘                               │
│                                                              │
│   HTTP Request #2 ─────┐                                    │
│                        ▼                                    │
│                   ┌─────────┐                               │
│                   │ obj #2  │ ← Different object            │
│                   └─────────┘                               │
└─────────────────────────────────────────────────────────────┘
```

### Session Scope

- **One instance per HTTP session**
- Same object shared across multiple requests of same user
- Object destroyed when session ends

```xml
<bean id="userPreferences" class="mypack.UserPreferences" scope="session"/>
```

```
┌─────────────────────────────────────────────────────────────┐
│                     SESSION SCOPE                            │
│                                                              │
│   User A - Session 1:                                        │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Request 1 ────┐                                    │   │
│   │                ▼                                    │   │
│   │           ┌─────────┐                               │   │
│   │  Request 2 ──▶│ obj #1  │ ← Same object for session │   │
│   │                └─────────┘                               │   │
│   │  Request 3 ────┘                                    │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   User B - Session 2:                                        │
│   ┌─────────────────────────────────────────────────────┐   │
│   │           ┌─────────┐                               │   │
│   │           │ obj #2  │ ← Different session = new obj │   │
│   │           └─────────┘                               │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Global Session Scope

- Used only in **Portlet-based** web applications
- One instance shared across all sessions in a global scope
- Rarely used in modern applications

```xml
<bean id="globalSettings" class="mypack.GlobalSettings" scope="global-session"/>
```

---

## 6. Eager vs Lazy Initialization

### Eager Initialization (Default)

- Beans are created **immediately** when container starts
- Happens before any `getBean()` call
- **Default behavior** for singleton beans
- Errors are detected early (at startup)

```
┌─────────────────────────────────────────────────────────────┐
│                   EAGER INITIALIZATION                       │
│                                                              │
│   ApplicationContext ctx =                                   │
│       new ClassPathXmlApplicationContext("beans.xml");       │
│                                                              │
│   ↓ At this point, ALL singleton beans are already created! │
│                                                              │
│   // Bean already exists, just returns reference            │
│   MyClass obj = ctx.getBean("a1");                          │
└─────────────────────────────────────────────────────────────┘
```

### Lazy Initialization

- Beans are created **only when first requested**
- First `getBean()` call triggers creation
- Use `lazy-init="true"` attribute
- Saves memory if bean is not always needed

```xml
<bean id="a1" class="mypack.MyClass" lazy-init="true"/>
```

```
┌─────────────────────────────────────────────────────────────┐
│                    LAZY INITIALIZATION                       │
│                                                              │
│   ApplicationContext ctx =                                   │
│       new ClassPathXmlApplicationContext("beans.xml");       │
│                                                              │
│   ↓ Bean "a1" is NOT created yet!                           │
│                                                              │
│   // Now bean is created (first access)                     │
│   MyClass obj = ctx.getBean("a1");                          │
│                                                              │
│   // Returns same instance (still singleton by default)     │
│   MyClass obj2 = ctx.getBean("a1");                         │
└─────────────────────────────────────────────────────────────┘
```

### Comparison Table

| Aspect | Eager (Default) | Lazy |
|--------|-----------------|------|
| **Creation Time** | Container startup | First `getBean()` |
| **Memory** | Used from start | Saved until needed |
| **Error Detection** | Early (startup) | Late (first access) |
| **Startup Time** | Slower (creates all) | Faster |
| **XML Attribute** | Default | `lazy-init="true"` |

### Scope vs Initialization

| Scope | Default Initialization |
|-------|----------------------|
| singleton | **Eager** |
| prototype | **Lazy** (always) |
| request | Lazy (per request) |
| session | Lazy (per session) |

> **Important**: Prototype beans are **always lazy** - they're only created when requested.

---

## 7. Bean Lifecycle

### Lifecycle Stages

```
┌─────────────────────────────────────────────────────────────┐
│                    BEAN LIFECYCLE                            │
│                                                              │
│   1. INSTANTIATION                                           │
│      ─────────────                                          │
│      Container creates bean using constructor               │
│                          │                                   │
│                          ▼                                   │
│   2. POPULATE PROPERTIES                                     │
│      ───────────────────                                    │
│      Setter/Constructor injection happens                   │
│                          │                                   │
│                          ▼                                   │
│   3. BEAN NAME AWARE                                         │
│      ─────────────────                                      │
│      setBeanName() called if bean implements BeanNameAware  │
│                          │                                   │
│                          ▼                                   │
│   4. BEAN FACTORY AWARE                                      │
│      ──────────────────                                     │
│      setBeanFactory() called if implements BeanFactoryAware │
│                          │                                   │
│                          ▼                                   │
│   5. PRE-INITIALIZATION (BeanPostProcessor)                  │
│      ──────────────────────────────────                     │
│      postProcessBeforeInitialization() called               │
│                          │                                   │
│                          ▼                                   │
│   6. INITIALIZATION                                          │
│      ──────────────                                         │
│      @PostConstruct or init-method called                   │
│                          │                                   │
│                          ▼                                   │
│   7. POST-INITIALIZATION (BeanPostProcessor)                 │
│      ───────────────────────────────────                    │
│      postProcessAfterInitialization() called                │
│                          │                                   │
│                          ▼                                   │
│   8. BEAN READY FOR USE                                      │
│      ───────────────────                                    │
│      Bean is now fully initialized and can be used          │
│                          │                                   │
│                          ▼                                   │
│   9. DESTRUCTION                                             │
│      ───────────                                            │
│      @PreDestroy or destroy-method called when              │
│      container is closed                                    │
└─────────────────────────────────────────────────────────────┘
```

### Init and Destroy Methods

```xml
<bean id="myBean" class="mypack.MyBean" 
      init-method="init" 
      destroy-method="cleanup"/>
```

```java
public class MyBean {
    
    public void init() {
        // Called after properties are set
        // Initialize resources, connections, etc.
        System.out.println("Bean initialized!");
    }
    
    public void cleanup() {
        // Called when container is closed
        // Release resources, close connections, etc.
        System.out.println("Bean destroyed!");
    }
}
```

---

## 8. Complete Code Examples

### Singleton vs Prototype Demo

**File: MyClass.java**
```java
package mypack;

public class MyClass {
    // Constructor prints message to show when object is created
    public MyClass() {
        System.out.println("MyClass constructor called. Object created!");
    }
}
```

**File: beans.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">

    <!-- Singleton scope (default) - only one instance -->
    <bean id="singletonBean" class="mypack.MyClass" scope="singleton"/>
    
    <!-- Prototype scope - new instance each time -->
    <bean id="prototypeBean" class="mypack.MyClass" scope="prototype"/>
    
    <!-- Lazy singleton - created only when first requested -->
    <bean id="lazyBean" class="mypack.MyClass" lazy-init="true"/>

</beans>
```

**File: Main.java**
```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== Creating Container ===");
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("beans.xml");
        System.out.println("=== Container Created ===\n");
        
        // Notice: singletonBean is already created (eager)
        // Notice: lazyBean is NOT created yet (lazy)
        // Notice: prototypeBean is NOT created yet (prototype is always lazy)
        
        System.out.println("=== Testing Singleton ===");
        MyClass s1 = (MyClass) ctx.getBean("singletonBean");
        MyClass s2 = (MyClass) ctx.getBean("singletonBean");
        System.out.println("s1 == s2: " + (s1 == s2));  // true
        
        System.out.println("\n=== Testing Prototype ===");
        MyClass p1 = (MyClass) ctx.getBean("prototypeBean");
        MyClass p2 = (MyClass) ctx.getBean("prototypeBean");
        System.out.println("p1 == p2: " + (p1 == p2));  // false
        
        System.out.println("\n=== Testing Lazy Singleton ===");
        MyClass l1 = (MyClass) ctx.getBean("lazyBean");  // Created now!
        MyClass l2 = (MyClass) ctx.getBean("lazyBean");
        System.out.println("l1 == l2: " + (l1 == l2));  // true
        
        ctx.close();
    }
}
```

**Expected Output:**
```
=== Creating Container ===
MyClass constructor called. Object created!     <- singletonBean (eager)
=== Container Created ===

=== Testing Singleton ===
s1 == s2: true

=== Testing Prototype ===
MyClass constructor called. Object created!     <- prototypeBean call 1
MyClass constructor called. Object created!     <- prototypeBean call 2
p1 == p2: false

=== Testing Lazy Singleton ===
MyClass constructor called. Object created!     <- lazyBean (first access)
l1 == l2: true
```

---

## 9. Common Interview Questions

### Q1: What are the bean scopes in Spring?
**A:** Five scopes:
1. **singleton** (default) - one instance per container
2. **prototype** - new instance per getBean()
3. **request** - one instance per HTTP request (web only)
4. **session** - one instance per HTTP session (web only)
5. **global-session** - one instance per global session (portlet only)

### Q2: What is the default scope of a Spring bean?
**A:** **Singleton** - only one instance is created and shared across all requests.

### Q3: What is the difference between singleton and prototype scope?
**A:** 
- **Singleton**: One instance per container, same object returned every time
- **Prototype**: New instance created for each getBean() call

### Q4: What is the difference between eager and lazy initialization?
**A:**
- **Eager**: Bean created at container startup (default for singleton)
- **Lazy**: Bean created only when first requested (prototype is always lazy)

### Q5: Can you make a singleton bean lazy?
**A:** Yes, using `lazy-init="true"`:
```xml
<bean id="myBean" class="MyClass" lazy-init="true"/>
```

---

## 10. Key Takeaways

📌 **Singleton (default)**: One instance per container, shared everywhere

📌 **Prototype**: New instance for each request, not fully managed by container

📌 **Request/Session**: Web-specific scopes based on HTTP request/session

📌 **Eager (default for singleton)**: Created at container startup

📌 **Lazy**: Created only when first requested

📌 **Prototype is always lazy**: Only created when getBean() is called

📌 **Singleton + Eager** = Detected errors early at startup

📌 **Use singleton** for stateless beans, **prototype** for stateful beans

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│             BEAN SCOPES QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SCOPE SYNTAX:                                               │
│  <bean id="..." class="..." scope="singleton"/>             │
│  <bean id="..." class="..." scope="prototype"/>             │
│                                                              │
│  LAZY INIT:                                                  │
│  <bean id="..." class="..." lazy-init="true"/>              │
│                                                              │
│  SUMMARY TABLE:                                              │
│  ┌──────────────┬──────────┬──────────┐                     │
│  │ Scope        │ Instances│ Init     │                     │
│  ├──────────────┼──────────┼──────────┤                     │
│  │ singleton    │ 1        │ Eager    │                     │
│  │ prototype    │ Many     │ Lazy     │                     │
│  │ request      │ Per req  │ Lazy     │                     │
│  │ session      │ Per sess │ Lazy     │                     │
│  └──────────────┴──────────┴──────────┘                     │
│                                                              │
│  getBean() BEHAVIOR:                                         │
│  singleton → returns SAME object                            │
│  prototype → returns NEW object                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [05. Constructor Injection Deep Dive](./05_Constructor_Injection_Deep_Dive.md)*

*Next: [07. Autowiring in Spring](./07_Autowiring_in_Spring.md)*
