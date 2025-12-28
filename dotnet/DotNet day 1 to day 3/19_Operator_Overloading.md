# Operator Overloading in C#

## Overview
Operator overloading allows you to redefine how operators work with user-defined types (classes and structs). This enables natural, intuitive syntax when working with custom objects.

---

## 1. What is Operator Overloading?

### Definition
**Operator overloading** allows you to define custom behavior for built-in operators (`+`, `-`, `*`, `==`, etc.) when applied to instances of your own classes or structs.

### Why Use It?
```csharp
// Without operator overloading
Vector v3 = Vector.Add(v1, v2);

// With operator overloading - more intuitive!
Vector v3 = v1 + v2;
```

---

## 2. Operator Overloading Syntax

```csharp
public static returnType operator symbol(parameters)
{
    // Implementation
    return result;
}
```

### Rules
1. Must be **`public`** and **`static`**
2. At least one parameter must be the **containing type**
3. Some operators must be overloaded in **pairs** (`==`/`!=`, `<`/`>`, etc.)

---

## 3. Overloadable and Non-Overloadable Operators

### Can Be Overloaded

| Category | Operators |
|----------|-----------|
| Unary | `+`, `-`, `!`, `~`, `++`, `--`, `true`, `false` |
| Binary | `+`, `-`, `*`, `/`, `%`, `&`, `|`, `^`, `<<`, `>>` |
| Comparison | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| Conversion | `implicit`, `explicit` |

### Cannot Be Overloaded

| Operators | Reason |
|-----------|--------|
| `=` (assignment) | Has built-in behavior |
| `&&`, `||` | Use `&`, `|` and `true`/`false` instead |
| `[]` (indexer) | Use indexer syntax instead |
| `()` (cast) | Use implicit/explicit conversion |
| `?.`, `??`, `=>` | Language syntax elements |
| `new`, `typeof`, `sizeof` | Fundamental operations |

---

## 4. Unary Operator Overloading

```csharp
using System;

class Counter
{
    public int Value { get; private set; }
    
    public Counter(int value = 0) => Value = value;
    
    // Unary + (positive)
    public static Counter operator +(Counter c)
        => new Counter(Math.Abs(c.Value));
    
    // Unary - (negation)
    public static Counter operator -(Counter c)
        => new Counter(-c.Value);
    
    // Increment ++
    public static Counter operator ++(Counter c)
        => new Counter(c.Value + 1);
    
    // Decrement --
    public static Counter operator --(Counter c)
        => new Counter(c.Value - 1);
    
    // Logical negation !
    public static bool operator !(Counter c)
        => c.Value == 0;
    
    public override string ToString() => $"Counter({Value})";
}

class Program
{
    static void Main()
    {
        Counter c = new Counter(5);
        Console.WriteLine($"Original: {c}");     // Counter(5)
        
        Console.WriteLine($"Negated: {-c}");     // Counter(-5)
        
        c++;
        Console.WriteLine($"After ++: {c}");     // Counter(6)
        
        c--;
        Console.WriteLine($"After --: {c}");     // Counter(5)
        
        Counter zero = new Counter(0);
        Console.WriteLine($"!zero: {!zero}");    // True
        Console.WriteLine($"!c: {!c}");          // False
    }
}
```

---

## 5. Binary Operator Overloading

