# Hibernate Setup

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Maven Dependencies](#maven-dependencies)
3. [hibernate.cfg.xml](#hibernatecfgxml)
4. [HibernateUtil](#hibernateutil)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Hibernate can be configured using **XML** or **Java-based** configuration.

---

## 📖 Maven Dependencies

```xml
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.3.1.Final</version>
</dependency>
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>
```

---

## 📖 hibernate.cfg.xml

```xml
<hibernate-configuration>
    <session-factory>
        <property name="hibernate.connection.driver_class">
            com.mysql.cj.jdbc.Driver</property>
        <property name="hibernate.connection.url">
            jdbc:mysql://localhost:3306/mydb</property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password">root</property>
        <property name="hibernate.dialect">
            org.hibernate.dialect.MySQLDialect</property>
        <property name="hibernate.hbm2ddl.auto">update</property>
        <property name="hibernate.show_sql">true</property>
        
        <mapping class="com.example.entity.User"/>
    </session-factory>
</hibernate-configuration>
```

### hbm2ddl.auto Values

| Value | Behavior |
|-------|----------|
| `create` | Drop and recreate |
| `update` | Update schema |
| `validate` | Validate only |
| `none` | Do nothing |

---

## 📖 HibernateUtil

```java
public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    
    static {
        sessionFactory = new Configuration()
                .configure()
                .buildSessionFactory();
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
```

---

## ✅ Key Takeaways

1. Config in **hibernate.cfg.xml** or Java
2. **hbm2ddl.auto=update** for development
3. SessionFactory created once at startup

---

## 🎤 Interview Questions

**Q1: What is hbm2ddl.auto?**
> **A:** Controls schema generation: create, update, validate, none.

**Q2: Where to place hibernate.cfg.xml?**
> **A:** In classpath root. For Maven: `src/main/resources/`
