# XML-Based AOP Configuration

## Table of Contents
1. [Introduction](#1-introduction)
2. [ProxyFactoryBean Approach](#2-proxyfactorybean-approach)
3. [Implementing Advice Classes](#3-implementing-advice-classes)
4. [XML Configuration with ProxyFactoryBean](#4-xml-configuration-with-proxyfactorybean)
5. [Complete Code Example](#5-complete-code-example)
6. [Execution Flow](#6-execution-flow)
7. [Common Interview Questions](#7-common-interview-questions)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. Introduction

In Spring AOP, there are multiple ways to configure aspects. **XML-based configuration** uses `ProxyFactoryBean` to create proxy objects that apply advice to target methods.

> **Key Point**: XML-based AOP is the traditional approach and is useful for understanding how AOP works internally.

---

## 2. ProxyFactoryBean Approach

### What is ProxyFactoryBean?

`ProxyFactoryBean` is a Spring class that creates a **proxy object** wrapping your actual business object. This proxy applies advices before/after method calls.

### How It Works

```
┌─────────────────────────────────────────────────────────────┐
│                    PROXYFACTORYBEAN                          │
│                                                              │
│   XML Configuration:                                         │
│   <bean id="product" class="ProxyFactoryBean">              │
│       <property name="target" ref="productImpl"/>           │
│       <property name="interceptorNames">                    │
│           <list>                                             │
│               <value>beforeCall</value>                     │
│               <value>aroundCall</value>                     │
│           </list>                                            │
│       </property>                                            │
│   </bean>                                                    │
│                                                              │
│   Result:                                                    │
│   ┌──────────────────────────────────────────────────────┐  │
│   │  When you call getBean("product"):                    │  │
│   │                                                       │  │
│   │  Returns a PROXY that:                               │  │
│   │  1. Calls beforeCall advice                          │  │
│   │  2. Calls aroundCall advice (before part)            │  │
│   │  3. Calls actual productImpl method                  │  │
│   │  4. Calls aroundCall advice (after part)             │  │
│   │  5. Calls afterCall advice                           │  │
│   └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Implementing Advice Classes

### 3.1 Before Advice (MethodBeforeAdvice)

```java
package mypack;

import java.lang.reflect.Method;
import org.springframework.aop.MethodBeforeAdvice;

// Line 6: Implements MethodBeforeAdvice for "before" advice
public class LogBeforeCall implements MethodBeforeAdvice
{
    // Line 9-12: This method is called BEFORE the target method
    // Parameters:
    //   method - the method being called
    //   os - arguments passed to the method
    //   o - the target object
    public void before(Method method, Object[] os, Object o) throws Throwable
    {
        System.out.println("Before Calling the Method");
        System.out.println("Method name: " + method.getName());
    }
}
```

**Explanation:**
| Parameter | Description |
|-----------|-------------|
| `Method method` | Reflection object representing the method being called |
| `Object[] os` | Array of arguments passed to the method |
| `Object o` | The target object on which method is invoked |

---

### 3.2 After Returning Advice (AfterReturningAdvice)

```java
package mypack;

import java.lang.reflect.Method;
import org.springframework.aop.AfterReturningAdvice;

// Line 6: Implements AfterReturningAdvice for "after" advice
public class LogAfterReturning implements AfterReturningAdvice
{
    // Line 9-13: Called AFTER the target method returns successfully
    // Parameters:
    //   returnValue - the value returned by the method
    //   method - the method that was called
    //   args - arguments passed to the method
    //   target - the target object
    public void afterReturning(Object returnValue, Method method, 
            Object[] args, Object target) throws Throwable
    {
        System.out.println("After Returning from Method");
        System.out.println("Return value: " + returnValue);
    }
}
```

---

### 3.3 Around Advice (MethodInterceptor)

```java
package mypack;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

// Line 5: Implements MethodInterceptor for "around" advice
public class LogAround implements MethodInterceptor
{
    // Line 8-23: Wraps the entire method execution
    public Object invoke(MethodInvocation mi) throws Throwable
    {
        // BEFORE METHOD EXECUTION
        System.out.println("beginning of invoke");
        
        // Get method arguments
        Object arg[] = mi.getArguments();
        int num1 = (Integer) arg[0];
        int num2 = (Integer) arg[1];
        
        // Validation before proceeding
        if(num1 == 0 && num2 == 0)
        {
            throw new Exception("Cannot Multiply 0 with 0");
        }
        
        // CALL THE ACTUAL METHOD
        Object result = mi.proceed();  // <-- Critical line!
        
        // AFTER METHOD EXECUTION
        System.out.println("after proceed");
        
        return result;
    }
}
```

**Key Points:**
| Line | Code | Explanation |
|------|------|-------------|
| 10-11 | Before `mi.proceed()` | Code executes BEFORE target method |
| 24 | `mi.proceed()` | Calls the actual target method |
| 27-28 | After `mi.proceed()` | Code executes AFTER target method |
| 17-20 | Validation | Can prevent method execution entirely! |

---

## 4. XML Configuration with ProxyFactoryBean

### Complete aopdemo.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">

    <!-- STEP 1: Define Advice Beans -->
    <!-- These are the cross-cutting concern implementations -->
    <bean id="beforeCall" class="mypack.LogBeforeCall"/>
    <bean id="afterCall" class="mypack.LogAfterReturning"/>
    <bean id="aroundCall" class="mypack.LogAround"/>
    
    <!-- STEP 2: Define Target Bean (Business Logic) -->
    <!-- This is the actual class that contains business methods -->
    <bean id="productImpl" class="mypack.ProductImpl"/>
    
    <!-- STEP 3: Create Proxy using ProxyFactoryBean -->
    <!-- This wraps the target with advices -->
    <bean id="product" class="org.springframework.aop.framework.ProxyFactoryBean">
        
        <!-- Target: The actual business object to proxy -->
        <property name="target">
            <ref bean="productImpl"/>
        </property>
        
        <!-- InterceptorNames: List of advice beans to apply -->
        <property name="interceptorNames">
            <list>
                <value>beforeCall</value>
                <value>aroundCall</value>
                <value>afterCall</value>
            </list>
        </property>
        
        <!-- ProxyInterfaces: Interface(s) the proxy should implement -->
        <property name="proxyInterfaces">
            <value>mypack.Product</value>
        </property>
    </bean>

</beans>
```

**Line-by-Line Explanation:**

| Section | Purpose |
|---------|---------|
| Lines 10-12 | Define advice beans (before, after, around) |
| Line 16 | Define the target business object |
| Lines 20-40 | Create proxy using ProxyFactoryBean |
| Lines 23-25 | `target` property - which object to proxy |
| Lines 28-34 | `interceptorNames` - which advices to apply |
| Lines 37-39 | `proxyInterfaces` - interface the proxy implements |

---

## 5. Complete Code Example

### File Structure

```
project/
├── src/
│   ├── mypack/
│   │   ├── Product.java          (Interface)
│   │   ├── ProductImpl.java      (Target - Business Logic)
│   │   ├── LogBeforeCall.java    (Before Advice)
│   │   ├── LogAfterReturning.java(After Advice)
│   │   ├── LogAround.java        (Around Advice)
│   │   └── Main.java
│   └── aopdemo.xml
└── pom.xml
```

### Product.java (Interface)
```java
package mypack;

public interface Product {
    int multiply(int a, int b);
}
```

### ProductImpl.java (Target)
```java
package mypack;

// Business logic class - contains actual logic
public class ProductImpl implements Product {
    
    @Override
    public int multiply(int a, int b) {
        System.out.println("Inside multiply method - BUSINESS LOGIC");
        return a * b;
    }
}
```

### Main.java
```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("aopdemo.xml");
        
        // Get the PROXY (not the actual ProductImpl!)
        Product product = (Product) ctx.getBean("product");
        
        // Call method - advices will be applied automatically
        int result = product.multiply(5, 3);
        
        System.out.println("Result: " + result);
        
        ctx.close();
    }
}
```

---

## 6. Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                  AOP EXECUTION FLOW                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: Client calls product.multiply(5, 3)                 │
│  ─────────────────────────────────────────                  │
│  Note: "product" is a PROXY, not ProductImpl!               │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: BEFORE ADVICE executes                              │
│  ───────────────────────────────                            │
│  LogBeforeCall.before() is called                           │
│  OUTPUT: "Before Calling the Method"                        │
│  OUTPUT: "Method name: multiply"                            │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: AROUND ADVICE (before part)                         │
│  ───────────────────────────────────                        │
│  LogAround.invoke() starts                                  │
│  OUTPUT: "beginning of invoke"                              │
│  Checks: if(5==0 && 3==0) → false, continue                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: ACTUAL METHOD EXECUTION                             │
│  ───────────────────────────────                            │
│  mi.proceed() calls ProductImpl.multiply(5, 3)              │
│  OUTPUT: "Inside multiply method - BUSINESS LOGIC"          │
│  Returns: 15                                                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: AROUND ADVICE (after part)                          │
│  ──────────────────────────────────                         │
│  LogAround.invoke() continues after proceed()               │
│  OUTPUT: "after proceed"                                    │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 6: AFTER RETURNING ADVICE                              │
│  ──────────────────────────────                             │
│  LogAfterReturning.afterReturning() is called               │
│  OUTPUT: "After Returning from Method"                      │
│  OUTPUT: "Return value: 15"                                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 7: Return to Client                                    │
│  ────────────────────────                                   │
│  OUTPUT: "Result: 15"                                       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Console Output

```
Before Calling the Method
Method name: multiply
beginning of invoke
Inside multiply method - BUSINESS LOGIC
after proceed
After Returning from Method
Return value: 15
Result: 15
```

---

## 7. Common Interview Questions

### Q1: What is ProxyFactoryBean?
**A:** ProxyFactoryBean is a Spring class that creates a proxy object wrapping your target object. The proxy applies configured advices before/after method calls on the target.

### Q2: What interfaces do advice classes implement?
**A:**
- **Before**: `MethodBeforeAdvice`
- **After Returning**: `AfterReturningAdvice`
- **Around**: `MethodInterceptor` (from AOP Alliance)
- **Throws**: `ThrowsAdvice`

### Q3: What is mi.proceed() in MethodInterceptor?
**A:** `mi.proceed()` is the method that actually calls the target method. Without calling it, the target method won't execute. This gives around advice the power to prevent method execution entirely.

### Q4: What properties does ProxyFactoryBean require?
**A:** Three main properties:
1. `target` - the actual business object
2. `interceptorNames` - list of advice bean names
3. `proxyInterfaces` - interface(s) the proxy should implement

---

## 8. Key Takeaways

📌 **ProxyFactoryBean** creates proxy objects that apply advices

📌 **Before advice** implements `MethodBeforeAdvice`

📌 **After advice** implements `AfterReturningAdvice`

📌 **Around advice** implements `MethodInterceptor`

📌 **mi.proceed()** is critical - calls the actual target method

📌 **Order of advice** matters - they execute in the order specified

📌 **getBean()** returns the **proxy**, not the actual target

📌 **Target is never called directly** - always through proxy

---

*Previous: [10. Introduction to AOP](./10_Introduction_to_AOP.md)*

*Next: [12. Annotation-based AOP](./12_Annotation_Based_AOP.md)*
