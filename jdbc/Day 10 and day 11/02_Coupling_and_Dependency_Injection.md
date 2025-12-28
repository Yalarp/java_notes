# Coupling and Dependency Injection

## Table of Contents
1. [Introduction](#1-introduction)
2. [Understanding Coupling](#2-understanding-coupling)
3. [Tight Coupling - The Problem](#3-tight-coupling---the-problem)
4. [Loose Coupling - First Attempt](#4-loose-coupling---first-attempt)
5. [The Remaining Problem](#5-the-remaining-problem)
6. [Dependency Injection - The Solution](#6-dependency-injection---the-solution)
7. [Types of Dependency Injection](#7-types-of-dependency-injection)
8. [Complete Code Examples](#8-complete-code-examples)
9. [Execution Flow](#9-execution-flow)
10. [Common Interview Questions](#10-common-interview-questions)
11. [Key Takeaways](#11-key-takeaways)

---

## 1. Introduction

Before diving into Spring's dependency injection, it's crucial to understand the problem it solves. This note explains **coupling** - what it is, why tight coupling is bad, and how Spring's Dependency Injection achieves true loose coupling.

> **The Core Problem**: How do we make our classes independent of specific implementations?

---

## 2. Understanding Coupling

### What is Coupling?

**Coupling** refers to the degree of interdependence between software modules. It measures how closely connected two classes or modules are.

```
┌────────────────────────────────────────────────────────────────┐
│                     COUPLING SPECTRUM                           │
│                                                                 │
│   TIGHT COUPLING ◄──────────────────────►  LOOSE COUPLING      │
│                                                                 │
│   High dependency                          Low dependency       │
│   Hard to maintain                         Easy to maintain     │
│   Difficult to test                        Easy to test         │
│   Changes ripple                           Changes isolated     │
│   NOT desirable                            DESIRABLE            │
└────────────────────────────────────────────────────────────────┘
```

### Why Does Coupling Matter?

| Tight Coupling Problems | Loose Coupling Benefits |
|-------------------------|-------------------------|
| Changing one class breaks others | Changes are isolated |
| Difficult to unit test | Easy to test with mocks |
| Code reuse is hard | High reusability |
| Maintenance nightmare | Easy maintenance |
| Inflexible design | Flexible, adaptable |

---

## 3. Tight Coupling - The Problem

### The Soldier-Weapon Example

Let's understand tight coupling with a classic example:

```
┌─────────────────────────────────────────────────────────────┐
│                    TIGHT COUPLING EXAMPLE                    │
│                                                              │
│   ┌──────────────┐         ┌──────────────┐                 │
│   │   SOLDIER    │ ──────▶ │     GUN      │                 │
│   │              │ direct  │              │                 │
│   │  perform()   │ dependency              │                │
│   │  {           │                         │                 │
│   │   Gun g=new Gun(); ◄─── PROBLEM!                        │
│   │   g.attack();│                         │                 │
│   │  }           │                         │                 │
│   └──────────────┘                         │                 │
│                                                              │
│   Soldier is DIRECTLY dependent on Gun class                │
│   What if soldier needs Sword or Missile?                    │
│   We must CHANGE the Soldier class!                          │
└─────────────────────────────────────────────────────────────┘
```

### Code Example - Tight Coupling

**File: Weapon.java (Interface)**
```java
// Line 1: Interface declaration - defines the contract
interface Weapon
{
    // Line 3: Abstract method that all weapons must implement
    void attack();
}
```

**File: Gun.java**
```java
// Line 1: Gun implements the Weapon interface
class Gun implements Weapon
{
    // Line 3-6: Implementation of attack method for Gun
    public void attack()
    {
        System.out.println("Attacking with Gun!");
    }
}
```

**File: Sword.java**
```java
// Line 1: Sword implements the Weapon interface
class Sword implements Weapon
{
    // Line 3-6: Implementation of attack method for Sword
    public void attack()
    {
        System.out.println("Attacking with Sword!");
    }
}
```

**File: Missiles.java**
```java
// Line 1: Missiles implements the Weapon interface
class Missiles implements Weapon
{
    // Line 3-6: Implementation of attack method for Missiles
    public void attack()
    {
        System.out.println("Attacking with Missiles!");
    }
}
```

**File: Soldier.java (TIGHTLY COUPLED)**
```java
// Line 1: Soldier class - the class that needs a weapon
class Soldier
{
    // Line 3-7: perform method with TIGHT COUPLING
    void perform()
    {
        // Line 5: ❌ PROBLEM - Directly creating Gun object
        // This is TIGHT COUPLING - Soldier depends on Gun directly
        Gun g = new Gun();  // <-- TIGHT COUPLING!
        
        // Line 6: Calling attack on the specific Gun instance
        g.attack();
    }
}
```

**File: MyApp.java**
```java
// Line 1: Main application class
public class MyApp
{
    public static void main(String args[])
    {
        // Line 5: Creating a Soldier object
        Soldier s = new Soldier();
        
        // Line 6: Calling perform - soldier always uses Gun!
        s.perform();  // Always attacks with Gun
    }
}
```

### The Problem Explained

```
┌─────────────────────────────────────────────────────────────┐
│                    TIGHT COUPLING PROBLEM                    │
│                                                              │
│  Current Code:                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  void perform()                                       │   │
│  │  {                                                    │   │
│  │      Gun g = new Gun();  ◄── Hardcoded dependency!   │   │
│  │      g.attack();                                      │   │
│  │  }                                                    │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                              │
│  ❌ What if soldier needs to use Sword instead of Gun?      │
│  ❌ We MUST modify the Soldier class!                       │
│  ❌ This is called "Program to Implementation"              │
│  ❌ This leads to MAINTENANCE NIGHTMARE                     │
└─────────────────────────────────────────────────────────────┘
```

> **Key Term**: This pattern is called **"Program to Implementation"** - we're programming to a specific class (Gun) instead of an interface (Weapon).

---

## 4. Loose Coupling - First Attempt

### The Solution: Program to Interface

To achieve loose coupling, we use **Interface-based programming**:

```
┌─────────────────────────────────────────────────────────────┐
│                    LOOSE COUPLING ATTEMPT                    │
│                                                              │
│                      ┌──────────┐                            │
│                      │ WEAPON   │  (Interface)               │
│                      │ attack() │                            │
│                      └────┬─────┘                            │
│           ┌───────────────┼───────────────┐                  │
│           │               │               │                  │
│      ┌────▼────┐    ┌────▼────┐    ┌────▼────┐              │
│      │   GUN   │    │  SWORD  │    │ MISSILES│              │
│      └─────────┘    └─────────┘    └─────────┘              │
│                                                              │
│   ┌──────────────┐                                          │
│   │   SOLDIER    │                                          │
│   │              │                                          │
│   │ perform(     │                                          │
│   │  Weapon ref) │ ◄── Now accepts ANY weapon!              │
│   └──────────────┘                                          │
└─────────────────────────────────────────────────────────────┘
```

### Code Example - Loose Coupling (First Attempt)

**File: Soldier.java (LOOSELY COUPLED)**
```java
// Line 1: Soldier class - now loosely coupled
class Soldier
{
    // Line 3-7: perform method with LOOSE COUPLING
    // Now accepts Weapon interface, not specific implementation
    void perform(Weapon ref)  // <-- LOOSE COUPLING!
    {
        // Line 5: Can call attack on ANY weapon type
        // Works with Gun, Sword, Missiles, or any future weapon!
        ref.attack();
    }
}
```

**Explanation:**
- **Line 3**: Method now takes `Weapon` interface as parameter
- **Line 5**: Polymorphism - `ref.attack()` calls the appropriate implementation
- **No dependency** on any specific weapon class inside Soldier!

**File: MyApp.java (Updated)**
```java
// Line 1: Main application class
public class MyApp
{
    public static void main(String args[])
    {
        // Line 5: Creating a Soldier object
        Soldier s = new Soldier();
        
        // Line 6-10: Now we can pass ANY weapon!
        s.perform(new Gun());      // Attacks with Gun
        // OR
        s.perform(new Sword());    // Attacks with Sword
        // OR
        s.perform(new Missiles()); // Attacks with Missiles
    }
}
```

### What We Achieved

```
┌────────────────────────────────────────────────────────────┐
│              FIRST ATTEMPT - ACHIEVEMENTS                   │
│                                                             │
│  ✅ Soldier class is NOW loosely coupled                   │
│  ✅ Soldier can use ANY weapon type                        │
│  ✅ Adding new weapons doesn't change Soldier              │
│  ✅ This is "Program to Interface"                         │
│                                                             │
│  BUT WAIT... there's still a problem!                       │
└────────────────────────────────────────────────────────────┘
```

---

## 5. The Remaining Problem

### The Problem Hasn't Been Fully Solved

Look carefully at `MyApp.java`:

```java
public class MyApp
{
    public static void main(String args[])
    {
        Soldier s = new Soldier();
        
        // ❌ PROBLEM: Tight coupling EXISTS HERE!
        s.perform(new Gun());  // <-- new Gun() is hardcoded!
    }
}
```

### Visual Representation

```
┌─────────────────────────────────────────────────────────────┐
│                    REMAINING PROBLEM                         │
│                                                              │
│   ┌──────────────┐                                          │
│   │   SOLDIER    │ ✅ Loosely coupled (uses interface)      │
│   └──────────────┘                                          │
│                                                              │
│   ┌──────────────┐                                          │
│   │    MYAPP     │ ❌ Still TIGHTLY coupled!                │
│   │              │                                          │
│   │ new Gun()    │ ◄── This is the problem!                 │
│   │ new Sword()  │     Somewhere we MUST specify            │
│   │              │     which implementation to use!         │
│   └──────────────┘                                          │
│                                                              │
│  Even though Soldier is loosely coupled, SOMEWHERE in the   │
│  application we still need to create the specific object!   │
│                                                              │
│  This is where SPRING's DEPENDENCY INJECTION comes in!      │
└─────────────────────────────────────────────────────────────┘
```

> **The Question**: So what's special about Spring's loose coupling? We've already achieved loose coupling without Spring!

### The Answer

Even though we removed tight coupling from the `Soldier` class, it still exists somewhere in our application (in `MyApp`). **Somewhere, we must specify which specific type we want to use (Gun, Sword, etc.)**.

**Spring's Solution**: Move this decision **OUTSIDE** the Java code entirely - into a **configuration file (XML or annotations)**!

---

## 6. Dependency Injection - The Solution

### What is Dependency Injection?

**Dependency Injection (DI)** is a design pattern where:
- Objects receive their dependencies from an **external source**
- Rather than creating them internally (using `new`)
- The **IOC Container** injects dependencies at runtime

### How Spring Solves the Problem Completely

```
┌─────────────────────────────────────────────────────────────┐
│              SPRING DEPENDENCY INJECTION                     │
│                                                              │
│   ┌───────────────────────────────────────────────────┐     │
│   │         CONFIGURATION FILE (beans.xml)             │     │
│   │                                                    │     │
│   │  <bean id="weapon" class="mypack.Gun"/>           │     │
│   │  <!-- OR -->                                       │     │
│   │  <bean id="weapon" class="mypack.Sword"/>         │     │
│   │                                                    │     │
│   │  <bean id="soldier" class="mypack.Soldier">       │     │
│   │      <property name="weapon" ref="weapon"/>       │     │
│   │  </bean>                                           │     │
│   └───────────────────────────────────────────────────┘     │
│                         │                                    │
│                         ▼                                    │
│   ┌───────────────────────────────────────────────────┐     │
│   │              IOC CONTAINER                         │     │
│   │                                                    │     │
│   │  1. Reads configuration                           │     │
│   │  2. Creates objects (beans)                       │     │
│   │  3. INJECTS dependencies automatically!           │     │
│   └───────────────────────────────────────────────────┘     │
│                         │                                    │
│                         ▼                                    │
│   ┌───────────────────────────────────────────────────┐     │
│   │              READY-TO-USE OBJECTS                  │     │
│   │                                                    │     │
│   │  Soldier with Weapon already injected!            │     │
│   │  NO "new" keyword in Java code!                   │     │
│   │  ✅ 100% Loosely Coupled!                         │     │
│   └───────────────────────────────────────────────────┘     │
│                                                              │
│  To change from Gun to Sword:                                │
│  Just change XML! No Java code modification needed!          │
└─────────────────────────────────────────────────────────────┘
```

### The Key Advantage

```
┌─────────────────────────────────────────────────────────────┐
│            WITHOUT SPRING vs WITH SPRING                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WITHOUT SPRING:                                             │
│  ┌────────────────────────────────────────┐                 │
│  │  Java Code                              │                 │
│  │  ─────────                             │                 │
│  │  Soldier s = new Soldier();            │                 │
│  │  s.perform(new Gun()); ◄── Change here │                 │
│  │                                         │                 │
│  │  To use Sword: MODIFY JAVA CODE        │                 │
│  │  Recompile, Redeploy!                  │                 │
│  └────────────────────────────────────────┘                 │
│                                                              │
│  WITH SPRING:                                                │
│  ┌────────────────────────────────────────┐                 │
│  │  Java Code                              │                 │
│  │  ─────────                             │                 │
│  │  // Just ask container for soldier     │                 │
│  │  Soldier s = container.getBean("soldier"); │             │
│  │  s.perform();  // Weapon already injected! │             │
│  │                                         │                 │
│  │  To use Sword: ONLY MODIFY XML FILE    │                 │
│  │  No Java code changes needed!          │                 │
│  └────────────────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Types of Dependency Injection

Spring supports three types of Dependency Injection:

### 7.1 Constructor Injection

Dependencies are provided through the class constructor:

```java
// Soldier receives Weapon through constructor
class Soldier
{
    private Weapon ref;
    
    // Constructor injection - dependency provided via constructor
    Soldier(Weapon ref)
    {
        this.ref = ref;
    }
    
    void perform()
    {
        ref.attack();
    }
}
```

**Usage (Without Spring):**
```java
Soldier s1 = new Soldier(new Gun());  // Constructor injection
```

**XML Configuration (With Spring):**
```xml
<bean id="weapon" class="mypack.Gun"/>
<bean id="soldier" class="mypack.Soldier">
    <constructor-arg ref="weapon"/>
</bean>
```

### 7.2 Setter Injection

Dependencies are provided through setter methods:

```java
// Soldier receives Weapon through setter method
class Soldier
{
    private Weapon ref;
    
    // Setter injection - dependency provided via setter
    void setRef(Weapon ref)
    {
        this.ref = ref;
    }
    
    void perform()
    {
        ref.attack();
    }
}
```

**Usage (Without Spring):**
```java
Soldier s1 = new Soldier();
s1.setRef(new Sword());  // Setter injection
```

**XML Configuration (With Spring):**
```xml
<bean id="weapon" class="mypack.Sword"/>
<bean id="soldier" class="mypack.Soldier">
    <property name="ref" ref="weapon"/>
</bean>
```

### 7.3 Field Injection (Annotation-based)

Dependencies are injected directly into fields:

```java
class Soldier
{
    @Autowired  // Spring injects dependency directly
    private Weapon ref;
    
    void perform()
    {
        ref.attack();
    }
}
```

### Comparison Table

| Aspect | Constructor Injection | Setter Injection | Field Injection |
|--------|----------------------|------------------|-----------------|
| **XML Tag** | `<constructor-arg>` | `<property>` | N/A (annotation) |
| **Annotation** | `@Autowired` on constructor | `@Autowired` on setter | `@Autowired` on field |
| **Mandatory Dependencies** | ✅ Best choice | Works | Works |
| **Optional Dependencies** | Works | ✅ Best choice | Works |
| **Immutability** | ✅ Supports final fields | ❌ Cannot use final | ❌ Cannot use final |
| **Testing** | ✅ Easy | ✅ Easy | ❌ Harder |

---

## 8. Complete Code Examples

### Example: Complete Spring DI Implementation

**File: Weapon.java**
```java
package mypack;

// Line 1-4: Interface defining the contract for all weapons
public interface Weapon
{
    void attack();
}
```

**File: Gun.java**
```java
package mypack;

// Line 1-8: Gun implementation
public class Gun implements Weapon
{
    // Line 4-7: attack method implementation for Gun
    @Override
    public void attack()
    {
        System.out.println("Attacking with Gun! 🔫");
    }
}
```

**File: Sword.java**
```java
package mypack;

// Line 1-8: Sword implementation
public class Sword implements Weapon
{
    // Line 4-7: attack method implementation for Sword
    @Override
    public void attack()
    {
        System.out.println("Attacking with Sword! ⚔️");
    }
}
```

**File: Soldier.java (Spring-ready)**
```java
package mypack;

// Line 1-20: Soldier class ready for Spring DI
public class Soldier
{
    // Line 5: Dependency - will be injected by Spring
    private Weapon weapon;
    
    // Line 8-11: No-arg constructor (required for setter injection)
    public Soldier()
    {
        System.out.println("Soldier created!");
    }
    
    // Line 14-18: Setter for dependency injection
    public void setWeapon(Weapon weapon)
    {
        System.out.println("Weapon injected via setter!");
        this.weapon = weapon;
    }
    
    // Line 21-24: Business method using injected dependency
    public void perform()
    {
        weapon.attack();
    }
}
```

**File: beans.xml (Spring Configuration)**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Line 1: XML declaration -->

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-4.0.xsd">
<!-- Line 3-6: Spring namespace declarations -->

    <!-- Line 9: Define the weapon bean - Gun implementation -->
    <!-- Change to "mypack.Sword" to use Sword instead! -->
    <bean id="weapon" class="mypack.Gun"/>
    
    <!-- Line 12-15: Define soldier bean with setter injection -->
    <bean id="soldier" class="mypack.Soldier">
        <!-- Line 14: Inject weapon into soldier -->
        <!-- name="weapon" means call setWeapon() method -->
        <!-- ref="weapon" means inject the bean with id="weapon" -->
        <property name="weapon" ref="weapon"/>
    </bean>

</beans>
```

**File: Main.java**
```java
package mypack;

import org.springframework.context.support.ClassPathXmlApplicationContext;

// Line 1-18: Main application demonstrating DI
public class Main
{
    public static void main(String[] args)
    {
        // Line 9-10: Create IOC Container and load configuration
        // The container reads beans.xml and creates all beans
        ClassPathXmlApplicationContext container = 
            new ClassPathXmlApplicationContext("beans.xml");
        
        // Line 13: Get the soldier bean from container
        // Weapon is ALREADY INJECTED by the container!
        Soldier soldier = (Soldier) container.getBean("soldier");
        
        // Line 16: Use the soldier - weapon is already available!
        soldier.perform();
        
        // Line 19: Close the container (good practice)
        container.close();
    }
}
```

---

## 9. Execution Flow

### Step-by-Step Execution

```
┌─────────────────────────────────────────────────────────────┐
│                    EXECUTION FLOW                            │
│                                                              │
│  STEP 1: Application starts                                  │
│  ────────────────────────────                               │
│  ClassPathXmlApplicationContext container =                  │
│      new ClassPathXmlApplicationContext("beans.xml");        │
│                                                              │
│  STEP 2: Container reads beans.xml                           │
│  ────────────────────────────────                           │
│  Container finds:                                            │
│  - <bean id="weapon" class="mypack.Gun"/>                   │
│  - <bean id="soldier" class="mypack.Soldier">               │
│        <property name="weapon" ref="weapon"/>               │
│    </bean>                                                   │
│                                                              │
│  STEP 3: Container creates beans (Eager by default)          │
│  ─────────────────────────────────────────────              │
│  1. Creates Gun object: new Gun()                            │
│  2. Creates Soldier object: new Soldier()                    │
│     Output: "Soldier created!"                               │
│                                                              │
│  STEP 4: Container injects dependencies                      │
│  ───────────────────────────────────────                    │
│  Calls soldier.setWeapon(gun);                               │
│  Output: "Weapon injected via setter!"                       │
│                                                              │
│  STEP 5: Application gets bean                               │
│  ─────────────────────────────                              │
│  Soldier soldier = container.getBean("soldier");             │
│  (Returns the SAME soldier object that was created earlier)  │
│                                                              │
│  STEP 6: Application uses bean                               │
│  ─────────────────────────────                              │
│  soldier.perform();                                          │
│  Output: "Attacking with Gun! 🔫"                            │
└─────────────────────────────────────────────────────────────┘
```

### Console Output

```
Soldier created!
Weapon injected via setter!
Attacking with Gun! 🔫
```

### Changing Implementation (The Power of DI!)

To change from Gun to Sword, **ONLY** modify beans.xml:

```xml
<!-- Before: Using Gun -->
<bean id="weapon" class="mypack.Gun"/>

<!-- After: Using Sword -->
<bean id="weapon" class="mypack.Sword"/>
```

**No Java code changes needed!** Just change the XML and restart.

---

## 10. Common Interview Questions

### Q1: What is tight coupling? Give an example.
**A:** Tight coupling occurs when a class directly depends on a specific implementation rather than an interface. Example: `Gun g = new Gun();` inside a Soldier class makes Soldier tightly coupled to Gun.

### Q2: How does Spring achieve loose coupling?
**A:** Spring achieves loose coupling through:
1. **Interface-based programming** - depend on interfaces, not implementations
2. **Dependency Injection** - container injects dependencies
3. **External configuration** - specify implementations in XML/annotations, not in Java code

### Q3: What are the types of Dependency Injection?
**A:** Three types:
1. **Constructor Injection** - through constructor (`<constructor-arg>`)
2. **Setter Injection** - through setter methods (`<property>`)
3. **Field Injection** - through annotations on fields (`@Autowired`)

### Q4: Without Spring, can we achieve loose coupling?
**A:** Yes, but not completely. We can use interface-based programming to decouple classes, but somewhere in the application we still need to instantiate specific implementations. Spring moves this decision entirely outside Java code into configuration files.

### Q5: Which injection type should I use?
**A:** 
- **Constructor Injection**: Mandatory dependencies, immutable objects
- **Setter Injection**: Optional dependencies, mutable objects
- **Field Injection**: Quick development (not recommended for production)

---

## 11. Key Takeaways

📌 **Tight Coupling** = Direct dependency on specific implementation (`new Gun()`)

📌 **Loose Coupling** = Dependency on interface (`Weapon ref`)

📌 **Program to Interface** = Depend on abstractions, not concrete classes

📌 **Even with interfaces**, tight coupling exists somewhere in traditional code

📌 **Spring's DI** moves implementation decisions to external configuration

📌 **IOC Container** creates objects and injects dependencies automatically

📌 **Three injection types**: Constructor, Setter, Field

📌 **Main advantage**: Change implementations without modifying Java code

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│                  COUPLING QUICK REFERENCE                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  TIGHT COUPLING:                                             │
│  ❌ Gun g = new Gun();  // Direct dependency                │
│                                                              │
│  LOOSE COUPLING (without Spring):                            │
│  ✓ void perform(Weapon ref) {ref.attack();}                 │
│    But: s.perform(new Gun()); // Still coupled in main()    │
│                                                              │
│  LOOSE COUPLING (with Spring):                               │
│  ✅ Everything externalized to XML/annotations              │
│  ✅ No "new" keyword for dependencies in Java code          │
│  ✅ Change implementation by changing config only!          │
│                                                              │
│  INJECTION TYPES:                                            │
│  1. Constructor: <constructor-arg ref="..."/>               │
│  2. Setter:      <property name="..." ref="..."/>           │
│  3. Field:       @Autowired on the field                    │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [01. Introduction to Spring Framework](./01_Introduction_to_Spring_Framework.md)*

*Next: [03. IOC Container Fundamentals](./03_IOC_Container_Fundamentals.md)*
