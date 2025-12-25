# CachedRowSet - Disconnected ResultSet

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Connected vs Disconnected](#connected-vs-disconnected)
3. [What is CachedRowSet](#what-is-cachedrowset)
4. [Advantages](#advantages)
5. [Code Example](#code-example)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

A **disconnected environment** is one where the user is not necessarily connected with the database all the time. The connection is:
- **Established** when retrieving data
- **Closed** after data is fetched
- **Re-established** only when updates need to be synchronized

CachedRowSet provides this disconnected capability.

---

## 📖 Connected vs Disconnected

### Connected Approach (ResultSet)

```
┌─────────────┐     Permanent     ┌─────────────┐
│   Java      │ ←───Connection───→│  Database   │
│ Application │                   │   Server    │
└─────────────┘                   └─────────────┘
      │
      │ while(rs.next()) {
      │     // Each call fetches from database
      │     // Connection must be open
      │ }
```

**Problems:**
- Connection must stay open while traversing
- Holds database resources
- Not serializable (can't send over network)

### Disconnected Approach (CachedRowSet)

```
┌─────────────┐  1. Connect &    ┌─────────────┐
│   Java      │ ───Fetch Data───→│  Database   │
│ Application │  2. Disconnect   │   Server    │
└─────────────┘                   └─────────────┘
      │
      │ // Data cached in memory
      │ while(crs.next()) {
      │     // Reading from local cache
      │     // No active connection!
      │ }
```

---

## 📖 What is CachedRowSet

**CachedRowSet** is a disconnected, serializable, scrollable container for tabular data.

| Feature | ResultSet | CachedRowSet |
|---------|-----------|--------------|
| Connection Required | Always | Only during fetch |
| Serializable | No | Yes (can send over network) |
| Memory Usage | Low | Higher (caches all data) |
| Scrollable | Depends | Always |
| Updatable | Depends | Yes |
| Best For | Connected apps | Distributed apps |

---

## ✅ Advantages

### 1. No Permanent Connection Needed
```java
// Connection only needed during execute()
crs.execute();  // Connects, fetches, disconnects automatically
```

### 2. Serializable (Network Transfer)
```java
// ResultSet CANNOT be serialized
// CachedRowSet CAN be serialized and sent over network
ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
oos.writeObject(cachedRowSet);  // Send over network ✅
```

### 3. Works Offline
```java
// After execute(), can traverse without connection
while(crs.next()) {
    // Reading from local cache
    // Database connection is closed
}
```

### 4. Better for Thousands of Records
When you need to traverse many records without holding a connection.

---

## 💻 Code Example

### CachedRowSetDemo.java

```java
import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetProvider;

public class CachedRowSetDemo {
    public static void main(String args[]) {
        
        // Create CachedRowSet with try-with-resources
        try (CachedRowSet crs = RowSetProvider.newFactory().createCachedRowSet()) {
            
            // Configure connection info
            crs.setUsername("root");
            crs.setPassword("root");
            crs.setUrl("jdbc:mysql://localhost:3306/mydb");
            
            // Set query command
            crs.setCommand("select * from dept");
            
            // Execute - connects, fetches data, disconnects
            crs.execute();
            
            // At this point, connection is CLOSED
            System.out.println("Connection closed, but data is available!");
            
            // Traverse data from local cache
            while (crs.next()) {
                int a = crs.getInt(1);
                String b = crs.getString(2);
                String c = crs.getString(3);
                System.out.println(a + "\t" + b + "\t" + c);
            }
            
        } catch (Exception ee) {
            ee.printStackTrace();
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 8 | `RowSetProvider.newFactory().createCachedRowSet()` | Create CachedRowSet using factory |
| 11-13 | `setUsername`, `setPassword`, `setUrl` | Configure connection parameters |
| 16 | `setCommand("select * from dept")` | Set SQL query to execute |
| 19 | `execute()` | Connects → Runs query → Caches results → Disconnects |
| 24-27 | `while(crs.next())` | Traverse cached data (no active connection!) |

### Execution Flow

```
1. CachedRowSet created (no connection yet)
        ↓
2. setUrl(), setUsername(), setPassword()
        ↓
3. setCommand() - SQL query stored
        ↓
4. execute()
        ├── Creates connection internally
        ├── Executes query
        ├── Fetches ALL data to memory
        └── Closes connection automatically
        ↓
5. while(crs.next())
        └── Reads from in-memory cache
        └── No database connection!
```

---

## ✅ Key Takeaways

1. **CachedRowSet is disconnected** - connection needed only during execute()
2. **Data cached in memory** - can traverse after connection is closed
3. **Serializable** - can be sent over network (ResultSet cannot)
4. **Uses RowSetProvider factory** to create instances
5. **execute() method** handles connect → fetch → disconnect automatically
6. **Best for distributed apps** where data needs to travel over network

---

## 🎤 Interview Questions

**Q1: What is the difference between ResultSet and CachedRowSet?**
> **A:**
> - **ResultSet**: Connected - requires active database connection during traversal. Not serializable.
> - **CachedRowSet**: Disconnected - caches data in memory, doesn't need connection after fetch. Serializable and can be sent over network.

**Q2: When would you use CachedRowSet over ResultSet?**
> **A:** Use CachedRowSet when:
> - You need to send data over the network (RMI, web services)
> - You want to minimize database connection time
> - You need to traverse data offline
> - You have thousands of records to process without holding connection

**Q3: How does CachedRowSet maintain data without a connection?**
> **A:** When `execute()` is called, CachedRowSet:
> 1. Opens a connection
> 2. Executes the query
> 3. Fetches ALL rows into memory
> 4. Closes the connection
> The data remains in the CachedRowSet object for later access.

**Q4: Is CachedRowSet updatable?**
> **A:** Yes. You can modify data in CachedRowSet while disconnected. When ready to persist changes, call `acceptChanges()` which reconnects and synchronizes updates with the database.
