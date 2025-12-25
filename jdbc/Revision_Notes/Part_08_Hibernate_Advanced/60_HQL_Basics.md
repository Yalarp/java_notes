# HQL Basics

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [HQL vs SQL](#hql-vs-sql)
3. [Basic Queries](#basic-queries)
4. [Parameters](#parameters)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**HQL (Hibernate Query Language)** is object-oriented query language using entity/property names.

---

## 📖 HQL vs SQL

| HQL | SQL |
|-----|-----|
| Entity names | Table names |
| Property names | Column names |
| Object-oriented | Relational |
| Database independent | Database specific |

---

## 📖 Basic Queries

```java
// Select all
List<User> users = session.createQuery("FROM User", User.class).list();

// With WHERE
List<User> users = session.createQuery(
    "FROM User WHERE status = 'ACTIVE'", User.class).list();

// Order By
List<User> users = session.createQuery(
    "FROM User ORDER BY name ASC", User.class).list();

// Single result
User user = session.createQuery(
    "FROM User WHERE id = 1", User.class).uniqueResult();
```

---

## 📖 Parameters

### Named Parameters

```java
User user = session.createQuery(
    "FROM User WHERE email = :email", User.class)
    .setParameter("email", "john@email.com")
    .uniqueResult();
```

### Pagination

```java
List<User> users = session.createQuery("FROM User", User.class)
    .setFirstResult(0)
    .setMaxResults(10)
    .list();
```

---

## ✅ Key Takeaways

1. HQL uses **entity/property names**
2. Use **named parameters** for safety
3. **list()** for multiple, **uniqueResult()** for single
4. Database independent

---

## 🎤 Interview Questions

**Q1: Difference between HQL and SQL?**
> **A:** HQL uses entity names; SQL uses table names. HQL is database independent.

**Q2: How to implement pagination?**
> **A:** Use `setFirstResult()` and `setMaxResults()`.
