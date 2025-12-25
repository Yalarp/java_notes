# ORM Introduction

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is ORM](#what-is-orm)
3. [What is Hibernate](#what-is-hibernate)
4. [JDBC vs Hibernate](#jdbc-vs-hibernate)
5. [Hibernate Architecture](#hibernate-architecture)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**ORM (Object-Relational Mapping)** maps objects to database tables. **Hibernate** is the most popular Java ORM framework.

---

## 📖 What is ORM

| Objects (Java) | Tables (SQL) |
|----------------|--------------|
| Classes | Tables |
| Fields | Columns |
| Objects | Rows |
| References | Foreign Keys |

ORM automatically converts between objects and SQL.

---

## 📖 What is Hibernate

Hibernate:
- Maps Java classes to database tables
- Generates SQL automatically
- Handles caching and lazy loading
- Manages transactions

---

## 📖 JDBC vs Hibernate

| Feature | JDBC | Hibernate |
|---------|------|-----------|
| Code | Verbose | Concise |
| SQL | Manual | Auto-generated |
| Mapping | Manual | Automatic |
| Caching | Manual | Built-in |

---

## 📖 Hibernate Architecture

```
SessionFactory (one per app, thread-safe)
        ↓
Session (one per request, NOT thread-safe)
        ↓
Transaction
        ↓
Database
```

---

## ✅ Key Takeaways

1. **ORM** bridges objects and tables
2. **Hibernate** generates SQL automatically
3. **SessionFactory** - one per app
4. **Session** - one per request

---

## 🎤 Interview Questions

**Q1: What is ORM?**
> **A:** Object-Relational Mapping - bridges objects and relational databases automatically.

**Q2: SessionFactory vs Session?**
> **A:** SessionFactory is heavyweight, one per app, thread-safe. Session is lightweight, one per request, NOT thread-safe.
