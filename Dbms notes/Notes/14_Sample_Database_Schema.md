# 📚 ClassicModels Sample Database Schema

## 🎯 Learning Objectives
By the end of this chapter, you will understand:
- The ClassicModels database structure and business model
- All tables, their relationships, and constraints
- How to query real-world business data
- Common use cases and query patterns

---

## 📖 Table of Contents
1. [Database Overview](#1-database-overview)
2. [Entity Relationship Diagram](#2-entity-relationship-diagram)
3. [Table Structures](#3-table-structures)
4. [Sample Queries](#4-sample-queries)
5. [Business Scenarios](#5-business-scenarios)

---

## 1. Database Overview

### Database Information
- **Database Name:** `classicmodels`
- **Character Set:** `latin1`
- **Purpose:** A company that sells scale models of classic cars
- **Version:** 3.1

**Business Model:**
- Customers place orders for products
- Orders contain multiple order details (line items)
- Employees manage customer relationships
- Offices house employees
- Products are organized by product lines

---

## 2. Entity Relationship Diagram

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│   offices    │       │  employees   │       │  customers   │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ officeCode PK│←─────┤│officeCode FK│       │customerNumber│
│ city         │      ││employeeNumber│       │     PK       │
│ phone        │      │└──────────────┘│       │customerName  │
│ country      │      │      ▲         │       │creditLimit   │
└──────────────┘      │      │         │       └──────────────┘
                      │      │reportsTo│              │
                      │      │  (self) │              │
                      │      │         │              │
                      │      ▼         │              │
                      │ ┌──────────────┘              │
                      │ │salesRepEmployeeNumber       │
                      │ │                   FK        │
                      │ └──────────────────────────────┘
                      │                                 │
                      │                                 │
                      │                                 ▼
                      │                       ┌──────────────┐
                      │                       │   orders     │
                      │                       ├──────────────┤
                      │                       │orderNumber PK│
                      │                       │customerNumber│
                      │                       │    FK        │
                      │                       │orderDate     │
                      │                       │status        │
                      │                       └──────────────┘
                      │                                 │
                      │                                 │
                      │                                 ▼
                      │                       ┌──────────────┐
                      │                       │ orderdetails │
                      │                       ├──────────────┤
                      │                       │orderNumber PK│
                      │                       │productCode PK│
                      │                       │quantityOrdered│
                      │                       │priceEach     │
                      │                       └──────────────┘
                      │                                 │
                      │                                 │
                      │                                 ▼
                      │                       ┌──────────────┐
                      │                       │   products   │
                      │                       ├──────────────┤
                      │                       │productCode PK│
                      │                       │productName   │
                      │                       │buyPrice      │
                      └───────────────────────│productLine FK│
                                              └──────────────┘
                                                      │
                                                      │
                                                      ▼
                                            ┌──────────────┐
                                            │ productlines │
                                            ├──────────────┤
                                            │productLine PK│
                                            │textDescription│
                                            └──────────────┘
```

---

## 3. Table Structures

### 3.1 customers

**Purpose:** Store customer information

```sql
CREATE TABLE `customers` (
  `customerNumber` int(11) NOT NULL,
  `customerName` varchar(50) NOT NULL,
  `contactLastName` varchar(50) NOT NULL,
  `contactFirstName` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `addressLine1` varchar(50) NOT NULL,
  `addressLine2` varchar(50) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `postalCode` varchar(15) DEFAULT NULL,
  `country` varchar(50) NOT NULL,
  `salesRepEmployeeNumber` int(11) DEFAULT NULL,
  `creditLimit` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`customerNumber`),
  KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`salesRepEmployeeNumber`) 
    REFERENCES `employees` (`employeeNumber`)
) ENGINE=InnoDB;
```

**Key Points:**
- Primary Key: `customerNumber`
- Foreign Key: `salesRepEmployeeNumber` → employees
- Contains contact and billing information
- Tracks assigned sales representative

**Sample Data:**
```
┌────────────┬─────────────────────┬─────────────┬───────────┐
│customerNumber│customerName       │country      │creditLimit│
├────────────┼─────────────────────┼─────────────┼───────────┤
│ 103        │Atelier graphique    │France       │21000.00   │
│ 112        │Signal Gift Stores   │USA          │71800.00   │
│ 114        │Australian Collectors│Australia    │117300.00  │
└────────────┴─────────────────────┴─────────────┴───────────┘
```

---

### 3.2 employees

**Purpose:** Store employee information and hierarchy

```sql
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  KEY `reportsTo` (`reportsTo`),
  KEY `officeCode` (`officeCode`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) 
    REFERENCES `employees` (`employeeNumber`),
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) 
    REFERENCES `offices` (`officeCode`)
) ENGINE=InnoDB;
```

**Key Points:**
- Primary Key: `employeeNumber`
- Foreign Key 1: `reportsTo` → employees (self-referencing for hierarchy)
- Foreign Key 2: `officeCode` → offices
- Job titles: President, VP Sales, Sales Rep, etc.

**Sample Data:**
```
┌──────────┬──────────┬───────────┬────────────┬──────────┐
│employeeNumber│lastName│firstName │jobTitle    │reportsTo │
├──────────┼──────────┼───────────┼────────────┼──────────┤
│ 1002     │Murphy    │Diane      │President   │NULL      │
│ 1056     │Patterson │Mary       │VP Sales    │1002      │
│ 1165     │Jennings  │Leslie     │Sales Rep   │1143      │
└──────────┴──────────┴───────────┴────────────┴──────────┘
```

---

### 3.3 offices

**Purpose:** Store office locations

```sql
CREATE TABLE `offices` (
  `officeCode` varchar(10) NOT NULL,
  `city` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `addressLine1` varchar(50) NOT NULL,
  `addressLine2` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) NOT NULL,
  `postalCode` varchar(15) NOT NULL,
  `territory` varchar(10) NOT NULL,
  PRIMARY KEY (`officeCode`)
) ENGINE=InnoDB;
```

**Sample Data:**
```
┌──────────┬─────────────┬────────────┬──────────┐
│officeCode│city         │country     │territory │
├──────────┼─────────────┼────────────┼──────────┤
│ 1        │San Francisco│USA         │NA        │
│ 4        │Paris        │France      │EMEA      │
│ 5        │Tokyo        │Japan       │Japan     │
│ 6        │Sydney       │Australia   │APAC      │
└──────────┴─────────────┴────────────┴──────────┘
```

---

### 3.4 orders

**Purpose:** Store customer orders

```sql
CREATE TABLE `orders` (
  `orderNumber` int(11) NOT NULL,
  `orderDate` date NOT NULL,
  `requiredDate` date NOT NULL,
  `shippedDate` date DEFAULT NULL,
  `status` varchar(15) NOT NULL,
  `comments` text,
  `customerNumber` int(11) NOT NULL,
  PRIMARY KEY (`orderNumber`),
  KEY `customerNumber` (`customerNumber`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) 
    REFERENCES `customers` (`customerNumber`)
) ENGINE=InnoDB;
```

**Key Points:**
- Primary Key: `orderNumber`
- Foreign Key: `customerNumber` → customers
- Status: Shipped, In Process, Resolved, Cancelled, etc.

---

### 3.5 orderdetails

**Purpose:** Store line items for each order

```sql
CREATE TABLE `orderdetails` (
  `orderNumber` int(11) NOT NULL,
  `productCode` varchar(15) NOT NULL,
  `quantityOrdered` int(11) NOT NULL,
  `priceEach` decimal(10,2) NOT NULL,
  `orderLineNumber` smallint(6) NOT NULL,
  PRIMARY KEY (`orderNumber`,`productCode`),
  KEY `productCode` (`productCode`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderNumber`) 
    REFERENCES `orders` (`orderNumber`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`productCode`) 
    REFERENCES `products` (`productCode`)
) ENGINE=InnoDB;
```

**Key Points:**
- **Composite Primary Key**: `orderNumber` + `productCode`
- Foreign Key 1: `orderNumber` → orders
- Foreign Key 2: `productCode` → products
- One order can have multiple products

---

### 3.6 products

**Purpose:** Store product catalog

```sql
CREATE TABLE `products` (
  `productCode` varchar(15) NOT NULL,
  `productName` varchar(70) NOT NULL,
  `productLine` varchar(50) NOT NULL,
  `productScale` varchar(10) NOT NULL,
  `productVendor` varchar(50) NOT NULL,
  `productDescription` text NOT NULL,
  `quantityInStock` smallint(6) NOT NULL,
  `buyPrice` decimal(10,2) NOT NULL,
  `MSRP` decimal(10,2) NOT NULL,
  PRIMARY KEY (`productCode`),
  KEY `productLine` (`productLine`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) 
    REFERENCES `productlines` (`productLine`)
) ENGINE=InnoDB;
```

**Key Points:**
- Primary Key: `productCode`
- Foreign Key: `productLine` → productlines
- Tracks inventory, pricing, and vendor info

---

### 3.7 productlines

**Purpose:** Categorize products

```sql
CREATE TABLE `productlines` (
  `productLine` varchar(50) NOT NULL,
  `textDescription` varchar(4000) DEFAULT NULL,
  `htmlDescription` mediumtext,
  `image` mediumblob,
  PRIMARY KEY (`productLine`)
) ENGINE=InnoDB;
```

**Sample Data:**
```
┌──────────────┬────────────────────────────────────┐
│productLine   │textDescription                     │
├──────────────┼────────────────────────────────────┤
│Classic Cars  │Models of classic automobiles       │
│Motorcycles   │Scale models of motorcycles         │
│Planes        │Replica aircraft models             │
│Ships         │Historic ship replicas              │
│Trains        │Model trains and accessories        │
└──────────────┴────────────────────────────────────┘
```

---

## 4. Sample Queries

### 4.1 Simple Queries

```sql
-- All customers from USA
SELECT * FROM customers WHERE country = 'USA';

-- Top 10 customers by credit limit
SELECT customerName, creditLimit 
FROM customers 
ORDER BY creditLimit DESC 
LIMIT 10;

-- Employees in office 1
SELECT firstName, lastName, jobTitle 
FROM employees 
WHERE officeCode = '1';
```

### 4.2 JOIN Queries

```sql
-- Orders with customer names
SELECT o.orderNumber, c.customerName, o.orderDate, o.status
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber;

-- Employees with their office city
SELECT e.firstName, e.lastName, o.city
FROM employees e
JOIN offices o ON e.officeCode = o.officeCode;

-- Products with their category
SELECT p.productName, pl.productLine
FROM products p
JOIN productlines pl ON p.productLine = pl.productLine;
```

### 4.3 Aggregate Queries

```sql
-- Total orders per customer
SELECT c.customerName, COUNT(o.orderNumber) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
ORDER BY total_orders DESC;

-- Revenue by product line
SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM orderdetails od
JOIN products p ON od.productCode = p.productCode
GROUP BY p.productLine
ORDER BY revenue DESC;
```

---

## 5. Business Scenarios

### Scenario 1: Sales Performance
```sql
-- Sales rep with highest revenue
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

### Scenario 2: Inventory Check
```sql
-- Low stock products (less than 1000)
SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 1000
ORDER BY quantityInStock;
```

### Scenario 3: Customer Analysis
```sql
-- Customers who haven't ordered this year
SELECT c.customerName, MAX(o.orderDate) AS last_order
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
HAVING MAX(o.orderDate) < '2024-01-01' OR MAX(o.orderDate) IS NULL;
```

---

## 📚 Further Reading
- [Previous: Normalization ←](./13_Normalization.md)
- [Next: Practice Queries Collection →](./15_Practice_Queries_Collection.md)

---

*Last Updated: December 2024*
