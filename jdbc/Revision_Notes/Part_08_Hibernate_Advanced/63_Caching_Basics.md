# Caching Basics

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [First-Level Cache](#first-level-cache)
3. [Second-Level Cache](#second-level-cache)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Hibernate caching reduces database hits for better performance.

---

## 📖 First-Level Cache

- **Scope**: Session
- **Enabled**: Always (cannot disable)
- **Purpose**: Avoid duplicates within session

```java
Session session = sf.openSession();

User user1 = session.find(User.class, 1L);  // DB hit
User user2 = session.find(User.class, 1L);  // Cache hit!

System.out.println(user1 == user2);  // true
```

### Cache Operations

```java
session.clear();      // Clear all
session.evict(user);  // Remove specific entity
```

---

## 📖 Second-Level Cache

- **Scope**: SessionFactory (shared)
- **Enabled**: Requires configuration
- **Purpose**: Cache across sessions

```java
// Session 1
Session s1 = sf.openSession();
User user = s1.find(User.class, 1L);  // DB hit
s1.close();

// Session 2
Session s2 = sf.openSession();
User user = s2.find(User.class, 1L);  // L2 cache hit!
```

---

## ✅ Key Takeaways

1. **L1 Cache** - per session, always on
2. **L2 Cache** - shared, optional
3. L1 returns **same object**
4. Use caching for **read-heavy** data

---

## 🎤 Interview Questions

**Q1: Difference between L1 and L2 cache?**
> **A:** L1 is per-session, always on. L2 is per-SessionFactory, optional, shared.

**Q2: Can you disable L1 cache?**
> **A:** No, but you can clear it with session.clear().
