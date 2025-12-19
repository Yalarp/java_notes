# 📚 Subqueries - Nested SELECT Statements

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand what subqueries are and when to use them
- Write scalar, single-row, and multi-row subqueries
- Use subqueries in WHERE, FROM, and SELECT clauses
- Implement correlated subqueries
- Apply EXISTS and NOT EXISTS operators

---

## 📖 Table of Contents
1. [What are Subqueries?](#1-what-are-subqueries)
2. [Scalar Subqueries](#2-scalar-subqueries)
3. [Subqueries with IN](#3-subqueries-with-in)
4. [Subqueries in FROM Clause](#4-subqueries-in-from-clause)
5. [Correlated Subqueries](#5-correlated-subqueries)
6. [EXISTS and NOT EXISTS](#6-exists-and-not-exists)
7. [Key Takeaways](#7-key-takeaways)

---

## 1. What are Subqueries?

A **Subquery** (also called **nested query** or **inner query**) is a SELECT statement embedded within another SQL statement.

### Subquery Locations
```
┌────────────────────────────────────────────────────────────────┐
│               WHERE Subqueries Can Appear                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. WHERE clause:   WHERE column = (subquery)                  │
│  2. HAVING clause:  HAVING COUNT(*) > (subquery)               │
│  3. FROM clause:    FROM (subquery) AS alias                   │
│  4. SELECT clause:  SELECT (subquery) AS column                │
└────────────────────────────────────────────────────────────────┘
```

### Types of Subqueries

| Type | Returns | Example Use |
|------|---------|-------------|
| **Scalar** | Single value (1 row, 1 column) | `WHERE deptid = (subquery)` |
| **Single-row** | One row, multiple columns | Less common in MySQL |
| **Multi-row** | Multiple rows, single column | `WHERE id IN (subquery)` |
| **Multi-column** | Multiple rows and columns | Advanced use cases |

---

## 2. Scalar Subqueries

### Definition
A **Scalar Subquery** returns exactly **one value** (single row, single column).

### 2.1 Basic Scalar Subquery

```sql
-- Display employees in HR department using subquery
SELECT ename, 'HR' AS deptname 
FROM emp 
WHERE deptid = (SELECT deptid FROM dept WHERE deptname = 'HR');
```

**Line-by-Line Breakdown:**
```sql
SELECT ename, 'HR' AS deptname  -- Select employee name and literal 'HR'
FROM emp 
WHERE deptid = (                -- Filter where deptid equals...
  SELECT deptid                 -- ...the deptid from dept table...
  FROM dept 
  WHERE deptname = 'HR'         -- ...where department name is 'HR'
);
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Execute INNER query (subquery)                      │
│         SELECT deptid FROM dept WHERE deptname = 'HR'       │
│         Returns: 1 (assuming HR has deptid=1)               │
│         ↓                                                   │
│ Step 2: Substitute result into OUTER query                  │
│         WHERE deptid = 1                                    │
│         ↓                                                   │
│ Step 3: Execute outer query with substituted value          │
│         SELECT ename, 'HR' FROM emp WHERE deptid = 1        │
└─────────────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> Scalar subqueries MUST return exactly ONE value! If they return 0 or multiple rows, you'll get an error.

---

### 2.2 Subquery vs JOIN

**Using Subquery:**
```sql
SELECT ename, 'HR' AS deptname 
FROM emp 
WHERE deptid = (SELECT deptid FROM dept WHERE deptname = 'HR');
```

**Using JOIN:**
```sql
SELECT ename, deptname
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE deptname = 'HR';
```

**When to use which:**
- **Subquery**: Simpler logic, good for filtering
- **JOIN**: Better performance, can retrieve columns from both tables

---

## 3. Subqueries with IN

### 3.1 Multi-Row Subquery

```sql
-- Find all employees in departments that have more than 10 employees
SELECT ename 
FROM emp 
WHERE deptid IN (
  SELECT deptid 
  FROM emp 
  GROUP BY deptid 
  HAVING COUNT(*) > 10
);
```

**Line-by-Line Breakdown:**
```sql
SELECT ename 
FROM emp 
WHERE deptid IN (           -- deptid must be in the list returned by...
  SELECT deptid             -- ...this subquery which returns...
  FROM emp 
  GROUP BY deptid           -- ...departments grouped...
  HAVING COUNT(*) > 10      -- ...that have more than 10 employees
);
```

---

### 3.2 NOT IN Subquery

```sql
-- Find employees NOT in HR department
SELECT ename 
FROM emp 
WHERE deptid NOT IN (
  SELECT deptid 
  FROM dept 
  WHERE deptname = 'HR'
);
```

---

## 4. Subqueries in FROM Clause

### Definition
A subquery in the FROM clause creates a **derived table** (temporary result set).

### 4.1 Top 5 from Each Department

```sql
SELECT deptname, ename, salary 
FROM (
  SELECT deptname, ename, salary,
    ROW_NUMBER() OVER(PARTITION BY deptname ORDER BY salary DESC) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t
WHERE rn <= 5;
```

**Line-by-Line Breakdown:**
```sql
SELECT deptname, ename, salary  -- Final SELECT from derived table
FROM (
  -- SUBQUERY: Create derived table with rankings
  SELECT deptname, ename, salary,
    ROW_NUMBER() OVER(PARTITION BY deptname ORDER BY salary DESC) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t                          -- MUST have alias for derived table
WHERE rn <= 5;                  -- Filter derived table
```

> [!NOTE]
> Derived tables (subqueries in FROM) **MUST** have an alias!

---

### 4.2 Another Example: Aggregate Summary

```sql
SELECT 
  AVG(dept_total) AS avg_dept_total
FROM (
  SELECT deptid, SUM(salary) AS dept_total
  FROM emp
  GROUP BY deptid
) AS dept_totals;
```

---

## 5. Correlated Subqueries

### Definition
A **Correlated Subquery** references columns from the outer query. It's executed **once for each row** of the outer query.

### 5.1 Employees Earning Above Department Average

```sql
SELECT ename, salary, deptid
FROM emp e1
WHERE salary > (
  SELECT AVG(salary)
  FROM emp e2
  WHERE e2.deptid = e1.deptid  -- Correlation: references outer query
);
```

**Line-by-Line Breakdown:**
```sql
SELECT ename, salary, deptid
FROM emp e1                    -- Outer query table aliased as e1
WHERE salary > (
  SELECT AVG(salary)
  FROM emp e2                  -- Subquery table aliased as e2
  WHERE e2.deptid = e1.deptid  -- Correlated: uses e1.deptid from outer
);
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ For EACH row in outer query emp e1:                         │
│                                                              │
│ Row 1 (e1): eid=1, salary=5000, deptid=1                    │
│   ↓ Execute subquery: SELECT AVG(salary) WHERE deptid=1     │
│   ↓ Returns: 4500                                           │
│   ↓ Compare: 5000 > 4500? YES → Include row                 │
│                                                              │
│ Row 2 (e1): eid=2, salary=3000, deptid=1                    │
│   ↓ Execute subquery: SELECT AVG(salary) WHERE deptid=1     │
│   ↓ Returns: 4500                                           │
│   ↓ Compare: 3000 > 4500? NO → Exclude row                  │
│                                                              │
│ (Repeat for all rows)                                       │
└─────────────────────────────────────────────────────────────┘
```

> [!WARNING]
> Correlated subqueries can be **slow** because they execute once per outer row!

---

## 6. EXISTS and NOT EXISTS

### 6.1 EXISTS Operator

**EXISTS** returns TRUE if the subquery returns **at least one row**.

```sql
-- Find departments that have at least one employee
SELECT deptname 
FROM dept
WHERE EXISTS (
  SELECT 1 
  FROM emp 
  WHERE emp.deptid = dept.deptid
);
```

**Line-by-Line Breakdown:**
```sql
SELECT deptname 
FROM dept
WHERE EXISTS (              -- Check if subquery returns ANY rows
  SELECT 1                  -- Doesn't matter what's selected
  FROM emp 
  WHERE emp.deptid = dept.deptid  -- Correlated condition
);
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ For EACH dept row:                                          │
│                                                              │
│ Dept 'HR' (deptid=1):                                       │
│   ↓ Execute: SELECT 1 FROM emp WHERE emp.deptid = 1         │
│   ↓ Returns: At least one row? YES → Include 'HR'           │
│                                                              │
│ Dept 'OPR' (deptid=4):                                      │
│   ↓ Execute: SELECT 1 FROM emp WHERE emp.deptid = 4         │
│   ↓ Returns: No rows → Exclude 'OPR'                        │
└─────────────────────────────────────────────────────────────┘
```

---

### 6.2 NOT EXISTS Operator

**NOT EXISTS** returns TRUE if the subquery returns **zero rows**.

```sql
-- Find departments with NO employees
SELECT deptname 
FROM dept
WHERE NOT EXISTS (
  SELECT 1 
  FROM emp 
  WHERE emp.deptid = dept.deptid
);
```

**Line-by-Line Breakdown:**
```sql
SELECT deptname 
FROM dept
WHERE NOT EXISTS (        -- Check if subquery returns ZERO rows
  SELECT 1 
  FROM emp 
  WHERE emp.deptid = dept.deptid
);
```

**This is equivalent to the provided source example:**
```sql
SELECT deptname FROM dept
WHERE NOT EXISTS
(SELECT 1 FROM emp WHERE emp.deptid = dept.deptid);
```

---

### 6.3 EXISTS vs IN

```sql
-- Using EXISTS (correlated)
SELECT deptname 
FROM dept d
WHERE EXISTS (
  SELECT 1 FROM emp e WHERE e.deptid = d.deptid
);

-- Using IN (non-correlated)
SELECT deptname 
FROM dept
WHERE deptid IN (SELECT DISTINCT deptid FROM emp);
```

**Performance:**
- **EXISTS**: Can stop as soon as first match found
- **IN**: Must evaluate all subquery results first
- **EXISTS** is often faster for large datasets

---

## 7. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Subquery Types:**
>    - Scalar: Returns 1 value
>    - Multi-row: Returns multiple rows (use with IN)
>    - Derived table: In FROM clause (needs alias)
> 
> 2. **Subquery Locations:**
>    - WHERE clause: Most common
>    - FROM clause: Creates temporary table
>    - SELECT clause: Returns calculated value
>    - HAVING clause: Filter grouped data
> 
> 3. **Correlated Subqueries:**
>    - Reference outer query columns
>    - Execute once per outer row
>    - Can be slow on large datasets
> 
> 4. **EXISTS vs IN:**
>    - EXISTS: Better for correlated checks
>    - IN: Better for small result sets
>    - NOT EXISTS: Find missing relationships
> 
> 5. **Best Practices:**
>    - Consider JOIN as alternative
>    - Use EXISTS for better performance
>    - Always alias derived tables
>    - Test with EXPLAIN for optimization

---

## 📋 Practice Exercises

### Exercise 1: Basic Subqueries
```sql
-- 1. Find employees in IT department
SELECT ename 
FROM emp 
WHERE deptid = (SELECT deptid FROM dept WHERE deptname = 'IT');

-- 2. Find employees with above-average salary
SELECT ename, salary
FROM emp
WHERE salary > (SELECT AVG(salary) FROM emp);

-- 3. Find departments with at least one employee
SELECT deptname
FROM dept
WHERE deptid IN (SELECT DISTINCT deptid FROM emp);
```

### Exercise 2: Derived Tables
```sql
-- 1. Average of department totals
SELECT AVG(total) AS overall_avg
FROM (
  SELECT deptid, SUM(salary) AS total
  FROM emp
  GROUP BY deptid
) AS dept_sums;

-- 2. Top 3 highest paid employees
SELECT *
FROM (
  SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
  FROM emp
) AS ranked
WHERE rn <= 3;
```

### Exercise 3: Correlated Subqueries
```sql
-- 1. Employees earning more than their department average
SELECT ename, salary, deptid
FROM emp e1
WHERE salary > (
  SELECT AVG(salary)
  FROM emp e2
  WHERE e2.deptid = e1.deptid
);

-- 2. Departments with more than 5 employees
SELECT deptname
FROM dept d
WHERE (SELECT COUNT(*) FROM emp e WHERE e.deptid = d.deptid) > 5;
```

### Exercise 4: EXISTS Queries
```sql
-- 1. Find departments with employees
SELECT deptname
FROM dept d
WHERE EXISTS (SELECT 1 FROM emp e WHERE e.deptid = d.deptid);

-- 2. Find empty departments
SELECT deptname
FROM dept d
WHERE NOT EXISTS (SELECT 1 FROM emp e WHERE e.deptid = d.deptid);
```

---

## 📚 Further Reading
- [Previous: Window Functions ←](./10_Window_Functions.md)
- [Next: Transaction Management →](./12_Transaction_Management.md)

---

*Last Updated: December 2024*