```csharp
using System;

class Complex
{
    public double Real { get; }
    public double Imaginary { get; }
    
    public Complex(double real, double imaginary)
    {
        Real = real;
        Imaginary = imaginary;
    }
    
    // Addition
    public static Complex operator +(Complex a, Complex b)
        => new Complex(a.Real + b.Real, a.Imaginary + b.Imaginary);
    
    // Subtraction
    public static Complex operator -(Complex a, Complex b)
        => new Complex(a.Real - b.Real, a.Imaginary - b.Imaginary);
    
    // Multiplication
    public static Complex operator *(Complex a, Complex b)
        => new Complex(
            a.Real * b.Real - a.Imaginary * b.Imaginary,
            a.Real * b.Imaginary + a.Imaginary * b.Real
        );
    
    // Scalar multiplication (Complex * double)
    public static Complex operator *(Complex c, double scalar)
        => new Complex(c.Real * scalar, c.Imaginary * scalar);
    
    // Scalar multiplication (double * Complex)
    public static Complex operator *(double scalar, Complex c)
        => c * scalar;  // Reuse the other overload
    
    // Division by scalar
    public static Complex operator /(Complex c, double scalar)
    {
        if (scalar == 0)
            throw new DivideByZeroException();
        return new Complex(c.Real / scalar, c.Imaginary / scalar);
    }
    
    public override string ToString()
    {
        if (Imaginary >= 0)
            return $"{Real} + {Imaginary}i";
        else
            return $"{Real} - {Math.Abs(Imaginary)}i";
    }
}

class Program
{
    static void Main()
    {
        Complex c1 = new Complex(3, 4);
        Complex c2 = new Complex(1, 2);
        
        Console.WriteLine($"c1 = {c1}");              // 3 + 4i
        Console.WriteLine($"c2 = {c2}");              // 1 + 2i
        Console.WriteLine($"c1 + c2 = {c1 + c2}");    // 4 + 6i
        Console.WriteLine($"c1 - c2 = {c1 - c2}");    // 2 + 2i
        Console.WriteLine($"c1 * c2 = {c1 * c2}");    // -5 + 10i
        Console.WriteLine($"c1 * 2 = {c1 * 2}");      // 6 + 8i
        Console.WriteLine($"2 * c1 = {2 * c1}");      // 6 + 8i
    }
}
```

---

## 6. Comparison Operator Overloading

**Important:** Comparison operators must be overloaded in pairs!
- `==` and `!=`
- `<` and `>`
- `<=` and `>=`

```csharp
using System;

class Point : IEquatable<Point>
{
    public int X { get; }
    public int Y { get; }
    
    public Point(int x, int y) { X = x; Y = y; }
    
    // Distance from origin (for comparison)
    public double DistanceFromOrigin => Math.Sqrt(X * X + Y * Y);
    
    // Equality operators (must override Equals and GetHashCode too!)
    public static bool operator ==(Point a, Point b)
    {
        if (ReferenceEquals(a, b)) return true;
        if (a is null || b is null) return false;
        return a.X == b.X && a.Y == b.Y;
    }
    
    public static bool operator !=(Point a, Point b)
        => !(a == b);
    
    // Comparison operators
    public static bool operator <(Point a, Point b)
        => a.DistanceFromOrigin < b.DistanceFromOrigin;
    
    public static bool operator >(Point a, Point b)
        => a.DistanceFromOrigin > b.DistanceFromOrigin;
    
    public static bool operator <=(Point a, Point b)
        => a.DistanceFromOrigin <= b.DistanceFromOrigin;
    
    public static bool operator >=(Point a, Point b)
        => a.DistanceFromOrigin >= b.DistanceFromOrigin;
    
    // Must override Equals when overloading ==
    public override bool Equals(object obj)
        => obj is Point p && this == p;
    
    public bool Equals(Point other)
        => this == other;
    
    // Must override GetHashCode when overriding Equals
    public override int GetHashCode()
        => HashCode.Combine(X, Y);
    
    public override string ToString() => $"({X}, {Y})";
}

class Program
{
    static void Main()
    {
        Point p1 = new Point(3, 4);
        Point p2 = new Point(3, 4);
        Point p3 = new Point(0, 5);
        
        Console.WriteLine($"p1 = {p1}");
        Console.WriteLine($"p2 = {p2}");
        Console.WriteLine($"p3 = {p3}");
        
        Console.WriteLine($"p1 == p2: {p1 == p2}");  // True
        Console.WriteLine($"p1 != p3: {p1 != p3}");  // True
        Console.WriteLine($"p1 == p3: {p1 == p3}");  // False (same distance, diff coords)
        Console.WriteLine($"p1 > p3: {p1 > p3}");    // False (5 vs 5)
    }
}
```

