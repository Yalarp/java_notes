# Association: OneToOne

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Unidirectional](#unidirectional)
3. [Bidirectional](#bidirectional)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**OneToOne** associates one entity with exactly one other entity.

---

## 📖 Unidirectional

```java
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "profile_id")
    private Profile profile;
}

@Entity
public class Profile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String bio;
}
```

---

## 📖 Bidirectional

```java
@Entity
public class User {
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "profile_id")
    private Profile profile;
}

@Entity
public class Profile {
    @OneToOne(mappedBy = "profile")
    private User user;
}
```

---

## ✅ Key Takeaways

1. **@JoinColumn** on owning side
2. **mappedBy** on inverse side
3. Use **CascadeType.ALL** for lifecycle

---

## 🎤 Interview Questions

**Q1: What does mappedBy do?**
> **A:** Indicates inverse side; references the property on owning side.

**Q2: Which side has the FK?**
> **A:** The owning side with @JoinColumn.
