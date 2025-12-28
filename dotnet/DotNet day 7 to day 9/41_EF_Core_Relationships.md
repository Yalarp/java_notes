# EF Core Entity Relationships

## 📚 Introduction

Entity Framework Core supports three types of relationships: One-to-Many, One-to-One, and Many-to-Many. These are configured through navigation properties and can be customized using Data Annotations or Fluent API.

---

## 🎯 Learning Objectives

- Configure One-to-Many relationships
- Implement One-to-One relationships
- Set up Many-to-Many relationships (EF Core 5+)
- Understand cascade delete options

---

## 📖 Theory: Relationship Types

```
┌────────────────────────────────────────────────────────────────┐
│                  EF Core Relationship Types                     │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ONE-TO-MANY (Most common)                                     │
│  ─────────────────────────                                      │
│  Author (1) ←────────→ (*) Books                               │
│  One author has many books                                     │
│  Each book has one author                                      │
│                                                                 │
│  ONE-TO-ONE                                                     │
│  ──────────                                                     │
│  Employee (1) ←────────→ (1) Address                           │
│  One employee has one address                                  │
│  One address belongs to one employee                           │
│                                                                 │
│  MANY-TO-MANY                                                   │
│  ────────────                                                   │
│  Student (*) ←────────→ (*) Course                             │
│  Students can enroll in many courses                           │
│  Courses can have many students                                │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 One-to-Many Relationship

```csharp
// Entity Classes
public class Author
{
    public int AuthorId { get; set; }
    public string Name { get; set; }
    
    // Navigation property: Collection for "many" side
    public ICollection<Book> Books { get; set; } = new List<Book>();
}

public class Book
{
    public int BookId { get; set; }
    public string Title { get; set; }
    public decimal Price { get; set; }
    
    // Foreign key property
    public int AuthorId { get; set; }
    
    // Navigation property: Reference for "one" side
    public Author Author { get; set; }
}

// DbContext configuration
public class BookStoreContext : DbContext
{
    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Fluent API configuration (optional - conventions work too)
        modelBuilder.Entity<Book>()
            .HasOne(b => b.Author)           // Book has one Author
            .WithMany(a => a.Books)          // Author has many Books
            .HasForeignKey(b => b.AuthorId)  // FK property
            .OnDelete(DeleteBehavior.Cascade); // Delete books when author deleted
    }
}

// Usage
using (var context = new BookStoreContext())
{
    // Create author with books
    var author = new Author
    {
        Name = "John Doe",
        Books = new List<Book>
        {
            new Book { Title = "C# Basics", Price = 29.99m },
            new Book { Title = "Advanced C#", Price = 49.99m }
        }
    };
    
    context.Authors.Add(author);
    context.SaveChanges();
    
    // Query with include
    var authorWithBooks = context.Authors
        .Include(a => a.Books)
        .FirstOrDefault(a => a.Name == "John Doe");
}
```

---

## 💻 One-to-One Relationship

```csharp
// Entity Classes
public class Employee
{
    public int EmployeeId { get; set; }
    public string Name { get; set; }
    
    // Navigation property
    public EmployeeAddress Address { get; set; }
}

public class EmployeeAddress
{
    public int EmployeeAddressId { get; set; }
    public string Street { get; set; }
    public string City { get; set; }
    public string ZipCode { get; set; }
    
    // Foreign key (same as principal's PK for 1:1)
    public int EmployeeId { get; set; }
    
    // Navigation property back
    public Employee Employee { get; set; }
}

// DbContext configuration
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Employee>()
        .HasOne(e => e.Address)          // Employee has one Address
        .WithOne(a => a.Employee)        // Address has one Employee
        .HasForeignKey<EmployeeAddress>(a => a.EmployeeId);
}

// Usage
var employee = new Employee
{
    Name = "Jane Smith",
    Address = new EmployeeAddress
    {
        Street = "123 Main St",
        City = "New York",
        ZipCode = "10001"
    }
};

