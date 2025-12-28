# String to Number Conversion Methods

## Overview
Converting strings to numbers is a common operation in C#. This chapter covers three primary methods: `Parse()`, `Convert`, and `TryParse()`, with detailed explanations of when to use each.

---

## 1. The Three Conversion Methods

### Comparison Table

| Method | Exception on Invalid Input | Exception on Null | Returns |
|--------|---------------------------|-------------------|---------|
| `Parse()` | Yes (FormatException) | Yes (ArgumentNullException) | Converted value |
| `Convert.ToXxx()` | Yes (FormatException) | Returns 0 (no exception) | Converted value |
| `TryParse()` | No (returns false) | No (returns false) | bool + out parameter |

---

## 2. Parse() Method

### Syntax
```csharp
int.Parse(string)
float.Parse(string)
double.Parse(string)
```

### Characteristics
- Throws `FormatException` if string is not valid number
- Throws `ArgumentNullException` if string is null
- Returns the converted value directly

### Code Example

```csharp
using System;

class ParseDemo
{
    static void Main()
    {
        // ✅ Valid conversion
        string validNumber = "123";
        int result = int.Parse(validNumber);
        Console.WriteLine($"Parsed: {result}");  // 123
        
        // ✅ Float parsing
        string floatStr = "3.14";
        float f = float.Parse(floatStr);
        Console.WriteLine($"Float: {f}");  // 3.14
        
        // ❌ Invalid string - throws FormatException
        try
        {
            string invalid = "abc";
            int num = int.Parse(invalid);  // Exception!
        }
        catch (FormatException ex)
        {
            Console.WriteLine($"FormatException: {ex.Message}");
        }
        
        // ❌ Null string - throws ArgumentNullException
        try
        {
            string nullStr = null;
            int num = int.Parse(nullStr);  // Exception!
        }
        catch (ArgumentNullException ex)
        {
            Console.WriteLine($"ArgumentNullException: {ex.Message}");
        }
    }
}
```

### Parse Methods for Different Types

```csharp
string str = "42";

int i = int.Parse(str);         // Same as Int32.Parse(str)
long l = long.Parse(str);        // Same as Int64.Parse(str)
float f = float.Parse("3.14");   // Same as Single.Parse()
double d = double.Parse("3.14"); // Same as Double.Parse()
decimal m = decimal.Parse("19.99");
bool b = bool.Parse("true");     // Case-insensitive: "True", "true", "TRUE"
```

---

## 3. Convert Class Methods

### Syntax
```csharp
Convert.ToInt32(string)
Convert.ToSingle(string)
Convert.ToDouble(string)
```

### Characteristics
- Throws `FormatException` for invalid strings
- Returns **0** (or default) for null input (no exception!)
- More flexible - can convert between many types

### Code Example

```csharp
using System;

class ConvertDemo
{
    static void Main()
    {
        // ✅ Valid conversion
        string validNumber = "456";
        int result = Convert.ToInt32(validNumber);
        Console.WriteLine($"Converted: {result}");  // 456
        
        // ✅ Null handling - returns 0!
        string nullStr = null;
        int n = Convert.ToInt32(nullStr);  // Returns 0, no exception
        Console.WriteLine($"Null converted: {n}");  // 0
        
        // ✅ Other conversions
        double d = Convert.ToDouble("3.14159");
        float f = Convert.ToSingle("2.5");
        bool b = Convert.ToBoolean("true");
        
        // ❌ Invalid string - throws FormatException
        try
        {
            int invalid = Convert.ToInt32("abc");  // Exception!
        }
        catch (FormatException ex)
        {
            Console.WriteLine($"FormatException: {ex.Message}");
        }
        
        // ✅ Rounding behavior (different from Parse!)
        double roundTest = 3.7;
        int rounded = Convert.ToInt32(roundTest);  // 4 (rounds!)
        int truncated = (int)roundTest;            // 3 (truncates!)
        
        Console.WriteLine($"Convert.ToInt32(3.7): {rounded}");    // 4
        Console.WriteLine($"(int)3.7: {truncated}");               // 3
    }
}
```

### Convert Methods Reference

| Method | Description |
|--------|-------------|
| `Convert.ToInt32()` | To int (32-bit) |
| `Convert.ToInt64()` | To long (64-bit) |
| `Convert.ToSingle()` | To float |
| `Convert.ToDouble()` | To double |
| `Convert.ToDecimal()` | To decimal |
| `Convert.ToBoolean()` | To bool |
| `Convert.ToChar()` | To char |
| `Convert.ToString()` | To string |

---

## 4. TryParse() Method (RECOMMENDED)

### Syntax
```csharp
bool success = int.TryParse(string, out int result);
```

### Characteristics
- Returns `true` if conversion succeeds, `false` otherwise
- **Never throws exceptions** for invalid input
- Result is provided via `out` parameter
- **Best practice** for user input validation

### Code Example

```csharp
using System;

class TryParseDemo
{
    static void Main()
    {
        // ✅ Valid conversion
        string validNumber = "789";
        if (int.TryParse(validNumber, out int result))
        {
            Console.WriteLine($"Success: {result}");  // 789
        }
        
        // ✅ Invalid string - no exception!
        string invalid = "abc";
        if (int.TryParse(invalid, out int num))
        {
            Console.WriteLine($"Converted: {num}");
        }
        else
        {
            Console.WriteLine("Conversion failed!");  // This executes
            Console.WriteLine($"num is: {num}");      // 0 (default)
        }
        
        // ✅ Null string - no exception!
        string nullStr = null;
        if (int.TryParse(nullStr, out int n))
        {
            Console.WriteLine($"Converted: {n}");
        }
        else
        {
            Console.WriteLine("Null conversion failed!");  // This executes
        }
        
        // ✅ Safe user input handling
        Console.Write("Enter a number: ");
        string input = Console.ReadLine();
        
        if (int.TryParse(input, out int userNum))
        {
            Console.WriteLine($"You entered: {userNum}");
        }
        else
        {
            Console.WriteLine("Invalid input! Please enter a number.");
        }
    }
}
```

