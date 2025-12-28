# HibernateTemplate Integration

## Table of Contents
1. [Introduction](#1-introduction)
2. [Understanding ORM and Hibernate](#2-understanding-orm-and-hibernate)
3. [HibernateTemplate Overview](#3-hibernatetemplate-overview)
4. [Spring + Hibernate Configuration](#4-spring--hibernate-configuration)
5. [HibernateTemplate CRUD Operations](#5-hibernatetemplate-crud-operations)
6. [Modern Approach (SessionFactory)](#6-modern-approach-sessionfactory)
7. [Complete Code Example](#7-complete-code-example)
8. [Entity Mapping](#8-entity-mapping)
9. [Transaction Management](#9-transaction-management)
10. [HibernateTemplate vs SessionFactory](#10-hibernatetemplate-vs-sessionfactory)
11. [Common Interview Questions](#11-common-interview-questions)
12. [Key Takeaways](#12-key-takeaways)

---

## 1. Introduction

**HibernateTemplate** is a Spring class that simplifies Hibernate ORM operations. However, it's **deprecated since Spring 3.1** in favor of direct `SessionFactory` usage.

> **Important**: This note covers both the legacy HibernateTemplate approach (for understanding older codebases) and the modern recommended approach.

### When to Use What

| Scenario | Recommendation |
|----------|----------------|
| New Spring projects | Use SessionFactory + @Transactional |
| Spring Boot projects | Use Spring Data JPA |
| Legacy Spring 2.x/3.x | May have HibernateTemplate |
| Interview questions | Know both approaches |

---

## 2. Understanding ORM and Hibernate

### What is ORM?

```
┌─────────────────────────────────────────────────────────────┐
│              Object-Relational Mapping (ORM)                 │
│                                                              │
│  OBJECT WORLD                   RELATIONAL WORLD             │
│  ┌─────────────────┐           ┌─────────────────┐          │
│  │   Java Object   │           │  Database Table  │          │
│  │                 │           │                  │          │
│  │  User user      │    ↔      │  users          │          │
│  │  - id           │    ↔      │  - id (PK)      │          │
│  │  - name         │    ↔      │  - name         │          │
│  │  - email        │    ↔      │  - email        │          │
│  └─────────────────┘           └─────────────────┘          │
│                                                              │
│  ORM automatically converts between objects and tables!     │
│                                                              │
│  Benefits:                                                   │
│  ✅ No SQL writing (usually)                                │
│  ✅ Database-independent                                    │
│  ✅ Object-oriented persistence                             │
│  ✅ Caching, lazy loading                                   │
└─────────────────────────────────────────────────────────────┘
```

### What is Hibernate?

Hibernate is the most popular Java ORM framework that:
- Maps Java objects to database tables
- Generates SQL automatically
- Handles caching, transactions, lazy loading
- Works with multiple databases

---

## 3. HibernateTemplate Overview

### What is HibernateTemplate?

HibernateTemplate was Spring's wrapper around Hibernate's Session API that:
- Simplified Hibernate operations
- Converted HibernateException to DataAccessException
- Managed Session lifecycle automatically

```
┌─────────────────────────────────────────────────────────────┐
│              HIBERNATETEMPLATE                               │
│                                                              │
│   Traditional Hibernate:         With HibernateTemplate:    │
│   ┌─────────────────────┐       ┌───────────────────┐       │
│   │  Session session    │       │                   │       │
│   │  Transaction tx     │       │ hibernateTemplate │       │
│   │  try {              │  →→→  │   .save(entity)  │       │
│   │    tx = session...  │       │                   │       │
│   │    session.save()   │       │ (1 line!)         │       │
│   │    tx.commit()      │       │                   │       │
│   │  } catch/finally    │       └───────────────────┘       │
│   │    session.close()  │                                   │
│   └─────────────────────┘                                   │
│         10+ lines                      1 line               │
│                                                              │
│   ⚠️ DEPRECATED since Spring 3.1                            │
└─────────────────────────────────────────────────────────────┘
```

### Why Deprecated?

1. Modern Hibernate is simpler to use directly
2. `@Transactional` handles session management
3. Thread-safe session handling with `getCurrentSession()`
4. Less indirection = cleaner code

---

## 4. Spring + Hibernate Configuration

### Dependencies (Maven)

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-orm</artifactId>
        <version>6.x.x</version>
    </dependency>
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-core</artifactId>
        <version>6.x.x</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.x.x</version>
    </dependency>
</dependencies>
```

### XML Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:tx="http://www.springframework.org/schema/tx"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="...">

    <!-- Component Scanning -->
    <context:component-scan base-package="mypack"/>
    
    <!-- Enable Transaction Annotations -->
    <tx:annotation-driven transaction-manager="transactionManager"/>

    <!-- DataSource -->
    <bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource"
          destroy-method="close">
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mydb"/>
        <property name="username" value="root"/>
        <property name="password" value="password"/>
    </bean>

    <!-- LocalSessionFactoryBean - Creates Hibernate SessionFactory -->
    <bean id="sessionFactory" 
          class="org.springframework.orm.hibernate5.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <property name="packagesToScan" value="mypack.entity"/>
        <property name="hibernateProperties">
            <props>
                <prop key="hibernate.dialect">org.hibernate.dialect.MySQLDialect</prop>
                <prop key="hibernate.show_sql">true</prop>
                <prop key="hibernate.format_sql">true</prop>
                <prop key="hibernate.hbm2ddl.auto">update</prop>
            </props>
        </property>
    </bean>

    <!-- Transaction Manager -->
    <bean id="transactionManager" 
          class="org.springframework.orm.hibernate5.HibernateTransactionManager">
        <property name="sessionFactory" ref="sessionFactory"/>
    </bean>

    <!-- HibernateTemplate (Legacy - for reference) -->
    <bean id="hibernateTemplate" 
          class="org.springframework.orm.hibernate5.HibernateTemplate">
        <property name="sessionFactory" ref="sessionFactory"/>
    </bean>

</beans>
```

### Java Configuration (Modern)

```java
@Configuration
@EnableTransactionManagement
@ComponentScan("mypack")
public class HibernateConfig {

    @Bean
    public DataSource dataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/mydb");
        ds.setUsername("root");
        ds.setPassword("password");
        return ds;
    }

    @Bean
    public LocalSessionFactoryBean sessionFactory(DataSource dataSource) {
        LocalSessionFactoryBean sf = new LocalSessionFactoryBean();
        sf.setDataSource(dataSource);
        sf.setPackagesToScan("mypack.entity");
        
        Properties props = new Properties();
        props.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        props.put("hibernate.show_sql", "true");
        props.put("hibernate.format_sql", "true");
        props.put("hibernate.hbm2ddl.auto", "update");
        sf.setHibernateProperties(props);
        
        return sf;
    }

    @Bean
    public HibernateTransactionManager transactionManager(SessionFactory sf) {
        return new HibernateTransactionManager(sf);
    }
}
```

---

## 5. HibernateTemplate CRUD Operations

### HibernateTemplate Methods (Legacy)

| Method | Purpose | SQL Equivalent |
|--------|---------|----------------|
| `save(entity)` | Insert new entity | INSERT |
| `update(entity)` | Update existing entity | UPDATE |
| `saveOrUpdate(entity)` | Insert or update | INSERT/UPDATE |
| `delete(entity)` | Delete entity | DELETE |
| `get(Class, id)` | Load by ID | SELECT WHERE id=? |
| `load(Class, id)` | Lazy load by ID | SELECT (lazy) |
| `find(hql)` | Execute HQL query | SELECT |
| `findByCriteria(...)` | Criteria query | SELECT |

### Legacy DAO with HibernateTemplate

```java
@Repository
public class UserDaoLegacy {
    
    @Autowired
    private HibernateTemplate hibernateTemplate;
    
    // CREATE
    public Serializable save(User user) {
        return hibernateTemplate.save(user);  // Returns generated ID
    }
    
    // READ - by ID
    public User findById(int id) {
        return hibernateTemplate.get(User.class, id);
    }
    
    // READ - all
    @SuppressWarnings("unchecked")
    public List<User> findAll() {
        return (List<User>) hibernateTemplate.find("FROM User");
    }
    
    // READ - by condition
    @SuppressWarnings("unchecked")
    public List<User> findByName(String name) {
        return (List<User>) hibernateTemplate.find(
            "FROM User WHERE name = ?", name);
    }
    
    // UPDATE
    public void update(User user) {
        hibernateTemplate.update(user);
    }
    
    // DELETE
    public void delete(User user) {
        hibernateTemplate.delete(user);
    }
    
    // DELETE by ID
    public void deleteById(int id) {
        User user = findById(id);
        if (user != null) {
            hibernateTemplate.delete(user);
        }
    }
}
```

---

## 6. Modern Approach (SessionFactory)

### Why Modern Approach is Better

```
┌─────────────────────────────────────────────────────────────┐
│           MODERN APPROACH BENEFITS                           │
│                                                              │
│  1. Direct SessionFactory Usage                              │
│     • Less indirection                                       │
│     • Cleaner code                                          │
│     • Full Hibernate API access                             │
│                                                              │
│  2. @Transactional Annotation                                │
│     • Automatic transaction management                       │
│     • Automatic session management                          │
│     • Declarative approach                                  │
│                                                              │
│  3. getCurrentSession()                                      │
│     • Thread-safe                                           │
│     • Bound to current transaction                          │
│     • Auto-closed with transaction                          │
│                                                              │
│  4. Type-safe Queries                                        │
│     • Criteria API                                          │
│     • TypedQuery                                            │
└─────────────────────────────────────────────────────────────┘
```

### Modern DAO with SessionFactory

```java
@Repository
@Transactional
public class UserDao {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }
    
    // CREATE
    public void save(User user) {
        getCurrentSession().persist(user);
    }
    
    // READ - by ID
    public User findById(int id) {
        return getCurrentSession().get(User.class, id);
    }
    
    // READ - all
    public List<User> findAll() {
        return getCurrentSession()
            .createQuery("FROM User", User.class)
            .getResultList();
    }
    
    // READ - by condition
    public List<User> findByName(String name) {
        return getCurrentSession()
            .createQuery("FROM User WHERE name = :name", User.class)
            .setParameter("name", name)
            .getResultList();
    }
    
    // UPDATE
    public void update(User user) {
        getCurrentSession().merge(user);
    }
    
    // DELETE
    public void delete(User user) {
        getCurrentSession().remove(
            getCurrentSession().contains(user) ? user : 
            getCurrentSession().merge(user)
        );
    }
    
    // DELETE by ID
    public void deleteById(int id) {
        User user = findById(id);
        if (user != null) {
            delete(user);
        }
    }
    
    // CRITERIA API
    public List<User> findByEmailDomain(String domain) {
        CriteriaBuilder cb = getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<User> cq = cb.createQuery(User.class);
        Root<User> root = cq.from(User.class);
        
        cq.select(root)
          .where(cb.like(root.get("email"), "%" + domain));
        
        return getCurrentSession()
            .createQuery(cq)
            .getResultList();
    }
}
```

---

## 7. Complete Code Example

### User Entity

```java
package mypack.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(nullable = false, length = 100)
    private String name;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "is_active")
    private boolean active = true;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Constructors
    public User() {}
    
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    
    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', email='" + email + "'}";
    }
}
```

### UserService

```java
package mypack.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserDao userDao;
    
    public void createUser(String name, String email) {
        User user = new User(name, email);
        userDao.save(user);
    }
    
    @Transactional(readOnly = true)
    public User getUser(int id) {
        return userDao.findById(id);
    }
    
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userDao.findAll();
    }
    
    public void updateEmail(int id, String newEmail) {
        User user = userDao.findById(id);
        if (user != null) {
            user.setEmail(newEmail);
            userDao.update(user);
        }
    }
    
    public void deleteUser(int id) {
        userDao.deleteById(id);
    }
}
```

### Main Application

```java
package mypack;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Main {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext ctx = 
            new AnnotationConfigApplicationContext(HibernateConfig.class);
        
        UserService service = ctx.getBean(UserService.class);
        
        // Create
        service.createUser("John Doe", "john@example.com");
        
        // Read
        List<User> users = service.getAllUsers();
        users.forEach(System.out::println);
        
        // Update
        service.updateEmail(1, "john.doe@example.com");
        
        // Delete
        service.deleteUser(1);
        
        ctx.close();
    }
}
```

---

## 8. Entity Mapping

### Common JPA Annotations

| Annotation | Purpose |
|------------|---------|
| `@Entity` | Marks class as JPA entity |
| `@Table(name="...")` | Specifies table name |
| `@Id` | Primary key |
| `@GeneratedValue` | Auto-generation strategy |
| `@Column` | Column mapping |
| `@OneToMany` | One-to-many relationship |
| `@ManyToOne` | Many-to-one relationship |
| `@JoinColumn` | Foreign key column |

### Relationship Example

```java
@Entity
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
    
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;
}
```

---

## 9. Transaction Management

### @Transactional Attributes

```java
@Transactional(
    readOnly = false,                    // Default: false
    propagation = Propagation.REQUIRED,  // Default
    isolation = Isolation.DEFAULT,       // Database default
    timeout = -1,                        // No timeout
    rollbackFor = Exception.class        // Rollback on any exception
)
public void method() { }
```

### Propagation Types

```
┌─────────────────────────────────────────────────────────────┐
│              TRANSACTION PROPAGATION                         │
│                                                              │
│  REQUIRED (default)                                          │
│  • Use existing transaction if any                          │
│  • Create new if none exists                                │
│                                                              │
│  REQUIRES_NEW                                                │
│  • Always create new transaction                            │
│  • Suspend existing if any                                  │
│                                                              │
│  SUPPORTS                                                    │
│  • Use existing transaction if any                          │
│  • Run without transaction if none                          │
│                                                              │
│  NOT_SUPPORTED                                               │
│  • Always run without transaction                           │
│  • Suspend existing if any                                  │
│                                                              │
│  MANDATORY                                                   │
│  • Require existing transaction                             │
│  • Throw exception if none                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. HibernateTemplate vs SessionFactory

| Aspect | HibernateTemplate (Legacy) | SessionFactory (Modern) |
|--------|---------------------------|------------------------|
| Status | Deprecated since Spring 3.1 | Recommended |
| Boilerplate | Minimal | Minimal with @Transactional |
| Session management | Automatic | Via getCurrentSession() |
| API access | Limited wrapper | Full Hibernate API |
| Learning curve | Easy | Slightly more complex |
| Flexibility | Limited | Full control |

---

## 11. Common Interview Questions

### Q1: What is HibernateTemplate?
**A:** HibernateTemplate is a Spring class that simplified Hibernate operations and exception handling. It's deprecated since Spring 3.1 in favor of direct SessionFactory usage with @Transactional.

### Q2: Why is HibernateTemplate deprecated?
**A:** Modern Spring recommends SessionFactory with @Transactional because it's cleaner, provides full Hibernate API access, and @Transactional handles session management automatically.

### Q3: What is LocalSessionFactoryBean?
**A:** A Spring FactoryBean that creates Hibernate's SessionFactory, configuring DataSource, entity scanning, and Hibernate properties.

### Q4: What is HibernateTransactionManager?
**A:** Spring's transaction manager for Hibernate that integrates with @Transactional annotation to manage transactions.

### Q5: Difference between get() and load()?
**A:**
- `get()`: Immediate database hit, returns null if not found
- `load()`: Lazy load (proxy), throws exception if not found

### Q6: What does getCurrentSession() do?
**A:** Returns the Session bound to the current transaction context. Thread-safe and auto-closed when transaction ends.

---

## 12. Key Takeaways

📌 **HibernateTemplate** is deprecated (Spring 3.1+)

📌 **Modern approach**: `SessionFactory` + `@Transactional`

📌 **LocalSessionFactoryBean** creates SessionFactory

📌 **HibernateTransactionManager** for transaction management

📌 Use `getCurrentSession()` to get Session

📌 **@Transactional** handles session open/close automatically

📌 Use **JPA annotations** for entity mapping

📌 **Criteria API** for type-safe queries

📌 For new projects, consider **Spring Data JPA**

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│           HIBERNATE TEMPLATE REFERENCE                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  LEGACY (HibernateTemplate):                                 │
│  @Autowired HibernateTemplate ht;                           │
│  ht.save(entity);                                           │
│  ht.get(User.class, id);                                    │
│  ht.find("FROM User");                                      │
│                                                              │
│  MODERN (SessionFactory):                                    │
│  @Autowired SessionFactory sf;                              │
│  sf.getCurrentSession().persist(entity);                    │
│  sf.getCurrentSession().get(User.class, id);                │
│  sf.getCurrentSession()                                     │
│    .createQuery("FROM User", User.class)                    │
│    .getResultList();                                        │
│                                                              │
│  REQUIRED ANNOTATIONS:                                       │
│  @Repository on DAO                                         │
│  @Transactional on class/method                             │
│                                                              │
│  CONFIGURATION:                                              │
│  LocalSessionFactoryBean → creates SessionFactory           │
│  HibernateTransactionManager → transaction management       │
│  @EnableTransactionManagement → enables @Transactional      │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [15. Advanced JDBC Templates](./15_Advanced_JDBC_Templates.md)*

*Next: [17. Behavioral Design Patterns](./17_Behavioral_Design_Patterns.md)*
