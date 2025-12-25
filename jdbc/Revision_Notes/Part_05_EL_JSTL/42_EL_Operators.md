# EL Operators

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Arithmetic Operators](#arithmetic-operators)
3. [Comparison Operators](#comparison-operators)
4. [Logical Operators](#logical-operators)
5. [Special Operators](#special-operators)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

Expression Language provides operators for arithmetic, comparison, logical, and special operations.

---

## 📖 Arithmetic Operators

```jsp
${5 + 3}     <%-- 8 --%>
${10 - 4}    <%-- 6 --%>
${3 * 4}     <%-- 12 --%>
${10 / 3}    <%-- 3.333... --%>
${10 div 3}  <%-- Same as / --%>
${10 % 3}    <%-- 1 --%>
${10 mod 3}  <%-- Same as % --%>
```

---

## 📖 Comparison Operators

| Symbol | Alternate | Example |
|--------|-----------|---------|
| `==` | `eq` | `${a == b}` |
| `!=` | `ne` | `${a != b}` |
| `<` | `lt` | `${a < b}` |
| `>` | `gt` | `${a > b}` |
| `<=` | `le` | `${a <= b}` |
| `>=` | `ge` | `${a >= b}` |

```jsp
${user.age >= 18}
${status eq 'ACTIVE'}
```

---

## 📖 Logical Operators

```jsp
${true && false}   <%-- false --%>
${true and false}  <%-- false --%>
${true || false}   <%-- true --%>
${true or false}   <%-- true --%>
${!true}           <%-- false --%>
${not true}        <%-- false --%>
```

---

## 📖 Special Operators

### empty Operator

```jsp
${empty name}      <%-- true if null, empty string, or empty collection --%>
${not empty list}  <%-- true if list has elements --%>
```

### Ternary Operator

```jsp
${user != null ? user.name : 'Guest'}
${age >= 18 ? 'Adult' : 'Minor'}
```

---

## ✅ Key Takeaways

1. **Arithmetic**: +, -, *, /, div, %, mod
2. **Comparison**: ==, !=, <, >, <=, >= (or eq, ne, lt, gt, le, ge)
3. **Logical**: &&, ||, ! (or and, or, not)
4. **empty**: checks null, empty string, empty collection
5. **Ternary**: condition ? trueValue : falseValue

---

## 🎤 Interview Questions

**Q1: What does the empty operator check?**
> **A:** Returns true if value is null, empty string "", or empty collection/array/map.

**Q2: When would you use 'eq' instead of '=='?**
> **A:** Both work the same. 'eq' is the word form, useful in XML where < and > need escaping.
