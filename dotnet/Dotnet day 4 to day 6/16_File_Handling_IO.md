# File Handling and I/O in C#

## 📚 Introduction

C# provides comprehensive support for file and stream operations through the `System.IO` namespace. This includes reading/writing files, working with streams, and managing directories.

---

## 🎯 Learning Objectives

- Master FileStream for byte-level operations
- Use StreamReader/StreamWriter for text files
- Implement File and Directory helper classes
- Apply `using` statement for proper cleanup

---

## 🔍 Stream Hierarchy

```
                    ┌─────────────┐
                    │   Stream    │ (abstract base)
                    └──────┬──────┘
                           │
     ┌─────────────┬───────┼───────┬─────────────┐
     │             │       │       │             │
┌────▼────┐  ┌─────▼────┐ ┌─▼────┐ ┌▼─────────┐ ┌▼────────────┐
│FileStream│ │MemoryStream│ │BufferedStream│ │NetworkStream│ │GZipStream  │
└─────────┘  └──────────┘ └────────┘ └───────────┘ └──────────────┘
```

---

## 💻 Code Examples

### Example 1: FileStream - Byte-Level Operations

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = @"C:\Temp\test.txt";
        
        // Writing bytes to file
        using (FileStream fs = new FileStream(path, FileMode.Create))
        {
            byte[] data = System.Text.Encoding.UTF8.GetBytes("Hello, FileStream!");
            fs.Write(data, 0, data.Length);
            Console.WriteLine($"Written {data.Length} bytes");
        }  // File automatically closed here
        
        // Reading bytes from file
        using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read))
        {
            byte[] buffer = new byte[fs.Length];
            int bytesRead = fs.Read(buffer, 0, buffer.Length);
            string content = System.Text.Encoding.UTF8.GetString(buffer, 0, bytesRead);
            Console.WriteLine($"Read: {content}");
        }
    }
}
```

#### Line-by-Line Explanation
| Line | Code | Explanation |
|------|------|-------------|
| 9 | `@"C:\Temp\test.txt"` | Verbatim string (@ prevents escape sequences) |
| 11 | `FileMode.Create` | Creates new file or overwrites existing |
| 13 | `GetBytes(...)` | Converts string to byte array |
| 14 | `fs.Write(data, 0, data.Length)` | Writes bytes starting at offset 0 |
| 19 | `FileMode.Open, FileAccess.Read` | Open existing file, read-only |
| 22 | `fs.Read(buffer, 0, buffer.Length)` | Reads bytes into buffer |

---

### Example 2: FileMode Options

```csharp
using System.IO;

// FileMode enumeration
FileMode.Create      // Create new or overwrite existing
FileMode.CreateNew   // Create new, throw if exists
FileMode.Open        // Open existing, throw if not exists
FileMode.OpenOrCreate // Open if exists, create if not
FileMode.Append      // Open and seek to end
FileMode.Truncate    // Open and truncate to zero length

// FileAccess (optional)
FileAccess.Read      // Read-only
FileAccess.Write     // Write-only
FileAccess.ReadWrite // Both (default)

// FileShare (optional - for concurrent access)
FileShare.None       // No sharing
FileShare.Read       // Others can read
FileShare.Write      // Others can write
FileShare.ReadWrite  // Others can read and write
```

---

### Example 3: StreamWriter - Text Files

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = @"C:\Temp\notes.txt";
        
        // Writing text to file
        using (StreamWriter writer = new StreamWriter(path))
        {
            writer.WriteLine("Line 1: Hello");
            writer.WriteLine("Line 2: World");
            writer.Write("No newline at end");
        }
        
        // Appending text
        using (StreamWriter writer = new StreamWriter(path, append: true))
        {
            writer.WriteLine();  // Add newline
            writer.WriteLine("Appended line");
        }
        
        // Reading the file
        Console.WriteLine(File.ReadAllText(path));
    }
}
```

#### Output:
```
Line 1: Hello
Line 2: World
No newline at end
Appended line
```

---

### Example 4: StreamReader - Reading Text

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = @"C:\Temp\notes.txt";
        
        // Read entire file
        using (StreamReader reader = new StreamReader(path))
        {
            string content = reader.ReadToEnd();
            Console.WriteLine("=== Entire File ===");
            Console.WriteLine(content);
        }
        
        // Read line by line
        using (StreamReader reader = new StreamReader(path))
        {
            Console.WriteLine("=== Line by Line ===");
            string line;
            int lineNum = 1;
            while ((line = reader.ReadLine()) != null)
            {
                Console.WriteLine($"{lineNum++}: {line}");
            }
        }
    }
}
```

---

### Example 5: File Helper Class (Static Methods)

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = @"C:\Temp\data.txt";
        
        // Write all text at once
        File.WriteAllText(path, "Hello World!");
        
        // Read all text
        string content = File.ReadAllText(path);
        Console.WriteLine(content);
        
        // Write all lines
        string[] lines = { "Line 1", "Line 2", "Line 3" };
        File.WriteAllLines(path, lines);
        
        // Read all lines
        string[] readLines = File.ReadAllLines(path);
        foreach (string line in readLines)
            Console.WriteLine(line);
        
        // Append text
        File.AppendAllText(path, "\nAppended text");
        
        // Check if file exists
        if (File.Exists(path))
        {
            Console.WriteLine("File exists!");
            
            // Get file info
            FileInfo info = new FileInfo(path);
            Console.WriteLine($"Size: {info.Length} bytes");
            Console.WriteLine($"Created: {info.CreationTime}");
            Console.WriteLine($"Modified: {info.LastWriteTime}");
        }
        
        // Copy file
        File.Copy(path, @"C:\Temp\data_backup.txt", overwrite: true);
        
        // Move/Rename file
        // File.Move(path, @"C:\Temp\renamed.txt");
        
        // Delete file
        // File.Delete(path);
    }
}
```

