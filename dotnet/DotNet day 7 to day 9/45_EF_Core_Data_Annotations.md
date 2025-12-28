# EF Core Data Annotations

## 📚 Introduction

Data Annotations are attributes applied to entity classes and properties to configure how they map to the database. They provide a simple, declarative way to define constraints, relationships, and column mappings.

---

## 🎯 Learning Objectives

- Use common data annotations for entity configuration
- Understand validation vs database configuration
- Know when to use annotations vs Fluent API

---

## 📖 Common Data Annotations

```
┌────────────────────────────────────────────────────────────────┐
│                 Data Annotation Categories                      │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  KEY CONFIG          COLUMN CONFIG        RELATIONSHIP         │
│  [Key]               [Column]             [ForeignKey]         │
│  [DatabaseGenerated] [MaxLength]          [InverseProperty]    │
│                      [Required]           [NotMapped]          │
│                      [StringLength]                            │
│                                                                 │
│  TABLE CONFIG        VALIDATION                                │
│  [Table]             [Required]                                │
│  [Index]             [Range]                                   │
│                      [EmailAddress]                            │
│                      [Phone]                                   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Complete Example with Annotations

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

// ===== ENTITY WITH ALL COMMON ANNOTATIONS =====
[Table("Authors", Schema = "dbo")]      // Table name and schema
[Index(nameof(Email), IsUnique = true)] // Unique index
public class Author
{
    [Key]                               // Primary key
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]  // Auto-increment
    public int AuthorId { get; set; }
    
    [Required]                          // NOT NULL
    [MaxLength(100)]                    // VARCHAR(100)
    [Column("FirstName", TypeName = "varchar(100)")] // Column customization
    public string FirstName { get; set; }
    
    [Required]
    [StringLength(100, MinimumLength = 2)]  // Validation + DB config
    public string LastName { get; set; }
    
    [EmailAddress]                      // Validation only (not DB constraint)
    [MaxLength(255)]
    public string Email { get; set; }
    
    [Phone]                             // Validation only
    public string PhoneNumber { get; set; }
    
    [Range(0, 150)]                     // Validation: age between 0-150
    public int? Age { get; set; }
    
    [Column(TypeName = "decimal(18,2)")] // Explicit SQL type
    public decimal Royalties { get; set; }
    
    [DataType(DataType.Date)]           // Display format hint
    public DateTime BirthDate { get; set; }
    
    [Timestamp]                         // Row version for concurrency
    public byte[] RowVersion { get; set; }
    
    [NotMapped]                         // Not in database
    public string FullName => $"{FirstName} {LastName}";
    
    // Navigation property
    public virtual ICollection<Book> Books { get; set; }
}

public class Book
{
    [Key]
    public int BookId { get; set; }
    
    [Required]
    [MaxLength(200)]
    public string Title { get; set; }
    
    [Column(TypeName = "decimal(10,2)")]
    [Range(0.01, 9999.99)]
    public decimal Price { get; set; }
    
    [ForeignKey("Author")]              // Explicit foreign key
    public int AuthorId { get; set; }
    
    [InverseProperty("Books")]          // Specifies which navigation property
    public virtual Author Author { get; set; }
}
```

---

## 📊 Annotation Reference Table

| Annotation | Namespace | Purpose | DB Effect |
|------------|-----------|---------|-----------|
| `[Key]` | DataAnnotations | Primary key | PRIMARY KEY |
| `[Required]` | DataAnnotations | NOT NULL | NOT NULL |
| `[MaxLength(n)]` | DataAnnotations | Max string length | VARCHAR(n) |
| `[StringLength(max, min)]` | DataAnnotations | String length range | VARCHAR(max) |
| `[Column("name")]` | DataAnnotations.Schema | Column name/type | Column definition |
| `[Table("name")]` | DataAnnotations.Schema | Table name | Table name |
| `[ForeignKey("prop")]` | DataAnnotations.Schema | Foreign key | FK constraint |
| `[NotMapped]` | DataAnnotations.Schema | Exclude property | Not in DB |
| `[DatabaseGenerated]` | DataAnnotations.Schema | Value generation | IDENTITY |
| `[Index]` | EntityFrameworkCore | Create index | INDEX |
| `[Timestamp]` | DataAnnotations | Concurrency token | ROWVERSION |

---

## 💻 Key Annotations Explained

### [Key] - Primary Key

```csharp
public class Order
{
    [Key]
    public int OrderId { get; set; }  // Primary key
    
    // Composite key (use Fluent API instead)
    // [Key]
    // public int OrderId { get; set; }
    // [Key]
    // public int ProductId { get; set; }
}
```

### [Required] and [MaxLength]

```csharp
public class Product
{
    [Required(ErrorMessage = "Name is required")]
    [MaxLength(100, ErrorMessage = "Name too long")]
    public string Name { get; set; }
    
    // Generates: Name VARCHAR(100) NOT NULL
}
```

### [Column] - Column Customization

```csharp
public class Employee
{
    [Column("emp_name", TypeName = "nvarchar(50)", Order = 1)]
    public string Name { get; set; }
    
    [Column(TypeName = "decimal(18,4)")]
    public decimal Salary { get; set; }
}
```

### [NotMapped] - Exclude from Database

```csharp
public class Person
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    
    [NotMapped]  // Calculated, not stored
    public string FullName => $"{FirstName} {LastName}";
    
    [NotMapped]  // Used only in app logic
    public int TempValue { get; set; }
}
```

### [DatabaseGenerated] Options

```csharp
public class Entity
{
    // Auto-increment (default for int PK)
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public int Id { get; set; }
    
    // Computed by database
    [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
    public DateTime LastModified { get; set; }
    
    // Never generated (you provide value)
    [DatabaseGenerated(DatabaseGeneratedOption.None)]
    public Guid CustomId { get; set; }
}
```

---

## 📊 Annotations vs Fluent API

| Aspect | Data Annotations | Fluent API |
|--------|------------------|------------|
| **Location** | On entity class | In DbContext |
| **Readability** | With class | Separate |
| **Complexity** | Simple configs | Complex relationships |
| **Composite keys** | Not supported | Supported |
| **All options** | Limited | Full access |

```csharp
// Annotation approach
[Required]
[MaxLength(100)]
public string Name { get; set; }

// Fluent API equivalent
modelBuilder.Entity<Author>()
    .Property(a => a.Name)
    .IsRequired()
    .HasMaxLength(100);
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **[Key]** - Marks primary key
2. **[Required]** - NOT NULL constraint
3. **[MaxLength]** - String column size
4. **[Column]** - Custom column name/type
5. **[NotMapped]** - Exclude from database
6. **[ForeignKey]** - Define FK relationship

---

## 📝 Interview Questions

1. **Difference between [MaxLength] and [StringLength]?**
   - Both set max length
   - StringLength also has MinimumLength
   - StringLength is primarily for validation

2. **When to use Fluent API over annotations?**
   - Composite primary keys
   - Complex configurations
   - Keep entities clean of EF dependencies

---

## 🔗 Next Topic
Next: [46_EF_Core_DI_Integration.md](./46_EF_Core_DI_Integration.md) - Dependency Injection Integration
