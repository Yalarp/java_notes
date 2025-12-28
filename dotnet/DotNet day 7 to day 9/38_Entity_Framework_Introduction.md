# Entity Framework Core Introduction

## 📚 Introduction

Entity Framework Core (EF Core) is Microsoft's modern Object-Relational Mapper (ORM) for .NET. It allows developers to work with databases using C# objects instead of raw SQL, dramatically improving productivity and maintainability.

---

## 🎯 Learning Objectives

- Understand ORM concepts and benefits
- Know the difference between Code First and Database First
- Set up EF Core in a .NET project

---

## 📖 Theory: What is an ORM?

```
┌────────────────────────────────────────────────────────────────┐
│                 ORM - Object Relational Mapper                  │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Without ORM:                                                  │
│  ────────────                                                   │
│  C# Code                              SQL Database             │
│  ┌─────────────────────┐              ┌─────────────────────┐  │
│  │ SqlCommand cmd      │  ──SQL──→    │ SELECT * FROM       │  │
│  │ cmd.ExecuteReader() │              │ Users WHERE         │  │
│  │ while(rdr.Read())   │  ←rows──     │ Age > 18            │  │
│  │ {                   │              └─────────────────────┘  │
│  │   // Manual mapping │                                       │
│  │ }                   │                                       │
│  └─────────────────────┘                                       │
│                                                                 │
│  With ORM (EF Core):                                           │
│  ───────────────────                                            │
│  C# Objects                           Database                 │
│  ┌─────────────────────┐              ┌─────────────────────┐  │
│  │ var adults =        │              │ Users Table         │  │
│  │   context.Users     │ ←─EF Core──→ │ ┌───┬──────┬─────┐ │  │
│  │   .Where(u =>       │   mapping    │ │Id │ Name │ Age │ │  │
│  │      u.Age > 18)    │              │ └───┴──────┴─────┘ │  │
│  │   .ToList();        │              └─────────────────────┘  │
│  └─────────────────────┘                                       │
│                                                                 │
│  EF Core handles:                                              │
│  • SQL generation                                              │
│  • Connection management                                        │
│  • Object mapping                                              │
│  • Change tracking                                             │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 EF Core Benefits

| Benefit | Description |
|---------|-------------|
| **Productivity** | Write C# instead of SQL |
| **Type Safety** | Compile-time checking with LINQ |
| **Maintainability** | Strongly-typed queries |
| **Cross-Platform** | Works on Windows, Linux, Mac |
| **Database Agnostic** | Switch providers easily |
| **Change Tracking** | Automatically tracks modifications |
| **Migrations** | Version control for database schema |

---

## 📖 Two Development Approaches

```
┌────────────────────────────────────────────────────────────────┐
│                  EF Core Approaches                             │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CODE FIRST                        DATABASE FIRST              │
│  ──────────                        ──────────────              │
│                                                                 │
│  1. Define C# classes              1. Have existing database   │
│  2. Add DbContext                  2. Run scaffold command     │
│  3. Create migrations              3. EF generates classes     │
│  4. Update database                4. Start coding             │
│                                                                 │
│  class User                        dotnet ef dbcontext         │
│  {                                   scaffold "connStr"        │
│      public int Id;                  SqlServer                 │
│      public string Name;                                       │
│  }                                 → Generates User.cs,        │
│       ↓                              DbContext.cs              │
│  Add-Migration Initial                                         │
│       ↓                                                        │
│  Creates Users table                                           │
│                                                                 │
│  ✅ Best for:                       ✅ Best for:               │
│  • New projects                     • Legacy databases         │
│  • Agile development               • DBA-designed schemas      │
│  • Full control                    • Quick start               │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Setting Up EF Core

### Step 1: Install NuGet Packages

```xml
<!-- In .csproj -->
<ItemGroup>
    <PackageReference Include="Microsoft.EntityFrameworkCore" Version="7.0.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="7.0.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="7.0.0" />
</ItemGroup>
```

Or via Package Manager:
```
Install-Package Microsoft.EntityFrameworkCore
Install-Package Microsoft.EntityFrameworkCore.SqlServer
Install-Package Microsoft.EntityFrameworkCore.Tools
```

### Step 2: Create Entity Classes

```csharp
// Models/Author.cs
public class Author
{
    public int AuthorId { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    
    // Navigation property
    public ICollection<Book> Books { get; set; }
}

// Models/Book.cs
public class Book
{
    public int BookId { get; set; }
    public string Title { get; set; }
    public decimal Price { get; set; }
    
    // Foreign key
    public int AuthorId { get; set; }
    
    // Navigation property
    public Author Author { get; set; }
}
```

### Step 3: Create DbContext

```csharp
// Data/BookStoreContext.cs
using Microsoft.EntityFrameworkCore;

public class BookStoreContext : DbContext
{
    // DbSet for each entity
    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    
    // Configure database connection
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer(
            "Server=.;Database=BookStore;Trusted_Connection=True;");
    }
}
```

### Step 4: Run Migrations

```powershell
# Create initial migration
dotnet ef migrations add InitialCreate

# Apply migration to database
dotnet ef database update
```

---

## 📊 Database Providers

| Provider | Package | Database |
|----------|---------|----------|
| SQL Server | `Microsoft.EntityFrameworkCore.SqlServer` | SQL Server, Azure SQL |
| SQLite | `Microsoft.EntityFrameworkCore.Sqlite` | SQLite |
| MySQL | `Pomelo.EntityFrameworkCore.MySql` | MySQL, MariaDB |
| PostgreSQL | `Npgsql.EntityFrameworkCore.PostgreSQL` | PostgreSQL |
| In-Memory | `Microsoft.EntityFrameworkCore.InMemory` | Testing |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **ORM** - Object Relational Mapper bridges C# and databases
2. **Code First** - Define classes, generate database
3. **Database First** - Existing database, generate classes
4. **DbContext** - Main class for database operations
5. **DbSet<T>** - Represents a table/collection
6. **Migrations** - Version control for schema changes

---

## 📝 Interview Questions

1. **What is EF Core?**
   - Microsoft's ORM for .NET
   - Maps C# objects to database tables
   - Generates SQL from LINQ queries

2. **Code First vs Database First?**
   - Code First: Define classes first, generate database
   - Database First: Scaffold classes from existing database

3. **Benefits of EF Core over ADO.NET?**
   - Less boilerplate code
   - Type safety with LINQ
   - Automatic change tracking
   - Database migrations

---

## 🔗 Next Topic
Next: [39_DbContext_DbSet.md](./39_DbContext_DbSet.md) - DbContext and DbSet
