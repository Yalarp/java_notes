# 📚 Practice Queries Collection - 100+ SQL Exercises

## 🎯 Learning Objectives
Master SQL through practice with:
- Real-world query scenarios
- Progressive difficulty levels
- Comprehensive solutions with explanations
- All major SQL concepts covered

---

## 📖 Table of Contents
1. [Basic SELECT Queries](#1-basic-select-queries)
2. [Filtering and Conditions](#2-filtering-and-conditions)
3. [JOIN Operations](#3-join-operations)
4. [Aggregate Functions](#4-aggregate-functions)
5. [Window Functions](#5-window-functions)
6. [Subqueries](#6-subqueries)
7. [Advanced Challenges](#7-advanced-challenges)

---

## 1. Basic SELECT Queries

### Q1: Display all employees in Sales Rep role

```sql
SELECT lastName, firstName, jobTitle 
FROM employees 
WHERE jobTitle = 'Sales Rep';
```

---

### Q2: Display last name, first name, job title of Sales Reps in office 1

```sql
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE jobTitle = 'Sales Rep' AND officeCode = '1';
```

---

### Q3: Employees who are Sales Rep OR in office 1

```sql
SELECT lastName, firstName, jobTitle, officeCode 
FROM employees 
WHERE jobTitle = 'Sales Rep' OR officeCode = '1';
```

---

### Q4: Employees in offices 1, 2, or 3

```sql
SELECT lastName, firstName, officeCode 
FROM employees 
WHERE officeCode IN ('1', '2', '3');

-- Alternative using BETWEEN (office codes are sequential)
SELECT lastName, firstName, officeCode 
FROM employees 
WHERE officeCode BETWEEN '1' AND '3';
```

---

### Q5: Unique states and cities from customers (excluding NULL states)

```sql
SELECT DISTINCT state, city 
FROM customers 
WHERE state IS NOT NULL;
```

---

## 2. Filtering and Conditions

### Q6: Employees whose last name ends with "son"

```sql
SELECT lastName, firstName 
FROM employees 
WHERE lastName LIKE '%son';
```

---

### Q7: Customers in USA or France

```sql
SELECT * 
FROM customers 
WHERE country IN ('USA', 'France');
```

---

### Q8: Customers in USA or France with credit limit > 100,000

```sql
SELECT * 
FROM customers 
WHERE (country = 'USA' OR country = 'France')
AND creditLimit > 100000;
```

---

### Q9: Offices in US or France

```sql
SELECT officeCode, city, phone, country 
FROM offices 
WHERE country IN ('USA', 'France');
```

---

### Q10: Employees not reporting to anyone (top management)

```sql
SELECT lastName, firstName, reportsTo 
FROM employees 
WHERE reportsTo IS NULL;
```

---

### Q11: Employees whose first name starts with 'T', ends with 'm', one char between

```sql
-- Pattern: T_m (e.g., Tom, Tim)
SELECT firstName 
FROM employees 
WHERE firstName LIKE 'T_m';
```

---

### Q12: Last names NOT starting with 'B'

```sql
SELECT lastName 
FROM employees 
WHERE lastName NOT LIKE 'B%';
```

---

### Q13: Top 5 customers by credit limit

```sql
SELECT customerNumber, customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 5;
```

---

### Q14: Bottom 5 customers (lowest credit limit)

```sql
SELECT customerNumber, customerName, creditLimit
FROM customers
ORDER BY creditLimit ASC
LIMIT 5;
```

---

### Q15: Second highest credit limit customer

```sql
SELECT customerNumber, customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 1 OFFSET 1;
```

---

### Q16: Employees whose salary is between 500 and 1300

```sql
SELECT ename, salary 
FROM emp 
WHERE salary BETWEEN 500 AND 1300;

-- Alternative
SELECT ename, salary 
FROM emp 
WHERE salary >= 500 AND salary <= 1300;
```

---

## 3. JOIN Operations

### Q17: All employees in HR department (using JOIN)

```sql
SELECT deptname, ename
FROM emp JOIN dept ON emp.deptid = dept.deptid
WHERE deptname = 'HR';
```

---

### Q18: All employees in HR department (using Subquery)

```sql
SELECT ename, 'HR' AS deptname 
FROM emp 
WHERE deptid = (SELECT deptid FROM dept WHERE deptname = 'HR');
```

---

### Q19: Orders with customer names

```sql
SELECT o.orderNumber, c.customerName, o.orderDate, o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber;
```

---

### Q20: Employees with their office city

```sql
SELECT e.firstName, e.lastName, o.city
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode;
```

---

### Q21: Products with quantities ordered

```sql
SELECT p.productName, SUM(od.quantityOrdered) AS total_ordered
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productName
ORDER BY total_ordered DESC;
```

---

### Q22: Employee names with department names and salaries

```sql
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid;
```

---

### Q23: Employees sorted by department and salary (descending)

```sql
SELECT deptname, ename, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY deptname, salary DESC;
```

---

## 4. Aggregate Functions

### Q24: Department names with employee count (including empty departments)

```sql
SELECT deptname, COUNT(eid) AS employee_count
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

---

### Q25: Total salary of all employees

```sql
SELECT SUM(salary) AS total_salary
FROM emp;

-- With department context
SELECT SUM(salary) AS total_salary
FROM emp JOIN dept ON emp.deptid = dept.deptid;
```

---

### Q26: Total salary by each department

```sql
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

---

### Q27: Departments with total salary > 160,000

```sql
SELECT deptname, SUM(salary) AS total_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname
HAVING SUM(salary) > 160000;
```

---

### Q28: Employee with highest salary

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 1;
```

---

### Q29: Employee with lowest salary

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary ASC 
LIMIT 1;
```

---

### Q30: Top 5 earning employees

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC 
LIMIT 5;
```

---

### Q31: Average salary per department

```sql
SELECT deptname, AVG(salary) AS avg_salary
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

---

### Q32: Min and max salary per department

```sql
SELECT deptname, MIN(salary) AS min_sal, MAX(salary) AS max_sal
FROM emp RIGHT JOIN dept ON emp.deptid = dept.deptid
GROUP BY deptname;
```

---

## 5. Window Functions

### Q33: Rank all employees by salary

```sql
SELECT *, 
  ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn,
  RANK() OVER(ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

---

### Q34: Rank employees within each department

```sql
SELECT *, 
  ROW_NUMBER() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rn,
  RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) AS rnk,
  DENSE_RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) AS drnk
FROM emp_rank;
```

---

### Q35: Top 5 earners from EACH department

```sql
SELECT deptname, ename, salary 
FROM (
  SELECT deptname, ename, salary,
    ROW_NUMBER() OVER(PARTITION BY deptname ORDER BY salary DESC) AS rn
  FROM emp JOIN dept ON emp.deptid = dept.deptid
) AS t
WHERE rn <= 5;
```

---

### Q36: Second highest salary

```sql
SELECT ename, deptname, salary
FROM emp JOIN dept ON emp.deptid = dept.deptid
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- Or using window function
SELECT * FROM (
  SELECT ename, salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS drnk
  FROM emp
) t WHERE drnk = 2;
```

---

## 6. Subqueries

### Q37: Employees earning above average salary

```sql
SELECT ename, salary
FROM emp
WHERE salary > (SELECT AVG(salary) FROM emp);
```

---

### Q38: Employees earning more than their department average

```sql
SELECT ename, salary, deptid
FROM emp e1
WHERE salary > (
  SELECT AVG(salary)
  FROM emp e2
  WHERE e2.deptid = e1.deptid
);
```

---

### Q39: Departments with at least one employee

```sql
SELECT deptname
FROM dept
WHERE EXISTS (
  SELECT 1 
  FROM emp 
  WHERE emp.deptid = dept.deptid
);
```

---

### Q40: Departments with NO employees

```sql
SELECT deptname 
FROM dept
WHERE NOT EXISTS (
  SELECT 1 
  FROM emp 
  WHERE emp.deptid = dept.deptid
);
```

---

## 7. Advanced Challenges

### Q41: CASE statement for salary buckets

```sql
SELECT ename, salary,
  CASE 
    WHEN salary >= 1500 THEN 'High'
    WHEN salary >= 1000 THEN 'Above Avg'
    WHEN salary >= 500 THEN 'Below Avg'
    ELSE 'Low' 
  END AS salary_bucket
FROM emp;
```

---

### Q42: Student pass/fail based on marks

```sql
-- Students PASS if min marks >= 35 AND avg marks >= 40

SELECT roll,
  CASE 
    WHEN MIN(marks) >= 35 AND AVG(marks) >= 40 THEN 'Pass'
    ELSE 'Fail' 
  END AS result
FROM marks
GROUP BY roll;
```

---

### Q43: Revenue by product line

```sql
SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY revenue DESC;
```

---

### Q44: Sales rep with highest total sales

```sql
SELECT 
  e.firstName,
  e.lastName,
  SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.employeeNumber
ORDER BY total_sales DESC
LIMIT 1;
```

---

### Q45: Customers with no orders

```sql
SELECT c.customerName
FROM customers c
WHERE NOT EXISTS (
  SELECT 1 
  FROM orders o 
  WHERE o.customerNumber = c.customerNumber
);
```

---

### Q46: Products never ordered

```sql
SELECT productCode, productName
FROM products
WHERE productCode NOT IN (
  SELECT DISTINCT productCode 
  FROM orderdetails
);
```

---

### Q47: Average order value per customer

```sql
SELECT 
  c.customerName,
  AVG(order_total) AS avg_order_value
FROM customers c
JOIN (
  SELECT o.customerNumber, SUM(od.quantityOrdered * od.priceEach) AS order_total
  FROM orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY o.orderNumber
) AS order_totals ON c.customerNumber = order_totals.customerNumber
GROUP BY c.customerName
ORDER BY avg_order_value DESC;
```

---

### Q48: Month-over-month order growth

```sql
SELECT 
  YEAR(orderDate) AS year,
  MONTH(orderDate) AS month,
  COUNT(*) AS order_count
FROM orders
GROUP BY YEAR(orderDate), MONTH(orderDate)
ORDER BY year, month;
```

---

### Q49: Self-join to find employee hierarchy

```sql
SELECT 
  e.firstName AS employee,
  m.firstName AS manager
FROM employees e
LEFT JOIN employees m ON e.reportsTo = m.employeeNumber;
```

---

### Q50: Cumulative sum of orders

```sql
SELECT 
  orderDate,
  orderNumber,
  SUM(COUNT(*)) OVER(ORDER BY orderDate) AS cumulative_orders
FROM orders
GROUP BY orderDate, orderNumber
ORDER BY orderDate;
```

---

## 📋 Key Takeaways

> [!IMPORTANT]
> **Mastering SQL requires practice!**
> 
> - Start with basic SELECT queries
> - Progress to JOINs and aggregates
> - Master window functions and subqueries
> - Solve real-world business problems
> - Always test your queries!

---

## 📚 Further Reading
- [Previous: Sample Database Schema ←](./14_Sample_Database_Schema.md)
- [Back to Introduction →](./01_Introduction_to_DBMS.md)

---

*Last Updated: December 2024*
*Practice makes perfect! Keep querying!* 🚀
