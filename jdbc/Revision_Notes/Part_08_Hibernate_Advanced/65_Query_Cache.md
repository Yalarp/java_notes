# Query Cache

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Usage](#usage)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Query Cache** caches query results, not just entities.

---

## 📖 Configuration

```xml
<property name="hibernate.cache.use_query_cache">true</property>
```

---

## 📖 Usage

```java
List<Product> products = session.createQuery(
    "FROM Product WHERE category = :cat", Product.class)
    .setParameter("cat", "Electronics")
    .setCacheable(true)  // Enable query cache
    .list();
```

### Cache Key

Query cache key includes:
- Query string
- Parameter values
- Pagination settings

---

## ✅ Key Takeaways

1. Caches **query results**
2. Requires `setCacheable(true)` per query
3. Invalidated when entity changes
4. Works best with L2 cache

---

## 🎤 Interview Questions

**Q1: What does query cache store?**
> **A:** Primary keys of entities returned by the query. Actual entities from L2 cache.

**Q2: When is query cache invalidated?**
> **A:** When any entity in the result is modified.