### TryParse with Different Types

```csharp
// Integer
int.TryParse("123", out int i);

// Float
float.TryParse("3.14", out float f);

// Double
double.TryParse("2.718", out double d);

// Decimal
decimal.TryParse("19.99", out decimal m);

// Boolean
bool.TryParse("true", out bool b);

// Long
long.TryParse("123456789", out long l);
```

---

## 5. Complete Comparison Example

```csharp
using System;

class ConversionComparison
{
    static void Main()
    {
        string[] testValues = { "123", "abc", null, "3.14", "" };
        
        foreach (string value in testValues)
        {
            Console.WriteLine($"\n=== Testing: \"{value ?? "null"}\" ===");
            
            // Parse method
            try
            {
                int parseResult = int.Parse(value);
                Console.WriteLine($"Parse: {parseResult}");
            }
            catch (FormatException)
            {
                Console.WriteLine("Parse: FormatException");
            }
            catch (ArgumentNullException)
            {
                Console.WriteLine("Parse: ArgumentNullException");
            }
            
            // Convert method
            try
            {
                int convertResult = Convert.ToInt32(value);
                Console.WriteLine($"Convert: {convertResult}");
            }
            catch (FormatException)
            {
                Console.WriteLine("Convert: FormatException");
            }
            
            // TryParse method
            if (int.TryParse(value, out int tryParseResult))
            {
                Console.WriteLine($"TryParse: {tryParseResult}");
            }
            else
            {
                Console.WriteLine($"TryParse: false (result is {tryParseResult})");
            }
        }
    }
}
```

### Expected Output:

```
=== Testing: "123" ===
Parse: 123
Convert: 123
TryParse: 123

=== Testing: "abc" ===
Parse: FormatException
Convert: FormatException
TryParse: false (result is 0)

=== Testing: "null" ===
Parse: ArgumentNullException
Convert: 0
TryParse: false (result is 0)

=== Testing: "3.14" ===
Parse: FormatException
Convert: FormatException
TryParse: false (result is 0)

=== Testing: "" ===
Parse: FormatException
Convert: FormatException
TryParse: false (result is 0)
```

---

## 6. Converting Numbers to Different Bases

### Converting from Different Bases

```csharp
// Convert from hexadecimal
int hex = Convert.ToInt32("FF", 16);  // 255

// Convert from binary
int binary = Convert.ToInt32("1010", 2);  // 10

// Convert from octal
int octal = Convert.ToInt32("17", 8);  // 15
```

### Converting to Different Bases

```csharp
int number = 255;

string hex = Convert.ToString(number, 16);   // "ff"
string binary = Convert.ToString(number, 2); // "11111111"
string octal = Convert.ToString(number, 8);  // "377"
```

---

## 7. Practical Example: Robust Input Validation

```csharp
using System;

class RobustInputDemo
{
    static void Main()
    {
        int age = GetValidInteger("Enter your age: ", 1, 120);
        Console.WriteLine($"Your age is: {age}");
        
        double salary = GetValidDouble("Enter your salary: ");
        Console.WriteLine($"Your salary is: {salary:C}");
    }
    
    static int GetValidInteger(string prompt, int min, int max)
    {
        int result;
        
        while (true)
        {
            Console.Write(prompt);
            string input = Console.ReadLine();
            
            if (int.TryParse(input, out result))
            {
                if (result >= min && result <= max)
                {
                    return result;
                }
                Console.WriteLine($"Please enter a value between {min} and {max}.");
            }
            else
            {
                Console.WriteLine("Invalid input. Please enter a valid number.");
            }
        }
    }
    
    static double GetValidDouble(string prompt)
    {
        double result;
        
        while (true)
        {
            Console.Write(prompt);
            string input = Console.ReadLine();
            
            if (double.TryParse(input, out result) && result > 0)
            {
                return result;
            }
            Console.WriteLine("Invalid input. Please enter a positive number.");
        }
    }
}
```

---

## 8. ToString() Method

### Every Type Has ToString()

```csharp
int number = 42;
string str = number.ToString();  // "42"

double pi = 3.14159;
string piStr = pi.ToString();    // "3.14159"

bool flag = true;
string flagStr = flag.ToString(); // "True"

// Formatted ToString
double price = 1234.567;
Console.WriteLine(price.ToString("C"));   // $1,234.57 (currency)
Console.WriteLine(price.ToString("F2"));  // 1234.57 (fixed 2 decimals)
Console.WriteLine(price.ToString("N"));   // 1,234.57 (number format)
```

---

## Key Points Summary

| Aspect | Parse | Convert | TryParse |
|--------|-------|---------|----------|
| **Invalid String** | FormatException | FormatException | Returns false |
| **Null Input** | ArgumentNullException | Returns 0 | Returns false |
| **Best For** | Known valid input | Type conversions | User input |
| **Performance** | Fast | Medium | Fast |

### When to Use Each

1. **Use `Parse()`** when you're certain the input is valid
2. **Use `Convert.ToXxx()`** when you need flexibility with null handling
3. **Use `TryParse()`** (RECOMMENDED) for user input or uncertain data

---

## Practice Questions

1. What is the difference between Parse and TryParse?
2. What happens when you pass null to Convert.ToInt32()?
3. Why is TryParse recommended for user input?
4. What is the return type of TryParse?
5. What does Convert.ToInt32(3.7) return? Why?
6. How do you convert a hexadecimal string to integer?
