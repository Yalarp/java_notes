# Spring Interview Questions - Complete Reference

## Table of Contents
1. [Spring Core Questions](#1-spring-core-questions)
2. [IOC and Dependency Injection](#2-ioc-and-dependency-injection)
3. [Bean Scopes and Lifecycle](#3-bean-scopes-and-lifecycle)
4. [Spring AOP Questions](#4-spring-aop-questions)
5. [Spring Templates Questions](#5-spring-templates-questions)
6. [Design Patterns Questions](#6-design-patterns-questions)
7. [Quick Revision Table](#7-quick-revision-table)

---

## 1. Spring Core Questions

### Q1: What is Spring Framework?
**A:** Spring is a lightweight, open-source Java application framework that provides comprehensive infrastructure support. It was developed by Rod Johnson and released in 2003/2005. Key features include:
- Dependency Injection (DI)
- Aspect-Oriented Programming (AOP)
- Transaction Management
- MVC Framework
- Data Access Support

### Q2: Why is Spring called lightweight?
**A:** Because the IOC container is just a Java class (like `ClassPathXmlApplicationContext`), not a heavy application server. It starts quickly with minimal memory overhead.

### Q3: What is the difference between Framework and Library?
**A:** 
| Framework | Library |
|-----------|---------|
| Framework calls YOUR code | YOU call library code |
| Inversion of Control | Direct control |
| Defines application structure | Just provides utilities |
| Example: Spring | Example: Apache Commons |

### Q4: What are the modules of Spring Framework?
**A:** Spring Core, Spring AOP, Spring Data, Spring MVC, Spring Security, Spring Boot, Spring Cloud

---

## 2. IOC and Dependency Injection

### Q5: What is IOC (Inversion of Control)?
**A:** IOC means the control of object creation and dependency management is transferred from application code to the Spring container. Instead of `new Object()`, the container creates and manages objects.

### Q6: What is Dependency Injection?
**A:** DI is a design pattern where dependencies are "injected" into a class from outside rather than created internally. Spring supports three types:
1. **Constructor Injection** - via constructor
2. **Setter Injection** - via setter methods
3. **Field Injection** - via @Autowired on fields

### Q7: What is the difference between BeanFactory and ApplicationContext?
**A:**
| BeanFactory | ApplicationContext |
|-------------|-------------------|
| Basic DI only | Full Spring features |
| Lazy loading | Eager loading (default) |
| Lightweight | More features |
| Deprecated | Recommended |

### Q8: What is autowiring? What are the modes?
**A:** Autowiring is automatic dependency injection without explicit configuration. Modes:
- `no` - Default, no autowiring
- `byName` - Match bean ID with property name
- `byType` - Match bean class with property type
- `constructor` - byType for constructor args

### Q9: What is @Component?
**A:** @Component marks a class as a Spring-managed bean. When component scanning is enabled, Spring automatically detects and registers these classes.

### Q10: What is @Autowired?
**A:** @Autowired automatically injects dependencies by type. Can be used on fields, setters, or constructors.

### Q11: What is @Qualifier?
**A:** @Qualifier is used with @Autowired to specify which bean to inject when multiple beans of the same type exist.

### Q12: What is @Configuration and @Bean?
**A:** 
- `@Configuration` marks a class as a source of bean definitions (like XML config file)
- `@Bean` on a method indicates the return value is a Spring bean

---

## 3. Bean Scopes and Lifecycle

### Q13: What are the bean scopes in Spring?
**A:**
1. **singleton** (default) - One instance per container
2. **prototype** - New instance every request
3. **request** - One per HTTP request (web)
4. **session** - One per HTTP session (web)
5. **global-session** - One per global session (portlet)

### Q14: What is the difference between singleton and prototype?
**A:**
| Singleton | Prototype |
|-----------|-----------|
| One instance | New instance each time |
| Default scope | Must specify explicitly |
| Eager loading | Lazy loading |
| Same hashcode | Different hashcode |

### Q15: What is the difference between eager and lazy loading?
**A:**
| Eager (Default) | Lazy |
|-----------------|------|
| Created at startup | Created on first request |
| Errors detected early | Errors detected late |
| `lazy-init="false"` | `lazy-init="true"` |

### Q16: What is the bean lifecycle?
**A:** 
1. Instantiation (constructor)
2. Populate properties (DI)
3. BeanNameAware, BeanFactoryAware
4. BeanPostProcessor (before)
5. @PostConstruct / init-method
6. BeanPostProcessor (after)
7. Bean ready
8. @PreDestroy / destroy-method

---

## 4. Spring AOP Questions

### Q17: What is AOP?
**A:** Aspect-Oriented Programming separates cross-cutting concerns (logging, security, transactions) from business logic by encapsulating them in modules called Aspects.

### Q18: What are cross-cutting concerns?
**A:** Functionalities that cut across multiple modules: logging, security, transaction management, caching, exception handling.

### Q19: What is an Aspect?
**A:** A module containing cross-cutting concern code. Defined with @Aspect annotation.

### Q20: What is a Pointcut?
**A:** An expression that selects which join points (methods) to apply advice to.
Example: `execution(* mypack.*Service.*(..))`

### Q21: What are the types of Advice?
**A:**
1. **@Before** - Before method
2. **@AfterReturning** - After successful return
3. **@AfterThrowing** - After exception
4. **@After** - After method (finally)
5. **@Around** - Wraps entire method

### Q22: What is Weaving?
**A:** The process of applying aspects to target objects to create proxied objects. Spring uses runtime weaving.

### Q23: What is the difference between JoinPoint and ProceedingJoinPoint?
**A:** 
- `JoinPoint` - Used in all advice except @Around
- `ProceedingJoinPoint` - Used only in @Around, has `proceed()` method

---

## 5. Spring Templates Questions

### Q24: What is JdbcTemplate?
**A:** A Spring class that simplifies JDBC operations by eliminating boilerplate code for connection management, exception handling, and resource cleanup.

### Q25: What is the advantage of using templates?
**A:**
1. **Boilerplate reduction** - No manual connection/statement management
2. **Exception translation** - Converts SQLException to DataAccessException

### Q26: What is RowMapper?
**A:** An interface that converts each row of ResultSet to a Java object. `BeanPropertyRowMapper` provides automatic mapping.

### Q27: What is the difference between JdbcTemplate and NamedParameterJdbcTemplate?
**A:**
- `JdbcTemplate` - Uses `?` placeholders
- `NamedParameterJdbcTemplate` - Uses named parameters like `:name`

---

## 6. Design Patterns Questions

### Q28: What is Observer Pattern?
**A:** Defines a one-to-many dependency. When subject changes, all observers are notified. Spring uses it in ApplicationEvent.

### Q29: What is Chain of Responsibility?
**A:** Passes request along a chain of handlers. Each handler decides to process or pass to next. Used in Spring Security filters.

### Q30: What are SOLID principles?
**A:**
- **S** - Single Responsibility
- **O** - Open/Closed
- **L** - Liskov Substitution
- **I** - Interface Segregation
- **D** - Dependency Inversion

### Q31: Which design patterns does Spring use?
**A:**
- **Singleton** - Default bean scope
- **Factory** - BeanFactory
- **Proxy** - AOP
- **Template Method** - JdbcTemplate
- **Observer** - Events

---

## 7. Quick Revision Table

| Topic | Key Points |
|-------|------------|
| **IOC** | Container manages objects, not you |
| **DI Types** | Constructor, Setter, Field |
| **Autowire Modes** | no, byName, byType, constructor |
| **Bean Scopes** | singleton (default), prototype, request, session |
| **Singleton vs Prototype** | One vs Many instances |
| **Eager vs Lazy** | Startup vs On-demand |
| **@Component** | Marks class as bean |
| **@Autowired** | Injects by type |
| **@Qualifier** | Resolves ambiguity |
| **@Configuration + @Bean** | Java-based config |
| **AOP** | Separates cross-cutting concerns |
| **Advice Types** | Before, After, Around, etc. |
| **Pointcut** | Where to apply advice |
| **JdbcTemplate** | Simplifies JDBC |
| **Observer Pattern** | One-to-many notification |
| **Chain of Responsibility** | Sequential handlers |
| **SOLID** | Design principles |

---

## Quick Memory Tips

```
┌─────────────────────────────────────────────────────────────┐
│                 MEMORY TIPS                                  │
│                                                              │
│  IOC = "I Order Coffee" → Barista (container) makes it     │
│                                                              │
│  DI = "Delivery Injection" → Dependencies delivered to you │
│                                                              │
│  Singleton = "Single Tone" → Only ONE voice (instance)     │
│                                                              │
│  Prototype = "Proto Type" → New TYPE each time             │
│                                                              │
│  AOP = "Add On Programming" → Add behavior without modify  │
│                                                              │
│  SOLID = "Software Organized, Logically Ideally Designed"  │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [14. Design Patterns in Spring](./14_Design_Patterns_in_Spring.md)*

---

## Notes Index

1. [Introduction to Spring Framework](./01_Introduction_to_Spring_Framework.md)
2. [Coupling and Dependency Injection](./02_Coupling_and_Dependency_Injection.md)
3. [IOC Container Fundamentals](./03_IOC_Container_Fundamentals.md)
4. [Setter Injection Complete Guide](./04_Setter_Injection_Complete_Guide.md)
5. [Constructor Injection Deep Dive](./05_Constructor_Injection_Deep_Dive.md)
6. [Bean Scopes and Lifecycle](./06_Bean_Scopes_and_Lifecycle.md)
7. [Autowiring in Spring](./07_Autowiring_in_Spring.md)
8. [Component Scanning and Annotations](./08_Component_Scanning_and_Annotations.md)
9. [Java Configuration and Bean](./09_Java_Configuration_and_Bean.md)
10. [Introduction to AOP](./10_Introduction_to_AOP.md)
11. [XML-based AOP Configuration](./11_XML_Based_AOP_Configuration.md)
12. [Annotation-based AOP](./12_Annotation_Based_AOP.md)
13. [Spring Templates Overview](./13_Spring_Templates_Overview.md)
14. [Design Patterns in Spring](./14_Design_Patterns_in_Spring.md)
15. [Spring Interview Questions](./15_Spring_Interview_Questions.md) *(This File)*
