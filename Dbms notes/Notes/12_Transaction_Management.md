# 📚 Transaction Management in SQL

## 🎯 Learning Objectives
By the end of this chapter, you will be able to:
- Understand what transactions are and why they're important
- Use START TRANSACTION, COMMIT, and ROLLBACK
- Understand auto-commit behavior in MySQL
- Apply transactions to maintain data integrity
- Handle transaction boundaries properly

---

## 📖 Table of Contents
1. [What are Transactions?](#1-what-are-transactions)
2. [ACID Properties Review](#2-acid-properties-review)
3. [Transaction Commands](#3-transaction-commands)
4. [Auto-Commit Behavior](#4-auto-commit-behavior)
5. [Transaction Examples](#5-transaction-examples)
6. [Key Takeaways](#6-key-takeaways)

---

## 1. What are Transactions?

A **Transaction** is a sequence of one or more SQL operations executed as a single unit of work.

### Transaction Lifecycle
```
┌────────────────────────────────────────────────────────────────┐
│                  Transaction Lifecycle                          │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  START TRANSACTION                                              │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────┐                                              │
│  │  Execute SQL │ ← Multiple INSERT/UPDATE/DELETE              │
│  │  Statements  │                                              │
│  └──────────────┘                                              │
│         │                                                       │
│         ▼                                                       │
│    ┌─────────┐                                                 │
│    │Success? │                                                 │
│    └─────────┘                                                 │
│      │     │                                                   │
│   YES│     │NO                                                 │
│      ▼     ▼                                                   │
│   COMMIT  ROLLBACK                                             │
│   (Save)  (Undo)                                               │
└────────────────────────────────────────────────────────────────┘
```

### Why Use Transactions?

**Without Transactions:**
```sql
-- Transfer $100 from Account A to Account B
UPDATE accounts SET balance = balance - 100 WHERE account = 'A';
-- ⚠️ System crash here!
UPDATE accounts SET balance = balance + 100 WHERE account = 'B';
-- Second statement never executes - money lost!
```

**With Transactions:**
```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE account = 'A';
UPDATE accounts SET balance = balance + 100 WHERE account = 'B';
COMMIT;
-- Both succeed or both fail - money never lost!
```

---

## 2. ACID Properties Review

> [!NOTE]
> Transactions ensure ACID properties (covered in detail in Introduction to DBMS)

```
┌────────────────────────────────────────────────────────────────┐
│                      ACID Properties                            │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  A - Atomicity:     All or nothing                             │
│  C - Consistency:   Valid state → Valid state                  │
│  I - Isolation:     Transactions don't interfere               │
│  D - Durability:    Committed = Permanent                      │
└────────────────────────────────────────────────────────────────┘
```

---

## 3. Transaction Commands

### 3.1 START TRANSACTION

Begins a new transaction.

```sql
START TRANSACTION;
```

**Alternative commands (equivalent):**
```sql
BEGIN;
BEGIN WORK;
```

---

### 3.2 COMMIT

Saves all changes made in the current transaction permanently.

```sql
COMMIT;
-- or
COMMIT WORK;
```

---

### 3.3 ROLLBACK

Undoes all changes made in the current transaction.

```sql
ROLLBACK;
-- or
ROLLBACK WORK;
```

---

## 4. Auto-Commit Behavior

### 4.1 Default Auto-Commit

By default, MySQL runs in **auto-commit mode**: each statement is automatically committed.

```sql
-- In auto-commit mode:
DELETE FROM test;  
-- Automatically committed immediately!
-- Cannot rollback!
```

---

### 4.2 Disabling Auto-Commit

```sql
-- Method 1: Use START TRANSACTION
START TRANSACTION;
DELETE FROM test;
-- Not committed yet!
ROLLBACK;  -- Can undo!

-- Method 2: Disable auto-commit globally
SET autocommit = 0;
DELETE FROM test;
-- Not committed yet!
COMMIT or ROLLBACK;  -- Must explicitly commit/rollback
```

---

## 5. Transaction Examples

### 5.1 Basic ROLLBACK

```sql
-- Start transaction
START TRANSACTION;

-- Make changes
DELETE FROM test;
INSERT INTO test VALUES(100, 'ff');
UPDATE test SET name = 'abc' WHERE id = 100;

-- Undo everything
ROLLBACK;

-- Result: No changes applied!
```

**Line-by-Line Breakdown:**
```sql
START TRANSACTION;           -- Step 1: Begin transaction
DELETE FROM test;            -- Step 2: Delete all rows (in memory)
INSERT INTO test VALUES(100, 'ff');  -- Step 3: Insert new row (in memory)
UPDATE test SET name = 'abc' WHERE id = 100;  -- Step 4: Update row (in memory)
ROLLBACK;                    -- Step 5: Discard ALL changes, restore original state
```

**Execution Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: START TRANSACTION                                   │
│         Create transaction buffer                           │
│         ↓                                                   │
│ Step 2: DELETE FROM test                                    │
│         Mark rows as deleted (not physically removed)       │
│         ↓                                                   │
│ Step 3: INSERT new row                                      │
│         Add to transaction buffer (not to table yet)        │
│         ↓                                                   │
│ Step 4: UPDATE row                                          │
│         Modify in transaction buffer                        │
│         ↓                                                   │
│ Step 5: ROLLBACK                                            │
│         Discard transaction buffer                          │
│         Restore table to state before START TRANSACTION     │
└─────────────────────────────────────────────────────────────┘
```

---

### 5.2 Successful COMMIT

```sql
-- Start transaction
START TRANSACTION;

-- Insert data
INSERT INTO test VALUES(1, 'a');

-- Commit changes
COMMIT;

-- Result: Data permanently saved!
```

---

### 5.3 Nested Transaction Problem

```sql
START TRANSACTION;
DELETE FROM test;

START TRANSACTION;  -- ⚠️ WARNING: This auto-commits the previous transaction!
INSERT INTO test VALUES(100, 'ff');
UPDATE test SET name = 'abc' WHERE id = 100;

ROLLBACK;  -- Only rolls back INSERT and UPDATE, NOT DELETE!
```

**Line-by-Line Breakdown:**
```sql
START TRANSACTION;           -- Transaction 1 begins
DELETE FROM test;            -- DELETE in transaction 1

START TRANSACTION;           -- ⚠️ Auto-commits transaction 1!
                            -- DELETE is now permanent!
                            -- Transaction 2 begins
INSERT INTO test VALUES(100, 'ff');     -- In transaction 2
UPDATE test SET name = 'abc' WHERE id = 100;  -- In transaction 2

ROLLBACK;                    -- Rolls back transaction 2 only
                            -- DELETE from transaction 1 is STILL committed!
```

> [!CAUTION]
> **Starting a new transaction auto-commits the previous one!**

---

### 5.4 Bank Transfer Example

```sql
-- Transfer $500 from Account 1 to Account 2
START TRANSACTION;

-- Withdraw from Account 1
UPDATE accounts 
SET balance = balance - 500 
WHERE account_id = 1;

-- Check if sufficient funds (application logic)
-- If balance < 0 after withdrawal, rollback

-- Deposit to Account 2
UPDATE accounts 
SET balance = balance + 500 
WHERE account_id = 2;

-- Verify both updates succeeded
COMMIT;  -- Make changes permanent
```

---

### 5.5 Error Handling Pattern

```sql
START TRANSACTION;

-- Try multiple operations
INSERT INTO orders VALUES(1001, 'Product A', 100);
UPDATE inventory SET stock = stock - 1 WHERE product = 'Product A';
INSERT INTO order_history VALUES(1001, NOW());

-- If ANY statement fails, rollback
-- Otherwise commit
COMMIT;
```

---

## 6. Key Takeaways

> [!IMPORTANT]
> ### 🔑 Summary Points
> 
> 1. **Transaction Commands:**
>    - `START TRANSACTION` / `BEGIN` - Start transaction
>    - `COMMIT` - Save changes permanently
>    - `ROLLBACK` - Undo all changes
> 
> 2. **ACID Guarantees:**
>    - Atomicity: All or nothing
>    - Consistency: Valid states only
>    - Isolation: No interference
>    - Durability: Committed = permanent
> 
> 3. **Auto-Commit:**
>    - Default: ON (each statement auto-commits)
>    - Use START TRANSACTION to disable temporarily
>    - DDL commands (CREATE, ALTER, DROP) always auto-commit!
> 
> 4. **Important Rules:**
>    - Cannot nest transactions (new START auto-commits previous)
>    - DDL auto-commits (cannot rollback CREATE/ALTER/DROP)
>    - Always pair START with COMMIT or ROLLBACK
> 
> 5. **Use Cases:**
>    - Money transfers
>    - Multi-table inserts
>    - Data integrity operations
>    - Batch updates

---

## 📋 Practice Exercises

### Exercise 1: Basic Transactions
```sql
-- Test ROLLBACK
START TRANSACTION;
INSERT INTO test VALUES(99, 'test');
SELECT * FROM test;  -- Should see the new row
ROLLBACK;
SELECT * FROM test;  -- Row is gone!

-- Test COMMIT
START TRANSACTION;
INSERT INTO test VALUES(99, 'test');
COMMIT;
SELECT * FROM test;  -- Row is permanent
```

### Exercise 2: Multiple Operations
```sql
-- Transfer operation
START TRANSACTION;

-- Update multiple related tables
INSERT INTO orders(order_id, customer_id, total) VALUES(1001, 5, 250);
UPDATE customers SET total_orders = total_orders + 1 WHERE customer_id = 5;
UPDATE products SET stock = stock - 2 WHERE product_id = 101;

-- If all succeed
COMMIT;

-- If any fails (should rollback)
-- ROLLBACK;
```

### Exercise 3: Error Scenarios
```sql
-- Scenario 1: Forget to COMMIT
START TRANSACTION;
UPDATE test SET name = 'updated' WHERE id = 1;
-- Oops! Close connection without COMMIT
-- Result: Changes lost!

-- Scenario 2: Nested transactions
START TRANSACTION;
DELETE FROM test WHERE id = 1;
START TRANSACTION;  -- Auto-commits DELETE!
INSERT INTO test VALUES(2, 'new');
ROLLBACK;  -- Only undoes INSERT, DELETE is permanent!
```

---

## 📚 Further Reading
- [Previous: Subqueries ←](./11_Subqueries.md)
- [Next: Normalization →](./13_Normalization.md)

---

*Last Updated: December 2024*
