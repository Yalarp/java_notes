# EF Core Change Tracking

## 📚 Introduction

Change Tracking is how EF Core monitors modifications to entities. It automatically detects which entities have been added, modified, or deleted and generates appropriate SQL statements when `SaveChanges()` is called.

---

## 🎯 Learning Objectives

- Understand how change tracking works
- Manage entity states manually
- Optimize performance with AsNoTracking
- Handle disconnected scenarios

---

## 📖 Theory: Change Tracking Process

```
┌────────────────────────────────────────────────────────────────┐
│                Change Tracking Internals                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  When you query an entity:                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  var author = context.Authors.Find(1);                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                           ↓                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  ChangeTracker stores:                                   │   │
│  │  ┌─────────────────────────────────────────────┐        │   │
│  │  │ Entity:    Author { Id=1, Name="John" }     │        │   │
│  │  │ State:     Unchanged                        │        │   │
│  │  │ Original:  { Id=1, Name="John" }  ← snapshot│        │   │
│  │  └─────────────────────────────────────────────┘        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                           ↓                                     │
│  When you modify:                                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  author.Name = "Jane";                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                           ↓                                     │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  ChangeTracker detects:                                  │   │
│  │  ┌─────────────────────────────────────────────┐        │   │
│  │  │ Entity:    Author { Id=1, Name="Jane" }     │        │   │
│  │  │ State:     Modified                         │        │   │
│  │  │ Original:  { Id=1, Name="John" }            │        │   │
│  │  │ Changed:   Name property                    │        │   │
│  │  └─────────────────────────────────────────────┘        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                           ↓                                     │
│  On SaveChanges():                                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  UPDATE Authors SET Name = 'Jane' WHERE Id = 1           │   │
│  │  (Only changed columns!)                                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 💻 Entity States in Action

```csharp
using System;
using Microsoft.EntityFrameworkCore;