---

## 7. Implicit and Explicit Conversion Operators

### Implicit Conversion (Automatic)

```csharp
class Fahrenheit
{
    public double Temperature { get; }
    
    public Fahrenheit(double temp) => Temperature = temp;
    
    // Implicit: Fahrenheit → double (always safe)
    public static implicit operator double(Fahrenheit f)
        => f.Temperature;
    
    // Implicit: double → Fahrenheit
    public static implicit operator Fahrenheit(double temp)
        => new Fahrenheit(temp);
    
    public override string ToString() => $"{Temperature}°F";
}

class Program
{
    static void Main()
    {
        Fahrenheit f = 98.6;  // Implicit: double → Fahrenheit
        double temp = f;       // Implicit: Fahrenheit → double
        
        Console.WriteLine($"Temperature: {f}");   // 98.6°F
        Console.WriteLine($"As double: {temp}");  // 98.6
    }
}
```

### Explicit Conversion (Requires Cast)

```csharp
class Celsius
{
    public double Temperature { get; }
    
    public Celsius(double temp) => Temperature = temp;
    
    // Explicit: Celsius → Fahrenheit (might lose precision)
    public static explicit operator Fahrenheit(Celsius c)
        => new Fahrenheit(c.Temperature * 9 / 5 + 32);
    
    // Explicit: Fahrenheit → Celsius
    public static explicit operator Celsius(Fahrenheit f)
        => new Celsius((f.Temperature - 32) * 5 / 9);
    
    public override string ToString() => $"{Temperature}°C";
}

class Program
{
    static void Main()
    {
        Celsius c = new Celsius(100);
        Fahrenheit f = (Fahrenheit)c;  // Explicit cast required
        
        Console.WriteLine($"{c} = {f}");  // 100°C = 212°F
        
        Celsius c2 = (Celsius)f;  // Back to Celsius
        Console.WriteLine($"{f} = {c2}");  // 212°F = 100°C
    }
}
```

---

## 8. true and false Operators

For using objects in boolean contexts:

```csharp
class MyBoolean
{
    public int Value { get; }
    
    public MyBoolean(int value) => Value = value;
    
    // true operator - defines when object is "true"
    public static bool operator true(MyBoolean b)
        => b.Value != 0;
    
    // false operator - defines when object is "false"
    public static bool operator false(MyBoolean b)
        => b.Value == 0;
    
    // For && and || to work, also need & and |
    public static MyBoolean operator &(MyBoolean a, MyBoolean b)
        => new MyBoolean(a.Value & b.Value);
    
    public static MyBoolean operator |(MyBoolean a, MyBoolean b)
        => new MyBoolean(a.Value | b.Value);
}

class Program
{
    static void Main()
    {
        MyBoolean a = new MyBoolean(5);
        MyBoolean b = new MyBoolean(0);
        
        if (a)  // Uses 'operator true'
            Console.WriteLine("a is true");
        
        if (!b)  // Uses 'operator false'
            Console.WriteLine("b is false");
    }
}
```

---

## 9. Complete Example: Vector2D

