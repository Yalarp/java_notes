# JSTL Formatting Tags

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Setup](#setup)
3. [Number Formatting](#number-formatting)
4. [Date Formatting](#date-formatting)
5. [Internationalization](#internationalization)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**JSTL Formatting Tags** (fmt) provide number/date formatting and internationalization support.

---

## 📖 Setup

```jsp
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
```

---

## 📖 Number Formatting

### fmt:formatNumber

```jsp
<%-- Currency --%>
<fmt:formatNumber value="${price}" type="currency"/>
<%-- $1,234.56 --%>

<%-- Percentage --%>
<fmt:formatNumber value="0.75" type="percent"/>
<%-- 75% --%>

<%-- Custom pattern --%>
<fmt:formatNumber value="1234.5" pattern="#,##0.00"/>
<%-- 1,234.50 --%>
```

### fmt:parseNumber

```jsp
<fmt:parseNumber var="num" value="1,234.56"/>
```

---

## 📖 Date Formatting

### fmt:formatDate

```jsp
<%-- Date only --%>
<fmt:formatDate value="${now}" type="date"/>
<%-- Dec 25, 2024 --%>

<%-- Time only --%>
<fmt:formatDate value="${now}" type="time"/>
<%-- 10:30:45 AM --%>

<%-- Both --%>
<fmt:formatDate value="${now}" type="both"/>

<%-- Custom pattern --%>
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss"/>
<%-- 2024-12-25 10:30:45 --%>
```

### Date Styles

```jsp
<fmt:formatDate value="${date}" dateStyle="short"/>    <%-- 12/25/24 --%>
<fmt:formatDate value="${date}" dateStyle="medium"/>   <%-- Dec 25, 2024 --%>
<fmt:formatDate value="${date}" dateStyle="long"/>     <%-- December 25, 2024 --%>
<fmt:formatDate value="${date}" dateStyle="full"/>     <%-- Wednesday, December 25, 2024 --%>
```

---

## 📖 Internationalization

### Setting Locale

```jsp
<fmt:setLocale value="fr_FR"/>
<fmt:formatNumber value="1234.56" type="currency"/>
<%-- 1 234,56 € --%>
```

### Resource Bundles

```jsp
<fmt:setBundle basename="messages"/>
<fmt:message key="welcome.message"/>
```

---

## ✅ Key Takeaways

1. **fmt:formatNumber** - currency, percent, patterns
2. **fmt:formatDate** - date, time, custom patterns
3. **fmt:setLocale** - set locale for formatting
4. **fmt:message** - i18n message bundles

---

## 🎤 Interview Questions

**Q1: How do you format a number as currency?**
> **A:** `<fmt:formatNumber value="${price}" type="currency"/>`

**Q2: How do you display dates in custom format?**
> **A:** `<fmt:formatDate value="${date}" pattern="yyyy-MM-dd"/>`
