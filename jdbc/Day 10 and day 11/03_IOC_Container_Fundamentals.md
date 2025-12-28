# IOC Container Fundamentals

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is IOC (Inversion of Control)](#2-what-is-ioc-inversion-of-control)
3. [What is IOC Container](#3-what-is-ioc-container)
4. [BeanFactory vs ApplicationContext](#4-beanfactory-vs-applicationcontext)
5. [Spring Bean Configuration File](#5-spring-bean-configuration-file)
6. [Complete Code Example](#6-complete-code-example)
7. [Execution Flow](#7-execution-flow)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

The **IOC Container** is the **foundation** of the entire Spring Framework. It is responsible for:
- Creating objects (beans)
- Managing their lifecycle
- Wiring dependencies between objects

> **Key Insight**: The IOC Container is just a **Java class**! This is what makes Spring lightweight.

---

## 2. What is IOC (Inversion of Control)

### Traditional Control Flow vs IOC

```
┌─────────────────────────────────────────────────────────────┐
│              TRADITIONAL CONTROL FLOW                        │
│                                                              │
│   Your Application                                           │
│   ┌──────────────────────────────────────────────────┐      │
│   │  public static void main(String[] args) {        │      │
│   │      // YOU create objects                       │      │
│   │      Gun gun = new Gun();                        │      │
│   │      Soldier soldier = new Soldier();            │      │
│   │      soldier.setWeapon(gun);  // YOU wire them   │      │
│   │      soldier.perform();                          │      │
│   │  }                                               │      │
│   └──────────────────────────────────────────────────┘      │
│                                                              │
│   YOU are in control of:                                     │
│   ✗ Object creation                                          │
│   ✗ Object wiring (connecting dependencies)                  │
│   ✗ Object lifecycle                                         │
└─────────────────────────────────────────────────────────────┘

                           VS

┌─────────────────────────────────────────────────────────────┐
│             INVERSION OF CONTROL (IOC)                       │
│                                                              │
│   Configuration File (beans.xml)                             │
│   ┌──────────────────────────────────────────────────┐      │
│   │  <bean id="weapon" class="mypack.Gun"/>          │      │
│   │  <bean id="soldier" class="mypack.Soldier">      │      │
│   │      <property name="weapon" ref="weapon"/>      │      │
│   │  </bean>                                         │      │
│   └──────────────────────────────────────────────────┘      │
│                                                              │
│   Your Application                                           │
│   ┌──────────────────────────────────────────────────┐      │
│   │  // Container creates and wires objects          │      │
│   │  ApplicationContext ctx = ...                    │      │
│   │  Soldier s = ctx.getBean("soldier");             │      │
│   │  s.perform();  // Just use it!                   │      │
│   └──────────────────────────────────────────────────┘      │
│                                                              │
│   CONTAINER is in control of:                                │
│   ✓ Object creation                                          │
│   ✓ Object wiring                                            │
│   ✓ Object lifecycle                                         │
└─────────────────────────────────────────────────────────────┘
```

### Definition

**IOC (Inversion of Control)** means the control of object creation and dependency management is **inverted** - transferred from the application code to an external container.

---

## 3. What is IOC Container

### Definition

The **IOC Container** is a Java class that:
1. Reads configuration (XML or annotations)
2. Creates objects (beans)
3. Manages object lifecycle
4. Wires dependencies (injects dependencies)

### Why is IOC Container Lightweight?

> **Important Interview Point**: IOC Container is lightweight because it is just a **CLASS** (like `ClassPathXmlApplicationContext`), not a heavy server or application container!

```java
// This IS the IOC Container - just a simple Java class!
ClassPathXmlApplicationContext container = 
    new ClassPathXmlApplicationContext("beans.xml");
```

### IOC Container Types

Spring provides two main IOC container types:

| Container Type | Interface | Common Implementation |
|----------------|-----------|----------------------|
| **BeanFactory** | `BeanFactory` | `XmlBeanFactory` (deprecated) |
| **ApplicationContext** | `ApplicationContext` | `ClassPathXmlApplicationContext`, `AnnotationConfigApplicationContext` |

---

## 4. BeanFactory vs ApplicationContext

### BeanFactory

- Basic container providing fundamental DI support
- **Lazy loading** - beans created only when requested
- Lightweight, minimal functionality
- **Deprecated** in modern Spring

### ApplicationContext

- **Extends BeanFactory** with additional features
- **Eager loading** - all singleton beans created at startup
- Recommended for all applications
- Additional features: internationalization, event publishing, etc.

### Comparison Table

| Feature | BeanFactory | ApplicationContext |
|---------|-------------|-------------------|
| Bean Loading | Lazy | Eager (default) |
| Internationalization | ❌ | ✅ |
| Event Publishing | ❌ | ✅ |
| Automatic BeanPostProcessor | ❌ | ✅ |
| Annotation Support | Limited | Full |
| Recommended | ❌ | ✅ |

### Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTAINER HIERARCHY                       │
│                                                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │                    BeanFactory                       │   │
│   │  - Basic DI                                          │   │
│   │  - Lazy loading                                      │   │
│   │  - getBean() method                                  │   │
│   └─────────────────────────┬───────────────────────────┘   │
│                             │ extends                        │
│                             ▼                                │
│   ┌─────────────────────────────────────────────────────┐   │
│   │              ApplicationContext                      │   │
│   │  - Everything from BeanFactory +                    │   │
│   │  - Eager loading (default)                          │   │
│   │  - Internationalization (i18n)                      │   │
│   │  - Event publishing                                 │   │
│   │  - Annotation processing                            │   │
│   │  - Resource loading                                 │   │
│   └─────────────────────────────────────────────────────┘   │
│                             │                                │
│                             ▼                                │
│   ┌─────────────────────────────────────────────────────┐   │
│   │ Implementations:                                     │   │
│   │ • ClassPathXmlApplicationContext                    │   │
│   │ • FileSystemXmlApplicationContext                   │   │
│   │ • AnnotationConfigApplicationContext                │   │
│   │ • WebApplicationContext                             │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Spring Bean Configuration File

The **Spring Bean Configuration File** is an XML file where we configure beans and their dependencies.

### Basic Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
    
    <!-- Bean definitions go here -->
    
</beans>
```

### Line-by-Line Explanation

```xml
<?xml version="1.0" encoding="UTF-8"?>
```
- **Line 1**: XML declaration
- Specifies this is an XML file with UTF-8 encoding

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
```
- **Root element**: `<beans>` - contains all bean definitions
- **xmlns**: Default namespace for Spring beans

```xml
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
```
- **xmlns:xsi**: XML Schema Instance namespace for validation

```xml
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
```
- **schemaLocation**: Where to find the XSD schema for validation
- IDE uses this for autocomplete and validation

### Bean Definition Elements

| Element | Purpose | Example |
|---------|---------|---------|
| `<bean>` | Defines a bean | `<bean id="..." class="..."/>` |
| `<property>` | Setter injection | `<property name="..." value="..."/>` |
| `<constructor-arg>` | Constructor injection | `<constructor-arg type="..." value="..."/>` |
| `<ref>` | Reference to another bean | `<ref bean="..."/>` |

### Where to Place Configuration File

> **Important**: Place the configuration file in the **src** folder (classpath root) so it's accessible via `ClassPathXmlApplicationContext`.

---

## 6. Complete Code Example

### Project Structure

```
project/
├── src/
│   ├── mypack/
│   │   ├── Account.java
│   │   ├── CurrentAccountImpl.java
│   │   ├── SavingAccountImpl.java
│   │   ├── AccountBean.java
│   │   └── Main.java
│   └── account.xml
└── pom.xml
```

### File: Account.java
```java
package mypack;

// Line 1: Package declaration
// Line 3-7: Interface defining the contract for all account types
public interface Account
{
    // Line 5: Abstract method that all accounts must implement
    public void deposit();
}
```
**Explanation**: This is the **interface** that all account implementations must follow. It defines the contract with a single method `deposit()`.

---

### File: CurrentAccountImpl.java
```java
package mypack;

// Line 1: Package declaration
// Line 3-11: Implementation of Account interface for Current Account
public class CurrentAccountImpl implements Account 
{
    // Line 5-9: Implementation of deposit method
    @Override
    public void deposit() 
    {
        // Line 7: Prints message specific to current account
        System.out.println("inside current deposit");
    }
}
```
**Explanation**: This is a **concrete implementation** of the Account interface for current (checking) accounts.

---

### File: SavingAccountImpl.java
```java
package mypack;

// Line 1: Package declaration
// Line 3-11: Implementation of Account interface for Saving Account
public class SavingAccountImpl implements Account 
{
    // Line 5-9: Implementation of deposit method
    @Override
    public void deposit() 
    {
        // Line 7: Prints message specific to saving account
        System.out.println("inside saving deposit");
    }
}
```
**Explanation**: This is another **concrete implementation** of the Account interface for savings accounts.

---

### File: AccountBean.java
```java
package mypack;

// Line 1: Package declaration
// Line 3-18: Bean class that depends on Account
public class AccountBean
{
    // Line 5: Dependency - will be injected by Spring
    private Account account;
    
    // Line 8-11: No-arg constructor
    public AccountBean()
    {
        System.out.println("in AccountBean no-arg constructor");
    }
    
    // Line 14-18: Setter method for dependency injection
    // Spring will call this method to inject the Account dependency
    public void setAccount(Account account) 
    {
        System.out.println("inside setter method");
        this.account = account;
    }
    
    // Line 21-24: Business method that uses the injected dependency
    public void makeDeposit()
    {
        account.deposit();
    }
}
```

**Explanation:**
| Line | Purpose |
|------|---------|
| 5 | Declares dependency on `Account` interface (not implementation) |
| 8-11 | No-arg constructor - called by Spring to create bean |
| 14-18 | **Setter method** - Spring calls this to inject dependency. Name `setAccount` means property is `account` |
| 21-24 | Business method using the injected account |

---

### File: account.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="
http://www.springframework.org/schema/beans 
http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">

    <!-- Line 8: Define accountbean with setter injection -->
    <bean id="accountbean" class="mypack.AccountBean">
        <!-- Line 9-11: Inject 'caccount' bean into 'account' property -->
        <property name="account">
            <ref bean="caccount"/> 
        </property>
    </bean>
    
    <!-- Line 14: Define Current Account implementation -->
    <bean id="caccount" class="mypack.CurrentAccountImpl"/>
    
    <!-- Line 17: Define Saving Account implementation -->
    <bean id="saccount" class="mypack.SavingAccountImpl"/>

</beans>
```

**Line-by-Line Explanation:**

| Line | Element | Explanation |
|------|---------|-------------|
| 8 | `<bean id="accountbean"...>` | Creates bean named "accountbean" of type AccountBean |
| 9-11 | `<property name="account">` | Calls `setAccount()` method on accountbean |
| 10 | `<ref bean="caccount"/>` | Injects the bean with id="caccount" |
| 14 | `<bean id="caccount".../>` | Creates CurrentAccountImpl bean |
| 17 | `<bean id="saccount".../>` | Creates SavingAccountImpl bean (not used currently) |

> **Important**: In XML, **sequence does not matter**! Spring resolves all references regardless of order.

---

### File: Main.java
```java
package mypack;

// Line 1: Package declaration
// Line 3: Import the ApplicationContext implementation
import org.springframework.context.support.ClassPathXmlApplicationContext;

// Line 5-17: Main application class
public class Main 
{
    public static void main(String[] args) 
    {
        // Line 10-11: Create IOC Container
        // ClassPathXmlApplicationContext is the IOC Container
        // args[0] or "account.xml" is the configuration file
        ClassPathXmlApplicationContext appContext = 
            new ClassPathXmlApplicationContext(args[0]);
            
        // Line 14: Confirmation message
        System.out.println("ClassPathXmlApplicationContext instantiated");
        
        // Line 17-18: Get bean from container
        // We're asking: "Mr. IOC Container, give us the object referred by 'accountbean'"
        // Container returns the bean with dependencies already injected!
        AccountBean ab = (AccountBean) appContext.getBean("accountbean");
        
        // Line 21: Use the bean - account is already injected!
        ab.makeDeposit();
        
        // Line 24: Close the container
        appContext.close();
    }
}
```

**Key Points:**

1. **Line 10-11**: `ClassPathXmlApplicationContext` IS the IOC Container
   - We pass the configuration file name (account.xml)
   - Container reads the file and creates all beans

2. **Line 17-18**: `getBean("accountbean")`
   - Asks the container for a bean by ID
   - Returns `Object`, so we cast to `AccountBean`
   - The account dependency is ALREADY INJECTED!

3. **Line 21**: Just use the bean - no manual wiring needed!

---

## 7. Execution Flow

### Step-by-Step Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     EXECUTION FLOW                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 1: Create IOC Container                                │
│  ─────────────────────────────                              │
│  ClassPathXmlApplicationContext appContext =                 │
│      new ClassPathXmlApplicationContext("account.xml");      │
│                                                              │
│      Container reads account.xml                             │
│      ↓                                                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 2: Container creates beans (EAGER - at startup)        │
│  ────────────────────────────────────────────               │
│  a) Creates CurrentAccountImpl (id="caccount")              │
│  b) Creates SavingAccountImpl (id="saccount")               │
│  c) Creates AccountBean (id="accountbean")                  │
│     → Prints: "in AccountBean no-arg constructor"           │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 3: Container wires dependencies                        │
│  ────────────────────────────────────────                   │
│  Sees: <property name="account"><ref bean="caccount"/>      │
│  Calls: accountbean.setAccount(caccount)                    │
│     → Prints: "inside setter method"                        │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 4: Container is ready                                  │
│  ──────────────────────────                                 │
│  All beans created and wired                                 │
│     → Prints: "ClassPathXmlApplicationContext instantiated" │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 5: Application gets bean                               │
│  ─────────────────────────────                              │
│  AccountBean ab = appContext.getBean("accountbean");        │
│  (Returns the SAME pre-created, pre-wired bean)             │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  STEP 6: Application uses bean                               │
│  ─────────────────────────────                              │
│  ab.makeDeposit();                                          │
│     → account.deposit() is called                           │
│     → Prints: "inside current deposit"                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Console Output

```
in AccountBean no-arg constructor
inside setter method
ClassPathXmlApplicationContext instantiated
inside current deposit
```

### Changing to Saving Account

To use SavingAccountImpl instead of CurrentAccountImpl, just change ONE line in XML:

```xml
<!-- Before -->
<ref bean="caccount"/>

<!-- After -->
<ref bean="saccount"/>
```

**New Output:**
```
in AccountBean no-arg constructor
inside setter method
ClassPathXmlApplicationContext instantiated
inside saving deposit
```

---

## 8. Common Interview Questions

### Q1: What is IOC Container?
**A:** IOC Container is a Java class that manages bean lifecycle and dependencies. It reads configuration (XML or annotations), creates beans, and injects dependencies. Main implementations are `BeanFactory` and `ApplicationContext`.

### Q2: Why is IOC Container lightweight?
**A:** Because it's just a Java class (like `ClassPathXmlApplicationContext`), not a heavy application server. It starts quickly and has minimal overhead.

### Q3: What is the difference between BeanFactory and ApplicationContext?
**A:** 
- **BeanFactory**: Basic DI, lazy loading, minimal features
- **ApplicationContext**: Extends BeanFactory, eager loading, i18n, event publishing, annotation support
- ApplicationContext is recommended for all applications

### Q4: What are the ways to configure IOC Container?
**A:** Three ways:
1. **XML Configuration**: beans.xml with `<bean>` elements
2. **Annotation Configuration**: `@Component`, `@Autowired`, `@Configuration`
3. **Java Configuration**: `@Configuration` class with `@Bean` methods

### Q5: What is the default bean scope?
**A:** **Singleton** - only one instance created per container, returned for all requests.

---

## 9. Key Takeaways

📌 **IOC Container** is the foundation of Spring - manages beans and dependencies

📌 **IOC Container is just a class** (`ClassPathXmlApplicationContext`) - that's why Spring is lightweight

📌 **ApplicationContext** is preferred over BeanFactory (more features)

📌 **Default loading is EAGER** - all singleton beans created at container startup

📌 **Configuration file** defines beans and their wiring

📌 **getBean()** returns pre-created, pre-wired beans

📌 **Change implementation** by modifying XML only - no Java changes!

📌 **In XML, sequence doesn't matter** - Spring resolves all references

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│               IOC CONTAINER QUICK REFERENCE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  CREATING CONTAINER:                                         │
│  ApplicationContext ctx =                                    │
│      new ClassPathXmlApplicationContext("beans.xml");        │
│                                                              │
│  GETTING BEANS:                                              │
│  MyBean bean = (MyBean) ctx.getBean("beanId");              │
│  // OR with type safety:                                     │
│  MyBean bean = ctx.getBean("beanId", MyBean.class);         │
│                                                              │
│  BEAN DEFINITION:                                            │
│  <bean id="myBean" class="mypack.MyBean"/>                  │
│                                                              │
│  SETTER INJECTION:                                           │
│  <bean id="myBean" class="mypack.MyBean">                   │
│      <property name="dependency" ref="otherBean"/>          │
│  </bean>                                                     │
│                                                              │
│  CONTAINER TYPES:                                            │
│  • ClassPathXmlApplicationContext - XML from classpath      │
│  • FileSystemXmlApplicationContext - XML from filesystem    │
│  • AnnotationConfigApplicationContext - Java config         │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [02. Coupling and Dependency Injection](./02_Coupling_and_Dependency_Injection.md)*

*Next: [04. Setter Injection Complete Guide](./04_Setter_Injection_Complete_Guide.md)*
