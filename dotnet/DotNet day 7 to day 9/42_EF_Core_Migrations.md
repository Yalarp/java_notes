# EF Core Migrations

## 📚 Introduction

Migrations allow you to incrementally update your database schema to keep it in sync with your entity model. Each migration represents a set of schema changes that can be applied or rolled back.

---

## 🎯 Learning Objectives

- Create and apply migrations
- Roll back migrations
- Understand migration files structure
- Use migrations in production

---

## 📖 Theory: Migration Workflow

```
┌────────────────────────────────────────────────────────────────┐
│                   Migration Workflow                            │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. MODIFY MODEL                                               │
│     ┌─────────────────────────────────────────────────────┐    │
│     │ public class Author                                  │    │
│     │ {                                                    │    │
│     │     public int AuthorId { get; set; }               │    │
│     │     public string Name { get; set; }                │    │
│     │     public string Email { get; set; }  // NEW!      │    │
│     │ }                                                    │    │
│     └─────────────────────────────────────────────────────┘    │
│                          ↓                                      │
│  2. CREATE MIGRATION                                           │
│     dotnet ef migrations add AddEmailToAuthor                  │
│                          ↓                                      │
│  3. MIGRATION FILE GENERATED                                   │
│     ┌─────────────────────────────────────────────────────┐    │
│     │ Migrations/                                          │    │
│     │   └── 20231228_AddEmailToAuthor.cs                  │    │
│     │       ├── Up()   → Add Email column                 │    │
│     │       └── Down() → Remove Email column              │    │
│     └─────────────────────────────────────────────────────┘    │
│                          ↓                                      │
│  4. APPLY MIGRATION                                            │
│     dotnet ef database update                                  │
│                          ↓                                      │
│  5. DATABASE UPDATED                                           │
│     ALTER TABLE Authors ADD Email NVARCHAR(MAX)                │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Migration Commands

### .NET CLI Commands

```powershell
# Install EF Core tools (if not installed)
dotnet tool install --global dotnet-ef

# Add a new migration
dotnet ef migrations add InitialCreate

# Add migration with output directory
dotnet ef migrations add InitialCreate -o Data/Migrations

# Apply pending migrations to database
dotnet ef database update

# Update to specific migration
dotnet ef database update InitialCreate

# Remove last unapplied migration
dotnet ef migrations remove

# Generate SQL script (for production)
dotnet ef migrations script

# Generate script from one migration to another
dotnet ef migrations script InitialCreate AddEmailColumn

# Generate idempotent script (safe to run multiple times)
dotnet ef migrations script --idempotent

# List all migrations
dotnet ef migrations list
```

### Package Manager Console (Visual Studio)

```powershell
# Add migration
Add-Migration InitialCreate

# Update database
Update-Database

# Remove migration
Remove-Migration

# Generate SQL script
Script-Migration
```

---

## 💻 Migration File Structure

```csharp
// Migrations/20231228120000_AddEmailToAuthor.cs
using Microsoft.EntityFrameworkCore.Migrations;

public partial class AddEmailToAuthor : Migration
{
    // Up() - Apply migration (forward)
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.AddColumn<string>(
            name: "Email",
            table: "Authors",
            type: "nvarchar(max)",
            nullable: true);
        
        // Other operations available:
        // migrationBuilder.CreateTable(...)
        // migrationBuilder.DropTable(...)
        // migrationBuilder.RenameColumn(...)
        // migrationBuilder.AlterColumn(...)
        // migrationBuilder.AddForeignKey(...)
        // migrationBuilder.CreateIndex(...)
        // migrationBuilder.Sql("raw SQL here")
    }
    
    // Down() - Rollback migration (reverse)
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropColumn(
            name: "Email",
            table: "Authors");
    }
}
```

---

## 💻 Common Migration Scenarios

### Scenario 1: Initial Database Creation

```csharp
// 1. Create your entities
public class Product
{
    public int ProductId { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
}

// 2. Create DbContext
public class AppDbContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlServer("your_connection_string");
}

// 3. Run in terminal:
// dotnet ef migrations add InitialCreate
// dotnet ef database update
```

### Scenario 2: Adding New Column

```csharp
// 1. Add property to entity
public class Product
{
    public int ProductId { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public int Quantity { get; set; }  // NEW
}

// 2. Create migration
// dotnet ef migrations add AddQuantityToProduct

// 3. Apply
// dotnet ef database update
```

### Scenario 3: Seeding Data in Migration

```csharp
protected override void Up(MigrationBuilder migrationBuilder)
{
    migrationBuilder.InsertData(
        table: "Products",
        columns: new[] { "Name", "Price", "Quantity" },
        values: new object[] { "Sample Product", 9.99m, 100 });
}

protected override void Down(MigrationBuilder migrationBuilder)
{
    migrationBuilder.DeleteData(
        table: "Products",
        keyColumn: "Name",
        keyValue: "Sample Product");
}
```

---

## 📊 Migration Best Practices

| Practice | Description |
|----------|-------------|
| **Descriptive names** | `AddEmailToUser`, not `Migration5` |
| **Review generated code** | Check `Up()` and `Down()` methods |
| **Test rollbacks** | Ensure `Down()` works correctly |
| **Use scripts in production** | Generate SQL, review, then execute |
| **Small, focused migrations** | One logical change per migration |
| **Back up before migrating** | Always in production |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Add-Migration** - Creates migration file from model changes
2. **Update-Database** - Applies pending migrations
3. **Up()** - Forward migration logic
4. **Down()** - Rollback logic
5. **Script-Migration** - Generate SQL for production
6. **__EFMigrationsHistory** - Table tracks applied migrations

---

## 📝 Interview Questions

1. **What are migrations in EF Core?**
   - Version control for database schema
   - Track changes incrementally in C# files

2. **How to apply migrations in production?**
   - Generate SQL script with `Script-Migration`
   - Review and execute script on production DB

3. **Can you roll back a migration?**
   - Yes, using `Update-Database MigrationName`
   - Or generate rollback script

---

## 🔗 Next Topic
Next: [43_EF_Core_Change_Tracker.md](./43_EF_Core_Change_Tracker.md) - Change Tracking
