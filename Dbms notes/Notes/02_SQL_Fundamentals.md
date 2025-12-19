# 📚 SQL Fundamentals and MySQL Basics

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Connect to MySQL server and navigate databases
- Understand SQL categories (DDL, DML, DCL, TCL, DQL)
- Work with different SQL data types
- Perform basic database and table operations
- Use essential date/time functions

---

## 📖 Table of Contents
1. [Connecting to MySQL](#1-connecting-to-mysql)
2. [SQL Categories](#2-sql-categories)
3. [Database Operations](#3-database-operations)
4. [Data Types](#4-data-types)
5. [Date and Time Functions](#5-date-and-time-functions)
6. [Key Takeaways](#6-key-takeaways)

---

## 1. Connecting to MySQL

### Login Command Syntax

```sql
MySQL -uroot -ptest@123
```

**Line-by-Line Breakdown:**
```
MySQL       -- The MySQL client program executable
-u          -- Flag for username (no space needed)
root        -- Username (root is the admin account)
-p          -- Flag for password (no space needed)
test@123    -- The password for the user
```

### Execution Flow:
```
┌─────────────────────────────────────────────────────────────┐
│  1. Command sent to MySQL client                            │
│                    ↓                                        │
│  2. Client connects to MySQL server (default port 3306)     │
│                    ↓                                        │
│  3. Server authenticates username/password                  │
│                    ↓                                        │
│  4. If successful: mysql> prompt appears                    │
│     If failed: Access denied error                          │
└─────────────────────────────────────────────────────────────┘
```

### Connection Variations
```sql
-- Basic connection (will prompt for password)
mysql -u root -p

-- Connect to specific host
mysql -h localhost -u root -p

-- Connect to specific database directly
mysql -u root -p trainingdb

-- Connect to remote server
mysql -h 192.168.1.100 -u username -p
```

### First Commands After Login
```sql
-- Check which database is currently selected
SELECT database();
-- Returns NULL if no database selected

-- Show MySQL version
SELECT version();

-- Show current user
SELECT current_user();

-- Show current date and time
SELECT now();
```

---

## 2. SQL Categories

SQL commands are divided into **5 categories** based on their function:

### Visual Overview
```
┌────────────────────────────────────────────────────────────────────┐
│                         SQL Categories                              │
├────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│   │   DDL   │   │   DML   │   │   DQL   │   │   DCL   │   │   TCL   │
│   ├─────────┤   ├─────────┤   ├─────────┤   ├─────────┤   ├─────────┤
│   │ CREATE  │   │ INSERT  │   │ SELECT  │   │ GRANT   │   │ COMMIT  │
│   │ ALTER   │   │ UPDATE  │   │         │   │ REVOKE  │   │ ROLLBACK│
│   │ DROP    │   │ DELETE  │   │         │   │         │   │SAVEPOINT│
│   │ TRUNCATE│   │         │   │         │   │         │   │         │
│   │ RENAME  │   │         │   │         │   │         │   │         │
│   └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
│                                                                      │
└────────────────────────────────────────────────────────────────────┘
```

### 2.1 DDL - Data Definition Language

**Purpose:** Define and modify database structure (schema)

| Command | Description | Auto-Commit? |
|---------|-------------|--------------|
| `CREATE` | Create database/table/index/view | Yes |
| `ALTER` | Modify existing structure | Yes |
| `DROP` | Delete database/table/index/view | Yes |
| `TRUNCATE` | Remove all rows from table | Yes |
| `RENAME` | Rename database objects | Yes |

**Example:**
```sql
-- Create a new table
CREATE TABLE test(id INT, name VARCHAR(100));

-- Modify table structure
ALTER TABLE test ADD salary INT;

-- Delete table
DROP TABLE test;
```

> [!IMPORTANT]
> DDL commands are **auto-committed** - they cannot be rolled back!

---

### 2.2 DML - Data Manipulation Language

**Purpose:** Manipulate data within tables

| Command | Description | Auto-Commit? |
|---------|-------------|--------------|
| `INSERT` | Add new rows | No |
| `UPDATE` | Modify existing rows | No |
| `DELETE` | Remove rows | No |

**Example:**
```sql
-- Insert new row
INSERT INTO test(id, name) VALUES(1, 'John');

-- Update existing row
UPDATE test SET name = 'Jane' WHERE id = 1;

-- Delete row
DELETE FROM test WHERE id = 1;
```

> [!NOTE]
> DML commands can be **rolled back** before COMMIT

---

### 2.3 DQL - Data Query Language

**Purpose:** Retrieve data from database

| Command | Description |
|---------|-------------|
| `SELECT` | Query data from tables |

**Example:**
```sql
-- Basic select
SELECT * FROM test;

-- Select specific columns
SELECT id, name FROM test;

-- Select with condition
SELECT * FROM test WHERE id = 1;
```

---

### 2.4 DCL - Data Control Language

**Purpose:** Control access to data

| Command | Description |
|---------|-------------|
| `GRANT` | Give privileges to users |
| `REVOKE` | Remove privileges from users |

**Example:**
```sql
-- Grant SELECT privilege on employees table to user 'john'
GRANT SELECT ON trainingdb.employees TO 'john'@'localhost';

-- Revoke the privilege
REVOKE SELECT ON trainingdb.employees FROM 'john'@'localhost';
```

---

### 2.5 TCL - Transaction Control Language

**Purpose:** Manage transactions

| Command | Description |
|---------|-------------|
| `START TRANSACTION` | Begin a transaction |
| `COMMIT` | Save changes permanently |
| `ROLLBACK` | Undo changes |
| `SAVEPOINT` | Create a savepoint |

**Example:**
```sql
-- Start transaction
START TRANSACTION;

-- Perform operations
INSERT INTO test VALUES(1, 'a');
UPDATE test SET name = 'b' WHERE id = 1;

-- Save changes
COMMIT;

-- Or undo changes
-- ROLLBACK;
```

---

## 3. Database Operations

### 3.1 Show All Databases

```sql
SHOW DATABASES;
```

**Execution Flow:**
```
1. MySQL queries the information_schema
2. Returns list of all databases user has access to
3. System databases: mysql, information_schema, performance_schema
```

**Sample Output:**
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| trainingdb         |
+--------------------+
```

---

### 3.2 Create a New Database

```sql
CREATE DATABASE trainingdb;
```

**Line-by-Line Breakdown:**
```
CREATE DATABASE  -- Keyword to create new database
trainingdb       -- Name of database (case-insensitive in MySQL)
;                -- Statement terminator
```

**Execution Flow:**
```
┌──────────────────────────────────────────────────────┐
│ 1. Check if database name already exists            │
│ 2. If exists: Error "database exists"               │
│ 3. If not: Create directory for database            │
│ 4. Create metadata entries                          │
│ 5. Return success message                           │
└──────────────────────────────────────────────────────┘
```

**Variations:**
```sql
-- Create only if doesn't exist
CREATE DATABASE IF NOT EXISTS trainingdb;

-- Create with character set
CREATE DATABASE trainingdb CHARACTER SET utf8mb4;
```

---

### 3.3 Select/Use a Database

```sql
USE trainingdb;
```

**Line-by-Line Breakdown:**
```
USE          -- Keyword to switch to a database
trainingdb   -- Name of database to use
```

**Execution Flow:**
```
1. Check if database exists
2. Check if user has access
3. Set as current database for session
4. All subsequent table operations use this database
```

**Verification:**
```sql
-- Check current database
SELECT database();

-- Output: trainingdb
```

---

### 3.4 Show Tables in Database

```sql
SHOW TABLES;
```

**Sample Output:**
```
+----------------------+
| Tables_in_trainingdb |
+----------------------+
| customers            |
| employees            |
| orders               |
| products             |
+----------------------+
```

---

### 3.5 Describe Table Structure

```sql
DESC test;
-- or
DESCRIBE test;
```

**Sample Output:**
```
+-------+--------------+------+-----+---------+-------+
| Field | Type         | Null | Key | Default | Extra |
+-------+--------------+------+-----+---------+-------+
| id    | int(11)      | YES  |     | NULL    |       |
| name  | varchar(100) | YES  |     | NULL    |       |
+-------+--------------+------+-----+---------+-------+
```

**Column Meanings:**
| Column | Meaning |
|--------|---------|
| Field | Column name |
| Type | Data type |
| Null | YES = allows NULL, NO = NOT NULL |
| Key | PRI = Primary Key, UNI = Unique, MUL = Index |
| Default | Default value if not specified |
| Extra | Additional info (AUTO_INCREMENT, etc.) |

---

### 3.6 Create a Table

```sql
CREATE TABLE test(id INT, name VARCHAR(100));
```

**Line-by-Line Breakdown:**
```
CREATE TABLE    -- Keyword to create new table
test            -- Table name
(               -- Start of column definitions
  id INT,       -- Column 'id' of type Integer
  name VARCHAR(100)  -- Column 'name' of type Variable Character (max 100)
)               -- End of column definitions
;               -- Statement terminator
```

**Execution Flow:**
```
┌──────────────────────────────────────────────────────┐
│ 1. Parse column definitions                          │
│ 2. Validate data types                               │
│ 3. Check constraints                                 │
│ 4. Create table structure in database                │
│ 5. Update metadata catalog                           │
│ 6. Return success or error message                   │
└──────────────────────────────────────────────────────┘
```

---

## 4. Data Types

### 4.1 Numeric Data Types

| Type | Size | Range | Use Case |
|------|------|-------|----------|
| `TINYINT` | 1 byte | -128 to 127 | Age, small numbers |
| `SMALLINT` | 2 bytes | -32,768 to 32,767 | Year, quantity |
| `MEDIUMINT` | 3 bytes | -8M to 8M | Medium counts |
| `INT` | 4 bytes | -2B to 2B | Regular integers |
| `BIGINT` | 8 bytes | -9Q to 9Q | Large numbers (IDs) |
| `DECIMAL(p,s)` | Varies | Exact precision | Money, prices |
| `FLOAT` | 4 bytes | Approximate | Scientific data |
| `DOUBLE` | 8 bytes | Approximate | High precision floats |

**Examples:**
```sql
CREATE TABLE numbers_demo (
    tiny_num TINYINT,           -- Small integers
    regular_num INT,            -- Standard integers
    price DECIMAL(10,2),        -- Money: 10 total digits, 2 after decimal
    measurement FLOAT           -- Approximate values
);

INSERT INTO numbers_demo VALUES(100, 50000, 99999.99, 3.14159);
```

> [!TIP]
> Always use `DECIMAL` for money to avoid floating-point precision issues!

---

### 4.2 String Data Types

| Type | Max Length | Storage | Use Case |
|------|------------|---------|----------|
| `CHAR(n)` | 255 chars | Fixed n bytes | Fixed-length (country codes) |
| `VARCHAR(n)` | 65,535 chars | Variable | Names, addresses |
| `TEXT` | 65,535 chars | Variable | Long text |
| `MEDIUMTEXT` | 16MB | Variable | Articles |
| `LONGTEXT` | 4GB | Variable | Large documents |

**CHAR vs VARCHAR:**
```
┌───────────────────────────────────────────────────────┐
│ CHAR(10) storing 'ABC'                                │
│ Storage: [A][B][C][ ][ ][ ][ ][ ][ ][ ]  (10 bytes)  │
├───────────────────────────────────────────────────────┤
│ VARCHAR(10) storing 'ABC'                             │
│ Storage: [3][A][B][C]  (4 bytes: 1 length + 3 chars) │
└───────────────────────────────────────────────────────┘
```

**Examples:**
```sql
CREATE TABLE strings_demo (
    country_code CHAR(2),        -- 'US', 'IN', 'UK'
    name VARCHAR(100),           -- Variable length names
    description TEXT             -- Long descriptions
);
```

---

### 4.3 Date and Time Data Types

| Type | Format | Range | Use Case |
|------|--------|-------|----------|
| `DATE` | YYYY-MM-DD | 1000-01-01 to 9999-12-31 | Birth dates |
| `TIME` | HH:MM:SS | -838:59:59 to 838:59:59 | Duration |
| `DATETIME` | YYYY-MM-DD HH:MM:SS | 1000 to 9999 | Events |
| `TIMESTAMP` | YYYY-MM-DD HH:MM:SS | 1970 to 2038 | Auto-update |
| `YEAR` | YYYY | 1901 to 2155 | Year only |

**Examples:**
```sql
CREATE TABLE dates_demo (
    birth_date DATE,             -- '2000-01-15'
    start_time TIME,             -- '09:30:00'
    created_at DATETIME,         -- '2024-12-19 10:30:00'
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert date in MySQL format (YYYY-MM-DD)
INSERT INTO dates_demo(birth_date) VALUES('2025-02-20');
```

> [!WARNING]
> MySQL uses **YYYY-MM-DD** format! Not DD-MM-YYYY or MM-DD-YYYY

---

### 4.4 Other Data Types

| Type | Description | Use Case |
|------|-------------|----------|
| `BOOLEAN` | TRUE/FALSE (stored as TINYINT) | Flags |
| `ENUM` | Predefined list of values | Status, category |
| `SET` | Multiple values from list | Tags, options |
| `JSON` | JSON documents | Flexible data |
| `BLOB` | Binary data | Images, files |

**Examples:**
```sql
CREATE TABLE other_types (
    is_active BOOLEAN DEFAULT TRUE,
    status ENUM('pending', 'active', 'completed'),
    tags SET('urgent', 'important', 'review'),
    metadata JSON
);

INSERT INTO other_types VALUES(TRUE, 'active', 'urgent,important', '{"key": "value"}');
```

---

## 5. Date and Time Functions

### Current Date/Time Functions

```sql
-- Get current date and time
SELECT NOW();
-- Output: 2024-12-19 10:30:45

-- Get current date only
SELECT CURRENT_DATE();
SELECT CURDATE();
-- Output: 2024-12-19

-- Get current time only
SELECT CURRENT_TIME();
SELECT CURTIME();
-- Output: 10:30:45
```

**Execution Flow:**
```
1. NOW() queries system clock
2. Returns formatted DATETIME value
3. CURDATE() extracts only date portion
4. CURTIME() extracts only time portion
```

---

### Extract Parts from Date

```sql
-- Extract year from current date
SELECT YEAR(CURRENT_DATE());
-- Output: 2024

-- Extract month from current date
SELECT MONTH(CURRENT_DATE());
-- Output: 12

-- Extract day from current date
SELECT DAY(CURRENT_DATE());
-- Output: 19

-- All together
SELECT 
    YEAR(CURRENT_DATE()) AS year,
    MONTH(CURRENT_DATE()) AS month,
    DAY(CURRENT_DATE()) AS day;
```

---

### More Date Functions

```sql
-- Day of week (1=Sunday, 7=Saturday)
SELECT DAYOFWEEK('2024-12-19');  -- 5 (Thursday)

-- Day name
SELECT DAYNAME('2024-12-19');  -- Thursday

-- Month name
SELECT MONTHNAME('2024-12-19');  -- December

-- Week number
SELECT WEEK('2024-12-19');  -- 51

-- Add days/months/years
SELECT DATE_ADD('2024-12-19', INTERVAL 30 DAY);  -- 2025-01-18
SELECT DATE_ADD('2024-12-19', INTERVAL 1 MONTH); -- 2025-01-19
SELECT DATE_ADD('2024-12-19', INTERVAL 1 YEAR);  -- 2025-12-19

-- Subtract dates
SELECT DATEDIFF('2024-12-31', '2024-12-19');  -- 12 days
```

---

### Practical Examples

```sql
-- Create table with date column
CREATE TABLE t1 (c1 INT, c2 VARCHAR(100), c3 DATE);

-- Insert with specific date
INSERT INTO t1 VALUES(1, 'a', '2025-02-20');

-- Insert with current date
INSERT INTO t1 VALUES(2, 'b', CURDATE());

-- Find records from last 30 days
SELECT * FROM orders 
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Find records this month
SELECT * FROM orders 
WHERE YEAR(order_date) = YEAR(CURDATE())
AND MONTH(order_date) = MONTH(CURDATE());
```

---

## 6. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Login:** `mysql -u username -p password`
> 2. **SQL Categories:**
>    - DDL (CREATE, ALTER, DROP) - Structure
>    - DML (INSERT, UPDATE, DELETE) - Data
>    - DQL (SELECT) - Query
>    - DCL (GRANT, REVOKE) - Access
>    - TCL (COMMIT, ROLLBACK) - Transactions
> 3. **Database Commands:**
>    - `SHOW DATABASES` - List all
>    - `CREATE DATABASE` - Create new
>    - `USE database` - Select database
>    - `SHOW TABLES` - List tables
>    - `DESC table` - Table structure
> 4. **Data Types:**
>    - Numeric: INT, DECIMAL, FLOAT
>    - String: VARCHAR, TEXT
>    - Date: DATE, DATETIME, TIMESTAMP
> 5. **Date Functions:**
>    - NOW(), CURDATE(), CURTIME()
>    - YEAR(), MONTH(), DAY()

---

## 📋 Practice Exercises

### Exercise 1: Database Setup
```sql
-- Complete these tasks:
-- 1. Create a database named 'company_db'
-- 2. Select the database
-- 3. Create a table 'employees' with columns:
--    - emp_id INT
--    - emp_name VARCHAR(50)
--    - hire_date DATE
--    - salary DECIMAL(10,2)
-- 4. Verify the table structure

-- Solution:
CREATE DATABASE company_db;
USE company_db;
CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10,2)
);
DESC employees;
```

### Exercise 2: Date Functions
```sql
-- Write queries to:
-- 1. Get current date and time
-- 2. Extract the year and month from current date
-- 3. Find what day of the week is today
-- 4. Calculate the date 90 days from now

-- Solutions:
SELECT NOW();
SELECT YEAR(CURDATE()), MONTH(CURDATE());
SELECT DAYNAME(CURDATE());
SELECT DATE_ADD(CURDATE(), INTERVAL 90 DAY);
```

---

## 📚 Further Reading
- [Previous: Introduction to DBMS ←](./01_Introduction_to_DBMS.md)
- [Next: DDL Commands →](./03_DDL_Commands.md)

---

*Last Updated: December 2024*
