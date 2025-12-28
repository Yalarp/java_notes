# Advanced JDBC Templates

## Table of Contents
1. [Introduction](#1-introduction)
2. [NamedParameterJdbcTemplate](#2-namedparameterjdbctemplate)
3. [SimpleJdbcInsert](#3-simplejdbcinsert)
4. [SimpleJdbcCall](#4-simplejdbccall)
5. [Batch Operations](#5-batch-operations)
6. [RowMapper vs ResultSetExtractor](#6-rowmapper-vs-resultsetextractor)
7. [Complete Code Examples](#7-complete-code-examples)
8. [When to Use What](#8-when-to-use-what)
9. [Common Interview Questions](#9-common-interview-questions)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Introduction

Beyond basic `JdbcTemplate`, Spring provides advanced templates for specific use cases:

| Template | Purpose |
|----------|---------|
| **NamedParameterJdbcTemplate** | Named parameters instead of `?` |
| **SimpleJdbcInsert** | INSERT without writing SQL |
| **SimpleJdbcCall** | Call stored procedures |
| **BatchUpdate** | Bulk operations |

---

## 2. NamedParameterJdbcTemplate

### What is it?

Uses **named parameters** (`:paramName`) instead of positional `?` placeholders.

### Problem with JdbcTemplate

```java
// Hard to read with many parameters
String sql = "UPDATE users SET name=?, email=?, phone=?, address=?, city=? WHERE id=?";
jdbcTemplate.update(sql, name, email, phone, address, city, id);
// Which ? is which? Easy to mix up order!
```

### Solution: Named Parameters

```java
// Clear and readable
String sql = "UPDATE users SET name=:name, email=:email, phone=:phone WHERE id=:id";
// Order doesn't matter, names are explicit
```

### Configuration

```java
@Configuration
public class DatabaseConfig {

    @Bean
    public NamedParameterJdbcTemplate namedParameterJdbcTemplate(DataSource ds) {
        return new NamedParameterJdbcTemplate(ds);
    }
}
```

### MapSqlParameterSource

```java
@Repository
public class UserDao {
    
    @Autowired
    private NamedParameterJdbcTemplate namedTemplate;
    
    public User findByNameAndEmail(String name, String email) {
        String sql = "SELECT * FROM users WHERE name = :name AND email = :email";
        
        // Create parameter source
        MapSqlParameterSource params = new MapSqlParameterSource();
        params.addValue("name", name);
        params.addValue("email", email);
        
        return namedTemplate.queryForObject(sql, params,
            new BeanPropertyRowMapper<>(User.class));
    }
    
    public int updateUser(User user) {
        String sql = "UPDATE users SET name = :name, email = :email WHERE id = :id";
        
        MapSqlParameterSource params = new MapSqlParameterSource()
            .addValue("id", user.getId())
            .addValue("name", user.getName())
            .addValue("email", user.getEmail());
        
        return namedTemplate.update(sql, params);
    }
}
```

### BeanPropertySqlParameterSource

```java
/**
 * Automatically extracts parameters from bean properties
 * Property names must match parameter names in SQL
 */
public int insertUser(User user) {
    String sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
    
    // Automatically uses user.getName() for :name, user.getEmail() for :email
    BeanPropertySqlParameterSource params = new BeanPropertySqlParameterSource(user);
    
    return namedTemplate.update(sql, params);
}
```

### Using Map<String, Object>

```java
public int insertWithMap(String name, String email) {
    String sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
    
    Map<String, Object> params = new HashMap<>();
    params.put("name", name);
    params.put("email", email);
    
    return namedTemplate.update(sql, params);
}
```

### Comparison Diagram

```
┌─────────────────────────────────────────────────────────────┐
│     JdbcTemplate vs NamedParameterJdbcTemplate              │
│                                                              │
│  JdbcTemplate:                                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  sql = "SELECT * FROM users WHERE name=? AND age=?" │    │
│  │  jdbcTemplate.query(sql, rowMapper, name, age)      │    │
│  │                                     ↑    ↑          │    │
│  │                                     │    │          │    │
│  │  Position matters! Wrong order = Wrong data!        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  NamedParameterJdbcTemplate:                                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  sql = "SELECT * FROM users WHERE name=:name..."    │    │
│  │  params.put("age", 25);  // Order doesn't matter!   │    │
│  │  params.put("name", "John");                        │    │
│  │  namedTemplate.query(sql, params, rowMapper)        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  Benefits of Named Parameters:                               │
│  ✅ Self-documenting code                                   │
│  ✅ Order-independent                                       │
│  ✅ Same parameter can be used multiple times               │
│  ✅ Easier to maintain                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. SimpleJdbcInsert

### What is it?

Simplifies INSERT operations - **no SQL needed!** Automatically generates INSERT statement from table metadata.

### Configuration

```java
@Repository
public class UserDao {
    
    private SimpleJdbcInsert simpleJdbcInsert;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.simpleJdbcInsert = new SimpleJdbcInsert(dataSource)
            .withTableName("users")
            .usingGeneratedKeyColumns("id");  // For auto-increment
    }
}
```

### Basic Insert

```java
public void insert(User user) {
    Map<String, Object> params = new HashMap<>();
    params.put("name", user.getName());
    params.put("email", user.getEmail());
    params.put("created_at", new java.sql.Timestamp(System.currentTimeMillis()));
    
    // Executes: INSERT INTO users (name, email, created_at) VALUES (?, ?, ?)
    simpleJdbcInsert.execute(params);
}
```

### Insert and Get Generated Key

```java
public User insertAndGetId(User user) {
    Map<String, Object> params = new HashMap<>();
    params.put("name", user.getName());
    params.put("email", user.getEmail());
    
    // Returns the auto-generated ID
    Number newId = simpleJdbcInsert.executeAndReturnKey(params);
    user.setId(newId.intValue());
    
    return user;
}
```

### Specify Columns Explicitly

```java
public void configureInsert(DataSource dataSource) {
    this.simpleJdbcInsert = new SimpleJdbcInsert(dataSource)
        .withTableName("users")
        .usingColumns("name", "email")  // Only these columns
        .usingGeneratedKeyColumns("id");
}
```

### Using BeanPropertySqlParameterSource

```java
public int insertFromBean(User user) {
    SqlParameterSource params = new BeanPropertySqlParameterSource(user);
    return simpleJdbcInsert.execute(params);
}
```

---

## 4. SimpleJdbcCall

### What is it?

Simplifies calling **stored procedures** and **functions**.

### Calling a Stored Procedure

```sql
-- MySQL stored procedure
DELIMITER //
CREATE PROCEDURE get_user_by_id(IN user_id INT)
BEGIN
    SELECT * FROM users WHERE id = user_id;
END //
DELIMITER ;
```

```java
@Repository
public class UserDao {
    
    private SimpleJdbcCall simpleJdbcCall;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.simpleJdbcCall = new SimpleJdbcCall(dataSource)
            .withProcedureName("get_user_by_id")
            .returningResultSet("users", 
                new BeanPropertyRowMapper<>(User.class));
    }
    
    public List<User> getUserById(int id) {
        SqlParameterSource params = new MapSqlParameterSource()
            .addValue("user_id", id);
        
        Map<String, Object> result = simpleJdbcCall.execute(params);
        
        @SuppressWarnings("unchecked")
        List<User> users = (List<User>) result.get("users");
        return users;
    }
}
```

### Calling a Function

```sql
-- MySQL function
CREATE FUNCTION count_users() RETURNS INT
BEGIN
    DECLARE user_count INT;
    SELECT COUNT(*) INTO user_count FROM users;
    RETURN user_count;
END;
```

```java
public int countUsers() {
    SimpleJdbcCall call = new SimpleJdbcCall(dataSource)
        .withFunctionName("count_users");
    
    return call.executeFunction(Integer.class);
}
```

---

## 5. Batch Operations

### Why Batch?

```
┌─────────────────────────────────────────────────────────────┐
│              BATCH vs INDIVIDUAL INSERTS                     │
│                                                              │
│  INDIVIDUAL INSERTS (1000 rows):                            │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Loop 1000 times:                                   │    │
│  │    1. Get connection                                │    │
│  │    2. Prepare statement                             │    │
│  │    3. Execute INSERT                                │    │
│  │    4. Close resources                               │    │
│  │                                                      │    │
│  │  Result: 1000 database round-trips                  │    │
│  │  Time: ~5-10 seconds                                │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  BATCH INSERT (1000 rows):                                   │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  1. Get connection                                  │    │
│  │  2. Prepare statement                               │    │
│  │  3. Add 1000 rows to batch                          │    │
│  │  4. Execute batch (single round-trip)               │    │
│  │  5. Close resources                                 │    │
│  │                                                      │    │
│  │  Result: 1 database round-trip                      │    │
│  │  Time: ~0.1-0.5 seconds                             │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  Batch is 10-100x faster!                                   │
└─────────────────────────────────────────────────────────────┘
```

### JdbcTemplate Batch Update

```java
public int[] batchInsert(List<User> users) {
    String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
    
    return jdbcTemplate.batchUpdate(sql, new BatchPreparedStatementSetter() {
        @Override
        public void setValues(PreparedStatement ps, int i) throws SQLException {
            User user = users.get(i);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
        }
        
        @Override
        public int getBatchSize() {
            return users.size();
        }
    });
}
```

### NamedParameterJdbcTemplate Batch Update

```java
public int[] batchInsertNamed(List<User> users) {
    String sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
    
    SqlParameterSource[] batch = SqlParameterSourceUtils
        .createBatch(users.toArray());
    
    return namedTemplate.batchUpdate(sql, batch);
}
```

### Batch with List of Object Arrays

```java
public int[] batchInsertSimple(List<User> users) {
    String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
    
    List<Object[]> batchArgs = new ArrayList<>();
    for (User user : users) {
        batchArgs.add(new Object[] { user.getName(), user.getEmail() });
    }
    
    return jdbcTemplate.batchUpdate(sql, batchArgs);
}
```

---

## 6. RowMapper vs ResultSetExtractor

### RowMapper

- Called **once per row**
- Returns **single object** per row
- JdbcTemplate collects into List

```java
public List<User> findAllWithRowMapper() {
    return jdbcTemplate.query(
        "SELECT * FROM users",
        (rs, rowNum) -> new User(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("email")
        )
    );
}
```

### ResultSetExtractor

- Called **once for entire ResultSet**
- Returns **any data structure**
- Used for complex aggregations

```java
public Map<Integer, List<Order>> getOrdersByCustomer() {
    String sql = "SELECT * FROM orders";
    
    return jdbcTemplate.query(sql, 
        new ResultSetExtractor<Map<Integer, List<Order>>>() {
            @Override
            public Map<Integer, List<Order>> extractData(ResultSet rs) 
                    throws SQLException {
                Map<Integer, List<Order>> map = new HashMap<>();
                
                while (rs.next()) {
                    int customerId = rs.getInt("customer_id");
                    Order order = new Order(
                        rs.getInt("id"),
                        rs.getString("product")
                    );
                    
                    map.computeIfAbsent(customerId, k -> new ArrayList<>())
                       .add(order);
                }
                return map;
            }
        }
    );
}
```

### Comparison

```
┌─────────────────────────────────────────────────────────────┐
│           RowMapper vs ResultSetExtractor                    │
│                                                              │
│  RowMapper:                                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  • Called: Once PER ROW                             │    │
│  │  • Returns: Single object                           │    │
│  │  • JdbcTemplate: Collects into List<T>             │    │
│  │  • Use for: Simple row-to-object mapping            │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ResultSetExtractor:                                         │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  • Called: Once for ENTIRE ResultSet                │    │
│  │  • Returns: Any type (List, Map, custom)            │    │
│  │  • You control: The iteration                       │    │
│  │  • Use for: Complex aggregations, grouping          │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  Example Results:                                            │
│                                                              │
│  RowMapper → List<User>                                      │
│  ResultSetExtractor → Map<Integer, List<Order>>              │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Complete Code Examples

### UserDao with All Templates

```java
package mypack.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.*;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.*;

@Repository
public class UserDao {
    
    private final JdbcTemplate jdbcTemplate;
    private final NamedParameterJdbcTemplate namedTemplate;
    private SimpleJdbcInsert simpleJdbcInsert;
    
    @Autowired
    public UserDao(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.namedTemplate = new NamedParameterJdbcTemplate(dataSource);
        this.simpleJdbcInsert = new SimpleJdbcInsert(dataSource)
            .withTableName("users")
            .usingGeneratedKeyColumns("id");
    }
    
    // ==================== JdbcTemplate ====================
    
    public List<User> findAll() {
        return jdbcTemplate.query("SELECT * FROM users",
            new BeanPropertyRowMapper<>(User.class));
    }
    
    // ==================== NamedParameterJdbcTemplate ====================
    
    public User findByNameAndEmail(String name, String email) {
        String sql = "SELECT * FROM users WHERE name = :name AND email = :email";
        
        MapSqlParameterSource params = new MapSqlParameterSource()
            .addValue("name", name)
            .addValue("email", email);
        
        return namedTemplate.queryForObject(sql, params,
            new BeanPropertyRowMapper<>(User.class));
    }
    
    // ==================== SimpleJdbcInsert ====================
    
    public int insertAndGetId(User user) {
        Map<String, Object> params = new HashMap<>();
        params.put("name", user.getName());
        params.put("email", user.getEmail());
        
        Number newId = simpleJdbcInsert.executeAndReturnKey(params);
        return newId.intValue();
    }
    
    // ==================== Batch Operations ====================
    
    public int[] batchInsert(List<User> users) {
        String sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
        
        SqlParameterSource[] batch = SqlParameterSourceUtils
            .createBatch(users.toArray());
        
        return namedTemplate.batchUpdate(sql, batch);
    }
}
```

---

## 8. When to Use What

| Scenario | Use This |
|----------|----------|
| Simple CRUD | `JdbcTemplate` |
| Multiple parameters | `NamedParameterJdbcTemplate` |
| Same parameter twice | `NamedParameterJdbcTemplate` |
| INSERT without SQL | `SimpleJdbcInsert` |
| Get generated ID | `SimpleJdbcInsert` |
| Stored procedures | `SimpleJdbcCall` |
| Bulk inserts | `batchUpdate()` |
| Simple row mapping | `RowMapper` |
| Complex aggregations | `ResultSetExtractor` |

---

## 9. Common Interview Questions

### Q1: Difference between JdbcTemplate and NamedParameterJdbcTemplate?
**A:**
- JdbcTemplate uses `?` placeholders (positional)
- NamedParameterJdbcTemplate uses `:name` (named)
- Named parameters are more readable and order-independent

### Q2: What is SimpleJdbcInsert?
**A:** Helper class for INSERT operations. Generates SQL from table metadata, no SQL writing needed. Can return generated keys.

### Q3: RowMapper vs ResultSetExtractor?
**A:**
- RowMapper: Called per row, returns single object
- ResultSetExtractor: Called once, manually iterate, returns any structure

### Q4: Why use batch operations?
**A:** Performance - batch operations make one database round-trip instead of one per row. Can be 10-100x faster for bulk inserts.

### Q5: What is MapSqlParameterSource?
**A:** Parameter holder for NamedParameterJdbcTemplate. Provides named parameters via `addValue("name", value)`.

### Q6: What is BeanPropertySqlParameterSource?
**A:** Automatically extracts parameters from bean properties. Property names must match SQL parameter names.

---

## 10. Key Takeaways

📌 **NamedParameterJdbcTemplate** uses `:name` instead of `?`

📌 **MapSqlParameterSource** for named parameter values

📌 **BeanPropertySqlParameterSource** extracts from bean properties

📌 **SimpleJdbcInsert** - INSERT without SQL

📌 **SimpleJdbcCall** - call stored procedures

📌 **batchUpdate()** - bulk operations (10-100x faster)

📌 **RowMapper** - one object per row

📌 **ResultSetExtractor** - entire ResultSet, any structure

📌 Use named parameters for **complex queries**

📌 Use batch for **bulk operations**

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────┐
│           ADVANCED JDBC TEMPLATES REFERENCE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  NamedParameterJdbcTemplate:                                 │
│  sql = "SELECT * FROM users WHERE name = :name"             │
│  params.addValue("name", "John")                            │
│  namedTemplate.query(sql, params, rowMapper)                │
│                                                              │
│  SimpleJdbcInsert:                                           │
│  new SimpleJdbcInsert(dataSource)                           │
│     .withTableName("users")                                 │
│     .usingGeneratedKeyColumns("id")                         │
│  Number id = simpleJdbcInsert.executeAndReturnKey(params)   │
│                                                              │
│  Batch:                                                      │
│  SqlParameterSource[] batch = SqlParameterSourceUtils       │
│     .createBatch(users.toArray())                           │
│  namedTemplate.batchUpdate(sql, batch)                      │
│                                                              │
│  ResultSetExtractor (complex):                               │
│  jdbcTemplate.query(sql, rs -> {                            │
│     while (rs.next()) { ... }                               │
│     return result;                                          │
│  })                                                          │
└─────────────────────────────────────────────────────────────┘
```

---

*Previous: [14. JdbcTemplate Fundamentals](./14_JdbcTemplate_Fundamentals.md)*

*Next: [16. HibernateTemplate Integration](./16_HibernateTemplate_Integration.md)*
