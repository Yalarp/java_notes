# EF Core Dependency Injection Integration

## 📚 Introduction

EF Core is designed to work seamlessly with .NET's built-in Dependency Injection (DI) system. This enables proper lifetime management, testability, and loose coupling in your applications.

---

## 🎯 Learning Objectives

- Register DbContext with DI container
- Understand DbContext lifetime (Scoped)
- Implement Repository pattern with DI
- Use DbContext in controllers and services

---

## 📖 Theory: DbContext Lifetime

```
┌────────────────────────────────────────────────────────────────┐
│                DbContext Lifetime in DI                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SCOPED (Default, Recommended)                                 │
│  ─────────────────────────────                                  │
│                                                                 │
│  HTTP Request 1              HTTP Request 2                    │
│  ┌──────────────────┐        ┌──────────────────┐              │
│  │   DbContext A    │        │   DbContext B    │              │
│  │  (new instance)  │        │  (new instance)  │              │
│  │                  │        │                  │              │
│  │  Controller      │        │  Controller      │              │
│  │  Service1        │ shared │  Service1        │ shared       │
│  │  Service2        │        │  Service2        │              │
│  └──────────────────┘        └──────────────────┘              │
│        ↓                           ↓                           │
│   Disposed at                 Disposed at                      │
│   request end                 request end                      │
│                                                                 │
│  ✅ Thread-safe (one per request)                              │
│  ✅ Automatic disposal                                         │
│  ✅ Change tracking works within request                       │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Registering DbContext

### Basic Registration

```csharp
// Program.cs (.NET 6+)
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Register DbContext with SQL Server
builder.Services.AddDbContext<BookStoreContext>(options =>
{
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"));
});

var app = builder.Build();
```

### With Options Configuration

```csharp
builder.Services.AddDbContext<BookStoreContext>(options =>
{
    var connectionString = builder.Configuration.GetConnectionString("Default");
    
    options.UseSqlServer(connectionString, sqlOptions =>
    {
        sqlOptions.EnableRetryOnFailure(
            maxRetryCount: 3,
            maxRetryDelay: TimeSpan.FromSeconds(30),
            errorNumbersToAdd: null);
        
        sqlOptions.CommandTimeout(60);
    });
    
    // Development-only options
    if (builder.Environment.IsDevelopment())
    {
        options.EnableSensitiveDataLogging();
        options.EnableDetailedErrors();
        options.LogTo(Console.WriteLine, LogLevel.Information);
    }
});
```

### Connection String in appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=BookStore;Trusted_Connection=True;TrustServerCertificate=True"
  }
}
```

---

## 💻 Using DbContext in Controllers

```csharp
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[ApiController]
[Route("api/[controller]")]
public class AuthorsController : ControllerBase
{
    private readonly BookStoreContext _context;
    
    // Constructor injection
    public AuthorsController(BookStoreContext context)
    {
        _context = context;
    }
    
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Author>>> GetAuthors()
    {
        return await _context.Authors.ToListAsync();
    }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<Author>> GetAuthor(int id)
    {
        var author = await _context.Authors.FindAsync(id);
        
        if (author == null)
            return NotFound();
        
        return author;
    }
    
    [HttpPost]
    public async Task<ActionResult<Author>> CreateAuthor(Author author)
    {
        _context.Authors.Add(author);
        await _context.SaveChangesAsync();
        
        return CreatedAtAction(nameof(GetAuthor), new { id = author.AuthorId }, author);
    }
    
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateAuthor(int id, Author author)
    {
        if (id != author.AuthorId)
            return BadRequest();
        
        _context.Entry(author).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        
        return NoContent();
    }
    
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteAuthor(int id)
    {
        var author = await _context.Authors.FindAsync(id);
        if (author == null)
            return NotFound();
        
        _context.Authors.Remove(author);
        await _context.SaveChangesAsync();
        
        return NoContent();
    }
}
```

---

## 💻 Repository Pattern with DI

