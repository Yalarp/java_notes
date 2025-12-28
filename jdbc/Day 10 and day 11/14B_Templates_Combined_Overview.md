# Spring Templates Overview

## Table of Contents
1. [Introduction](#1-introduction)
2. [What are Spring Templates](#2-what-are-spring-templates)
3. [JdbcTemplate](#3-jdbctemplate)
4. [NamedParameterJdbcTemplate](#4-namedparameterjdbctemplate)
5. [SimpleJdbcInsert](#5-simplejdbcinsert)
6. [HibernateTemplate](#6-hibernatetemplate)
7. [Comparison of Templates](#7-comparison-of-templates)
8. [Common Interview Questions](#8-common-interview-questions)
9. [Key Takeaways](#9-key-takeaways)

---

## 1. Introduction

**Spring Templates** are helper classes that simplify common tasks in database operations. They eliminate boilerplate code and handle resource management automatically.

> **Key Benefit**: Templates reduce JDBC/ORM code from 20+ lines to just 1-2 lines!

---

## 2. What are Spring Templates

### Purpose of Templates

Spring templates serve two main purposes:

1. **Boilerplate Reduction**: Eliminate repetitive code
2. **Exception Translation**: Convert checked exceptions to unchecked exceptions

```
┌─────────────────────────────────────────────────────────────┐
│              WITHOUT TEMPLATE vs WITH TEMPLATE               │
│                                                              │
│   WITHOUT TEMPLATE (Traditional JDBC):                       │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  Connection conn = null;                             │   │
│   │  PreparedStatement ps = null;                        │   │
│   │  ResultSet rs = null;                                │   │
│   │  try {                                               │   │
│   │      conn = dataSource.getConnection();              │   │
│   │      ps = conn.prepareStatement("SELECT * FROM...");│   │
│   │      rs = ps.executeQuery();                         │   │
│   │      while(rs.next()) {                              │   │
│   │          // process results                          │   │
│   │      }                                               │   │
│   │  } catch (SQLException e) {                          │   │
│   │      // handle exception                             │   │
│   │  } finally {                                         │   │
│   │      if(rs != null) rs.close();                      │   │
│   │      if(ps != null) ps.close();                      │   │
│   │      if(conn != null) conn.close();                  │   │
│   │  }                                                   │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   WITH TEMPLATE (JdbcTemplate):                              │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  List<User> users = jdbcTemplate.query(              │   │
│   │      "SELECT * FROM users",                          │   │
│   │      new BeanPropertyRowMapper<>(User.class)         │   │
│   │  );                                                  │   │
│   └─────────────────────────────────────────────────────┘   │
│                                                              │
│   ✅ No connection management                                │
│   ✅ No exception handling                                   │
│   ✅ No resource cleanup                                     │
└─────────────────────────────────────────────────────────────┘
```

### Exception Translation

```
┌─────────────────────────────────────────────────────────────┐
│                EXCEPTION TRANSLATION                         │
│                                                              │
│   JDBC throws: SQLException (CHECKED exception)             │
│                     │                                        │
│                     ▼                                        │
│   Template converts to: DataAccessException (UNCHECKED)     │
│                                                              │
│   BENEFITS:                                                  │
│   ✅ No try-catch required in calling code                  │
│   ✅ Consistent exception hierarchy across all DAO          │
│   ✅ Database-agnostic exceptions                           │
│                                                              │
│   DataAccessException Hierarchy:                             │
│   ┌─────────────────────────────────────────────────────┐   │
│   │  DataAccessException (Root)                          │   │
│   │  ├── EmptyResultDataAccessException                  │   │
│   │  ├── DuplicateKeyException                           │   │
│   │  ├── DataIntegrityViolationException                 │   │
│   │  └── CannotGetJdbcConnectionException                │   │
│   └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. JdbcTemplate

### What is JdbcTemplate?

`JdbcTemplate` is the core class for JDBC operations. It executes SQL queries, updates, and stored procedures.

### Common Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `update()` | INSERT, UPDATE, DELETE | `update("DELETE FROM users WHERE id=?", id)` |
| `query()` | SELECT returning list | `query("SELECT * FROM users", rowMapper)` |
| `queryForObject()` | SELECT single row | `queryForObject("SELECT * FROM users WHERE id=?", rowMapper, id)` |
| `queryForList()` | SELECT returning List<Map> | `queryForList("SELECT * FROM users")` |
| `execute()` | DDL statements | `execute("CREATE TABLE...")` |

### Code Example

```java
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.BeanPropertyRowMapper;

@Repository
public class UserDAO {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // INSERT
    public int insert(User user) {
        String sql = "INSERT INTO users (name, email) VALUES (?, ?)";
        return jdbcTemplate.update(sql, user.getName(), user.getEmail());
    }
    
    // SELECT ALL
    public List<User> findAll() {
        String sql = "SELECT * FROM users";
        return jdbcTemplate.query(sql, 
            new BeanPropertyRowMapper<>(User.class));
    }
    
    // SELECT BY ID
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, 
            new BeanPropertyRowMapper<>(User.class), id);
    }
    
    // UPDATE
    public int update(User user) {
        String sql = "UPDATE users SET name=?, email=? WHERE id=?";
        return jdbcTemplate.update(sql, 
            user.getName(), user.getEmail(), user.getId());
    }
    
    // DELETE
    public int delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }
}
```

### RowMapper

`RowMapper` converts each row of `ResultSet` to an object.

```java
// Using BeanPropertyRowMapper (automatic mapping)
new BeanPropertyRowMapper<>(User.class)

// Using custom RowMapper
new RowMapper<User>() {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        return user;
    }
}

// Using Lambda
(rs, rowNum) -> new User(
    rs.getInt("id"),
    rs.getString("name"),
    rs.getString("email")
)
```

---

## 4. NamedParameterJdbcTemplate

### What is NamedParameterJdbcTemplate?

Instead of using `?` placeholders, you can use **named parameters** like `:name`, `:email`.

### Benefits

- ✅ More readable SQL
- ✅ Order of parameters doesn't matter
- ✅ Same parameter can be used multiple times

### Code Example

```java
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;

@Repository
public class UserDAO {
    
    @Autowired
    private NamedParameterJdbcTemplate namedTemplate;
    
    public User findByNameAndEmail(String name, String email) {
        // Named parameters instead of ?
        String sql = "SELECT * FROM users WHERE name = :name AND email = :email";
        
        // Create parameter map
        MapSqlParameterSource params = new MapSqlParameterSource();
        params.addValue("name", name);
        params.addValue("email", email);
        
        return namedTemplate.queryForObject(sql, params,
            new BeanPropertyRowMapper<>(User.class));
    }
    
    public int insert(User user) {
        String sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
        
        Map<String, Object> params = new HashMap<>();
        params.put("name", user.getName());
        params.put("email", user.getEmail());
        
        return namedTemplate.update(sql, params);
    }
}
```

---

## 5. SimpleJdbcInsert

### What is SimpleJdbcInsert?

`SimpleJdbcInsert` simplifies INSERT operations - no need to write SQL!

### Code Example

```java
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;

@Repository
public class UserDAO {
    
    private SimpleJdbcInsert simpleJdbcInsert;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.simpleJdbcInsert = new SimpleJdbcInsert(dataSource)
            .withTableName("users")
            .usingGeneratedKeyColumns("id");
    }
    
    public User insert(User user) {
        Map<String, Object> params = new HashMap<>();
        params.put("name", user.getName());
        params.put("email", user.getEmail());
        
        // Returns generated key
        Number newId = simpleJdbcInsert.executeAndReturnKey(params);
        user.setId(newId.intValue());
        
        return user;
    }
}
```

---

## 6. HibernateTemplate

### What is HibernateTemplate?

`HibernateTemplate` is a template for Hibernate ORM operations.

> **Note**: In modern Spring, `HibernateTemplate` is deprecated. Use `SessionFactory` with `@Transactional` instead.

### Common Methods

| Method | Purpose |
|--------|---------|
| `save(entity)` | Insert new entity |
| `update(entity)` | Update existing entity |
| `delete(entity)` | Delete entity |
| `get(Class, id)` | Load entity by ID |
| `find(hql)` | Execute HQL query |
| `findByCriteria()` | Execute criteria query |

### Code Example (Legacy)

```java
import org.springframework.orm.hibernate5.HibernateTemplate;

@Repository
public class UserDAO {
    
    @Autowired
    private HibernateTemplate hibernateTemplate;
    
    // INSERT
    public void save(User user) {
        hibernateTemplate.save(user);
    }
    
    // SELECT BY ID
    public User findById(int id) {
        return hibernateTemplate.get(User.class, id);
    }
    
    // SELECT ALL
    public List<User> findAll() {
        return (List<User>) hibernateTemplate.find("FROM User");
    }
    
    // UPDATE
    public void update(User user) {
        hibernateTemplate.update(user);
    }
    
    // DELETE
    public void delete(User user) {
        hibernateTemplate.delete(user);
    }
}
```

### Modern Approach (Recommended)

```java
import org.hibernate.SessionFactory;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class UserDAO {
    
    @Autowired
    private SessionFactory sessionFactory;
    
    public void save(User user) {
        sessionFactory.getCurrentSession().persist(user);
    }
    
    public User findById(int id) {
        return sessionFactory.getCurrentSession().get(User.class, id);
    }
}
```

---

## 7. Comparison of Templates

| Template | Use Case | Key Feature |
|----------|----------|-------------|
| **JdbcTemplate** | Direct SQL with `?` placeholders | Most commonly used |
| **NamedParameterJdbcTemplate** | SQL with named parameters | More readable SQL |
| **SimpleJdbcInsert** | INSERT operations | No SQL needed |
| **HibernateTemplate** | Hibernate ORM (legacy) | Works with entities |

### Decision Tree

```
┌─────────────────────────────────────────────────────────────┐
│              WHICH TEMPLATE TO USE?                          │
│                                                              │
│   Need to write SQL?                                         │
│   ├── YES                                                    │
│   │   ├── Simple queries → JdbcTemplate                     │
│   │   └── Complex queries with named params →               │
│   │                      NamedParameterJdbcTemplate         │
│   │                                                          │
│   └── NO (Just INSERT)                                       │
│       └── SimpleJdbcInsert                                  │
│                                                              │
│   Using Hibernate?                                           │
│   ├── Legacy project → HibernateTemplate                    │
│   └── Modern project → SessionFactory + @Transactional      │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Common Interview Questions

### Q1: What is JdbcTemplate?
**A:** JdbcTemplate is a Spring class that simplifies JDBC operations by eliminating boilerplate code for connection management, statement creation, exception handling, and resource cleanup.

### Q2: What is the advantage of using Spring templates?
**A:** Two main advantages:
1. **Boilerplate reduction** - No manual connection/statement management
2. **Exception translation** - Converts checked SQLException to unchecked DataAccessException

### Q3: What is the difference between JdbcTemplate and NamedParameterJdbcTemplate?
**A:** 
- `JdbcTemplate` uses `?` placeholders for parameters
- `NamedParameterJdbcTemplate` uses named parameters like `:name`

### Q4: What is RowMapper?
**A:** RowMapper is an interface that converts each row of ResultSet to a Java object. Spring provides `BeanPropertyRowMapper` for automatic mapping.

### Q5: Is HibernateTemplate still recommended?
**A:** No, it's deprecated. Modern approach is to use `SessionFactory` with `@Transactional` annotation.

---

## 9. Key Takeaways

📌 **Templates eliminate boilerplate** code for database operations

📌 **Exception translation** converts SQLException to DataAccessException

📌 **JdbcTemplate** is the most commonly used template

📌 **NamedParameterJdbcTemplate** for more readable SQL with `:param`

📌 **SimpleJdbcInsert** for INSERT without writing SQL

📌 **HibernateTemplate is deprecated** - use SessionFactory instead

📌 **RowMapper** converts ResultSet rows to objects

📌 **BeanPropertyRowMapper** for automatic column-to-property mapping

---

*Previous: [12. Annotation-based AOP](./12_Annotation_Based_AOP.md)*

*Next: [14. Design Patterns in Spring](./14_Design_Patterns_in_Spring.md)*
