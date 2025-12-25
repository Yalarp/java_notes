# ID Generation Strategies

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [GenerationType Options](#generationtype-options)
3. [IDENTITY](#identity)
4. [SEQUENCE](#sequence)
5. [TABLE](#table)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**ID Generation Strategies** specify how primary key values are automatically generated.

---

## 📖 GenerationType Options

| Strategy | Description | Best For |
|----------|-------------|----------|
| `IDENTITY` | Auto-increment | MySQL |
| `SEQUENCE` | Database sequence | Oracle, PostgreSQL |
| `TABLE` | Separate table | Any database |
| `AUTO` | Hibernate chooses | Portable |

---

## 📖 IDENTITY

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Long id;
```

- Uses database AUTO_INCREMENT
- ID assigned after INSERT
- Recommended for MySQL

---

## 📖 SEQUENCE

```java
@Id
@GeneratedValue(strategy = GenerationType.SEQUENCE, 
                generator = "user_seq")
@SequenceGenerator(
    name = "user_seq",
    sequenceName = "USER_SEQ",
    allocationSize = 1
)
private Long id;
```

- Uses database sequence object
- ID known before INSERT
- Recommended for Oracle

---

## 📖 TABLE

```java
@Id
@GeneratedValue(strategy = GenerationType.TABLE, 
                generator = "id_gen")
@TableGenerator(
    name = "id_gen",
    table = "id_generator",
    pkColumnName = "gen_name",
    valueColumnName = "gen_value"
)
private Long id;
```

- Uses separate table for IDs
- Database portable

---

## ✅ Key Takeaways

1. **IDENTITY** for MySQL
2. **SEQUENCE** for Oracle
3. **TABLE** for portability
4. **AUTO** lets Hibernate choose

---

## 🎤 Interview Questions

**Q1: Which strategy for MySQL?**
> **A:** IDENTITY - uses AUTO_INCREMENT.

**Q2: Difference between IDENTITY and SEQUENCE?**
> **A:** IDENTITY gets ID after INSERT; SEQUENCE gets ID before INSERT.
