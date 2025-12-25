# Criteria API

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Building Queries](#building-queries)
3. [Restrictions](#restrictions)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Criteria API** provides type-safe, programmatic way to build queries.

---

## 📖 Building Queries

```java
CriteriaBuilder cb = session.getCriteriaBuilder();
CriteriaQuery<User> cq = cb.createQuery(User.class);
Root<User> root = cq.from(User.class);

cq.select(root);

List<User> users = session.createQuery(cq).list();
```

---

## 📖 Restrictions

```java
CriteriaBuilder cb = session.getCriteriaBuilder();
CriteriaQuery<User> cq = cb.createQuery(User.class);
Root<User> root = cq.from(User.class);

// WHERE status = 'ACTIVE'
cq.where(cb.equal(root.get("status"), "ACTIVE"));

// AND age >= 18
cq.where(
    cb.and(
        cb.equal(root.get("status"), "ACTIVE"),
        cb.greaterThanOrEqualTo(root.get("age"), 18)
    )
);

// LIKE
cq.where(cb.like(root.get("name"), "%John%"));

// ORDER BY
cq.orderBy(cb.asc(root.get("name")));

List<User> users = session.createQuery(cq).list();
```

---

## ✅ Key Takeaways

1. **Type-safe** at compile time
2. Good for **dynamic queries**
3. Uses CriteriaBuilder, CriteriaQuery, Root

---

## 🎤 Interview Questions

**Q1: Advantages of Criteria API over HQL?**
> **A:** Type-safe, compile-time checking, better for dynamic queries.

**Q2: Main classes in Criteria API?**
> **A:** CriteriaBuilder, CriteriaQuery, Root, Predicate.
