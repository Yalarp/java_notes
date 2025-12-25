# Transaction Management in JDBC

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is a Transaction](#what-is-a-transaction)
3. [ACID Properties](#acid-properties)
4. [Auto-Commit Mode](#auto-commit-mode)
5. [Manual Transaction Control](#manual-transaction-control)
6. [Code Example](#code-example)
7. [Savepoints](#savepoints)
8. [Key Takeaways](#key-takeaways)
9. [Common Mistakes](#common-mistakes)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

A **transaction** is a sequence of database operations that must be treated as a **single unit**. Either ALL operations succeed (commit), or ALL are cancelled (rollback). JDBC provides methods to control transaction boundaries.

---

## 📖 What is a Transaction

### Real-World Example: Bank Transfer

Transferring ₹1000 from Account A to Account B:
1. Debit ₹1000 from Account A
2. Credit ₹1000 to Account B

**Problem:** What if step 1 succeeds but step 2 fails?
- Money deducted from A ❌
- Money not added to B ❌
- ₹1000 disappeared! ❌

**Solution:** Use a Transaction
- If both succeed → COMMIT (save changes)
- If any fails → ROLLBACK (undo all changes)

---

## 🔐 ACID Properties

Transactions must follow ACID properties:

| Property | Description |
|----------|-------------|
| **A**tomicity | All operations succeed or all fail |
| **C**onsistency | Database remains in valid state |
| **I**solation | Transactions don't interfere with each other |
| **D**urability | Committed changes are permanent |

### Atomicity Example

```
Transaction:
    1. UPDATE account SET balance = balance - 1000 WHERE id = 'A'
    2. UPDATE account SET balance = balance + 1000 WHERE id = 'B'

If step 2 fails:
    Rollback → step 1 is also undone
    Database state = same as before transaction started
```

---

## 🔄 Auto-Commit Mode

### Default Behavior

By default, JDBC connection is in **auto-commit mode**:
- Each SQL statement is a separate transaction
- Each statement is immediately committed
- No way to rollback after execution

```java
Connection con = DriverManager.getConnection(url, user, pass);
// Auto-commit is TRUE by default

Statement st = con.createStatement();
st.executeUpdate("UPDATE account SET balance = 500");  // Immediately committed!
// Cannot rollback this change
```

### Checking Auto-Commit Status

```java
boolean isAutoCommit = con.getAutoCommit();  // Returns true by default
```

---

## 🎛️ Manual Transaction Control

### Disabling Auto-Commit

To manage transactions manually:

```java
con.setAutoCommit(false);  // Turn off auto-commit
```

### Transaction Methods

| Method | Description |
|--------|-------------|
| `setAutoCommit(false)` | Start manual transaction control |
| `commit()` | Save all changes permanently |
| `rollback()` | Undo all changes since last commit |
| `setAutoCommit(true)` | Return to auto-commit mode |

### Transaction Pattern

```java
try {
    con.setAutoCommit(false);  // 1. Start transaction
    
    // 2. Execute multiple operations
    operation1();
    operation2();
    operation3();
    
    con.commit();  // 3. All successful → Commit
    
} catch (Exception e) {
    con.rollback();  // 4. Any failure → Rollback
}
```

---

## 💻 Code Example

### App8.java - Transaction with Commit/Rollback

```java
import java.sql.*;

public class App8 {
    public static void main(String args[]) throws Exception {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            
            try {
                // Step 1: Disable auto-commit
                con.setAutoCommit(false);
                
                Statement st = con.createStatement();
                
                // Step 2: Execute first operation
                int a = st.executeUpdate("UPDATE dept SET loc = 'bombay'");
                
                // Step 3: Execute second operation
                int b = st.executeUpdate("INSERT INTO dept VALUES(10, 'abc', 'aaa')");
                
                // Step 4: All successful → Commit
                con.commit();
                System.out.println("Transaction committed successfully!");
                
            } catch (Exception ee) {
                // Step 5: Any error → Rollback
                con.rollback();
                System.out.println("Transaction rolled back: " + ee);
            }
            
            // Step 6: Restore auto-commit
            con.setAutoCommit(true);
            
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 11 | `con.setAutoCommit(false)` | Disable auto-commit, start transaction |
| 16 | `st.executeUpdate("UPDATE...")` | First operation - not committed yet |
| 19 | `st.executeUpdate("INSERT...")` | Second operation - not committed yet |
| 22 | `con.commit()` | Both successful → commit to database |
| 26 | `con.rollback()` | If exception → undo all changes |
| 30 | `con.setAutoCommit(true)` | Restore default behavior |

### Execution Flow

```
Normal Flow (No Error):
┌────────────────────────────────────┐
│ setAutoCommit(false)               │
│         ↓                          │
│ UPDATE dept (in memory)            │
│         ↓                          │
│ INSERT INTO dept (in memory)       │
│         ↓                          │
│ commit() → Changes saved to DB ✅  │
│         ↓                          │
│ setAutoCommit(true)                │
└────────────────────────────────────┘

Error Flow (Exception Occurs):
┌────────────────────────────────────┐
│ setAutoCommit(false)               │
│         ↓                          │
│ UPDATE dept (in memory)            │
│         ↓                          │
│ INSERT fails (duplicate key!) ❌   │
│         ↓                          │
│ catch block executes               │
│         ↓                          │
│ rollback() → UPDATE also undone ✅ │
│         ↓                          │
│ setAutoCommit(true)                │
└────────────────────────────────────┘
```

---

## 📍 Savepoints

### What is a Savepoint?

A **savepoint** marks a point within a transaction that you can rollback to, without rolling back the entire transaction.

```java
con.setAutoCommit(false);

Statement st = con.createStatement();
st.executeUpdate("INSERT INTO table1 VALUES(1, 'A')");  // Operation 1

Savepoint sp = con.setSavepoint("AfterFirstInsert");    // Mark savepoint

st.executeUpdate("INSERT INTO table2 VALUES(2, 'B')");  // Operation 2

// If we want to undo only Operation 2:
con.rollback(sp);  // Rolls back to savepoint (keeps Operation 1)

con.commit();  // Commits Operation 1 only
```

### Savepoint Methods

| Method | Description |
|--------|-------------|
| `setSavepoint()` | Create unnamed savepoint |
| `setSavepoint("name")` | Create named savepoint |
| `rollback(savepoint)` | Rollback to specific savepoint |
| `releaseSavepoint(sp)` | Remove savepoint |

---

## ✅ Key Takeaways

1. **Auto-commit is ON by default** - each statement commits immediately
2. **Use setAutoCommit(false)** for multi-statement transactions  
3. **Always commit or rollback** - never leave transaction hanging
4. **Rollback undoes ALL changes** since setAutoCommit(false)
5. **Restore auto-commit** after transaction completes
6. **Use Savepoints** for partial rollbacks
7. **ACID properties** ensure data integrity

---

## ⚠️ Common Mistakes

### 1. Forgetting to Commit

```java
// ❌ WRONG - Changes not saved!
con.setAutoCommit(false);
st.executeUpdate("UPDATE...");
st.executeUpdate("INSERT...");
// Missing commit()! Changes lost when connection closes

// ✅ CORRECT
con.setAutoCommit(false);
st.executeUpdate("UPDATE...");
st.executeUpdate("INSERT...");
con.commit();  // Save changes
```

### 2. Not Catching Exceptions for Rollback

```java
// ❌ WRONG - No rollback on error
con.setAutoCommit(false);
st.executeUpdate("UPDATE...");  // Succeeds
st.executeUpdate("INSERT...");  // Fails
// First UPDATE is neither committed nor rolled back!

// ✅ CORRECT
try {
    con.setAutoCommit(false);
    st.executeUpdate("UPDATE...");
    st.executeUpdate("INSERT...");
    con.commit();
} catch (SQLException e) {
    con.rollback();  // Undo partial changes
}
```

### 3. Not Restoring Auto-Commit

```java
// ❌ WRONG - Connection left in manual mode
con.setAutoCommit(false);
// ... transaction code ...
con.commit();
// Next operations also need explicit commit!

// ✅ CORRECT
con.setAutoCommit(false);
// ... transaction code ...
con.commit();
con.setAutoCommit(true);  // Restore default
```

---

## 🎤 Interview Questions

**Q1: What is a database transaction?**
> **A:** A transaction is a sequence of database operations that are treated as a single unit. Either all operations complete successfully (commit), or all are undone (rollback). This ensures data consistency.

**Q2: What are ACID properties?**
> **A:**
> - **Atomicity**: All or nothing - all operations succeed or all fail
> - **Consistency**: Database remains valid before and after transaction
> - **Isolation**: Concurrent transactions don't interfere
> - **Durability**: Committed changes survive system failures

**Q3: What is auto-commit mode in JDBC?**
> **A:** By default, JDBC connections have auto-commit enabled. Each SQL statement is immediately committed to the database. To manage transactions manually, you must call `setAutoCommit(false)`.

**Q4: What is the difference between commit() and rollback()?**
> **A:** 
> - `commit()`: Permanently saves all changes since the transaction started
> - `rollback()`: Undoes all changes since the transaction started, restoring the database to its previous state

**Q5: What happens if you don't call commit() before closing connection?**
> **A:** The behavior depends on the JDBC driver. Most drivers will automatically rollback uncommitted changes when the connection closes. However, relying on this is bad practice - always explicitly commit or rollback.

**Q6: What is a Savepoint and when would you use it?**
> **A:** A Savepoint marks a point within a transaction that you can rollback to without rolling back the entire transaction. Use it when you have a long transaction and want to undo only part of it if an error occurs, keeping earlier successful operations.
