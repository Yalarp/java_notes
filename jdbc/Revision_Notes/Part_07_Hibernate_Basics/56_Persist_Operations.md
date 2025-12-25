# Persist Operations (CRUD)

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Create (persist)](#create-persist)
3. [Read (find)](#read-find)
4. [Update (merge)](#update-merge)
5. [Delete (remove)](#delete-remove)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Hibernate provides methods for CRUD operations on entities.

| Operation | Method |
|-----------|--------|
| Create | `persist()` |
| Read | `find()` |
| Update | `merge()` |
| Delete | `remove()` |

---

## 📖 Create (persist)

```java
Session session = sf.openSession();
session.beginTransaction();

User user = new User("John", "john@email.com");
session.persist(user);

session.getTransaction().commit();
session.close();
```

---

## 📖 Read (find)

```java
Session session = sf.openSession();

User user = session.find(User.class, 1L);

session.close();
```

---

## 📖 Update (merge)

```java
Session session = sf.openSession();
session.beginTransaction();

User user = session.find(User.class, 1L);
user.setName("John Updated");
// No explicit call needed for attached entities

session.getTransaction().commit();
session.close();
```

For detached entities:
```java
User managedUser = session.merge(detachedUser);
```

---

## 📖 Delete (remove)

```java
Session session = sf.openSession();
session.beginTransaction();

User user = session.find(User.class, 1L);
if (user != null) {
    session.remove(user);
}

session.getTransaction().commit();
session.close();
```

---

## ✅ Key Takeaways

1. **persist()** - save new
2. **find()** - get by ID
3. **merge()** - update detached
4. **remove()** - delete
5. Attached entities auto-tracked

---

## 🎤 Interview Questions

**Q1: Do you need to call update() for attached entities?**
> **A:** No. Hibernate's dirty checking automatically detects changes.

**Q2: Difference between persist() and merge()?**
> **A:** persist() for new entities; merge() for detached entities.
