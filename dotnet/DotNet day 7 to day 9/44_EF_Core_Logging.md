# EF Core Logging and Diagnostics

## 📚 Introduction

EF Core provides built-in logging to help you understand what SQL is being generated and executed. This is essential for debugging, performance tuning, and understanding EF Core behavior.

---

## 🎯 Learning Objectives

- Enable SQL query logging in EF Core
- Configure different logging levels
- Use logging for debugging and optimization
- Integrate with ASP.NET Core logging

---

## 📖 Logging Options Overview

```
┌────────────────────────────────────────────────────────────────┐
│                  EF Core Logging Options                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Simple Logging (Quick & Easy)                              │
│     optionsBuilder.LogTo(Console.WriteLine)                    │
│                                                                 │
│  2. Microsoft.Extensions.Logging (ASP.NET Core)                │
│     Integrated with ILogger<T>                                 │
│                                                                 │
│  3. EnableSensitiveDataLogging                                 │
│     Shows parameter values (dev only!)                         │
│                                                                 │
│  4. EnableDetailedErrors                                        │
│     More exception details                                     │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Simple Logging (Console)

```csharp
using System;
using Microsoft.EntityFrameworkCore;

public class BookStoreContext : DbContext
{
    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder
            .UseSqlServer("your_connection_string")
            
            // Log to Console
            .LogTo(Console.WriteLine)
            
            // Or log to Debug window
            // .LogTo(message => Debug.WriteLine(message))
            
            // Filter by log level
            .LogTo(Console.WriteLine, LogLevel.Information)
            
            // Filter by specific categories
            .LogTo(Console.WriteLine, new[] { DbLoggerCategory.Database.Command.Name })
            
            // Show parameter values (ONLY in development!)
            .EnableSensitiveDataLogging()
            
            // Show more detailed errors
            .EnableDetailedErrors();
    }
}
```

### Sample Output:

```
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (15ms) [Parameters=[@p0='1'], CommandType='Text', CommandTimeout='30']
      SELECT [a].[AuthorId], [a].[Email], [a].[FirstName], [a].[LastName]
      FROM [Authors] AS [a]
      WHERE [a].[AuthorId] = @p0

info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (3ms) [Parameters=[@p0='John' (Size = 100)], CommandType='Text', CommandTimeout='30']
      INSERT INTO [Authors] ([FirstName], [LastName])
      VALUES (@p0, @p1);
      SELECT [AuthorId]
      FROM [Authors]
      WHERE @@ROWCOUNT = 1 AND [AuthorId] = scope_identity();
```

---

## 💻 Using ILoggerFactory (Dependency Injection)

```csharp
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

// Create a custom logger factory
public class BookStoreContext : DbContext
{
    public static readonly ILoggerFactory MyLoggerFactory = 
        LoggerFactory.Create(builder =>
        {
            builder
                .AddFilter((category, level) =>
                    category == DbLoggerCategory.Database.Command.Name
                    && level == LogLevel.Information)
                .AddConsole();
        });
    
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder
            .UseSqlServer("your_connection_string")
            .UseLoggerFactory(MyLoggerFactory);
    }
}
```

---

## 💻 ASP.NET Core Integration

```csharp
// Program.cs or Startup.cs
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add DbContext with logging configuration
builder.Services.AddDbContext<BookStoreContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("Default"));
    
    // In development, enable detailed logging
    if (builder.Environment.IsDevelopment())
    {
        options.EnableSensitiveDataLogging();
        options.EnableDetailedErrors();
    }
});

// Configure logging in appsettings.Development.json
/*
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.EntityFrameworkCore.Database.Command": "Information"
    }
  }
}
*/
```

---

## 💻 Custom Log Formatting

```csharp
public class BookStoreContext : DbContext
{
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder
            .UseSqlServer("your_connection_string")
            .LogTo(
                action: message => LogToFile(message),
                categories: new[] { DbLoggerCategory.Database.Command.Name },
                minimumLevel: LogLevel.Information,
                options: DbContextLoggerOptions.SingleLine | 
                         DbContextLoggerOptions.UtcTime);
    }
    
    private void LogToFile(string message)
    {
        var logPath = "ef_queries.log";
        File.AppendAllText(logPath, $"{DateTime.UtcNow}: {message}\n");
    }
}
```

---

## 📊 Log Categories

| Category | What it Logs |
|----------|-------------|
| `Database.Command` | SQL commands |
| `Database.Connection` | Connection open/close |
| `Database.Transaction` | Transaction operations |
| `Query` | Query compilation |
| `Model` | Model building |
| `Update` | SaveChanges operations |
| `ChangeTracking` | Entity state changes |

```csharp
// Filter to specific categories
.LogTo(
    Console.WriteLine,
    new[] {
        DbLoggerCategory.Database.Command.Name,
        DbLoggerCategory.Database.Transaction.Name
    })
```

---

## ⚠️ Security Considerations

```
┌────────────────────────────────────────────────────────────────┐
│                Security Warning                                 │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  EnableSensitiveDataLogging() exposes:                         │
│  • Parameter values (passwords, personal data)                 │
│  • Connection strings                                          │
│  • Entity property values                                      │
│                                                                 │
│  ⚠️  NEVER use in production!                                  │
│                                                                 │
│  if (env.IsDevelopment())                                      │
│  {                                                              │
│      options.EnableSensitiveDataLogging();                     │
│  }                                                              │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **LogTo(Console.WriteLine)** - Quick logging setup
2. **EnableSensitiveDataLogging** - Shows parameter values (dev only)
3. **Filter by category** - Focus on specific operations
4. **ILoggerFactory** - For DI integration
5. **DbLoggerCategory** - Predefined categories
6. **Never log sensitive data in production!**

---

## 📝 Interview Questions

1. **How do you see the SQL generated by EF Core?**
   - Use `LogTo()` or `UseLoggerFactory()`
   - Configure logging level to Information

2. **What does EnableSensitiveDataLogging do?**
   - Shows actual parameter values in logs
   - Should only be used in development

---

## 🔗 Next Topic
Next: [45_EF_Core_Data_Annotations.md](./45_EF_Core_Data_Annotations.md) - Data Annotations
