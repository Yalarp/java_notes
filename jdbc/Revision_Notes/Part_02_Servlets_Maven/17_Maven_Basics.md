# Maven Build Tool

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is Maven](#what-is-maven)
3. [Why Maven](#why-maven)
4. [pom.xml Structure](#pomxml-structure)
5. [Dependencies](#dependencies)
6. [Maven Repositories](#maven-repositories)
7. [Build Lifecycle](#build-lifecycle)
8. [Code Examples](#code-examples)
9. [Key Takeaways](#key-takeaways)
10. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Maven** is a powerful build automation and dependency management tool for Java projects. It standardizes project structure, handles dependency downloads, and automates builds.

---

## 📖 What is Maven

### Maven = Build Tool + Dependency Manager

| Feature | Description |
|---------|-------------|
| **Build Automation** | Compile, test, package automatically |
| **Dependency Management** | Download and manage JARs |
| **Standard Structure** | Consistent project layout |
| **Plugin Architecture** | Extensible with plugins |
| **Project Lifecycle** | Defined phases (compile, test, package) |

### Maven vs Manual Approach

| Manual | Maven |
|--------|-------|
| Download JARs manually | Specify in pom.xml, auto-download |
| Manage classpaths yourself | Maven handles classpaths |
| Custom build scripts | Standardized build lifecycle |
| Copy JARs to each project | Central/local repository |

---

## 📖 Why Maven

### Problems Maven Solves

1. **JAR Hell**: Managing dozens of dependencies manually
2. **Version Conflicts**: Ensuring compatible versions
3. **Transitive Dependencies**: Libraries that libraries need
4. **Build Consistency**: Same build on all machines
5. **Project Portability**: Clone and build immediately

### Example: Without Maven

```
1. Go to MySQL website
2. Download mysql-connector-java-8.0.17.jar
3. Copy to project lib folder
4. Add to classpath
5. Repeat for every dependency...
6. Hope versions are compatible...
```

### With Maven

```xml
<!-- Just add this to pom.xml -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>
<!-- Maven downloads it automatically! -->
```

---

## 📖 pom.xml Structure

### POM = Project Object Model

The `pom.xml` is the heart of a Maven project.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    <modelVersion>4.0.0</modelVersion>
    
    <!-- Project Coordinates (GAV) -->
    <groupId>com.example</groupId>
    <artifactId>my-web-app</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    
    <!-- Project Info -->
    <name>My Web Application</name>
    
    <!-- Properties -->
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
    
    <!-- Dependencies -->
    <dependencies>
        <!-- Servlet API -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- MySQL Connector -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.33</version>
        </dependency>
    </dependencies>
    
</project>
```

### GAV Coordinates

Every Maven artifact is identified by **GAV**:

| Element | Description | Example |
|---------|-------------|---------|
| **G**roupId | Organization/company | `com.mysql` |
| **A**rtifactId | Project name | `mysql-connector-j` |
| **V**ersion | Version number | `8.0.33` |

---

## 📖 Dependencies

### Dependency Declaration

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>
```

### Dependency Scopes

| Scope | Compile | Test | Runtime | Package |
|-------|---------|------|---------|---------|
| `compile` (default) | ✅ | ✅ | ✅ | ✅ |
| `provided` | ✅ | ✅ | ❌ | ❌ |
| `runtime` | ❌ | ✅ | ✅ | ✅ |
| `test` | ❌ | ✅ | ❌ | ❌ |

**Common Uses:**
- `compile`: Regular dependencies
- `provided`: Servlet API (container provides it)
- `runtime`: JDBC drivers (not needed at compile)
- `test`: JUnit, Mockito

### Transitive Dependencies

If A depends on B, and B depends on C, Maven automatically downloads C.

```
Your Project
    └── mysql-connector-j
            └── protobuf-java (transitive - auto-downloaded!)
```

---

## 📖 Maven Repositories

### Repository Types

```
┌──────────────────────────────────────────────────────────────┐
│                    Maven Central Repository                   │
│                  (https://repo.maven.apache.org)              │
│                     [Remote - Internet]                       │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼ Download once
┌──────────────────────────────────────────────────────────────┐
│                    Local Repository                           │
│                   (~/.m2/repository/)                         │
│                     [Local Cache]                             │
└────────────────────────────┬─────────────────────────────────┘
                             │
                             ▼ Used by
┌──────────────────────────────────────────────────────────────┐
│                    Your Project                               │
└──────────────────────────────────────────────────────────────┘
```

### How It Works

1. Project needs `mysql-connector-j`
2. Maven checks **local repository** (`~/.m2/repository/`)
3. If not found, downloads from **Maven Central**
4. Stores in local repository for future use
5. Never downloads same JAR twice

---

## 📖 Build Lifecycle

### Default Lifecycle Phases

```
validate → compile → test → package → verify → install → deploy
    │         │        │        │         │        │         │
    │         │        │        │         │        │         └── Deploy to remote repo
    │         │        │        │         │        └── Install to local repo
    │         │        │        │         └── Run integration tests
    │         │        │        └── Create JAR/WAR
    │         │        └── Run unit tests
    │         └── Compile source code
    └── Validate project structure
```

### Common Commands

| Command | Description |
|---------|-------------|
| `mvn compile` | Compile source code |
| `mvn test` | Run unit tests |
| `mvn package` | Create JAR/WAR |
| `mvn install` | Install to local repo |
| `mvn clean` | Delete target folder |
| `mvn clean package` | Clean then package |

---

## 💻 Code Examples

### Standard Maven Project Structure

```
my-web-app/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/
│   │   │       └── PersonServ.java
│   │   ├── resources/
│   │   │   └── myproperty.properties
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml
│   │       └── index.html
│   └── test/
│       └── java/
│           └── com/example/
│               └── PersonServTest.java
└── target/                    ← Generated by Maven
    └── my-web-app-1.0.war
```

### Complete pom.xml for Web App

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>my-web-app</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>war</packaging>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <!-- Jakarta Servlet API -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- MySQL JDBC Driver -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.33</version>
        </dependency>
        
        <!-- JUnit for Testing -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
            </plugin>
        </plugins>
    </build>
    
</project>
```

---

## ✅ Key Takeaways

1. **Maven** = Build tool + Dependency manager
2. **pom.xml** = Project Object Model (configuration file)
3. **GAV** = GroupId, ArtifactId, Version (unique identifier)
4. **Local repo** = `~/.m2/repository/` (cached JARs)
5. **Scopes**: compile, provided, runtime, test
6. **Transitive dependencies** = automatically downloaded
7. **Standard structure** = consistent project layout

---

## 🎤 Interview Questions

**Q1: What is Maven and why use it?**
> **A:** Maven is a build automation and dependency management tool. It standardizes project structure, automatically downloads dependencies, handles transitive dependencies, and provides a consistent build lifecycle across projects.

**Q2: What is pom.xml?**
> **A:** POM (Project Object Model) is Maven's configuration file. It contains project information, dependencies, plugins, and build configuration. Every Maven project has a pom.xml at its root.

**Q3: What is the difference between compile and provided scope?**
> **A:** 
> - **compile**: Default scope - included in compilation and final package
> - **provided**: Available at compile time but NOT packaged (container provides it, e.g., Servlet API)

**Q4: Where does Maven store downloaded dependencies?**
> **A:** In the local repository at `~/.m2/repository/`. This acts as a cache - dependencies are downloaded once from Maven Central and reused for all projects.

**Q5: What are transitive dependencies?**
> **A:** Dependencies of your dependencies. If your project depends on A, and A depends on B, Maven automatically downloads B as a transitive dependency.
