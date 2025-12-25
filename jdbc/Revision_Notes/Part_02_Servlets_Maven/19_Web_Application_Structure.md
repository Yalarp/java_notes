# Web Application Structure

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Standard Directory Structure](#standard-directory-structure)
3. [WEB-INF Folder](#web-inf-folder)
4. [WAR File](#war-file)
5. [Maven Web Project Structure](#maven-web-project-structure)
6. [Key Takeaways](#key-takeaways)
7. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

A Java web application follows a **standard directory structure** defined by the Servlet specification. Understanding this structure is essential for proper deployment.

---

## 📖 Standard Directory Structure

### Basic Web Application Layout

```
MyWebApp/
├── index.html                 ← Public content (accessible via URL)
├── styles/
│   └── main.css              ← Public CSS
├── scripts/
│   └── app.js                ← Public JavaScript
├── images/
│   └── logo.png              ← Public images
└── WEB-INF/                   ← PROTECTED (not directly accessible)
    ├── web.xml               ← Deployment descriptor
    ├── classes/              ← Compiled .class files
    │   └── com/
    │       └── example/
    │           └── MyServlet.class
    └── lib/                  ← JAR dependencies
        └── mysql-connector-java.jar
```

### Public vs Protected

| Location | Accessible via URL | Contains |
|----------|-------------------|----------|
| **Root folder** | ✅ Yes | HTML, CSS, JS, images |
| **WEB-INF/** | ❌ No | Classes, JARs, config |

### Access Examples

```
http://localhost:8080/MyWebApp/index.html      ✅ Works
http://localhost:8080/MyWebApp/styles/main.css ✅ Works
http://localhost:8080/MyWebApp/WEB-INF/web.xml ❌ 404 Error
```

---

## 📖 WEB-INF Folder

### Why WEB-INF is Protected

The `WEB-INF` folder CANNOT be accessed directly via URL. This is a security feature:
- Protects compiled code from being downloaded
- Hides configuration files
- Prevents access to JAR files

### WEB-INF Contents

```
WEB-INF/
├── web.xml         ← Deployment descriptor (optional in Servlet 3.0+)
├── classes/        ← Compiled Java classes
│   └── com/example/MyServlet.class
├── lib/            ← Third-party JAR files
│   ├── mysql-connector-java.jar
│   └── gson.jar
└── views/          ← JSP files (optional, for MVC pattern)
    └── display.jsp
```

### Key Folders

| Folder | Purpose | Example Contents |
|--------|---------|-----------------|
| `classes/` | Compiled .class files | `MyServlet.class` |
| `lib/` | Dependency JARs | JDBC drivers, libraries |
| `views/` | Protected JSPs | JSPs forwarded by servlets |

---

## 📖 WAR File

### What is a WAR?

**WAR (Web Application Archive)** is a packaged web application - a ZIP file with `.war` extension.

### WAR Structure

```
mywebapp.war
├── index.html
├── styles/
├── WEB-INF/
│   ├── web.xml
│   ├── classes/
│   └── lib/
└── META-INF/
    └── MANIFEST.MF
```

### Creating WAR with Maven

```bash
mvn package
# Creates: target/mywebapp-1.0.war
```

### Deploying WAR

1. Copy WAR to Tomcat's `webapps/` folder
2. Tomcat automatically extracts and deploys
3. Access at `http://localhost:8080/mywebapp/`

---

## 📖 Maven Web Project Structure

### Maven Conventions

```
my-web-app/
├── pom.xml                           ← Maven configuration
├── src/
│   ├── main/
│   │   ├── java/                     ← Java source files
│   │   │   └── com/example/
│   │   │       ├── PersonServ.java
│   │   │       └── SingletonCon.java
│   │   ├── resources/                ← Classpath resources
│   │   │   └── myproperty.properties
│   │   └── webapp/                   ← Web content (becomes WAR root)
│   │       ├── index.html
│   │       ├── styles/
│   │       │   └── main.css
│   │       └── WEB-INF/
│   │           ├── web.xml
│   │           └── views/
│   │               └── display.jsp
│   └── test/
│       └── java/                     ← Test classes
│           └── com/example/
│               └── PersonServTest.java
└── target/                           ← Build output (generated)
    ├── classes/                      ← Compiled classes
    └── my-web-app-1.0.war           ← Packaged WAR
```

### Key Maven Directories

| Directory | Purpose |
|-----------|---------|
| `src/main/java/` | Java source code |
| `src/main/resources/` | Properties, config files |
| `src/main/webapp/` | Web content root |
| `src/test/java/` | Test classes |
| `target/` | Build output |

### How Maven Builds WAR

```
src/main/java/*.java  → compile →  WEB-INF/classes/
src/main/resources/*  → copy →     WEB-INF/classes/
src/main/webapp/*     → copy →     WAR root
pom.xml dependencies  → copy →     WEB-INF/lib/
```

---

## 📖 Classloading

### Web App Classloader Hierarchy

```
                Bootstrap ClassLoader
                        ↓
                System ClassLoader
                        ↓
                Tomcat Common ClassLoader
                        ↓
            ┌───────────┴───────────┐
            ↓                       ↓
     WebApp1 ClassLoader      WebApp2 ClassLoader
     (WEB-INF/classes         (WEB-INF/classes
      WEB-INF/lib)             WEB-INF/lib)
```

### Why System CLASSPATH Doesn't Work

Each web app has its own classloader that looks in:
1. `WEB-INF/classes/`
2. `WEB-INF/lib/*.jar`

System CLASSPATH is NOT part of this hierarchy.

---

## ✅ Key Takeaways

1. **WEB-INF** is protected - not accessible via URL
2. **classes/** folder holds compiled .class files
3. **lib/** folder holds JAR dependencies
4. **WAR** is a packaged web application
5. Maven's `webapp/` folder becomes WAR root
6. Each web app has its own classloader

---

## 🎤 Interview Questions

**Q1: What is the purpose of the WEB-INF folder?**
> **A:** WEB-INF is a protected directory that cannot be accessed directly via URL. It contains:
> - `web.xml` (deployment descriptor)
> - `classes/` (compiled Java classes)
> - `lib/` (JAR dependencies)
> This protects configuration and code from direct access.

**Q2: What is a WAR file?**
> **A:** WAR (Web Application Archive) is a packaged web application. It's a ZIP file with `.war` extension containing all web resources, classes, and dependencies. It can be deployed to any compliant servlet container.

**Q3: Why can't we access files in WEB-INF directly?**
> **A:** The Servlet specification mandates that WEB-INF contents cannot be served directly. This is a security feature to protect configuration files, source code, and dependencies from being downloaded.

**Q4: Where should JDBC driver JARs be placed in a web application?**
> **A:** In `WEB-INF/lib/` folder. Setting system CLASSPATH doesn't work for web apps because each webapp has its own classloader that only looks in WEB-INF/classes and WEB-INF/lib.

**Q5: What is the difference between src/main/java and src/main/webapp in Maven?**
> **A:**
> - `src/main/java/`: Java source files (compiled to WEB-INF/classes)
> - `src/main/webapp/`: Web content (HTML, CSS, JSP, WEB-INF) - becomes WAR root
