# ✅ Spring Boot REST API Validation

## Table of Contents
1. [Introduction](#introduction)
2. [Dependencies](#dependencies)
3. [Entity with Validation](#entity-with-validation)
4. [Controller with @Valid](#controller-with-valid)
5. [Validation Annotations](#validation-annotations)
6. [Error Handling](#error-handling)
7. [Interview Questions](#interview-questions)

---

## Introduction

**Bean Validation** in Spring Boot validates incoming request data using annotations before processing.

```
┌─────────────────────────────────────────────────────────────┐
│           Why Validation?                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Without Validation:                                        │
│    ✗ Invalid data enters system                             │
│    ✗ Database errors                                        │
│    ✗ Security vulnerabilities                               │
│                                                             │
│  With Validation:                                           │
│    ✓ Reject bad data early                                  │
│    ✓ Clear error messages                                   │
│    ✓ Clean data in database                                 │
│                                                             │
│  Annotations Used:                                          │
│    @NotBlank, @Email, @Size, @Pattern, @Range               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Dependencies

```xml
<!-- Spring Boot Starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<!-- Validation Starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>

<!-- JPA for Entity -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

---

## Entity with Validation

### Person.java

```java
package com.example.entities;

import org.hibernate.validator.constraints.Range;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Entity
public class Person {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private int id;
    
    @NotBlank(message="person name must be entered")
    @Size(min=4, max=20, message="name must be between 4 to 20")
    @Pattern(regexp = "^[a-zA-Z]+$", message = "name must contain characters")
    private String name;
    
    @NotBlank(message="email can not be empty")
    @Email(message="invalid email id")
    private String email;
    
    @Range(min=18, max=30, message="age should be between {min} and {max}")
    private int age;
    
    // Getters and setters...
}
```

### Annotation Explanations

| Annotation | Purpose | Example |
|------------|---------|---------|
| `@NotBlank` | Not null and not empty | Name required |
| `@Size(min=4, max=20)` | String length limits | 4-20 characters |
| `@Pattern(regexp)` | Regex pattern match | Letters only |
| `@Email` | Valid email format | user@domain.com |
| `@Range(min, max)` | Number range | Age 18-30 |

---

## Controller with @Valid

### PersonController.java

```java
package com.example.controllers;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.entities.Person;
import com.example.services.PersonManager;
import jakarta.validation.Valid;

@RestController
public class PersonController {
    @Autowired
    private PersonManager manager;
    
    @PostMapping("/addPerson")
    public void addPerson(@Valid @RequestBody Person person) {
        manager.addPerson(person);
    }
    
    @GetMapping("/getPersons")
    public List<Person> getAllPersons() {
        return manager.getAllPersons();
    }
}
```

### Key Point: @Valid

```
┌─────────────────────────────────────────────────────────────┐
│           @Valid Annotation                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  @Valid @RequestBody Person person                          │
│                                                             │
│  What it does:                                              │
│    1. Deserialize JSON to Person object                     │
│    2. Trigger validation on Person fields                   │
│    3. If validation FAILS → 400 Bad Request                 │
│    4. If validation PASSES → Continue to method             │
│                                                             │
│  Without @Valid:                                            │
│    Validation annotations are IGNORED!                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Validation Annotations

### Common Annotations

| Annotation | Package | Purpose |
|------------|---------|---------|
| `@NotNull` | jakarta.validation | Not null |
| `@NotEmpty` | jakarta.validation | Not null, not empty |
| `@NotBlank` | jakarta.validation | Not null, not empty, not whitespace |
| `@Size` | jakarta.validation | String/collection size |
| `@Min`, `@Max` | jakarta.validation | Number min/max |
| `@Email` | jakarta.validation | Email format |
| `@Pattern` | jakarta.validation | Regex match |
| `@Range` | org.hibernate.validator | Number range |
| `@Past`, `@Future` | jakarta.validation | Date validation |

### Usage Examples

```java
@NotBlank(message = "Username required")
private String username;

@Email(message = "Invalid email")
private String email;

@Size(min = 8, message = "Password min 8 chars")
private String password;

@Min(value = 0, message = "Price cannot be negative")
private double price;

@Past(message = "Birth date must be in past")
private LocalDate birthDate;
```

---

## Error Handling

### Default Error Response (400 Bad Request)

When validation fails, Spring returns 400 with details:

```json
{
  "timestamp": "2024-01-15T10:30:45",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "errors": [
    {
      "field": "name",
      "defaultMessage": "name must be between 4 to 20"
    },
    {
      "field": "email", 
      "defaultMessage": "invalid email id"
    }
  ]
}
```

### Custom Exception Handler

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationErrors(
            MethodArgumentNotValidException ex) {
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error -> 
            errors.put(error.getField(), error.getDefaultMessage())
        );
        return ResponseEntity.badRequest().body(errors);
    }
}
```

---

## Interview Questions

**Q1: How to enable validation in Spring Boot?**
Add `spring-boot-starter-validation` dependency and use `@Valid` on controller parameters.

**Q2: What is the difference between @NotNull, @NotEmpty, @NotBlank?**
- `@NotNull`: Not null (empty string OK)
- `@NotEmpty`: Not null, not empty (whitespace OK)
- `@NotBlank`: Not null, not empty, not only whitespace

**Q3: Why is @Valid required?**
Without `@Valid`, validation annotations on entity are ignored. `@Valid` triggers the validation.

**Q4: What HTTP status for validation failure?**
400 Bad Request with error details.

**Q5: What is `@Range` annotation?**
Hibernate Validator annotation for number ranges: `@Range(min=18, max=30)`

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           Validation Summary                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Setup:                                                     │
│    1. Add spring-boot-starter-validation                    │
│    2. Add annotations to entity fields                      │
│    3. Use @Valid in controller                              │
│                                                             │
│  Key Annotations:                                           │
│    @NotBlank, @Email, @Size, @Pattern, @Range               │
│                                                             │
│  Controller:                                                │
│    @PostMapping                                             │
│    public void add(@Valid @RequestBody Person p) { }        │
│                                                             │
│  On Failure: 400 Bad Request with error messages            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [17_Spring_Boot_Profiles.md](./17_Spring_Boot_Profiles.md)*
