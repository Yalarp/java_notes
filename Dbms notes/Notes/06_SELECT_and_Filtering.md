# 📚 SELECT Statement and Data Filtering

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Write basic SELECT queries to retrieve data
- Use WHERE clause with various operators
- Filter data using IN, BETWEEN, LIKE operators
- Handle NULL values in queries
- Combine multiple conditions with AND/OR

---

## 📖 Table of Contents
1. [Basic SELECT Statement](#1-basic-select-statement)
2. [WHERE Clause](#2-where-clause)
3. [IN and NOT IN Operators](#3-in-and-not-in-operators)
4. [BETWEEN Operator](#4-between-operator)
5. [LIKE Operator (Pattern Matching)](#5-like-operator-pattern-matching)
6. [NULL Handling](#6-null-handling)
7. [Combining Conditions](#7-combining-conditions)
8. [ORDER BY Clause](#8-order-by-clause)
9. [LIMIT and OFFSET](#9-limit-and-offset)
10. [Key Takeaways](#10-key-takeaways)

---

## 1. Basic SELECT Statement

### 1.1 Select All Columns

```sql
SELECT * FROM test;
```

**Line-by-Line Breakdown:**
```sql
SELECT        -- DQL keyword to retrieve data
*             -- Asterisk means "all columns"
FROM test     -- Specify the source table
;             -- Statement terminator
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Parse SQL statement                                 │
│         ↓                                                   │
│ Step 2: Identify table 'test' in current database           │
│         ↓                                                   │
│ Step 3: Resolve * to all column names in table              │
│         ↓                                                   │
│ Step 4: Read all rows from table storage                    │
│         ↓                                                   │
│ Step 5: Return result set to client                         │
└─────────────────────────────────────────────────────────────┘
```

---

### 1.2 Select Specific Columns

```sql
SELECT id, name FROM test;
```

**Line-by-Line Breakdown:**
```sql
SELECT id, name   -- Specify only columns you need
FROM test         -- From the 'test' table
;
```

> [!TIP]
> Always specify column names instead of `*` in production code for:
> - Better performance (less data transfer)
> - Clearer code
> - Protection against schema changes

---

### 1.3 Select with Alias

```sql
SELECT ename AS employee_name, salary AS monthly_salary FROM emp;
```

---

## 2. WHERE Clause

### 2.1 Equality Operator (=)

```sql
SELECT id, name FROM test WHERE id = 1;
```

**Line-by-Line Breakdown:**
```sql
SELECT id, name   -- Columns to retrieve
FROM test         -- Source table
WHERE id = 1      -- Filter: only rows where id equals 1
;
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Table: test                                                  │
├────────┬───────────┐                                        │
│   id   │   name    │                                        │
├────────┼───────────┤                                        │
│   1    │    a      │  ← id=1? YES → Include                 │
│   2    │    b      │  ← id=1? NO  → Skip                    │
│   3    │    c      │  ← id=1? NO  → Skip                    │
└────────┴───────────┘                                        │
                                                               │
│ Result:                                                      │
├────────┬───────────┐                                        │
│   1    │    a      │                                        │
└────────┴───────────┘                                        │
└─────────────────────────────────────────────────────────────┘
```

---

### 2.2 Not Equal Operators (!= and <>)

```sql
-- Both are equivalent:
SELECT id, name FROM test WHERE id != 1;
SELECT id, name FROM test WHERE id <> 1;
```

**Line-by-Line Breakdown:**
```sql
SELECT id, name FROM test 
WHERE id != 1     -- All rows where id is NOT equal to 1
;

SELECT id, name FROM test 
WHERE id <> 1     -- Same as above, ANSI standard syntax
;
```

---

### 2.3 Comparison Operators (>, <, >=, <=)

```sql
-- Greater than
SELECT * FROM emp WHERE salary > 5000;

-- Less than
SELECT * FROM emp WHERE salary < 5000;

-- Greater than or equal
SELECT * FROM emp WHERE salary >= 5000;

-- Less than or equal
SELECT * FROM emp WHERE salary <= 5000;
```

---

## 3. IN and NOT IN Operators

### 3.1 IN Operator

```sql
SELECT id, name FROM test WHERE id IN (1, 3, 5);
```

**Line-by-Line Breakdown:**
```sql
SELECT id, name 
FROM test 
WHERE id IN (1, 3, 5)  -- Match if id is 1 OR 3 OR 5
;
```

**Equivalent to:**
```sql
SELECT id, name FROM test WHERE id = 1 OR id = 3 OR id = 5;
```

---

### 3.2 NOT IN Operator

```sql
SELECT id, name FROM test WHERE id NOT IN (1, 3, 5);
```

**Line-by-Line Breakdown:**
```sql
SELECT id, name 
FROM test 
WHERE id NOT IN (1, 3, 5)  -- Match if id is NOT 1 AND NOT 3 AND NOT 5
;
```

---

### 3.3 IN with Strings

```sql
SELECT id, name FROM test WHERE name IN ('a', 'b');
SELECT id, name FROM test WHERE name NOT IN ('a', 'b');
```

---

## 4. BETWEEN Operator

### 4.1 Numeric BETWEEN

```sql
SELECT * FROM test WHERE id BETWEEN 1 AND 5;
```

**Line-by-Line Breakdown:**
```sql
SELECT * 
FROM test 
WHERE id BETWEEN 1 AND 5  -- 1 <= id <= 5 (INCLUSIVE on both ends)
;
```

> [!IMPORTANT]
> BETWEEN is **inclusive** — it includes both boundary values!

**Equivalent to:**
```sql
SELECT * FROM test WHERE id >= 1 AND id <= 5;
```

---

### 4.2 NOT BETWEEN

```sql
SELECT * FROM test WHERE id NOT BETWEEN 1 AND 5;
```

**Line-by-Line Breakdown:**
```sql
SELECT * 
FROM test 
WHERE id NOT BETWEEN 1 AND 5  -- id < 1 OR id > 5
;
```

---

### 4.3 BETWEEN with Strings

```sql
SELECT * FROM test WHERE name BETWEEN 'a' AND 'c';
```

**Explanation:**
- Compares alphabetically
- Includes 'a', 'b', 'c' but NOT 'abcdef' (because 'abcdef' > 'c')

**Example Results:**
```sql
-- Given data: a, b, c, abcdef, dedeasae
SELECT * FROM test WHERE name BETWEEN 'a' AND 'c';
-- Returns: a, abcdef, b, c
-- Note: 'abcdef' is included because 'a' <= 'abcdef' < 'b'
```

---

### 4.4 Salary Range Query

```sql
-- Display employees with salary between 500 and 1300
SELECT ename, salary FROM emp WHERE salary BETWEEN 500 AND 1300;

-- Equivalent to:
SELECT ename, salary FROM emp WHERE salary >= 500 AND salary <= 1300;
```

---

## 5. LIKE Operator (Pattern Matching)

### 5.1 Wildcards

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `%` | Zero or more characters | `'a%'` matches 'a', 'ab', 'abc' |
| `_` | Exactly one character | `'a_'` matches 'ab', 'ac' (not 'a', 'abc') |

---

### 5.2 Contains Pattern

```sql
-- All names containing 'a' anywhere
SELECT * FROM test WHERE name LIKE '%a%';
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM test 
WHERE name LIKE '%a%'  -- % = any chars before, 'a' in middle, % = any chars after
;
```

**Matches:**
- 'a' ✅
- 'abc' ✅
- 'bac' ✅
- 'zebra' ✅
- 'bob' ❌

---

### 5.3 Starts With Pattern

```sql
-- All names starting with 'a'
SELECT * FROM test WHERE name LIKE 'a%';
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM test 
WHERE name LIKE 'a%'  -- Must start with 'a', anything after
;
```

**Matches:**
- 'a' ✅
- 'abc' ✅
- 'apple' ✅
- 'banana' ❌

---

### 5.4 Ends With Pattern

```sql
-- All names ending with 'a'
SELECT * FROM test WHERE name LIKE '%a';
```

**Matches:**
- 'a' ✅
- 'banana' ✅
- 'alpha' ✅
- 'abc' ❌

---

### 5.5 Specific Position Pattern

```sql
-- All names where second character is 'b'
SELECT * FROM test WHERE name LIKE '_b%';
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM test 
WHERE name LIKE '_b%'  -- _ = exactly one char, then 'b', then anything
;
```

**Matches:**
- 'ab' ✅
- 'abcdef' ✅
- 'xbyz' ✅
- 'b' ❌ (no first character)
- 'abc' ❌ (second char is 'b' ❌, it's 'b')

**Wait, let me correct:** 
- 'abc' - second char is 'b'? 'a'=1st, 'b'=2nd ✅

---

### 5.6 NOT LIKE

```sql
-- All names where second character is NOT 'b'
SELECT * FROM test WHERE name NOT LIKE '_b%';
```

---

### 5.7 Practice Queries (from Source)

```sql
-- Q6: Employees whose name ends with 'son'
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE lastName LIKE '%son';

-- Q13: Names starting with T, ending with m, one char between (e.g., Tom, Tim)
SELECT * FROM employees 
WHERE firstName LIKE 'T_m';

-- Q14: Last names that DON'T start with 'B'
SELECT * FROM employees 
WHERE lastName NOT LIKE 'B%';
```

---

## 6. NULL Handling

### 6.1 IS NULL

```sql
SELECT * FROM test WHERE name IS NULL;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM test 
WHERE name IS NULL   -- Only rows where 'name' has no value
;
```

---

### 6.2 IS NOT NULL

```sql
SELECT * FROM test WHERE name IS NOT NULL;
```

---

### 6.3 Common Mistake

```sql
-- WRONG! This doesn't work:
SELECT * FROM test WHERE name = NULL;   -- Returns empty!

-- CORRECT:
SELECT * FROM test WHERE name IS NULL;
```

**Why `= NULL` doesn't work:**
```
NULL represents "unknown"
Unknown compared to unknown = unknown (not TRUE)
The WHERE clause only includes rows where condition is TRUE
```

---

### 6.4 Practice Queries

```sql
-- Q8: Employees not reporting to anyone (no manager)
SELECT lastName, firstName, reportsTo 
FROM employees 
WHERE reportsTo IS NULL;

-- Q9: Unique state, city from customers where state exists
SELECT DISTINCT state, city 
FROM customers 
WHERE state IS NOT NULL;
```

---

## 7. Combining Conditions

### 7.1 AND Operator

```sql
-- Q3: Job title 'Sales Rep' AND officeCode is 1
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE jobTitle = 'Sales Rep' AND officeCode = '1';
```

**Line-by-Line Breakdown:**
```sql
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE 
    jobTitle = 'Sales Rep'  -- First condition
    AND                      -- Both must be true
    officeCode = '1'         -- Second condition
;
```

---

### 7.2 OR Operator

```sql
-- Q4: Job title 'Sales Rep' OR officeCode is 1
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE jobTitle = 'Sales Rep' OR officeCode = '1';
```

**Difference between AND and OR:**
```
AND: Both conditions must be TRUE
     ┌───────────┐     ┌───────────┐
     │ Condition │ AND │ Condition │ = Row included only if BOTH true
     │    A      │     │    B      │
     └───────────┘     └───────────┘

OR:  At least one condition must be TRUE
     ┌───────────┐     ┌───────────┐
     │ Condition │ OR  │ Condition │ = Row included if EITHER true
     │    A      │     │    B      │
     └───────────┘     └───────────┘
```

---

### 7.3 Complex Conditions with Parentheses

```sql
-- Q11: USA or France customers with credit > 100,000
SELECT * FROM customers 
WHERE (country = 'USA' OR country = 'France') 
AND creditLimit > 100000;
```

**Line-by-Line Breakdown:**
```sql
SELECT * FROM customers 
WHERE 
    (country = 'USA' OR country = 'France')  -- In USA or France
    AND                                        -- AND ALSO
    creditLimit > 100000                       -- Credit over 100K
;
```

> [!WARNING]
> Without parentheses, AND has higher precedence than OR!
> `A OR B AND C` means `A OR (B AND C)`, not `(A OR B) AND C`

---

## 8. ORDER BY Clause

### 8.1 Basic Ordering

```sql
-- Order by salary (ascending - lowest first)
SELECT * FROM emp ORDER BY salary;

-- Order by salary descending (highest first)
SELECT * FROM emp ORDER BY salary DESC;
```

---

### 8.2 Multiple Column Ordering

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
    deptname,       -- First sort by department (A-Z)
    salary DESC     -- Within each dept, sort by salary (highest first)
;
```

---

### 8.3 Order by Column Position

```sql
-- Order by 3rd column (salary) ascending
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY 3;

-- Same as ORDER BY salary
```

---

## 9. LIMIT and OFFSET

### 9.1 Basic LIMIT

```sql
-- Get top 5 highest paid employees
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 5;
```

**Line-by-Line Breakdown:**
```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC   -- Sort highest first
LIMIT 5                -- Return only first 5 rows
;
```

---

### 9.2 LIMIT with OFFSET

```sql
-- Get 2nd highest salary (skip 1, take 1)
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 1 OFFSET 1;
```

**Line-by-Line Breakdown:**
```sql
ORDER BY salary DESC   -- Sort highest first
LIMIT 1                -- Return 1 row
OFFSET 1               -- Skip first 1 row
;
-- Result: 2nd highest salary
```

---

### 9.3 Alternative LIMIT Syntax

```sql
-- LIMIT offset, count
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 1, 1;           -- Skip 1, take 1 (same as LIMIT 1 OFFSET 1)
```

---

### 9.4 Practice Queries

```sql
-- Q15: Top 5 customers by credit limit
SELECT customerNumber, customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 5;

-- Q16: Bottom 5 customers (lowest credit limit)
SELECT customerNumber, customerName, creditLimit
FROM customers
ORDER BY creditLimit ASC
LIMIT 5;

-- Q6: Second highest salary
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 1 OFFSET 1;
```

---

## 10. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **SELECT Basics:**
>    - `SELECT *` = all columns
>    - `SELECT col1, col2` = specific columns
>    - Always prefer specific columns over *
> 
> 2. **WHERE Operators:**
>    - `=`, `!=`, `<>`, `<`, `>`, `<=`, `>=`
>    - `IN (list)` = match any value in list
>    - `BETWEEN a AND b` = inclusive range
> 
> 3. **LIKE Patterns:**
>    - `%` = zero or more characters
>    - `_` = exactly one character
>    - `'a%'` = starts with 'a'
>    - `'%a'` = ends with 'a'
>    - `'%a%'` = contains 'a'
> 
> 4. **NULL Handling:**
>    - Use `IS NULL` / `IS NOT NULL`
>    - Never use `= NULL`
> 
> 5. **Combining Conditions:**
>    - AND = both must be true
>    - OR = at least one true
>    - Use parentheses for clarity
> 
> 6. **ORDER BY:** ASC (default) or DESC
> 7. **LIMIT:** Restrict result set, use OFFSET to skip rows

---

## 📋 Practice Exercises

### Exercise 1: Basic Filtering
```sql
-- Given the classicmodels database:

-- 1. Find all customers in USA
SELECT * FROM customers WHERE country = 'USA';

-- 2. Find employees with officeCode 1, 2, or 3
SELECT * FROM employees WHERE officeCode IN ('1', '2', '3');

-- 3. Find products with buy price between 50 and 100
SELECT * FROM products WHERE buyPrice BETWEEN 50 AND 100;
```

### Exercise 2: Pattern Matching
```sql
-- 1. Find customers whose name starts with 'A'
SELECT * FROM customers WHERE customerName LIKE 'A%';

-- 2. Find employees with 'son' in their last name
SELECT * FROM employees WHERE lastName LIKE '%son%';

-- 3. Find products where second letter is 'o'
SELECT * FROM products WHERE productName LIKE '_o%';
```

### Exercise 3: Complex Queries
```sql
-- 1. Find USA or France customers with credit > 50000
SELECT * FROM customers 
WHERE (country = 'USA' OR country = 'France')
AND creditLimit > 50000;

-- 2. Top 10 products ordered by MSRP descending
SELECT productName, MSRP 
FROM products 
ORDER BY MSRP DESC 
LIMIT 10;
```

---

## 📚 Further Reading
- [Previous: Data Constraints ←](./05_Data_Constraints.md)
- [Next: SQL Joins →](./07_SQL_Joins.md)

---

*Last Updated: December 2024*
