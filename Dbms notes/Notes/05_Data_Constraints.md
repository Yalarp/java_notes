# 📚 Data Constraints in SQL

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand and implement PRIMARY KEY constraints
- Create FOREIGN KEY relationships between tables
- Use UNIQUE constraints (single and composite)
- Apply NOT NULL, CHECK, and DEFAULT constraints
- Handle constraint violations

---

## 📖 Table of Contents
1. [What are Constraints?](#1-what-are-constraints)
2. [PRIMARY KEY](#2-primary-key)
3. [FOREIGN KEY](#3-foreign-key)
4. [UNIQUE](#4-unique)
5. [NOT NULL](#5-not-null)
6. [CHECK](#6-check)
7. [DEFAULT](#7-default)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. What are Constraints?

**Constraints** are rules enforced on table columns to ensure data integrity, accuracy, and reliability.

### Types of Constraints
```
┌────────────────────────────────────────────────────────────────┐
│                     SQL Constraints                             │
├─────────────────┬──────────────────────────────────────────────┤
│   PRIMARY KEY   │  Unique identifier for each row               │
├─────────────────┼──────────────────────────────────────────────┤
│   FOREIGN KEY   │  Links to primary key in another table        │
├─────────────────┼──────────────────────────────────────────────┤
│   UNIQUE        │  Ensures all values in column are different   │
├─────────────────┼──────────────────────────────────────────────┤
│   NOT NULL      │  Ensures column cannot have NULL              │
├─────────────────┼──────────────────────────────────────────────┤
│   CHECK         │  Validates values against a condition         │
├─────────────────┼──────────────────────────────────────────────┤
│   DEFAULT       │  Sets default value if none provided          │
└─────────────────┴──────────────────────────────────────────────┘
```

### Constraint Comparison
| Constraint | NULL Allowed? | Duplicates Allowed? | Multiple Per Table? |
|------------|---------------|---------------------|---------------------|
| PRIMARY KEY | No | No | Only 1 |
| UNIQUE | Yes (multiple) | No | Yes |
| FOREIGN KEY | Yes | Yes | Yes |
| NOT NULL | No | Yes | Yes |
| CHECK | Yes (bypassed) | Yes | Yes |
| DEFAULT | Yes | Yes | Yes |

---

## 2. PRIMARY KEY

### Definition
A **PRIMARY KEY** uniquely identifies each record in a table. It must contain:
- **UNIQUE** values only
- **NO NULL** values

### 2.1 Simple Primary Key

```sql
CREATE TABLE t_pk(id INT PRIMARY KEY, name VARCHAR(100));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_pk (    -- Create table named 't_pk'
    id INT PRIMARY KEY,-- 'id' is integer AND the primary key
    name VARCHAR(100)  -- 'name' can have any varchar value (including NULL)
);
```

**Testing the Primary Key:**
```sql
INSERT INTO t_pk VALUES(1, 'a');    -- ✅ Works: first row with id=1
INSERT INTO t_pk VALUES(1, 'b');    -- ❌ FAILS: Duplicate entry '1' for key 'PRIMARY'
INSERT INTO t_pk VALUES(NULL, 'b'); -- ❌ FAILS: Column 'id' cannot be null
```

**Execution Flow when constraint violated:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Parse INSERT statement                              │
│         ↓                                                   │
│ Step 2: Check PRIMARY KEY constraint                        │
│         - Is value NULL? → REJECT                           │
│         - Does value already exist? → REJECT                │
│         ↓                                                   │
│ Step 3: If violation: Error returned, no insert             │
│         If valid: Insert row successfully                   │
└─────────────────────────────────────────────────────────────┘
```

---

### 2.2 Multiple Primary Keys (NOT ALLOWED)

```sql
-- This FAILS! Only ONE primary key allowed per table
CREATE TABLE t_pk_multi(c1 INT PRIMARY KEY, c2 INT PRIMARY KEY, c3 INT);
-- Error: Multiple primary key defined
```

**Explanation:**
- A table can have only **ONE** primary key
- But that key can be **composite** (multiple columns)

---

### 2.3 Composite Primary Key

```sql
CREATE TABLE t_pk_comp(c1 INT, c2 INT, c3 VARCHAR(100), PRIMARY KEY(c1, c3));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_pk_comp (
    c1 INT,                    -- First column
    c2 INT,                    -- Second column
    c3 VARCHAR(100),           -- Third column
    PRIMARY KEY(c1, c3)        -- Composite PK: combination of c1+c3 must be unique
);
```

**Testing Composite Primary Key:**
```sql
INSERT INTO t_pk_comp VALUES(1, 1, 'a');  -- ✅ Works: (1,'a') is unique
INSERT INTO t_pk_comp VALUES(2, 1, 'a');  -- ✅ Works: (2,'a') is unique (different c1)
INSERT INTO t_pk_comp VALUES(1, 1, 'b');  -- ✅ Works: (1,'b') is unique (different c3)
INSERT INTO t_pk_comp VALUES(1, 3, 'b');  -- ❌ FAILS: (1,'b') already exists
```

**Visual Representation:**
```
┌────────┬────────┬────────┐
│   c1   │   c2   │   c3   │  Composite PK = (c1, c3)
├────────┼────────┼────────┤
│   1    │   1    │   'a'  │  ✅ (1,'a') - first entry
│   2    │   1    │   'a'  │  ✅ (2,'a') - c1 different
│   1    │   1    │   'b'  │  ✅ (1,'b') - c3 different
│   1    │   3    │   'b'  │  ❌ (1,'b') - DUPLICATE!
└────────┴────────┴────────┘
```

---

## 3. FOREIGN KEY

### Definition
A **FOREIGN KEY** creates a link between two tables. It references the PRIMARY KEY of another table (parent table).

### 3.1 Creating Foreign Key Relationship

```sql
-- STEP 1: Create parent table with PRIMARY KEY
CREATE TABLE t_parent(deptid INT PRIMARY KEY, deptname VARCHAR(100));

-- STEP 2: Create child table with FOREIGN KEY
CREATE TABLE t_child(
    eid INT, 
    ename VARCHAR(100), 
    deptid INT,
    FOREIGN KEY fk1 (deptid) REFERENCES t_parent(deptid)
);
```

**Line-by-Line Breakdown:**
```sql
-- Parent table (must be created first)
CREATE TABLE t_parent (
    deptid INT PRIMARY KEY,    -- This is the referenced column
    deptname VARCHAR(100)
);

-- Child table
CREATE TABLE t_child (
    eid INT,                   -- Employee ID
    ename VARCHAR(100),        -- Employee name
    deptid INT,                -- Department ID (will reference parent)
    FOREIGN KEY fk1            -- Constraint name 'fk1'
    (deptid)                   -- Column in this table
    REFERENCES t_parent(deptid)-- Column in parent table
);
```

**FK Relationship Diagram:**
```
┌─────────────────────────────────┐       ┌─────────────────────────────────┐
│         t_parent                │       │         t_child                 │
├─────────────────────────────────┤       ├─────────────────────────────────┤
│ deptid INT (PK) ◄───────────────┼───────┤ deptid INT (FK)                │
│ deptname VARCHAR(100)           │       │ eid INT                         │
└─────────────────────────────────┘       │ ename VARCHAR(100)              │
                                          └─────────────────────────────────┘
```

---

### 3.2 Foreign Key Behavior

```sql
-- Before adding department, inserting employee fails:
INSERT INTO t_child VALUES(1, 'a', 1);
-- ❌ FAILS: Cannot add or update a child row: FK constraint fails
-- Reason: deptid=1 doesn't exist in t_parent yet

-- NULL is allowed in FK:
INSERT INTO t_child VALUES(1, 'a', NULL);
-- ✅ Works: NULL means "no department assigned"

-- First add the parent record:
INSERT INTO t_parent VALUES(1, 'HR');

-- Now child insert works:
INSERT INTO t_child VALUES(1, 'a', 1);
-- ✅ Works: deptid=1 now exists in parent
```

**Execution Flow for FK Validation:**
```
┌─────────────────────────────────────────────────────────────┐
│ INSERT INTO t_child VALUES(1, 'a', 1)                       │
│         ↓                                                   │
│ Step 1: Check if FK value is NULL                           │
│         - If NULL: Skip FK check (NULL allowed in FK)       │
│         - If NOT NULL: Proceed to Step 2                    │
│         ↓                                                   │
│ Step 2: Look up value in parent table's PK                  │
│         SELECT * FROM t_parent WHERE deptid = 1             │
│         ↓                                                   │
│ Step 3: If parent record EXISTS: Insert allowed             │
│         If parent record NOT EXISTS: INSERT REJECTED        │
└─────────────────────────────────────────────────────────────┘
```

---

### 3.3 FK Referential Actions

```sql
-- ON DELETE CASCADE: Delete child rows when parent is deleted
CREATE TABLE child (
    id INT,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES parent(id) ON DELETE CASCADE
);

-- ON UPDATE CASCADE: Update child FK when parent PK changes
CREATE TABLE child (
    id INT,
    parent_id INT,
    FOREIGN KEY (parent_id) REFERENCES parent(id) ON UPDATE CASCADE
);

-- Options: CASCADE, SET NULL, RESTRICT, NO ACTION
```

---

## 4. UNIQUE

### Definition
A **UNIQUE** constraint ensures all values in a column are different. Unlike PRIMARY KEY, UNIQUE allows NULL values.

### 4.1 Simple Unique Constraint

```sql
CREATE TABLE t_uk (id INT UNIQUE, name VARCHAR(100));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_uk (
    id INT UNIQUE,        -- 'id' must be unique, but NULL is allowed
    name VARCHAR(100)     -- 'name' has no constraint
);
```

**Testing Unique Constraint:**
```sql
INSERT INTO t_uk VALUES(1, 'a');    -- ✅ Works: first row with id=1
INSERT INTO t_uk VALUES(1, 'b');    -- ❌ FAILS: Duplicate entry '1'
INSERT INTO t_uk VALUES(NULL, 'a'); -- ✅ Works: NULL allowed in UNIQUE
INSERT INTO t_uk VALUES(NULL, 'b'); -- ✅ Works: Multiple NULLs allowed!
INSERT INTO t_uk(name) VALUES('c'); -- ✅ Works: id defaults to NULL
```

> [!IMPORTANT]
> **UNIQUE vs PRIMARY KEY:**
> - PRIMARY KEY: NO NULL, only ONE per table
> - UNIQUE: NULL allowed (multiple), multiple UNIQUE constraints per table

---

### 4.2 Multiple Unique Columns

```sql
CREATE TABLE t_uk_multi(c1 INT UNIQUE, c2 INT, c3 VARCHAR(100) UNIQUE);
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_uk_multi (
    c1 INT UNIQUE,         -- c1 must be unique
    c2 INT,                -- c2 has no constraint
    c3 VARCHAR(100) UNIQUE -- c3 must ALSO be unique (independently)
);
```

**Testing:**
```sql
INSERT INTO t_uk_multi VALUES(1, 1, 'a');  -- ✅ Works
INSERT INTO t_uk_multi VALUES(2, 1, 'a');  -- ❌ FAILS: c3='a' already exists
INSERT INTO t_uk_multi VALUES(1, 1, 'b');  -- ❌ FAILS: c1=1 already exists
INSERT INTO t_uk_multi VALUES(2, 1, 'b');  -- ✅ Works: both c1=2 and c3='b' are new
```

---

### 4.3 Composite Unique Constraint

```sql
CREATE TABLE t_uk_comp(c1 INT, c2 INT, c3 VARCHAR(100), UNIQUE(c1, c3));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_uk_comp (
    c1 INT,                -- First column
    c2 INT,                -- Second column  
    c3 VARCHAR(100),       -- Third column
    UNIQUE(c1, c3)         -- Combination of c1+c3 must be unique
);
```

**Testing Composite Unique:**
```sql
INSERT INTO t_uk_comp VALUES(1, 1, 'a');  -- ✅ Works: (1,'a') is unique
INSERT INTO t_uk_comp VALUES(2, 1, 'a');  -- ✅ Works: (2,'a') is unique (c1 different)
INSERT INTO t_uk_comp VALUES(1, 1, 'b');  -- ✅ Works: (1,'b') is unique (c3 different)
INSERT INTO t_uk_comp VALUES(1, 3, 'b');  -- ❌ FAILS: (1,'b') already exists!
```

**Visual Representation:**
```
┌────────┬────────┬────────┐
│   c1   │   c2   │   c3   │  Composite UNIQUE = (c1, c3)
├────────┼────────┼────────┤
│   1    │   1    │   'a'  │  ✅ (1,'a')
│   2    │   1    │   'a'  │  ✅ (2,'a') - c1 different from row 1
│   1    │   1    │   'b'  │  ✅ (1,'b') - c3 different from row 1
│   1    │   3    │   'b'  │  ❌ (1,'b') - same as row 3!
└────────┴────────┴────────┘
```

---

## 5. NOT NULL

### Definition
A **NOT NULL** constraint ensures a column cannot contain NULL values.

### 5.1 Creating NOT NULL Constraint

```sql
CREATE TABLE t_nn(id INT NOT NULL, name VARCHAR(100));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_nn (
    id INT NOT NULL,     -- 'id' must always have a value
    name VARCHAR(100)    -- 'name' can be NULL
);
```

**Testing NOT NULL:**
```sql
INSERT INTO t_nn VALUES(1, 'a');       -- ✅ Works
INSERT INTO t_nn VALUES(NULL, 'a');    -- ❌ FAILS: Column 'id' cannot be null
INSERT INTO t_nn(name) VALUES('a');    -- ❌ FAILS: Field 'id' doesn't have default
INSERT INTO t_nn(id) VALUES(2);        -- ✅ Works: name becomes NULL
```

---

### 5.2 Adding NOT NULL to Existing Column

```sql
-- Add NOT NULL constraint via ALTER
ALTER TABLE test MODIFY COLUMN id INT NOT NULL;
```

> [!WARNING]
> If the column already has NULL values, you must update them first!

---

## 6. CHECK

### Definition
A **CHECK** constraint validates that values in a column satisfy a specific condition.

### 6.1 Creating CHECK Constraint

```sql
CREATE TABLE t_cc(eid INT, ename VARCHAR(100), salary INT CHECK(salary >= 100));
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_cc (
    eid INT,                         -- Employee ID
    ename VARCHAR(100),              -- Employee name
    salary INT CHECK(salary >= 100)  -- Salary must be 100 or more
);
```

**Testing CHECK Constraint:**
```sql
INSERT INTO t_cc VALUES(1, 'a', 50);   -- ❌ FAILS: Check constraint violated
INSERT INTO t_cc VALUES(1, 'a', 500);  -- ✅ Works: 500 >= 100
INSERT INTO t_cc VALUES(1, 'a', 100);  -- ✅ Works: 100 >= 100 (boundary)
INSERT INTO t_cc VALUES(1, 'a', NULL); -- ✅ Works! NULL bypasses CHECK
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ INSERT INTO t_cc VALUES(1, 'a', 50)                         │
│         ↓                                                   │
│ Step 1: Check if salary is NULL                             │
│         - If NULL: Skip check (NULL bypasses CHECK)         │
│         - If NOT NULL: Evaluate condition                   │
│         ↓                                                   │
│ Step 2: Evaluate: salary >= 100                             │
│         50 >= 100 → FALSE                                   │
│         ↓                                                   │
│ Step 3: REJECT INSERT - Check constraint violated           │
└─────────────────────────────────────────────────────────────┘
```

> [!NOTE]
> NULL values bypass CHECK constraints! If you want to prevent NULL, also add NOT NULL.

---

### 6.2 Complex CHECK Conditions

```sql
-- Multiple conditions
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    age INT CHECK(age >= 18 AND age <= 65),
    salary DECIMAL(10,2) CHECK(salary > 0),
    email VARCHAR(100) CHECK(email LIKE '%@%.%')
);
```

---

## 7. DEFAULT

### Definition
A **DEFAULT** constraint provides a default value for a column when no value is specified during INSERT.

### 7.1 Creating DEFAULT Constraint

```sql
CREATE TABLE t_def (id INT, name VARCHAR(100), salary INT DEFAULT 1000);
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t_def (
    id INT,                       -- No default
    name VARCHAR(100),            -- No default
    salary INT DEFAULT 1000       -- If salary not provided, use 1000
);
```

**Testing DEFAULT:**
```sql
-- Omitting column uses default
INSERT INTO t_def(id, name) VALUES(1, 'a');
SELECT * FROM t_def;  -- salary = 1000 ✅

-- Explicit NULL overrides default!
INSERT INTO t_def(id, name, salary) VALUES(2, 'b', NULL);
SELECT * FROM t_def WHERE id = 2;  -- salary = NULL (not 1000!)
```

**Visual Representation:**
```
┌────────────────────────────────────────────────────────────┐
│ INSERT INTO t_def(id, name) VALUES(1, 'a')                 │
│         ↓                                                  │
│ salary column not specified                                │
│         ↓                                                  │
│ Use DEFAULT value: 1000                                    │
│         ↓                                                  │
│ Result: (1, 'a', 1000)                                     │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ INSERT INTO t_def(id, name, salary) VALUES(2, 'b', NULL)   │
│         ↓                                                  │
│ salary explicitly set to NULL                              │
│         ↓                                                  │
│ NULL is a value, not "missing"                             │
│         ↓                                                  │
│ Result: (2, 'b', NULL)  -- NOT 1000!                       │
└────────────────────────────────────────────────────────────┘
```

---

### 7.2 DEFAULT with Other Constraints

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    join_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active','inactive') DEFAULT 'active',
    department VARCHAR(50) DEFAULT 'General'
);
```

---

## 8. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **PRIMARY KEY:**
>    - Unique + NOT NULL
>    - Only ONE per table
>    - Can be composite (multiple columns)
> 
> 2. **FOREIGN KEY:**
>    - References PK of another table
>    - NULL allowed (unless combined with NOT NULL)
>    - Parent record must exist first
> 
> 3. **UNIQUE:**
>    - No duplicates but NULL allowed
>    - Multiple NULLs allowed
>    - Multiple UNIQUE constraints per table
> 
> 4. **NOT NULL:**
>    - Column must have a value
>    - Often combined with other constraints
> 
> 5. **CHECK:**
>    - Validates condition on insert/update
>    - NULL bypasses CHECK (be careful!)
> 
> 6. **DEFAULT:**
>    - Used when column value not specified
>    - Explicit NULL overrides default

---

## 📋 Practice Exercises

### Exercise 1: Create Constrained Tables
```sql
-- Create a department table with constraints
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    budget DECIMAL(12,2) CHECK(budget > 0) DEFAULT 100000
);

-- Create employees table with FK to departments
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2) CHECK(salary >= 30000),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Test the constraints
INSERT INTO departments VALUES(1, 'Engineering', 500000);
INSERT INTO employees VALUES(1, 'John Doe', 'john@company.com', 75000, 1);
```

### Exercise 2: Constraint Violations
```sql
-- Test these and predict which will fail:

-- 1. Duplicate primary key
INSERT INTO departments VALUES(1, 'Marketing', 200000);  -- ?

-- 2. NULL in NOT NULL column
INSERT INTO departments VALUES(2, NULL, 200000);  -- ?

-- 3. FK to non-existent parent
INSERT INTO employees VALUES(2, 'Jane', 'jane@co.com', 60000, 99);  -- ?

-- 4. CHECK violation
INSERT INTO employees VALUES(3, 'Bob', 'bob@co.com', 20000, 1);  -- ?

-- 5. NULL bypasses CHECK
INSERT INTO employees VALUES(4, 'Sam', 'sam@co.com', NULL, 1);  -- ?
```

---

## 📚 Further Reading
- [Previous: DML Commands ←](./04_DML_Commands.md)
- [Next: SELECT and Filtering →](./06_SELECT_and_Filtering.md)

---

*Last Updated: December 2024*
