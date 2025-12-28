# AOP with Annotations (@Aspect, @Pointcut, Advice Types)

## Table of Contents
1. [Introduction](#1-introduction)
2. [Enabling AspectJ Support](#2-enabling-aspectj-support)
3. [Creating an Aspect Class](#3-creating-an-aspect-class)
4. [Pointcut Expressions Deep Dive](#4-pointcut-expressions-deep-dive)
5. [@Before Advice](#5-before-advice)
6. [@AfterReturning Advice](#6-afterreturning-advice)
7. [@AfterThrowing Advice](#7-afterthrowing-advice)
8. [@After Advice (Finally)](#8-after-advice-finally)
9. [@Around Advice](#9-around-advice)
10. [Reusable Pointcuts](#10-reusable-pointcuts)
11. [Complete Code Example](#11-complete-code-example)
12. [Execution Flow](#12-execution-flow)
13. [Common Interview Questions](#13-common-interview-questions)
14. [Key Takeaways](#14-key-takeaways)

---

## 1. Introduction

**Annotation-based AOP** using `@Aspect` is the modern approach to implementing AOP in Spring. It's cleaner, more readable, and the preferred method for new applications.

### Annotation-Based vs XML-Based AOP

| Feature | Annotation-Based | XML-Based |
|---------|-----------------|-----------|
| Configuration | In Java code | External XML file |
| Readability | ✅ Easy to read | More verbose |
| Type-safety | ✅ Compile-time check | Runtime errors |
| IDE Support | ✅ Full support | Limited |
| Preferred for | New applications | Legacy apps |

---

## 2. Enabling AspectJ Support

### Option 1: XML Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">

    <!-- Enable AspectJ auto-proxy -->
    <aop:aspectj-autoproxy/>
    
    <!-- Scan for components and aspects -->
    <context:component-scan base-package="mypack"/>

</beans>
```

### Option 2: Java Configuration (Recommended)

```java
@Configuration
@EnableAspectJAutoProxy       // Enables @Aspect processing
@ComponentScan("mypack")      // Scans for @Component, @Aspect
public class AppConfig {
}
```

### Required Dependencies (Maven)

```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-aop</artifactId>
    <version>6.x.x</version>
</dependency>
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.x</version>
</dependency>
```

---

## 3. Creating an Aspect Class

### Basic Aspect Structure

```java
package mypack;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Aspect      // Marks this class as an Aspect
@Component   // Must be a Spring bean!
public class LoggingAspect {
    
    @Before("execution(* mypack.*.*(..))")
    public void logBefore() {
        System.out.println("Before method execution");
    }
}
```

### Critical Requirements

```
┌─────────────────────────────────────────────────────────────┐
│              ASPECT CLASS REQUIREMENTS                       │
│                                                              │
│  @Aspect                                                     │
│  ├── Marks class as containing AOP advice                   │
│  ├── Without this, methods are NOT treated as advice        │
│  └── Comes from org.aspectj.lang.annotation                 │
│                                                              │
│  @Component (or @Bean)                                       │
│  ├── Aspect must be a Spring bean                           │
│  ├── Without this, Spring won't detect the aspect           │
│  └── Can also use @Service, @Repository                     │
│                                                              │
│  BOTH annotations are REQUIRED!                              │
│  @Aspect alone = NOT ENOUGH                                  │
│  @Component alone = NOT an aspect                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Pointcut Expressions Deep Dive

### Pointcut Expression Syntax

```
execution(modifiers? return-type declaring-type? method-name(params) throws?)
```

### Complete Reference

```
┌─────────────────────────────────────────────────────────────┐
│              POINTCUT EXPRESSION SYNTAX                      │
│                                                              │
│  execution( [modifiers] [return-type] [package].[class].    │
│             [method]([parameters]) [throws] )               │
│                                                              │
│  EXAMPLES:                                                   │
│  ─────────                                                   │
│                                                              │
│  execution(* mypack.*.*(..))                                │
│         │    │     │ │  │                                   │
│         │    │     │ │  └── (..) = any arguments            │
│         │    │     │ └── * = any method name                │
│         │    │     └── * = any class                        │
│         │    └── mypack = package name                      │
│         └── * = any return type                             │
│                                                              │
│  execution(public int mypack.Calculator.add(int, int))      │
│         │      │          │             │        │          │
│         │      │          │             │        └── args   │
│         │      │          │             └── method name     │
│         │      │          └── class name                    │
│         │      └── return type (int)                        │
│         └── modifier (public)                               │
└─────────────────────────────────────────────────────────────┘
```

### Common Pointcut Patterns

| Pattern | Meaning |
|---------|---------|
| `execution(* mypack.*.*(..))` | All methods in mypack |
| `execution(* mypack..*.*(..))` | All methods in mypack and subpackages |
| `execution(public * *.*(..))` | All public methods |
| `execution(* *Service.*(..))` | All methods in classes ending with "Service" |
| `execution(* mypack.*.get*(..))` | All methods starting with "get" |
| `execution(* mypack.*.*(String))` | Methods with single String parameter |
| `execution(* mypack.*.*(String, ..))` | Methods with String as first parameter |

### Wildcard Reference

| Wildcard | Meaning |
|----------|---------|
| `*` | Matches any single element |
| `..` | Matches zero or more elements |
| `+` | Matches subclasses |

---

## 5. @Before Advice

### Purpose
Executes **before** the target method. Cannot prevent method execution or modify arguments.

### Syntax and Usage

```java
@Aspect
@Component
public class LoggingAspect {
    
    /**
     * @Before advice executes before the target method
     * 
     * JoinPoint provides:
     * - Method signature
     * - Arguments
     * - Target object
     */
    @Before("execution(* mypack.service.*.*(..))")
    public void logMethodEntry(JoinPoint joinPoint) {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@Before] Method Entry");
        System.out.println("═══════════════════════════════════════════");
        
        // Get method signature
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        System.out.println("Method: " + className + "." + methodName + "()");
        
        // Get arguments
        Object[] args = joinPoint.getArgs();
        System.out.println("Arguments: " + java.util.Arrays.toString(args));
        
        // Get declaring type
        String declaringType = joinPoint.getSignature().getDeclaringTypeName();
        System.out.println("Declaring Type: " + declaringType);
    }
}
```

### JoinPoint Interface

```java
public interface JoinPoint {
    Object[] getArgs();           // Method arguments
    Signature getSignature();     // Method signature
    Object getTarget();           // Target object
    Object getThis();             // Proxy object
    String toString();            // String representation
}
```

---

## 6. @AfterReturning Advice

### Purpose
Executes **after** the method returns successfully. Has access to return value.

### Syntax and Usage

```java
@Aspect
@Component
public class LoggingAspect {
    
    /**
     * @AfterReturning executes after successful method completion
     * 
     * returning = "result" binds the return value to parameter
     * NOTE: This does NOT run if method throws exception
     */
    @AfterReturning(
        pointcut = "execution(* mypack.service.*.*(..))",
        returning = "result"  // Binds return value to 'result' parameter
    )
    public void logMethodReturn(JoinPoint joinPoint, Object result) {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@AfterReturning] Method Completed Successfully");
        System.out.println("═══════════════════════════════════════════");
        
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Method: " + methodName);
        System.out.println("Return Value: " + result);
        System.out.println("Return Type: " + 
            (result != null ? result.getClass().getSimpleName() : "null"));
    }
}
```

### Key Points

```
┌─────────────────────────────────────────────────────────────┐
│           @AfterReturning KEY POINTS                         │
│                                                              │
│  1. returning = "result"                                     │
│     • Binds return value to method parameter                │
│     • Parameter name must MATCH                             │
│                                                              │
│  2. Parameter type can filter:                               │
│     • Object result → catches all                           │
│     • String result → only String returns                   │
│     • Integer result → only Integer returns                 │
│                                                              │
│  3. NOT called if exception is thrown                        │
│     Use @AfterThrowing for exceptions                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. @AfterThrowing Advice

### Purpose
Executes **after** the method throws an exception.

### Syntax and Usage

```java
@Aspect
@Component
public class ExceptionAspect {
    
    /**
     * @AfterThrowing executes when method throws exception
     * 
     * throwing = "exception" binds the exception to parameter
     */
    @AfterThrowing(
        pointcut = "execution(* mypack.service.*.*(..))",
        throwing = "exception"  // Binds exception to parameter
    )
    public void logException(JoinPoint joinPoint, Exception exception) {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@AfterThrowing] Exception Occurred!");
        System.out.println("═══════════════════════════════════════════");
        
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Method: " + methodName);
        System.out.println("Exception Type: " + exception.getClass().getName());
        System.out.println("Exception Message: " + exception.getMessage());
        
        // Log stack trace (optional)
        // exception.printStackTrace();
    }
}
```

### Exception Type Filtering

```java
// Catches ALL exceptions
@AfterThrowing(pointcut = "...", throwing = "ex")
public void handleAll(Exception ex) { }

// Catches only RuntimeException
@AfterThrowing(pointcut = "...", throwing = "ex")
public void handleRuntime(RuntimeException ex) { }

// Catches only SQLException
@AfterThrowing(pointcut = "...", throwing = "ex")  
public void handleSql(SQLException ex) { }
```

---

## 8. @After Advice (Finally)

### Purpose
Executes **after** the method regardless of outcome (success OR exception). Similar to `finally` block.

### Syntax and Usage

```java
@Aspect
@Component
public class CleanupAspect {
    
    /**
     * @After executes ALWAYS after method (like finally)
     * 
     * Runs regardless of:
     * - Successful return
     * - Exception thrown
     * 
     * Use for: Cleanup, resource release, logging
     */
    @After("execution(* mypack.service.*.*(..))")
    public void afterMethod(JoinPoint joinPoint) {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@After] Method Finished (Finally Block)");
        System.out.println("═══════════════════════════════════════════");
        
        String methodName = joinPoint.getSignature().getName();
        System.out.println("Completed: " + methodName);
        System.out.println("Timestamp: " + java.time.LocalDateTime.now());
    }
}
```

### @After vs @AfterReturning vs @AfterThrowing

```
┌─────────────────────────────────────────────────────────────┐
│              AFTER ADVICE COMPARISON                         │
│                                                              │
│  Method succeeds (returns normally):                         │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  @AfterReturning  ✓ RUNS                            │    │
│  │  @AfterThrowing   ✗ Does NOT run                    │    │
│  │  @After           ✓ RUNS                            │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  Method throws exception:                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  @AfterReturning  ✗ Does NOT run                    │    │
│  │  @AfterThrowing   ✓ RUNS                            │    │
│  │  @After           ✓ RUNS                            │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  @After = ALWAYS runs (like finally)                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. @Around Advice

### Purpose
**Most powerful** advice type. Wraps entire method execution. Can:
- Prevent method execution
- Modify arguments
- Modify return value
- Handle exceptions

### Syntax and Usage

```java
@Aspect
@Component
public class PerformanceAspect {
    
    /**
     * @Around wraps the ENTIRE method execution
     * 
     * ProceedingJoinPoint extends JoinPoint with:
     * - proceed() method to call target
     * 
     * MUST return Object and throw Throwable
     */
    @Around("execution(* mypack.service.*.*(..))")
    public Object measureExecutionTime(ProceedingJoinPoint pjp) throws Throwable {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@Around] BEFORE - Entering Method");
        System.out.println("═══════════════════════════════════════════");
        
        String methodName = pjp.getSignature().getName();
        Object[] args = pjp.getArgs();
        
        System.out.println("Method: " + methodName);
        System.out.println("Arguments: " + java.util.Arrays.toString(args));
        
        // Record start time
        long startTime = System.currentTimeMillis();
        
        Object result = null;
        try {
            // ════════════════════════════════════════
            // PROCEED - Call the actual target method
            // ════════════════════════════════════════
            result = pjp.proceed();  // This calls the actual method!
            
        } catch (Exception e) {
            // Handle exception if needed
            System.out.println("Exception caught: " + e.getMessage());
            throw e;  // Re-throw or handle
        }
        
        // Record end time
        long endTime = System.currentTimeMillis();
        
        System.out.println("═══════════════════════════════════════════");
        System.out.println("[@Around] AFTER - Exiting Method");
        System.out.println("═══════════════════════════════════════════");
        System.out.println("Result: " + result);
        System.out.println("Execution Time: " + (endTime - startTime) + " ms");
        
        // Can modify result here before returning
        return result;
    }
}
```

### ProceedingJoinPoint

```
┌─────────────────────────────────────────────────────────────┐
│           ProceedingJoinPoint                                │
│                                                              │
│  extends JoinPoint with:                                     │
│                                                              │
│  Object proceed() throws Throwable                          │
│    • Calls the target method                                │
│    • Returns the method's return value                      │
│    • MUST be called (unless blocking intentionally)         │
│                                                              │
│  Object proceed(Object[] args) throws Throwable             │
│    • Calls target with MODIFIED arguments                   │
│    • Useful for argument transformation                     │
│                                                              │
│  IMPORTANT:                                                  │
│  • Only available in @Around advice                         │
│  • Without proceed(), method NEVER executes                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. Reusable Pointcuts

### @Pointcut Annotation

Define pointcuts once, reuse multiple times:

```java
@Aspect
@Component
public class LoggingAspect {
    
    // ════════════════════════════════════════
    // REUSABLE POINTCUT DEFINITIONS
    // ════════════════════════════════════════
    
    @Pointcut("execution(* mypack.service.*.*(..))")
    public void serviceLayer() {}  // Empty method = pointcut definition
    
    @Pointcut("execution(* mypack.repository.*.*(..))")
    public void repositoryLayer() {}
    
    @Pointcut("execution(public * *(..))")
    public void publicMethods() {}
    
    // Combine pointcuts
    @Pointcut("serviceLayer() || repositoryLayer()")
    public void businessLayer() {}
    
    // ════════════════════════════════════════
    // ADVICES USING POINTCUTS
    // ════════════════════════════════════════
    
    @Before("serviceLayer()")
    public void logServiceEntry(JoinPoint jp) {
        System.out.println("Entering service: " + jp.getSignature().getName());
    }
    
    @Before("repositoryLayer()")
    public void logDaoEntry(JoinPoint jp) {
        System.out.println("Entering repository: " + jp.getSignature().getName());
    }
    
    @After("businessLayer()")
    public void logBusinessExit(JoinPoint jp) {
        System.out.println("Exiting business layer: " + jp.getSignature().getName());
    }
}
```

### Combining Pointcuts

```java
// AND - both must match
@Pointcut("serviceLayer() && publicMethods()")
public void publicServiceMethods() {}

// OR - either must match
@Pointcut("serviceLayer() || repositoryLayer()")
public void businessLayer() {}

// NOT - exclude matching
@Pointcut("businessLayer() && !repositoryLayer()")
public void onlyServiceLayer() {}
```

---

## 11. Complete Code Example

### ProductService.java (Target)

```java
package mypack.service;

import org.springframework.stereotype.Service;

@Service
public class ProductService {

    public int multiply(int a, int b) {
        System.out.println(">>> [ProductService] multiply(" + a + ", " + b + ")");
        return a * b;
    }

    public int divide(int a, int b) {
        System.out.println(">>> [ProductService] divide(" + a + ", " + b + ")");
        if (b == 0) {
            throw new ArithmeticException("Cannot divide by zero!");
        }
        return a / b;
    }
}
```

### LoggingAspect.java (Complete Aspect)

```java
package mypack.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LoggingAspect {

    // Reusable pointcut
    @Pointcut("execution(* mypack.service.*.*(..))")
    public void serviceMethods() {}

    @Before("serviceMethods()")
    public void logBefore(JoinPoint jp) {
        System.out.println("\n[@Before] → " + jp.getSignature().getName());
    }

    @AfterReturning(pointcut = "serviceMethods()", returning = "result")
    public void logAfterReturning(JoinPoint jp, Object result) {
        System.out.println("[@AfterReturning] ← " + jp.getSignature().getName() + 
            " returned: " + result);
    }

    @AfterThrowing(pointcut = "serviceMethods()", throwing = "ex")
    public void logAfterThrowing(JoinPoint jp, Exception ex) {
        System.out.println("[@AfterThrowing] ✗ " + jp.getSignature().getName() + 
            " threw: " + ex.getMessage());
    }

    @After("serviceMethods()")
    public void logAfter(JoinPoint jp) {
        System.out.println("[@After] ✓ " + jp.getSignature().getName() + " completed");
    }

    @Around("serviceMethods()")
    public Object logAround(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        
        Object result = pjp.proceed();
        
        long duration = System.currentTimeMillis() - start;
        System.out.println("[@Around] ⏱ " + pjp.getSignature().getName() + 
            " took " + duration + "ms");
        
        return result;
    }
}
```

---

## 12. Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│              ADVICE EXECUTION ORDER                          │
│                                                              │
│  Client calls: productService.multiply(5, 3)                │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  1. @Around (BEFORE part)                           │    │
│  │     "[@Around] Entering method"                     │    │
│  │     startTime = currentTimeMillis()                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          ▼                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  2. @Before                                         │    │
│  │     "[@Before] → multiply"                          │    │
│  └─────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          ▼                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  3. TARGET METHOD                                   │    │
│  │     pjp.proceed() → ProductService.multiply(5, 3)  │    │
│  │     Returns: 15                                     │    │
│  └─────────────────────────────────────────────────────┘    │
│                          │                                   │
│        ┌─────────────────┴─────────────────┐                │
│        │ SUCCESS                  │ EXCEPTION               │
│        ▼                          ▼                          │
│  ┌──────────────────┐    ┌──────────────────┐               │
│  │ 4a. @AfterReturn │    │ 4b. @AfterThrowing│              │
│  │   "returned: 15" │    │   "threw: ..."    │              │
│  └──────────────────┘    └──────────────────┘               │
│        │                          │                          │
│        └─────────────────┬────────┘                         │
│                          ▼                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  5. @After (ALWAYS runs)                            │    │
│  │     "[@After] multiply completed"                   │    │
│  └─────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          ▼                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  6. @Around (AFTER part)                            │    │
│  │     "[@Around] ⏱ multiply took 5ms"                │    │
│  └─────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          ▼                                   │
│  7. Return 15 to Client                                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 13. Common Interview Questions

### Q1: What annotations are required for an Aspect?
**A:** Two annotations are required:
1. `@Aspect` - marks the class as an aspect
2. `@Component` (or similar) - makes it a Spring bean

### Q2: Difference between JoinPoint and ProceedingJoinPoint?
**A:**
- `JoinPoint` - for @Before, @After, @AfterReturning, @AfterThrowing
- `ProceedingJoinPoint` - ONLY for @Around (has `proceed()` method)

### Q3: What is the execution order of advices?
**A:** @Around(before) → @Before → Method → @AfterReturning/@AfterThrowing → @After → @Around(after)

### Q4: What happens if you don't call proceed() in @Around?
**A:** The target method is NEVER executed. Useful for blocking calls.

### Q5: How do you enable AspectJ auto-proxy?
**A:** Either `<aop:aspectj-autoproxy/>` in XML or `@EnableAspectJAutoProxy` annotation.

---

## 14. Key Takeaways

📌 **@Aspect + @Component** = Complete aspect class

📌 **@EnableAspectJAutoProxy** enables annotation processing

📌 **@Before** → before method execution

📌 **@AfterReturning** → after success, has return value

📌 **@AfterThrowing** → after exception, has exception

📌 **@After** → ALWAYS (like finally)

📌 **@Around** → most powerful, uses **ProceedingJoinPoint**

📌 **pjp.proceed()** calls the actual target method

📌 **@Pointcut** defines reusable expressions

📌 Combine pointcuts with **&&**, **||**, **!**

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│         ANNOTATION-BASED AOP QUICK REFERENCE                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  REQUIRED:                                                   │
│  @Aspect + @Component on aspect class                       │
│  @EnableAspectJAutoProxy on config class                    │
│                                                              │
│  ADVICE TYPES:                                               │
│  @Before("pointcut")                   → before method      │
│  @AfterReturning(returning="r")        → after success      │
│  @AfterThrowing(throwing="e")          → after exception    │
│  @After("pointcut")                    → always (finally)   │
│  @Around("pointcut")                   → wraps execution    │
│                                                              │
│  POINTCUT SYNTAX:                                            │
│  execution(* mypack.*.*(..))          → all methods         │
│  execution(public * *(..))            → all public          │
│  execution(* *Service.*(..))          → *Service classes    │
│                                                              │
│  REMEMBER: pjp.proceed() calls target method!               │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [12. AOP with XML Configuration](./12_AOP_with_XML_Configuration.md)*

*Next: [14. JdbcTemplate Fundamentals](./14_JdbcTemplate_Fundamentals.md)*
