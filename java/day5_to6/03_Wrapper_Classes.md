# 📚 Wrapper Classes in Java - Complete Guide

## Table of Contents
1. [Introduction to Wrapper Classes](#introduction-to-wrapper-classes)
2. [Why Wrapper Classes Were Introduced](#why-wrapper-classes-were-introduced)
3. [Primitive to Wrapper Mapping](#primitive-to-wrapper-mapping)
4. [Creating Wrapper Objects](#creating-wrapper-objects)
5. [Autoboxing and Unboxing](#autoboxing-and-unboxing)
6. [Parsing Methods](#parsing-methods)
7. [Other Uses of Wrapper Classes](#other-uses-of-wrapper-classes)
8. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Wrapper Classes

**Wrapper classes** are used to wrap (enclose) primitives in objects. In Java, a Wrapper class is available for each primitive type.

### Key Characteristics:
- All wrapper classes are located in `java.lang` package
- All wrapper classes are derived from `java.lang.Object`
- All wrapper classes are **final** (cannot be subclassed)
- All wrapper classes are **immutable** (cannot modify wrapped value)

---

## Why Wrapper Classes Were Introduced

### The Problem (Before Wrapper Classes):

```java
public class Demo
{
    // This method accepts Object as parameter
    static void show(Object ref)
    {
        System.out.println(ref);
    }
    
    public static void main(String args[])
    {
        show(new String("hello"));    // ✓ Possible - String is Object
        show(new ArrayList());        // ✓ Possible - ArrayList is Object
        show(new LinkedList());       // ✓ Possible - LinkedList is Object
        
        int num = 10;
        show(num);  // ✗ NOT possible before JDK1.5
                    // Primitives are NOT objects!
    }
}
```

### The Solution (Wrapper Classes):

```java
public class Demo
{
    static void show(Object ref)
    {
        System.out.println(ref);
    }
    
    public static void main(String args[])
    {
        int num = 10;
        
        // Wrap primitive in Wrapper class
        Integer ob = new Integer(num);  // Wrapping int in Integer
        
        show(ob);  // ✓ Now possible! Integer IS-A Object
    }
}
```

### Why This Matters:
```
┌────────────────────────────────────────────────────────────────────┐
│ Collections (ArrayList, LinkedList, HashMap) work with OBJECTS    │
│ They CANNOT store primitives directly                             │
│                                                                    │
│ ArrayList<int> list = ...;     // ✗ NOT allowed                   │
│ ArrayList<Integer> list = ...; // ✓ Allowed                       │
│                                                                    │
│ Wrapper classes BRIDGE the gap between primitives and objects     │
└────────────────────────────────────────────────────────────────────┘
```

---

## Primitive to Wrapper Mapping

| Primitive | Wrapper Class | Size |
|-----------|---------------|------|
| `byte` | `Byte` | 8 bits |
| `short` | `Short` | 16 bits |
| `int` | `Integer` | 32 bits |
| `long` | `Long` | 64 bits |
| `float` | `Float` | 32 bits |
| `double` | `Double` | 64 bits |
| `char` | `Character` | 16 bits |
| `boolean` | `Boolean` | 1 bit (JVM specific) |

### Class Hierarchy:
```
java.lang.Object
    │
    ├── java.lang.Number (abstract)
    │       ├── Byte
    │       ├── Short
    │       ├── Integer
    │       ├── Long
    │       ├── Float
    │       └── Double
    │
    ├── java.lang.Character
    │
    └── java.lang.Boolean
```

---

## Creating Wrapper Objects

### Code Example: WrapperDemo1.java
```java
public class WrapperDemo1
{
    public static void main(String args[])
    {
        // How do you wrap primitive inside the wrapper class?
        
        // Line 7: Define primitive int
        int num = 100;
        
        // Line 8: Create Integer wrapper object containing primitive value
        // Constructor takes primitive and wraps it
        Integer ob = new Integer(num);
        
        // Line 9: Print the wrapper object
        // Internally calls Integer.toString() which returns "100"
        System.out.println(ob);  // Output: 100
    }
}
```

### Execution Flow:
```
Step 1: int num = 100
        Stack: [num = 100]

Step 2: new Integer(num)
        Heap: Creates Integer object containing value 100
        ┌─────────────────┐
   ob ──► │ value: 100     │
        └─────────────────┘

Step 3: System.out.println(ob)
        Calls ob.toString() → returns "100"
        Prints: 100
```

---

## Autoboxing and Unboxing

### Before JDK 1.5 (Manual Conversion):

```java
// Converting primitive to Wrapper (Boxing)
int num = 10;
Integer ob = new Integer(num);  // Manual boxing

// Converting Wrapper to primitive (Unboxing)
int temp = ob.intValue();       // Manual unboxing
```

### JDK 1.5 Onwards (Automatic Conversion):

```java
// Autoboxing - assigning primitive to wrapper
int num = 10;
Integer ob = num;  // Compiler converts to: new Integer(num)

// Unboxing - assigning wrapper to primitive
int temp = ob;     // Compiler converts to: ob.intValue()
```

### Code Example: WrapperDemo5.java (Before JDK 1.5)
```java
// Before JDK 1.5 - Manual conversion required
public class WrapperDemo5
{
    public static void main(String args[])
    {
        int num = 100;

        // Line 9: Converting primitive to wrapper (BOXING)
        // Must explicitly create Integer object
        Integer ob = new Integer(num);

        // Line 15: Converting wrapper to primitive (UNBOXING)
        // Must explicitly call intValue()
        int k = ob.intValue();
        
        System.out.println(k);  // Output: 100
    }
}
```

### Code Example: WrapperDemo6.java (JDK 1.5 Onwards)
```java
// From JDK 1.5 - Automatic conversion
public class WrapperDemo6
{
    public static void main(String args[])
    {
        int num = 100;

        // Line 9: AUTOBOXING - compiler converts to new Integer(num)
        Integer ob = num;  // Syntactic sugar!

        // Line 15: UNBOXING - compiler converts to ob.intValue()
        int k = ob;  // Syntactic sugar!
        
        System.out.println(k);  // Output: 100
    }
}
```

### Important Understanding:
```
Autoboxing and Unboxing are COMPILER features, NOT JVM features.

┌─────────────────────────────────────────────────────────────────┐
│ What you write:           │ What compiler generates:            │
├───────────────────────────┼─────────────────────────────────────┤
│ Integer ob = num;         │ Integer ob = new Integer(num);      │
│ int k = ob;               │ int k = ob.intValue();              │
└─────────────────────────────────────────────────────────────────┘

JVM doesn't understand autoboxing - it only sees the converted code.
This is called "syntactic sugar" - makes code easier to write.
```

### How Autoboxing Works with Method Parameters:
```java
// Method that accepts Object parameter
show(Object ref)
{
    System.out.println(ref);
}

// Calling with primitive (JDK 5 onwards)
int num = 100;
show(num);  // Possible!

// What compiler does:
show(new Integer(num));  // Autoboxing: int → Integer → Object
```

---

## Parsing Methods

Wrapper classes provide methods to convert **Strings to primitives**.

### Code Example: WrapperDemo2.java (String Concatenation Problem)
```java
public class WrapperDemo2
{
    public static void main(String args[])
    {
        // Line 5: str contains "125" as STRING (not number)
        String str = "125";
        
        // Line 6: += concatenates, does NOT add mathematically
        str += 10;  // String concatenation: "125" + "10"
        
        // Line 7: Prints "12510" (not 135!)
        System.out.println(str);  // Output: 12510
    }
}
```

### Code Example: WrapperDemo3.java (Using parseInt)
```java
public class WrapperDemo3
{
    public static void main(String args[])
    {
        // Line 5: String representation of number
        String str = "125";
        
        // Line 6: parseInt() converts String to int primitive
        int k = Integer.parseInt(str);  // k = 125 (as integer)
        
        // Line 7: Now mathematical addition works
        k += 10;  // 125 + 10 = 135
        
        // Line 8: Prints 135
        System.out.println(k);  // Output: 135
    }
}
```

### Code Example: WrapperDemo4.java (Handling Whitespace)
```java
public class WrapperDemo4
{
    public static void main(String args[])
    {
        // Line 5: String has leading and trailing spaces
        String str = " 125 ";  // Note the spaces
        
        // Line 6: trim() removes whitespace, then parseInt()
        // Without trim(): NumberFormatException!
        int k = Integer.parseInt(str.trim());
        
        k += 10;  // 125 + 10 = 135
        
        System.out.println(k);  // Output: 135
    }
}
```

### Parsing Methods for All Wrappers:

| Wrapper | Parsing Method | Example |
|---------|----------------|---------|
| `Byte` | `Byte.parseByte(str)` | `byte b = Byte.parseByte("10");` |
| `Short` | `Short.parseShort(str)` | `short s = Short.parseShort("100");` |
| `Integer` | `Integer.parseInt(str)` | `int i = Integer.parseInt("1000");` |
| `Long` | `Long.parseLong(str)` | `long l = Long.parseLong("10000");` |
| `Float` | `Float.parseFloat(str)` | `float f = Float.parseFloat("3.14");` |
| `Double` | `Double.parseDouble(str)` | `double d = Double.parseDouble("3.14159");` |
| `Boolean` | `Boolean.parseBoolean(str)` | `boolean b = Boolean.parseBoolean("true");` |

> **Note:** Character class has no parseChar() method.

---

## Other Uses of Wrapper Classes

### 1. Constants:
```java
// MAX and MIN values for primitives
System.out.println(Integer.MAX_VALUE);  // 2147483647
System.out.println(Integer.MIN_VALUE);  // -2147483648
System.out.println(Double.MAX_VALUE);   // 1.7976931348623157E308
```

### 2. Type Information:
```java
System.out.println(Integer.TYPE);    // int
System.out.println(Integer.SIZE);    // 32 (bits)
System.out.println(Integer.BYTES);   // 4 (Java 8+)
```

### 3. Conversion Methods:
```java
// Binary, Octal, Hex representation
System.out.println(Integer.toBinaryString(10));  // "1010"
System.out.println(Integer.toOctalString(10));   // "12"
System.out.println(Integer.toHexString(10));     // "a"

// Reverse parsing
int num = Integer.parseInt("1010", 2);  // Binary to int → 10
int num2 = Integer.parseInt("a", 16);   // Hex to int → 10
```

### 4. Comparison:
```java
Integer a = 100;
Integer b = 200;
System.out.println(Integer.compare(a, b));  // -1 (a < b)
System.out.println(a.compareTo(b));         // -1
```

---

## Code Examples with Flow

### Complete Autoboxing/Unboxing Flow:

```java
public class AutoboxingFlow
{
    public static void main(String args[])
    {
        // AUTOBOXING examples
        Integer i1 = 100;        // int → Integer
        Double d1 = 3.14;        // double → Double
        Boolean b1 = true;       // boolean → Boolean
        
        // UNBOXING examples
        int i2 = i1;             // Integer → int
        double d2 = d1;          // Double → double
        boolean b2 = b1;         // Boolean → boolean
        
        // Mixed operations - automatic conversion
        Integer sum = i1 + 50;   // Unbox i1, add 50, autobox result
        
        // Collections with Autoboxing
        ArrayList<Integer> list = new ArrayList<>();
        list.add(10);            // Autoboxing: int → Integer
        list.add(20);            // Autoboxing: int → Integer
        
        int first = list.get(0); // Unboxing: Integer → int
    }
}
```

### Execution Flow for Mixed Operations:
```
Expression: Integer sum = i1 + 50;

Step 1: i1 + 50
        ├── i1 is Integer object
        ├── Unbox i1: i1.intValue() → 100
        └── 100 + 50 = 150 (primitive int)

Step 2: Integer sum = 150
        └── Autobox 150: new Integer(150)

Result: sum refers to Integer object containing 150
```

### Memory Visualization:
```
┌────────────────────────────────────────────────────────────────────┐
│                           HEAP MEMORY                              │
│                                                                    │
│   ┌─────────────┐    ┌─────────────┐    ┌─────────────┐           │
│   │ Integer     │    │ Integer     │    │ Integer     │           │
│   │ value: 100  │    │ value: 150  │    │ value: 20   │           │
│   └─────────────┘    └─────────────┘    └─────────────┘           │
│         ▲                  ▲                  ▲                    │
│         │                  │                  │                    │
│        i1                 sum            list.get(1)               │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────────────┐
│                           STACK MEMORY                             │
│                                                                    │
│   i2 = 100 (primitive)                                             │
│   d2 = 3.14 (primitive)                                            │
│   first = 10 (primitive)                                           │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Key Takeaways

1. **Wrapper classes** wrap primitives in objects
2. **All 8 primitives** have corresponding wrapper classes
3. **Autoboxing** (JDK 5) - automatic primitive to wrapper conversion
4. **Unboxing** (JDK 5) - automatic wrapper to primitive conversion
5. **Syntactic sugar** - compiler converts autoboxing/unboxing to explicit code
6. **parse methods** - convert String to primitive
7. **Wrappers are immutable** - cannot change wrapped value
8. **Wrappers are final** - cannot be subclassed
9. **Collections require wrappers** - cannot store primitives directly

---

*Previous: [02_StringBuilder_and_Mutability.md](./02_StringBuilder_and_Mutability.md)*
*Next: [04_Enums_in_Java.md](./04_Enums_in_Java.md)*