```csharp
// Interface
public interface IAuthorRepository
{
    Task<IEnumerable<Author>> GetAllAsync();
    Task<Author> GetByIdAsync(int id);
    Task<Author> CreateAsync(Author author);
    Task UpdateAsync(Author author);
    Task DeleteAsync(int id);
}

// Implementation
public class AuthorRepository : IAuthorRepository
{
    private readonly BookStoreContext _context;
    
    public AuthorRepository(BookStoreContext context)
    {
        _context = context;
    }
    
    public async Task<IEnumerable<Author>> GetAllAsync()
    {
        return await _context.Authors
            .Include(a => a.Books)
            .ToListAsync();
    }
    
    public async Task<Author> GetByIdAsync(int id)
    {
        return await _context.Authors
            .Include(a => a.Books)
            .FirstOrDefaultAsync(a => a.AuthorId == id);
    }
    
    public async Task<Author> CreateAsync(Author author)
    {
        _context.Authors.Add(author);
        await _context.SaveChangesAsync();
        return author;
    }
    
    public async Task UpdateAsync(Author author)
    {
        _context.Entry(author).State = EntityState.Modified;
        await _context.SaveChangesAsync();
    }
    
    public async Task DeleteAsync(int id)
    {
        var author = await _context.Authors.FindAsync(id);
        if (author != null)
        {
            _context.Authors.Remove(author);
            await _context.SaveChangesAsync();
        }
    }
}

// Registration in Program.cs
builder.Services.AddScoped<IAuthorRepository, AuthorRepository>();

// Controller using repository
[ApiController]
[Route("api/[controller]")]
public class AuthorsController : ControllerBase
{
    private readonly IAuthorRepository _repository;
    
    public AuthorsController(IAuthorRepository repository)
    {
        _repository = repository;
    }
    
    [HttpGet]
    public async Task<IEnumerable<Author>> GetAll()
    {
        return await _repository.GetAllAsync();
    }
}
```

---

## 💻 Generic Repository Pattern

```csharp
// Generic interface
public interface IRepository<T> where T : class
{
    Task<IEnumerable<T>> GetAllAsync();
    Task<T> GetByIdAsync(int id);
    Task<T> CreateAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(int id);
}

// Generic implementation
public class Repository<T> : IRepository<T> where T : class
{
    protected readonly BookStoreContext _context;
    protected readonly DbSet<T> _dbSet;
    
    public Repository(BookStoreContext context)
    {
        _context = context;
        _dbSet = context.Set<T>();
    }
    
    public virtual async Task<IEnumerable<T>> GetAllAsync()
    {
        return await _dbSet.ToListAsync();
    }
    
    public virtual async Task<T> GetByIdAsync(int id)
    {
        return await _dbSet.FindAsync(id);
    }
    
    public virtual async Task<T> CreateAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }
    
    public virtual async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }
    
    public virtual async Task DeleteAsync(int id)
    {
        var entity = await GetByIdAsync(id);
        if (entity != null)
        {
            _dbSet.Remove(entity);
            await _context.SaveChangesAsync();
        }
    }
}

// Registration
builder.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
```

---

## 📊 DI Lifetime Options

| Lifetime | Use Case | DbContext |
|----------|----------|-----------|
| **Scoped** | Per HTTP request | ✅ Default |
| **Transient** | New instance each time | ❌ Wasteful |
| **Singleton** | Entire app lifetime | ❌ Not thread-safe |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **AddDbContext** - Registers DbContext with DI
2. **Scoped lifetime** - One instance per request
3. **Constructor injection** - Receive DbContext automatically
4. **Repository pattern** - Abstracts data access
5. **IConfiguration** - Use for connection strings
6. **Async methods** - Use for scalability

---

## 📝 Interview Questions

1. **Why is DbContext registered as Scoped?**
   - Thread-safe: one per request
   - Automatic disposal at request end
   - Change tracking works within request

2. **Benefits of Repository pattern with DI?**
   - Testability (can mock repository)
   - Separation of concerns
   - Single responsibility

3. **How does DI help with testing?**
   - Inject mock DbContext or in-memory database
   - Test services without real database

---

## 🎉 Series Complete!

Congratulations! You've completed the comprehensive .NET/C# notes series covering:
- **Collections & Data Structures**
- **Threading & Async**
- **Extension Methods & LINQ**
- **Dependency Injection**
- **ADO.NET**
- **SOLID Principles**
- **C# Modern Features**
- **Entity Framework Core**
