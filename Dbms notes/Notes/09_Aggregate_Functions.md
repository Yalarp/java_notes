# 📚 Aggregate Functions and GROUP BY

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Use aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- Group data using GROUP BY clause
- Filter grouped data with HAVING clause
- Combine aggregates with JOIN operations
- Order and limit aggregated results

---

## 📖 Table of Contents
1. [What are Aggregate Functions?](#1-what-are-aggregate-functions)
2. [COUNT Function](#2-count-function)
3. [SUM, AVG, MIN, MAX](#3-sum-avg-min-max)
4. [GROUP BY Clause](#4-group-by-clause)
5. [HAVING Clause](#5-having-clause)
6. [Aggregates with JOINs](#6-aggregates-with-joins)
7. [ORDER BY with Aggregates](#7-order-by-with-aggregates)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. What are Aggregate Functions?

**Aggregate Functions** perform calculations on a set of values and return a single value.

### Aggregate Functions Overview
```
┌────────────────────────────────────────────────────────────────┐
│                   Aggregate Functions                           │
├─────────────┬──────────────────────────────────────────────────┤
│   COUNT()   │  Count number of rows                             │
├─────────────┼──────────────────────────────────────────────────┤
│   SUM()     │  Calculate total of numeric values                │
├─────────────┼──────────────────────────────────────────────────┤
│   AVG()     │  Calculate average of numeric values              │
├─────────────┼──────────────────────────────────────────────────┤
│   MIN()     │  Find minimum value                               │
├─────────────┼──────────────────────────────────────────────────┤
│   MAX()     │  Find maximum value                               │
└─────────────┴──────────────────────────────────────────────────┘
```

### Key Characteristics
- Aggregate functions **ignore NULL values** (except COUNT(*))
- They return a **single value** from multiple rows
- Often used with **GROUP BY** to aggregate subsets of data

---

## 2. COUNT Function

### 2.1 COUNT(*) - Count All Rows

```sql
SELECT COUNT(*) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT COUNT(*)   -- Count ALL rows in the result set
FROM t_uk         -- From table t_uk
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Read all rows from table t_uk                       │
│         ↓                                                   │
│ Step 2: Count each row (including rows with NULL values)    │
│         ↓                                                   │
│ Step 3: Return single number                                │
└─────────────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> `COUNT(*)` counts **ALL rows**, including those with NULL values!

---

### 2.2 COUNT(1) vs COUNT(*)

```sql
SELECT COUNT(1) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT COUNT(1)   -- Count all rows (1 is just a constant)
FROM t_uk
;
```

**Performance Note:**
- `COUNT(*)` and `COUNT(1)` are **functionally identical**
- Modern databases optimize both the same way
- Use `COUNT(*)` for better readability

---

### 2.3 COUNT(column) - Count Non-NULL Values

```sql
SELECT COUNT(name) FROM t_uk;
SELECT COUNT(id) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT COUNT(name)  -- Count rows where 'name' is NOT NULL
FROM t_uk
;

SELECT COUNT(id)    -- Count rows where 'id' is NOT NULL
FROM t_uk
;
```

**Example with Data:**
```
Table t_uk:
┌────────┬───────────┐
│   id   │   name    │
├────────┼───────────┤
│   1    │    a      │
│  NULL  │    a      │
│  NULL  │    b      │
│  100   │   bvbb    │
└────────┴───────────┘

SELECT COUNT(*) FROM t_uk;      -- Returns: 4 (all rows)
SELECT COUNT(id) FROM t_uk;     -- Returns: 2 (only non-NULL ids)
SELECT COUNT(name) FROM t_uk;   -- Returns: 4 (all names are non-NULL)
```

---

### 2.4 COUNT(DISTINCT column) - Count Unique Values

```sql
SELECT COUNT(DISTINCT name) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT COUNT(DISTINCT name)  -- Count UNIQUE non-NULL values in 'name'
FROM t_uk
;
```

**Example:**
```
Table t_uk:
┌────────┬───────────┐
│   id   │   name    │
├────────┼───────────┤
│   1    │    a      │
│  NULL  │    a      │  ← 'a' appears again
│  NULL  │    b      │
│  100   │   bvbb    │
└────────┴───────────┘

SELECT COUNT(name) FROM t_uk;           -- Returns: 4
SELECT COUNT(DISTINCT name) FROM t_uk;  -- Returns: 3 (a, b, bvbb)
```

---

## 3. SUM, AVG, MIN, MAX

### 3.1 SUM - Calculate Total

```sql
SELECT SUM(id) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT SUM(id)   -- Add up all non-NULL values in 'id' column
FROM t_uk
;
```

**Example:**
```sql
INSERT INTO t_uk VALUES(100, 'bvbb');
SELECT SUM(id) FROM t_uk;
-- Values: 1, NULL, NULL, 100
-- SUM: 1 + 100 = 101 (NULLs ignored)
```

---

### 3.2 MAX - Find Maximum Value

```sql
SELECT MAX(id) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT MAX(id)   -- Find highest value in 'id' column
FROM t_uk
;
```

**Example:**
```sql
-- Values: 1, NULL, NULL, 100
SELECT MAX(id) FROM t_uk;  -- Returns: 100
```

---

### 3.3 MIN - Find Minimum Value

```sql
SELECT MIN(id) FROM t_uk;
```

**Example:**
```sql
-- Values: 1, NULL, NULL, 100
SELECT MIN(id) FROM t_uk;  -- Returns: 1
```

---

### 3.4 AVG - Calculate Average

```sql
SELECT AVG(id) FROM t_uk;
```

**Line-by-Line Breakdown:**
```sql
SELECT AVG(id)   -- Calculate average of non-NULL values in 'id'
FROM t_uk
;
```

**Example:**
```sql
-- Values: 1, NULL, NULL, 100
SELECT AVG(id) FROM t_uk;
-- Calculation: (1 + 100) / 2 = 50.5
-- NULL values are NOT counted in denominator!
```

---

### 3.5 Multiple Aggregates in One Query

```sql
SELECT 
    COUNT(*) AS total_rows,
    COUNT(id) AS non_null_ids,
    SUM(id) AS total,
    AVG(id) AS average,
    MIN(id) AS minimum,
    MAX(id) AS maximum
FROM t_uk;
```

**Result:**
```
┌────────────┬───────────────┬───────┬─────────┬─────────┬─────────┐
│ total_rows │ non_null_ids  │ total │ average │ minimum │ maximum │
├────────────┼───────────────┼───────┼─────────┼─────────┼─────────┤
│     4      │      2        │  101  │  50.5   │    1    │   100   │
└────────────┴───────────────┴───────┴─────────┴─────────┴─────────┘
```

---

## 4. GROUP BY Clause

### 4.1 What is GROUP BY?

**GROUP BY** divides rows into groups based on column values, then applies aggregate functions to each group separately.

**Without GROUP BY:**
```sql
-- Total salary of ALL employees
SELECT SUM(salary) AS total_salary
FROM emp;
-- Returns: one row with total for entire table
```

**With GROUP BY:**
```sql
-- Total salary BY each department
SELECT deptname, SUM(salary) AS total_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
-- Returns: one row PER department
```

---

### 4.2 Basic GROUP BY Example

```sql
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

**Line-by-Line Breakdown:**
```sql
SELECT 
    deptname,              -- Group by this column
    SUM(salary) AS total_salary  -- Aggregate each group
FROM emp 
RIGHT JOIN dept ON emp.deptid = dept.deptid  -- Include all departments
GROUP BY deptname;         -- Create groups by department name
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Perform JOIN to get employee-department data        │
│         ↓                                                   │
│ Step 2: Divide rows into groups by deptname                 │
│         Group 1: HR employees                               │
│         Group 2: IT employees                               │
│         Group 3: Finance employees                          │
│         Group 4: OPR (no employees - NULL salaries)         │
│         ↓                                                   │
│ Step 3: For each group, calculate SUM(salary)               │
│         ↓                                                   │
│ Step 4: Return one row per group                            │
└─────────────────────────────────────────────────────────────┘
```

**Sample Result:**
```
┌──────────────┬──────────────────┐
│  deptname    │  total_salary    │
├──────────────┼──────────────────┤
│   HR         │    180000.00     │
│   IT         │    165000.00     │
│   Finance    │    155000.00     │
│   OPR        │    NULL          │ ← No employees, SUM is NULL
└──────────────┴──────────────────┘
```

---

### 4.3 Count Employees by Department

```sql
-- Display department name and count of employees in each dept
SELECT deptname, COUNT(eid) AS employee_count
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

**Line-by-Line Breakdown:**
```sql
SELECT 
    deptname,                   -- Grouping column
    COUNT(eid) AS employee_count  -- Count employees in each group
FROM emp 
RIGHT JOIN dept ON emp.deptid = dept.deptid  -- All depts
GROUP BY deptname;
```

> [!NOTE]
> We use `COUNT(eid)` instead of `COUNT(*)` to count only actual employees (not NULLs from RIGHT JOIN)

---

### 4.4 Multiple Statistics per Department

```sql
-- Display avg, max, and min salary of each dept
SELECT 
    deptname,
    AVG(salary) AS avgsal,
    MAX(salary) AS max_sal,
    MIN(salary) AS min_sal
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

**Result:**
```
┌──────────────┬──────────┬──────────┬──────────┐
│  deptname    │  avgsal  │ max_sal  │ min_sal  │
├──────────────┼──────────┼──────────┼──────────┤
│   HR         │  60000   │  75000   │  45000   │
│   IT         │  55000   │  70000   │  40000   │
│   Finance    │  51666   │  65000   │  38000   │
│   OPR        │  NULL    │  NULL    │  NULL    │
└──────────────┴──────────┴──────────┴──────────┘
```

---

### 4.5 Rules for GROUP BY

> [!WARNING]
> **Important Rule:** Every column in SELECT must EITHER be:
> 1. In the GROUP BY clause, OR
> 2. Inside an aggregate function

```sql
-- CORRECT:
SELECT deptname, SUM(salary)
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;

-- WRONG! (ename not in GROUP BY and not in aggregate):
SELECT deptname, ename, SUM(salary)
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
-- Error: ename is not aggregated or grouped
```

---

## 5. HAVING Clause

### 5.1 What is HAVING?

**HAVING** filters groups AFTER aggregation (WHERE filters rows BEFORE grouping).

```
┌─────────────────────────────────────────────────────────────┐
│              WHERE vs HAVING                                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  WHERE:  Filters individual ROWS before grouping             │
│          Cannot use aggregate functions                      │
│                                                              │
│  HAVING: Filters GROUPS after aggregation                    │
│          Can use aggregate functions                         │
└─────────────────────────────────────────────────────────────┘
```

---

### 5.2 Basic HAVING Example

```sql
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
HAVING SUM(salary) > 160000;
```

**Line-by-Line Breakdown:**
```sql
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname          -- First: create groups
HAVING SUM(salary) > 160000;  -- Then: filter groups where total > 160000
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: JOIN tables                                         │
│         ↓                                                   │
│ Step 2: GROUP BY deptname                                   │
│         Groups: HR (180K), IT (165K), Finance (155K), OPR (NULL)│
│         ↓                                                   │
│ Step 3: Calculate SUM(salary) for each group                │
│         ↓                                                   │
│ Step 4: Apply HAVING filter                                 │
│         Keep only: HR (180K > 160K) ✅                       │
│                   IT (165K > 160K) ✅                        │
│         Exclude: Finance (155K < 160K) ❌                    │
│                 OPR (NULL) ❌                                │
│         ↓                                                   │
│ Step 5: Return filtered groups                              │
└─────────────────────────────────────────────────────────────┘
```

**Result:**
```
┌──────────────┬──────────────────┐
│  deptname    │  total_salary    │
├──────────────┼──────────────────┤
│   HR         │    180000.00     │
│   IT         │    165000.00     │
└──────────────┴──────────────────┘
```

---

### 5.3 WHERE vs HAVING Example

```sql
-- WHERE: Filter employees with salary > 5000 BEFORE grouping
SELECT deptname, COUNT(*) AS high_earners
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE salary > 5000        -- Filter rows first
GROUP BY deptname;

-- HAVING: Filter departments with avg salary > 5000 AFTER grouping
SELECT deptname, AVG(salary) AS avg_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
HAVING AVG(salary) > 5000;  -- Filter groups after aggregation
```

---

### 5.4 Combining WHERE and HAVING

```sql
SELECT deptname, AVG(salary) AS avg_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE salary > 1000              -- First: filter individual rows
GROUP BY deptname                -- Second: create groups
HAVING AVG(salary) > 5000;       -- Third: filter aggregated groups
```

**Execution Order:**
```
1. FROM/JOIN   - Get data from tables
2. WHERE       - Filter individual rows
3. GROUP BY    - Create groups
4. HAVING      - Filter groups
5. SELECT      - Choose columns to return
6. ORDER BY    - Sort results
7. LIMIT       - Limit number of rows
```

---

## 6. Aggregates with JOINs

### 6.1 Employee-Department Aggregation

```sql
-- Get employee name, department name, and salary
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid;
```

---

### 6.2 Total Salary Query

```sql
-- Total salary of ALL employees
SELECT SUM(salary) AS total_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid;
```

---

### 6.3 Find Employees in Specific Department

```sql
-- Method 1: Using JOIN
SELECT deptname, ename
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE deptname = 'HR';

-- Method 2: Using Subquery
SELECT ename, 'HR' AS deptname 
FROM emp 
WHERE deptid = (SELECT deptid FROM dept WHERE deptname = 'HR');
```

---

## 7. ORDER BY with Aggregates

### 7.1 Order by Department and Salary

```sql
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY deptname, salary DESC;
```

**Line-by-Line Breakdown:**
```sql
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY 
    deptname,         -- Primary sort: by department (A-Z)
    salary DESC;      -- Within each dept: by salary (highest first)
```

---

### 7.2 Order by Column Position

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY 3;           -- Order by 3rd column (salary)
```

---

### 7.3 Multiple Aggregates with Ordering

```sql
-- Departments ordered by total salary
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
ORDER BY total_salary DESC;
```

---

## 8. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Aggregate Functions:**
>    - `COUNT(*)` = count all rows
>    - `COUNT(column)` = count non-NULL values
>    - `COUNT(DISTINCT column)` = count unique values
>    - `SUM()`, `AVG()`, `MIN()`, `MAX()` ignore NULLs
> 
> 2. **GROUP BY:**
>    - Divides rows into groups
>    - One result row per group
>    - All SELECT columns must be grouped or aggregated
> 
> 3. **HAVING:**
>    - Filters groups after aggregation
>    - Can use aggregate functions
>    - Comes after GROUP BY
> 
> 4. **WHERE vs HAVING:**
>    - WHERE: filters rows BEFORE grouping
>    - HAVING: filters groups AFTER aggregation
> 
> 5. **Query Execution Order:**
>    - FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

---

## 📋 Practice Exercises

### Exercise 1: Basic Aggregates
```sql
-- Given emp table with 100 employees:

-- 1. Total number of employees
SELECT COUNT(*) FROM emp;

-- 2. Average salary
SELECT AVG(salary) FROM emp;

-- 3. Highest and lowest salary
SELECT MAX(salary) AS highest, MIN(salary) AS lowest FROM emp;

-- 4. Total payroll
SELECT SUM(salary) AS total_payroll FROM emp;
```

### Exercise 2: GROUP BY Queries
```sql
-- 1. Count employees per department
SELECT deptname, COUNT(eid) AS emp_count
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;

-- 2. Average salary per department
SELECT deptname, AVG(salary) AS avg_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;

-- 3. Department with highest total salary
SELECT deptname, SUM(salary) AS total
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
ORDER BY total DESC
LIMIT 1;
```

### Exercise 3: HAVING Queries
```sql
-- 1. Departments with more than 30 employees
SELECT deptname, COUNT(*) AS emp_count
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
HAVING COUNT(*) > 30;

-- 2. Departments with average salary > 5000
SELECT deptname, AVG(salary) AS avg_sal
FROM emp JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
HAVING AVG(salary) > 5000;
```

---

## 📚 Further Reading
- [Previous: Set Operators ←](./08_Set_Operators.md)
- [Next: Window Functions →](./10_Window_Functions.md)

---

*Last Updated: December 2024*
