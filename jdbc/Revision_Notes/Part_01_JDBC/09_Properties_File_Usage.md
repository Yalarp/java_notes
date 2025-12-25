# Properties File for JDBC Configuration

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Why Use Properties Files](#why-use-properties-files)
3. [Properties File Format](#properties-file-format)
4. [Reading Properties in Java](#reading-properties-in-java)
5. [Code Example](#code-example)
6. [Best Practices](#best-practices)
7. [Key Takeaways](#key-takeaways)
8. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Properties files** are external configuration files used to store database connection details outside of Java code. This allows changing configuration without recompiling the application.

---

## 📖 Why Use Properties Files

### Problem: Hardcoded Configuration

```java
// ❌ BAD: Hardcoded values
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/mydb",  // Change requires recompile
    "root",                               // Security risk
    "password123"                         // Exposed in source code
);
```

### Solution: External Configuration

```java
// ✅ GOOD: Read from properties file
ResourceBundle rb = ResourceBundle.getBundle("myproperty");
String url = rb.getString("url");
String user = rb.getString("user");
String password = rb.getString("password");

Connection con = DriverManager.getConnection(url, user, password);
```

### Benefits

| Benefit | Description |
|---------|-------------|
| **No Recompilation** | Change config without rebuilding |
| **Security** | Credentials not in source code |
| **Environment-Specific** | Different configs for dev/test/prod |
| **Maintainability** | Centralized configuration |
| **Deployment** | Ops team can change without developers |

---

## 📋 Properties File Format

### File: myproperty.properties

```properties
# Database configuration
url=jdbc:mysql://localhost:3306/mydb
user=root
password=Root

# Optional: Additional properties
driver=com.mysql.cj.jdbc.Driver
maxConnections=10
```

### Format Rules

1. File extension: `.properties`
2. Each line: `key=value`
3. Comments start with `#`
4. No quotes around values
5. No spaces around `=` (or escape them)

### Location

Place the properties file in:
- **Source folder** (src/) for ResourceBundle
- **Classpath root** for both methods
- **WEB-INF/classes** for web applications

---

## 📖 Reading Properties in Java

### Method 1: ResourceBundle (Recommended)

```java
import java.util.ResourceBundle;

// Load properties file (no .properties extension)
ResourceBundle rb = ResourceBundle.getBundle("myproperty");

// Read values
String url = rb.getString("url");
String user = rb.getString("user");
String password = rb.getString("password");
```

> **Note:** Don't include `.properties` extension when using ResourceBundle

### Method 2: Properties Class

```java
import java.util.Properties;
import java.io.FileInputStream;

Properties props = new Properties();
props.load(new FileInputStream("myproperty.properties"));

String url = props.getProperty("url");
String user = props.getProperty("user");
String password = props.getProperty("password");
```

### Comparison

| Feature | ResourceBundle | Properties |
|---------|----------------|------------|
| File Location | Classpath only | Any path |
| Extension | Don't include | Include |
| Caching | Yes (cached) | No |
| Best For | Configuration | Any key-value |

---

## 💻 Code Example

### myproperty.properties

```properties
url=jdbc:mysql://localhost:3306/mydb
user=root
password=Root
```

### ConnectionProvider.java

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ResourceBundle;

public class ConnectionProvider {
    
    private static Connection con;
    
    public static Connection getCon() {
        try {
            // Load properties file (without .properties extension)
            ResourceBundle rb = ResourceBundle.getBundle("myproperty");
            
            // Read configuration
            String url = rb.getString("url");
            String user = rb.getString("user");
            String password = rb.getString("password");
            
            // Create connection
            con = DriverManager.getConnection(url, user, password);
            
        } catch (Exception ee) {
            System.out.println(ee);
        }
        return con;
    }
}
```

### Using ConnectionProvider

```java
import java.sql.*;

public class App {
    public static void main(String[] args) {
        try {
            // Get connection from provider
            Connection con = ConnectionProvider.getCon();
            
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM dept");
            
            while (rs.next()) {
                System.out.println(rs.getInt(1) + " " + rs.getString(2));
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| 12 | `ResourceBundle.getBundle("myproperty")` | Load myproperty.properties from classpath |
| 15-17 | `rb.getString(...)` | Read values by key name |
| 20 | `DriverManager.getConnection(...)` | Create connection with config values |

---

## 🛡️ Best Practices

### 1. Never Commit Credentials to Version Control

```
# .gitignore
*.properties
```

Create a template file instead:
```properties
# myproperty.properties.template
url=jdbc:mysql://localhost:3306/YOUR_DB
user=YOUR_USERNAME
password=YOUR_PASSWORD
```

### 2. Use Different Files for Different Environments

```
config/
├── dev.properties      # Development
├── test.properties     # Testing
├── prod.properties     # Production
```

### 3. Encrypt Sensitive Data

```java
// Instead of plain text password
password=ENC(encrypted_value_here)

// Decrypt in code
String encrypted = rb.getString("password");
String password = decrypt(encrypted);
```

### 4. Provide Defaults

```java
String maxConnections = props.getProperty("maxConnections", "10");
// Uses "10" if property not found
```

---

## ✅ Key Takeaways

1. **Properties files** externalize configuration from code
2. **ResourceBundle** is recommended for classpath resources
3. **Don't include .properties extension** when using ResourceBundle
4. **Benefits**: No recompilation, security, environment-specific configs
5. **Never commit credentials** to version control
6. **Use Singleton pattern** (like ConnectionProvider) for connection management

---

## 🎤 Interview Questions

**Q1: Why should database credentials not be hardcoded in Java code?**
> **A:** 
> - **Security**: Source code may be shared, committed to repos, or decompiled
> - **Flexibility**: Changing config requires recompilation
> - **Deployment**: Different environments (dev/test/prod) need different settings
> - **Maintenance**: Centralized config is easier to manage

**Q2: What is the difference between ResourceBundle and Properties class?**
> **A:**
> - **ResourceBundle**: Reads from classpath, caches content, doesn't need file extension, supports internationalization (i18n)
> - **Properties**: Can read from any file path, no caching, needs full filename, simpler API

**Q3: Where should the properties file be placed for ResourceBundle to find it?**
> **A:** In the classpath root:
> - For standalone: In src/ folder (gets copied to bin/)
> - For Maven: In src/main/resources/
> - For web apps: In WEB-INF/classes/

**Q4: How would you handle different configurations for dev and production?**
> **A:** 
> 1. Create separate properties files: `dev.properties`, `prod.properties`
> 2. Use environment variable or system property to select which to load
> 3. Example: `ResourceBundle.getBundle(System.getProperty("env", "dev"))`
