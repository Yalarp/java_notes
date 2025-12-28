# Spring Interview Questions - Complete Reference

## Table of Contents
1. [Spring Core & IoC](#1-spring-core--ioc)
2. [Dependency Injection](#2-dependency-injection)
3. [Bean Scopes & Lifecycle](#3-bean-scopes--lifecycle)
4. [Annotations](#4-annotations)
5. [Spring AOP](#5-spring-aop)
6. [Spring Templates](#6-spring-templates)
7. [Design Patterns in Spring](#7-design-patterns-in-spring)
8. [SOLID Principles](#8-solid-principles)
9. [Scenario-Based Questions](#9-scenario-based-questions)
10. [Quick Revision Table](#10-quick-revision-table)

---

## 1. Spring Core & IoC

### Q1.1: What is Spring Framework?
**Answer:** Spring is a lightweight, open-source framework for building enterprise Java applications. It provides comprehensive infrastructure support including:
- Dependency Injection
- Aspect-Oriented Programming
- Transaction Management
- MVC Framework
- Data Access Integration

### Q1.2: What is IoC (Inversion of Control)?
**Answer:** IoC is a design principle where the control of object creation and lifecycle is transferred from the application to a container/framework.

**Traditional approach:** Objects create their dependencies
**IoC approach:** Dependencies are injected by the container

```java
// Traditional (No IoC)
class Service {
    private Repository repo = new Repository();  // Creates its own dependency
}

// With IoC
class Service {
    private Repository repo;  // Dependency injected by Spring
    public Service(Repository repo) { this.repo = repo; }
}
```

### Q1.3: What is IoC Container?
**Answer:** The IoC container is the core of Spring Framework. It creates objects, wires them together, configures them, and manages their lifecycle.

| Container Type | Interface | Description |
|----------------|-----------|-------------|
| BeanFactory | `BeanFactory` | Basic container, lazy initialization |
| ApplicationContext | `ApplicationContext` | Advanced, eager initialization, i18n, events |

```java
ApplicationContext ctx = new ClassPathXmlApplicationContext("beans.xml");
ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
```

### Q1.4: Difference between BeanFactory and ApplicationContext?

| Feature | BeanFactory | ApplicationContext |
|---------|-------------|-------------------|
| Bean Loading | Lazy | Eager (pre-instantiates) |
| AOP Support | Partial | Full |
| i18n | No | Yes |
| Event Publishing | No | Yes |
| Environment Properties | No | Yes |
| Annotation Support | Limited | Full |

**Use:** ApplicationContext for most applications, BeanFactory for memory-constrained environments.

### Q1.5: What are the advantages of Spring?

1. **Lightweight** - Non-intrusive, POJOs
2. **Loose Coupling** - Dependency Injection
3. **Declarative** - Annotations, XML
4. **Modular** - Use only what you need
5. **Testable** - Easy unit testing
6. **Transaction Management** - Declarative @Transactional
7. **Exception Handling** - Consistent exception hierarchy

---

## 2. Dependency Injection

### Q2.1: What is Dependency Injection?
**Answer:** DI is a design pattern where dependencies are "injected" into a class from outside rather than created inside. Spring container injects dependencies at runtime.

### Q2.2: Types of Dependency Injection?

| Type | Annotation/XML | When to Use |
|------|----------------|-------------|
| Constructor | `<constructor-arg>` / `@Autowired` on constructor | Mandatory dependencies |
| Setter | `<property>` / `@Autowired` on setter | Optional dependencies |
| Field | `@Autowired` on field | Quick prototyping (avoid in production) |

```java
// Constructor Injection (Recommended)
@Service
public class OrderService {
    private final PaymentService paymentService;
    
    @Autowired
    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;  // Immutable, testable
    }
}

// Setter Injection
@Service
public class OrderService {
    private PaymentService paymentService;
    
    @Autowired
    public void setPaymentService(PaymentService ps) {
        this.paymentService = ps;
    }
}

// Field Injection (Not recommended)
@Service
public class OrderService {
    @Autowired
    private PaymentService paymentService;  // Hard to test
}
```

### Q2.3: Why is Constructor Injection preferred?

1. **Immutability** - Dependencies can be final
2. **Required Dependencies** - Fails fast if missing
3. **Testability** - Easy to mock in tests
4. **Circular Dependency** - Detected at compile time
5. **Design Clarity** - All dependencies visible in constructor

### Q2.4: What is Autowiring?
**Answer:** Autowiring is Spring's automatic dependency injection. Spring resolves and injects dependencies automatically.

| Mode | Description |
|------|-------------|
| `no` | Default, no autowiring |
| `byName` | Match by bean name |
| `byType` | Match by bean type |
| `constructor` | Match constructor arguments by type |

### Q2.5: How to resolve ambiguity in @Autowired?
**Answer:** Use `@Qualifier` to specify which bean to inject:

```java
@Autowired
@Qualifier("masterDataSource")
private DataSource dataSource;
```

Or use `@Primary` on the default bean:

```java
@Bean
@Primary
public DataSource primaryDataSource() { ... }
```

---

## 3. Bean Scopes & Lifecycle

### Q3.1: What are Bean Scopes?

| Scope | Description | Use Case |
|-------|-------------|----------|
| `singleton` | One instance per container (default) | Stateless beans |
| `prototype` | New instance per request | Stateful beans |
| `request` | One per HTTP request | Web app request data |
| `session` | One per HTTP session | User session data |
| `application` | One per ServletContext | App-wide shared state |

```java
@Component
@Scope("prototype")
public class ShoppingCart { ... }
```

### Q3.2: Default Bean Scope?
**Answer:** `singleton` - Spring creates one instance per container.

### Q3.3: Difference between Singleton and Prototype?

| Aspect | Singleton | Prototype |
|--------|-----------|-----------|
| Instances | One per container | New per getBean() |
| Lifecycle | Container managed | Client managed |
| Stateful | Avoid (shared state) | Safe |
| @PreDestroy | Called | Not called |

### Q3.4: What is Bean Lifecycle?

```
┌─────────────────────────────────────────────────────────────┐
│                    BEAN LIFECYCLE                            │
│                                                              │
│  1. Instantiation (new Bean())                              │
│       ↓                                                      │
│  2. Populate Properties (set dependencies)                  │
│       ↓                                                      │
│  3. BeanNameAware.setBeanName()                             │
│       ↓                                                      │
│  4. BeanFactoryAware.setBeanFactory()                       │
│       ↓                                                      │
│  5. ApplicationContextAware.setApplicationContext()         │
│       ↓                                                      │
│  6. @PostConstruct / init-method                            │
│       ↓                                                      │
│  7. Bean Ready for Use                                      │
│       ↓                                                      │
│  8. Container Shutdown                                      │
│       ↓                                                      │
│  9. @PreDestroy / destroy-method                            │
└─────────────────────────────────────────────────────────────┘
```

### Q3.5: @PostConstruct vs init-method?

| Feature | @PostConstruct | init-method |
|---------|----------------|-------------|
| Definition | Annotation on method | XML attribute |
| Standard | JSR-250 | Spring-specific |
| Location | In class | In configuration |

---

## 4. Annotations

### Q4.1: Explain Stereotype Annotations

| Annotation | Layer | Purpose |
|------------|-------|---------|
| `@Component` | Generic | General Spring-managed bean |
| `@Controller` | Web | MVC controller, handles HTTP |
| `@Service` | Business | Business logic |
| `@Repository` | Data | Data access, exception translation |

```
┌─────────────────────────────────────────────────────────────┐
│                LAYERED ARCHITECTURE                          │
│                                                              │
│   @Controller → Web Layer (handles requests)                │
│        ↓                                                     │
│   @Service → Business Layer (business logic)                │
│        ↓                                                     │
│   @Repository → Data Layer (database access)                │
│                                                              │
│   All are specializations of @Component                     │
└─────────────────────────────────────────────────────────────┘
```

### Q4.2: @Component vs @Bean?

| Aspect | @Component | @Bean |
|--------|------------|-------|
| Level | Class | Method |
| Scan | Auto-detected | Explicit in @Configuration |
| Control | Limited | Full (third-party classes) |

```java
// @Component - auto-detected
@Component
public class MyService { }

// @Bean - explicit, more control
@Configuration
public class AppConfig {
    @Bean
    public ThirdPartyService thirdPartyService() {
        return new ThirdPartyService(config);
    }
}
```

### Q4.3: What is @Configuration?
**Answer:** Marks a class as source of bean definitions. @Bean methods inside create Spring-managed beans.

```java
@Configuration
public class AppConfig {
    @Bean
    public DataSource dataSource() { ... }
    
    @Bean
    public JdbcTemplate jdbcTemplate() {
        return new JdbcTemplate(dataSource());
    }
}
```

### Q4.4: What is @Value?
**Answer:** Injects property values into fields.

```java
@Value("${database.url}")
private String dbUrl;

@Value("#{systemProperties['user.name']}")
private String userName;

@Value("Default Value")
private String defaultValue;
```

### Q4.5: @Autowired vs @Resource vs @Inject?

| Feature | @Autowired | @Resource | @Inject |
|---------|------------|-----------|---------|
| Standard | Spring | JSR-250 | JSR-330 |
| Match By | Type first | Name first | Type first |
| Required | Optional attr | N/A | N/A |

---

## 5. Spring AOP

### Q5.1: What is AOP?
**Answer:** Aspect-Oriented Programming separates cross-cutting concerns (logging, security, transactions) from business logic. It allows adding behavior without modifying code.

### Q5.2: Key AOP Terms?

| Term | Description |
|------|-------------|
| **Aspect** | Class containing advice (cross-cutting logic) |
| **Join Point** | Point in execution (method call, exception) |
| **Advice** | Action taken at join point |
| **Pointcut** | Expression matching join points |
| **Weaving** | Linking aspects with target objects |

### Q5.3: Types of Advice?

| Advice | When Executed |
|--------|---------------|
| `@Before` | Before method |
| `@AfterReturning` | After successful return |
| `@AfterThrowing` | After exception |
| `@After` | Always (finally) |
| `@Around` | Before and after (most powerful) |

```java
@Aspect
@Component
public class LoggingAspect {
    
    @Before("execution(* com.example.service.*.*(..))")
    public void logBefore(JoinPoint jp) {
        System.out.println("Before: " + jp.getSignature());
    }
    
    @Around("execution(* com.example.service.*.*(..))")
    public Object logAround(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = pjp.proceed();
        long duration = System.currentTimeMillis() - start;
        System.out.println("Method took: " + duration + "ms");
        return result;
    }
}
```

### Q5.4: What is Pointcut expression?
**Answer:** Expression that matches join points.

```
execution(modifiers? return-type declaring-type? method-name(params) throws?)

Examples:
execution(* com.example.*.*(..))       - All methods in package
execution(public * *(..))              - All public methods
execution(* save*(..))                 - Methods starting with 'save'
```

### Q5.5: Difference between Spring AOP and AspectJ?

| Feature | Spring AOP | AspectJ |
|---------|------------|---------|
| Weaving | Runtime (proxy) | Compile/Load time |
| Join Points | Method execution only | Methods, fields, constructors |
| Complexity | Simpler | More powerful |
| Performance | Slight overhead | Better performance |

---

## 6. Spring Templates

### Q6.1: What is JdbcTemplate?
**Answer:** Spring's helper class that simplifies JDBC operations by:
- Handling connection management
- Converting SQLException to DataAccessException
- Reducing boilerplate code

```java
// Traditional JDBC: 25+ lines
// JdbcTemplate: 2 lines
User user = jdbcTemplate.queryForObject(
    "SELECT * FROM users WHERE id = ?",
    new BeanPropertyRowMapper<>(User.class), id);
```

### Q6.2: What is NamedParameterJdbcTemplate?
**Answer:** Extension of JdbcTemplate using named parameters instead of `?`.

```java
String sql = "SELECT * FROM users WHERE name = :name AND age = :age";
MapSqlParameterSource params = new MapSqlParameterSource()
    .addValue("name", "John")
    .addValue("age", 25);
return namedTemplate.query(sql, params, rowMapper);
```

### Q6.3: RowMapper vs ResultSetExtractor?

| Feature | RowMapper | ResultSetExtractor |
|---------|-----------|-------------------|
| Called | Once per row | Once for entire ResultSet |
| Returns | Single object | Any structure |
| Use | Simple mapping | Complex aggregations |

### Q6.4: What is HibernateTemplate?
**Answer:** Spring's wrapper around Hibernate (deprecated since Spring 3.1). Modern approach: Use SessionFactory with @Transactional directly.

---

## 7. Design Patterns in Spring

### Q7.1: Design Patterns used in Spring?

| Pattern | Usage in Spring |
|---------|-----------------|
| **Singleton** | Default bean scope |
| **Factory** | BeanFactory, ApplicationContext |
| **Proxy** | AOP, @Transactional |
| **Template Method** | JdbcTemplate, RestTemplate |
| **Observer** | ApplicationEvents |
| **Strategy** | Various interfaces with implementations |
| **Dependency Injection** | Core IoC container |

### Q7.2: How does Spring implement Singleton?
**Answer:** Unlike traditional singleton (private constructor), Spring singleton means one instance per container, managed by the IoC container.

### Q7.3: What is Proxy Pattern in Spring?
**Answer:** Spring creates proxy objects for AOP and @Transactional. Two types:
- JDK Dynamic Proxy (interface-based)
- CGLIB Proxy (class-based)

---

## 8. SOLID Principles

### Q8.1: What is SOLID and how does Spring implement it?

| Principle | Description | Spring Implementation |
|-----------|-------------|----------------------|
| **S**RP | One class, one responsibility | @Controller, @Service, @Repository |
| **O**CP | Open for extension, closed for modification | Plugins, Events, Listeners |
| **L**SP | Subtypes substitutable for base types | Interface-based programming |
| **I**SP | Small focused interfaces | CrudRepository, PagingRepository |
| **D**IP | Depend on abstractions | @Autowired, Dependency Injection |

### Q8.2: How does @Autowired implement DIP?
**Answer:** @Autowired injects dependencies based on interfaces, not concrete classes. High-level modules depend on abstractions, and Spring provides concrete implementations at runtime.

---

## 9. Scenario-Based Questions

### Q9.1: How to handle circular dependencies?
**Answer:**
1. Use setter injection instead of constructor injection
2. Use `@Lazy` annotation
3. Refactor design to break the cycle
4. Use `@PostConstruct` for initialization

```java
@Component
public class A {
    @Autowired @Lazy
    private B b;
}
```

### Q9.2: How to create bean from third-party class?
**Answer:** Use @Bean in @Configuration:

```java
@Configuration
public class Config {
    @Bean
    public ThirdPartyClass thirdPartyBean() {
        return new ThirdPartyClass();
    }
}
```

### Q9.3: How to read properties file?
**Answer:**
```java
@PropertySource("classpath:application.properties")
@Configuration
public class Config {
    @Value("${db.url}")
    private String dbUrl;
}
```

### Q9.4: How to handle bean initialization order?
**Answer:** Use `@DependsOn`:

```java
@Bean
@DependsOn("dataSource")
public JdbcTemplate jdbcTemplate() {
    return new JdbcTemplate(dataSource());
}
```

### Q9.5: What happens if two beans have same name?
**Answer:** Last registered bean wins (XML > Annotation). Use @Qualifier to distinguish.

---

## 10. Quick Revision Table

| Topic | Key Points |
|-------|------------|
| **IoC** | Inversion of Control, container manages objects |
| **DI** | Constructor (preferred), Setter, Field injection |
| **Bean Scopes** | singleton (default), prototype, request, session |
| **@Autowired** | Auto-inject by type, use @Qualifier for ambiguity |
| **@Component** | Auto-detected bean, specializations: @Controller, @Service, @Repository |
| **@Bean** | Explicit method-level bean creation in @Configuration |
| **AOP** | Cross-cutting concerns, @Aspect, @Before/@After/@Around |
| **Pointcut** | `execution(* package.*.*(..))`  |
| **JdbcTemplate** | Simplifies JDBC, converts SQLException |
| **Proxy** | JDK (interface), CGLIB (class) |
| **SOLID** | Design principles, Spring implements DIP via DI |

---

## Interview Preparation Checklist

- [ ] Core: IoC, DI, Bean scopes, Lifecycle
- [ ] Annotations: @Component family, @Autowired, @Bean, @Value
- [ ] AOP: Concepts, Advice types, Pointcut expressions
- [ ] Templates: JdbcTemplate, NamedParameterJdbcTemplate
- [ ] Patterns: Singleton, Factory, Proxy, Observer
- [ ] SOLID: All five principles with examples

---

## Quick Formula Sheet

```
┌─────────────────────────────────────────────────────────────┐
│              SPRING INTERVIEW FORMULAS                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  IoC = Inversion of Control (Container creates objects)    │
│  DI = Dependency Injection (Container injects dependencies)│
│  AOP = Aspect-Oriented Programming (Cross-cutting concerns)│
│                                                              │
│  Bean Scopes: singleton > prototype > request > session    │
│                                                              │
│  Annotation Layers:                                          │
│  @Controller → @Service → @Repository (all are @Component) │
│                                                              │
│  AOP Advice Order:                                           │
│  @Around(before) → @Before → Method →                       │
│  @AfterReturning/@AfterThrowing → @After → @Around(after)  │
│                                                              │
│  DI Preference:                                              │
│  Constructor > Setter > Field                               │
│                                                              │
│  Proxy Types:                                                │
│  JDK = interface-based | CGLIB = class-based                │
│                                                              │
│  Exception Translation:                                      │
│  SQLException → DataAccessException (unchecked)             │
│                                                              │
│  SOLID in Spring:                                            │
│  SRP = Layer separation                                      │
│  OCP = Events & Listeners                                   │
│  LSP = Interface-based                                       │
│  ISP = Fine-grained interfaces                              │
│  DIP = @Autowired                                           │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [18. SOLID Design Principles](./18_SOLID_Design_Principles.md)*

---

**Good luck with your interview! 🚀**
