# AOP Terminology and Concepts

## Table of Contents
1. [Introduction](#1-introduction)
2. [Key AOP Terms](#2-key-aop-terms)
3. [Aspect](#3-aspect)
4. [Join Point](#4-join-point)
5. [Pointcut](#5-pointcut)
6. [Advice Types](#6-advice-types)
7. [Weaving](#7-weaving)
8. [Target Object and Proxy](#8-target-object-and-proxy)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

Understanding AOP terminology is essential for working with Spring AOP effectively. This note covers all the key concepts and terms used in Aspect-Oriented Programming.

---

## 2. Key AOP Terms

| Term | Definition |
|------|------------|
| **Aspect** | A module containing cross-cutting concern code |
| **Join Point** | A point in program execution where aspect can be applied |
| **Pointcut** | Expression that selects which join points to apply advice to |
| **Advice** | The actual code to execute at a join point |
| **Target Object** | The object being advised (original business object) |
| **Proxy** | The object created by AOP that wraps the target |
| **Weaving** | Process of applying aspects to target objects |

---

## 3. Aspect

### What is an Aspect?

An **Aspect** is a module that encapsulates a cross-cutting concern. It contains the logic that you want to apply across multiple classes.

```
┌─────────────────────────────────────────────────────────────┐
│                      ASPECT                                  │
│                                                              │
│   An Aspect contains:                                        │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Aspect                                             │   │
│   │  public class LoggingAspect {                        │   │
│   │                                                      │   │
│   │      // POINTCUT - WHERE to apply                    │   │
│   │      @Pointcut("execution(* mypack.*.*(..))")       │   │
│   │      public void allMethods() {}                    │   │
│   │                                                      │   │
│   │      // ADVICE - WHAT to do                          │   │
│   │      @Before("allMethods()")                         │   │
│   │      public void logBefore() {                       │   │
│   │          System.out.println("Before method");        │   │
│   │      }                                               │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Aspect = Pointcut + Advice                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Join Point

### What is a Join Point?

A **Join Point** is a specific point in the execution of a program where an aspect can be applied. In Spring AOP, a join point is always a **method execution**.

```
┌─────────────────────────────────────────────────────────────┐
│                    JOIN POINTS                               │
│                                                              │
│   public class BankService {                                │
│                                                              │
│       public void deposit() {        ← JOIN POINT 1        │
│           // ...                                             │
│       }                                                      │
│                                                              │
│       public void withdraw() {       ← JOIN POINT 2        │
│           // ...                                             │
│       }                                                      │
│                                                              │
│       public void transfer() {       ← JOIN POINT 3        │
│           // ...                                             │
│       }                                                      │
│   }                                                          │
│                                                              │
│   Every method execution is a potential join point!         │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Pointcut

### What is a Pointcut?

A **Pointcut** is an expression that selects which join points to apply advice to. It defines WHERE the advice should run.

### Pointcut Expression Syntax

```
execution(modifiers? return-type declaring-type? method-name(params) throws?)
```

### Common Pointcut Examples

```
┌─────────────────────────────────────────────────────────────┐
│                POINTCUT EXPRESSIONS                          │
│                                                              │
│  All methods in a class:                                     │
│  execution(* mypack.ProductService.*(..))                   │
│            ↑              ↑         ↑  ↑                    │
│            │              │         │  └── any arguments    │
│            │              │         └── any method          │
│            │              └── in ProductService class       │
│            └── any return type                              │
│                                                              │
│  All methods in package:                                     │
│  execution(* mypack.*.*(..))                                │
│                                                              │
│  All public methods:                                         │
│  execution(public * mypack.*.*(..))                         │
│                                                              │
│  Methods returning int:                                      │
│  execution(int mypack.*.*(..))                              │
│                                                              │
│  All subpackages (..):                                       │
│  execution(* mypack..*.*(..))                               │
│                  ↑↑                                          │
│                  └── includes all subpackages               │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Advice Types

Spring AOP supports **5 types of advice**:

### 6.1 Before Advice (@Before)

Executes **before** the target method.

```java
@Before("execution(* mypack.*.*(..))")
public void beforeAdvice() {
    System.out.println("Before method execution");
}
```

### 6.2 After Returning Advice (@AfterReturning)

Executes **after** successful method completion.

```java
@AfterReturning(pointcut = "execution(* mypack.*.*(..))", returning = "result")
public void afterReturning(Object result) {
    System.out.println("Method returned: " + result);
}
```

### 6.3 After Throwing Advice (@AfterThrowing)

Executes **after** method throws an exception.

```java
@AfterThrowing(pointcut = "execution(* mypack.*.*(..))", throwing = "ex")
public void afterThrowing(Exception ex) {
    System.out.println("Exception: " + ex.getMessage());
}
```

### 6.4 After (Finally) Advice (@After)

Executes **after** method (regardless of outcome).

```java
@After("execution(* mypack.*.*(..))")
public void afterAdvice() {
    System.out.println("Finally - after method (success or exception)");
}
```

### 6.5 Around Advice (@Around)

**Most powerful** - wraps entire method execution.

```java
@Around("execution(* mypack.*.*(..))")
public Object aroundAdvice(ProceedingJoinPoint pjp) throws Throwable {
    System.out.println("Before");
    Object result = pjp.proceed();  // Call actual method
    System.out.println("After");
    return result;
}
```

### Visual Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    ADVICE EXECUTION ORDER                    │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @Before                                             │   │
│   │  "Execute BEFORE method runs"                        │   │
│   └─────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                      │   │
│   │  ┌───────────────────────────────────────────────┐  │   │
│   │  │         ACTUAL METHOD EXECUTION                │  │   │
│   │  │         (Target method runs here)              │  │   │
│   │  └───────────────────────────────────────────────┘  │   │
│   │                                                      │   │
│   │     ┌──────────────────┐  ┌──────────────────┐      │   │
│   │     │ Success ✓        │  │ Exception ✗      │      │   │
│   │     │                  │  │                  │      │   │
│   │     │ @AfterReturning  │  │ @AfterThrowing   │      │   │
│   │     └──────────────────┘  └──────────────────┘      │   │
│   │                                                      │   │
│   └─────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  @After (Finally)                                    │   │
│   │  "Execute AFTER method (success or failure)"         │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Weaving

### What is Weaving?

**Weaving** is the process of applying aspects to target objects to create proxied objects.

### Types of Weaving

| Weaving Type | When it Happens | Framework |
|--------------|-----------------|-----------|
| **Compile-time** | During compilation | AspectJ |
| **Load-time** | When class is loaded | AspectJ |
| **Runtime** | When application runs | Spring AOP |

> **Spring AOP uses Runtime Weaving** - creates proxy objects at runtime.

```
┌─────────────────────────────────────────────────────────────┐
│                    WEAVING PROCESS                           │
│                                                              │
│   RUNTIME WEAVING (Spring AOP):                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                                                      │   │
│   │   Target Object      Aspect                         │   │
│   │   ┌──────────┐       ┌──────────┐                   │   │
│   │   │BankService│  +   │LoggingAsp│                   │   │
│   │   └──────────┘       └──────────┘                   │   │
│   │         │                  │                         │   │
│   │         └────────┬─────────┘                         │   │
│   │                  │                                   │   │
│   │                  ▼                                   │   │
│   │         ┌───────────────┐                            │   │
│   │         │  PROXY OBJECT │                            │   │
│   │         │  (at runtime) │                            │   │
│   │         └───────────────┘                            │   │
│   │                                                      │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Target Object and Proxy

### Target Object

The **target object** is the actual business object being advised. It contains the original business logic.

### Proxy

The **proxy** is the object created by Spring AOP that wraps the target. All method calls go through the proxy.

```
┌─────────────────────────────────────────────────────────────┐
│              TARGET vs PROXY                                 │
│                                                              │
│   When you call: ctx.getBean("bankService")                 │
│                                                              │
│   You get:                                                   │
│   ┌─────────────────────────────────────────────────────┐   │
│   │              PROXY OBJECT                            │   │
│   │                                                      │   │
│   │  ┌───────────────────────────────────────────────┐  │   │
│   │  │  Before advice                                 │  │   │
│   │  │  Around advice (before)                        │  │   │
│   │  │                                                │  │   │
│   │  │  ──────────────────────────────────────────── │  │   │
│   │  │  │  TARGET OBJECT (BankService)            │  │  │   │
│   │  │  │  - deposit()                             │  │  │   │
│   │  │  │  - withdraw()                            │  │  │   │
│   │  │  ──────────────────────────────────────────── │  │   │
│   │  │                                                │  │   │
│   │  │  Around advice (after)                        │  │   │
│   │  │  After advice                                 │  │   │
│   │  └───────────────────────────────────────────────┘  │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   NOTE: You never interact directly with target object!     │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Common Interview Questions

### Q1: What is an Aspect?
**A:** An Aspect is a module that encapsulates cross-cutting concern code. It contains pointcuts (where) and advice (what).

### Q2: What is a Join Point?
**A:** A Join Point is a point in program execution where an aspect can be applied. In Spring AOP, it's always a method execution.

### Q3: What is a Pointcut?
**A:** A Pointcut is an expression that selects which join points to apply advice to. Example: `execution(* mypack.*.*(..))`

### Q4: What are the types of Advice?
**A:** Five types:
1. **@Before** - before method
2. **@AfterReturning** - after successful return
3. **@AfterThrowing** - after exception
4. **@After** - always (finally)
5. **@Around** - wraps method execution

### Q5: What is Weaving?
**A:** Weaving is the process of applying aspects to target objects to create proxied objects. Spring AOP uses runtime weaving.

---

## 10. Key Takeaways

📌 **Aspect** = Pointcut + Advice

📌 **Join Point** = Method execution point

📌 **Pointcut** = WHERE to apply (expression)

📌 **Advice** = WHAT to do (code)

📌 **5 Advice Types**: Before, AfterReturning, AfterThrowing, After, Around

📌 **Weaving** = Applying aspects to create proxies

📌 **Spring AOP** = Runtime weaving

📌 **Proxy** wraps target, client never sees target directly

---

*Previous: [10. AOP Fundamentals](./10_AOP_Fundamentals.md)*

*Next: [12. AOP with XML Configuration](./12_AOP_with_XML_Configuration.md)*
