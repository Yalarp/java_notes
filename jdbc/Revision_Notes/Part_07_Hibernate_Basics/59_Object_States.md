# Object States in Hibernate

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Entity States](#entity-states)
3. [State Transitions](#state-transitions)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Hibernate entities exist in different **states** during their lifecycle.

---

## 📖 Entity States

| State | Description |
|-------|-------------|
| **Transient** | New object, not yet saved |
| **Persistent** | Saved and managed by session |
| **Detached** | Was persistent, session closed |
| **Removed** | Marked for deletion |

---

## 📖 State Transitions

```
     new User()
          ↓
    ┌─────────────┐
    │  TRANSIENT  │
    └──────┬──────┘
           │ persist()
           ↓
    ┌─────────────┐        close()/clear()     ┌─────────────┐
    │  PERSISTENT │ ─────────────────────────► │   DETACHED  │
    └──────┬──────┘ ◄───────────────────────── └─────────────┘
           │              merge()
           │ remove()
           ↓
    ┌─────────────┐
    │   REMOVED   │
    └─────────────┘
```

### Transient → Persistent
```java
User user = new User();  // Transient
session.persist(user);   // Persistent
```

### Persistent → Detached
```java
session.close();  // Entity becomes Detached
```

### Detached → Persistent
```java
User managed = session.merge(detachedUser);  // Persistent again
```

### Persistent → Removed
```java
session.remove(user);  // Removed (deleted on commit)
```

---

## ✅ Key Takeaways

1. **Transient**: New, no ID, not saved
2. **Persistent**: Managed, changes tracked
3. **Detached**: Not managed, can be reattached
4. **Removed**: Scheduled for deletion

---

## 🎤 Interview Questions

**Q1: What are the entity states?**
> **A:** Transient (new), Persistent (managed), Detached (session closed), Removed (to be deleted).

**Q2: How to reattach a detached entity?**
> **A:** Use `session.merge(detachedEntity)` which returns a new persistent instance.
