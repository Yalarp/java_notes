# Welcome Files

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Search Order](#search-order)
4. [Key Takeaways](#key-takeaways)
5. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Welcome files** specify default pages when a user accesses a directory URL without specifying a file.

```
http://localhost:8080/myapp/      ← No file specified
```

Container looks for welcome files and serves the first one found.

---

## 📖 Configuration

### web.xml

```xml
<welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.jsp</welcome-file>
    <welcome-file>default.html</welcome-file>
</welcome-file-list>
```

---

## 📖 Search Order

```
Request: http://localhost:8080/myapp/

Container checks:
1. /myapp/index.html    → Found? Serve it.
2. /myapp/index.jsp     → Found? Serve it.
3. /myapp/default.html  → Found? Serve it.
4. Not found? 404 error
```

### Tomcat Defaults

If no `<welcome-file-list>` specified:
- index.html
- index.htm
- index.jsp

---

## ✅ Key Takeaways

1. Welcome files are **default pages** for directories
2. Container checks files **in order**
3. First found file is served
4. Configure via `<welcome-file-list>` in web.xml

---

## 🎤 Interview Questions

**Q1: What are welcome files?**
> **A:** Default pages served when user accesses a directory URL without specifying a file.

**Q2: What happens if no welcome file is found?**
> **A:** 404 Not Found error, or directory listing if enabled.
