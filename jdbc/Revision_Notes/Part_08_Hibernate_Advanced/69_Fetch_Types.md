# Fetch Types

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [LAZY vs EAGER](#lazy-vs-eager)
3. [N+1 Problem](#n1-problem)
4. [Solutions](#solutions)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Fetch type** determines when associated entities are loaded.

---

## 📖 LAZY vs EAGER

| Type | Behavior | Default For |
|------|----------|-------------|
| `LAZY` | Load when accessed | @OneToMany, @ManyToMany |
| `EAGER` | Load immediately | @ManyToOne, @OneToOne |

```java
@ManyToOne(fetch = FetchType.LAZY)
private Department department;

@OneToMany(fetch = FetchType.LAZY)
private List<Employee> employees;
```

---

## 📖 N+1 Problem

```java
// 1 query for departments
List<Department> depts = session.createQuery("FROM Department").list();

// N queries for employees (one per department!)
for (Department d : depts) {
    d.getEmployees().size();  // Triggers lazy load
}
```

---

## 📖 Solutions

### JOIN FETCH

```java
List<Department> depts = session.createQuery(
    "FROM Department d JOIN FETCH d.employees", Department.class)
    .list();
```

### Entity Graph

```java
@NamedEntityGraph(name = "dept.employees",
    attributeNodes = @NamedAttributeNode("employees"))
public class Department { }
```

---

## ✅ Key Takeaways

1. Use **LAZY** by default
2. **EAGER** can cause performance issues
3. **JOIN FETCH** solves N+1
4. Access lazy collections within session

---

## 🎤 Interview Questions

**Q1: What is the N+1 problem?**
> **A:** Loading N entities then accessing lazy collection on each causes N additional queries.

**Q2: Default fetch for @OneToMany?**
> **A:** LAZY (load when accessed).
