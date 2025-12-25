# HQL Advanced

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Aggregations](#aggregations)
3. [Joins](#joins)
4. [Update and Delete](#update-and-delete)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Advanced HQL features for aggregations, joins, and bulk operations.

---

## 📖 Aggregations

```java
// Count
Long count = session.createQuery(
    "SELECT COUNT(u) FROM User u", Long.class).uniqueResult();

// Average
Double avgAge = session.createQuery(
    "SELECT AVG(u.age) FROM User u", Double.class).uniqueResult();

// Group By
List<Object[]> stats = session.createQuery(
    "SELECT u.status, COUNT(u) FROM User u GROUP BY u.status",
    Object[].class).list();
```

---

## 📖 Joins

```java
// Implicit join (dot notation)
List<Order> orders = session.createQuery(
    "FROM Order o WHERE o.user.name = :name", Order.class)
    .setParameter("name", "John")
    .list();

// Explicit join
List<Object[]> results = session.createQuery(
    "SELECT o, u FROM Order o JOIN o.user u", Object[].class)
    .list();

// Fetch join (eager load)
List<User> users = session.createQuery(
    "FROM User u JOIN FETCH u.orders", User.class)
    .list();
```

---

## 📖 Update and Delete

```java
// Bulk update
int updated = session.createMutationQuery(
    "UPDATE User SET status = :status WHERE lastLogin < :date")
    .setParameter("status", "INACTIVE")
    .setParameter("date", cutoffDate)
    .executeUpdate();

// Bulk delete
int deleted = session.createMutationQuery(
    "DELETE FROM User WHERE status = :status")
    .setParameter("status", "DELETED")
    .executeUpdate();
```

---

## ✅ Key Takeaways

1. **Aggregations**: COUNT, AVG, SUM, MAX, MIN
2. **JOIN FETCH** for eager loading
3. **executeUpdate()** for bulk operations
4. Bulk operations bypass entity cache

---

## 🎤 Interview Questions

**Q1: What is JOIN FETCH?**
> **A:** Loads associated entities in same query to avoid N+1 problem.

**Q2: Do bulk updates trigger entity lifecycle?**
> **A:** No, they bypass entity cache and don't trigger listeners.
