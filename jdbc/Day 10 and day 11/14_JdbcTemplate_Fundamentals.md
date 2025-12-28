# JdbcTemplate Fundamentals

## Table of Contents
1. [Introduction](#1-introduction)
2. [What is JdbcTemplate](#2-what-is-jdbctemplate)
3. [Boilerplate Reduction](#3-boilerplate-reduction)
4. [Exception Translation](#4-exception-translation)
5. [Configuration](#5-configuration)
6. [Core Methods](#6-core-methods)
7. [CRUD Operations with Examples](#7-crud-operations-with-examples)
8. [RowMapper Deep Dive](#8-rowmapper-deep-dive)
9. [Complete DAO Example](#9-complete-dao-example)
10. [Execution Flow](#10-execution-flow)
11. [Best Practices](#11-best-practices)
12. [Common Interview Questions](#12-common-interview-questions)
13. [Key Takeaways](#13-key-takeaways)

---

## 1. Introduction

**JdbcTemplate** is a Spring class that simplifies JDBC operations by:
1. Eliminating boilerplate code (connection management, statement creation, resource cleanup)
2. Translating checked `SQLException` to unchecked `DataAccessException`
3. Providing convenient methods for common database operations

> **Key Insight**: JdbcTemplate reduces 25+ lines of JDBC code to 2-3 lines!

---

## 2. What is JdbcTemplate

### The Problem with Traditional JDBC

Traditional JDBC requires handling:
- Connection management
- Statement creation
- ResultSet processing
- Exception handling
- Resource cleanup (closing connections)

### JdbcTemplate Solution

```
┌─────────────────────────────────────────────────────────────┐
│              JDBCTEMPLATE BENEFITS                           │
│                                                              │
│  TRADITIONAL JDBC:                                           │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Connection conn = null;                            │    │
│  │  PreparedStatement ps = null;                       │    │
│  │  ResultSet rs = null;                               │    │
│  │  try {                                              │    │
│  │      conn = dataSource.getConnection();             │    │
│  │      ps = conn.prepareStatement(sql);               │    │
│  │      ps.setInt(1, id);                              │    │
│  │      rs = ps.executeQuery();                        │    │
│  │      // Process results...                          │    │
│  │  } catch (SQLException e) {                         │    │
│  │      // Handle exception                            │    │
│  │  } finally {                                        │    │
│  │      // Close rs, ps, conn (each can throw!)       │    │
│  │  }                                                  │    │
│  └─────────────────────────────────────────────────────┘    │
│                        25+ lines                             │
│                                                              │
│  WITH JDBCTEMPLATE:                                          │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  return jdbcTemplate.queryForObject(sql,            │    │
│  │      new BeanPropertyRowMapper<>(User.class), id);  │    │
│  └─────────────────────────────────────────────────────┘    │
│                         2 lines!                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Boilerplate Reduction

### Without JdbcTemplate (Traditional JDBC)

```java
public User findById(int id) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    User user = null;
    
    try {
        // Step 1: Get connection
        conn = dataSource.getConnection();
        
        // Step 2: Create prepared statement
        ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        ps.setInt(1, id);
        
        // Step 3: Execute query
        rs = ps.executeQuery();
        
        // Step 4: Process result
        if (rs.next()) {
            user = new User();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setEmail(rs.getString("email"));
        }
    } catch (SQLException e) {
        // Step 5: Handle exception
        throw new RuntimeException("Database error", e);
    } finally {
        // Step 6: Close resources (MUST handle each exception!)
        try { if (rs != null) rs.close(); } catch (SQLException e) { /* ignore */ }
        try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignore */ }
        try { if (conn != null) conn.close(); } catch (SQLException e) { /* ignore */ }
    }
    return user;
}
```

### With JdbcTemplate

```java
public User findById(int id) {
    String sql = "SELECT * FROM users WHERE id = ?";
    return jdbcTemplate.queryForObject(sql, 
        new BeanPropertyRowMapper<>(User.class), id);
}
```

**Result: 28 lines → 3 lines!**

---

## 4. Exception Translation

### The Problem with SQLException

```
┌─────────────────────────────────────────────────────────────┐
│              SQLException PROBLEMS                           │
│                                                              │
│  1. CHECKED EXCEPTION                                        │
│     • Must be caught or declared everywhere                 │
│     • Clutters code with try-catch blocks                   │
│                                                              │
│  2. DATABASE-SPECIFIC ERROR CODES                            │
│     • MySQL: Error 1062 (Duplicate key)                     │
│     • Oracle: ORA-00001 (Unique constraint)                 │
│     • PostgreSQL: Error 23505 (Unique violation)            │
│     • Different codes for same error!                       │
│                                                              │
│  3. GENERIC EXCEPTION                                        │
│     • All errors throw same SQLException                    │
│     • Hard to handle specific error types                   │
└─────────────────────────────────────────────────────────────┘
```

### Spring's Solution: DataAccessException Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│              DataAccessException HIERARCHY                   │
│                                                              │
│  DataAccessException (unchecked)                            │
│  ├── NonTransientDataAccessException                        │
│  │   ├── DataIntegrityViolationException                   │
│  │   │   └── DuplicateKeyException                         │
│  │   ├── DataRetrievalFailureException                     │
│  │   │   └── EmptyResultDataAccessException                │
│  │   └── PermissionDeniedDataAccessException               │
│  │                                                          │
│  ├── TransientDataAccessException                           │
│  │   └── CannotGetJdbcConnectionException                  │
│  │                                                          │
│  └── UncategorizedDataAccessException                       │
│                                                              │
│  BENEFITS:                                                   │
│  ✅ Unchecked - no try-catch required                       │
│  ✅ Consistent across all databases                         │
│  ✅ Specific exception types for different errors           │
└─────────────────────────────────────────────────────────────┘
```

### Example: Handling Specific Exceptions

```java
try {
    userDao.insert(user);
} catch (DuplicateKeyException e) {
    // Handle duplicate email
    throw new EmailAlreadyExistsException(user.getEmail());
} catch (DataIntegrityViolationException e) {
    // Handle constraint violation
    throw new InvalidDataException("Data constraint violated");
} catch (DataAccessException e) {
    // Handle any other database error
    throw new DatabaseException("Database operation failed");
}
```

---

## 5. Configuration

### XML Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="...">

    <!-- DataSource Configuration -->
    <bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource"
          destroy-method="close">
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mydb"/>
        <property name="username" value="root"/>
        <property name="password" value="password"/>
        
        <!-- Connection pool settings -->
        <property name="initialSize" value="5"/>
        <property name="maxTotal" value="10"/>
    </bean>

    <!-- JdbcTemplate Bean -->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <property name="dataSource" ref="dataSource"/>
    </bean>

</beans>
```

### Java Configuration

```java
@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        BasicDataSource ds = new BasicDataSource();
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost:3306/mydb");
        ds.setUsername("root");
        ds.setPassword("password");
        ds.setInitialSize(5);
        ds.setMaxTotal(10);
        return ds;
    }

    @Bean
    public JdbcTemplate jdbcTemplate(DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }
}
```

### Spring Boot (Auto-configured)

```properties
# application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

```java
@Repository
public class UserDao {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;  // Auto-injected by Spring Boot
}
```

---

## 6. Core Methods

### Method Reference Table

| Method | Purpose | Returns |
|--------|---------|---------|
| `update(sql, args...)` | INSERT, UPDATE, DELETE | int (affected rows) |
| `query(sql, rowMapper, args...)` | SELECT multiple rows | List<T> |
| `queryForObject(sql, rowMapper, args...)` | SELECT single row | T |
| `queryForList(sql, args...)` | SELECT as List<Map> | List<Map<String, Object>> |
| `queryForMap(sql, args...)` | SELECT single row as Map | Map<String, Object> |
| `execute(sql)` | DDL statements | void |
| `batchUpdate(sql, batchArgs)` | Batch operations | int[] |

### Method Details

```
┌─────────────────────────────────────────────────────────────┐
│              JDBCTEMPLATE CORE METHODS                       │
│                                                              │
│  update(String sql, Object... args)                         │
│  ├── Used for: INSERT, UPDATE, DELETE                       │
│  ├── Returns: Number of affected rows                       │
│  └── Example: update("DELETE FROM users WHERE id=?", 1)    │
│                                                              │
│  query(String sql, RowMapper<T> rm, Object... args)         │
│  ├── Used for: SELECT returning multiple rows               │
│  ├── Returns: List<T>                                       │
│  └── Example: query("SELECT * FROM users", rowMapper)       │
│                                                              │
│  queryForObject(String sql, RowMapper<T> rm, Object... args)│
│  ├── Used for: SELECT returning exactly one row             │
│  ├── Returns: T                                             │
│  ├── Throws: EmptyResultDataAccessException if no rows      │
│  └── Throws: IncorrectResultSizeException if > 1 row        │
│                                                              │
│  batchUpdate(String sql, List<Object[]> batchArgs)          │
│  ├── Used for: Bulk INSERT, UPDATE, DELETE                  │
│  └── Returns: int[] (affected rows per statement)           │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. CRUD Operations with Examples

### CREATE (INSERT)

```java
/**
 * Insert a new user
 * @return Number of rows affected (1 if successful)
 */
public int insert(User user) {
    String sql = "INSERT INTO users (name, email, created_at) VALUES (?, ?, ?)";
    return jdbcTemplate.update(sql, 
        user.getName(), 
        user.getEmail(), 
        new java.sql.Timestamp(System.currentTimeMillis())
    );
}

/**
 * Insert and get generated ID
 * Using KeyHolder to retrieve auto-generated primary key
 */
public int insertAndGetId(User user) {
    String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
    
    KeyHolder keyHolder = new GeneratedKeyHolder();
    
    jdbcTemplate.update(connection -> {
        PreparedStatement ps = connection.prepareStatement(sql, 
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, user.getName());
        ps.setString(2, user.getEmail());
        return ps;
    }, keyHolder);
    
    return keyHolder.getKey().intValue();  // Returns generated ID
}
```

### READ (SELECT)

```java
/**
 * Find user by ID
 * @throws EmptyResultDataAccessException if not found
 */
public User findById(int id) {
    String sql = "SELECT * FROM users WHERE id = ?";
    return jdbcTemplate.queryForObject(sql, 
        new BeanPropertyRowMapper<>(User.class), id);
}

/**
 * Find user by ID (null if not found)
 */
public User findByIdOrNull(int id) {
    String sql = "SELECT * FROM users WHERE id = ?";
    try {
        return jdbcTemplate.queryForObject(sql, 
            new BeanPropertyRowMapper<>(User.class), id);
    } catch (EmptyResultDataAccessException e) {
        return null;  // Not found
    }
}

/**
 * Find all users
 */
public List<User> findAll() {
    String sql = "SELECT * FROM users ORDER BY name";
    return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
}

/**
 * Find users by name (LIKE query)
 */
public List<User> findByName(String name) {
    String sql = "SELECT * FROM users WHERE name LIKE ?";
    return jdbcTemplate.query(sql, 
        new BeanPropertyRowMapper<>(User.class), 
        "%" + name + "%");
}

/**
 * Count total users
 */
public int count() {
    String sql = "SELECT COUNT(*) FROM users";
    return jdbcTemplate.queryForObject(sql, Integer.class);
}
```

### UPDATE

```java
/**
 * Update user details
 * @return Number of rows affected
 */
public int update(User user) {
    String sql = "UPDATE users SET name = ?, email = ? WHERE id = ?";
    return jdbcTemplate.update(sql, 
        user.getName(), 
        user.getEmail(), 
        user.getId()
    );
}

/**
 * Update multiple fields conditionally
 */
public int updateEmail(int userId, String newEmail) {
    String sql = "UPDATE users SET email = ?, updated_at = ? WHERE id = ?";
    return jdbcTemplate.update(sql, 
        newEmail, 
        new java.sql.Timestamp(System.currentTimeMillis()),
        userId
    );
}
```

### DELETE

```java
/**
 * Delete user by ID
 * @return Number of rows affected (1 if deleted, 0 if not found)
 */
public int delete(int id) {
    String sql = "DELETE FROM users WHERE id = ?";
    return jdbcTemplate.update(sql, id);
}

/**
 * Delete all users (use with caution!)
 */
public int deleteAll() {
    String sql = "DELETE FROM users";
    return jdbcTemplate.update(sql);
}

/**
 * Delete users by condition
 */
public int deleteInactive() {
    String sql = "DELETE FROM users WHERE last_login < ?";
    // Delete users inactive for 1 year
    long oneYearAgo = System.currentTimeMillis() - (365L * 24 * 60 * 60 * 1000);
    return jdbcTemplate.update(sql, new java.sql.Timestamp(oneYearAgo));
}
```

---

## 8. RowMapper Deep Dive

### What is RowMapper?

`RowMapper` is an interface that maps each row of `ResultSet` to an object.

```java
@FunctionalInterface
public interface RowMapper<T> {
    T mapRow(ResultSet rs, int rowNum) throws SQLException;
}
```

### Option 1: BeanPropertyRowMapper (Automatic)

```java
// Automatic mapping - column names must match property names
// Column: user_name → Property: userName (camelCase conversion)
RowMapper<User> rowMapper = new BeanPropertyRowMapper<>(User.class);

List<User> users = jdbcTemplate.query(sql, rowMapper);
```

**Requirements:**
- Bean must have no-arg constructor
- Column names should match property names (with underscore to camelCase conversion)

### Option 2: Custom RowMapper (Anonymous Class)

```java
RowMapper<User> rowMapper = new RowMapper<User>() {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Can do custom logic
        user.setActive(rs.getInt("status") == 1);
        
        return user;
    }
};

List<User> users = jdbcTemplate.query(sql, rowMapper);
```

### Option 3: Lambda Expression (Java 8+)

```java
List<User> users = jdbcTemplate.query(sql, (rs, rowNum) -> {
    User user = new User();
    user.setId(rs.getInt("id"));
    user.setName(rs.getString("name"));
    user.setEmail(rs.getString("email"));
    return user;
});
```

### Option 4: Method Reference

```java
public class UserRowMapper implements RowMapper<User> {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("email")
        );
    }
}

// Usage
List<User> users = jdbcTemplate.query(sql, new UserRowMapper());
```

---

## 9. Complete DAO Example

### User.java (Entity)

```java
public class User {
    private int id;
    private String name;
    private String email;
    private java.sql.Timestamp createdAt;
    private boolean active;
    
    // Constructors
    public User() {}
    
    public User(int id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }
    
    // Getters and Setters
    // ... (standard getters/setters)
    
    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', email='" + email + "'}";
    }
}
```

### UserDao.java (Complete Repository)

```java
package mypack.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDao {
    
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public UserDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    // ==================== CREATE ====================
    
    public int insert(User user) {
        String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
        return jdbcTemplate.update(sql, user.getName(), user.getEmail());
    }
    
    public int insertAndGetId(User user) {
        String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(conn -> {
            PreparedStatement ps = conn.prepareStatement(sql, 
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().intValue();
    }
    
    // ==================== READ ====================
    
    public Optional<User> findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            User user = jdbcTemplate.queryForObject(sql, 
                new BeanPropertyRowMapper<>(User.class), id);
            return Optional.ofNullable(user);
        } catch (EmptyResultDataAccessException e) {
            return Optional.empty();
        }
    }
    
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY id";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(User.class));
    }
    
    public List<User> findByName(String name) {
        String sql = "SELECT * FROM users WHERE name LIKE ?";
        return jdbcTemplate.query(sql, 
            new BeanPropertyRowMapper<>(User.class), "%" + name + "%");
    }
    
    public int count() {
        String sql = "SELECT COUNT(*) FROM users";
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
    
    public boolean existsById(int id) {
        String sql = "SELECT COUNT(*) FROM users WHERE id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }
    
    // ==================== UPDATE ====================
    
    public int update(User user) {
        String sql = "UPDATE users SET name = ?, email = ? WHERE id = ?";
        return jdbcTemplate.update(sql, 
            user.getName(), user.getEmail(), user.getId());
    }
    
    // ==================== DELETE ====================
    
    public int delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }
    
    public int deleteAll() {
        return jdbcTemplate.update("DELETE FROM users");
    }
}
```

---

## 10. Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│              JDBCTEMPLATE EXECUTION FLOW                     │
│                                                              │
│  Client: userDao.findById(1)                                │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 1: JdbcTemplate receives request              │    │
│  │  sql = "SELECT * FROM users WHERE id = ?"           │    │
│  │  args = [1]                                          │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 2: Get Connection from DataSource             │    │
│  │  (Connection pooling handles this efficiently)      │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 3: Create PreparedStatement                   │    │
│  │  • Prepares SQL with placeholders                   │    │
│  │  • Sets parameter: ps.setInt(1, 1)                  │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 4: Execute Query                              │    │
│  │  • Sends SQL to database                            │    │
│  │  • Database returns ResultSet                       │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 5: Map ResultSet to Object                    │    │
│  │  • RowMapper.mapRow(rs, 0) called                   │    │
│  │  • Creates User object from row data                │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 6: Resource Cleanup (Automatic!)              │    │
│  │  • Close ResultSet                                  │    │
│  │  • Close PreparedStatement                          │    │
│  │  • Return Connection to pool                        │    │
│  └─────────────────────────────────────────────────────┘    │
│              │                                               │
│              ▼                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Step 7: Return User object to client               │    │
│  │                                                      │    │
│  │  If SQLException occurs at any step:                │    │
│  │  → Translated to DataAccessException                │    │
│  │  → Resources still cleaned up properly              │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. Best Practices

### ✅ Do This

```java
// Use constructor injection
@Repository
public class UserDao {
    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public UserDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
}

// Use parameterized queries (prevent SQL injection)
String sql = "SELECT * FROM users WHERE name = ?";
jdbcTemplate.query(sql, rowMapper, name);

// Use Optional for nullable results
public Optional<User> findById(int id) {
    try {
        return Optional.ofNullable(
            jdbcTemplate.queryForObject(sql, rowMapper, id));
    } catch (EmptyResultDataAccessException e) {
        return Optional.empty();
    }
}

// Use BeanPropertyRowMapper for simple cases
new BeanPropertyRowMapper<>(User.class);
```

### ❌ Avoid This

```java
// DON'T: String concatenation (SQL Injection risk!)
String sql = "SELECT * FROM users WHERE name = '" + name + "'";

// DON'T: Create JdbcTemplate per method
public void method() {
    JdbcTemplate jt = new JdbcTemplate(dataSource);  // Wasteful!
}

// DON'T: Catch and ignore exceptions
try {
    jdbcTemplate.update(sql);
} catch (Exception e) {
    // Silent failure - BAD!
}
```

---

## 12. Common Interview Questions

### Q1: What is JdbcTemplate?
**A:** JdbcTemplate is a Spring class that simplifies JDBC operations by handling connection management, statement creation, exception handling, and resource cleanup automatically.

### Q2: What are the advantages of JdbcTemplate?
**A:**
1. Eliminates boilerplate code (25+ lines → 2-3 lines)
2. Automatic resource management
3. Translates SQLException to unchecked DataAccessException
4. Consistent exception handling across databases
5. Easy integration with connection pooling

### Q3: What is RowMapper?
**A:** RowMapper is an interface that maps each row of ResultSet to a Java object. The `mapRow(ResultSet rs, int rowNum)` method is called for each row.

### Q4: Difference between query() and queryForObject()?
**A:**
- `query()` - Returns List<T>, for multiple rows
- `queryForObject()` - Returns single T, throws exception if not exactly 1 row

### Q5: What exception is thrown if queryForObject finds no rows?
**A:** `EmptyResultDataAccessException`

### Q6: What is BeanPropertyRowMapper?
**A:** Automatic RowMapper that maps columns to bean properties by name, with underscore-to-camelCase conversion.

---

## 13. Key Takeaways

📌 **JdbcTemplate** eliminates JDBC boilerplate (25+ → 2 lines)

📌 **SQLException** → **DataAccessException** (unchecked)

📌 **update()** for INSERT, UPDATE, DELETE

📌 **query()** for SELECT returning List

📌 **queryForObject()** for single row (throws if not exactly 1)

📌 **RowMapper** converts ResultSet rows to objects

📌 **BeanPropertyRowMapper** for automatic mapping

📌 Always use **parameterized queries** (prevent SQL injection)

📌 Use **constructor injection** for JdbcTemplate

---

*Previous: [13. AOP with Annotations](./13_AOP_with_Annotations.md)*

*Next: [15. Advanced JDBC Templates](./15_Advanced_JDBC_Templates.md)*
