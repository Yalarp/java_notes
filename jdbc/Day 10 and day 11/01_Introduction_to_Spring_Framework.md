# Introduction to Spring Framework

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Spring Framework](#2-what-is-spring-framework)
3. [History of Spring](#3-history-of-spring)
4. [Framework vs Library](#4-framework-vs-library)
5. [Spring Modules Overview](#5-spring-modules-overview)
6. [Why Spring is Lightweight](#6-why-spring-is-lightweight)
7. [Key Features of Spring](#7-key-features-of-spring)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

Spring Framework is one of the most popular and widely used frameworks in the Java ecosystem. It provides comprehensive infrastructure support for developing enterprise Java applications. Spring handles the infrastructure so you can focus on your application's business logic.

> **Why Learn Spring?**
> - Most Java job postings require Spring knowledge
> - Simplifies enterprise application development
> - Provides a consistent programming model
> - Excellent integration with other frameworks

---

## 2. What is Spring Framework

### Definition
Spring is an **open-source, lightweight framework** for developing enterprise Java applications. It provides great support for:

| Application Type | Description |
|------------------|-------------|
| **Object Communication** | Managing how objects interact (e.g., Student communicates with Course) |
| **JDBC** | Simplified database operations |
| **ORM** | Integration with Hibernate, MyBatis, JPA |
| **MVC Applications** | Web application development |

### Core Philosophy
Spring follows the principle of **"Don't call us, we'll call you"** (Hollywood Principle), which is the foundation of Inversion of Control (IOC).

```
┌─────────────────────────────────────────────────────────┐
│                    SPRING FRAMEWORK                      │
│                                                          │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐ │
│   │  Core   │   │   DAO   │   │   Web   │   │   AOP   │ │
│   │  (IOC)  │   │         │   │   MVC   │   │         │ │
│   └─────────┘   └─────────┘   └─────────┘   └─────────┘ │
│                                                          │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐ │
│   │   ORM   │   │   JEE   │   │  Test   │   │ Security│ │
│   │         │   │         │   │         │   │         │ │
│   └─────────┘   └─────────┘   └─────────┘   └─────────┘ │
└─────────────────────────────────────────────────────────┘
```

---

## 3. History of Spring

### Timeline

| Year | Event |
|------|-------|
| **2002** | Rod Johnson wrote "Expert One-on-One J2EE Design and Development" |
| **2003** | Spring Framework project started |
| **2004** | Spring 1.0 released |
| **2005** | Spring 2.0 released with major improvements |
| **2009** | VMware acquired SpringSource |
| **2013** | Pivotal spun off, took over Spring development |
| **2022** | Spring 6.0 released with Jakarta EE support |

### Why Was Spring Created?

Before Spring, developers used **Enterprise JavaBeans (EJB)** for enterprise applications. However, EJB had significant drawbacks:

```
┌────────────────────────────────────────────────┐
│           PROBLEMS WITH EJB                     │
├────────────────────────────────────────────────┤
│ ❌ Heavy and complex                           │
│ ❌ Required application server                 │
│ ❌ Had to take ALL features (no modularity)    │
│ ❌ Difficult to test                           │
│ ❌ Too much configuration                      │
└────────────────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────────┐
│        SPRING FRAMEWORK SOLUTION                │
├────────────────────────────────────────────────┤
│ ✅ Lightweight and simple                      │
│ ✅ Works without application server            │
│ ✅ Take only what you need (modular)           │
│ ✅ Easy to test (POJO-based)                   │
│ ✅ Minimal configuration                       │
└────────────────────────────────────────────────┘
```

> **Key Point**: The main drawback of EJB was that we had to take ALL features even if we didn't need them. Spring solves this by being modular.

---

## 4. Framework vs Library

This is a **frequently asked interview question**. Understanding the difference is crucial.

### Library
- A **set of pre-written code** that you can use to build your application
- **You call** the library code
- Library does **NOT enforce** any pattern
- You have full control over the flow

### Framework
- A **supporting structure** that provides a foundation for building applications
- Framework **calls your code** (Inversion of Control)
- Framework **enforces patterns** and conventions
- The framework controls the flow

### Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                         LIBRARY                              │
│                                                              │
│    ┌──────────────┐                    ┌──────────────┐     │
│    │  Your Code   │ ──── calls ────▶  │   Library    │     │
│    └──────────────┘                    └──────────────┘     │
│                                                              │
│    YOU are in control. You decide when to call library.     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                        FRAMEWORK                             │
│                                                              │
│    ┌──────────────┐                    ┌──────────────┐     │
│    │  Framework   │ ──── calls ────▶  │  Your Code   │     │
│    └──────────────┘                    └──────────────┘     │
│                                                              │
│    FRAMEWORK is in control. It decides when to call you.    │
└─────────────────────────────────────────────────────────────┘
```

### Key Differences Table

| Aspect | Library | Framework |
|--------|---------|-----------|
| **Control Flow** | Your code calls library | Framework calls your code |
| **Pattern Enforcement** | No patterns enforced | Must follow framework patterns |
| **Flexibility** | High flexibility | Structured approach |
| **Analogy** | A collection of tools | A skeleton/blueprint |
| **Example** | GSON, Apache Commons | Spring, Hibernate |

### The Hollywood Principle
> "Don't call us, we'll call you"

This is also called **Inversion of Control (IOC)**. In traditional programming, your code controls the flow. With frameworks, the framework controls the flow and calls your code when needed.

---

## 5. Spring Modules Overview

Spring is designed as a modular framework. You can use only the modules you need.

### Core Modules

```
┌─────────────────────────────────────────────────────────────────────┐
│                         SPRING FRAMEWORK                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    CORE CONTAINER                            │    │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────────┐    │    │
│  │  │  Core   │ │  Beans  │ │ Context │ │ Expression Lang │    │    │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────────────┘    │    │
│  │                                                              │    │
│  │  * IOC Container is the FOUNDATION of entire Spring         │    │
│  │  * Manages lifecycle and dependencies of POJOs              │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐       │
│  │     DAO      │  │     ORM      │  │         JEE          │       │
│  ├──────────────┤  ├──────────────┤  ├──────────────────────┤       │
│  │ Spring JDBC  │  │  Hibernate   │  │ JMX, JMS, JCA        │       │
│  │ Transaction  │  │  JPA         │  │ Remoting, EJB        │       │
│  │ Management   │  │  TopLink     │  │ Email                │       │
│  │              │  │  MyBatis     │  │                      │       │
│  └──────────────┘  └──────────────┘  └──────────────────────┘       │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐                                 │
│  │     Web      │  │     AOP      │                                 │
│  ├──────────────┤  ├──────────────┤                                 │
│  │ Spring MVC   │  │ Aspect       │                                 │
│  │ Web Servlet  │  │ Oriented     │                                 │
│  │ Web Portlet  │  │ Programming  │                                 │
│  └──────────────┘  └──────────────┘                                 │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Module Descriptions

| Module | Purpose |
|--------|---------|
| **Core** | IOC Container - Foundation of Spring. Manages object lifecycle and dependencies |
| **Beans** | BeanFactory, bean definitions, instantiation |
| **Context** | ApplicationContext, builds on Core and Beans |
| **DAO** | Spring JDBC, Transaction management |
| **ORM** | Integration with Hibernate, JPA, TopLink, MyBatis, JDO |
| **JEE** | JMX, JMS, JCA, Remoting, EJB, Email support |
| **Web** | Spring MVC, Web Servlet, Web Portlet |
| **AOP** | Aspect Oriented Programming support |

### Core Container - The Foundation

The **IOC Container** is the most important part of Spring:

```java
// IOC Container is just a CLASS!
// This is what makes Spring lightweight
ClassPathXmlApplicationContext appContext = 
    new ClassPathXmlApplicationContext("beans.xml");
```

> **Key Insight**: IOC Container is lightweight because it's just a Java class, not a heavy application server.

---

## 6. Why Spring is Lightweight

### The "Lightweight" Concept

Spring is called **lightweight** for several reasons:

#### 1. Modular Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                         EJB (Heavy)                          │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  You MUST take ALL features even if not needed       │    │
│  │  ❌ Transaction  ❌ Security  ❌ Persistence         │    │
│  │  ❌ Messaging    ❌ Threading ❌ All modules         │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            VS
┌─────────────────────────────────────────────────────────────┐
│                      SPRING (Lightweight)                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Take ONLY what you need, ignore the rest            │    │
│  │  ✅ Core IOC (required)                              │    │
│  │  ⬜ DAO (optional)     ⬜ ORM (optional)             │    │
│  │  ⬜ Web (optional)     ⬜ AOP (optional)             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

#### 2. IOC Container is a Class

```java
// The IOC Container is simply a Java class
// NOT a heavy container like EJB container

// This is the IOC Container:
ClassPathXmlApplicationContext container = 
    new ClassPathXmlApplicationContext("config.xml");

// It's just a class! That's why it's lightweight.
```

#### 3. POJO-Based Development

```java
// Spring works with Plain Old Java Objects (POJOs)
// No need to extend framework classes

public class MyService {  // Just a simple POJO
    private MyRepository repository;
    
    // Spring injects dependencies
    public void setRepository(MyRepository repository) {
        this.repository = repository;
    }
}
```

---

## 7. Key Features of Spring

### 7.1 Inversion of Control (IOC)
The IOC Container manages POJOs and their dependencies:

```
┌─────────────────────────────────────────────────────────┐
│                    IOC CONTAINER                         │
│                                                          │
│   Configuration ──▶ Container ──▶ Ready Objects         │
│      (XML or                       (POJOs with          │
│     Annotations)                   dependencies          │
│                                    injected)             │
└─────────────────────────────────────────────────────────┘
```

### 7.2 Dependency Injection (DI)
Three types of injection:

| Type | XML Element | Description |
|------|-------------|-------------|
| **Setter Injection** | `<property>` | Uses setter methods |
| **Constructor Injection** | `<constructor-arg>` | Uses constructors |
| **Field Injection** | `@Autowired` on field | Direct field injection |

### 7.3 Loose Coupling
Spring achieves loose coupling through:
- Interface-based programming
- Dependency Injection
- Configuration externalization

### 7.4 Declarative Programming
Make changes in XML without changing Java code:

```xml
<!-- Change implementation without touching Java code -->
<bean id="account" class="mypack.SavingAccountImpl"/>
<!-- OR -->
<bean id="account" class="mypack.CurrentAccountImpl"/>
```

### 7.5 Runtime Configuration
Two approaches for configuration:

| Approach | Description |
|----------|-------------|
| **XML Configuration** | Traditional, external configuration |
| **Annotation Configuration** | Modern, in-code configuration |

> **Important**: Whatever you can do with XML, you can also do with annotations.

---

## 8. Common Interview Questions

### Q1: What is Spring Framework?
**A:** Spring is a lightweight, open-source framework for developing enterprise Java applications. It provides comprehensive infrastructure support including IOC container, AOP, transaction management, and integration with various technologies.

### Q2: Why is Spring called lightweight?
**A:** Spring is lightweight because:
1. IOC Container is just a Java class, not a heavy container
2. Modular architecture - use only what you need
3. POJO-based development - no need to extend framework classes
4. Unlike EJB, you don't have to take all features

### Q3: What is the difference between Framework and Library?
**A:** 
- **Library**: Your code calls the library. You're in control.
- **Framework**: Framework calls your code (IOC). Framework is in control.
- Library doesn't enforce patterns; frameworks do.

### Q4: What are the main modules of Spring?
**A:** Core (IOC Container), Beans, Context, AOP, DAO, ORM, Web MVC, and JEE integration modules.

### Q5: What is IOC Container?
**A:** IOC Container is a Java class (like `ClassPathXmlApplicationContext`) that manages the lifecycle and dependencies of POJOs. It reads configuration (XML or annotations) and creates, configures, and wires beans.

---

## 9. Key Takeaways

📌 **Spring Framework** was created by Rod Johnson to address EJB's complexity

📌 **Framework vs Library**: Frameworks call your code; you call libraries

📌 **IOC Container** is the foundation - it's just a lightweight Java class

📌 **Lightweight** means you take only what you need, unlike EJB

📌 **Modular Architecture** allows using Spring modules independently

📌 **Configuration Options**: XML or Annotations (both achieve the same result)

📌 **Key Modules**: Core, Beans, Context, AOP, DAO, ORM, Web, JEE

📌 **POJO-Based**: No need to extend framework classes - simpler development

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                 SPRING QUICK REFERENCE                       │
├─────────────────────────────────────────────────────────────┤
│  Creator      : Rod Johnson (2003)                          │
│  Current      : Spring 6.x (Jakarta EE)                     │
│  Container    : ClassPathXmlApplicationContext              │
│                                                              │
│  CORE CONCEPTS:                                              │
│  • IOC        : Inversion of Control                        │
│  • DI         : Dependency Injection                        │
│  • AOP        : Aspect Oriented Programming                 │
│                                                              │
│  INJECTION TYPES:                                            │
│  • Setter     : <property name="..." value="..."/>          │
│  • Constructor: <constructor-arg type="..." value="..."/>   │
│  • Field      : @Autowired on field                         │
│                                                              │
│  CONFIGURATION:                                              │
│  • XML        : beans.xml                                   │
│  • Java       : @Configuration + @Bean                      │
│  • Annotation : @Component + @Autowired                     │
└─────────────────────────────────────────────────────────────┘
```

---

*Next: [02. Coupling and Dependency Injection](./02_Coupling_and_Dependency_Injection.md)*