public class ChangeTrackingDemo
{
    public void DemonstrateStates()
    {
        using var context = new BookStoreContext();
        
        // === DETACHED ===
        var newAuthor = new Author { Name = "New Author" };
        var state1 = context.Entry(newAuthor).State;  // Detached
        Console.WriteLine($"New entity: {state1}");
        
        // === ADDED ===
        context.Authors.Add(newAuthor);
        var state2 = context.Entry(newAuthor).State;  // Added
        Console.WriteLine($"After Add: {state2}");
        
        context.SaveChanges();  // INSERT executed
        
        // === UNCHANGED ===
        var state3 = context.Entry(newAuthor).State;  // Unchanged
        Console.WriteLine($"After Save: {state3}");
        
        // === MODIFIED ===
        newAuthor.Name = "Updated Name";
        var state4 = context.Entry(newAuthor).State;  // Modified
        Console.WriteLine($"After Modify: {state4}");
        
        context.SaveChanges();  // UPDATE executed
        
        // === DELETED ===
        context.Authors.Remove(newAuthor);
        var state5 = context.Entry(newAuthor).State;  // Deleted
        Console.WriteLine($"After Remove: {state5}");
        
        context.SaveChanges();  // DELETE executed
    }
}
```

---

## 💻 Inspecting Change Tracker

```csharp
public void InspectTrackedEntities(BookStoreContext context)
{
    // Get all tracked entities
    var entries = context.ChangeTracker.Entries();
    
    foreach (var entry in entries)
    {
        Console.WriteLine($"Entity: {entry.Entity.GetType().Name}");
        Console.WriteLine($"State: {entry.State}");
        
        // For modified entities, see what changed
        if (entry.State == EntityState.Modified)
        {
            foreach (var prop in entry.Properties)
            {
                if (prop.IsModified)
                {
                    Console.WriteLine($"  {prop.Metadata.Name}:");
                    Console.WriteLine($"    Original: {prop.OriginalValue}");
                    Console.WriteLine($"    Current:  {prop.CurrentValue}");
                }
            }
        }
    }
    
    // Check if there are any pending changes
    bool hasChanges = context.ChangeTracker.HasChanges();
    Console.WriteLine($"Has pending changes: {hasChanges}");
}
```

---

## 💻 Manually Managing State

```csharp
public class DisconnectedScenarios
{
    // Scenario: Web API receives entity from client
    public void UpdateFromClient(Author authorFromClient)
    {
        using var context = new BookStoreContext();
        
        // Option 1: Attach and mark modified
        context.Attach(authorFromClient);
        context.Entry(authorFromClient).State = EntityState.Modified;
        context.SaveChanges();
        // Updates ALL columns
        
        // Option 2: Update method (same as above)
        // context.Authors.Update(authorFromClient);
        
        // Option 3: Fetch and update only changed properties
        var existing = context.Authors.Find(authorFromClient.AuthorId);
        if (existing != null)
        {
            existing.Name = authorFromClient.Name;
            existing.Email = authorFromClient.Email;
            context.SaveChanges();
            // Updates only specified columns
        }
        
        // Option 4: Use SetValues
        var existingEntry = context.Authors.Find(authorFromClient.AuthorId);
        if (existingEntry != null)
        {
            context.Entry(existingEntry).CurrentValues.SetValues(authorFromClient);
            context.SaveChanges();
            // Updates only properties that are different
        }
    }
}
```

---

## 💻 AsNoTracking for Read-Only Queries

```csharp
public class ReadOnlyQueries
{
    public void DemonstrateNoTracking()
    {
        using var context = new BookStoreContext();
        
        // WITH tracking (default) - entities are cached
        var authors = context.Authors.ToList();
        Console.WriteLine($"Tracked: {context.ChangeTracker.Entries().Count()}");  // > 0
        
        // WITHOUT tracking - better performance for read-only
        var authorsNoTrack = context.Authors
            .AsNoTracking()
            .ToList();
        
        // Not tracked, modifications won't be saved
        authorsNoTrack[0].Name = "Changed";
        context.SaveChanges();  // Nothing happens!
        
        // Global no-tracking (for read-heavy apps)
        // In DbContext constructor:
        // ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
    }
}
```

### When to Use AsNoTracking:

```
┌────────────────────────────────────────────────────────────────┐
│                When to Use AsNoTracking                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ USE AsNoTracking:                                          │
│  • Display-only data (lists, reports)                          │
│  • API responses (no modifications expected)                   │
│  • Large result sets                                           │
│  • Performance-critical read operations                        │
│                                                                 │
│  ❌ DON'T USE AsNoTracking:                                    │
│  • When you'll modify and save entities                        │
│  • When you need identity resolution                           │
│  • When querying related data you'll update                    │
│                                                                 │
│  Performance difference:                                        │
│  • 10-20% faster queries                                       │
│  • Lower memory usage                                          │
│  • No snapshot maintenance                                     │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## 📊 Entity State Summary

| State | Description | On SaveChanges |
|-------|-------------|----------------|
| **Detached** | Not tracked by context | Nothing |
| **Unchanged** | Tracked, no modifications | Nothing |
| **Added** | New entity to insert | INSERT |
| **Modified** | Existing entity changed | UPDATE |
| **Deleted** | Marked for deletion | DELETE |

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Automatic tracking** - EF tracks queried entities
2. **Snapshot comparison** - Detects changes vs original
3. **AsNoTracking()** - Faster for read-only queries
4. **Entry()** - Access entity tracking info
5. **State manipulation** - Use for disconnected scenarios
6. **HasChanges()** - Check for pending modifications

---

## 📝 Interview Questions

1. **How does EF Core detect changes?**
   - Keeps snapshot of original values
   - Compares current values on SaveChanges()

2. **When would you use AsNoTracking?**
   - Read-only queries for better performance
   - When entities won't be modified

3. **How to update in disconnected scenario?**
   - Attach entity, set state to Modified
   - Or fetch existing and copy values

---

## 🔗 Next Topic
Next: [44_EF_Core_Logging.md](./44_EF_Core_Logging.md) - Query Logging