```csharp
using System;

struct Vector2D : IEquatable<Vector2D>
{
    public double X { get; }
    public double Y { get; }
    
    public Vector2D(double x, double y) { X = x; Y = y; }
    
    // Magnitude (length) of vector
    public double Magnitude => Math.Sqrt(X * X + Y * Y);
    
    // Unit vector (normalized)
    public Vector2D Normalized
    {
        get
        {
            double mag = Magnitude;
            return mag > 0 ? this / mag : new Vector2D(0, 0);
        }
    }
    
    // Unary operators
    public static Vector2D operator +(Vector2D v) => v;
    public static Vector2D operator -(Vector2D v) => new Vector2D(-v.X, -v.Y);
    
    // Binary arithmetic operators
    public static Vector2D operator +(Vector2D a, Vector2D b)
        => new Vector2D(a.X + b.X, a.Y + b.Y);
    
    public static Vector2D operator -(Vector2D a, Vector2D b)
        => new Vector2D(a.X - b.X, a.Y - b.Y);
    
    public static Vector2D operator *(Vector2D v, double scalar)
        => new Vector2D(v.X * scalar, v.Y * scalar);
    
    public static Vector2D operator *(double scalar, Vector2D v)
        => v * scalar;
    
    public static Vector2D operator /(Vector2D v, double scalar)
    {
        if (scalar == 0) throw new DivideByZeroException();
        return new Vector2D(v.X / scalar, v.Y / scalar);
    }
    
    // Dot product using *
    public static double operator *(Vector2D a, Vector2D b)
        => a.X * b.X + a.Y * b.Y;
    
    // Comparison operators
    public static bool operator ==(Vector2D a, Vector2D b)
        => a.X == b.X && a.Y == b.Y;
    
    public static bool operator !=(Vector2D a, Vector2D b)
        => !(a == b);
    
    // Compare by magnitude
    public static bool operator <(Vector2D a, Vector2D b)
        => a.Magnitude < b.Magnitude;
    
    public static bool operator >(Vector2D a, Vector2D b)
        => a.Magnitude > b.Magnitude;
    
    public static bool operator <=(Vector2D a, Vector2D b)
        => a.Magnitude <= b.Magnitude;
    
    public static bool operator >=(Vector2D a, Vector2D b)
        => a.Magnitude >= b.Magnitude;
    
    // Implicit conversion from tuple
    public static implicit operator Vector2D((double x, double y) tuple)
        => new Vector2D(tuple.x, tuple.y);
    
    // Override Equals and GetHashCode
    public override bool Equals(object obj)
        => obj is Vector2D v && this == v;
    
    public bool Equals(Vector2D other) => this == other;
    
    public override int GetHashCode()
        => HashCode.Combine(X, Y);
    
    public override string ToString()
        => $"({X:F2}, {Y:F2})";
}

class Program
{
    static void Main()
    {
        Vector2D v1 = (3, 4);  // Implicit from tuple
        Vector2D v2 = (1, 2);
        
        Console.WriteLine($"v1 = {v1}");
        Console.WriteLine($"v2 = {v2}");
        Console.WriteLine($"|v1| = {v1.Magnitude}");          // 5
        Console.WriteLine($"v1 + v2 = {v1 + v2}");            // (4, 6)
        Console.WriteLine($"v1 - v2 = {v1 - v2}");            // (2, 2)
        Console.WriteLine($"v1 * 2 = {v1 * 2}");              // (6, 8)
        Console.WriteLine($"v1 · v2 = {v1 * v2}");            // 11 (dot product)
        Console.WriteLine($"-v1 = {-v1}");                     // (-3, -4)
        Console.WriteLine($"v1 normalized = {v1.Normalized}"); // (0.6, 0.8)
        Console.WriteLine($"v1 == v1: {v1 == v1}");           // True
        Console.WriteLine($"v1 > v2: {v1 > v2}");             // True
    }
}
```

---

## Key Points Summary

1. Operators must be **`public static`**
2. **Comparison operators** must be overloaded in pairs
3. Override **`Equals`** and **`GetHashCode`** when overloading `==`
4. Use **`implicit`** for safe conversions, **`explicit`** for potentially lossy ones
5. At least one parameter must be the containing type
6. **Cannot overload** `=`, `&&`, `||`, `[]`, `new`, etc.
7. Return **new instance** from operators (immutability)

---

## Common Mistakes to Avoid

1. ❌ Forgetting to override `Equals`/`GetHashCode` with `==`
2. ❌ Only overloading one of a required pair (`==` without `!=`)
3. ❌ Modifying operands instead of returning new instance
4. ❌ Not making operators `public static`
5. ❌ Using implicit conversion when data might be lost

---

## Practice Questions

1. What operators cannot be overloaded?
2. Why must `==` and `!=` be overloaded together?
3. What is the difference between implicit and explicit conversion?
4. What must you override when you overload `==`?
5. Can you overload the assignment operator `=`?
6. What is required for `&&` and `||` to work with custom types?
