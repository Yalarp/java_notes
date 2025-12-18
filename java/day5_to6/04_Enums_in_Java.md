# 📚 Enums in Java - Complete Guide

## Table of Contents
1. [Introduction to Enums](#introduction-to-enums)
2. [Why Enums Were Introduced](#why-enums-were-introduced)
3. [Enum Syntax and Declaration](#enum-syntax-and-declaration)
4. [Enum Internal Structure](#enum-internal-structure)
5. [Enum Constructors](#enum-constructors)
6. [Enum with Methods](#enum-with-methods)
7. [Static Blocks in Enums](#static-blocks-in-enums)
8. [The values() Method](#the-values-method)
9. [Important Enum Rules](#important-enum-rules)
10. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Enums

An **enum** (enumeration) is a user-defined data type used to define a **set of predefined constant values**. 

### Key Characteristics:
- Introduced in **Java 5**
- Helps make programs **more readable**
- Helps **reduce programming bugs**
- Provides **type safety** for constants

### Real-World Examples:
```
✓ Compass directions: NORTH, SOUTH, EAST, WEST
✓ Days of the week: MONDAY, TUESDAY, WEDNESDAY...
✓ Pizza sizes: SMALL, MEDIUM, LARGE
✓ HTTP status: OK, NOT_FOUND, SERVER_ERROR
✓ Card suits: HEARTS, DIAMONDS, CLUBS, SPADES
```

---

## Why Enums Were Introduced

### The Problem: Using static final Constants

Before enums, developers used `static final` integers:

```java
class MyFont
{
    // Line 4-6: Define constants as static final integers
    public static final int PLAIN = 0;
    public static final int BOLD = 1;
    public static final int ITALIC = 2;
}

class MyComponent
{
    // Line 11: Method accepts int parameter
    public void setStyle(int style)
    {
        switch(style)
        {
            case 0: System.out.println("plain");
                    break;
            case 1: System.out.println("bold");
                    break;
            case 2: System.out.println("italic");
                    break;
            default: System.out.println("unpredictable font");
        }
    }
}

public class Demo1
{
    public static void main(String args[])
    {
        MyComponent mc = new MyComponent();
        
        mc.setStyle(MyFont.BOLD);    // ✓ Correct usage
        mc.setStyle(MyFont.ITALIC);  // ✓ Correct usage
        
        // PROBLEMS:
        mc.setStyle(1);   // ✓ Saves typing but loses meaning
        mc.setStyle(6);   // ✓ Compiles but RISKY! No such style!
    }
}
```

### Problems with static final Approach:
1. **No type safety** - Any integer can be passed
2. **No compile-time checking** - Invalid values not caught
3. **Magic numbers** - `setStyle(1)` is not readable
4. **Risk of bugs** - `setStyle(6)` compiles but fails at runtime

---

### The Solution: Using Enum

```java
// Line 2-5: Define enum with exactly 3 valid values
enum MyFont
{
    PLAIN, BOLD, ITALIC   // Only these 3 values are valid
}

class MyComponent
{
    // Line 10: Method accepts MyFont type (not int!)
    public void setStyle(MyFont font)
    {
        switch(font)
        {
            case PLAIN:  System.out.println("plain");
                         break;
            case BOLD:   System.out.println("bold");
                         break;
            case ITALIC: System.out.println("italic");
                         break;
            // No default needed - all cases covered!
        }
    }
}

public class Demo1
{
    public static void main(String args[])
    {
        MyComponent mc = new MyComponent();
        
        mc.setStyle(MyFont.BOLD);    // ✓ Correct
        mc.setStyle(MyFont.ITALIC);  // ✓ Correct
        mc.setStyle(MyFont.PLAIN);   // ✓ Correct
        
        // mc.setStyle(1);   // ✗ Compilation Error!
        // mc.setStyle(6);   // ✗ Compilation Error!
        // Only MyFont values allowed!
    }
}
```

### Benefits of Enum:
1. **Type safety** - Only valid enum values accepted
2. **Compile-time checking** - Invalid values caught at compile time
3. **Readable code** - `setStyle(MyFont.BOLD)` is clear
4. **No risk of invalid values** - Cannot pass random integers

---

## Enum Syntax and Declaration

### Basic Syntax:
```java
// Declaring enum outside class
enum Day
{
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

// Using enum
Day today = Day.MONDAY;
```

### Declaring Enum:
```java
// At package level (like a class)
enum Color { RED, GREEN, BLUE }

// Inside a class (nested)
class Shape {
    enum Side { TOP, BOTTOM, LEFT, RIGHT }
}

// CANNOT declare inside a method - enum cannot be local!
void method() {
    // enum LocalEnum { A, B } // ✗ Compilation Error!
}
```

---

## Enum Internal Structure

### What Enum Really Is:

When you write:
```java
public enum Color 
{
    RED, GREEN, BLUE;
}
```

### The Compiler Generates:
```java
public final class Color extends Enum<Color> 
{
    // Each constant is a public static final instance
    public static final Color RED = new Color("RED", 0);
    public static final Color GREEN = new Color("GREEN", 1);
    public static final Color BLUE = new Color("BLUE", 2);
    
    // Private constructor (cannot instantiate from outside)
    private Color(String name, int ordinal) {
        super(name, ordinal);
    }
    
    // Additional methods generated by compiler
    public static Color[] values() { ... }
    public static Color valueOf(String name) { ... }
}
```

### Key Points:
```
┌────────────────────────────────────────────────────────────────────┐
│ 1. Enum is internally a CLASS that extends java.lang.Enum         │
│ 2. java.lang.Enum is an abstract class (no abstract methods)      │
│ 3. Enum CANNOT extend any other class (already extends Enum)      │
│ 4. Enum CAN implement interfaces                                  │
│ 5. Enum constants are "public", "static", and "final"             │
│ 6. Enum constructor is ALWAYS PRIVATE (implicitly)                │
│ 7. You CANNOT instantiate enum with "new" keyword                 │
└────────────────────────────────────────────────────────────────────┘
```

---

## Enum Constructors

### Default Constructor:

```java
enum Sample
{
    member1, member2;  // Two enum constants
    
    // Default constructor - implicitly private
    Sample()
    {
        System.out.println("inside Sample default constructor");
    }
}

public class Demo_3
{
    public static void main(String[] args) 
    {
        System.out.println("Main function started");
        
        // Cannot use new: Sample s1 = new Sample(); // ✗ Error!
        
        // Access enum constants - triggers constructor calls
        Sample ref1 = Sample.member1;
        Sample ref2 = Sample.member2;
        
        System.out.println(ref1 == ref2);           // false
        System.out.println(ref1 == Sample.member1); // true
    }
}
```

**Output:**
```
inside Sample default constructor
inside Sample default constructor
Main function started
false
true
```

**Explanation:** Constructor is called once for EACH enum constant during class loading.

---

### Parameterized Constructor:

```java
enum Sample
{
    // Constants must pass arguments to constructor
    member1(9), member2(6);  // Pass int to constructor
    
    private int num;  // Instance variable
    
    // Parameterized constructor - implicitly private
    Sample(int num)  
    {
        this.num = num;
        System.out.println("inside Sample parameterized constructor");
    }
    
    // Getter method
    public int getNum()    
    {
        return num;
    }
}

public class Demo_3_a
{
    public static void main(String[] args) 
    {
        System.out.println("Main function started");
        
        // Sample s1 = new Sample(200); // ✗ NOT allowed - private constructor
        
        Sample ref1 = Sample.member1;
        Sample ref2 = Sample.member2;
        
        System.out.println(ref1 == ref2);      // false
        System.out.println(ref1.getNum());     // 9
        System.out.println(ref2.getNum());     // 6
    }
}
```

**Output:**
```
inside Sample parameterized constructor
inside Sample parameterized constructor
Main function started
false
9
6
```

### Why You Cannot Use `new` for Enums:
```
In Java enums:

1. All enum constructors are implicitly PRIVATE
   (even if you don't write "private", compiler enforces it)

2. You CANNOT call "new" on an enum type from outside
   because the whole point of enum is to have a 
   FIXED SET of instances (the constants)

3. The ONLY way instances can be created is through
   the enum constants (member1, member2, etc.)
   declared at the top
```

---

## Enum with Methods

Enums can have methods just like classes:

```java
enum MyEnum
{
    instance;  // Single constant

    static
    {
        System.out.println("inside MyEnum static block");
    }
    
    MyEnum()
    {
        System.out.println("in the MyEnum constructor");
    }

    // Instance methods
    public void disp1()
    {
        System.out.println("inside disp1");
    }
    
    public void disp2()
    {
        System.out.println("inside disp2");
    }
}

public class Demo1
{
    public static void main(String[] args) 
    {
        System.out.println("Main function started");
        
        // Access singleton instance
        MyEnum ref1 = MyEnum.instance;
        
        // Call methods on enum constant
        ref1.disp1();
        ref1.disp2();
    }
}
```

**Output:**
```
Main function started
inside MyEnum static block
in the MyEnum constructor
inside disp1
inside disp2
```

---

## Static Blocks in Enums

### Execution Order:

```java
class A
{
    public static A ref = new A();
    
    static
    {
        System.out.println("in A static block");
    }
    
    A()
    {
        System.out.println("in A default constructor");
    }
}

public class DemoApp
{
    public static void main(String args[])
    {
        System.out.println(A.ref);
        System.out.println("in main");
    }
}
```

**Key Insight:**
```
Static blocks and static field initializations are executed
in "TEXTUAL ORDER" (order they appear in code).

If static field is BEFORE static block:
   1) Constructor called (for new A())
   2) Static block executed

If static block is BEFORE static field:
   1) Static block executed
   2) Constructor called (for new A())
```

### Applied to Enum:
When you access an enum constant:
1. Enum class is loaded
2. Static blocks and constant initializations execute in order
3. Constructor is called for EACH constant

---

## The values() Method

Every enum has a compiler-generated `values()` method that returns an array of all constants:

```java
enum Day
{
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

public class EnumDemo
{
    public static void main(String args[])
    {
        // values() returns array of all enum constants
        Day[] allDays = Day.values();
        
        for(Day d : allDays)
        {
            System.out.println(d);
        }
        
        // ordinal() returns position (0-based)
        System.out.println(Day.MONDAY.ordinal());    // 0
        System.out.println(Day.WEDNESDAY.ordinal()); // 2
        
        // name() returns constant name as String
        System.out.println(Day.FRIDAY.name());       // FRIDAY
        
        // valueOf() converts String to enum
        Day day = Day.valueOf("SATURDAY");
        System.out.println(day);                     // SATURDAY
    }
}
```

---

## Important Enum Rules

### Summary of Enum Characteristics:

| Property | Description |
|----------|-------------|
| **Extends** | Implicitly extends `java.lang.Enum` |
| **Inheritance** | Cannot extend another class |
| **Interfaces** | Can implement interfaces |
| **Constructor** | Always private (implicitly) |
| **Instantiation** | Cannot use `new` keyword |
| **Constants** | public, static, final |
| **Location** | Package level or nested, NOT local |
| **Introduced** | Java 5 (JDK 1.5) |

```java
// ✓ Enum can implement interfaces
enum Day implements Comparable<Day>, Serializable
{
    MONDAY, TUESDAY;
}

// ✗ Enum cannot extend a class
enum Day extends SomeClass  // Compilation Error!
{
    MONDAY, TUESDAY;
}

// ✗ Enum cannot be local (inside method)
void method()
{
    enum LocalDay { MON, TUE }  // Compilation Error!
}
```

---

## Code Examples with Flow

### Complete Enum Example:

```java
enum Planet
{
    // Each planet with mass and radius
    MERCURY(3.303e+23, 2.4397e6),
    VENUS(4.869e+24, 6.0518e6),
    EARTH(5.976e+24, 6.37814e6),
    MARS(6.421e+23, 3.3972e6);
    
    private final double mass;   // in kg
    private final double radius; // in meters
    
    // Constructor
    Planet(double mass, double radius)
    {
        this.mass = mass;
        this.radius = radius;
    }
    
    // Gravitational constant
    private static final double G = 6.67300E-11;
    
    // Method to calculate surface gravity
    double surfaceGravity()
    {
        return G * mass / (radius * radius);
    }
    
    // Method to calculate weight on this planet
    double surfaceWeight(double earthWeight)
    {
        double mass = earthWeight / EARTH.surfaceGravity();
        return mass * surfaceGravity();
    }
}

public class PlanetDemo
{
    public static void main(String[] args)
    {
        double earthWeight = 70.0;  // kg
        
        for(Planet p : Planet.values())
        {
            System.out.printf("Weight on %s: %.2f kg%n", 
                             p, p.surfaceWeight(earthWeight));
        }
    }
}
```

### Execution Flow:
```
Step 1: Class Loading
        ├── Planet class loads
        ├── Static block (if any) executes
        └── Constructor called for each constant:
            ├── MERCURY(3.303e+23, 2.4397e6)
            ├── VENUS(4.869e+24, 6.0518e6)
            ├── EARTH(5.976e+24, 6.37814e6)
            └── MARS(6.421e+23, 3.3972e6)

Step 2: main() called
        └── Iterate through Planet.values()
            ├── Calculate surfaceWeight for each
            └── Print formatted output

Memory:
┌─────────────────────────────────────────────────────┐
│           HEAP (Enum Constants)                     │
│  MERCURY ──► [mass: 3.303e+23, radius: 2.4397e6]   │
│  VENUS   ──► [mass: 4.869e+24, radius: 6.0518e6]   │
│  EARTH   ──► [mass: 5.976e+24, radius: 6.37814e6]  │
│  MARS    ──► [mass: 6.421e+23, radius: 3.3972e6]   │
└─────────────────────────────────────────────────────┘
```

---

## Key Takeaways

1. **Enum** = type-safe set of named constants
2. **Introduced in Java 5** for better constant handling
3. **Internally a class** extending `java.lang.Enum`
4. **Constructor always private** - cannot use `new`
5. **Constants are instances** - created during class loading
6. **Can have methods, fields, constructors**
7. **Cannot extend classes** but can implement interfaces
8. **Cannot be local** (inside methods)
9. **Use for fixed sets** of known values

---

*Previous: [03_Wrapper_Classes.md](./03_Wrapper_Classes.md)*
*Next: [05_Varargs_Variable_Arguments.md](./05_Varargs_Variable_Arguments.md)*
