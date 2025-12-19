# 📚 DML Commands - Data Manipulation Language

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Insert data into tables using various methods
- Update existing records with WHERE conditions
- Delete records selectively or completely
- Understand NULL values and their behavior
- Master single-row and multi-row operations

---

## 📖 Table of Contents
1. [What is DML?](#1-what-is-dml)
2. [INSERT Statement](#2-insert-statement)
3. [UPDATE Statement](#3-update-statement)
4. [DELETE Statement](#4-delete-statement)
5. [Understanding NULL](#5-understanding-null)
6. [Key Takeaways](#6-key-takeaways)

---

## 1. What is DML?

**DML (Data Manipulation Language)** consists of SQL commands that manipulate data within tables.

### DML Commands Overview
```
┌────────────────────────────────────────────────────────────────┐
│                      DML Commands                               │
├─────────────┬──────────────────────────────────────────────────┤
│   INSERT    │  Add new rows to a table                         │
├─────────────┼──────────────────────────────────────────────────┤
│   UPDATE    │  Modify existing rows in a table                 │
├─────────────┼──────────────────────────────────────────────────┤
│   DELETE    │  Remove rows from a table                        │
└─────────────┴──────────────────────────────────────────────────┘
```

> [!NOTE]
> DML commands can be **rolled back** before COMMIT (unlike DDL commands)

---

## 2. INSERT Statement

### 2.1 Single Row Insert with Column Names

```sql
INSERT INTO test(id, name) VALUES(1, 'a');
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO    -- Keyword to add data
test           -- Name of the table
(id, name)     -- List of columns to insert into
VALUES         -- Keyword introducing the values
(1, 'a')       -- Actual values in same order as columns
;              -- Statement terminator
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Parse SQL and validate table name                   │
│         ↓                                                   │
│ Step 2: Check column names exist in table                   │
│         ↓                                                   │
│ Step 3: Validate data types match column types              │
│         ↓                                                   │
│ Step 4: Check all constraints (PK, FK, NOT NULL, etc.)      │
│         ↓                                                   │
│ Step 5: Insert row into table (in transaction buffer)       │
│         ↓                                                   │
│ Step 6: Return "1 row affected"                             │
│         ↓                                                   │
│ Step 7: Wait for COMMIT or ROLLBACK (if in transaction)     │
└─────────────────────────────────────────────────────────────┘
```

---

### 2.2 Single Row Insert without Column Names

```sql
INSERT INTO test VALUES(2, 'b');
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO test   -- Insert into 'test' table
VALUES             -- Values keyword
(2, 'b')           -- Values for ALL columns in order
;
```

> [!WARNING]
> When omitting column names, you must provide values for **ALL columns** in the exact order they appear in the table!

**Verification:**
```sql
-- Check column order first
DESC test;
-- id comes first, then name
```

---

### 2.3 Multi-Row Insert

```sql
INSERT INTO test VALUES(3,'c'),(4,'d'),(5,'e'),(6,'f');
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO test VALUES  -- Insert multiple rows into 'test'
(3, 'c'),                -- First row: id=3, name='c'
(4, 'd'),                -- Second row: id=4, name='d'
(5, 'e'),                -- Third row: id=5, name='e'
(6, 'f')                 -- Fourth row: id=6, name='f'
;
```

**Why use Multi-Row Insert?**
- ✅ **Faster** - Single database round-trip
- ✅ **Atomic** - All succeed or all fail
- ✅ **Less overhead** - Reduced parsing time

---

### 2.4 Insert with Partial Columns

```sql
INSERT INTO test(id) VALUES(7);
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO test(id)  -- Only specify 'id' column
VALUES(7)             -- Only provide value for 'id'
;
```

**Result:**
- `id` column gets value 7
- `name` column gets **NULL** (value not yet defined)

> [!IMPORTANT]
> **NULL means "value not yet defined"** — it doesn't mean blank or 0!

---

### 2.5 Insert with Date Values

```sql
INSERT INTO t1 VALUES(1, 'a', '2025-02-20');
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO t1 VALUES  -- Insert into table t1 (has: c1 INT, c2 VARCHAR, c3 DATE)
(
    1,                 -- c1 value: integer
    'a',               -- c2 value: string
    '2025-02-20'       -- c3 value: date in YYYY-MM-DD format
);
```

---

### 2.6 Insert from Recursive CTE (Advanced)

This example from the source creates 100 employee records automatically:

```sql
INSERT INTO emp
WITH RECURSIVE tab AS (
    SELECT 
        1 eid,                              -- Starting employee ID
        CAST('a1' AS CHAR(100)) AS ename,   -- Starting name
        RAND()*10000 salary,                -- Random salary
        1 deptid                            -- Starting department
    UNION ALL
    SELECT 
        eid+1,                              -- Increment employee ID
        CONCAT('a', eid+1),                 -- Generate name like 'a2', 'a3'...
        RAND()*10000 salary,                -- Random salary
        MOD(eid, 3)+1                       -- Rotate through departments 1,2,3
    FROM tab 
    WHERE eid < 100                         -- Generate 100 rows
)
SELECT * FROM tab;
```

**Line-by-Line Breakdown:**
```sql
INSERT INTO emp           -- Target table for insertion
WITH RECURSIVE tab AS (   -- Create recursive CTE named 'tab'
    -- Base case: first row
    SELECT 1 eid,         -- Employee ID starts at 1
        CAST('a1' AS CHAR(100)) AS ename,  -- Employee name 'a1'
        RAND()*10000 salary,               -- Random salary between 0-10000
        1 deptid                           -- Department ID 1
    UNION ALL             -- Combine with recursive part
    -- Recursive case: generate subsequent rows
    SELECT eid+1,         -- Increment ID by 1
        CONCAT('a', eid+1),  -- Name = 'a' + new ID
        RAND()*10000 salary, -- New random salary
        MOD(eid, 3)+1        -- Cycle through depts: 1,2,3,1,2,3...
    FROM tab              -- Reference the CTE itself
    WHERE eid < 100       -- Stop after 100 rows
)
SELECT * FROM tab;        -- Select all generated rows for insertion
```

**Execution Flow:**
```
Iteration 1: (1, 'a1', 5234.12, 1)
Iteration 2: (2, 'a2', 8912.45, 2)
Iteration 3: (3, 'a3', 3421.78, 3)
Iteration 4: (4, 'a4', 6543.21, 1)
...
Iteration 100: (100, 'a100', 7845.32, 1)
```

---

## 3. UPDATE Statement

### 3.1 Basic Update

```sql
UPDATE test SET name = 'xyz' WHERE id = 10;
```

**Line-by-Line Breakdown:**
```sql
UPDATE test        -- Specify which table to update
SET name = 'xyz'   -- Set the 'name' column to 'xyz'
WHERE id = 10      -- Only update rows where id equals 10
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Find all rows matching WHERE clause                 │
│         ↓                                                   │
│ Step 2: For each matching row:                              │
│         - Validate new values                               │
│         - Check constraints                                 │
│         - Store old value (for potential ROLLBACK)          │
│         - Apply new value                                   │
│         ↓                                                   │
│ Step 3: Return "X rows affected"                            │
│         ↓                                                   │
│ Step 4: Wait for COMMIT or ROLLBACK                         │
└─────────────────────────────────────────────────────────────┘
```

---

### 3.2 Update Multiple Columns

```sql
UPDATE test SET name = 'john', id = 12 WHERE id = 9;
```

**Line-by-Line Breakdown:**
```sql
UPDATE test            -- Update the 'test' table
SET 
    name = 'john',     -- Change name to 'john'
    id = 12            -- Change id to 12
WHERE id = 9           -- Only where current id is 9
;
```

**Visual Representation:**
```
BEFORE UPDATE:
┌────────┬───────────┐
│   id   │   name    │
├────────┼───────────┤
│   9    │ dedeasae  │
└────────┴───────────┘

AFTER UPDATE:
┌────────┬───────────┐
│   id   │   name    │
├────────┼───────────┤
│   12   │   john    │
└────────┴───────────┘
```

---

### 3.3 Update Without WHERE (Dangerous!)

```sql
-- This updates ALL rows in the table!
UPDATE test SET name = 'same_name';
```

> [!CAUTION]
> **Updating without WHERE affects EVERY row!** Always double-check your WHERE clause.

---

### 3.4 Update with Calculations

```sql
-- Give 10% raise to all employees in department 101
UPDATE employees SET salary = salary * 1.1 WHERE dept_id = 101;
```

**Line-by-Line Breakdown:**
```sql
UPDATE employees          -- Update employees table
SET salary = salary * 1.1 -- Multiply current salary by 1.1 (10% increase)
WHERE dept_id = 101       -- Only for department 101
;
```

---

## 4. DELETE Statement

### 4.1 Delete Specific Rows

```sql
DELETE FROM test WHERE id = 12;
```

**Line-by-Line Breakdown:**
```sql
DELETE FROM test   -- Delete from 'test' table
WHERE id = 12      -- Only rows where id equals 12
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Find all rows matching WHERE clause                 │
│         ↓                                                   │
│ Step 2: Store rows in transaction log (for ROLLBACK)        │
│         ↓                                                   │
│ Step 3: Mark rows as deleted                                │
│         ↓                                                   │
│ Step 4: Return "X rows affected"                            │
│         ↓                                                   │
│ Step 5: Wait for COMMIT or ROLLBACK                         │
└─────────────────────────────────────────────────────────────┘
```

---

### 4.2 Delete All Rows

```sql
DELETE FROM test;
```

**Line-by-Line Breakdown:**
```sql
DELETE FROM test   -- Delete from 'test' table
;                  -- No WHERE = delete ALL rows
```

> [!WARNING]
> **Deleting without WHERE removes ALL rows!** But unlike TRUNCATE, this can be rolled back.

---

### 4.3 DELETE vs TRUNCATE Comparison

```sql
-- Both remove all rows, but:

-- DELETE (DML) - can be rolled back
START TRANSACTION;
DELETE FROM test;
ROLLBACK;  -- Data restored!

-- TRUNCATE (DDL) - cannot be rolled back
TRUNCATE TABLE test;  -- Data gone forever!
```

| Feature | DELETE | TRUNCATE |
|---------|--------|----------|
| Command Type | DML | DDL |
| Can Rollback | Yes | No |
| WHERE clause | Yes | No |
| Speed | Slower | Faster |
| Triggers | Fires | Doesn't fire |
| Reset AUTO_INCREMENT | No | Yes |

---

## 5. Understanding NULL

### What is NULL?

> **NULL means "value not yet defined"** — it's NOT blank, NOT zero, NOT an empty string!

```sql
-- This row has NULL for 'name' column
INSERT INTO test(id) VALUES(7);

-- When you select, NULL shows as empty but IS NOT empty string
SELECT * FROM test WHERE id = 7;
-- Returns: id=7, name=NULL
```

---

### 5.1 Checking for NULL

```sql
-- CORRECT way to check for NULL
SELECT * FROM test WHERE name IS NULL;

-- CORRECT way to check for NOT NULL
SELECT * FROM test WHERE name IS NOT NULL;

-- WRONG way (this doesn't work!)
SELECT * FROM test WHERE name = NULL;   -- Wrong!
SELECT * FROM test WHERE name != NULL;  -- Wrong!
```

**Why `= NULL` doesn't work:**
- NULL is "unknown"
- Unknown compared to unknown = unknown (not TRUE or FALSE)
- Use `IS NULL` or `IS NOT NULL` instead

---

### 5.2 NULL in Constraints

```sql
-- UNIQUE allows multiple NULLs
CREATE TABLE t_uk (id INT UNIQUE, name VARCHAR(100));

INSERT INTO t_uk VALUES(1, 'a');    -- Works
INSERT INTO t_uk VALUES(1, 'b');    -- FAILS (duplicate)
INSERT INTO t_uk VALUES(NULL, 'a'); -- Works
INSERT INTO t_uk VALUES(NULL, 'b'); -- Works (NULL not duplicate)
INSERT INTO t_uk(name) VALUES('b'); -- Works (id is NULL)

-- PRIMARY KEY doesn't allow NULL
CREATE TABLE t_pk(id INT PRIMARY KEY, name VARCHAR(100));

INSERT INTO t_pk VALUES(1, 'a');    -- Works
INSERT INTO t_pk VALUES(NULL, 'b'); -- FAILS (NULL not allowed in PK)
```

---

### 5.3 NULL in DEFAULT

```sql
CREATE TABLE t_def (id INT, name VARCHAR(100), salary INT DEFAULT 1000);

-- Omit column = use default
INSERT INTO t_def(id, name) VALUES(1, 'a');
SELECT * FROM t_def;  -- salary = 1000

-- Explicit NULL overrides default
INSERT INTO t_def(id, name, salary) VALUES(2, 'b', NULL);
SELECT * FROM t_def WHERE id = 2;  -- salary = NULL (not 1000!)
```

---

### 5.4 NULL in CHECK Constraint

```sql
CREATE TABLE t_cc(eid INT, ename VARCHAR(100), salary INT CHECK(salary >= 100));

INSERT INTO t_cc VALUES(1, 'a', 50);   -- FAILS (50 < 100)
INSERT INTO t_cc VALUES(1, 'a', 500);  -- Works
INSERT INTO t_cc VALUES(1, 'a', NULL); -- Works! (NULL bypasses CHECK)
```

> [!NOTE]
> NULL values typically bypass CHECK constraints because NULL comparisons return unknown, not FALSE.

---

## 6. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **INSERT:**
>    - With columns: `INSERT INTO table(cols) VALUES(...)`
>    - Without columns: `INSERT INTO table VALUES(...)` (all columns required)
>    - Multi-row: `VALUES(...),(...),(...)`
> 
> 2. **UPDATE:**
>    - Always use WHERE: `UPDATE table SET col=value WHERE condition`
>    - Without WHERE updates ALL rows!
>    - Can update multiple columns in one statement
> 
> 3. **DELETE:**
>    - With WHERE: `DELETE FROM table WHERE condition`
>    - Without WHERE deletes ALL rows (but can rollback)
> 
> 4. **NULL:**
>    - Means "unknown/undefined" (NOT zero or empty)
>    - Check with `IS NULL` / `IS NOT NULL`
>    - Never use `= NULL`
> 
> 5. **DML vs DDL:**
>    - DML (INSERT/UPDATE/DELETE) can be rolled back
>    - DDL (CREATE/ALTER/DROP/TRUNCATE) cannot

---

## 📋 Practice Exercises

### Exercise 1: Insert Operations
```sql
-- Create a products table and practice inserts
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT DEFAULT 0
);

-- 1. Insert single product with all columns
INSERT INTO products VALUES(1, 'Laptop', 999.99, 50);

-- 2. Insert product without stock (uses default)
INSERT INTO products(product_id, product_name, price) VALUES(2, 'Mouse', 29.99);

-- 3. Insert multiple products at once
INSERT INTO products VALUES
    (3, 'Keyboard', 79.99, 100),
    (4, 'Monitor', 299.99, 25),
    (5, 'Headphones', 149.99, 75);

-- Verify
SELECT * FROM products;
```

### Exercise 2: Update Operations
```sql
-- 1. Increase price of Laptop by 10%
UPDATE products SET price = price * 1.1 WHERE product_id = 1;

-- 2. Update both name and stock for product 2
UPDATE products SET product_name = 'Wireless Mouse', stock = 200 WHERE product_id = 2;

-- 3. Reduce all stock by 5
UPDATE products SET stock = stock - 5;

-- Verify
SELECT * FROM products;
```

### Exercise 3: Delete Operations
```sql
-- 1. Delete product with low stock
DELETE FROM products WHERE stock < 25;

-- 2. Delete by name
DELETE FROM products WHERE product_name = 'Headphones';

-- Verify
SELECT * FROM products;
```

---

## 📚 Further Reading
- [Previous: DDL Commands ←](./03_DDL_Commands.md)
- [Next: Data Constraints →](./05_Data_Constraints.md)

---

*Last Updated: December 2024*
