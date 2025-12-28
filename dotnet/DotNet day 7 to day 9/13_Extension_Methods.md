# Extension Methods in C#

## 📚 Introduction

Extension methods, introduced in .NET 3.5, allow you to add new methods to existing types without modifying the original type, creating a derived class, or using inheritance. They are the foundation of LINQ.

---

## 🎯 Learning Objectives

- Understand how to create extension methods
- Learn the "this" modifier syntax
- Know when and why to use extension methods

---

## 📖 Theory: Why Extension Methods?

```
┌────────────────────────────────────────────────────────────────┐
│               Why Use Extension Methods?                        │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Problem 1: Want to add methods to a class in production        │
│           → Modifying it risks breaking existing code          │
│                                                                 │
│ Problem 2: Want to add methods to sealed class or struct       │
│           → Cannot inherit from sealed types                   │
│                                                                 │
│ Problem 3: Want to extend types you don't own (string, int)    │
│           → Cannot modify .NET framework types                 │
│                                                                 │
│ Solution: Extension Methods!                                   │
│           → Add functionality without modifying original       │
└────────────────────────────────────────────────────────────────┘
```

### Defining Extension Methods

Two requirements:
1. **Static class** - Extension methods must be in a static class
2. **this keyword** - First parameter uses `this` modifier

---

## 💻 Code Example 1: Basic Extension Method

```csharp
using System;

namespace ConsoleApplication20
{
    class Program
    {
        static void Main(string[] args)
        {
            string str = "cdac";
            
            // Call extension method as if it were instance method!
            string rs = str.ChangeFirstLetter("hello");
            
            Console.WriteLine(rs);  // Output: Cdachello
        }
    }
    
    // Extension methods must be in static class
    public static class StringHelper
    {
        // Extension method: note "this string inp" parameter
        public static string ChangeFirstLetter(this string inp, string s)
        {
            if (inp.Length > 0)
            {
                char[] char_arr = inp.ToCharArray();
                
                // Toggle case of first character
                char_arr[0] = char.IsUpper(char_arr[0]) 
                    ? char.ToLower(char_arr[0]) 
                    : char.ToUpper(char_arr[0]);
                    
                return new string(char_arr) + s;
            }
            return inp;
        }
    }
}
```

### Line-by-Line Explanation:

| Line | Code | Explanation |
|------|------|-------------|
| 9 | `string str = "cdac"` | Normal string variable |
| 12 | `str.ChangeFirstLetter("hello")` | Calling extension method |
| 19 | `public static class StringHelper` | Must be static class |
| 22 | `this string inp` | "this" marks it as extension method |
| 22 | `string s` | Additional parameter |
| 27-29 | Toggle case logic | Uppercase if lower, lowercase if upper |
| 31 | `return new string(char_arr) + s` | Return modified string + suffix |

### How It Works:

```
str.ChangeFirstLetter("hello")
     ↓
Compiler converts to:
StringHelper.ChangeFirstLetter(str, "hello")
     ↓
"this string inp" receives "cdac"
"string s" receives "hello"
     ↓
Returns "Cdachello"
```

### Memory Visualization:

```
str = "cdac"
       ↓
char_arr:
┌───┬───┬───┬───┐
│ c │ d │ a │ c │
│↓↓↓│   │   │   │
│ C │   │   │   │  ← Toggle to uppercase
└───┴───┴───┴───┘
       ↓
new string(char_arr) + "hello" = "Cdachello"
```

---

## 💻 Code Example 2: Extension Method on Custom Type

```csharp
using System;
using System.Collections.Generic;

public enum Dept { HR, Payroll, IT }

internal class Employee
{
    public string Name { get; set; }
    public int Id { get; set; }
    public string Email { get; set; }
    public Dept? Department { get; set; }

    public override string ToString()
    {
        return String.Format("{0} {1} {2} {3}", Id, Name, Email, Department);
    }
}

// Extension methods for Employee collections
public static class EmployeeExtensions
{
    // Get employees by department
    public static IEnumerable<Employee> ByDepartment(
        this IEnumerable<Employee> employees, 
        Dept dept)
    {
        foreach (var emp in employees)
        {
            if (emp.Department == dept)
                yield return emp;
        }
    }
    
    // Get high earners (if salary property existed)
    public static IEnumerable<Employee> InIT(this IEnumerable<Employee> employees)
    {
        return employees.ByDepartment(Dept.IT);
    }
}

class Program
{
    static void Main()
    {
        var employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Mary", Department = Dept.HR },
            new Employee { Id = 2, Name = "John", Department = Dept.IT },
            new Employee { Id = 3, Name = "Sam", Department = Dept.IT }
        };
        
        // Use extension methods
        foreach (var emp in employees.InIT())
        {
            Console.WriteLine(emp);
        }
        // Output:
        // 2 John null IT
        // 3 Sam null IT
    }
}
```

---

## 📊 Extension Method Rules

| Rule | Explanation |
|------|-------------|
| **Static class** | Container must be static |
| **Static method** | Method must be static |
| **this parameter** | First parameter has "this" keyword |
| **No access to privates** | Can only access public members |
| **Instance methods win** | If conflict, instance method is called |
| **Using required** | Namespace must be imported |

---

## 💻 Code Example 3: Chaining Extension Methods

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

public static class StringExtensions
{
    public static string Reverse(this string s)
    {
        char[] arr = s.ToCharArray();
        Array.Reverse(arr);
        return new string(arr);
    }
    
    public static string Shout(this string s)
    {
        return s.ToUpper() + "!";
    }
}

class Program
{
    static void Main()
    {
        string message = "hello";
        
        // Chain extension methods
        string result = message.Reverse().Shout();
        
        Console.WriteLine(result);  // Output: OLLEH!
    }
}
```

### Chaining Flow:

```
"hello".Reverse().Shout()
   ↓
Reverse("hello") → "olleh"
   ↓
Shout("olleh") → "OLLEH!"
```

---

## 🔑 Key Points

> **📌 Remember These!**

1. **Static class + static method** - Both required
2. **this keyword** - Marks the extended type
3. **Called like instance method** - `str.Method()` not `Class.Method(str)`
4. **LINQ is built on this** - All LINQ methods are extension methods
5. **Cannot access private members** - Only public API available

---

## ⚠️ Common Mistakes

| Mistake | Problem | Solution |
|---------|---------|----------|
| Non-static class | Won't compile | Make class static |
| Forgetting "this" | Not an extension method | Add this keyword |
| Not importing namespace | Method not found | Add using statement |

---

## 📝 Interview Questions

1. **What is an extension method?**
   - Static method that appears as instance method on extended type

2. **What are the requirements for extension methods?**
   - Static class, static method, "this" on first parameter

3. **Can extension methods access private members?**
   - No, only public members of the extended type

4. **What happens if instance method has same signature?**
   - Instance method wins (takes precedence)

---

## 🔗 Next Topic
Next: [14_LINQ_Fundamentals.md](./14_LINQ_Fundamentals.md) - LINQ Fundamentals
