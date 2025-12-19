# 📚 Set Operators - UNION, INTERSECT, EXCEPT

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Combine results from multiple queries using set operators
- Understand UNION vs UNION ALL
- Use INTERSECT to find common rows
- Apply EXCEPT to find differences between result sets
- Implement FULL OUTER JOIN using UNION

---

## 📖 Table of Contents
1. [What are Set Operators?](#1-what-are-set-operators)
2. [Sample Data Setup](#2-sample-data-setup)
3. [UNION](#3-union)
4. [UNION ALL](#4-union-all)
5. [INTERSECT](#5-intersect)
6. [EXCEPT](#6-except)
7. [Practical Applications](#7-practical-applications)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. What are Set Operators?

**Set Operators** combine the results of two or more SELECT queries into a single result set.

### Set Operators Overview
```
┌────────────────────────────────────────────────────────────────┐
│                      SQL Set Operators                          │
├─────────────────┬──────────────────────────────────────────────┤
│   UNION         │  Combine results, remove duplicates           │
├─────────────────┼──────────────────────────────────────────────┤
│   UNION ALL     │  Combine results, keep duplicates             │
├─────────────────┼──────────────────────────────────────────────┤
│   INTERSECT     │  Only rows that appear in both results        │
├─────────────────┼──────────────────────────────────────────────┤
│   EXCEPT        │  Rows in first result but not in second       │
└─────────────────┴──────────────────────────────────────────────┘
```

### Visual Representation (Venn Diagrams)
```
UNION:                      UNION ALL:
   ┌───────────────┐           ┌───────────────┐
   │███████████████│           │███████████████│
   │███████████████│           │███████████████│  + duplicates
   │███████████████│           │███████████████│
   │███████████████│           │███████████████│
   └───────────────┘           └───────────────┘
   All unique rows             All rows

INTERSECT:                  EXCEPT (A - B):
   ┌───────────────┐           ┌───────────────┐
   │     ┌─────┐   │           │███████████    │
   │     │█████│   │           │███████████    │
   │     │█████│   │           │███└─────┘     │
   │     └─────┘   │           │███            │
   └───────────────┘           └───────────────┘
   Only overlap                Only in first set
```

### Rules for Set Operators
1. **Same number of columns** in all SELECT statements
2. **Compatible data types** in corresponding positions
3. **Column names** from first SELECT are used in result
4. **ORDER BY** can only be at the end (applies to final result)

---

## 2. Sample Data Setup

```sql
-- Create two sample tables
CREATE TABLE a(id INT);
CREATE TABLE b(id INT);

INSERT INTO a VALUES(1),(2),(3);
INSERT INTO b VALUES(3),(4),(5);
```

**Data Overview:**
```
┌───────────┐     ┌───────────┐
│  Table a  │     │  Table b  │
├───────────┤     ├───────────┤
│    id     │     │    id     │
├───────────┤     ├───────────┤
│     1     │     │     3     │
│     2     │     │     4     │
│     3     │     │     5     │
└───────────┘     └───────────┘

Note: Only value 3 exists in BOTH tables
```

---

## 3. UNION

### Definition
**UNION** combines results from two or more SELECT statements and **removes duplicate rows**.

### Basic Syntax

```sql
SELECT * FROM a
UNION
SELECT * FROM b;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM a    -- First query: get all rows from table 'a'
UNION              -- Combine with next query, remove duplicates
SELECT * FROM b    -- Second query: get all rows from table 'b'
;
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Execute first SELECT                                │
│         Result: {1, 2, 3}                                   │
│         ↓                                                   │
│ Step 2: Execute second SELECT                               │
│         Result: {3, 4, 5}                                   │
│         ↓                                                   │
│ Step 3: Combine results                                     │
│         Combined: {1, 2, 3, 3, 4, 5}                        │
│         ↓                                                   │
│ Step 4: Remove duplicates                                   │
│         Final: {1, 2, 3, 4, 5}                              │
└─────────────────────────────────────────────────────────────┘
```

### Result
```
┌───────────┐
│    id     │
├───────────┤
│     1     │
│     2     │
│     3     │  ← Value 3 appears once (duplicate removed)
│     4     │
│     5     │
└───────────┘
5 rows returned
```

---

### 3.1 Order Matters for Column Names

```sql
-- This uses column name from first SELECT
SELECT * FROM a
UNION
SELECT * FROM b;
-- Result column name: 'id'

-- Reverse order - still uses first SELECT's column name
SELECT * FROM b
UNION
SELECT * FROM a;
-- Result column name: 'id' (same result, just different order)
```

---

### 3.2 UNION with ORDER BY

```sql
-- ORDER BY applies to the final combined result
SELECT * FROM a
UNION
SELECT * FROM b
ORDER BY id DESC;
```

**Result:**
```
┌───────────┐
│    id     │
├───────────┤
│     5     │
│     4     │
│     3     │
│     2     │
│     1     │
└───────────┘
```

> [!IMPORTANT]
> ORDER BY can only appear **ONCE** at the very end, it applies to the entire result set!

---

## 4. UNION ALL

### Definition
**UNION ALL** combines results from two or more SELECT statements and **keeps all duplicate rows**.

### Basic Syntax

```sql
SELECT * FROM a
UNION ALL
SELECT * FROM b;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM a    -- First query: get all rows from table 'a'
UNION ALL          -- Combine with next query, KEEP duplicates
SELECT * FROM b    -- Second query: get all rows from table 'b'
;
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Execute first SELECT                                │
│         Result: {1, 2, 3}                                   │
│         ↓                                                   │
│ Step 2: Execute second SELECT                               │
│         Result: {3, 4, 5}                                   │
│         ↓                                                   │
│ Step 3: Combine results (NO duplicate removal)              │
│         Final: {1, 2, 3, 3, 4, 5}                           │
└─────────────────────────────────────────────────────────────┘
```

### Result
```
┌───────────┐
│    id     │
├───────────┤
│     1     │
│     2     │
│     3     │  ← From table 'a'
│     3     │  ← From table 'b' (duplicate kept!)
│     4     │
│     5     │
└───────────┘
6 rows returned
```

---

### 4.1 UNION vs UNION ALL Comparison

| Feature | UNION | UNION ALL |
|---------|-------|-----------|
| **Duplicates** | Removed | Kept |
| **Performance** | Slower (needs to check duplicates) | Faster |
| **Use Case** | When you want unique results | When duplicates are needed or don't exist |
| **Result Count** | ≤ sum of individual results | = sum of individual results |

**Example from Source:**
```sql
SELECT * FROM a
UNION
SELECT * FROM b;
-- Result: 5 rows (1,2,3,4,5)

SELECT * FROM a
UNION ALL
SELECT * FROM b;
-- Result: 6 rows (1,2,3,3,4,5)

SELECT * FROM b
UNION ALL
SELECT * FROM a;
-- Result: 6 rows (3,4,5,1,2,3) - order different
```

> [!TIP]
> Use **UNION ALL** when you know there are no duplicates or when duplicates are meaningful. It's much faster!

---

## 5. INTERSECT

### Definition
**INTERSECT** returns only rows that appear in **BOTH** result sets.

### Basic Syntax

```sql
SELECT * FROM a
INTERSECT
SELECT * FROM b;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM a    -- First query: {1, 2, 3}
INTERSECT          -- Return only common rows
SELECT * FROM b    -- Second query: {3, 4, 5}
;
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Execute first SELECT                                │
│         Result: {1, 2, 3}                                   │
│         ↓                                                   │
│ Step 2: Execute second SELECT                               │
│         Result: {3, 4, 5}                                   │
│         ↓                                                   │
│ Step 3: Find common rows (intersection)                     │
│         Final: {3}                                          │
└─────────────────────────────────────────────────────────────┘
```

### Result
```
┌───────────┐
│    id     │
├───────────┤
│     3     │  ← Only value in BOTH tables
└───────────┘
1 row returned
```

---

### 5.1 Order Doesn't Matter in INTERSECT

```sql
-- Both produce same result
SELECT * FROM a INTERSECT SELECT * FROM b;
SELECT * FROM b INTERSECT SELECT * FROM a;
-- Both return: {3}
```

---

## 6. EXCEPT

### Definition
**EXCEPT** (also called **MINUS** in some databases) returns rows from the first query that are **NOT** in the second query.

### Basic Syntax

```sql
SELECT * FROM a
EXCEPT
SELECT * FROM b;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM a    -- First query: {1, 2, 3}
EXCEPT             -- Remove rows that are also in second query
SELECT * FROM b    -- Second query: {3, 4, 5}
;
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Execute first SELECT                                │
│         Result: {1, 2, 3}                                   │
│         ↓                                                   │
│ Step 2: Execute second SELECT                               │
│         Result: {3, 4, 5}                                   │
│         ↓                                                   │
│ Step 3: Remove rows from first that exist in second         │
│         {1, 2, 3} - {3, 4, 5} = {1, 2}                      │
│         ↓                                                   │
│ Step 4: Return remaining rows from first query              │
│         Final: {1, 2}                                       │
└─────────────────────────────────────────────────────────────┘
```

### Result
```
┌───────────┐
│    id     │
├───────────┤
│     1     │  ← Only in 'a', not in 'b'
│     2     │  ← Only in 'a', not in 'b'
└───────────┘
2 rows returned
```

---

### 6.1 Order DOES Matter in EXCEPT

```sql
-- a EXCEPT b: values in 'a' but not in 'b'
SELECT * FROM a
EXCEPT
SELECT * FROM b;
-- Result: {1, 2}

-- b EXCEPT a: values in 'b' but not in 'a'
SELECT * FROM b
EXCEPT
SELECT * FROM a;
-- Result: {4, 5}
```

**Visual Comparison:**
```
a EXCEPT b:              b EXCEPT a:
   ┌───────────────┐        ┌───────────────┐
   │███████████    │        │     ██████████│
   │███████████    │        │     ██████████│
   │███└─────┘     │        │     └─────┘███│
   └───────────────┘        └───────────────┘
   {1, 2}                   {4, 5}
```

---

## 7. Practical Applications

### 7.1 Implementing FULL OUTER JOIN

As discussed in the Joins chapter, MySQL doesn't support FULL OUTER JOIN natively. We use UNION:

```sql
-- FULL OUTER JOIN using UNION
SELECT * FROM t1 LEFT JOIN t2 ON t1.c1 = t2.c1
UNION
SELECT * FROM t1 RIGHT JOIN t2 ON t1.c1 = t2.c1;
```

**Line-by-Line Breakdown:**
```sql
-- Part 1: All from left table + matching from right
SELECT * FROM t1 LEFT JOIN t2 ON t1.c1 = t2.c1
UNION               -- Combine and remove duplicates
-- Part 2: All from right table + matching from left
SELECT * FROM t1 RIGHT JOIN t2 ON t1.c1 = t2.c1;
-- Result: All rows from both tables with NULLs for non-matches
```

**Why this works:**
- LEFT JOIN gives: All t1 rows + matching t2
- RIGHT JOIN gives: All t2 rows + matching t1
- UNION combines them, removing the duplicate matching rows
- Result: Complete set from both tables

---

### 7.2 Finding Departments with No Employees

```sql
-- Using EXCEPT to find empty departments
SELECT deptname FROM dept
EXCEPT
SELECT deptname FROM dept JOIN emp ON dept.deptid = emp.deptid;
```

**Alternative using NOT EXISTS:**
```sql
SELECT deptname FROM dept
WHERE NOT EXISTS
(SELECT 1 FROM emp WHERE emp.deptid = dept.deptid);
```

---

### 7.3 Combining Data from Multiple Sources

```sql
-- Get all unique customer countries from both USA and France branches
SELECT country FROM usa_customers
UNION
SELECT country FROM france_customers;

-- Get customers in both databases (duplicates)
SELECT customer_id FROM usa_customers
INTERSECT
SELECT customer_id FROM france_customers;

-- Get customers only in USA database
SELECT customer_id FROM usa_customers
EXCEPT
SELECT customer_id FROM france_customers;
```

---

### 7.4 Multiple UNION Operations

```sql
-- Combine three or more queries
SELECT id FROM table1
UNION
SELECT id FROM table2
UNION
SELECT id FROM table3
UNION
SELECT id FROM table4;
```

---

## 8. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **UNION:**
>    - Combines results, removes duplicates
>    - Slower than UNION ALL
>    - Use when you need unique rows
> 
> 2. **UNION ALL:**
>    - Combines results, keeps duplicates
>    - Faster performance
>    - Use when duplicates are needed or don't exist
> 
> 3. **INTERSECT:**
>    - Returns only common rows
>    - Order doesn't matter: A ∩ B = B ∩ A
> 
> 4. **EXCEPT:**
>    - Returns rows in first query but not second
>    - Order DOES matter: A - B ≠ B - A
> 
> 5. **Requirements:**
>    - Same number of columns
>    - Compatible data types
>    - ORDER BY only at end
> 
> 6. **FULL JOIN:**
>    - Use LEFT UNION RIGHT in MySQL

---

## 📋 Practice Exercises

### Exercise 1: Basic Set Operations
```sql
-- Given tables a and b from earlier:

-- 1. Get all unique IDs from both tables
SELECT * FROM a UNION SELECT * FROM b;
-- Result: {1, 2, 3, 4, 5}

-- 2. Get all IDs including duplicates
SELECT * FROM a UNION ALL SELECT * FROM b;
-- Result: {1, 2, 3, 3, 4, 5}

-- 3. Get only IDs that exist in both tables
SELECT * FROM a INTERSECT SELECT * FROM b;
-- Result: {3}

-- 4. Get IDs only in table 'a'
SELECT * FROM a EXCEPT SELECT * FROM b;
-- Result: {1, 2}

-- 5. Get IDs only in table 'b'
SELECT * FROM b EXCEPT SELECT * FROM a;
-- Result: {4, 5}
```

### Exercise 2: Employee Queries
```sql
-- 1. Get all employees from both HR and IT departments
SELECT ename FROM emp WHERE deptid = 1  -- HR
UNION
SELECT ename FROM emp WHERE deptid = 2; -- IT

-- 2. Find employees who changed departments (exist in both lists)
SELECT emp_id FROM dept_history_2023
INTERSECT
SELECT emp_id FROM dept_history_2024;

-- 3. Find new employees in 2024
SELECT emp_id FROM employees_2024
EXCEPT
SELECT emp_id FROM employees_2023;
```

### Exercise 3: Complex Combinations
```sql
-- Get customers from USA, Canada, or Mexico (unique)
SELECT customerName, country FROM customers WHERE country = 'USA'
UNION
SELECT customerName, country FROM customers WHERE country = 'Canada'
UNION
SELECT customerName, country FROM customers WHERE country = 'Mexico'
ORDER BY country, customerName;
```

---

## 📚 Further Reading
- [Previous: SQL Joins ←](./07_SQL_Joins.md)
- [Next: Aggregate Functions →](./09_Aggregate_Functions.md)

---

*Last Updated: December 2024*
