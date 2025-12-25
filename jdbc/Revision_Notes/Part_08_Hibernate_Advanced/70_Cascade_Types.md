# Cascade Types

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Cascade Types](#cascade-types)
3. [Usage](#usage)
4. [orphanRemoval](#orphanremoval)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Cascade** propagates operations from parent to child entities.

---

## 📖 Cascade Types

| Type | Description |
|------|-------------|
| `PERSIST` | Save children with parent |
| `MERGE` | Update children with parent |
| `REMOVE` | Delete children with parent |
| `REFRESH` | Refresh children with parent |
| `DETACH` | Detach children with parent |
| `ALL` | All of the above |

---

## 📖 Usage

```java
@Entity
public class Department {
    
    @OneToMany(mappedBy = "department", 
               cascade = CascadeType.ALL)
    private List<Employee> employees;
}
```

### Example

```java
Department dept = new Department("IT");
dept.addEmployee(new Employee("John"));
dept.addEmployee(new Employee("Jane"));

session.persist(dept);  // Persists dept AND both employees!
```

---

## 📖 orphanRemoval

Removes child when removed from collection:

```java
@OneToMany(mappedBy = "department", 
           cascade = CascadeType.ALL,
           orphanRemoval = true)
private List<Employee> employees;
```

```java
dept.getEmployees().remove(employee);
// Employee is deleted from database!
```

---

## ✅ Key Takeaways

1. **CascadeType.ALL** for parent-child lifecycle
2. **PERSIST** saves children automatically
3. **REMOVE** deletes children with parent
4. **orphanRemoval** deletes when removed from collection

---

## 🎤 Interview Questions

**Q1: What is CascadeType.ALL?**
> **A:** All cascade operations: PERSIST, MERGE, REMOVE, REFRESH, DETACH.

**Q2: Difference between REMOVE and orphanRemoval?**
> **A:** REMOVE deletes when parent deleted. orphanRemoval also deletes when removed from collection.
