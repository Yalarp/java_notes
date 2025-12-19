# 📚 Database Normalization - Organizing Data Efficiently

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand what normalization is and why it's important
- Identify database anomalies (insertion, update, deletion)
- Apply First Normal Form (1NF)
- Apply Second Normal Form (2NF)
- Apply Third Normal Form (3NF)
- Understand Boyce-Codd Normal Form (BCNF)
- Know when to denormalize

---

## 📖 Table of Contents
1. [What is Normalization?](#1-what-is-normalization)
2. [Database Anomalies](#2-database-anomalies)
3. [First Normal Form (1NF)](#3-first-normal-form-1nf)
4. [Second Normal Form (2NF)](#4-second-normal-form-2nf)
5. [Third Normal Form (3NF)](#5-third-normal-form-3nf)
6. [Boyce-Codd Normal Form (BCNF)](#6-boyce-codd-normal-form-bcnf)
7. [Denormalization](#7-denormalization)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. What is Normalization?

**Normalization** is the process of organizing database tables to minimize redundancy and dependency by dividing large tables into smaller, related tables.

### Goals of Normalization
```
┌────────────────────────────────────────────────────────────────┐
│                  Goals of Normalization                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Eliminate Redundant Data    →  Reduce storage waste        │
│  2. Ensure Data Integrity       →  Consistency across tables   │
│  3. Simplify Queries            →  Easier to maintain          │
│  4. Reduce Anomalies            →  Insertion, Update, Delete   │
│  5. Improve Performance         →  Faster updates              │
└────────────────────────────────────────────────────────────────┘
```

### Normal Forms Hierarchy
```
┌──────────────────────────────────────────────────────┐
│              Normal Forms (NF)                        │
├──────────────────────────────────────────────────────┤
│                                                       │
│  1NF  ←  Basic: No repeating groups                  │
│   ↓                                                   │
│  2NF  ←  Eliminates partial dependencies             │
│   ↓                                                   │
│  3NF  ←  Eliminates transitive dependencies          │
│   ↓                                                   │
│ BCNF  ←  Stricter version of 3NF                     │
│   ↓                                                   │
│  4NF, 5NF  ←  Advanced (rarely used)                 │
└──────────────────────────────────────────────────────┘
```

> [!NOTE]
> Most applications only need to reach 3NF for practical purposes.

---

## 2. Database Anomalies

### Types of Anomalies

**Unnormalized Student Table:**
```
┌─────────┬──────────┬───────────────────────────────────┬──────────────┐
│Student_ID│Student_  │ Courses                          │ Department   │
│         │ Name     │                                   │              │
├─────────┼──────────┼───────────────────────────────────┼──────────────┤
│  101    │ John     │ Math, Physics, Chemistry          │ Science      │
│  102    │ Jane     │ English, History                  │ Arts         │
│  103    │ Bob      │ Math, Computer Science            │ Science      │
└─────────┴──────────┴───────────────────────────────────┴──────────────┘
```

---

### 2.1 Insertion Anomaly

**Problem:** Cannot insert certain data without other data.

**Example:**
```
Cannot add a new Department (e.g., "Engineering") without adding a student.
```

---

### 2.2 Update Anomaly

**Problem:** Updating data in one place requires updates in multiple places, risking inconsistency.

**Example:**
```
If "Science" department changes to "Natural Sciences":
- Must update EVERY row with department="Science"
- If we miss one, data becomes inconsistent
```

---

### 2.3 Deletion Anomaly

**Problem:** Deleting data unintentionally removes other important data.

**Example:**
```
If we delete the last student in "Arts" department:
- We lose information that "Arts" department exists
```

---

## 3. First Normal Form (1NF)

### Definition
A table is in **1NF** if:
1. All columns contain **atomic (indivisible) values**
2. Each column contains values of **single type**
3. Each row is **unique** (has a primary key)
4. No **repeating groups** or arrays

---

### 3.1 Violation Example

**NOT in 1NF:**
```
┌─────────┬──────────┬───────────────────────────┐
│Student_ID│Student_  │ Courses                  │
│         │ Name     │                           │
├─────────┼──────────┼───────────────────────────┤
│  101    │ John     │ Math, Physics, Chemistry  │ ← Multiple values!
│  102    │ Jane     │ English, History          │ ← Multiple values!
└─────────┴──────────┴───────────────────────────┘
```

**Problem:** "Courses" column has multiple values (not atomic).

---

### 3.2 Converting to 1NF

**Method 1: Separate rows for each course**
```
┌─────────┬──────────┬──────────────┐
│Student_ID│Student_  │ Course       │
│         │ Name     │              │
├─────────┼──────────┼──────────────┤
│  101    │ John     │ Math         │
│  101    │ John     │ Physics      │
│  101    │ John     │ Chemistry    │
│  102    │ Jane     │ English      │
│  102    │ Jane     │ History      │
└─────────┴──────────┴──────────────┘
```

**Method 2: Create separate tables (better)**
```
STUDENTS Table:
┌─────────┬──────────┐
│Student_ID│Student_  │
│         │ Name     │
├─────────┼──────────┤
│  101    │ John     │
│  102    │ Jane     │
└─────────┴──────────┘

ENROLLMENTS Table:
┌─────────┬──────────────┐
│Student_ID│ Course       │
├─────────┼──────────────┤
│  101    │ Math         │
│  101    │ Physics      │
│  101    │ Chemistry    │
│  102    │ English      │
│  102    │ Jane     │ History      │
└─────────┴──────────────┘
```

---

## 4. Second Normal Form (2NF)

### Definition
A table is in **2NF** if:
1. It is in **1NF**, AND
2. All non-key columns are **fully dependent** on the entire primary key (no partial dependencies)

> [!NOTE]
> 2NF only applies to tables with **composite primary keys**

---

### 4.1 Violation Example

**NOT in 2NF:**
```
ENROLLMENTS Table (Composite PK: Student_ID + Course):
┌─────────┬──────────────┬──────────────┬──────────────┐
│Student_ID│ Course       │ Student_Name │ Course_Fee   │
│  (PK)   │  (PK)        │              │              │
├─────────┼──────────────┼──────────────┼──────────────┤
│  101    │ Math         │ John         │  500         │
│  101    │ Physics      │ John         │  600         │
│  102    │ English      │ Jane         │  400         │
└─────────┴──────────────┴──────────────┴──────────────┘
```

**Problems:**
- `Student_Name` depends only on `Student_ID` (not on Course) — **Partial dependency!**
- `Course_Fee` depends only on `Course` (not on Student_ID) — **Partial dependency!**

---

### 4.2 Converting to 2NF

**Separate into three tables:**

**STUDENTS Table:**
```
┌─────────┬──────────────┐
│Student_ID│ Student_Name │
│  (PK)   │              │
├─────────┼──────────────┤
│  101    │ John         │
│  102    │ Jane         │
└─────────┴──────────────┘
```

**COURSES Table:**
```
┌──────────────┬──────────────┐
│ Course       │ Course_Fee   │
│  (PK)        │              │
├──────────────┼──────────────┤
│ Math         │  500         │
│ Physics      │  600         │
│ English      │  400         │
└──────────────┴──────────────┘
```

**ENROLLMENTS Table:**
```
┌─────────┬──────────────┐
│Student_ID│ Course       │
│  (PK)   │  (PK)        │
├─────────┼──────────────┤
│  101    │ Math         │
│  101    │ Physics      │
│  102    │ English      │
└─────────┴──────────────┘
```

---

## 5. Third Normal Form (3NF)

### Definition
A table is in **3NF** if:
1. It is in **2NF**, AND
2. No non-key column is **transitively dependent** on the primary key

**Transitive Dependency:** A → B → C (where A is the key)

---

### 5.1 Violation Example

**NOT in 3NF:**
```
EMPLOYEES Table:
┌──────────┬──────────────┬──────────┬──────────────────┐
│ Emp_ID   │ Emp_Name     │ Dept_ID  │ Dept_Manager     │
│  (PK)    │              │          │                  │
├──────────┼──────────────┼──────────┼──────────────────┤
│  1       │ Alice        │  10      │ John             │
│  2       │ Bob          │  20      │ Sarah            │
│  3       │ Charlie      │  10      │ John             │
└──────────┴──────────────┴──────────┴──────────────────┘
```

**Problem:**
- `Emp_ID` → `Dept_ID` (direct dependency)
- `Dept_ID` → `Dept_Manager` (direct dependency)
- Therefore: `Emp_ID` → `Dept_ID` → `Dept_Manager` (**Transitive dependency!**)

**Consequence:**
- If John changes to a different manager for Dept 10, must update MULTIPLE rows
- Update anomaly!

---

### 5.2 Converting to 3NF

**Separate into two tables:**

**EMPLOYEES Table:**
```
┌──────────┬──────────────┬──────────┐
│ Emp_ID   │ Emp_Name     │ Dept_ID  │
│  (PK)    │              │  (FK)    │
├──────────┼──────────────┼──────────┤
│  1       │ Alice        │  10      │
│  2       │ Bob          │  20      │
│  3       │ Charlie      │  10      │
└──────────┴──────────────┴──────────┘
```

**DEPARTMENTS Table:**
```
┌──────────┬──────────────────┐
│ Dept_ID  │ Dept_Manager     │
│  (PK)    │                  │
├──────────┼──────────────────┤
│  10      │ John             │
│  20      │ Sarah            │
└──────────┴──────────────────┘
```

---

## 6. Boyce-Codd Normal Form (BCNF)

### Definition
A table is in **BCNF** if:
1. It is in **3NF**, AND
2. Every determinant is a candidate key

**Determinant:** A column whose value determines the value of another column.

> [!NOTE]
> BCNF is a stricter version of 3NF. Most tables in 3NF are also in BCNF.

---

### 6.1 When 3NF ≠ BCNF

**Example:**
```
TEACHING Table (Composite Key: Student_ID + Subject):
┌─────────┬──────────┬──────────────┐
│Student  │ Subject  │ Teacher      │
│  ID     │          │              │
├─────────┼──────────┼──────────────┤
│  101    │ Math     │ Dr. Smith    │
│  102    │ Math     │ Dr. Smith    │
│  101    │ Physics  │ Dr. Jones    │
└─────────┴──────────┴──────────────┘
```

**Problem:**
- Teacher depends on Subject (one teacher per subject)
- But Teacher is not a key!

**To BCNF:**
```
SUBJECTS_TEACHERS:
┌──────────┬──────────────┐
│ Subject  │ Teacher      │
│  (PK)    │              │
├──────────┼──────────────┤
│ Math     │ Dr. Smith    │
│ Physics  │ Dr. Jones    │
└──────────┴──────────────┘

STUDENT_SUBJECTS:
┌─────────┬──────────┐
│Student  │ Subject  │
│  ID(PK) │  (PK,FK) │
├─────────┼──────────┤
│  101    │ Math     │
│  102    │ Math     │
│  101    │ Physics  │
└─────────┴──────────┘
```

---

## 7. Denormalization

### Why Denormalize?

Sometimes we **intentionally** violate normal forms for **performance reasons**.

**Reasons to Denormalize:**
- Reduce JOIN operations (faster reads)
- Simplify queries
- Improve query performance
- Data warehousing / reporting

**Trade-offs:**
- ✅ Faster reads
- ❌ Slower writes
- ❌ More storage
- ❌ Risk of inconsistency

---

### Example

**Normalized (3NF):**
```sql
-- Requires JOIN for each query
SELECT c.customer_name, o.order_date, o.total
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;
```

**Denormalized:**
```sql
-- Denormalized orders table includes customer_name
-- No JOIN needed!
SELECT customer_name, order_date, total
FROM orders_denormalized;
```

---

## 8. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Normalization Process:**
>    - Organize tables to reduce redundancy
>    - Eliminate anomalies
>    - Improve data integrity
> 
> 2. **Normal Forms:**
>    - **1NF**: Atomic values, no repeating groups
>    - **2NF**: 1NF + no partial dependencies
>    - **3NF**: 2NF + no transitive dependencies
>    - **BCNF**: 3NF + all determinants are keys
> 
> 3. **Database Anomalies:**
>    - Insertion: Can't add without other data
>    - Update: Must update multiple places
>    - Deletion: Lose unintended data
> 
> 4. **Guidelines:**
>    - Most apps need only 3NF
>    - BCNF for critical systems
>    - Denormalize for performance (carefully!)
> 
> 5. **Benefits:**
>    - Less redundancy
>    - Easier maintenance
>    - Better integrity
>    - Smaller database size

---

## 📋 Practice Exercises

### Exercise 1: Identify Normal Form
```
Table: ORDERS
┌──────────┬─────────────┬────────────┬──────────────┬─────────────┐
│ Order_ID │ Customer_   │ Customer_  │ Product_Name │ Product_    │
│          │ Name        │ City       │              │ Price       │
├──────────┼─────────────┼────────────┼──────────────┼─────────────┤
│  1001    │ John Smith  │ NYC        │ Laptop       │  1000       │
│  1002    │ Jane Doe    │ LA         │ Mouse        │   20        │
└──────────┴─────────────┴────────────┴──────────────┴─────────────┘

Questions:
1. Is this table in 1NF? Yes
2. Is it in 2NF? No - Customer data depends only on Customer
3. Is it in 3NF? No - transitive dependencies exist
```

### Exercise 2: Normalize to 3NF
```sql
-- Original unnormalized table
CREATE TABLE orders_unnormalized (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_city VARCHAR(50),
    product_name VARCHAR(100),
    product_price DECIMAL(10,2),
    quantity INT
);

-- Solution: Separate into 3 tables

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## 📚 Further Reading
- [Previous: Transaction Management ←](./12_Transaction_Management.md)
- [Next: Sample Database Schema →](./14_Sample_Database_Schema.md)

---

*Last Updated: December 2024*
