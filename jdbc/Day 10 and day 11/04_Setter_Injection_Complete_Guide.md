# Setter Injection Complete Guide

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Setter Injection](#2-what-is-setter-injection)
3. [How Setter Injection Works](#3-how-setter-injection-works)
4. [The `<property>` Tag](#4-the-property-tag)
5. [Complete Code Example](#5-complete-code-example)
6. [Injecting Primitives vs Objects](#6-injecting-primitives-vs-objects)
7. [Execution Flow](#7-execution-flow)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

**Setter Injection** is one of the most commonly used dependency injection methods in Spring. It involves injecting dependencies through setter methods of a class.

> **Key Point**: In setter injection, Spring calls the setter method automatically to inject the dependency. You don't call it manually!

---

## 2. What is Setter Injection

### Definition

Setter Injection is a type of dependency injection where:
- Dependencies are provided through **setter methods**
- Spring container calls the setter methods to inject dependencies
- Uses the `<property>` tag in XML configuration

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│                    SETTER INJECTION                          │
│                                                              │
│   XML Configuration                                          │
│   ┌───────────────────────────────────────────────────┐     │
│   │  <bean id="a1" class="mypack.InjectSetter">       │     │
│   │      <property name="message" value="www"/>       │     │
│   │      <property name="num" value="150"/>           │     │
│   │  </bean>                                          │     │
│   └───────────────────────────────────────────────────┘     │
│                         │                                    │
│                         ▼                                    │
│   ┌───────────────────────────────────────────────────┐     │
│   │              IOC CONTAINER ACTIONS                 │     │
│   │                                                    │     │
│   │  1. Creates InjectSetter object (no-arg const.)   │     │
│   │  2. Calls setMessage("www")                       │     │
│   │  3. Calls setNum(150)                             │     │
│   │                                                    │     │
│   │  Bean is ready with values injected!              │     │
│   └───────────────────────────────────────────────────┘     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. How Setter Injection Works

### The Mechanism

```
┌─────────────────────────────────────────────────────────────┐
│              SETTER INJECTION MECHANISM                      │
│                                                              │
│   XML says:                                                  │
│   ┌─────────────────────────────────────────────────┐       │
│   │  <property name="message" value="www"/>         │       │
│   └─────────────────────────────────────────────────┘       │
│                          │                                   │
│                          ▼                                   │
│   Spring does internally:                                    │
│   ┌─────────────────────────────────────────────────┐       │
│   │  Step 1: Take property name = "message"         │       │
│   │  Step 2: Capitalize first letter = "Message"    │       │
│   │  Step 3: Prefix with "set" = "setMessage"       │       │
│   │  Step 4: Call setMessage("www")                 │       │
│   └─────────────────────────────────────────────────┘       │
│                                                              │
│   NAMING CONVENTION:                                         │
│   Property name → Setter method                              │
│   "message"     → setMessage()                               │
│   "num"         → setNum()                                   │
│   "firstName"   → setFirstName()                             │
│   "account"     → setAccount()                               │
└─────────────────────────────────────────────────────────────┘
```

### Requirements for Setter Injection

1. **No-arg constructor** (or default constructor) - Spring uses it to create the object
2. **Setter method** with standard naming convention (`set` + PropertyName)
3. **Property tag** in XML with matching property name

---

## 4. The `<property>` Tag

### Basic Syntax

```xml
<property name="propertyName" value="primitiveValue"/>
```
OR
```xml
<property name="propertyName">
    <ref bean="beanId"/>
</property>
```

### Attributes

| Attribute | Description | Example |
|-----------|-------------|---------|
| `name` | Property name (used to find setter method) | `name="message"` |
| `value` | Primitive value to inject (String, int, etc.) | `value="Hello"` |
| `ref` | Reference to another bean | `ref="accountBean"` |

### When to Use `value` vs `ref`

```
┌─────────────────────────────────────────────────────────────┐
│              WHEN TO USE VALUE vs REF                        │
│                                                              │
│   Use VALUE when injecting:                                  │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Primitives: int, double, boolean, etc.           │   │
│   │  • Strings: "Hello World"                           │   │
│   │  • Wrappers: Integer, Double, etc.                  │   │
│   │                                                     │   │
│   │  Example:                                           │   │
│   │  <property name="message" value="www"/>             │   │
│   │  <property name="num" value="150"/>                 │   │
│   │  <property name="active" value="true"/>             │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   Use REF (bean) when injecting:                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  • Object references (other beans)                  │   │
│   │  • Dependencies that are defined as beans           │   │
│   │                                                     │   │
│   │  Example:                                           │   │
│   │  <property name="account">                          │   │
│   │      <ref bean="currentAccount"/>                   │   │
│   │  </property>                                        │   │
│   │  OR shorthand:                                      │   │
│   │  <property name="account" ref="currentAccount"/>    │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Complete Code Example

### Project Structure
```
project/
├── src/
│   ├── mypack/
│   │   ├── InjectSetter.java
│   │   └── Main.java
│   └── injection.xml
└── pom.xml
```

### File: InjectSetter.java
```java
package mypack;
// Line 1: Package declaration

import java.beans.ConstructorProperties;
// Line 3: Import statement (not used in this example but included in source)

public class InjectSetter
// Line 5: Class declaration
{
    // Line 7-9: No-arg constructor - REQUIRED for setter injection
    // Spring uses this constructor to create the object first
    public InjectSetter() {
        System.out.println("Inside InjectSetter no-arg constructor");
    }
    
    // Line 10: Private field for message (String type)
    // Will be injected via setter
    private String message = null;
    
    // Line 11: Private field for num (int type)
    // Will be injected via setter
    private int num;

    // Line 13-17: Setter method for 'message' property
    // Spring calls this method when it sees:
    // <property name="message" value="www"/>
    public void setMessage(String message) 
    {
        System.out.println("in setMessage method");
        this.message = message;
    }

    // Line 19-23: Setter method for 'num' property
    // Spring calls this method when it sees:
    // <property name="num" value="150"/>
    public void setNum(int num) 
    {
        System.out.println("in setNum method");
        this.num = num;
    }
    
    // Line 24-26: Getter method for message
    public String getMessage() {
        return message;
    }
    
    // Line 27-29: Getter method for num
    public int getNum() {
        return num;
    }
}
```

**Detailed Explanation:**

| Line(s) | Code | Explanation |
|---------|------|-------------|
| 7-9 | `public InjectSetter()` | No-arg constructor called by Spring to create the object |
| 10 | `private String message = null` | Field that will receive injected value "www" |
| 11 | `private int num` | Field that will receive injected value 150 |
| 13-17 | `setMessage(String)` | Setter called by Spring when processing `<property name="message">` |
| 19-23 | `setNum(int)` | Setter called by Spring when processing `<property name="num">` |

---

### File: injection.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Line 1: XML declaration specifying version and encoding -->

<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
http://www.springframework.org/schema/beans 
http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
<!-- Line 2-5: Spring namespace declarations for bean configuration -->

    <!-- Line 6-9: Bean definition with setter injection -->
    <bean id="a1" class="mypack.InjectSetter">
        <!-- Line 7: Inject "www" into message property -->
        <!-- Spring will call: setMessage("www") -->
        <property name="message" value="www"/>
        
        <!-- Line 8: Inject 150 into num property -->
        <!-- Spring will call: setNum(150) -->
        <property name="num" value="150"/>
    </bean>
    
</beans>
```

**Line-by-Line Explanation:**

| Line | Element | What Happens |
|------|---------|--------------|
| 6 | `<bean id="a1" class="mypack.InjectSetter">` | Defines a bean with id "a1" of type InjectSetter |
| 7 | `<property name="message" value="www"/>` | Calls `setMessage("www")` on the bean |
| 8 | `<property name="num" value="150"/>` | Calls `setNum(150)` on the bean |

---

### File: Main.java
```java
package mypack;
// Line 1: Package declaration

import mypack.InjectSetter;
// Line 3: Import the bean class

import org.springframework.beans.factory.BeanFactory;
// Line 4: Import BeanFactory interface

import org.springframework.context.support.ClassPathXmlApplicationContext;
// Line 5: Import the IOC container implementation

public class Main {
// Line 7: Main class declaration

    public static void main(String[] args)
    // Line 8: Main method - entry point
    {
        // Line 10: Create IOC Container by loading injection.xml
        // At this point:
        // 1. Container reads injection.xml
        // 2. Creates InjectSetter object (calls no-arg constructor)
        // 3. Calls setMessage("www")
        // 4. Calls setNum(150)
        BeanFactory beanfactory = new ClassPathXmlApplicationContext("injection.xml");
        
        // Line 11: Confirmation that container is created
        System.out.println("after beanfactory creation");
        
        // Line 12: Get the bean from container
        // Bean is already created and configured - just returns reference!
        InjectSetter ic = (InjectSetter)beanfactory.getBean("a1");
        
        // Line 13: Verify message was injected
        System.out.println(ic.getMessage());  // Prints: www
        
        // Line 14: Verify num was injected
        System.out.println(ic.getNum());  // Prints: 150
    }
}
```

**Execution Explanation:**

| Step | Code | What Happens |
|------|------|--------------|
| 1 | `new ClassPathXmlApplicationContext("injection.xml")` | Container starts, reads XML |
| 2 | Container processing | Calls `new InjectSetter()` → prints "Inside InjectSetter no-arg constructor" |
| 3 | Container processing | Calls `setMessage("www")` → prints "in setMessage method" |
| 4 | Container processing | Calls `setNum(150)` → prints "in setNum method" |
| 5 | `System.out.println("after...")` | Prints "after beanfactory creation" |
| 6 | `getBean("a1")` | Returns the pre-configured bean |
| 7 | `getMessage()` | Returns "www" |
| 8 | `getNum()` | Returns 150 |

---

## 6. Injecting Primitives vs Objects

### Injecting Primitive Values

```xml
<bean id="employee" class="mypack.Employee">
    <!-- String value -->
    <property name="name" value="John Doe"/>
    
    <!-- int value -->
    <property name="age" value="30"/>
    
    <!-- double value -->
    <property name="salary" value="50000.00"/>
    
    <!-- boolean value -->
    <property name="active" value="true"/>
</bean>
```

### Injecting Object References

```xml
<!-- Define the dependency bean first -->
<bean id="address" class="mypack.Address">
    <property name="city" value="Mumbai"/>
    <property name="state" value="Maharashtra"/>
</bean>

<!-- Inject the address bean into employee -->
<bean id="employee" class="mypack.Employee">
    <property name="name" value="John Doe"/>
    
    <!-- Inject object reference using ref -->
    <property name="address" ref="address"/>
    
    <!-- OR using nested ref tag -->
    <property name="address">
        <ref bean="address"/>
    </property>
</bean>
```

### Diagram

```
┌─────────────────────────────────────────────────────────────┐
│           PRIMITIVE vs OBJECT INJECTION                      │
│                                                              │
│   PRIMITIVE INJECTION:                                       │
│   ┌───────────────────────────────────────────────────┐     │
│   │  value="www"  →  setMessage("www")                │     │
│   │  value="150"  →  setNum(150)                      │     │
│   │                                                   │     │
│   │  Container converts String "150" to int 150       │     │
│   └───────────────────────────────────────────────────┘     │
│                                                              │
│   OBJECT INJECTION:                                          │
│   ┌───────────────────────────────────────────────────┐     │
│   │  ref="address"  →  setAddress(addressBean)        │     │
│   │                                                   │     │
│   │  Container looks up bean with id="address"        │     │
│   │  and passes it to the setter                      │     │
│   └───────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Execution Flow

### Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 SETTER INJECTION FLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: Container Creation                                  │
│  ──────────────────────────                                 │
│  BeanFactory beanfactory =                                   │
│      new ClassPathXmlApplicationContext("injection.xml");    │
│                                                              │
│  Container reads injection.xml and processes it...          │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Bean Instantiation (EAGER by default)               │
│  ──────────────────────────────────────────                 │
│  Container sees:                                             │
│  <bean id="a1" class="mypack.InjectSetter">                 │
│                                                              │
│  Container does: new InjectSetter()                          │
│  ────────────────────────────────                           │
│  OUTPUT: "Inside InjectSetter no-arg constructor"           │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: Property Injection                                  │
│  ────────────────────────                                   │
│  Container sees:                                             │
│  <property name="message" value="www"/>                     │
│                                                              │
│  Container does: a1.setMessage("www")                       │
│  ────────────────────────────────────                       │
│  OUTPUT: "in setMessage method"                             │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: Property Injection (continued)                      │
│  ────────────────────────────────────                       │
│  Container sees:                                             │
│  <property name="num" value="150"/>                         │
│                                                              │
│  Container does: a1.setNum(150)                             │
│  ────────────────────────────                               │
│  OUTPUT: "in setNum method"                                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: Container Ready                                     │
│  ────────────────────                                       │
│  All beans created and configured                            │
│  OUTPUT: "after beanfactory creation"                       │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 6: Get Bean                                            │
│  ────────────────                                           │
│  InjectSetter ic = beanfactory.getBean("a1");               │
│  (Returns the same pre-created bean)                        │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 7: Use Bean                                            │
│  ─────────────                                              │
│  ic.getMessage()  →  "www"                                  │
│  ic.getNum()      →  150                                    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Console Output (Complete)

```
Inside InjectSetter no-arg constructor
in setMessage method
in setNum method
after beanfactory creation
www
150
```

---

## 8. Common Interview Questions

### Q1: What is Setter Injection?
**A:** Setter Injection is a type of dependency injection where dependencies are injected through setter methods. Spring uses the `<property>` tag in XML to specify which setter to call and what value to inject.

### Q2: How does Spring know which setter method to call?
**A:** Spring uses the property name to derive the setter method name:
1. Takes the property name (e.g., "message")
2. Capitalizes first letter ("Message")
3. Prefixes with "set" ("setMessage")
4. Calls that method

### Q3: When should I use Setter Injection vs Constructor Injection?
**A:** 
- **Setter Injection**: For optional dependencies, when you want to change dependencies after creation
- **Constructor Injection**: For mandatory dependencies, when dependencies shouldn't change after creation

### Q4: What happens if the setter method doesn't exist?
**A:** Spring throws a `BeanCreationException` with a message indicating that no matching setter method was found for the property.

### Q5: Can I inject both primitives and objects using setter injection?
**A:** Yes! Use `value` attribute for primitives and `ref` attribute for object references.

---

## 9. Key Takeaways

📌 **Setter Injection** uses setter methods to inject dependencies

📌 **`<property>` tag** is used in XML with `name`, `value`, or `ref` attributes

📌 Spring **derives setter name** from property name (message → setMessage)

📌 **No-arg constructor required** for setter injection

📌 Use **`value`** for primitives (String, int, etc.)

📌 Use **`ref`** for object references (other beans)

📌 **Eager loading** - Spring injects all properties at container startup

📌 After `getBean()`, the object is **already fully configured**

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│            SETTER INJECTION QUICK REFERENCE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  XML SYNTAX:                                                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  <!-- Primitive value -->                            │    │
│  │  <property name="message" value="Hello"/>            │    │
│  │                                                      │    │
│  │  <!-- Object reference -->                           │    │
│  │  <property name="account" ref="accountBean"/>        │    │
│  │                                                      │    │
│  │  <!-- Alternative ref syntax -->                     │    │
│  │  <property name="account">                           │    │
│  │      <ref bean="accountBean"/>                       │    │
│  │  </property>                                         │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  NAMING CONVENTION:                                          │
│  property name="xyz" → setXyz() method                      │
│                                                              │
│  REQUIREMENTS:                                               │
│  1. No-arg constructor in the bean class                    │
│  2. Setter method with correct naming                       │
│  3. Setter must be public                                   │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [03. IOC Container Fundamentals](./03_IOC_Container_Fundamentals.md)*

*Next: [05. Constructor Injection Deep Dive](./05_Constructor_Injection_Deep_Dive.md)*
