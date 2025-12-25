# Entity Mapping

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Basic Entity](#basic-entity)
3. [Common Annotations](#common-annotations)
4. [ID Generation](#id-generation)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Entity classes** represent database tables. JPA annotations map fields to columns.

---

## 📖 Basic Entity

```java
@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "user_name", nullable = false)
    private String name;
    
    private String email;
    
    // Constructors, getters, setters
}
```

---

## 📖 Common Annotations

| Annotation | Purpose |
|------------|---------|
| `@Entity` | Mark as JPA entity |
| `@Table` | Specify table name |
| `@Id` | Primary key |
| `@GeneratedValue` | ID generation |
| `@Column` | Column mapping |
| `@Transient` | Not persisted |

### @Column Attributes

```java
@Column(
    name = "user_name",
    length = 100,
    nullable = false,
    unique = true
)
private String name;
```

---

## 📖 ID Generation

| Strategy | Description |
|----------|-------------|
| `IDENTITY` | Auto-increment (MySQL) |
| `SEQUENCE` | Sequence (Oracle) |
| `TABLE` | Separate table |
| `AUTO` | Hibernate chooses |

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;
```

---

## ✅ Key Takeaways

1. **@Entity** + **@Id** are required
2. **@GeneratedValue** for auto ID
3. Entity needs **no-arg constructor**
4. Use **IDENTITY** for MySQL

---

## 🎤 Interview Questions

**Q1: What annotations are mandatory?**
> **A:** @Entity on class and @Id on primary key field.

**Q2: What does @Transient do?**
> **A:** Marks field to NOT be persisted to database.
