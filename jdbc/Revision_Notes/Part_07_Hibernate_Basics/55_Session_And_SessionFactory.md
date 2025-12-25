# Session and SessionFactory

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [SessionFactory](#sessionfactory)
3. [Session](#session)
4. [Transaction](#transaction)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**SessionFactory** creates Sessions. **Session** is the main interface for CRUD operations.

---

## 📖 SessionFactory

- **One per application**
- **Thread-safe**
- **Heavyweight** (expensive to create)
- Caches compiled mappings

```java
SessionFactory sf = new Configuration()
        .configure()
        .buildSessionFactory();
```

---

## 📖 Session

- **One per request/thread**
- **NOT thread-safe**
- **Lightweight**
- Main interface for CRUD

```java
Session session = sf.openSession();
try {
    session.beginTransaction();
    session.persist(user);
    session.getTransaction().commit();
} finally {
    session.close();
}
```

### Common Methods

| Method | Description |
|--------|-------------|
| `persist()` | Save new entity |
| `find()` | Get by ID |
| `merge()` | Update detached |
| `remove()` | Delete entity |

---

## 📖 Transaction

```java
Session session = sf.openSession();
Transaction tx = null;
try {
    tx = session.beginTransaction();
    // operations
    tx.commit();
} catch (Exception e) {
    if (tx != null) tx.rollback();
    throw e;
} finally {
    session.close();
}
```

---

## ✅ Key Takeaways

1. **SessionFactory** - one per app, thread-safe
2. **Session** - one per request, NOT thread-safe
3. Always use **transactions** for writes
4. Always **close** sessions

---

## 🎤 Interview Questions

**Q1: Difference between Session and SessionFactory?**
> **A:** SessionFactory is per-app, thread-safe, heavyweight. Session is per-request, not thread-safe, lightweight.

**Q2: What happens without commit()?**
> **A:** Changes are not saved to database; they're lost on session close.
