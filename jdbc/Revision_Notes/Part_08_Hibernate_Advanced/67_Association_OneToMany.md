# Association: OneToMany & ManyToOne

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Bidirectional Mapping](#bidirectional-mapping)
3. [Helper Methods](#helper-methods)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**OneToMany/ManyToOne** represents parent-child relationships.

```
Department (1) ←→ (*) Employee
```

---

## 📖 Bidirectional Mapping

### Department (One Side)

```java
@Entity
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL)
    private List<Employee> employees = new ArrayList<>();
}
```

### Employee (Many Side - Owns FK)

```java
@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id")
    private Department department;
}
```

---

## 📖 Helper Methods

```java
public class Department {
    public void addEmployee(Employee emp) {
        employees.add(emp);
        emp.setDepartment(this);
    }
    
    public void removeEmployee(Employee emp) {
        employees.remove(emp);
        emp.setDepartment(null);
    }
}
```

---

## ✅ Key Takeaways

1. Many side **owns** the relationship
2. **mappedBy** on One side
3. **@JoinColumn** on Many side
4. Use **helper methods** for consistency

---

## 🎤 Interview Questions

**Q1: Which side owns the relationship?**
> **A:** The Many side (with @ManyToOne and @JoinColumn).

**Q2: Why use helper methods?**
> **A:** To maintain consistency on both sides of bidirectional relationship.
