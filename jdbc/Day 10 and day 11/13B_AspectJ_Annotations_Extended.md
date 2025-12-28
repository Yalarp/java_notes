# Annotation-Based AOP (@Aspect)

## Table of Contents
1. [Introduction](#1-introduction)
2. [Enabling AspectJ Support](#2-enabling-aspectj-support)
3. [Creating an Aspect Class](#3-creating-an-aspect-class)
4. [Pointcut Expressions](#4-pointcut-expressions)
5. [Advice Annotations](#5-advice-annotations)
6. [Complete Code Example](#6-complete-code-example)
7. [Execution Flow](#7-execution-flow)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

**Annotation-based AOP** is the modern, recommended approach for implementing AOP in Spring. It uses annotations like `@Aspect`, `@Before`, `@After`, etc. to define aspects.

> **Key Advantage**: No XML configuration for aspects - everything is in Java code!

---

## 2. Enabling AspectJ Support

### Step 1: Add AspectJ Dependency

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aspects</artifactId>
    <version>6.0.0</version>
</dependency>
```

### Step 2: Enable AspectJ Auto-Proxy

**XML Approach:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/aop
           http://www.springframework.org/schema/aop/spring-aop.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- Enable AspectJ auto-proxy -->
    <aop:aspectj-autoproxy/>
    
    <!-- Enable component scanning -->
    <context:component-scan base-package="mypack"/>

</beans>
```

**Java Configuration Approach:**
```java
@Configuration
@EnableAspectJAutoProxy
@ComponentScan("mypack")
public class AppConfig {
}
```

---

## 3. Creating an Aspect Class

### Structure of an Aspect

```java
@Aspect
@Component  // Important: Aspect must be a Spring bean!
public class LoggingAspect {
    
    @Before("execution(* mypack.*.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("Before: " + joinPoint.getSignature().getName());
    }
}
```

### Key Annotations

| Annotation | Purpose |
|------------|---------|
| `@Aspect` | Marks the class as an Aspect |
| `@Component` | Registers it as a Spring bean |
| `@Before` | Before advice |
| `@After` | After (finally) advice |
| `@AfterReturning` | After successful return advice |
| `@AfterThrowing` | After exception advice |
| `@Around` | Around advice |

---

## 4. Pointcut Expressions

### What is a Pointcut Expression?

A pointcut expression defines **which methods** the advice should apply to.

### Syntax

```
execution(modifiers-pattern? return-type-pattern declaring-type-pattern? 
          method-name-pattern(param-pattern) throws-pattern?)
```

### Common Examples

```
┌─────────────────────────────────────────────────────────────┐
│                POINTCUT EXPRESSION EXAMPLES                  │
│                                                              │
│  All methods in a class:                                     │
│  execution(* mypack.ProductService.*(..))                   │
│            ↑              ↑         ↑  ↑                    │
│            │              │         │  └── any arguments    │
│            │              │         └── any method          │
│            │              └── in ProductService class       │
│            └── any return type                              │
│                                                              │
│  Specific method:                                            │
│  execution(* mypack.ProductService.save(..))                │
│                                                              │
│  All methods in package:                                     │
│  execution(* mypack.*.*(..))                                │
│            ↑    ↑  ↑  ↑                                     │
│            │    │  │  └── any arguments                     │
│            │    │  └── any method                           │
│            │    └── any class in mypack                     │
│            └── any return type                              │
│                                                              │
│  All public methods:                                         │
│  execution(public * mypack.*.*(..))                         │
│            ↑                                                 │
│            └── public modifier                              │
│                                                              │
│  Methods returning int:                                      │
│  execution(int mypack.*.*(..))                              │
│            ↑                                                 │
│            └── return type int                              │
│                                                              │
│  Methods with specific argument:                             │
│  execution(* mypack.*.*(String))                            │
│                         ↑                                    │
│                         └── single String parameter         │
│                                                              │
│  All subpackages:                                            │
│  execution(* mypack..*.*(..))                               │
│                  ↑↑                                          │
│                  └── includes all subpackages               │
└─────────────────────────────────────────────────────────────┘
```

### Reusable Pointcuts with @Pointcut

```java
@Aspect
@Component
public class LoggingAspect {
    
    // Define reusable pointcut
    @Pointcut("execution(* mypack.*Service.*(..))")
    public void serviceMethods() {}
    
    // Use the pointcut
    @Before("serviceMethods()")
    public void logBefore(JoinPoint jp) {
        System.out.println("Before: " + jp.getSignature().getName());
    }
    
    @After("serviceMethods()")
    public void logAfter(JoinPoint jp) {
        System.out.println("After: " + jp.getSignature().getName());
    }
}
```

---

## 5. Advice Annotations

### 5.1 @Before

Executes **before** the target method.

```java
@Before("execution(* mypack.*.*(..))")
public void logBefore(JoinPoint joinPoint) {
    System.out.println("Before method: " + joinPoint.getSignature().getName());
    System.out.println("Arguments: " + Arrays.toString(joinPoint.getArgs()));
}
```

### 5.2 @AfterReturning

Executes **after** successful return.

```java
@AfterReturning(
    pointcut = "execution(* mypack.*.*(..))",
    returning = "result"
)
public void logAfterReturning(JoinPoint joinPoint, Object result) {
    System.out.println("Method returned: " + result);
}
```

### 5.3 @AfterThrowing

Executes **after** exception is thrown.

```java
@AfterThrowing(
    pointcut = "execution(* mypack.*.*(..))",
    throwing = "exception"
)
public void logAfterThrowing(JoinPoint joinPoint, Exception exception) {
    System.out.println("Exception: " + exception.getMessage());
}
```

### 5.4 @After (Finally)

Executes **after** method (regardless of outcome).

```java
@After("execution(* mypack.*.*(..))")
public void logAfter(JoinPoint joinPoint) {
    System.out.println("After method (finally): " + joinPoint.getSignature().getName());
}
```

### 5.5 @Around

**Most powerful** - wraps the entire method execution.

```java
@Around("execution(* mypack.*.*(..))")
public Object logAround(ProceedingJoinPoint pjp) throws Throwable {
    long start = System.currentTimeMillis();
    
    System.out.println("Before method execution");
    
    try {
        // Call the actual method
        Object result = pjp.proceed();
        
        System.out.println("After method execution");
        return result;
        
    } finally {
        long duration = System.currentTimeMillis() - start;
        System.out.println("Method execution time: " + duration + "ms");
    }
}
```

> **Note**: `@Around` uses `ProceedingJoinPoint` (not `JoinPoint`) and must call `pjp.proceed()`.

---

## 6. Complete Code Example

### File: LoggingAspect.java

```java
package mypack;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

import java.util.Arrays;

// Line 8-9: @Aspect marks this as an Aspect
// @Component makes it a Spring bean (required!)
@Aspect
@Component
public class LoggingAspect {

    // Line 13-15: Define reusable pointcut for service methods
    @Pointcut("execution(* mypack.*Service.*(..))")
    public void serviceMethods() {}

    // Line 18-22: Before advice
    @Before("serviceMethods()")
    public void logBefore(JoinPoint jp) {
        System.out.println("=== BEFORE ===");
        System.out.println("Method: " + jp.getSignature().getName());
        System.out.println("Args: " + Arrays.toString(jp.getArgs()));
    }

    // Line 25-29: After returning advice
    @AfterReturning(pointcut = "serviceMethods()", returning = "result")
    public void logAfterReturning(JoinPoint jp, Object result) {
        System.out.println("=== AFTER RETURNING ===");
        System.out.println("Result: " + result);
    }

    // Line 32-36: After throwing advice
    @AfterThrowing(pointcut = "serviceMethods()", throwing = "ex")
    public void logAfterThrowing(JoinPoint jp, Exception ex) {
        System.out.println("=== AFTER THROWING ===");
        System.out.println("Exception: " + ex.getMessage());
    }

    // Line 39-43: After (finally) advice
    @After("serviceMethods()")
    public void logAfter(JoinPoint jp) {
        System.out.println("=== AFTER (FINALLY) ===");
    }
}
```

### File: ProductService.java

```java
package mypack;

import org.springframework.stereotype.Service;

@Service
public class ProductService {

    public int multiply(int a, int b) {
        System.out.println(">>> Executing multiply(" + a + ", " + b + ")");
        return a * b;
    }

    public void divideByZero() {
        System.out.println(">>> Executing divideByZero");
        int result = 10 / 0;  // Throws ArithmeticException
    }
}
```

### File: Main.java

```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("beans.xml");
        
        ProductService service = ctx.getBean(ProductService.class);
        
        // Test normal execution
        System.out.println("\n--- Calling multiply ---");
        int result = service.multiply(5, 3);
        System.out.println("Final Result: " + result);
        
        // Test exception
        System.out.println("\n--- Calling divideByZero ---");
        try {
            service.divideByZero();
        } catch (Exception e) {
            System.out.println("Caught: " + e.getMessage());
        }
        
        ctx.close();
    }
}
```

---

## 7. Execution Flow

### Normal Execution (multiply)

```
┌─────────────────────────────────────────────────────────────┐
│              ANNOTATION-BASED AOP FLOW                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: @Before advice                                      │
│  OUTPUT: "=== BEFORE ==="                                   │
│  OUTPUT: "Method: multiply"                                 │
│  OUTPUT: "Args: [5, 3]"                                     │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Actual method execution                             │
│  OUTPUT: ">>> Executing multiply(5, 3)"                     │
│  Returns: 15                                                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: @AfterReturning advice                              │
│  OUTPUT: "=== AFTER RETURNING ==="                          │
│  OUTPUT: "Result: 15"                                       │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: @After (finally) advice                             │
│  OUTPUT: "=== AFTER (FINALLY) ==="                          │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: Return to caller                                    │
│  OUTPUT: "Final Result: 15"                                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Exception Execution (divideByZero)

```
┌─────────────────────────────────────────────────────────────┐
│              EXCEPTION FLOW                                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: @Before advice                                      │
│  OUTPUT: "=== BEFORE ==="                                   │
│  OUTPUT: "Method: divideByZero"                             │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Actual method throws exception                      │
│  OUTPUT: ">>> Executing divideByZero"                       │
│  THROWS: ArithmeticException                                │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: @AfterThrowing advice                               │
│  OUTPUT: "=== AFTER THROWING ==="                           │
│  OUTPUT: "Exception: / by zero"                             │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: @After (finally) advice                             │
│  OUTPUT: "=== AFTER (FINALLY) ==="                          │
│  (Still executes on exception!)                             │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: Exception propagates to caller                      │
│  OUTPUT: "Caught: / by zero"                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Common Interview Questions

### Q1: What annotation marks a class as an Aspect?
**A:** `@Aspect` marks a class as an aspect. You also need `@Component` to make it a Spring bean.

### Q2: What is the difference between @After and @AfterReturning?
**A:** 
- `@After` executes always (like finally), regardless of success or exception
- `@AfterReturning` executes only when method returns successfully

### Q3: What is the difference between JoinPoint and ProceedingJoinPoint?
**A:** 
- `JoinPoint` is used in all advice types except @Around
- `ProceedingJoinPoint` is used only in @Around and has the `proceed()` method

### Q4: What does execution(* mypack..*.*(..)) mean?
**A:** Match any method (`*(..)`) in any class (`*`) in mypack or its subpackages (`..`) with any return type (`*`).

### Q5: What is the order of advice execution?
**A:** 
1. @Before
2. Method executes
3. @AfterReturning (if success) OR @AfterThrowing (if exception)
4. @After (always executes)

---

## 9. Key Takeaways

📌 **@Aspect + @Component** = Complete aspect definition

📌 **Enable with** `<aop:aspectj-autoproxy/>` or `@EnableAspectJAutoProxy`

📌 **Pointcut expression** defines where to apply advice

📌 **@Before** → before method

📌 **@AfterReturning** → after successful return

📌 **@AfterThrowing** → after exception

📌 **@After** → always (finally)

📌 **@Around** → most powerful, uses `ProceedingJoinPoint.proceed()`

📌 **Reusable pointcuts** with `@Pointcut` annotation

---

*Previous: [11. XML-based AOP Configuration](./11_XML_Based_AOP_Configuration.md)*

*Next: [13. Spring Templates Overview](./13_Spring_Templates_Overview.md)*
