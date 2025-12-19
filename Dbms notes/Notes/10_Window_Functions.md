# 📚 Window Functions - ROW_NUMBER, RANK, DENSE_RANK

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand window functions and how they differ from aggregates
- Use ROW_NUMBER() to assign sequential numbers
- Apply RANK() and DENSE_RANK() for ranking data
- Implement PARTITION BY to create subgroups
- Solve complex ranking problems (Nth highest salary, top N per group)

---

## 📖 Table of Contents
1. [What are Window Functions?](#1-what-are-window-functions)
2. [ROW_NUMBER()](#2-row_number)
3. [RANK()](#3-rank)
4. [DENSE_RANK()](#4-dense_rank)
5. [PARTITION BY](#5-partition-by)
6. [Solving Ranking Problems](#6-solving-ranking-problems)
7. [Key Takeaways](#7-key-takeaways)

---

## 1. What are Window Functions?

**Window Functions** perform calculations across a set of rows that are related to the current row, WITHOUT grouping them into a single output row.

### Window Functions vs Aggregate Functions

| Feature | Aggregate Functions | Window Functions |
|---------|---------------------|------------------|
| **Output Rows** | One per group | One per input row |
| **Grouping** | Requires GROUP BY | Uses OVER clause |
| **Example** | `SUM(salary) GROUP BY dept` | `SUM(salary) OVER (PARTITION BY dept)` |
| **Row Preservation** | Rows are collapsed | All rows preserved |

### Visual Comparison
```
AGGREGATE (GROUP BY):          WINDOW FUNCTION:
┌──────┬────────┐              ┌──────┬────────┬────────┐
│ dept │ total  │              │ dept │ salary │ total  │
├──────┼────────┤              ├──────┼────────┼────────┤
│ HR   │ 180K   │              │ HR   │  60K   │ 180K   │
│ IT   │ 165K   │              │ HR   │  70K   │ 180K   │
└──────┴────────┘              │ HR   │  50K   │ 180K   │
2 rows (collapsed)              │ IT   │  55K   │ 165K   │
                               │ IT   │  60K   │ 165K   │
                               │ IT   │  50K   │ 165K   │
                               └──────┴────────┴────────┘
                               6 rows (preserved)
```

---

## 2. ROW_NUMBER()

### Definition
**ROW_NUMBER()** assigns a unique sequential integer to each row within a partition, starting from 1.

### 2.1 Basic ROW_NUMBER()

```sql
SELECT *, 
  ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
FROM emp_rank;
```

**Line-by-Line Breakdown:**
```sql
SELECT *,                              -- All existing columns
  ROW_NUMBER()                         -- Window function to assign numbers
  OVER(ORDER BY salary DESC)           -- Sort by salary descending, number 1-N
  AS rn                                -- Alias the result as 'rn'
FROM emp_rank;
```

### Sample Data
```sql
CREATE TABLE emp_rank(eid INT, ename VARCHAR(100), salary INT, deptid INT);

INSERT INTO emp_rank VALUES(1,'a',100,1);
INSERT INTO emp_rank VALUES(2,'b',200,2);
INSERT INTO emp_rank VALUES(3,'c',100,1);
INSERT INTO emp_rank VALUES(4,'d',200,2);
INSERT INTO emp_rank VALUES(5,'e',50,1);
INSERT INTO emp_rank VALUES(6,'f',60,2);
INSERT INTO emp_rank VALUES(7,'g',70,1);
```

**Table Contents:**
```
┌─────┬───────┬────────┬────────┐
│ eid │ ename │ salary │ deptid │
├─────┼───────┼────────┼────────┤
│  1  │   a   │  100   │   1    │
│  2  │   b   │  200   │   2    │
│  3  │   c   │  100   │   1    │
│  4  │   d   │  200   │   2    │
│  5  │   e   │   50   │   1    │
│  6  │   f   │   60   │   2    │
│  7  │  g    │   70   │   1    │
└─────┴───────┴────────┴────────┘
```

### Result with ROW_NUMBER()
```sql
SELECT *, 
  ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
FROM emp_rank;
```

**Result:**
```
┌─────┬───────┬────────┬────────┬────┐
│ eid │ ename │ salary │ deptid │ rn │
├─────┼───────┼────────┼────────┼────┤
│  2  │   b   │  200   │   2    │  1 │ ← Highest salary
│  4  │   d   │  200   │   2    │  2 │ ← Same salary, next number
│  1  │   a   │  100   │   1    │  3 │
│  3  │   c   │  100   │   1    │  4 │ ← Same as above but different number
│  7  │   g   │   70   │   1    │  5 │
│  6  │   f   │   60   │   2    │  6 │
│  5  │   e   │   50   │   1    │  7 │ ← Lowest salary
└─────┴───────┴────────┴────────┴────┘
```

> [!NOTE]
> ROW_NUMBER() always assigns **unique sequential numbers**, even for ties!

---

## 3. RANK()

### Definition
**RANK()** assigns a rank to each row, with **gaps** for ties.

### 3.1 Basic RANK()

```sql
SELECT *, 
  RANK() OVER(ORDER BY salary DESC) AS rnk
FROM emp_rank;
```

**Line-by-Line Breakdown:**
```sql
SELECT *,                              -- All columns
  RANK()                               -- Ranking function
  OVER(ORDER BY salary DESC)           -- Order by salary descending
  AS rnk                               -- Alias as 'rnk'
FROM emp_rank;
```

### Result with RANK()
```
┌─────┬───────┬────────┬────────┬─────┐
│ eid │ ename │ salary │ deptid │ rnk │
├─────┼───────┼────────┼────────┼─────┤
│  2  │   b   │  200   │   2    │  1  │ ← Rank 1
│  4  │   d   │  200   │   2    │  1  │ ← Same rank for tie
│  1  │   a   │  100   │   1    │  3  │ ← Gap! Skips to 3 (not 2)
│  3  │   c   │  100   │   1    │  3  │ ← Same rank
│  7  │   g   │   70   │   1    │  5  │ ← Gap again
│  6  │   f   │   60   │   2    │  6  │
│  5  │   e   │   50   │   1    │  7  │
└─────┴───────┴────────┴────────┴─────┘
```

**How RANK() works:**
- Two employees with salary 200 → both get rank 1
- Next rank is **3** (not 2) — **gaps for ties**
- Two employees with salary 100 → both get rank 3
- Next rank is **5** (not 4)

---

## 4. DENSE_RANK()

### Definition
**DENSE_RANK()** assigns ranks **without gaps** — consecutive ranks even when there are ties.

### 4.1 Basic DENSE_RANK()

```sql
SELECT *, 
  DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

**Line-by-Line Breakdown:**
```sql
SELECT *,
  DENSE_RANK()                         -- Dense ranking function
  OVER(ORDER BY salary DESC)           -- Order by salary
  AS drnk
FROM emp_rank;
```

### Result with DENSE_RANK()
```
┌─────┬───────┬────────┬────────┬──────┐
│ eid │ ename │ salary │ deptid │ drnk │
├─────┼───────┼────────┼────────┼──────┤
│  2  │   b   │  200   │   2    │  1   │ ← Rank 1
│  4  │   d   │  200   │   2    │  1   │ ← Same rank
│  1  │   a   │  100   │   1    │  2   │ ← NO gap! Next is 2
│  3  │   c   │  100   │   1    │  2   │
│  7  │   g   │   70   │   1    │  3   │ ← Consecutive
│  6  │   f   │   60   │   2    │  4   │ ← Consecutive
│  5  │   e   │   50   │   1    │  5   │ ← Consecutive
└─────┴───────┴────────┴────────┴──────┘
```

**How DENSE_RANK() works:**
- Two employees with salary 200 → both get rank 1
- Next rank is **2** (no gap!)
- Two employees with salary 100 → both get rank 2
- Next rank is **3** (always consecutive)

---

### 4.2 All Three Together

```sql
SELECT *, 
  ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn,
  RANK() OVER(ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

**Complete Result:**
```
┌─────┬───────┬────────┬────────┬────┬─────┬──────┐
│ eid │ ename │ salary │ deptid │ rn │ rnk │ drnk │
├─────┼───────┼────────┼────────┼────┼─────┼──────┤
│  2  │   b   │  200   │   2    │ 1  │  1  │  1   │
│  4  │   d   │  200   │   2    │ 2  │  1  │  1   │ ← Same rnk/drnk, diff rn
│  1  │   a   │  100   │   1    │ 3  │  3  │  2   │ ← rnk has gap
│  3  │   c   │  100   │   1    │ 4  │  3  │  2   │
│  7  │   g   │   70   │   1    │ 5  │  5  │  3   │
│  6  │   f   │   60   │   2    │ 6  │  6  │  4   │
│  5  │   e   │   50   │   1    │ 7  │  7  │  5   │
└─────┴───────┴────────┴────────┴────┴─────┴──────┘
```

---

### Comparison Summary

| Salary | ROW_NUMBER() | RANK() | DENSE_RANK() |
|--------|--------------|--------|--------------|
| 200 | 1 | 1 | 1 |
| 200 | **2** | 1 | 1 |
| 100 | 3 | **3** (gap!) | **2** (no gap!) |
| 100 | 4 | 3 | 2 |
| 70 | 5 | 5 | 3 |
| 60 | 6 | 6 | 4 |
| 50 | 7 | 7 | 5 |

---

## 5. PARTITION BY

### Definition
**PARTITION BY** divides the result set into partitions and applies the window function to each partition independently.

### 5.1 Without PARTITION BY (Global Ranking)

```sql
SELECT *, 
  ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
FROM emp_rank;
-- Ranks ALL employees together
```

---

### 5.2 With PARTITION BY (Department-wise Ranking)

```sql
SELECT *, 
  ROW_NUMBER() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rn
FROM emp_rank;
```

**Line-by-Line Breakdown:**
```sql
SELECT *,
  ROW_NUMBER()                         -- Assign row numbers
  OVER(
    PARTITION BY deptid                -- Create separate partition for each dept
    ORDER BY salary DESC               -- Within each partition, order by salary
  ) AS rn
FROM emp_rank;
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: Divide rows into partitions by deptid               │
│         Partition 1 (deptid=1): rows {1,3,5,7}              │
│         Partition 2 (deptid=2): rows {2,4,6}                │
│         ↓                                                   │
│ Step 2: Within each partition, order by salary DESC         │
│         Partition 1: {1(100), 3(100), 7(70), 5(50)}         │
│         Partition 2: {2(200), 4(200), 6(60)}                │
│         ↓                                                   │
│ Step 3: Assign ROW_NUMBER for each partition independently  │
│         Partition 1: 1,2,3,4                                │
│         Partition 2: 1,2,3                                  │
└─────────────────────────────────────────────────────────────┘
```

### Result with PARTITION BY
```
┌─────┬───────┬────────┬────────┬────┐
│ eid │ ename │ salary │ deptid │ rn │
├─────┼───────┼────────┼────────┼────┤
│  1  │   a   │  100   │   1    │ 1  │ ← Highest in dept 1
│  3  │   c   │  100   │   1    │ 2  │
│  7  │   g   │   70   │   1    │ 3  │
│  5  │   e   │   50   │   1    │ 4  │ ← Lowest in dept 1
│  2  │   b   │  200   │   2    │ 1  │ ← Highest in dept 2
│  4  │   d   │  200   │   2    │ 2  │
│  6  │   f   │   60   │   2    │ 3  │ ← Lowest in dept 2
└─────┴───────┴────────┴────────┴────┘
```

> [!IMPORTANT]
> Notice that row numbers **reset to 1** for each department!

---

### 5.3 All Three with PARTITION BY

```sql
SELECT *, 
  ROW_NUMBER() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rn,
  RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

**Result:**
```
┌─────┬───────┬────────┬────────┬────┬─────┬──────┐
│ eid │ ename │ salary │ deptid │ rn │ rnk │ drnk │
├─────┼───────┼────────┼────────┼────┼─────┼──────┤
│  1  │   a   │  100   │   1    │ 1  │  1  │  1   │
│  3  │   c   │  100   │   1    │ 2  │  1  │  1   │ ← Same salary
│  7  │   g   │   70   │   1    │ 3  │  3  │  2   │ ← Gap in RANK
│  5  │   e   │   50   │   1    │ 4  │  4  │  3   │
│  2  │   b   │  200   │   2    │ 1  │  1  │  1   │ ← Resets for dept 2
│  4  │   d   │  200   │   2    │ 2  │  1  │  1   │
│  6  │   f   │   60   │   2    │ 3  │  3  │  2   │
└─────┴───────┴────────┴────────┴────┴─────┴──────┘
```

---

## 6. Solving Ranking Problems

### 6.1 Find Second Highest Salary

```sql
-- Method 1: Using window function + subquery
SELECT ename, deptname, salary
FROM (
  SELECT ename, deptname, salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t
WHERE rn = 2;
```

**Line-by-Line Breakdown:**
```sql
SELECT ename, deptname, salary  -- Final columns to display
FROM (
  -- Inner query: rank all employees by salary
  SELECT ename, deptname, salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t                          -- Alias for subquery
WHERE rn = 2;                   -- Filter to 2nd row
```

**Alternative using LIMIT OFFSET:**
```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

---

### 6.2 Top 5 Earning Employees

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC
LIMIT 5;
```

---

### 6.3 Top 5 Employees from EACH Department

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
SELECT deptname, ename, salary 
FROM (
  -- Inner query: rank employees within each department
  SELECT deptname, ename, salary,
    ROW_NUMBER() OVER(
      PARTITION BY deptname      -- Separate ranking per dept
      ORDER BY salary DESC       -- Highest salary first
    ) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t
WHERE rn <= 5;                   -- Top 5 from EACH department
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: JOIN emp and dept tables                            │
│         ↓                                                   │
│ Step 2: PARTITION by deptname (create groups)               │
│         ↓                                                   │
│ Step 3: Within each dept, ORDER BY salary DESC              │
│         ↓                                                   │
│ Step 4: Assign ROW_NUMBER (1,2,3... per dept)               │
│         ↓                                                   │
│ Step 5: Filter WHERE rn <= 5                                │
│         Result: Top 5 from HR, Top 5 from IT, etc.          │
└─────────────────────────────────────────────────────────────┘
```

---

### 6.4 Employees with Nth Highest Salary

```sql
-- Employees with 3rd highest salary
SELECT ename, salary
FROM (
  SELECT ename, salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
  FROM emp
) AS t
WHERE drnk = 3;
```

> [!TIP]
> Use DENSE_RANK() for "Nth highest" to avoid skipping ranks!

---

## 7. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Window Functions:**
>    - Don't collapse rows (unlike GROUP BY)
>    - Use OVER() clause
>    - Can combine with PARTITION BY and ORDER BY
> 
> 2. **ROW_NUMBER():**
>    - Always unique sequential numbers
>    - No ties — even identical values get different numbers
> 
> 3. **RANK():**
>    - Ties get same rank
>    - **Has gaps** after ties
>    - Example: 1, 1, 3, 4 (gap at 2)
> 
> 4. **DENSE_RANK():**
>    - Ties get same rank
>    - **No gaps** — consecutive ranks
>    - Example: 1, 1, 2, 3 (no gap)
> 
> 5. **PARTITION BY:**
>    - Creates independent groups
>    - Ranking/numbering resets for each partition
>    - Syntax: `OVER(PARTITION BY column ORDER BY column)`
> 
> 6. **Common Use Cases:**
>    - Nth highest: Use DENSE_RANK()
>    - Top N per group: Use ROW_NUMBER() with PARTITION BY
>    - Second highest: LIMIT 1 OFFSET 1 or window function

---

## 📋 Practice Exercises

### Exercise 1: Basic Window Functions
```sql
-- Given emp_rank table:

-- 1. Assign row numbers ordered by salary
SELECT *, ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
FROM emp_rank;

-- 2. Rank employees by salary (with gaps for ties)
SELECT *, RANK() OVER(ORDER BY salary DESC) AS rnk
FROM emp_rank;

-- 3. Dense rank employees (no gaps)
SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

### Exercise 2: PARTITION BY Queries
```sql
-- 1. Rank employees within each department
SELECT *,
  ROW_NUMBER() OVER(PARTITION BY deptid ORDER BY salary DESC) AS dept_rank
FROM emp_rank;

-- 2. Show salary and department average
SELECT ename, salary, deptid,
  AVG(salary) OVER(PARTITION BY deptid) AS dept_avg
FROM emp_rank;
```

### Exercise 3: Complex Ranking
```sql
-- 1. Find top 3 earners from each department
SELECT * FROM (
  SELECT ename, salary, deptid,
    ROW_NUMBER() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rn
  FROM emp_rank
) t WHERE rn <= 3;

-- 2. Find employees with 2nd highest salary in each dept
SELECT * FROM (
  SELECT ename, salary, deptid,
    DENSE_RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) AS drnk
  FROM emp_rank
) t WHERE drnk = 2;
```

---

## 📚 Further Reading
- [Previous: Aggregate Functions ←](./09_Aggregate_Functions.md)
- [Next: Subqueries →](./11_Subqueries.md)

---

*Last Updated: December 2024*
