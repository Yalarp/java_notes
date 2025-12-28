# EF Core CRUD Operations

## 📚 Introduction

CRUD operations (Create, Read, Update, Delete) in EF Core are performed through DbContext methods. EF Core tracks changes to entities and generates appropriate SQL statements when `SaveChanges()` is called.

---

## 🎯 Learning Objectives

- Perform all CRUD operations with EF Core
- Understand entity states and change tracking
- Use async methods for database operations

---

## 📖 Theory: Entity States

```
┌────────────────────────────────────────────────────────────────┐
│                    Entity State Lifecycle                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐                                                  │
│  │ Detached │  ──── context.Attach() ────→ ┌───────────┐       │
│  └────┬─────┘                               │ Unchanged │       │
│       │                                     └─────┬─────┘       │
│   context.Add()                                   │             │
│       │                              entity.Property = x        │
│       ▼                                           │             │
│  ┌──────────┐                               ┌─────▼─────┐       │
│  │  Added   │                               │ Modified  │       │
│  └────┬─────┘                               └─────┬─────┘       │
│       │                                           │             │
│       │           SaveChanges()                   │             │
│       └───────────────┬───────────────────────────┘             │
│                       ▼                                         │
│                  ┌──────────┐      context.Remove()            │
│                  │ Unchanged │ ──────────────→ ┌─────────┐     │
│                  └──────────┘                  │ Deleted │     │
│                                                └────┬────┘     │
│                                                     │           │
│                                              SaveChanges()      │
│                                                     │           │
│                                                ┌────▼────┐     │
│                                                │ Detached│     │
│                                                └─────────┘     │
│                                                                 │
│  State         SQL Generated                                   │
│  ─────         ──────────────                                  │
│  Added    →    INSERT INTO ...                                 │
│  Modified →    UPDATE ... WHERE Id = @Id                       │
│  Deleted  →    DELETE FROM ... WHERE Id = @Id                  │
│  Unchanged →   No SQL                                          │
│  Detached →    No tracking                                     │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 CREATE - Adding Entities

```csharp
using System;
using Microsoft.EntityFrameworkCore;

public class AuthorService
{
    private readonly BookStoreContext _context;
    
    public AuthorService(BookStoreContext context)
    {
        _context = context;
    }
    
    // Add single entity
    public void AddAuthor(string firstName, string lastName)
    {
        var author = new Author
        {
            FirstName = firstName,
            LastName = lastName
        };
        
        // State becomes Added
        _context.Authors.Add(author);
        
        // Generates: INSERT INTO Authors (FirstName, LastName) VALUES (@p0, @p1)
        _context.SaveChanges();
        
        // After save, author.AuthorId has database-generated value
        Console.WriteLine($"Created author with ID: {author.AuthorId}");
    }
    
    // Add multiple entities
    public void AddMultipleAuthors()
    {
        var authors = new List<Author>
        {
            new Author { FirstName = "Alice", LastName = "Smith" },
            new Author { FirstName = "Bob", LastName = "Jones" }
        };
        
        _context.Authors.AddRange(authors);  // Add multiple
        _context.SaveChanges();
    }
    
    // Async version
    public async Task<Author> AddAuthorAsync(string firstName, string lastName)
    {
        var author = new Author
        {
            FirstName = firstName,
            LastName = lastName
        };
        
        _context.Authors.Add(author);
        await _context.SaveChangesAsync();  // Async save
        
        return author;
    }
}
```

---

## 💻 READ - Querying Entities

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;

public class AuthorService
{
    private readonly BookStoreContext _context;
    
    public AuthorService(BookStoreContext context)
    {
        _context = context;
    }
    
    // Find by primary key (fastest for single entity)
    public Author GetById(int id)
    {
        return _context.Authors.Find(id);
        // SQL: SELECT TOP 1 * FROM Authors WHERE AuthorId = @id
    }
    
    // Get all entities
    public List<Author> GetAll()
    {
        return _context.Authors.ToList();
    }
    
    // Query with filter
    public List<Author> GetByLastName(string lastName)
    {
        return _context.Authors
            .Where(a => a.LastName == lastName)
            .ToList();
    }
    
    // Query with ordering
    public List<Author> GetAllOrdered()
    {
        return _context.Authors
            .OrderBy(a => a.LastName)
            .ThenBy(a => a.FirstName)
            .ToList();
    }
    
    // Include related data (eager loading)
    public List<Author> GetAuthorsWithBooks()
    {
        return _context.Authors
            .Include(a => a.Books)  // Load related books
            .ToList();
        // SQL: SELECT ... FROM Authors LEFT JOIN Books ON ...
    }
    
    // Projection - select specific columns
    public List<string> GetAuthorNames()
    {
        return _context.Authors
            .Select(a => a.FirstName + " " + a.LastName)
            .ToList();
    }
    
    // First or default
    public Author GetFirstByName(string name)
    {
        return _context.Authors
            .FirstOrDefault(a => a.FirstName == name);
    }
    
    // Async version
    public async Task<List<Author>> GetAllAsync()
    {
        return await _context.Authors.ToListAsync();
    }
}
```

