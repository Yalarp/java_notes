# 📚 DDL Commands - Data Definition Language

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Create, alter, and drop tables with proper syntax
- Add, modify, and remove columns from existing tables
- Rename tables and columns
- Understand the difference between DROP and TRUNCATE
- Work with column defaults and constraints

---

## 📖 Table of Contents
1. [What is DDL?](#1-what-is-ddl)
2. [CREATE TABLE](#2-create-table)
3. [ALTER TABLE](#3-alter-table)
4. [DROP and TRUNCATE](#4-drop-and-truncate)
5. [RENAME Operations](#5-rename-operations)
6. [Key Takeaways](#6-key-takeaways)

---

## 1. What is DDL?

**DDL (Data Definition Language)** consists of SQL commands that define or modify the structure of database objects like tables, indexes, and views.

### DDL Commands Overview
```
┌────────────────────────────────────────────────────────────────┐
│                      DDL Commands                               │
├─────────────┬──────────────────────────────────────────────────┤
│   CREATE    │  Create new database/table/index/view            │
├─────────────┼──────────────────────────────────────────────────┤
│   ALTER     │  Modify existing database objects                 │
├─────────────┼──────────────────────────────────────────────────┤
│   DROP      │  Delete database/table/index/view completely      │
├─────────────┼──────────────────────────────────────────────────┤
│   TRUNCATE  │  Remove all rows from table (keep structure)      │
├─────────────┼──────────────────────────────────────────────────┤
│   RENAME    │  Rename tables or columns                         │
└─────────────┴──────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> **All DDL commands are AUTO-COMMITTED!** They cannot be rolled back.

---

## 2. CREATE TABLE

### Basic Syntax

```sql
CREATE TABLE table_name (
    column1 datatype [constraints],
    column2 datatype [constraints],
    ...
);
```

### Example 1: Simple Table Creation

```sql
CREATE TABLE test(id INT, name VARCHAR(100));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE    -- DDL keyword to create a new table
test            -- Name of the table (case-insensitive in MySQL)
(               -- Opening parenthesis for column definitions
    id INT,     -- Column 'id' with Integer data type
    name VARCHAR(100)  -- Column 'name' with Variable Character (max 100 chars)
)               -- Closing parenthesis
;               -- Statement terminator
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Parse the SQL statement                             │
│         ↓                                                   │
│ Step 2: Validate table name (doesn't exist already)         │
│         ↓                                                   │
│ Step 3: Validate data types and constraints                 │
│         ↓                                                   │
│ Step 4: Create table structure in selected database         │
│         ↓                                                   │
│ Step 5: Update system catalog (information_schema)          │
│         ↓                                                   │
│ Step 6: AUTO-COMMIT (changes are permanent)                 │
│         ↓                                                   │
│ Step 7: Return "Query OK, 0 rows affected"                  │
└─────────────────────────────────────────────────────────────┘
```

---

### Example 2: Table with Multiple Columns

```sql
CREATE TABLE t1 (c1 INT, c2 VARCHAR(100), c3 DATE);
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t1 (    -- Create table named 't1'
    c1 INT,          -- First column: integer type
    c2 VARCHAR(100), -- Second column: string up to 100 characters
    c3 DATE          -- Third column: date type (format: YYYY-MM-DD)
);
```

---

### Example 3: Table with Constraints

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2) DEFAULT 0.00,
    dept_id INT,
    hire_date DATE DEFAULT (CURRENT_DATE)
);
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE employees (           -- Create table 'employees'
    emp_id INT PRIMARY KEY,        -- emp_id: integer, unique identifier for each row
    emp_name VARCHAR(100) NOT NULL,-- emp_name: required field (cannot be NULL)
    email VARCHAR(100) UNIQUE,     -- email: must be unique across all rows
    salary DECIMAL(10,2) DEFAULT 0.00, -- salary: defaults to 0.00 if not provided
    dept_id INT,                   -- dept_id: optional (can be NULL)
    hire_date DATE DEFAULT (CURRENT_DATE) -- defaults to today's date
);
```

---

### Verify Table Creation

```sql
-- Show all tables in current database
SHOW TABLES;

-- Describe table structure
DESC test;
-- or
DESCRIBE test;
```

**Sample Output of DESC:**
```
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | int(11)      | YES  |     | NULL    |       |
| name  | varchar(100) | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+
```

---

## 3. ALTER TABLE

ALTER TABLE is used to modify the structure of an existing table.

### 3.1 Add a Column

```sql
ALTER TABLE test ADD c1 INT;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE     -- DDL keyword to modify existing table
test            -- Name of the table to modify
ADD             -- Operation: adding something to the table
c1              -- Name of the new column
INT             -- Data type of the new column
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Lock the table                                      │
│         ↓                                                   │
│ Step 2: Add new column to table structure                   │
│         ↓                                                   │
│ Step 3: Existing rows get NULL for new column               │
│         ↓                                                   │
│ Step 4: Update metadata                                     │
│         ↓                                                   │
│ Step 5: AUTO-COMMIT                                         │
│         ↓                                                   │
│ Step 6: Unlock table                                        │
└─────────────────────────────────────────────────────────────┘
```

**Verify:**
```sql
DESC test;
-- Now shows three columns: id, name, c1
```

---

### 3.2 Add Column with Default Value

```sql
ALTER TABLE test ADD c1 INT DEFAULT 10;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test   -- Modify the 'test' table
ADD c1 INT         -- Add new column 'c1' of type INT
DEFAULT 10         -- Set default value to 10 for new inserts
;
```

**What happens:**
- New column `c1` is added
- Existing rows get `NULL` for this column (NOT the default)
- Future INSERT statements without `c1` value will use 10

---

### 3.3 Add Multiple Columns (MySQL Limitation)

```sql
-- This will NOT work in MySQL:
ALTER TABLE test ADD c2 INT DEFAULT 10, c3 INT;

-- You need separate statements:
ALTER TABLE test ADD c2 INT DEFAULT 10;
ALTER TABLE test ADD c3 INT;
```

> [!WARNING]
> MySQL doesn't support adding multiple columns with DEFAULT in a single ALTER statement!

---

### 3.4 Drop a Column

```sql
ALTER TABLE test DROP COLUMN c1;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test   -- Modify the 'test' table
DROP COLUMN        -- Operation: remove a column
c1                 -- Name of column to remove
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Check if column exists                              │
│         ↓                                                   │
│ Step 2: Check for dependencies (indexes, foreign keys)      │
│         ↓                                                   │
│ Step 3: Remove column from all rows                         │
│         ↓                                                   │
│ Step 4: Update table structure                              │
│         ↓                                                   │
│ Step 5: AUTO-COMMIT (data is permanently deleted!)          │
└─────────────────────────────────────────────────────────────┘
```

> [!CAUTION]
> Dropping a column **permanently deletes** all data in that column!

---

### 3.5 Modify Column Data Type

```sql
ALTER TABLE test MODIFY COLUMN name VARCHAR(200);
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test       -- Modify the 'test' table
MODIFY COLUMN          -- Operation: change column properties
name                   -- Column to modify
VARCHAR(200)           -- New data type (increased from 100 to 200)
;
```

**Common Modifications:**
```sql
-- Increase string length
ALTER TABLE test MODIFY COLUMN name VARCHAR(200);

-- Change data type (be careful with existing data!)
ALTER TABLE test MODIFY COLUMN salary DECIMAL(12,2);

-- Add NOT NULL constraint
ALTER TABLE test MODIFY COLUMN id INT NOT NULL;
```

---

### 3.6 Add NOT NULL Constraint

```sql
ALTER TABLE test MODIFY COLUMN id INT NOT NULL;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test       -- Modify the 'test' table
MODIFY COLUMN id       -- Modify the 'id' column
INT                    -- Keep the same data type
NOT NULL               -- Add constraint: no NULL values allowed
;
```

**After this change:**
```sql
-- This will FAIL because id cannot be NULL:
INSERT INTO test(name, c1) VALUES('a', 11);
-- Error: Field 'id' doesn't have a default value
```

---

## 4. DROP and TRUNCATE

### 4.1 DROP TABLE

Completely removes the table and all its data from the database.

```sql
DROP TABLE t1;
```

**Line-by-Line Breakdown:**
```sql
DROP TABLE    -- DDL keyword to delete a table
t1            -- Name of table to delete
;
```

**What Gets Deleted:**
- ✅ All data (rows)
- ✅ Table structure
- ✅ Indexes
- ✅ Triggers
- ✅ Constraints

**Safe Drop (prevents error if table doesn't exist):**
```sql
DROP TABLE IF EXISTS t1;
```

---

### 4.2 TRUNCATE TABLE

Removes all rows from a table but keeps the structure.

```sql
TRUNCATE TABLE test;
```

**Line-by-Line Breakdown:**
```sql
TRUNCATE TABLE    -- DDL keyword to remove all rows
test              -- Name of table to truncate
;
```

---

### DROP vs TRUNCATE vs DELETE

| Feature | DROP | TRUNCATE | DELETE |
|---------|------|----------|--------|
| **Type** | DDL | DDL | DML |
| **Removes Data** | Yes | Yes | Yes |
| **Removes Structure** | Yes | No | No |
| **Can Rollback** | No | No | Yes |
| **Speed** | Fast | Very Fast | Slow |
| **WHERE Clause** | N/A | N/A | Yes |
| **Resets AUTO_INCREMENT** | N/A | Yes | No |
| **Fires Triggers** | No | No | Yes |

**Visual Comparison:**
```
┌──────────────────────────────────────────────────────────────────┐
│                     Original Table: test                         │
├────────┬───────────────────────────────────────────────────────┤
│   id   │   name                                                  │
├────────┼───────────────────────────────────────────────────────┤
│   1    │   John                                                  │
│   2    │   Jane                                                  │
│   3    │   Bob                                                   │
└────────┴───────────────────────────────────────────────────────┘

After DROP TABLE test:
┌──────────────────────────────────────────────────────────────────┐
│  Table 'test' doesn't exist!                                     │
│  No structure, no data.                                          │
└──────────────────────────────────────────────────────────────────┘

After TRUNCATE TABLE test:
┌──────────────────────────────────────────────────────────────────┐
│                     Table: test (empty)                          │
├────────┬───────────────────────────────────────────────────────┤
│   id   │   name                                                  │
├────────┼───────────────────────────────────────────────────────┤
│ (empty - 0 rows)                                                 │
└────────┴───────────────────────────────────────────────────────┘

After DELETE FROM test:
┌──────────────────────────────────────────────────────────────────┐
│                     Table: test (empty but recoverable)          │
├────────┬───────────────────────────────────────────────────────┤
│   id   │   name                                                  │
├────────┼───────────────────────────────────────────────────────┤
│ (empty - 0 rows) - Can ROLLBACK to recover!                      │
└────────┴───────────────────────────────────────────────────────┘
```

---

## 5. RENAME Operations

### 5.1 Rename Table

```sql
ALTER TABLE test RENAME TO test2;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test   -- Select the table to modify
RENAME TO          -- Operation: rename the table
test2              -- New name for the table
;
```

**Rename Back:**
```sql
ALTER TABLE test2 RENAME TO test;
```

---

### 5.2 Rename Column

```sql
ALTER TABLE test RENAME COLUMN name TO name2;
```

**Line-by-Line Breakdown:**
```sql
ALTER TABLE test       -- Select the table to modify
RENAME COLUMN          -- Operation: rename a column
name                   -- Current column name
TO name2               -- New column name
;
```

**Rename Back:**
```sql
ALTER TABLE test RENAME COLUMN name2 TO name;
```

---

### 5.3 Complete ALTER Examples from Source

```sql
-- Example sequence from training:

-- Create initial table
CREATE TABLE test(id INT, name VARCHAR(100));

-- Add a column
ALTER TABLE test ADD c1 INT;

-- Insert data
INSERT INTO test VALUES(1, 'a', 1);

-- Drop the column
ALTER TABLE test DROP COLUMN c1;

-- Add column again
ALTER TABLE test ADD c1 INT;

-- Drop column
ALTER TABLE test DROP COLUMN c1;

-- Add column with default
ALTER TABLE test ADD c1 INT DEFAULT 10;

-- Modify column size
ALTER TABLE test MODIFY COLUMN name VARCHAR(200);

-- Add NOT NULL constraint to id
ALTER TABLE test MODIFY COLUMN id INT NOT NULL;

-- This fails because id cannot be NULL and has no default:
INSERT INTO test(name, c1) VALUES('a', 11);
-- Error: Field 'id' doesn't have a default value

-- Rename table
ALTER TABLE test RENAME TO test2;

-- Rename back
ALTER TABLE test2 RENAME TO test;

-- Rename column
ALTER TABLE test RENAME COLUMN name TO name2;

-- Rename column back
ALTER TABLE test RENAME COLUMN name2 TO name;
```

---

## 6. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **DDL Commands are AUTO-COMMITTED** - Cannot be rolled back!
> 
> 2. **CREATE TABLE:**
>    - `CREATE TABLE name (columns...)`
>    - Define columns with data types and constraints
> 
> 3. **ALTER TABLE:**
>    - `ADD column` - Add new column
>    - `DROP COLUMN column` - Remove column
>    - `MODIFY COLUMN` - Change data type/constraints
>    - `RENAME TO` - Rename table
>    - `RENAME COLUMN` - Rename column
> 
> 4. **DROP vs TRUNCATE:**
>    - DROP = Delete table completely
>    - TRUNCATE = Delete all rows, keep structure
>    - DELETE = DML, can be rolled back
> 
> 5. **Adding columns:**
>    - Existing rows get NULL (not default value)
>    - Default applies only to future INSERTs

---

## 📋 Practice Exercises

### Exercise 1: Table Creation and Modification
```sql
-- Task: Create and modify a products table

-- 1. Create table with basic columns
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
);

-- 2. Add a 'category' column
ALTER TABLE products ADD category VARCHAR(50);

-- 3. Add a 'stock_quantity' column with default 0
ALTER TABLE products ADD stock_quantity INT DEFAULT 0;

-- 4. Make product_id NOT NULL
ALTER TABLE products MODIFY COLUMN product_id INT NOT NULL;

-- 5. Verify the structure
DESC products;
```

### Exercise 2: Drop and Truncate Practice
```sql
-- Create test table
CREATE TABLE temp_data (id INT, value VARCHAR(50));
INSERT INTO temp_data VALUES(1,'a'),(2,'b'),(3,'c');

-- Count rows
SELECT COUNT(*) FROM temp_data;  -- 3

-- Truncate (remove data, keep structure)
TRUNCATE TABLE temp_data;
SELECT COUNT(*) FROM temp_data;  -- 0
DESC temp_data;  -- Structure still exists

-- Drop (remove everything)
DROP TABLE temp_data;
DESC temp_data;  -- Error: Table doesn't exist
```

---

## 📚 Further Reading
- [Previous: SQL Fundamentals ←](./02_SQL_Fundamentals.md)
- [Next: DML Commands →](./04_DML_Commands.md)

---

*Last Updated: December 2024*
