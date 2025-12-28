# AOP with XML Configuration (ProxyFactoryBean)

## Table of Contents
1. [Introduction](#1-introduction)
2. [Understanding ProxyFactoryBean](#2-understanding-proxyfactorybean)
3. [Advice Interfaces in Spring AOP](#3-advice-interfaces-in-spring-aop)
4. [Implementing Before Advice](#4-implementing-before-advice)
5. [Implementing After Returning Advice](#5-implementing-after-returning-advice)
6. [Implementing Around Advice](#6-implementing-around-advice)
7. [Complete XML Configuration](#7-complete-xml-configuration)
8. [Complete Code Example](#8-complete-code-example)
9. [Execution Flow Diagram](#9-execution-flow-diagram)
10. [Best Practices](#10-best-practices)
11. [Common Interview Questions](#11-common-interview-questions)
12. [Key Takeaways](#12-key-takeaways)

---

## 1. Introduction

**XML-based AOP** uses `ProxyFactoryBean` to create proxy objects that intercept method calls and apply cross-cutting concerns. This is the **traditional approach** to configuring AOP in Spring before annotations became popular.

> **Key Insight**: ProxyFactoryBean wraps your actual business object and adds behavior before/after method execution!

### When to Use XML-Based AOP

| Scenario | Recommendation |
|----------|----------------|
| Legacy applications | ✅ XML-based AOP |
| New Spring Boot apps | Use annotation-based (@Aspect) |
| Need runtime configuration | ✅ XML allows external config |
| Complex pointcut expressions | Annotations preferred |

---

## 2. Understanding ProxyFactoryBean

### What is ProxyFactoryBean?

`ProxyFactoryBean` is a Spring class that creates a **proxy object** wrapping your actual business object. The proxy intercepts method calls and applies configured advices.

```
┌─────────────────────────────────────────────────────────────┐
│              PROXYFACTORYBEAN ARCHITECTURE                   │
│                                                              │
│   getBean("product")                                         │
│         │                                                    │
│         ▼                                                    │
│   ┌─────────────────────────────────────────────────────┐   │
│   │              PROXY OBJECT                            │   │
│   │  ┌─────────────────────────────────────────────┐    │   │
│   │  │ Advice Chain:                                │    │   │
│   │  │  1. beforeCall (LogBeforeCall)              │    │   │
│   │  │  2. aroundCall (LogAround)                  │    │   │
│   │  │  3. afterCall (LogAfterReturning)           │    │   │
│   │  └─────────────────────────────────────────────┘    │   │
│   │                        │                             │   │
│   │                        ▼                             │   │
│   │  ┌─────────────────────────────────────────────┐    │   │
│   │  │         TARGET OBJECT                        │    │   │
│   │  │         (ProductImpl)                        │    │   │
│   │  │                                              │    │   │
│   │  │         multiply(int a, int b)              │    │   │
│   │  └─────────────────────────────────────────────┘    │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Client never sees the actual ProductImpl!                 │
└─────────────────────────────────────────────────────────────┘
```

### ProxyFactoryBean Properties

| Property | Description |
|----------|-------------|
| `target` | The actual business object to proxy |
| `interceptorNames` | List of advice bean names to apply |
| `proxyInterfaces` | Interface(s) the proxy should implement |

---

## 3. Advice Interfaces in Spring AOP

Spring provides several interfaces for different types of advice:

```
┌─────────────────────────────────────────────────────────────┐
│              ADVICE INTERFACES                               │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  MethodBeforeAdvice                                  │    │
│  │  • Runs BEFORE target method                         │    │
│  │  • Cannot prevent method execution                   │    │
│  │  • Cannot modify return value                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  AfterReturningAdvice                                │    │
│  │  • Runs AFTER method returns successfully            │    │
│  │  • Has access to return value                        │    │
│  │  • Cannot modify return value                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  MethodInterceptor (Around Advice)                   │    │
│  │  • Wraps ENTIRE method execution                     │    │
│  │  • Can prevent method execution                      │    │
│  │  • Can modify arguments and return value             │    │
│  │  • Most powerful advice type                         │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  ThrowsAdvice                                        │    │
│  │  • Runs when method throws exception                 │    │
│  │  • Can handle or rethrow exceptions                  │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Implementing Before Advice

### MethodBeforeAdvice Interface

```java
package org.springframework.aop;

public interface MethodBeforeAdvice extends BeforeAdvice {
    void before(Method method, Object[] args, Object target) throws Throwable;
}
```

### LogBeforeCall.java - Complete Implementation

```java
package mypack;

import java.lang.reflect.Method;
import org.springframework.aop.MethodBeforeAdvice;

/**
 * Before Advice - Executes BEFORE the target method
 * 
 * Use cases:
 * - Logging method entry
 * - Security checks
 * - Parameter validation
 * - Auditing
 */
public class LogBeforeCall implements MethodBeforeAdvice {
    
    /**
     * Called before every method on the target object
     * 
     * @param method - The method being invoked (e.g., multiply)
     * @param args   - Arguments passed to the method (e.g., [5, 3])
     * @param target - The target object (ProductImpl instance)
     */
    @Override
    public void before(Method method, Object[] args, Object target) throws Throwable {
        System.out.println("============================================");
        System.out.println("[BEFORE ADVICE] Method Interception Started");
        System.out.println("============================================");
        
        // Log method details
        System.out.println("Method Name: " + method.getName());
        System.out.println("Declaring Class: " + method.getDeclaringClass().getName());
        System.out.println("Return Type: " + method.getReturnType().getName());
        
        // Log arguments
        System.out.println("Arguments:");
        if (args != null && args.length > 0) {
            for (int i = 0; i < args.length; i++) {
                System.out.println("  arg[" + i + "] = " + args[i] + 
                    " (Type: " + args[i].getClass().getSimpleName() + ")");
            }
        } else {
            System.out.println("  No arguments");
        }
        
        // Log target object
        System.out.println("Target Object: " + target.getClass().getName());
        System.out.println("============================================");
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 1 | `package mypack;` | Package declaration |
| 3-4 | `import...` | Import Method class and MethodBeforeAdvice interface |
| 14 | `implements MethodBeforeAdvice` | Must implement this interface for before advice |
| 22 | `public void before(...)` | This method is called BEFORE every proxied method |
| 22 | `Method method` | Reflection object representing the method being called |
| 22 | `Object[] args` | Array of arguments passed to the method |
| 22 | `Object target` | The actual target object (not the proxy) |
| 28-31 | `method.getName()` | Gets the method name being invoked |
| 35-41 | Loop through args | Logs all arguments with their types |

---

## 5. Implementing After Returning Advice

### AfterReturningAdvice Interface

```java
package org.springframework.aop;

public interface AfterReturningAdvice extends AfterAdvice {
    void afterReturning(Object returnValue, Method method, 
                        Object[] args, Object target) throws Throwable;
}
```

### LogAfterReturning.java - Complete Implementation

```java
package mypack;

import java.lang.reflect.Method;
import org.springframework.aop.AfterReturningAdvice;

/**
 * After Returning Advice - Executes AFTER successful method completion
 * 
 * Use cases:
 * - Logging method exit and return values
 * - Caching return values
 * - Modifying response (create wrapper)
 * - Auditing successful operations
 */
public class LogAfterReturning implements AfterReturningAdvice {
    
    /**
     * Called after the target method returns successfully
     * NOTE: This is NOT called if method throws exception
     * 
     * @param returnValue - The value returned by the method
     * @param method      - The method that was invoked
     * @param args        - The arguments passed to the method
     * @param target      - The target object
     */
    @Override
    public void afterReturning(Object returnValue, Method method, 
                               Object[] args, Object target) throws Throwable {
        System.out.println("============================================");
        System.out.println("[AFTER RETURNING ADVICE] Method Completed");
        System.out.println("============================================");
        
        System.out.println("Method: " + method.getName());
        System.out.println("Return Value: " + returnValue);
        System.out.println("Return Type: " + (returnValue != null ? 
            returnValue.getClass().getSimpleName() : "void"));
        
        // Example: Log execution for auditing
        System.out.println("Status: SUCCESS");
        System.out.println("============================================");
    }
}
```

---

## 6. Implementing Around Advice

### MethodInterceptor Interface

```java
package org.aopalliance.intercept;

public interface MethodInterceptor extends Interceptor {
    Object invoke(MethodInvocation invocation) throws Throwable;
}
```

### LogAround.java - Complete Implementation

```java
package mypack;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

/**
 * Around Advice - Wraps the ENTIRE method execution
 * 
 * This is the MOST POWERFUL advice type because it can:
 * - Execute code before AND after the method
 * - Prevent method execution entirely
 * - Modify arguments before calling method
 * - Modify return value before returning to caller
 * - Handle exceptions
 * 
 * Use cases:
 * - Transaction management
 * - Performance monitoring
 * - Security checks with possible blocking
 * - Caching
 * - Retry logic
 */
public class LogAround implements MethodInterceptor {
    
    /**
     * Wraps the method execution
     * 
     * @param mi - MethodInvocation containing all method details
     * @return The return value (original or modified)
     */
    @Override
    public Object invoke(MethodInvocation mi) throws Throwable {
        // =========== BEFORE SECTION ===========
        System.out.println("********************************************");
        System.out.println("[AROUND ADVICE] Beginning of invoke");
        System.out.println("********************************************");
        
        // Get method arguments
        Object[] args = mi.getArguments();
        System.out.println("Method: " + mi.getMethod().getName());
        System.out.println("Arguments: " + java.util.Arrays.toString(args));
        
        // Example: Validation logic
        if (args.length >= 2) {
            int num1 = (Integer) args[0];
            int num2 = (Integer) args[1];
            
            // Prevent execution if both are 0
            if (num1 == 0 && num2 == 0) {
                System.out.println("ERROR: Cannot multiply 0 with 0!");
                throw new IllegalArgumentException("Cannot multiply 0 with 0");
            }
            
            System.out.println("Validation PASSED: " + num1 + " x " + num2);
        }
        
        // Record start time for performance monitoring
        long startTime = System.currentTimeMillis();
        
        // =========== PROCEED TO TARGET METHOD ===========
        // This is the CRITICAL line - calls the actual method
        Object result = mi.proceed();  // ← CALLS ProductImpl.multiply()
        
        // =========== AFTER SECTION ===========
        long endTime = System.currentTimeMillis();
        
        System.out.println("********************************************");
        System.out.println("[AROUND ADVICE] After proceed");
        System.out.println("Result: " + result);
        System.out.println("Execution Time: " + (endTime - startTime) + " ms");
        System.out.println("********************************************");
        
        // Can modify return value here if needed
        // return result * 2;  // Example: double the result
        
        return result;  // Return original result
    }
}
```

### Critical Understanding: mi.proceed()

```
┌─────────────────────────────────────────────────────────────┐
│              mi.proceed() EXPLAINED                          │
│                                                              │
│   Code BEFORE mi.proceed()  ←── Before Advice part          │
│                │                                             │
│                ▼                                             │
│   ┌─────────────────────────┐                               │
│   │    mi.proceed()         │ ←── Calls ACTUAL method       │
│   │    (target.multiply())  │                               │
│   └─────────────────────────┘                               │
│                │                                             │
│                ▼                                             │
│   Code AFTER mi.proceed()   ←── After Advice part           │
│                                                              │
│   If you DON'T call mi.proceed():                           │
│   → Target method is NEVER executed!                        │
│   → Useful for blocking/preventing calls                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Complete XML Configuration

### aopdemo.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- 
    ============================================================
    STEP 1: Define Advice Beans
    These are the cross-cutting concerns (logging, security, etc.)
    ============================================================
    -->
    
    <!-- Before Advice: Executes before target method -->
    <bean id="beforeCall" class="mypack.LogBeforeCall"/>
    
    <!-- After Returning Advice: Executes after successful return -->
    <bean id="afterCall" class="mypack.LogAfterReturning"/>
    
    <!-- Around Advice: Wraps entire method execution -->
    <bean id="aroundCall" class="mypack.LogAround"/>
    
    <!-- 
    ============================================================
    STEP 2: Define Target Bean
    This is the actual business object
    ============================================================
    -->
    <bean id="productImpl" class="mypack.ProductImpl"/>
    
    <!-- 
    ============================================================
    STEP 3: Create Proxy using ProxyFactoryBean
    This wraps the target and applies all advices
    ============================================================
    -->
    <bean id="product" class="org.springframework.aop.framework.ProxyFactoryBean">
        
        <!-- Target: The actual business object to be proxied -->
        <property name="target">
            <ref bean="productImpl"/>
        </property>
        
        <!-- 
        InterceptorNames: List of advice beans to apply
        Order matters! They execute in this sequence.
        -->
        <property name="interceptorNames">
            <list>
                <value>beforeCall</value>
                <value>aroundCall</value>
                <value>afterCall</value>
            </list>
        </property>
        
        <!-- ProxyInterfaces: Interface the proxy should implement -->
        <property name="proxyInterfaces">
            <value>mypack.Product</value>
        </property>
        
    </bean>

</beans>
```

### XML Configuration Explained

```
┌─────────────────────────────────────────────────────────────┐
│              XML CONFIGURATION BREAKDOWN                     │
│                                                              │
│  <bean id="beforeCall" class="mypack.LogBeforeCall"/>       │
│       ↓                                                      │
│  Creates: LogBeforeCall instance                            │
│                                                              │
│  <bean id="product" class="...ProxyFactoryBean">            │
│       │                                                      │
│       ├── target → productImpl (actual business object)     │
│       │                                                      │
│       ├── interceptorNames → [beforeCall, aroundCall, ...]  │
│       │                                                      │
│       └── proxyInterfaces → Product (interface to implement)│
│                                                              │
│  Result:                                                     │
│  getBean("product") returns a PROXY, not ProductImpl!       │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Complete Code Example

### Product.java (Interface)

```java
package mypack;

/**
 * Interface defining the contract for product operations
 * The proxy will implement this interface
 */
public interface Product {
    int multiply(int a, int b);
    int add(int a, int b);
}
```

### ProductImpl.java (Target)

```java
package mypack;

/**
 * Target class containing actual business logic
 * This is what gets proxied by ProxyFactoryBean
 */
public class ProductImpl implements Product {
    
    @Override
    public int multiply(int a, int b) {
        System.out.println(">>> [ProductImpl] Executing multiply: " + a + " x " + b);
        return a * b;
    }
    
    @Override
    public int add(int a, int b) {
        System.out.println(">>> [ProductImpl] Executing add: " + a + " + " + b);
        return a + b;
    }
}
```

### Main.java

```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        // Load Spring container
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("aopdemo.xml");
        
        // Get the PROXY (not the actual ProductImpl!)
        Product product = (Product) ctx.getBean("product");
        
        System.out.println("\n========== CALLING multiply(5, 3) ==========\n");
        
        // This call goes through the proxy!
        int result = product.multiply(5, 3);
        
        System.out.println("\n========== FINAL RESULT: " + result + " ==========\n");
        
        ctx.close();
    }
}
```

---

## 9. Execution Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│              COMPLETE EXECUTION FLOW                         │
│                                                              │
│  1. Client: product.multiply(5, 3)                          │
│         │                                                    │
│         ▼                                                    │
│  2. PROXY intercepts the call                               │
│         │                                                    │
│         ▼                                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  3. BEFORE ADVICE (LogBeforeCall.before())          │    │
│  │     OUTPUT: "[BEFORE ADVICE] Method Interception"   │    │
│  │     OUTPUT: "Method Name: multiply"                 │    │
│  │     OUTPUT: "Arguments: arg[0]=5, arg[1]=3"         │    │
│  └─────────────────────────────────────────────────────┘    │
│         │                                                    │
│         ▼                                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  4. AROUND ADVICE (LogAround.invoke()) - BEFORE     │    │
│  │     OUTPUT: "[AROUND ADVICE] Beginning of invoke"   │    │
│  │     OUTPUT: "Validation PASSED: 5 x 3"              │    │
│  └─────────────────────────────────────────────────────┘    │
│         │                                                    │
│         ▼                                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  5. mi.proceed() → ACTUAL METHOD                    │    │
│  │     ProductImpl.multiply(5, 3) executes             │    │
│  │     OUTPUT: "[ProductImpl] Executing multiply"      │    │
│  │     Returns: 15                                     │    │
│  └─────────────────────────────────────────────────────┘    │
│         │                                                    │
│         ▼                                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  6. AROUND ADVICE (LogAround.invoke()) - AFTER      │    │
│  │     OUTPUT: "[AROUND ADVICE] After proceed"         │    │
│  │     OUTPUT: "Result: 15"                            │    │
│  └─────────────────────────────────────────────────────┘    │
│         │                                                    │
│         ▼                                                    │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  7. AFTER RETURNING ADVICE                          │    │
│  │     (LogAfterReturning.afterReturning())            │    │
│  │     OUTPUT: "[AFTER RETURNING] Method Completed"    │    │
│  │     OUTPUT: "Return Value: 15"                      │    │
│  └─────────────────────────────────────────────────────┘    │
│         │                                                    │
│         ▼                                                    │
│  8. Return 15 to Client                                     │
└─────────────────────────────────────────────────────────────┘
```

### Console Output

```
========== CALLING multiply(5, 3) ==========

============================================
[BEFORE ADVICE] Method Interception Started
============================================
Method Name: multiply
Declaring Class: mypack.ProductImpl
Return Type: int
Arguments:
  arg[0] = 5 (Type: Integer)
  arg[1] = 3 (Type: Integer)
Target Object: mypack.ProductImpl
============================================
********************************************
[AROUND ADVICE] Beginning of invoke
********************************************
Method: multiply
Arguments: [5, 3]
Validation PASSED: 5 x 3
>>> [ProductImpl] Executing multiply: 5 x 3
********************************************
[AROUND ADVICE] After proceed
Result: 15
Execution Time: 1 ms
********************************************
============================================
[AFTER RETURNING ADVICE] Method Completed
============================================
Method: multiply
Return Value: 15
Return Type: Integer
Status: SUCCESS
============================================

========== FINAL RESULT: 15 ==========
```

---

## 10. Best Practices

### ✅ Do This

```java
// Always call mi.proceed() in around advice (unless blocking)
public Object invoke(MethodInvocation mi) throws Throwable {
    // before logic
    Object result = mi.proceed();  // Don't forget this!
    // after logic
    return result;
}
```

### ❌ Avoid This

```java
// Don't create new proxy for each request
public void badApproach() {
    ProxyFactoryBean pfb = new ProxyFactoryBean();  // Wrong!
    pfb.setTarget(new ProductImpl());
}
```

### Order of Interceptors

```xml
<property name="interceptorNames">
    <list>
        <!-- Order matters! First in list = first to execute -->
        <value>securityAdvice</value>   <!-- 1st -->
        <value>loggingAdvice</value>    <!-- 2nd -->
        <value>transactionAdvice</value> <!-- 3rd -->
    </list>
</property>
```

---

## 11. Common Interview Questions

### Q1: What is ProxyFactoryBean?
**A:** ProxyFactoryBean is a Spring class that creates proxy objects wrapping target beans. It applies configured advices to method calls, enabling AOP without modifying target code.

### Q2: What interfaces do advice classes implement?
**A:**
| Advice Type | Interface |
|-------------|-----------|
| Before | `MethodBeforeAdvice` |
| After Returning | `AfterReturningAdvice` |
| Around | `MethodInterceptor` |
| Throws | `ThrowsAdvice` |

### Q3: What does mi.proceed() do?
**A:** `mi.proceed()` calls the actual target method. Without calling it, the target method never executes. It's like passing control to the next handler in a chain.

### Q4: What's the difference between Before and Around advice?
**A:**
- **Before**: Only runs before, cannot prevent method execution
- **Around**: Wraps entire execution, can prevent method, modify args/result

### Q5: What properties does ProxyFactoryBean require?
**A:** Three main properties:
1. `target` - the business object
2. `interceptorNames` - list of advice beans
3. `proxyInterfaces` - interface(s) to implement

---

## 12. Key Takeaways

📌 **ProxyFactoryBean** creates proxy objects at runtime

📌 **MethodBeforeAdvice** runs before target method

📌 **AfterReturningAdvice** runs after successful completion

📌 **MethodInterceptor** wraps entire execution (most powerful)

📌 **mi.proceed()** is CRITICAL - calls the actual method

📌 **getBean()** returns the **PROXY**, not the target

📌 **Interceptor order** in XML determines execution order

📌 Use XML AOP for **legacy apps** or **external configuration**

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│         XML-BASED AOP QUICK REFERENCE                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ADVICE TYPES:                                               │
│  MethodBeforeAdvice    → before(method, args, target)       │
│  AfterReturningAdvice  → afterReturning(ret, method, args)  │
│  MethodInterceptor     → invoke(MethodInvocation mi)        │
│  ThrowsAdvice          → afterThrowing(Method, args, ex)    │
│                                                              │
│  PROXYFACTORYBEAN:                                           │
│  <bean class="...ProxyFactoryBean">                         │
│      <property name="target" ref="..."/>                    │
│      <property name="interceptorNames">                     │
│          <list><value>advice1</value>...</list>             │
│      </property>                                             │
│  </bean>                                                     │
│                                                              │
│  CRITICAL: mi.proceed() calls target method!                │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [11. AOP Terminology and Concepts](./11_AOP_Terminology_and_Concepts.md)*

*Next: [13. AOP with Annotations](./13_AOP_with_Annotations.md)*
