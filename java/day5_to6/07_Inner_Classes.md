# 📚 Inner Classes in Java - Complete Guide

## Table of Contents
1. [Introduction to Nested Classes](#introduction-to-nested-classes)
2. [Types of Nested Classes](#types-of-nested-classes)
3. [Static Nested Classes](#static-nested-classes)
4. [Non-Static Inner Classes](#non-static-inner-classes)
5. [Local Inner Classes](#local-inner-classes)
6. [Anonymous Inner Classes](#anonymous-inner-classes)
7. [What Compiler Does Internally](#what-compiler-does-internally)
8. [Access Specifiers for Classes](#access-specifiers-for-classes)
9. [Applications of Inner Classes](#applications-of-inner-classes)
10. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Nested Classes

A **nested class** is a class defined within another class. Nested classes provide:
- **Easy maintenance** - Related classes grouped together
- **Encapsulation** - Inner class can access private members of outer class
- **Logical grouping** - Helper classes near where they're used

---

## Types of Nested Classes

```
┌────────────────────────────────────────────────────────────────────┐
│                      NESTED CLASSES                                │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  1. STATIC NESTED CLASS                                            │
│     - Declared with 'static' keyword                               │
│     - Can only access static members of outer class                │
│                                                                    │
│  2. NON-STATIC INNER CLASS (Member Inner Class)                    │
│     - Without 'static' keyword                                     │
│     - Can access all members (static + non-static) of outer class  │
│                                                                    │
│  3. LOCAL INNER CLASS                                              │
│     - Defined inside a method                                      │
│     - Scope limited to that method                                 │
│                                                                    │
│  4. ANONYMOUS INNER CLASS                                          │
│     - No name, defined and instantiated together                   │
│     - Used for one-time implementation                             │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

### Terminology:
```java
Nested classes are divided into two categories:

1. STATIC nested classes    → Declared static (called "static nested class")
2. NON-STATIC nested classes → Called "inner classes"

Classes defined inside a METHOD are called "Local Inner Classes"
```

---

## Static Nested Classes

A **static nested class** is declared with the `static` keyword and can only access **static members** of the outer class.

### Code Example: Demo.java (Static Nested Class)
```java
class Outer
{
    // Line 3-6: Instance variables (non-static)
    private int num1 = 10;
    int num2 = 20;
    protected int num3 = 30;
    public int num4 = 40;
    
    // Line 8: Static variable
    static int num5 = 50;

    // Line 10-13: Static block of outer class
    static
    {
        System.out.println("in Outer static block");
    }
    
    // Line 15-18: Instance method
    void outerDisp()
    {
        System.out.println(num1 + "\t" + num2 + "\t" + num3 + "\t" + num4);
    }

    // Line 20-29: STATIC NESTED CLASS
    static class inner
    {
        void innerDisp()
        {
            // Can only access STATIC members of outer class
            System.out.println(num5);  // ✓ OK - static
            // System.out.println(num1); // ✗ Error - non-static
        }
        
        static
        {
            System.out.println("in inner static block");
        }
    }
}

public class Demo
{
    public static void main(String args[])
    {
        System.out.println("before creating Outer object");
        
        // Line 38: Create outer object
        Outer o1 = new Outer();
        
        System.out.println("before creating inner object");
        
        // Line 41: Create static nested class object
        // Syntax: OuterClass.InnerClass obj = new OuterClass.InnerClass();
        Outer.inner i = new Outer.inner();
        
        o1.outerDisp();
        i.innerDisp();
    }
}
```

### Execution Flow:
```
Step 1: "before creating Outer object" printed

Step 2: new Outer() - Outer class loads
        → "in Outer static block" printed
        → Outer object created

Step 3: "before creating inner object" printed

Step 4: new Outer.inner() - inner class loads
        → "in inner static block" printed
        → inner object created

Step 5: o1.outerDisp() → 10  20  30  40
Step 6: i.innerDisp()  → 50
```

### Key Points for Static Nested Class:
- Created using: `new OuterClass.InnerClass()`
- Does NOT need outer class instance
- Can only access static members of outer class
- Can have its own static members and static blocks

---

## Non-Static Inner Classes

A **non-static inner class** (member inner class) has access to **all members** of the outer class, including private and non-static.

### Code Example: Outer.java (Non-Static Inner Class)
```java
public class Outer
{
    // Line 3: Instance variable
    int num1 = 20;
    
    // Line 4-7: Instance method
    void disp1()
    {
        System.out.println("in disp1");
    }
    
    // Line 8-13: Constructor
    Outer()
    {
        System.out.println("in Outer def const");
    }
    
    // Line 14-17: Static block
    static 
    {
        System.out.println("in outer static block");
    }
    
    // Line 18-35: NON-STATIC INNER CLASS
    class inner
    {
        int num2 = 30;
        final int num3 = 60; 
        static final int num4 = 90;    // Only static final allowed
        static int num5 = 120;         // Java 16+ allows this
        
        void disp2()
        {
            System.out.println("in disp2\t" + num2);
            System.out.println("in disp2\t" + num3);
            System.out.println("in disp2\t" + num4);
            System.out.println("in disp2\t" + num5);
            
            // Can access outer class members directly!
            disp1();  // Calls outer's disp1()
        }
        
        static 
        {
            System.out.println("in inner static block");
        }
    }
    
    public static void main(String args[])
    {
        // Line 39: Create outer object first
        Outer o = new Outer();
        System.out.println(o.num1);
        o.disp1();
        
        // Line 42-43: Create inner object - NEEDS outer object
        // Syntax: OuterClass.InnerClass obj = outerRef.new InnerClass();
        Outer.inner i = o.new inner();
        i.disp2();
    }
}
```

### Execution Flow:
```
Step 1: Outer class loads
        → "in outer static block" printed

Step 2: new Outer()
        → "in Outer def const" printed

Step 3: o.num1 → 20
Step 4: o.disp1() → "in disp1"

Step 5: o.new inner() - inner class created
        → "in inner static block" printed
        
Step 6: i.disp2() prints:
        in disp2    30
        in disp2    60
        in disp2    90
        in disp2    120
        in disp1
```

### Key Points for Non-Static Inner Class:
- Created using: `outerRef.new InnerClass()`
- REQUIRES outer class instance
- Can access ALL members of outer class (including private)
- Has implicit reference to outer class object

---

## What Compiler Does Internally

When you create an inner class object:
```java
Outer.inner i = o.new inner();
```

### Compiler's Actions:
```
When inner class gets instantiated, compiler puts a reference 
of "Outer" class inside inner class object.

WHY?
  Because even though they are "outer" and "inner" classes 
  for a developer, for JVM these are DIFFERENT classes altogether.

HOW?
  Compiler adds a parameterized constructor accepting "outer" 
  class reference inside "inner" class and discards all other 
  available constructors.
```

### Generated Code (Conceptually):
```java
// Original inner class
class Outer$inner
{
    // Compiler adds this reference
    final Outer this$0;  // Reference to outer object
    
    // Compiler adds this constructor
    Outer$inner(Outer outer)
    {
        this.this$0 = outer;
    }
    
    void disp2()
    {
        // Access outer.disp1() through this$0
        this$0.disp1();
    }
}
```

---

## Local Inner Classes

**Local inner classes** are defined inside a method. Their scope is limited to that method only.

```java
public class LocalInnerDemo
{
    void method()
    {
        final int localVar = 100;  // Must be final or effectively final
        
        // Local inner class - defined inside method
        class LocalInner
        {
            void display()
            {
                System.out.println("Local variable: " + localVar);
            }
        }
        
        // Create and use within the method
        LocalInner local = new LocalInner();
        local.display();
    }
    
    public static void main(String args[])
    {
        new LocalInnerDemo().method();
    }
}
```

### Key Points:
- Defined inside a method
- Scope limited to that method
- Can access final or effectively final local variables
- Cannot have static declarations

---

## Anonymous Inner Classes

**Anonymous inner classes** are classes without a name, defined and instantiated together. Used for one-time implementations.

### Code Example: AnonymousDemo.java
```java
// Line 1-4: Interface to implement
interface emp
{
    void disp();
}

public class AnonymousDemo
{
    // Line 7-16: Method returning emp implementation
    static emp getEmp()
    {
        // Lines 9-15: Anonymous inner class
        // Implements 'emp' interface on the fly
        return new emp()  // Creating anonymous class
        {
            public void disp()
            {
                System.out.println("in disp");
            }
        };  // Note the semicolon - this is a statement
    }
    
    public static void main(String args[])
    {
        // Line 30: Get instance of anonymous class
        emp e1 = AnonymousDemo.getEmp();
        
        // Line 31: Call method
        e1.disp();  // Output: in disp
    }
}
```

### Alternative Syntax:
```java
static emp getEmp()
{
    // Create anonymous class and store in variable
    emp e = new emp()
    {
        public void disp()
        {
            System.out.println("in disp diff way");
        }
    };
    return e;
}
```

### Execution Flow:
```
Step 1: AnonymousDemo.getEmp() called

Step 2: new emp() { ... }
        ├── Creates anonymous class implementing emp
        ├── Instantiates that class
        └── Returns the instance

Step 3: e1.disp() calls the disp() method of anonymous class
        Output: in disp
```

### Use Cases for Anonymous Classes:
- Event handlers (button clicks, etc.)
- Callbacks
- One-time interface implementations
- Thread creation

---

## Access Specifiers for Classes

### Top-Level Classes:
```
Top level classes (not nested) can be:
  ✓ public
  ✓ default (package-private)

Top level classes CANNOT be:
  ✗ private   (would be useless - no one can access)
  ✗ protected (only makes sense for inheritance, not class visibility)
```

### Nested Classes:
```
Nested classes can have ALL access modifiers:
  ✓ public
  ✓ protected
  ✓ default
  ✓ private
```

---

## Applications of Inner Classes

### Why Use Inner Classes?

**Problem - Without Inner Classes:**
```java
// All interfaces implemented in ONE class - messy!
public class GUIAPP extends Applet implements MouseListener, WindowListener, KeyListener
{
    // MouseListener's 5 methods
    // WindowListener's 7 methods
    // KeyListener's 4 methods
    
    + GUI logic
    
    // 16+ methods in one class!
}
```

**Solution - With Inner Classes:**
```java
public class GUIAPP extends Applet 
{
    // Clean GUI logic here
    
    // Separate inner class for each listener
    class MyMouseListener implements MouseListener
    {
        // 5 methods
    }
    
    class MyWindowListener implements WindowListener
    {
        // 7 methods
    }
    
    class MyKeyListener implements KeyListener
    {
        // 4 methods
    }
}
```

### Benefits:
1. **Better organization** - Related code grouped together
2. **Encapsulation** - Inner class can be private
3. **Access to outer class** - Can access private members
4. **Logical grouping** - Helper classes near usage

---

## Code Examples with Flow

### Complete Comparison:

```java
public class InnerClassesDemo
{
    private int outerPrivate = 10;
    static int outerStatic = 20;
    
    // 1. Static Nested Class
    static class StaticNested
    {
        void show()
        {
            // System.out.println(outerPrivate); // ✗ Cannot access
            System.out.println(outerStatic);     // ✓ Can access
        }
    }
    
    // 2. Non-Static Inner Class
    class MemberInner
    {
        void show()
        {
            System.out.println(outerPrivate);    // ✓ Can access
            System.out.println(outerStatic);     // ✓ Can access
        }
    }
    
    void method()
    {
        final int localVar = 30;
        
        // 3. Local Inner Class
        class LocalInner
        {
            void show()
            {
                System.out.println(outerPrivate);  // ✓ Can access
                System.out.println(localVar);       // ✓ Can access (final)
            }
        }
        
        new LocalInner().show();
    }
    
    public static void main(String args[])
    {
        // Static nested - no outer instance needed
        StaticNested sn = new StaticNested();
        sn.show();
        
        // Member inner - needs outer instance
        InnerClassesDemo outer = new InnerClassesDemo();
        MemberInner mi = outer.new MemberInner();
        mi.show();
        
        // Local inner - only inside method
        outer.method();
        
        // 4. Anonymous inner - inline
        Runnable r = new Runnable()
        {
            public void run()
            {
                System.out.println("Anonymous inner class");
            }
        };
        r.run();
    }
}
```

### Summary Table:

| Type | Syntax to Create | Access to Outer | Static Members |
|------|------------------|-----------------|----------------|
| Static Nested | `new Outer.Inner()` | Static only | Allowed |
| Member Inner | `outer.new Inner()` | All members | Only static final |
| Local Inner | Inside method | All + final locals | Not allowed |
| Anonymous | `new Type() { }` | All + final locals | Not allowed |

---

## Key Takeaways

1. **Static nested class** - No outer instance needed, static access only
2. **Non-static inner class** - Requires outer instance, full access
3. **Local inner class** - Defined in method, limited scope
4. **Anonymous inner class** - No name, one-time use
5. **Compiler adds outer reference** to non-static inner classes
6. **Inner classes** can be private, protected, default, or public
7. **Top-level classes** can only be public or default

---

*Previous: [06_Overloading_Rules.md](./06_Overloading_Rules.md)*
*Next: [08_Garbage_Collection.md](./08_Garbage_Collection.md)*
