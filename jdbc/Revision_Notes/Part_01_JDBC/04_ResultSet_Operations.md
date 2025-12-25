# ResultSet Operations

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [ResultSet Basics](#resultset-basics)
3. [ResultSet Types](#resultset-types)
4. [Scrollable ResultSet](#scrollable-resultset)
5. [Updatable ResultSet](#updatable-resultset)
6. [ResultSetMetaData](#resultsetmetadata)
7. [Code Examples](#code-examples)
8. [Key Takeaways](#key-takeaways)
9. [Common Mistakes](#common-mistakes)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**ResultSet** is an interface that represents the result of a database query. It holds the rows returned by a SELECT statement and provides methods to:
- **Navigate** through records
- **Access** column data
- **Modify** data (if updatable)
- **Get metadata** about the result

---

## 📖 ResultSet Basics

### Cursor Position

When a ResultSet is created, the **cursor is positioned BEFORE the first row**:

```
   [BEFORE FIRST]  ← Cursor starts here
        ↓
    ┌─────────────────┐
    │   Row 1         │  ← After first next()
    ├─────────────────┤
    │   Row 2         │  ← After second next()
    ├─────────────────┤
    │   Row 3         │
    └─────────────────┘
        ↓
   [AFTER LAST]
```

### Accessing Column Data

There are two ways to access column data:

#### 1. By Column Name (Recommended)
```java
int deptno = rs.getInt("deptno");
String dname = rs.getString("dname");
String loc = rs.getString("loc");
```

#### 2. By Column Index (1-based)
```java
int deptno = rs.getInt(1);      // First column
String dname = rs.getString(2);  // Second column
String loc = rs.getString(3);    // Third column
```

#### 3. Using getObject() (Generic)
```java
// Returns Object - works for any data type
Object val1 = rs.getObject("deptno");
Object val2 = rs.getObject(2);
```

| Approach | Pros | Cons |
|----------|------|------|
| By Name | Readable, order-independent | Slightly slower |
| By Index | Faster | Hard to read, breaks if order changes |
| getObject | Universal | Requires casting |

---

## 📋 ResultSet Types

### Type and Concurrency

When creating a Statement, you can specify ResultSet behavior:

```java
Statement st = con.createStatement(TYPE, CONCURRENCY);
```

### ResultSet Type Constants

| Constant | Description |
|----------|-------------|
| `TYPE_FORWARD_ONLY` | Can only move forward (default) |
| `TYPE_SCROLL_INSENSITIVE` | Can scroll; doesn't reflect DB changes |
| `TYPE_SCROLL_SENSITIVE` | Can scroll; reflects DB changes |

### ResultSet Concurrency Constants

| Constant | Description |
|----------|-------------|
| `CONCUR_READ_ONLY` | Cannot update through ResultSet (default) |
| `CONCUR_UPDATABLE` | Can update database through ResultSet |

### Default Behavior

```java
// Default: Forward-only and Read-only
Statement st = con.createStatement();
// Equivalent to:
Statement st = con.createStatement(
    ResultSet.TYPE_FORWARD_ONLY, 
    ResultSet.CONCUR_READ_ONLY
);
```

---

## 🔄 Scrollable ResultSet

### What is Scrollable?

By default, ResultSet only supports `next()` method (forward movement). **Scrollable ResultSet** allows:
- Moving backward
- Jumping to specific rows
- Moving to first/last rows

### Navigation Methods

| Method | Description |
|--------|-------------|
| `next()` | Move to next row |
| `previous()` | Move to previous row |
| `first()` | Move to first row |
| `last()` | Move to last row |
| `absolute(n)` | Move to row number n |
| `relative(n)` | Move n rows from current position |
| `beforeFirst()` | Move before first row |
| `afterLast()` | Move after last row |

### Creating Scrollable ResultSet

```java
Statement st = con.createStatement(
    ResultSet.TYPE_SCROLL_INSENSITIVE,  // Scrollable
    ResultSet.CONCUR_READ_ONLY          // Read-only
);
ResultSet rs = st.executeQuery("SELECT * FROM dept");

// Now you can scroll
rs.last();        // Go to last row
rs.first();       // Go to first row
rs.absolute(5);   // Go to row 5
rs.previous();    // Go to row 4
```

---

## ✏️ Updatable ResultSet

### What is Updatable?

By default, ResultSet is read-only. **Updatable ResultSet** allows you to:
- Update existing rows
- Insert new rows
- Delete rows
- All through the ResultSet itself!

### Creating Updatable ResultSet

```java
Statement st = con.createStatement(
    ResultSet.TYPE_SCROLL_INSENSITIVE,  // Scrollable
    ResultSet.CONCUR_UPDATABLE          // Updatable
);
```

### Update Methods

| Method | Description |
|--------|-------------|
| `updateString(col, value)` | Update String column |
| `updateInt(col, value)` | Update int column |
| `updateRow()` | Commit changes to database |
| `deleteRow()` | Delete current row |
| `insertRow()` | Insert new row |
| `moveToInsertRow()` | Move to special insert row |

### Code Example: Scrollable and Updatable

```java
import java.sql.*;

public class App7 {
    public static void main(String args[]) {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            
            // Create scrollable and updatable statement
            Statement st = con.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_UPDATABLE
            );
            
            // Execute query (must include primary key for updates!)
            ResultSet rs = st.executeQuery("select deptno, dname, loc from dept");
            
            // Go to 5th row and update
            rs.absolute(5);                    // Jump to row 5
            rs.updateString("loc", "USA");     // Change loc to "USA"
            rs.updateRow();                    // Save to database
            
            // Go to previous row (4th) and update
            rs.previous();                     // Move to row 4
            rs.updateString("dname", "edp");   // Change dname
            rs.updateRow();                    // Save
            
            // Go to row 4 and update
            rs.absolute(4);                    // Jump to row 4
            rs.updateString("loc", "england"); // Change loc
            rs.updateRow();                    // Save
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 9 | `TYPE_SCROLL_INSENSITIVE` | ResultSet is scrollable |
| 10 | `CONCUR_UPDATABLE` | ResultSet is updatable |
| 13 | `select deptno, dname, loc` | Query must include all columns you want to update |
| 16 | `rs.absolute(5)` | Jump directly to 5th row |
| 17 | `rs.updateString("loc", "USA")` | Change column value in memory |
| 18 | `rs.updateRow()` | **MUST call** to persist changes to DB |
| 21 | `rs.previous()` | Move one row backward |

---

## 📊 ResultSetMetaData

### What is ResultSetMetaData?

When you don't know the structure of the result (column names, types, count), use **ResultSetMetaData**:

```java
ResultSetMetaData rsmd = rs.getMetaData();
```

### Useful Methods

| Method | Returns |
|--------|---------|
| `getColumnCount()` | Number of columns |
| `getColumnName(i)` | Column name at index i |
| `getColumnTypeName(i)` | SQL type name |
| `getTableName(i)` | Table name |
| `isNullable(i)` | Whether column allows NULL |

### Code Example: ResultSetMetaData (App2.java)

```java
import java.sql.*;

public class App2 {
    public static void main(String args[]) {
        String ss = "jdbc:mysql://localhost:3306/mydb";
        
        try (Connection con = DriverManager.getConnection(ss, "root", "root")) {
            
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select * from dept");
            
            // Get metadata about the ResultSet
            ResultSetMetaData rsmd = rs.getMetaData();
            
            // Get number of columns
            int colCount = rsmd.getColumnCount();
            
            // Print column headers
            for (int i = 1; i <= colCount; i++) {
                System.out.print(rsmd.getColumnName(i) + "\t");
            }
            System.out.println();
            
            // Print data using column names dynamically
            while (rs.next()) {
                for (int i = 1; i <= colCount; i++) {
                    System.out.print(rs.getObject(i) + "\t");
                }
                System.out.println();
            }
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
    }
}
```

### Why Use ResultSetMetaData?

✅ When you don't know:
- How many columns are returned
- What the column names are
- What data types they have

✅ Use cases:
- Building generic SQL tools
- Displaying any table dynamically
- Generating reports

---

## ✅ Key Takeaways

1. **Cursor starts BEFORE first row** - always call `next()` first
2. **Column index starts at 1**, not 0
3. **Default ResultSet** is forward-only and read-only
4. **For scrolling**, use `TYPE_SCROLL_INSENSITIVE`
5. **For updating**, use `CONCUR_UPDATABLE`
6. **Always call `updateRow()`** after updates to persist changes
7. **Use `getObject()`** when data type is unknown

---

## ⚠️ Common Mistakes

### 1. Accessing Data Without Calling next()

```java
// ❌ WRONG - Cursor not on any row
ResultSet rs = st.executeQuery("SELECT * FROM dept");
String name = rs.getString("dname");  // Exception!

// ✅ CORRECT
ResultSet rs = st.executeQuery("SELECT * FROM dept");
while (rs.next()) {
    String name = rs.getString("dname");  // Works
}
```

### 2. Using Column Index 0

```java
// ❌ WRONG - Columns are 1-indexed
String name = rs.getString(0);  // SQLException!

// ✅ CORRECT
String name = rs.getString(1);  // First column
```

### 3. Forgetting updateRow()

```java
// ❌ WRONG - Changes not saved
rs.absolute(5);
rs.updateString("loc", "Mumbai");
// Missing updateRow()! Changes lost

// ✅ CORRECT
rs.absolute(5);
rs.updateString("loc", "Mumbai");
rs.updateRow();  // Persists to database
```

### 4. Trying to Scroll on Forward-Only ResultSet

```java
// ❌ WRONG - Default is forward-only
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("SELECT * FROM dept");
rs.absolute(5);  // Exception! Can't scroll

// ✅ CORRECT - Create scrollable statement
Statement st = con.createStatement(
    ResultSet.TYPE_SCROLL_INSENSITIVE,
    ResultSet.CONCUR_READ_ONLY
);
```

---

## 🎤 Interview Questions

**Q1: What is the default type and concurrency of ResultSet?**
> **A:** Default is `TYPE_FORWARD_ONLY` and `CONCUR_READ_ONLY`. This means you can only move forward using `next()` and cannot modify data through the ResultSet.

**Q2: What is the difference between TYPE_SCROLL_INSENSITIVE and TYPE_SCROLL_SENSITIVE?**
> **A:** 
> - **SCROLL_INSENSITIVE**: Scrollable but doesn't reflect changes made by other users to the database after the ResultSet was created
> - **SCROLL_SENSITIVE**: Scrollable and reflects database changes made by others

**Q3: Why must we call updateRow() after updating values?**
> **A:** `updateXxx()` methods only change values in the ResultSet's internal buffer (memory), not in the database. `updateRow()` actually writes these changes to the database. Without it, changes are lost.

**Q4: What is ResultSetMetaData and when would you use it?**
> **A:** ResultSetMetaData provides information about the structure of a ResultSet - column count, names, types, etc. Use it when you don't know the query structure at compile time, like building generic database tools or dynamic reports.

**Q5: What happens if you call rs.previous() on a TYPE_FORWARD_ONLY ResultSet?**
> **A:** You get a SQLException with message like "Operation not permitted for forward-only result set". Forward-only ResultSets only support `next()` method.

**Q6: What is the significance of including primary key in the SELECT query for updatable ResultSet?**
> **A:** JDBC needs the primary key to uniquely identify which row to update in the database. Without it, the update may fail or the ResultSet may not be updatable.