context.Employees.Add(employee);
context.SaveChanges();

// Query
var emp = context.Employees
    .Include(e => e.Address)
    .FirstOrDefault();
```

---

## 💻 Many-to-Many Relationship (EF Core 5+)

```csharp
// Entity Classes - Simple (EF Core 5+)
public class Student
{
    public int StudentId { get; set; }
    public string Name { get; set; }
    
    // Navigation property
    public ICollection<Course> Courses { get; set; } = new List<Course>();
}

public class Course
{
    public int CourseId { get; set; }
    public string Title { get; set; }
    
    // Navigation property
    public ICollection<Student> Students { get; set; } = new List<Student>();
}

// EF Core automatically creates junction table!

// DbContext
public class SchoolContext : DbContext
{
    public DbSet<Student> Students { get; set; }
    public DbSet<Course> Courses { get; set; }
    
    // No configuration needed for basic M:M in EF Core 5+
}

// Usage
var student = new Student { Name = "Alice" };
var course1 = new Course { Title = "Math" };
var course2 = new Course { Title = "Science" };

student.Courses.Add(course1);
student.Courses.Add(course2);

context.Students.Add(student);
context.SaveChanges();

// Query
var studentsWithCourses = context.Students
    .Include(s => s.Courses)
    .ToList();
```

### Many-to-Many with Join Entity (for additional data):

```csharp
// When you need extra data on the relationship
public class Student
{
    public int StudentId { get; set; }
    public string Name { get; set; }
    public ICollection<Enrollment> Enrollments { get; set; }
}

public class Course
{
    public int CourseId { get; set; }
    public string Title { get; set; }
    public ICollection<Enrollment> Enrollments { get; set; }
}

// Join entity with additional properties
public class Enrollment
{
    public int StudentId { get; set; }
    public Student Student { get; set; }
    
    public int CourseId { get; set; }
    public Course Course { get; set; }
    
    // Additional properties
    public DateTime EnrollmentDate { get; set; }
    public string Grade { get; set; }
}

// Configuration
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Enrollment>()
        .HasKey(e => new { e.StudentId, e.CourseId });  // Composite key
    
    modelBuilder.Entity<Enrollment>()
        .HasOne(e => e.Student)
        .WithMany(s => s.Enrollments)
        .HasForeignKey(e => e.StudentId);
    
    modelBuilder.Entity<Enrollment>()
        .HasOne(e => e.Course)
        .WithMany(c => c.Enrollments)
        .HasForeignKey(e => e.CourseId);
}
```

---

## 📊 Cascade Delete Options

| Option | Description |
|--------|-------------|
| **Cascade** | Delete dependents when principal deleted |
| **Restrict** | Prevent deletion if dependents exist |
| **SetNull** | Set FK to null (requires nullable FK) |
| **ClientSetNull** | Set null only for tracked entities |
| **NoAction** | No automatic action (database decides) |

```csharp
// Configuration example
modelBuilder.Entity<Book>()
    .HasOne(b => b.Author)
    .WithMany(a => a.Books)
    .OnDelete(DeleteBehavior.Cascade);  // or Restrict, SetNull, etc.
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **One-to-Many** - Collection on one side, single reference on other
2. **One-to-One** - Single reference on both sides
3. **Many-to-Many** - Collections on both sides
4. **Include()** - Eager load related data
5. **Cascade Delete** - Configure deletion behavior
6. **Navigation properties** - Required for relationships

---

## 📝 Interview Questions

1. **How does EF Core detect relationships?**
   - By conventions: navigation properties and FK naming
   - By Fluent API or Data Annotations

2. **What's eager vs lazy loading?**
   - Eager: Load related data with Include()
   - Lazy: Load on navigation property access (requires proxy)

---

## 🔗 Next Topic
Next: [42_EF_Core_Migrations.md](./42_EF_Core_Migrations.md) - Database Migrations
