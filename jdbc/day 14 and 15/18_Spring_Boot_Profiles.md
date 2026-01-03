# ⚙️ Spring Boot Profiles

## Table of Contents
1. [What are Profiles](#what-are-profiles)
2. [Profile Configuration Files](#profile-configuration-files)
3. [Activating Profiles](#activating-profiles)
4. [Using @Value Annotation](#using-value-annotation)
5. [Complete Example](#complete-example)
6. [Interview Questions](#interview-questions)

---

## What are Profiles

**Spring Boot Profiles** allow different configurations for different environments (dev, test, prod).

```
┌─────────────────────────────────────────────────────────────┐
│           What is Spring Boot Profile?                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Profile = Environment-specific configuration               │
│                                                             │
│  Common Profiles:                                           │
│    dev  → Development environment                           │
│    test → Testing environment                               │
│    prod → Production environment                            │
│                                                             │
│  Benefits:                                                  │
│    ✓ Separate properties per environment                    │
│    ✓ Switch without code changes                            │
│    ✓ Different DB, logging, API keys per env                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Profile Configuration Files

### File Naming Convention

```
src/main/resources/
├── application.properties          # Common (+ active profile)
├── application-dev.properties      # Development
├── application-test.properties     # Testing
└── application-prod.properties     # Production
```

### Example Files

**application.properties**
```properties
spring.profiles.active=dev
server.port=8080
```

**application-dev.properties**
```properties
my.message=Hello from DEVELOPMENT
logging.level.root=DEBUG
```

**application-test.properties**
```properties
my.message=Hello from TESTING
```

**application-prod.properties**
```properties
my.message=Hello from PRODUCTION
logging.level.root=WARN
```

---

## Activating Profiles

```properties
# In application.properties
spring.profiles.active=dev
```

```bash
# Command line
java -jar app.jar --spring.profiles.active=prod

# Environment variable
set SPRING_PROFILES_ACTIVE=prod
```

**Priority (highest to lowest):**
1. Command line argument
2. Environment variable
3. application.properties

---

## Using @Value Annotation

```java
@RestController
public class ProfileController {
    
    @Value("${my.message}")
    private String message;
    
    @GetMapping("/helloprofile")
    public String sayHello() {
        return message;
    }
}
```

**Result based on profile:**
- dev: "Hello from DEVELOPMENT"
- prod: "Hello from PRODUCTION"

---

## Complete Example

**ProfileController.java**
```java
package com.example.FirstPro;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ProfileController {
    @Value("${my.message}")
    private String message;
    
    @GetMapping("helloprofile")
    public String sayHello() {
        return message;
    }
}
```

---

## Interview Questions

**Q1: What is a Spring Boot Profile?**
Environment-specific configuration. Different properties per dev/test/prod.

**Q2: How to create profile files?**
Name: `application-{profile}.properties` (e.g., application-dev.properties)

**Q3: How to activate a profile?**
- `spring.profiles.active=dev` in properties
- `--spring.profiles.active=prod` command line
- `SPRING_PROFILES_ACTIVE=prod` environment variable

**Q4: What if property exists in both common and profile files?**
Profile-specific OVERRIDES common properties.

---

*Next: [18_Spring_Boot_Validation.md](./18_Spring_Boot_Validation.md)*