---

## 💻 UPDATE - Modifying Entities

```csharp
using Microsoft.EntityFrameworkCore;

public class AuthorService
{
    private readonly BookStoreContext _context;
    
    public AuthorService(BookStoreContext context)
    {
        _context = context;
    }
    
    // Connected scenario - entity is tracked
    public void UpdateAuthor(int id, string newFirstName)
    {
        // Find entity (now tracked)
        var author = _context.Authors.Find(id);
        
        if (author != null)
        {
            // Modify property (state becomes Modified)
            author.FirstName = newFirstName;
            
            // SaveChanges generates UPDATE only for changed columns
            _context.SaveChanges();
            // SQL: UPDATE Authors SET FirstName = @p0 WHERE AuthorId = @p1
        }
    }
    
    // Disconnected scenario - entity not tracked
    public void UpdateAuthorDisconnected(Author author)
    {
        // Attach and mark entire entity as modified
        _context.Entry(author).State = EntityState.Modified;
        
        // Or use Update method
        // _context.Authors.Update(author);
        
        _context.SaveChanges();
        // SQL: UPDATE Authors SET FirstName=@p0, LastName=@p1, Email=@p2 WHERE AuthorId=@p3
    }
    
    // Update specific properties only
    public void UpdateEmail(int id, string email)
    {
        var author = new Author { AuthorId = id };
        _context.Authors.Attach(author);
        
        author.Email = email;
        _context.Entry(author).Property(a => a.Email).IsModified = true;
        
        _context.SaveChanges();
        // SQL: UPDATE Authors SET Email = @p0 WHERE AuthorId = @p1
    }
}
```

---

## 💻 DELETE - Removing Entities

```csharp
using Microsoft.EntityFrameworkCore;

public class AuthorService
{
    private readonly BookStoreContext _context;
    
    public AuthorService(BookStoreContext context)
    {
        _context = context;
    }
    
    // Delete by finding first
    public void DeleteAuthor(int id)
    {
        var author = _context.Authors.Find(id);
        
        if (author != null)
        {
            _context.Authors.Remove(author);  // State becomes Deleted
            _context.SaveChanges();
            // SQL: DELETE FROM Authors WHERE AuthorId = @p0
        }
    }
    
    // Delete without loading
    public void DeleteAuthorOptimized(int id)
    {
        var author = new Author { AuthorId = id };
        _context.Authors.Attach(author);
        _context.Authors.Remove(author);
        _context.SaveChanges();
    }
    
    // Delete multiple
    public void DeleteAuthorsWithNoBooks()
    {
        var authorsToDelete = _context.Authors
            .Where(a => !a.Books.Any())
            .ToList();
        
        _context.Authors.RemoveRange(authorsToDelete);
        _context.SaveChanges();
    }
}
```

---

## 📊 CRUD Methods Summary

| Operation | Method | Entity State | SQL Generated |
|-----------|--------|--------------|---------------|
| **Create** | `Add()`, `AddRange()` | Added | INSERT |
| **Read** | `Find()`, `Where()` | Unchanged | SELECT |
| **Update** | Modify tracked entity | Modified | UPDATE |
| **Delete** | `Remove()`, `RemoveRange()` | Deleted | DELETE |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Find()** - Best for single entity by primary key
2. **Include()** - Eager load related data
3. **Change tracking** - EF tracks modifications automatically
4. **SaveChanges()** - Persists all pending changes
5. **Async methods** - Use in web applications
6. **Entity states** - Added, Modified, Deleted, Unchanged, Detached

---

## 📝 Interview Questions

1. **Difference between Find() and FirstOrDefault()?**
   - Find() checks local cache first, then database
   - FirstOrDefault() always queries database

2. **How does EF Core know what changed?**
   - ChangeTracker compares current values to original
   - Only modified properties are updated

3. **How to update without loading entity first?**
   - Attach entity with key, set state to Modified

---

## 🔗 Next Topic
Next: [41_EF_Core_Relationships.md](./41_EF_Core_Relationships.md) - Entity Relationships
