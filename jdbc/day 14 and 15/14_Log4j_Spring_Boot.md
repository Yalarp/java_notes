# 📝 Logging in Spring Boot with SLF4J

## Table of Contents
1. [Spring Boot Default Logging](#spring-boot-default-logging)
2. [SLF4J vs Log4j](#slf4j-vs-log4j)
3. [Logging Configuration](#logging-configuration)
4. [Logger Usage in Spring Boot](#logger-usage-in-spring-boot)
5. [Complete REST Application with Logging](#complete-rest-application-with-logging)
6. [Log Output Analysis](#log-output-analysis)
7. [Best Practices](#best-practices)
8. [Interview Questions](#interview-questions)

---

## Spring Boot Default Logging

### What Spring Boot Uses

```
┌─────────────────────────────────────────────────────────────┐
│           Spring Boot Logging Stack                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Default Setup (out of the box):                            │
│                                                             │
│    Your Code                                                │
│       ↓                                                     │
│    SLF4J (Facade/Interface)                                 │
│       ↓                                                     │
│    Logback (Implementation) ← Default in Spring Boot        │
│       ↓                                                     │
│    Console Output                                           │
│                                                             │
│  Key Points:                                                │
│    • SLF4J is the API you code against                      │
│    • Logback is the actual logging framework                │
│    • No additional dependencies needed                      │
│    • Zero configuration for basic logging                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Why SLF4J + Logback?

| Feature | Benefit |
|---------|---------|
| **Zero Config** | Works out of the box |
| **Abstraction** | SLF4J facade hides implementation |
| **Performance** | Logback is fast and efficient |
| **Flexibility** | Can switch to Log4j2 if needed |
| **Spring Integration** | Built-in support in Spring Boot |

---

## SLF4J vs Log4j

### Understanding the Difference

```
┌─────────────────────────────────────────────────────────────┐
│           SLF4J vs Log4j - Key Difference                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SLF4J (Simple Logging Facade for Java):                    │
│    • It's an INTERFACE/API only                             │
│    • Provides common logging methods                        │
│    • Does NOT do actual logging                             │
│    • Needs an implementation behind it                      │
│                                                             │
│  Log4j / Logback:                                           │
│    • Actual logging IMPLEMENTATION                          │
│    • Does the real work of logging                          │
│    • Can be used directly or via SLF4J                      │
│                                                             │
│  Analogy:                                                   │
│    SLF4J = JDBC (interface)                                 │
│    Logback = MySQL Driver (implementation)                  │
│                                                             │
│  Why use SLF4J?                                             │
│    • Code to interface, not implementation                  │
│    • Switch logging frameworks without code changes         │
│    • All Spring Boot libraries use SLF4J                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Comparison Table

| Aspect | SLF4J | Log4j | Logback |
|--------|-------|-------|---------|
| **Type** | Facade/API | Implementation | Implementation |
| **Spring Boot Default** | Yes (API) | No | Yes (impl) |
| **Configuration** | N/A | log4j.properties | logback.xml |
| **Performance** | N/A | Good | Better |
| **Your Code Uses** | Yes | Sometimes | Through SLF4J |

---

## Logging Configuration

### application.properties Configuration

```properties
# Set log level for root logger
logging.level.root=INFO

# Set log level for specific packages
logging.level.com.example=DEBUG
logging.level.com.example.controllers=TRACE
logging.level.org.springframework=WARN

# Log to file
logging.file.name=application.log
logging.file.path=/var/log/myapp

# Pattern for console output
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n

# Pattern for file output
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

### Configuration Properties Explained

| Property | Purpose | Example |
|----------|---------|---------|
| `logging.level.root` | Default level for all loggers | `INFO` |
| `logging.level.{package}` | Level for specific package | `DEBUG` |
| `logging.file.name` | Log file name | `app.log` |
| `logging.file.path` | Log file directory | `/var/log` |
| `logging.pattern.console` | Console output format | `%d %p %m%n` |

### Log Levels in Spring Boot

```
┌─────────────────────────────────────────────────────────────┐
│           Spring Boot Log Levels                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Level Hierarchy (most to least verbose):                   │
│                                                             │
│    TRACE  ← Most detailed (includes everything below)       │
│      ↓                                                      │
│    DEBUG  ← Detailed debugging                              │
│      ↓                                                      │
│    INFO   ← General information (DEFAULT)                   │
│      ↓                                                      │
│    WARN   ← Warnings only                                   │
│      ↓                                                      │
│    ERROR  ← Errors only                                     │
│      ↓                                                      │
│    OFF    ← No logging                                      │
│                                                             │
│  Setting logging.level.root=DEBUG shows:                    │
│    TRACE, DEBUG, INFO, WARN, ERROR                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Logger Usage in Spring Boot

### Creating a Logger

```java
package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class ProductManagerImpl implements ProductManager {

    // Create logger for this class
    private static final Logger logger = LoggerFactory.getLogger(ProductManagerImpl.class);
    
    // ... service methods
}
```

### Key Points About Logger Creation

| Aspect | Details |
|--------|---------|
| **Import** | `org.slf4j.Logger` and `org.slf4j.LoggerFactory` |
| **Static** | `static final` - one per class |
| **Naming** | `logger` (lowercase, conventional) |
| **Parameter** | Pass the class for proper naming in logs |

### Logging Methods

```java
// All available logging methods
logger.trace("Trace level message");
logger.debug("Debug level message");
logger.info("Info level message");
logger.warn("Warning level message");
logger.error("Error level message");

// With parameters (placeholder syntax)
logger.info("Creating product: {}", product);
logger.info("Product {} saved at {}", product.getName(), LocalDateTime.now());

// With exception
try {
    // risky code
} catch (Exception e) {
    logger.error("Failed to process: {}", e.getMessage(), e);
}
```

### Parameter Placeholders `{}`

```
┌─────────────────────────────────────────────────────────────┐
│           Why Use {} Instead of String Concatenation?        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  String Concatenation (BAD):                                │
│    logger.debug("User " + username + " logged in");         │
│    → String is ALWAYS created, even if debug disabled       │
│    → Performance waste                                      │
│                                                             │
│  Placeholder Syntax (GOOD):                                 │
│    logger.debug("User {} logged in", username);             │
│    → String only created if debug is enabled                │
│    → SLF4J handles the substitution                         │
│                                                             │
│  Benefits:                                                  │
│    ✓ Better performance                                     │
│    ✓ Cleaner code                                           │
│    ✓ No isDebugEnabled() check needed                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete REST Application with Logging

### ProductManagerImpl.java

```java
package com.example.demo;

import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ProductManagerImpl implements ProductManager {

    @Autowired
    ProductRepository repository;
    
    private static final Logger logger = LoggerFactory.getLogger(ProductManagerImpl.class);
    
    @Override
    public void addProduct(Product p) {
        logger.info("Creating product: {}", p);
        Product temp = repository.save(p);
        logger.info("Product created successfully: {}", temp);
    }

    @Override
    public List<Product> getProducts() {
        logger.info("Fetching all products");
        List<Product> prodlist = repository.findAll();
        logger.info("Total products found: {}", prodlist.size());
        return prodlist;
    }

    @Override
    public void delete(int id) {
        logger.info("Deleting product with id: {}", id);
        if (repository.existsById(id)) {
            repository.deleteById(id);
            logger.info("Product with id {} deleted successfully", id);
        } else {
            logger.warn("Product with id {} not found to delete", id);
        }
    }

    @Override
    public void update(Product product, int id) {
        logger.info("Updating product with id: {}", id);
        repository.update(
            product.getProname(),
            product.getCategory(),
            product.getPrice(),
            product.getQuantity(),
            id
        );
        logger.info("Updated product with id: {}", id);
    }

    @Override
    public Optional<Product> getProduct(int id) {
        logger.info("Fetching product with id: {}", id);
        Optional<Product> product = repository.findById(id);
        if (product.isPresent()) {
            logger.info("Product found: {}", product.get());
        } else {
            logger.warn("Product with id {} not found", id);
        }
        return product;
    }

    @Override
    public List<Product> getSelected(String cat) {
        logger.info("Fetching products based on category: {}", cat);
        List<Product> prodlist = repository.listCat(cat);
        if (!prodlist.isEmpty()) {
            logger.info("Products found: {}", prodlist.size());
        } else {
            logger.warn("Products with category {} not found", cat);
        }
        return prodlist;
    }
}
```

### Logging Strategy Used

| Method | Log Level | When |
|--------|-----------|------|
| `addProduct` | INFO | Entry and success |
| `getProducts` | INFO | Entry and result count |
| `delete` | INFO + WARN | Success or not found |
| `update` | INFO | Entry and completion |
| `getProduct` | INFO + WARN | Found or not found |
| `getSelected` | INFO + WARN | Results or empty |

---

## Log Output Analysis

### Sample Console Output

```
2024-01-15 10:30:45 [http-nio-8080-exec-1] INFO  c.e.d.ProductManagerImpl - Creating product: Product{id=0, name='Laptop', price=999.0}
2024-01-15 10:30:45 [http-nio-8080-exec-1] INFO  c.e.d.ProductManagerImpl - Product created successfully: Product{id=1, name='Laptop', price=999.0}
2024-01-15 10:30:48 [http-nio-8080-exec-2] INFO  c.e.d.ProductManagerImpl - Fetching all products
2024-01-15 10:30:48 [http-nio-8080-exec-2] INFO  c.e.d.ProductManagerImpl - Total products found: 5
2024-01-15 10:30:52 [http-nio-8080-exec-3] INFO  c.e.d.ProductManagerImpl - Deleting product with id: 99
2024-01-15 10:30:52 [http-nio-8080-exec-3] WARN  c.e.d.ProductManagerImpl - Product with id 99 not found to delete
```

### Understanding the Output

| Part | Meaning |
|------|---------|
| `2024-01-15 10:30:45` | Timestamp |
| `[http-nio-8080-exec-1]` | Thread name (Tomcat worker thread) |
| `INFO` / `WARN` | Log level |
| `c.e.d.ProductManagerImpl` | Shortened class name |
| `Creating product...` | Log message |

---

## Best Practices

### Logging Best Practices

```
┌─────────────────────────────────────────────────────────────┐
│           Logging Best Practices                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Use Appropriate Log Levels                              │
│     DEBUG → Development details                             │
│     INFO  → Business events (user login, order placed)      │
│     WARN  → Recoverable issues (retry, fallback used)       │
│     ERROR → Failures needing attention                      │
│                                                             │
│  2. Use Placeholder Syntax                                  │
│     ✓ logger.info("User {} logged in", username);           │
│     ✗ logger.info("User " + username + " logged in");       │
│                                                             │
│  3. Log at Entry and Exit of Methods                        │
│     logger.info("Starting processOrder for: {}", orderId);  │
│     // ... processing                                       │
│     logger.info("Completed processOrder: {}", result);      │
│                                                             │
│  4. Include Context in Messages                             │
│     ✓ logger.error("Failed to update product id={}", id);   │
│     ✗ logger.error("Update failed");                        │
│                                                             │
│  5. Always Log Exceptions with Stack Trace                  │
│     logger.error("Error: {}", e.getMessage(), e);           │
│                                                             │
│  6. Don't Log Sensitive Data                                │
│     ✗ logger.info("Password: {}", password);                │
│     ✗ logger.info("Credit Card: {}", cardNumber);           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Production vs Development Configuration

```properties
# Development (application-dev.properties)
logging.level.root=DEBUG
logging.level.com.example=TRACE
logging.pattern.console=%d{HH:mm:ss} %-5level %logger{36} - %msg%n

# Production (application-prod.properties)
logging.level.root=WARN
logging.level.com.example=INFO
logging.file.name=/var/log/myapp/application.log
logging.file.max-size=10MB
logging.file.max-history=30
```

---

## Interview Questions

### Q1: What is the difference between SLF4J and Logback?
**Answer**:
- **SLF4J**: API/facade that provides logging methods
- **Logback**: Actual implementation that does the logging
- SLF4J is like JDBC, Logback is like MySQL driver
- Spring Boot uses SLF4J as API with Logback as default implementation

### Q2: What is the default logging framework in Spring Boot?
**Answer**: Spring Boot uses **Logback** as the default implementation with **SLF4J** as the facade. No additional dependencies are needed.

### Q3: How do you create a logger in Spring Boot?
**Answer**:
```java
private static final Logger logger = LoggerFactory.getLogger(MyClass.class);
```
Import `Logger` and `LoggerFactory` from `org.slf4j` package.

### Q4: Why use `{}` placeholder instead of string concatenation?
**Answer**: Performance. With placeholders, string substitution only happens if the log level is enabled. With concatenation, the string is always created even if it won't be logged.

### Q5: How do you configure logging level for a specific package?
**Answer**: In `application.properties`:
```properties
logging.level.com.example.mypackage=DEBUG
```

### Q6: What is the log level hierarchy in Spring Boot?
**Answer**: From most to least verbose:
TRACE > DEBUG > INFO > WARN > ERROR > OFF

Setting a level enables that level and all less verbose levels above it.

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           Spring Boot Logging Summary                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Default Stack:                                             │
│    SLF4J (API) + Logback (Implementation)                   │
│                                                             │
│  Creating Logger:                                           │
│    Logger logger = LoggerFactory.getLogger(MyClass.class);  │
│                                                             │
│  Using Logger:                                              │
│    logger.info("Message with param: {}", value);            │
│    logger.error("Error occurred", exception);               │
│                                                             │
│  Configuration:                                             │
│    logging.level.root=INFO                                  │
│    logging.level.com.example=DEBUG                          │
│    logging.file.name=app.log                                │
│                                                             │
│  Best Practices:                                            │
│    • Use {} placeholders                                    │
│    • Log at appropriate levels                              │
│    • Include context in messages                            │
│    • Never log sensitive data                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Next: [14_Spring_Boot_PDF_Generation.md](./14_Spring_Boot_PDF_Generation.md)*
