# DbContext and DbSet in EF Core

## 📚 Introduction

`DbContext` is the primary class for interacting with the database. It manages entity objects, tracks changes, and persists data. `DbSet<T>` represents a collection of entities of a specific type in the database.

---

## 🎯 Learning Objectives

- Understand DbContext responsibilities
- Configure DbContext for different scenarios
- Use DbSet for querying and modifying data

---

## 📖 Theory: DbContext Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                   DbContext Architecture                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    DbContext                             │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │  DbSet<Author> Authors  ←→  Authors Table               │   │
│  │  DbSet<Book> Books      ←→  Books Table                 │   │
│  ├─────────────────────────────────────────────────────────┤   │
│  │  ChangeTracker          │  Tracks entity states         │   │
│  │  Database               │  Database operations          │   │
│  │  Model                  │  Entity metadata              │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              │                                  │
│                    ┌─────────┴─────────┐                       │
│                    │   Database        │                       │
│                    │   ┌─────────────┐ │                       │
│                    │   │ Authors     │ │                       │
│                    │   │ Books       │ │                       │
│                    │   └─────────────┘ │                       │
│                    └───────────────────┘                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Complete DbContext Example

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

// Entity Classes
public class Author
{
    [Key]                              // Primary key
    public int AuthorId { get; set; }
    
    [Required]                         // NOT NULL
    [MaxLength(100)]                   // VARCHAR(100)
    public string FirstName { get; set; }
    
    [Required]
    [MaxLength(100)]
    public string LastName { get; set; }
    
    [EmailAddress]
    public string Email { get; set; }
    
    // Navigation property: Author has many Books
    public virtual ICollection<Book> Books { get; set; } = new List<Book>();
}

public class Book
{
    [Key]
    public int BookId { get; set; }
    
    [Required]
    [MaxLength(200)]
    public string Title { get; set; }
    
    [Column(TypeName = "decimal(18,2)")]  // Explicit SQL type
    public decimal Price { get; set; }
    
    public DateTime PublishedDate { get; set; }
    
    // Foreign key
    public int AuthorId { get; set; }
    
    // Navigation property: Book belongs to Author
    [ForeignKey("AuthorId")]
    public virtual Author Author { get; set; }
}

// DbContext Definition
public class BookStoreContext : DbContext
{
    // DbSet properties - each represents a table
    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    
    // Constructor for dependency injection
    public BookStoreContext(DbContextOptions<BookStoreContext> options)
        : base(options)
    {
    }
    
    // Parameterless constructor for testing
    public BookStoreContext() { }
    
    // Configure database connection
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            optionsBuilder.UseSqlServer(
                "Server=.;Database=BookStore;Trusted_Connection=True;");
        }
    }
    
    // Configure entity relationships and constraints
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Fluent API configuration
        modelBuilder.Entity<Author>(entity =>
        {
            entity.HasKey(a => a.AuthorId);
            entity.Property(a => a.FirstName).IsRequired().HasMaxLength(100);
            entity.Property(a => a.LastName).IsRequired().HasMaxLength(100);
        });
        
        modelBuilder.Entity<Book>(entity =>
        {
            entity.HasKey(b => b.BookId);
            
            // One-to-Many relationship
            entity.HasOne(b => b.Author)
                  .WithMany(a => a.Books)
                  .HasForeignKey(b => b.AuthorId)
                  .OnDelete(DeleteBehavior.Cascade);
        });
        
        // Seed initial data
        modelBuilder.Entity<Author>().HasData(
            new Author { AuthorId = 1, FirstName = "John", LastName = "Doe", Email = "john@example.com" }
        );
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 11 | `[Key]` | Marks property as primary key |
| 14 | `[Required]` | Creates NOT NULL constraint |
| 15 | `[MaxLength(100)]` | Limits string length |
| 36 | `[Column(TypeName = "decimal(18,2)")]` | Explicit SQL type |
| 41 | `public int AuthorId` | Convention-based foreign key |
| 44 | `[ForeignKey("AuthorId")]` | Explicit FK annotation |
| 50 | `DbSet<Author> Authors` | Table mapping |
| 72 | `OnModelCreating` | Fluent API configuration |
| 84 | `HasOne...WithMany` | Relationship configuration |

---

## 💻 DbContext Usage Patterns

```csharp
class Program
{
    static void Main()
    {
        // Pattern 1: Using statement (recommended)
        using (var context = new BookStoreContext())
        {
            var authors = context.Authors.ToList();
        }
        
        // Pattern 2: Dependency Injection (in ASP.NET Core)
        // DbContext is injected by the framework
        
        // Pattern 3: Factory pattern
        var optionsBuilder = new DbContextOptionsBuilder<BookStoreContext>();
        optionsBuilder.UseSqlServer("connection_string");
        using var context2 = new BookStoreContext(optionsBuilder.Options);
    }
}
```

---

## 📊 DbContext Responsibilities

| Responsibility | Property/Method | Description |
|---------------|-----------------|-------------|
| **Query Data** | `Set<T>.Where()` | LINQ queries |
| **Track Changes** | `ChangeTracker` | Monitors entity modifications |
| **Save Changes** | `SaveChanges()` | Persists all tracked changes |
| **Configure Model** | `OnModelCreating()` | Entity configuration |
| **Manage Connection** | `Database` | Connection operations |
| **Add Entities** | `Add()`, `AddRange()` | Mark for insertion |
| **Remove Entities** | `Remove()` | Mark for deletion |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **DbContext** - Unit of work, manages entities
2. **DbSet<T>** - Represents table, queryable collection
3. **Use "using"** - Ensures proper disposal
4. **OnConfiguring** - Set connection string
5. **OnModelCreating** - Configure relationships with Fluent API
6. **Navigation properties** - Define relationships between entities

---

## 📝 Interview Questions

1. **What is DbContext?**
   - Main class for database interaction
   - Manages connections, change tracking, and queries

2. **DbSet vs DbContext?**
   - DbContext: Overall database access
   - DbSet: Specific table/entity access

3. **When is OnModelCreating called?**
   - Once when model is first created
   - Used to configure entities via Fluent API

---

## 🔗 Next Topic
Next: [40_EF_Core_CRUD_Operations.md](./40_EF_Core_CRUD_Operations.md) - CRUD Operations
