# SqlConnection and Configuration in C#

## 📚 Introduction

SqlConnection manages the database connection. In .NET Core, connection strings are typically stored in appsettings.json and accessed via IConfiguration.

---

## 💻 Code Example: Setting Up Configuration

```csharp
using System;
using System.IO;
using Microsoft.Extensions.Configuration;

class Program
{
    private static IConfiguration _iconfiguration;
    
    static void Main(string[] args)
    {
        GetAppSettingsFile();
        // Use _iconfiguration to get connection string
    }
    
    static void GetAppSettingsFile()
    {
        // Build configuration from JSON file
        var builder = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
        
        _iconfiguration = builder.Build();
        
        Console.WriteLine(Directory.GetCurrentDirectory());
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 17 | `new ConfigurationBuilder()` | Create builder for configuration |
| 18 | `.SetBasePath(...)` | Set directory for config files |
| 19 | `.AddJsonFile(...)` | Read appsettings.json |
| 21 | `.Build()` | Create IConfiguration object |

---

## 💻 Using SqlConnection

```csharp
using System;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

public class ProductLayer
{
    private string _connectionString;
    
    public ProductLayer(IConfiguration iconfiguration)
    {
        _connectionString = iconfiguration.GetConnectionString("Default");
    }
    
    public void GetProducts()
    {
        // "using" ensures connection is closed/disposed
        using (SqlConnection con = new SqlConnection(_connectionString))
        {
            con.Open();
            Console.WriteLine("Connected!");
            
            // ... execute commands ...
            
        } // Connection automatically closed here
    }
}
```

### Connection String Components:

| Part | Description | Example |
|------|-------------|---------|
| **Data Source** | Server name | `(localdb)\\ProjectModels` |
| **Initial Catalog** | Database name | `StudentData` |
| **Integrated Security** | Windows auth | `True` or `SSPI` |
| **User Id/Password** | SQL auth | `User Id=sa;Password=xxx` |

---

## 🔑 Key Points

1. **Always use "using"** - Ensures connection is closed
2. **Store in config** - Never hard-code connection strings
3. **Open late, close early** - Minimize connection time
4. **Use IConfiguration** - Modern configuration pattern

---

## 🔗 Next Topic
Next: [25_SqlCommand_Execution.md](./25_SqlCommand_Execution.md) - SqlCommand Execution
