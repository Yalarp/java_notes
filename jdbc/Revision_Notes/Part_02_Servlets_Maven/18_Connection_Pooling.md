# Connection Pooling

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Problem with Regular Connections](#problem-with-regular-connections)
3. [What is Connection Pooling](#what-is-connection-pooling)
4. [How It Works](#how-it-works)
5. [DataSource Interface](#datasource-interface)
6. [Configuration Example](#configuration-example)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Connection Pooling** is a technique where database connections are created in advance and reused across multiple requests, instead of creating a new connection for each request.

---

## 📖 Problem with Regular Connections

### Without Connection Pool

```
Request 1: Create Connection → Use → Close
Request 2: Create Connection → Use → Close
Request 3: Create Connection → Use → Close
...
Request 1000: Create Connection → Use → Close
```

### Why This Is Bad

| Problem | Impact |
|---------|--------|
| **Connection creation is expensive** | 100-500ms per connection |
| **Resource intensive** | TCP socket, authentication, memory |
| **Database limit** | Max connections reached quickly |
| **Latency** | Users wait for connection setup |

### Time Breakdown

```
Without Pool:
┌──────────────────────────────────────────────────────┐
│ Create Connection: 200ms                              │
│ Execute Query: 50ms                                   │
│ Close Connection: 50ms                                │
│ Total: 300ms                                          │
└──────────────────────────────────────────────────────┘

With Pool:
┌──────────────────────────────────────────────────────┐
│ Get Connection from Pool: 1ms                         │
│ Execute Query: 50ms                                   │
│ Return Connection to Pool: 1ms                        │
│ Total: 52ms                                           │
└──────────────────────────────────────────────────────┘
```

---

## 📖 What is Connection Pooling

### Definition

A **connection pool** is a cache of database connections that are:
- Created at application startup
- Reused across multiple requests
- Managed by the pool (not your code)
- Returned to pool instead of closed

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Connection Pool                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │  Conn1  │  │  Conn2  │  │  Conn3  │  │  Conn4  │  ...   │
│  │ (in use)│  │ (idle)  │  │ (idle)  │  │ (in use)│        │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │
└─────────────────────────────────────────────────────────────┘
                          │
    ┌─────────────────────┼─────────────────────┐
    │                     │                     │
    ▼                     ▼                     ▼
┌─────────┐         ┌─────────┐          ┌─────────┐
│Request 1│         │Request 2│          │Request 3│
│(using   │         │(waiting │          │(using   │
│ Conn1)  │         │ for     │          │ Conn4)  │
└─────────┘         │ idle    │          └─────────┘
                    │ conn)   │
                    └─────────┘
```

### Pool Configuration

| Parameter | Description | Typical Value |
|-----------|-------------|---------------|
| `initialSize` | Connections at startup | 5 |
| `maxTotal` | Maximum connections | 20-50 |
| `maxIdle` | Max idle connections | 10 |
| `minIdle` | Min idle connections | 5 |
| `maxWaitMillis` | Wait time for connection | 10000 |

---

## 📖 How It Works

### Lifecycle

```
1. Application Starts
        ↓
2. Pool creates initial connections (e.g., 5)
        ↓
3. Request comes in
        ↓
4. Request asks pool for connection
        ↓
5. Pool provides idle connection (or creates new if under max)
        ↓
6. Request uses connection
        ↓
7. Request "closes" connection (actually returns to pool)
        ↓
8. Connection becomes idle, available for next request
```

### Key Behavior

```java
// This does NOT create a new connection
Connection con = dataSource.getConnection();

// This does NOT actually close - returns to pool
con.close();
```

---

## 📖 DataSource Interface

### javax.sql.DataSource

`DataSource` is the standard interface for connection pools. It replaces `DriverManager`.

```java
// Old way - DriverManager
Connection con = DriverManager.getConnection(url, user, pass);

// New way - DataSource
DataSource ds = // ... get from pool/JNDI
Connection con = ds.getConnection();
```

### Popular Connection Pool Implementations

| Library | Class | Notes |
|---------|-------|-------|
| **Apache DBCP** | `BasicDataSource` | Apache Commons |
| **HikariCP** | `HikariDataSource` | Fastest, Spring Boot default |
| **C3P0** | `ComboPooledDataSource` | Older, still used |
| **Tomcat JDBC** | `DataSource` | Built into Tomcat |

---

## 💻 Configuration Example

### Using Tomcat JDBC Pool (context.xml)

**META-INF/context.xml:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <Resource 
        name="jdbc/mydb"
        auth="Container"
        type="javax.sql.DataSource"
        driverClassName="com.mysql.cj.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/mydb"
        username="root"
        password="root"
        maxTotal="20"
        maxIdle="10"
        minIdle="5"
        maxWaitMillis="10000"
    />
</Context>
```

### Using DataSource in Servlet

```java
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;

@WebServlet("/test")
public class TestServlet extends HttpServlet {
    
    private DataSource ds;
    
    @Override
    public void init() throws ServletException {
        try {
            // Look up DataSource from JNDI
            InitialContext ctx = new InitialContext();
            ds = (DataSource) ctx.lookup("java:comp/env/jdbc/mydb");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException {
        
        // Get connection from pool
        try (Connection con = ds.getConnection()) {
            // Use connection
            // Automatically returned to pool when try block ends
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### Using HikariCP (Programmatic)

```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class ConnectionPool {
    private static HikariDataSource ds;
    
    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/mydb");
        config.setUsername("root");
        config.setPassword("root");
        config.setMaximumPoolSize(20);
        config.setMinimumIdle(5);
        
        ds = new HikariDataSource(config);
    }
    
    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}
```

---

## ✅ Key Takeaways

1. **Creating connections is expensive** - avoid per-request creation
2. **Connection pool** = pre-created, reusable connections
3. **DataSource** replaces DriverManager for pooled connections
4. **con.close()** returns connection to pool (doesn't actually close)
5. Configure **pool size** based on expected load
6. Popular pools: **HikariCP** (fastest), DBCP, C3P0

---

## 🎤 Interview Questions

**Q1: What is connection pooling and why is it needed?**
> **A:** Connection pooling maintains a cache of database connections that are reused across requests. It's needed because creating connections is expensive (100-500ms) and doing it per-request causes latency and resource exhaustion.

**Q2: What happens when you call close() on a pooled connection?**
> **A:** The connection is NOT actually closed. Instead, it's returned to the pool and marked as available for the next request. This is why you should always call close() - it makes the connection available.

**Q3: What is DataSource and how is it different from DriverManager?**
> **A:** DataSource is an interface for obtaining connections, typically from a pool. Unlike DriverManager which creates new connections each time, DataSource implementations manage pools and return reusable connections.

**Q4: What happens if all connections are in use?**
> **A:** The requesting thread waits (blocks) until a connection becomes available or the configured timeout (`maxWaitMillis`) is reached. If timeout expires, an exception is thrown.

**Q5: Name some popular connection pool libraries.**
> **A:** 
> - **HikariCP**: Fastest, Spring Boot default
> - **Apache DBCP**: Apache Commons pool
> - **C3P0**: Older, Hibernate compatible
> - **Tomcat JDBC Pool**: Built into Tomcat
