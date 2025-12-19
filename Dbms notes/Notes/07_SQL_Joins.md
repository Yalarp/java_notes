# 📚 SQL Joins - Combining Data from Multiple Tables

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand different types of SQL joins
- Write CROSS JOIN, INNER JOIN, LEFT JOIN, RIGHT JOIN queries
- Implement FULL OUTER JOIN using UNION workaround in MySQL
- Use both ANSI and legacy join syntax
- Apply joins to solve real-world data problems

---

## 📖 Table of Contents
1. [What are Joins?](#1-what-are-joins)
2. [Sample Data Setup](#2-sample-data-setup)
3. [CROSS JOIN](#3-cross-join)
4. [INNER JOIN](#4-inner-join)
5. [LEFT JOIN](#5-left-join)
6. [RIGHT JOIN](#6-right-join)
7. [FULL OUTER JOIN](#7-full-outer-join)
8. [Self Join](#8-self-join)
9. [Multiple Table Joins](#9-multiple-table-joins)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. What are Joins?

A **JOIN** combines rows from two or more tables based on a related column between them.

### Join Types Overview
```
┌────────────────────────────────────────────────────────────────┐
│                         SQL Join Types                          │
├─────────────────┬──────────────────────────────────────────────┤
│   CROSS JOIN    │  All combinations (Cartesian Product)        │
├─────────────────┼──────────────────────────────────────────────┤
│   INNER JOIN    │  Only matching rows from both tables          │
├─────────────────┼──────────────────────────────────────────────┤
│   LEFT JOIN     │  All from left + matching from right          │
├─────────────────┼──────────────────────────────────────────────┤
│   RIGHT JOIN    │  All from right + matching from left          │
├─────────────────┼──────────────────────────────────────────────┤
│   FULL JOIN     │  All from both (with NULLs for non-matches)   │
└─────────────────┴──────────────────────────────────────────────┘
```

### Visual Representation (Venn Diagrams)
```
INNER JOIN:                 LEFT JOIN:
   ┌───────────────┐           ┌───────────────┐
   │   ┌─────┐     │           │███████████    │
   │   │█████│     │           │███████████    │
   │   │█████│     │           │███│█████│     │
   │   └─────┘     │           │███└─────┘     │
   └───────────────┘           └───────────────┘
   Only overlap               All left + overlap

RIGHT JOIN:                 FULL OUTER JOIN:
   ┌───────────────┐           ┌───────────────┐
   │     ██████████│           │███████████████│
   │     ██████████│           │███████████████│
   │     │█████│███│           │███│█████│█████│
   │     └─────┘███│           │███└─────┘█████│
   └───────────────┘           └───────────────┘
   All right + overlap        All from both
```

---

## 2. Sample Data Setup

```sql
-- Create sample tables for demonstrations
CREATE TABLE t1(c1 INT, c2 VARCHAR(5));
CREATE TABLE t2(c1 INT, c3 VARCHAR(5));

INSERT INTO t1 VALUES(1,'a'),(2,'b'),(3,'c');
INSERT INTO t2 VALUES(3,'x'),(4,'y'),(5,'z');
```

**Line-by-Line Breakdown:**
```sql
CREATE TABLE t1(c1 INT, c2 VARCHAR(5));  -- Table 1: id and name
CREATE TABLE t2(c1 INT, c3 VARCHAR(5));  -- Table 2: id and code

-- Insert into t1: IDs 1, 2, 3
INSERT INTO t1 VALUES(1,'a'),(2,'b'),(3,'c');

-- Insert into t2: IDs 3, 4, 5
INSERT INTO t2 VALUES(3,'x'),(4,'y'),(5,'z');
```

**Data Overview:**
```
┌───────────────┐     ┌───────────────┐
│      t1       │     │      t2       │
├────────┬──────┤     ├────────┬──────┤
│   c1   │  c2  │     │   c1   │  c3  │
├────────┼──────┤     ├────────┼──────┤
│   1    │  a   │     │   3    │  x   │
│   2    │  b   │     │   4    │  y   │
│   3    │  c   │     │   5    │  z   │
└────────┴──────┘     └────────┴──────┘

Note: Only c1=3 exists in BOTH tables
```

---

## 3. CROSS JOIN

### Definition
A **CROSS JOIN** returns the Cartesian product — every row from the first table paired with every row from the second table.

### ANSI Syntax (Recommended)

```sql
SELECT * FROM t1 CROSS JOIN t2;
```

**Line-by-Line Breakdown:**
```sql
SELECT *         -- All columns from both tables
FROM t1          -- First table
CROSS JOIN t2    -- Cartesian product with second table
;
```

### Legacy Syntax

```sql
SELECT * FROM t1, t2;
```

### Result (3 × 3 = 9 rows)
```
┌────────┬──────┬────────┬──────┐
│ t1.c1  │ c2   │ t2.c1  │ c3   │
├────────┼──────┼────────┼──────┤
│   1    │  a   │   3    │  x   │
│   1    │  a   │   4    │  y   │
│   1    │  a   │   5    │  z   │
│   2    │  b   │   3    │  x   │
│   2    │  b   │   4    │  y   │
│   2    │  b   │   5    │  z   │
│   3    │  c   │   3    │  x   │
│   3    │  c   │   4    │  y   │
│   3    │  c   │   5    │  z   │
└────────┴──────┴────────┴──────┘
```

### Selecting Specific Columns

```sql
SELECT t1.*, c3 FROM t1 CROSS JOIN t2;
```

**Line-by-Line Breakdown:**
```sql
SELECT 
    t1.*,    -- All columns from t1 (c1, c2)
    c3       -- Only c3 from t2 (no ambiguity - c3 only in t2)
FROM t1 CROSS JOIN t2;
```

> [!WARNING]
> CROSS JOIN can produce very large result sets! 1000 × 1000 = 1,000,000 rows!

---

## 4. INNER JOIN

### Definition
An **INNER JOIN** returns only rows that have matching values in both tables.

### ANSI Syntax (Recommended)

```sql
SELECT * FROM t1 INNER JOIN t2 ON t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
SELECT *             -- All columns
FROM t1              -- Left table
INNER JOIN t2        -- Right table (INNER keyword optional)
ON t1.c1 = t2.c1     -- Join condition: matching c1 values
;
```

### Shorter Form (without INNER keyword)

```sql
SELECT * FROM t1 JOIN t2 ON t1.c1 = t2.c1;
```

### Legacy Syntax

```sql
SELECT * FROM t1, t2 WHERE t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
SELECT * 
FROM t1, t2          -- List both tables (implicit cross join)
WHERE t1.c1 = t2.c1  -- Filter to matching rows only
;
```

### Result (Only matching c1=3)
```
┌────────┬──────┬────────┬──────┐
│ t1.c1  │ c2   │ t2.c1  │ c3   │
├────────┼──────┼────────┼──────┤
│   3    │  c   │   3    │  x   │
└────────┴──────┴────────┴──────┘
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Take each row from t1                               │
│         ↓                                                   │
│ Step 2: For each t1 row, find matching t2 rows              │
│         where t1.c1 = t2.c1                                 │
│         ↓                                                   │
│ Step 3: If match found, include combined row in result      │
│         If no match, row is excluded                        │
└─────────────────────────────────────────────────────────────┘

t1 Row (1,'a'): Looking for t2.c1=1 → Not found → EXCLUDED
t1 Row (2,'b'): Looking for t2.c1=2 → Not found → EXCLUDED
t1 Row (3,'c'): Looking for t2.c1=3 → Found! (3,'x') → INCLUDED
```

### Selecting Specific Columns

```sql
SELECT t1.*, c3 FROM t1 INNER JOIN t2 ON t1.c1 = t2.c1;
SELECT t1.*, c3 FROM t1 JOIN t2 ON t1.c1 = t2.c1;
```

---

## 5. LEFT JOIN

### Definition
A **LEFT JOIN** returns ALL rows from the left table, plus matching rows from the right table. Non-matching right side gets NULL.

### ANSI Syntax

```sql
SELECT * FROM t1 LEFT JOIN t2 ON t1.c1 = t2.c1;
-- or
SELECT * FROM t1 LEFT OUTER JOIN t2 ON t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
SELECT *                -- All columns
FROM t1                 -- Left table (ALL rows kept)
LEFT JOIN t2            -- Right table
ON t1.c1 = t2.c1        -- Join condition
;
```

### Result (All from t1, matching from t2)
```
┌────────┬──────┬────────┬──────┐
│ t1.c1  │ c2   │ t2.c1  │ c3   │
├────────┼──────┼────────┼──────┤
│   1    │  a   │ NULL   │ NULL │  ← No match in t2
│   2    │  b   │ NULL   │ NULL │  ← No match in t2
│   3    │  c   │   3    │  x   │  ← Match found!
└────────┴──────┴────────┴──────┘
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Take each row from t1 (left table)                  │
│         ↓                                                   │
│ Step 2: For each t1 row, find matching t2 rows              │
│         ↓                                                   │
│ Step 3: If match found → combine row                        │
│         If NO match → include t1 row with NULL for t2 cols  │
└─────────────────────────────────────────────────────────────┘

t1 Row (1,'a'): t2.c1=1? No → Include with NULLs: (1,'a',NULL,NULL)
t1 Row (2,'b'): t2.c1=2? No → Include with NULLs: (2,'b',NULL,NULL)
t1 Row (3,'c'): t2.c1=3? Yes! → Include: (3,'c',3,'x')
```

### Practical Example: Employees and Departments

```sql
-- Get ALL departments with employee count (including empty depts)
SELECT deptname, COUNT(eid) AS employee_count
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

---

## 6. RIGHT JOIN

### Definition
A **RIGHT JOIN** returns ALL rows from the right table, plus matching rows from the left table. Non-matching left side gets NULL.

### ANSI Syntax

```sql
SELECT * FROM t1 RIGHT JOIN t2 ON t1.c1 = t2.c1;
-- or
SELECT * FROM t1 RIGHT OUTER JOIN t2 ON t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
SELECT *                  -- All columns
FROM t1                   -- Left table
RIGHT JOIN t2             -- Right table (ALL rows kept)
ON t1.c1 = t2.c1          -- Join condition
;
```

### Result (All from t2, matching from t1)
```
┌────────┬──────┬────────┬──────┐
│ t1.c1  │ c2   │ t2.c1  │ c3   │
├────────┼──────┼────────┼──────┤
│   3    │  c   │   3    │  x   │  ← Match found!
│ NULL   │ NULL │   4    │  y   │  ← No match in t1
│ NULL   │ NULL │   5    │  z   │  ← No match in t1
└────────┴──────┴────────┴──────┘
```

> [!TIP]
> `A LEFT JOIN B` is equivalent to `B RIGHT JOIN A`!

---

## 7. FULL OUTER JOIN

### Definition
A **FULL OUTER JOIN** returns ALL rows from both tables, with NULLs for non-matches.

### MySQL Limitation
```sql
-- This does NOT work in MySQL!
SELECT * FROM t1 FULL JOIN t2 ON t1.c1 = t2.c1;
-- Error: FULL is not supported in MySQL
```

### MySQL Workaround using UNION

```sql
SELECT * FROM t1 LEFT JOIN t2 ON t1.c1 = t2.c1
UNION
SELECT * FROM t1 RIGHT JOIN t2 ON t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
-- Part 1: Get all rows from LEFT JOIN
SELECT * FROM t1 LEFT JOIN t2 ON t1.c1 = t2.c1
UNION               -- Combine and remove duplicates
-- Part 2: Get all rows from RIGHT JOIN
SELECT * FROM t1 RIGHT JOIN t2 ON t1.c1 = t2.c1;
```

### Result (All from both tables)
```
┌────────┬──────┬────────┬──────┐
│ t1.c1  │ c2   │ t2.c1  │ c3   │
├────────┼──────┼────────┼──────┤
│   1    │  a   │ NULL   │ NULL │  ← Only in t1
│   2    │  b   │ NULL   │ NULL │  ← Only in t1
│   3    │  c   │   3    │  x   │  ← In both
│ NULL   │ NULL │   4    │  y   │  ← Only in t2
│ NULL   │ NULL │   5    │  z   │  ← Only in t2
└────────┴──────┴────────┴──────┘
```

---

## 8. Self Join

### Definition
A **Self Join** is when a table is joined with itself. Used for hierarchical data.

### Example: Employee Manager Hierarchy

```sql
-- Find employees and their managers (from employees table)
SELECT 
    e.firstName AS employee,
    m.firstName AS manager
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber;
```

**Line-by-Line Breakdown:**
```sql
SELECT 
    e.firstName AS employee,     -- Employee's name
    m.firstName AS manager       -- Manager's name
FROM employees e                 -- Alias 'e' for employee
LEFT JOIN employees m            -- Same table, alias 'm' for manager
ON e.reportsTo = m.employeeNumber;  -- Link to manager's ID
```

---

## 9. Multiple Table Joins

### Example: Employees with Department Names

```sql
-- Get employee name, department name, and salary
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid;
```

**Line-by-Line Breakdown:**
```sql
SELECT 
    deptname,   -- From dept table
    ename,      -- From emp table
    salary      -- From emp table
FROM emp        -- Start with employees
JOIN dept       -- Join with departments
ON emp.deptid = dept.deptid;  -- On matching department ID
```

### Finding Employees in Specific Department

```sql
-- Display employees in HR department using JOIN
SELECT deptname, ename
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE deptname = 'HR';

-- Using legacy syntax
SELECT deptname, ename
FROM emp, dept
WHERE emp.deptid = dept.deptid
AND deptname = 'HR';
```

### Three-Table Join Example

```sql
-- Orders with customer and product details
SELECT 
    c.customerName,
    o.orderNumber,
    od.quantityOrdered,
    p.productName
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode;
```

---

## 10. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **CROSS JOIN:**
>    - Cartesian product (all combinations)
>    - No ON clause
>    - Result: M × N rows
> 
> 2. **INNER JOIN:**
>    - Only matching rows
>    - Most common join type
>    - Rows without matches excluded
> 
> 3. **LEFT JOIN:**
>    - All from LEFT table
>    - Matching from right
>    - Non-matches: NULL
> 
> 4. **RIGHT JOIN:**
>    - All from RIGHT table
>    - Matching from left
>    - Non-matches: NULL
> 
> 5. **FULL OUTER JOIN:**
>    - All from both tables
>    - MySQL: Use UNION workaround
> 
> 6. **Syntax:**
>    - ANSI (recommended): `FROM t1 JOIN t2 ON condition`
>    - Legacy: `FROM t1, t2 WHERE condition`

---

## 📋 Practice Exercises

### Exercise 1: Basic Joins
```sql
-- Given dept and emp tables, write queries for:

-- 1. All employees with their department names (only matching)
SELECT ename, deptname
FROM emp INNER JOIN dept ON emp.deptid = dept.deptid;

-- 2. All departments with employee count (including empty depts)
SELECT deptname, COUNT(eid) AS emp_count
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;

-- 3. All employees, even those without department
SELECT ename, deptname
FROM emp LEFT JOIN dept ON emp.deptid = dept.deptid;
```

### Exercise 2: ClassicModels Database
```sql
-- 1. List all orders with customer names
SELECT o.orderNumber, c.customerName, o.orderDate
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber;

-- 2. Find employees with their office city
SELECT e.firstName, e.lastName, o.city
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode;

-- 3. Products with quantities ordered
SELECT p.productName, SUM(od.quantityOrdered) AS total_ordered
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productName
ORDER BY total_ordered DESC;
```

---

## 📚 Further Reading
- [Previous: SELECT and Filtering ←](./06_SELECT_and_Filtering.md)
- [Next: Set Operators →](./08_Set_Operators.md)

---

*Last Updated: December 2024*
