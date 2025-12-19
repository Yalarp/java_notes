# 📚 Introduction to Database Management System (DBMS)

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand what a Database and DBMS are
- Differentiate between various types of DBMS
- Explain CODD's 12 Rules for Relational Databases
- Understand ACID Properties
- Compare DBMS advantages over traditional file systems

---

## 📖 Table of Contents
1. [What is Data?](#1-what-is-data)
2. [What is a Database?](#2-what-is-a-database)
3. [What is DBMS?](#3-what-is-dbms)
4. [Types of DBMS](#4-types-of-dbms)
5. [CODD's 12 Rules](#5-codds-12-rules)
6. [ACID Properties](#6-acid-properties)
7. [DBMS vs File System](#7-dbms-vs-file-system)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. What is Data?

### Definition
**Data** is a collection of raw facts and figures that are processed to obtain meaningful information.

### Types of Data
| Type | Description | Example |
|------|-------------|---------|
| **Structured Data** | Organized in a fixed format (rows/columns) | Database tables, spreadsheets |
| **Unstructured Data** | No predefined format | Images, videos, emails |
| **Semi-structured Data** | Partially organized | JSON, XML files |

### Data vs Information
```
┌─────────────────────────────────────────────────────────┐
│  Raw Data          →    Processing    →    Information │
│  "100, 200, 300"   →    Sum, Average  →    "Total: 600, Avg: 200" │
└─────────────────────────────────────────────────────────┘
```

---

## 2. What is a Database?

### Definition
A **Database** is an organized collection of structured data stored electronically in a computer system.

### Characteristics of a Good Database
1. **Data Integrity** - Data is accurate and consistent
2. **Data Security** - Protected from unauthorized access
3. **Data Independence** - Changes in storage don't affect applications
4. **Minimal Redundancy** - Avoids duplicate data
5. **Concurrent Access** - Multiple users can access simultaneously

### Real-World Examples
- **Banking Systems** - Customer accounts, transactions
- **E-commerce** - Products, orders, customers
- **Social Media** - User profiles, posts, connections
- **Healthcare** - Patient records, prescriptions

---

## 3. What is DBMS?

### Definition
A **Database Management System (DBMS)** is software that enables users to create, manage, and manipulate databases efficiently.

### Components of DBMS
```
┌────────────────────────────────────────────────────────────────┐
│                         DBMS Architecture                       │
├────────────────────────────────────────────────────────────────┤
│                                                                  │
│    ┌──────────┐     ┌──────────────┐     ┌──────────────┐      │
│    │   User   │────▶│  Query       │────▶│  Database    │      │
│    │Interface │     │  Processor   │     │  Engine      │      │
│    └──────────┘     └──────────────┘     └──────────────┘      │
│                            │                     │               │
│                            ▼                     ▼               │
│                     ┌──────────────┐     ┌──────────────┐      │
│                     │ Transaction  │     │   Storage    │      │
│                     │  Manager     │     │   Manager    │      │
│                     └──────────────┘     └──────────────┘      │
│                                                 │               │
│                                                 ▼               │
│                                         ┌──────────────┐       │
│                                         │   Physical   │       │
│                                         │   Database   │       │
│                                         └──────────────┘       │
└────────────────────────────────────────────────────────────────┘
```

### Popular DBMS Software
| DBMS | Type | License | Best For |
|------|------|---------|----------|
| **MySQL** | Relational | Open Source | Web applications |
| **PostgreSQL** | Relational | Open Source | Complex queries |
| **Oracle** | Relational | Commercial | Enterprise |
| **SQL Server** | Relational | Commercial | Microsoft ecosystem |
| **MongoDB** | NoSQL | Open Source | Document storage |
| **Redis** | NoSQL | Open Source | Caching |

---

## 4. Types of DBMS

### 4.1 Hierarchical DBMS
- Data organized in **tree-like structure**
- Parent-child relationships (one-to-many)
- **Example:** IBM IMS

```
                    ┌─────────┐
                    │  Root   │
                    │ (Company)│
                    └────┬────┘
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         ┌────────┐ ┌────────┐ ┌────────┐
         │  HR    │ │Finance │ │   IT   │
         └───┬────┘ └────────┘ └───┬────┘
             ▼                     ▼
        ┌────────┐            ┌────────┐
        │Employee│            │Employee│
        └────────┘            └────────┘
```

**Advantages:**
- Fast data retrieval
- Data integrity through parent-child links

**Disadvantages:**
- Rigid structure
- Difficult to reorganize
- No many-to-many relationships

---

### 4.2 Network DBMS
- Data organized in **graph structure**
- Supports many-to-many relationships
- **Example:** Integrated Data Store (IDS)

```
        ┌─────────┐           ┌─────────┐
        │ Student │◄─────────►│ Course  │
        └────┬────┘           └────┬────┘
             │                     │
             ▼                     ▼
        ┌─────────┐           ┌─────────┐
        │ Faculty │◄─────────►│Department│
        └─────────┘           └─────────┘
```

**Advantages:**
- More flexible than hierarchical
- Supports complex relationships

**Disadvantages:**
- Complex to design and maintain
- Difficult navigation

---

### 4.3 Relational DBMS (RDBMS) ⭐ Most Popular
- Data organized in **tables (relations)**
- Uses **SQL** for data manipulation
- **Examples:** MySQL, PostgreSQL, Oracle, SQL Server

```
┌─────────────────────────────────────────────────────────┐
│                    EMPLOYEES Table                       │
├──────────┬───────────┬────────────┬────────────────────┤
│ emp_id   │ emp_name  │ salary     │ dept_id            │
├──────────┼───────────┼────────────┼────────────────────┤
│ 1        │ John      │ 50000      │ 101                │
│ 2        │ Jane      │ 60000      │ 102                │
│ 3        │ Bob       │ 55000      │ 101                │
└──────────┴───────────┴────────────┴────────────────────┘
                              │
                              │ Foreign Key Relationship
                              ▼
┌─────────────────────────────────────────────────────────┐
│                   DEPARTMENTS Table                      │
├──────────┬────────────────────────────────────────────┤
│ dept_id  │ dept_name                                    │
├──────────┼────────────────────────────────────────────┤
│ 101      │ Engineering                                  │
│ 102      │ Marketing                                    │
└──────────┴────────────────────────────────────────────┘
```

**Advantages:**
- Simple and intuitive structure
- Data independence
- Powerful query language (SQL)
- ACID compliance

**Disadvantages:**
- May be slower for very large datasets
- Not ideal for unstructured data

---

### 4.4 Object-Oriented DBMS (OODBMS)
- Data stored as **objects** (like OOP)
- Supports inheritance, encapsulation, polymorphism
- **Examples:** ObjectDB, db4o

**Advantages:**
- Natural fit for OOP applications
- Handles complex data types

**Disadvantages:**
- Lack of standardization
- Steep learning curve

---

### 4.5 NoSQL DBMS
- **Not Only SQL** - different data models
- Designed for distributed, large-scale data

| Type | Description | Example |
|------|-------------|---------|
| **Document** | JSON-like documents | MongoDB, CouchDB |
| **Key-Value** | Simple key-value pairs | Redis, DynamoDB |
| **Column-Family** | Column-based storage | Cassandra, HBase |
| **Graph** | Nodes and relationships | Neo4j, ArangoDB |

---

## 5. CODD's 12 Rules

> **Dr. Edgar F. Codd** proposed 12 rules (actually 13, numbered 0-12) in 1985 that define what is required for a DBMS to be considered truly relational.

### Rule 0: Foundation Rule
```
A relational database management system must manage its stored data 
using only its relational capabilities.
```
**Explanation:** The system must qualify as relational, as a database, and as a management system. All data must be managed through relational operations.

---

### Rule 1: Information Rule
```
All information in a relational database is represented explicitly 
at the logical level in exactly one way — as values in tables.
```
**Explanation:** Every piece of data must be stored in cells of tables (relations). Even metadata (information about tables) is stored as tables.

**Example:**
```sql
-- Data about employees is stored in a table
SELECT * FROM employees;

-- Even system information is in tables
SELECT * FROM information_schema.tables;
```

---

### Rule 2: Guaranteed Access Rule
```
Each and every datum (atomic value) in a relational database is 
guaranteed to be logically accessible by resorting to a combination 
of table name, primary key value, and column name.
```
**Explanation:** Every single value in the database can be accessed using: Table Name + Primary Key + Column Name.

**Example:**
```sql
-- Access specific value: employees table, emp_id=1, salary column
SELECT salary 
FROM employees 
WHERE emp_id = 1;
```

---

### Rule 3: Systematic Treatment of NULL Values
```
NULL values are supported for representing missing information and 
inapplicable information in a systematic way, independent of data type.
```
**Explanation:** NULL means "unknown" or "not applicable" — it's NOT the same as 0 or empty string.

**Example:**
```sql
-- NULL means value not yet defined, not blank or 0
INSERT INTO test(id) VALUES(7);
-- The 'name' column will be NULL

-- Checking for NULL requires IS NULL, not = NULL
SELECT * FROM test WHERE name IS NULL;
SELECT * FROM test WHERE name IS NOT NULL;
```

---

### Rule 4: Dynamic Online Catalog Based on Relational Model
```
The database description is represented at the logical level in the 
same way as ordinary data, so that authorized users can apply the 
same relational language to query it.
```
**Explanation:** Database metadata (table structures, constraints, etc.) must be stored in tables and queryable using SQL.

**Example:**
```sql
-- Query the catalog to see all tables
SHOW TABLES;

-- Describe table structure
DESC employees;

-- Query information schema
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE 
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = 'trainingdb';
```

---

### Rule 5: Comprehensive Data Sublanguage Rule
```
A relational system may support several languages. However, there 
must be at least one language whose statements can express all of 
the following: data definition, view definition, data manipulation, 
integrity constraints, authorization, and transaction boundaries.
```
**Explanation:** SQL is the comprehensive language that supports:
- **DDL** - Data Definition Language (CREATE, ALTER, DROP)
- **DML** - Data Manipulation Language (INSERT, UPDATE, DELETE)
- **DCL** - Data Control Language (GRANT, REVOKE)
- **TCL** - Transaction Control Language (COMMIT, ROLLBACK)
- **DQL** - Data Query Language (SELECT)

---

### Rule 6: View Updating Rule
```
All views that are theoretically updatable are also updatable by 
the system.
```
**Explanation:** If a view is logically capable of being updated, the DBMS must allow updates to pass through to the base tables.

---

### Rule 7: High-Level Insert, Update, and Delete
```
The capability of handling a base relation or a derived relation 
(view) as a single operand applies to retrieval, insertion, update, 
and deletion.
```
**Explanation:** You can INSERT, UPDATE, DELETE multiple rows at once, not just one row at a time.

**Example:**
```sql
-- Multi-row insert (set-level operation)
INSERT INTO test VALUES(3,'c'),(4,'d'),(5,'e'),(6,'f');

-- Update multiple rows at once
UPDATE employees SET salary = salary * 1.1 WHERE dept_id = 101;

-- Delete multiple rows at once
DELETE FROM test WHERE id > 5;
```

---

### Rule 8: Physical Data Independence
```
Application programs and terminal activities remain logically 
unimpaired whenever any changes are made in storage representations 
or access methods.
```
**Explanation:** Physical storage changes (file locations, indexes, etc.) should not require application code changes.

---

### Rule 9: Logical Data Independence
```
Application programs and terminal activities remain logically 
unimpaired when information-preserving changes that theoretically 
permit unimpairment are made to the base tables.
```
**Explanation:** Changes to table structure (adding columns, splitting tables) should minimally impact applications.

---

### Rule 10: Integrity Independence
```
Integrity constraints specific to a particular relational database 
must be definable in the relational data sublanguage and storable 
in the catalog, not in the application programs.
```
**Explanation:** Integrity rules (PRIMARY KEY, FOREIGN KEY, CHECK, etc.) should be defined in the database, not in application code.

**Example:**
```sql
-- Integrity constraints defined in database
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,           -- Entity integrity
    emp_name VARCHAR(100) NOT NULL,   -- Domain integrity
    salary INT CHECK(salary >= 0),    -- Check constraint
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)  -- Referential integrity
);
```

---

### Rule 11: Distribution Independence
```
A relational DBMS has distribution independence. The end-user must 
not be able to see that the data is distributed over various locations.
```
**Explanation:** If the database is distributed across multiple servers, users/applications should access it as if it were a single database.

---

### Rule 12: Nonsubversion Rule
```
If a relational system has a low-level (single-record-at-a-time) 
language, that low level cannot be used to subvert the relational 
rules and integrity constraints.
```
**Explanation:** No backdoor access that bypasses integrity constraints. All access must go through the relational interface.

---

### CODD's Rules Summary Table
| Rule # | Name | Key Point |
|--------|------|-----------|
| 0 | Foundation | System must be relational |
| 1 | Information | All data in tables |
| 2 | Guaranteed Access | Table + PK + Column = Value |
| 3 | NULL Handling | Systematic NULL support |
| 4 | Dynamic Catalog | Metadata in tables |
| 5 | Comprehensive Language | SQL covers everything |
| 6 | View Updating | Updatable views work |
| 7 | Set Operations | Multi-row operations |
| 8 | Physical Independence | Storage changes hidden |
| 9 | Logical Independence | Schema changes minimal impact |
| 10 | Integrity Independence | Rules in DB, not app |
| 11 | Distribution Independence | Distributed = transparent |
| 12 | Nonsubversion | No backdoor access |

---

## 6. ACID Properties

> ACID properties ensure reliable database transactions.

### What is a Transaction?
A **Transaction** is a sequence of operations performed as a single logical unit of work.

```sql
-- Example Transaction: Transfer money from Account A to Account B
START TRANSACTION;
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 'A';
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 'B';
COMMIT;
```

### The Four ACID Properties

#### A - Atomicity (All or Nothing)
```
Either ALL operations in a transaction complete successfully, 
or NONE of them are applied.
```

**Example:**
```sql
START TRANSACTION;
    DELETE FROM test;                    -- Operation 1
    INSERT INTO test VALUES(100,'ff');   -- Operation 2
    UPDATE test SET name='abc' WHERE id=100;  -- Operation 3
ROLLBACK;  -- All three operations are undone!
```

**Explanation:**
- Line 1: `START TRANSACTION` - Begins atomic unit
- Line 2: Delete all rows (not yet permanent)
- Line 3: Insert new row (not yet permanent)
- Line 4: Update the row (not yet permanent)
- Line 5: `ROLLBACK` - Cancels ALL operations, database returns to original state

---

#### C - Consistency
```
A transaction must transform the database from one valid state 
to another valid state, maintaining all integrity constraints.
```

**Example:**
```sql
-- If PRIMARY KEY constraint exists on emp_id
INSERT INTO employees VALUES(1, 'John', 50000, 101);  -- Works
INSERT INTO employees VALUES(1, 'Jane', 60000, 102);  -- FAILS! Duplicate PK

-- Database remains in consistent state - no duplicate PKs
```

---

#### I - Isolation
```
Concurrent transactions must execute as if they were running 
sequentially, without interfering with each other.
```

**Example Scenario:**
```
Transaction 1: Reads balance = 1000
Transaction 2: Reads balance = 1000
Transaction 1: Subtracts 100, writes balance = 900
Transaction 2: Subtracts 100, writes balance = 900

WITHOUT ISOLATION: Final balance = 900 (Lost Update!)
WITH ISOLATION: Final balance = 800 (Correct)
```

---

#### D - Durability
```
Once a transaction is COMMITTED, its changes are permanent and 
will survive system failures.
```

**Example:**
```sql
START TRANSACTION;
    INSERT INTO orders VALUES(1001, 'Laptop', 50000);
COMMIT;  -- Data is now permanent

-- Even if power fails immediately after, the order data is saved
```

---

### ACID Properties Diagram
```
┌────────────────────────────────────────────────────────────────┐
│                      ACID Properties                            │
├─────────────────┬──────────────────────────────────────────────┤
│   ATOMICITY     │  All operations succeed or all fail          │
│   (A)           │  "All or Nothing"                            │
├─────────────────┼──────────────────────────────────────────────┤
│   CONSISTENCY   │  Valid state → Valid state                    │
│   (C)           │  All constraints maintained                   │
├─────────────────┼──────────────────────────────────────────────┤
│   ISOLATION     │  Transactions don't interfere                 │
│   (I)           │  Appears sequential                           │
├─────────────────┼──────────────────────────────────────────────┤
│   DURABILITY    │  Committed = Permanent                        │
│   (D)           │  Survives crashes                             │
└─────────────────┴──────────────────────────────────────────────┘
```

---

## 7. DBMS vs File System

### Comparison Table
| Feature | File System | DBMS |
|---------|-------------|------|
| **Data Redundancy** | High (duplicate files) | Low (normalized) |
| **Data Inconsistency** | Likely | Prevented |
| **Data Isolation** | Scattered across files | Centralized |
| **Atomicity** | Not supported | Supported (Transactions) |
| **Concurrent Access** | Limited | Full support |
| **Security** | OS-level only | Row/Column level |
| **Data Integrity** | Application managed | DB enforced |
| **Backup & Recovery** | Manual | Automated |
| **Query Language** | None | SQL |
| **Data Independence** | None | Physical & Logical |

### File System Problems

#### 1. Data Redundancy
```
File: employees_hr.txt
John, 50000, HR

File: employees_payroll.txt  
John, 50000, HR  ← Same data duplicated!
```

#### 2. Data Inconsistency
```
File: employees_hr.txt
John, 50000, HR  ← Old salary

File: employees_payroll.txt  
John, 55000, HR  ← Updated salary - INCONSISTENT!
```

#### 3. Difficulty in Accessing Data
```
"Find all employees earning > 50000 in HR department"

With Files: Write custom program to parse each file
With DBMS: SELECT * FROM employees WHERE salary > 50000 AND dept = 'HR';
```

#### 4. Data Isolation
```
Employee data in employees.txt
Department data in departments.txt
Salary data in payroll.txt

Linking them requires complex programming!
```

---

## 8. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Database** is organized data; **DBMS** is software to manage it
> 2. **RDBMS** (MySQL, PostgreSQL, Oracle) is the most widely used type
> 3. **CODD's 12 Rules** define what makes a database truly relational
> 4. **ACID Properties** ensure reliable transactions:
>    - Atomicity = All or Nothing
>    - Consistency = Valid states only
>    - Isolation = No interference
>    - Durability = Permanent commits
> 5. **DBMS advantages** over files: Less redundancy, better security, SQL access

---

## 📋 Practice Questions

### Multiple Choice Questions

**Q1.** Which of the following is NOT a type of DBMS?
- a) Hierarchical
- b) Network
- c) Sequential ✓
- d) Relational

**Q2.** CODD's Rule 1 states that:
- a) All data must be in JSON format
- b) All data must be in tables ✓
- c) All data must have primary keys
- d) All data must be encrypted

**Q3.** In ACID, what does 'A' stand for?
- a) Availability
- b) Atomicity ✓
- c) Accessibility
- d) Authentication

### Short Answer Questions

**Q4.** Explain the difference between NULL and empty string.

**Answer:** NULL means "unknown" or "not applicable" — the value doesn't exist. An empty string ('') is a valid value representing zero-length text. They are fundamentally different: NULL IS NULL returns true, but '' = '' returns true while NULL = NULL returns NULL (not true).

**Q5.** Why is physical data independence important?

**Answer:** Physical data independence allows changing storage structures (adding indexes, changing file locations, modifying disk allocation) without requiring changes to application programs. This reduces maintenance costs and increases flexibility.

---

## 📚 Further Reading
- [Next: SQL Fundamentals →](./02_SQL_Fundamentals.md)
- CODD's Original Paper: "A Relational Model of Data for Large Shared Data Banks" (1970)
- MySQL Official Documentation: https://dev.mysql.com/doc/

---

*Last Updated: December 2024*