---

### Example 6: Directory Operations

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string dirPath = @"C:\Temp\MyFolder";
        
        // Create directory
        if (!Directory.Exists(dirPath))
        {
            Directory.CreateDirectory(dirPath);
            Console.WriteLine("Directory created");
        }
        
        // Get files in directory
        string[] files = Directory.GetFiles(@"C:\Temp");
        Console.WriteLine("Files in C:\\Temp:");
        foreach (string file in files)
            Console.WriteLine($"  {Path.GetFileName(file)}");
        
        // Get subdirectories
        string[] dirs = Directory.GetDirectories(@"C:\Temp");
        Console.WriteLine("\nSubdirectories:");
        foreach (string dir in dirs)
            Console.WriteLine($"  {Path.GetFileName(dir)}");
        
        // Get files with pattern
        string[] txtFiles = Directory.GetFiles(@"C:\Temp", "*.txt");
        
        // Get files recursively
        string[] allFiles = Directory.GetFiles(
            @"C:\Temp", 
            "*.*", 
            SearchOption.AllDirectories
        );
        
        // Current directory
        Console.WriteLine($"\nCurrent: {Directory.GetCurrentDirectory()}");
    }
}
```

---

### Example 7: Path Helper Class

```csharp
using System;
using System.IO;

class Program
{
    static void Main()
    {
        string path = @"C:\Users\John\Documents\report.txt";
        
        Console.WriteLine($"Full Path: {Path.GetFullPath(path)}");
        Console.WriteLine($"Directory: {Path.GetDirectoryName(path)}");
        Console.WriteLine($"Filename: {Path.GetFileName(path)}");
        Console.WriteLine($"Without Ext: {Path.GetFileNameWithoutExtension(path)}");
        Console.WriteLine($"Extension: {Path.GetExtension(path)}");
        Console.WriteLine($"Root: {Path.GetPathRoot(path)}");
        
        // Combine paths
        string combined = Path.Combine(@"C:\Users", "John", "file.txt");
        Console.WriteLine($"\nCombined: {combined}");
        
        // Temp paths
        Console.WriteLine($"Temp folder: {Path.GetTempPath()}");
        Console.WriteLine($"Random file: {Path.GetTempFileName()}");
    }
}
```

---

## 📊 Common File Operations Comparison

| Task | FileStream | StreamReader/Writer | File Class |
|------|------------|---------------------|------------|
| Byte access | ✓ Best | ✗ | ✗ |
| Text access | Manual encoding | ✓ Best | ✓ Simple |
| Large files | ✓ | ✓ | ✗ (memory) |
| Quick one-liners | ✗ | ✗ | ✓ Best |
| Control | Maximum | Medium | Minimal |

---

## ⚡ Key Points to Remember

1. **Always use `using`** - ensures proper cleanup
2. **File vs StreamReader** - File for simple, StreamReader for streaming
3. **FileMode.Create** - overwrites existing files!
4. **Path.Combine** - handles path separators automatically
5. **Check existence** - before operations that require existing files

---

## ❌ Common Mistakes

### Mistake 1: Forgetting to close files
```csharp
FileStream fs = new FileStream(...);
// ... work
fs.Close();  // Easy to forget!

// BETTER: use 'using'
using (FileStream fs = new FileStream(...)) { }
```

### Mistake 2: Not handling exceptions
```csharp
// Files can throw IOException, UnauthorizedAccessException, etc.
try
{
    File.ReadAllText(path);
}
catch (FileNotFoundException)
{
    Console.WriteLine("File not found");
}
```

---

## 📝 Practice Questions

1. **What's the difference between File.ReadAllText and StreamReader?**
<details>
<summary>Answer</summary>
`File.ReadAllText` reads entire file into memory at once. `StreamReader` can read incrementally, better for large files.
</details>

2. **What happens with FileMode.Create if file exists?**
<details>
<summary>Answer</summary>
It overwrites the existing file (truncates to 0 and writes new content).
</details>

---

## 🔗 Related Topics
- [17_Serialization.md](17_Serialization.md) - Saving objects to files
- [14_Exception_Handling.md](14_Exception_Handling.md) - File exception handling
