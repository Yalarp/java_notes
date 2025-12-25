# Association: ManyToMany

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Mapping](#mapping)
3. [Join Table](#join-table)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**ManyToMany** represents relationships where both sides can have multiple instances.

```
Student (*) ←→ (*) Course
```

---

## 📖 Mapping

### Student (Owning Side)

```java
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    
    @ManyToMany
    @JoinTable(
        name = "student_course",
        joinColumns = @JoinColumn(name = "student_id"),
        inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private Set<Course> courses = new HashSet<>();
}
```

### Course (Inverse Side)

```java
@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    
    @ManyToMany(mappedBy = "courses")
    private Set<Student> students = new HashSet<>();
}
```

---

## 📖 Join Table

```sql
CREATE TABLE student_course (
    student_id BIGINT,
    course_id BIGINT,
    PRIMARY KEY (student_id, course_id)
);
```

---

## ✅ Key Takeaways

1. Requires **join table**
2. **@JoinTable** on owning side
3. **mappedBy** on inverse side
4. Use **Set** to avoid duplicates

---

## 🎤 Interview Questions

**Q1: What is a join table?**
> **A:** Intermediate table storing foreign keys from both sides of ManyToMany.

**Q2: Why use Set instead of List?**
> **A:** Set prevents duplicates and is more efficient for ManyToMany.
