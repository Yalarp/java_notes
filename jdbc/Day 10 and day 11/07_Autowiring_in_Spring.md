# Autowiring in Spring

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is Autowiring](#2-what-is-autowiring)
3. [Autowiring Modes](#3-autowiring-modes)
4. [Autowire by Name](#4-autowire-by-name)
5. [Autowire by Type](#5-autowire-by-type)
6. [Autowire by Constructor](#6-autowire-by-constructor)
7. [No Qualifying Bean Error](#7-no-qualifying-bean-error)
8. [Complete Code Examples](#8-complete-code-examples)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

**Autowiring** is a feature in Spring that allows automatic dependency injection without explicitly specifying `<property>` or `<constructor-arg>` tags in XML.

> **Key Question**: Can we wire components without using `<property>` or `<constructor-arg>`?
> **Answer**: Yes! Using `autowire` attribute.

---

## 2. What is Autowiring

### Definition

Autowiring allows Spring to automatically resolve and inject dependencies (collaborating beans) into your bean.

### Traditional Wiring vs Autowiring

```
┌─────────────────────────────────────────────────────────────┐
│           TRADITIONAL WIRING (Manual)                        │
│                                                              │
│   <bean id="parentBean" class="mypack.ParentBean">          │
│       <property name="child" ref="childBean"/>              │
│   </bean>                                                    │
│   <bean id="childBean" class="mypack.ChildBean"/>           │
│                                                              │
│   ❌ Must explicitly specify every dependency                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│           AUTOWIRING (Automatic)                             │
│                                                              │
│   <bean id="parentBean" class="mypack.ParentBean"           │
│         autowire="byType"/>                                  │
│   <bean id="childBean" class="mypack.ChildBean"/>           │
│                                                              │
│   ✅ Spring automatically finds and injects dependency       │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Autowiring Modes

Spring supports 4 autowiring modes:

| Mode | Value | Description |
|------|-------|-------------|
| **no** | `autowire="no"` | No autowiring (default). Must use `<property>` or `<constructor-arg>` |
| **byName** | `autowire="byName"` | Matches bean id with property name |
| **byType** | `autowire="byType"` | Matches bean class with property type |
| **constructor** | `autowire="constructor"` | Like byType but for constructor arguments |

### Visual Overview

```
┌─────────────────────────────────────────────────────────────┐
│                   AUTOWIRING MODES                           │
│                                                              │
│   ┌──────────┐                                              │
│   │    no    │ → Default. Manual wiring required.           │
│   └──────────┘                                              │
│                                                              │
│   ┌──────────┐                                              │
│   │  byName  │ → Bean ID must match property name           │
│   └──────────┘   property: "address" ↔ bean id: "address"   │
│                                                              │
│   ┌──────────┐                                              │
│   │  byType  │ → Bean class must match property type        │
│   └──────────┘   property: Address ↔ bean class: Address    │
│                                                              │
│   ┌──────────┐                                              │
│   │constructor│ → byType but for constructor params         │
│   └──────────┘   Internally uses byType matching            │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Autowire by Name

### How It Works

- Spring looks for a bean with **ID matching the property name**
- Uses **setter injection** internally
- Property name must exactly match bean ID

### Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   AUTOWIRE BY NAME                           │
│                                                              │
│   XML:                                                       │
│   <bean id="employee" class="Employee" autowire="byName"/>  │
│   <bean id="address" class="Address"/>                      │
│                       ↑                                      │
│                       │                                      │
│   Java Class:         │                                      │
│   class Employee {    │                                      │
│       Address address;│ ← Property name "address"           │
│                       │                                      │
│       void setAddress(Address a) {                          │
│           this.address = a;                                 │
│       }               │                                      │
│   }                   │                                      │
│                       │                                      │
│   MATCH: property name "address" = bean id "address" ✅     │
└─────────────────────────────────────────────────────────────┘
```

### Code Example

**File: inject.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
    
    <!-- Parent bean with autowire="byName" -->
    <bean id="myClass2" class="mypack.MyClass2" autowire="byName"/>
    
    <!-- Child bean - ID must match property name! -->
    <bean id="myClass1" class="mypack.MyClass1"/>
    
</beans>
```

> **Important**: Bean ID `myClass1` must match property name `myClass1` in MyClass2.

---

## 5. Autowire by Type

### How It Works

- Spring looks for a bean with **class matching the property type**
- Uses **setter injection** internally
- Only **one bean** of that type should exist (otherwise ambiguity error)

### Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   AUTOWIRE BY TYPE                           │
│                                                              │
│   XML:                                                       │
│   <bean id="employee" class="Employee" autowire="byType"/>  │
│   <bean id="addr" class="Address"/>                         │
│                         ↑                                    │
│                         │ Type: Address                      │
│   Java Class:           │                                    │
│   class Employee {      │                                    │
│       Address address;  │ ← Property type: Address          │
│                         │                                    │
│       void setAddress(Address a) {                          │
│           this.address = a;                                 │
│       }                 │                                    │
│   }                     │                                    │
│                         │                                    │
│   MATCH: property type "Address" = bean class "Address" ✅  │
│                                                              │
│   NOTE: Bean ID doesn't matter! Only TYPE matters.          │
└─────────────────────────────────────────────────────────────┘
```

### The Ambiguity Problem

```
┌─────────────────────────────────────────────────────────────┐
│              AMBIGUITY ERROR (byType)                        │
│                                                              │
│   XML:                                                       │
│   <bean id="employee" class="Employee" autowire="byType"/>  │
│   <bean id="homeAddr" class="Address"/>  ← Address type     │
│   <bean id="officeAddr" class="Address"/> ← Address type    │
│                                                              │
│   ❌ ERROR: Two beans of type "Address" found!              │
│   Spring doesn't know which one to inject!                  │
│                                                              │
│   Error: "No qualifying bean of type [Address] is defined:  │
│          expected single matching bean but found 2"         │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Autowire by Constructor

### How It Works

- Spring looks for beans matching **constructor parameter types**
- Internally uses **byType** matching
- Uses **constructor injection**

### Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                AUTOWIRE BY CONSTRUCTOR                       │
│                                                              │
│   XML:                                                       │
│   <bean id="employee" class="Employee"                      │
│         autowire="constructor"/>                             │
│   <bean id="addr" class="Address"/>                         │
│                                                              │
│   Java Class:                                                │
│   class Employee {                                           │
│       Address address;                                       │
│                                                              │
│       Employee(Address address) {  ← Constructor param      │
│           this.address = address;                           │
│       }                                                      │
│   }                                                          │
│                                                              │
│   Spring calls: new Employee(addressBean)                   │
│                                                              │
│   NOTE: autowire="constructor" internally is "byType"       │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. No Qualifying Bean Error

### When Does This Error Occur?

This error occurs when using `byType` or `constructor` autowiring and:
- Multiple beans of the same type exist (ambiguity)
- No bean of the required type exists

### Error Message

```
Error: No qualifying bean of type [mypack.Address] is defined:
expected single matching bean but found 2: homeAddr, officeAddr
```

### Solution

Use `@Qualifier` annotation or switch to `byName` autowiring.

---

## 8. Complete Code Examples

### Example: Autowire byName

**File: MyClass1.java**
```java
package mypack;

public class MyClass1 {
    public MyClass1() {
        System.out.println("MyClass1 constructor called");
    }
    
    public void display() {
        System.out.println("Inside MyClass1 display method");
    }
}
```

**File: MyClass2.java**
```java
package mypack;

public class MyClass2 {
    // Property name is "myClass1" - must match bean ID!
    private MyClass1 myClass1;
    
    public MyClass2() {
        System.out.println("MyClass2 constructor called");
    }
    
    // Setter method - called by Spring for autowire="byName"
    public void setMyClass1(MyClass1 myClass1) {
        System.out.println("setMyClass1 called");
        this.myClass1 = myClass1;
    }
    
    public void show() {
        myClass1.display();
    }
}
```

**File: inject.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">

    <!-- autowire="byName" looks for bean with id="myClass1" -->
    <bean id="myClass2" class="mypack.MyClass2" autowire="byName"/>
    
    <!-- Bean ID "myClass1" matches property name in MyClass2 -->
    <bean id="myClass1" class="mypack.MyClass1"/>
    
</beans>
```

**File: Main.java**
```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext ctx = 
            new ClassPathXmlApplicationContext("inject.xml");
        
        MyClass2 obj = (MyClass2) ctx.getBean("myClass2");
        obj.show();
        
        ctx.close();
    }
}
```

**Output:**
```
MyClass1 constructor called
MyClass2 constructor called
setMyClass1 called
Inside MyClass1 display method
```

---

## 9. Common Interview Questions

### Q1: What is autowiring in Spring?
**A:** Autowiring is a feature that allows Spring to automatically inject dependencies without explicitly specifying `<property>` or `<constructor-arg>` tags. Spring resolves dependencies based on name, type, or constructor.

### Q2: What are the autowiring modes?
**A:** Four modes:
1. **no** (default) - manual wiring required
2. **byName** - matches bean ID with property name
3. **byType** - matches bean class with property type
4. **constructor** - matches constructor parameter types (internally byType)

### Q3: What is "No qualifying bean" error?
**A:** This error occurs when autowiring by type finds multiple beans of the same type, causing ambiguity. Spring doesn't know which bean to inject.

### Q4: How to resolve autowiring ambiguity?
**A:** Use `@Qualifier` annotation to specify which bean to inject, or use `@Primary` to mark one bean as preferred.

### Q5: Which autowire mode uses setter injection?
**A:** `byName` and `byType` use setter injection. `constructor` uses constructor injection.

---

## 10. Key Takeaways

📌 **Autowiring** eliminates need for explicit `<property>` or `<constructor-arg>`

📌 **Default mode is "no"** - must explicitly enable autowiring

📌 **byName**: Bean ID must match property name exactly

📌 **byType**: Bean class must match property type (only one bean allowed)

📌 **constructor**: Uses byType matching for constructor parameters

📌 **Ambiguity error** occurs when multiple beans of same type exist

📌 Use **byName** when you have multiple beans of same type

📌 **autowire="constructor" is internally byType**

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│              AUTOWIRING QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SYNTAX:                                                     │
│  <bean id="..." class="..." autowire="MODE"/>               │
│                                                              │
│  MODES:                                                      │
│  ┌──────────────┬────────────────────────────────────────┐  │
│  │ Mode         │ Matching Strategy                       │  │
│  ├──────────────┼────────────────────────────────────────┤  │
│  │ no           │ Default. No autowiring.                 │  │
│  │ byName       │ Bean ID = Property name                │  │
│  │ byType       │ Bean class = Property type             │  │
│  │ constructor  │ Bean class = Constructor param type    │  │
│  └──────────────┴────────────────────────────────────────┘  │
│                                                              │
│  INJECTION TYPE:                                             │
│  byName, byType → Setter injection                          │
│  constructor    → Constructor injection                     │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [06. Bean Scopes and Lifecycle](./06_Bean_Scopes_and_Lifecycle.md)*

*Next: [08. Component Scanning and Annotations](./08_Component_Scanning_and_Annotations.md)*
