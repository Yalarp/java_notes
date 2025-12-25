# Hibernate Without XML

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Java Configuration](#java-configuration)
3. [Properties Object](#properties-object)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Hibernate can be configured entirely in **Java code** without XML files.

---

## 📖 Java Configuration

```java
public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    
    static {
        Configuration cfg = new Configuration();
        
        // Database settings
        cfg.setProperty("hibernate.connection.driver_class", 
                       "com.mysql.cj.jdbc.Driver");
        cfg.setProperty("hibernate.connection.url", 
                       "jdbc:mysql://localhost:3306/mydb");
        cfg.setProperty("hibernate.connection.username", "root");
        cfg.setProperty("hibernate.connection.password", "root");
        
        // Hibernate settings
        cfg.setProperty("hibernate.dialect", 
                       "org.hibernate.dialect.MySQLDialect");
        cfg.setProperty("hibernate.hbm2ddl.auto", "update");
        cfg.setProperty("hibernate.show_sql", "true");
        
        // Add entities
        cfg.addAnnotatedClass(User.class);
        cfg.addAnnotatedClass(Product.class);
        
        sessionFactory = cfg.buildSessionFactory();
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
```

---

## 📖 Properties Object

```java
Properties props = new Properties();
props.put("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
props.put("hibernate.connection.url", "jdbc:mysql://localhost:3306/mydb");
props.put("hibernate.connection.username", "root");
props.put("hibernate.connection.password", "root");

Configuration cfg = new Configuration();
cfg.setProperties(props);
cfg.addAnnotatedClass(User.class);

SessionFactory sf = cfg.buildSessionFactory();
```

---

## ✅ Key Takeaways

1. Use `Configuration.setProperty()` for settings
2. Use `cfg.addAnnotatedClass()` for entities
3. No hibernate.cfg.xml needed
4. Good for programmatic configuration

---

## 🎤 Interview Questions

**Q1: How to configure Hibernate without XML?**
> **A:** Use `Configuration.setProperty()` and `addAnnotatedClass()` in Java code.

**Q2: Advantages of Java configuration?**
> **A:** Type-safe, IDE support, programmatic control.
