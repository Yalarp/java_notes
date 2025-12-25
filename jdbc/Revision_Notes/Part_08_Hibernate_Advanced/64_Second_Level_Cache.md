# Second Level Cache

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Cache Strategies](#cache-strategies)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Second Level Cache** is shared across sessions for frequently accessed data.

---

## 📖 Configuration

### hibernate.cfg.xml

```xml
<property name="hibernate.cache.use_second_level_cache">true</property>
<property name="hibernate.cache.region.factory_class">
    org.hibernate.cache.jcache.JCacheRegionFactory
</property>
```

### Entity Annotation

```java
@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Product { }
```

---

## 📖 Cache Strategies

| Strategy | Description |
|----------|-------------|
| `READ_ONLY` | Immutable data |
| `READ_WRITE` | Read & write with locks |
| `NONSTRICT_READ_WRITE` | Occasionally updated |
| `TRANSACTIONAL` | Full transaction support |

---

## ✅ Key Takeaways

1. Shared across sessions
2. Needs **@Cacheable** on entities
3. Choose strategy based on data mutability
4. Good for reference data

---

## 🎤 Interview Questions

**Q1: When to use L2 cache?**
> **A:** For read-heavy, rarely-changing data like reference tables.

**Q2: What is READ_ONLY strategy?**
> **A:** For immutable entities that never change after creation.
