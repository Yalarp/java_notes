# 📚 Overloading Rules with Widening, Boxing, and Varargs

## Table of Contents
1. [Introduction to Method Resolution](#introduction-to-method-resolution)
2. [Widening (Primitive Type Promotion)](#widening-primitive-type-promotion)
3. [Boxing (Autoboxing in Method Calls)](#boxing-autoboxing-in-method-calls)
4. [Varargs in Overloading](#varargs-in-overloading)
5. [Priority Rules](#priority-rules)
6. [Combined Scenarios](#combined-scenarios)
7. [Complete Rules Summary](#complete-rules-summary)
8. [Code Examples with Flow](#code-examples-with-flow)

---

## Introduction to Method Resolution

When you call an overloaded method, the compiler must decide which version to invoke. The resolution follows a **priority order**:

```
┌─────────────────────────────────────────────────────────┐
│               METHOD RESOLUTION PRIORITY                 │
├─────────────────────────────────────────────────────────┤
│  1. Exact Match (highest priority)                      │
│  2. Widening (primitive promotion)                      │
│  3. Boxing (autoboxing)                                 │
│  4. Varargs (lowest priority)                           │
└─────────────────────────────────────────────────────────┘
```

---

## Widening (Primitive Type Promotion)

**Widening** is automatic conversion from smaller primitive type to larger compatible type.

### Widening Hierarchy:
```
byte → short → int → long → float → double
              ↑
             char
```

### Code Example: Test1.java
```java
package core1;

public class Test1
{
    // Line 4-7: Method accepting int
    static void disp(int x)
    {
        System.out.println("in int");
    }
    
    // Line 8-11: Method accepting short
    static void disp(short y)
    {
        System.out.println("in short");
    }
    
    public static void main(String args[])
    {
        // Line 14: byte variable
        byte b = 30;
        
        // Line 15: Which method is called?
        disp(b);  // byte can widen to both short and int
    }
}

/*
Output: in short

Explanation:
  Primitive widening uses the "SMALLEST" method argument possible.
  
  byte → short (smaller jump) ✓ WINS
  byte → int   (larger jump)
*/
```

### Execution Flow:
```
Step 1: byte b = 30

Step 2: disp(b) called
        ├── Check exact match: disp(byte)? NO
        ├── Check widening options:
        │   ├── byte → short ✓ (1 step)
        │   └── byte → int   ✓ (2 steps)
        └── Choose SMALLEST: disp(short) WINS

Output: in short
```

---

## Boxing (Autoboxing in Method Calls)

**Boxing** converts primitive to its wrapper class (int → Integer).

### Code Example: Test2.java
```java
package core1;

public class Test2
{
    // Line 4-7: Method accepting Integer (wrapper)
    static void disp(Integer x)
    {
        System.out.println("in Integer");
    }
    
    // Line 8-11: Method accepting int (primitive)
    static void disp(int x)
    {
        System.out.println("in int");
    }
    
    public static void main(String args[])
    {
        int num = 5;
        disp(num);  // Which method?
    }
}

/*
Output: in int

Explanation:
  Exact match (int → int) is preferred over boxing (int → Integer).
  "Boxing has taken a back seat"
*/
```

---

## Priority: Widening Beats Boxing

### Code Example: Test3.java
```java
package core1;

public class Test3
{
    // Line 4-7: Method accepting Integer (wrapper)
    static void disp(Integer x)
    {
        System.out.println("in Integer");
    }
    
    // Line 8-11: Method accepting long (widened primitive)
    static void disp(long x)
    {
        System.out.println("in long");
    }
    
    public static void main(String args[])
    {
        int num = 5;
        disp(num);  // int can widen to long OR box to Integer
    }
}

/*
Output: in long

Explanation:
  WIDENING beats BOXING
  
  int → long    (widening) ✓ WINS
  int → Integer (boxing)   
*/
```

### Flow Diagram:
```
┌─────────────────────────────────────────────────────────┐
│                 disp(int num) called                    │
│                                                         │
│  Option 1: Widening                                     │
│  int → long ───────────────────────► disp(long) ✓ WINS │
│                                                         │
│  Option 2: Boxing                                       │
│  int → Integer ─────────────────────► disp(Integer)    │
│                                                         │
│  WIDENING has HIGHER priority than BOXING              │
└─────────────────────────────────────────────────────────┘
```

---

## Priority: Widening Beats Varargs

### Code Example: (Widening vs Varargs)
```java
class A
{
    // Fixed parameter method
    void disp(int x, int y)
    {
        System.out.println("in two ints");
    }
    
    // Varargs method
    void disp(byte ...x)
    {
        System.out.println("in byte var arg");
    }
    
    public static void main(String args[])
    {
        byte a = 3, b = 6;
        new A().disp(a, b);  // Which method?
    }
}

/*
Output: in two ints

Explanation:
  Compiler chooses OLD STYLE (fixed parameters) over varargs.
  byte,byte → int,int (widening) ✓ WINS
  byte,byte → byte... (varargs)
*/
```

---

## Priority: Boxing Beats Varargs

### Code Example: (Boxing vs Varargs)
```java
class A
{
    // Boxing method
    void disp(Byte x, Byte y)
    {
        System.out.println("in two Bytes");
    }
    
    // Varargs method
    void disp(byte ...x)
    {
        System.out.println("in byte var arg");
    }
    
    public static void main(String args[])
    {
        byte a = 3, b = 6;
        new A().disp(a, b);  // Which method?
    }
}

/*
Output: in two Bytes

Explanation:
  BOXING beats VARARGS
  byte,byte → Byte,Byte (boxing) ✓ WINS
  byte,byte → byte...   (varargs)
*/
```

---

## Combined Scenarios

### Cannot Widen from Wrapper to Wrapper

```java
void disp(Long x)
{
    System.out.println("in Long");
}

disp(new Integer(4));  // ✗ Error!

/*
Explanation:
  Wrapper classes are "peers" - no IS-A relationship.
  Integer is NOT-A Long
  There is NO widening between wrapper types.
*/
```

### Cannot Widen Then Box

```java
void disp(Long x)
{
    System.out.println("in Long");
}

byte b = 4;
disp(b);  // ✗ Error!

/*
Explanation:
  Compiler CANNOT do:
  byte → long (widening) → Long (boxing)
  
  "An int can't become Long"
*/
```

### CAN Box Then Widen

```java
void disp(Object o)
{
    System.out.println("in Object");
}

byte b = 4;
disp(b);  // ✓ Works!

/*
Explanation:
  Compiler CAN do:
  byte → Byte (boxing) → Object (widening/upcasting)
  
  Byte IS-A Object (inheritance relationship)
*/
```

### Flow:
```
byte b = 4;
disp(b);

Step 1: Boxing
        byte → Byte

Step 2: Widening (upcasting)
        Byte → Object

disp(Object) is called with Byte object
```

---

## Varargs Ambiguity

### Cannot Combine Varargs with Both Widening and Boxing

```java
void disp(long ...x)
{
    System.out.println("in long var args");
}

void disp(Integer ...y)
{
    System.out.println("in Integer var args");
}

int p = 20, q = 30;
disp(p, q);  // ✗ Compilation Error - AMBIGUOUS!

/*
Explanation:
  When combining varargs, you CANNOT have both widening and boxing options.
  
  int,int → long... (varargs with widening)
  int,int → Integer... (varargs with boxing)
  
  Both are equally valid → AMBIGUITY!
*/
```

---

## Complete Rules Summary

### Rules for Overloading with Widening, Boxing, and Varargs:

| Rule | Description |
|------|-------------|
| **Rule 1** | Primitive widening uses the "smallest" method argument possible |
| **Rule 2** | Used individually, boxing and varargs are compatible with overloading |
| **Rule 3** | You CANNOT widen from one wrapper type to another (IS-A fails) |
| **Rule 4** | You CANNOT widen and then box (int can't become Long) |
| **Rule 5** | You CAN box and then widen (int → Integer → Object) |
| **Rule 6** | You CAN combine varargs with either widening OR boxing, but NOT both |

### Priority Order:

```
┌──────────────────────────────────────────────────────────────────┐
│                   PRIORITY ORDER (High to Low)                   │
├──────────────────────────────────────────────────────────────────┤
│  1. EXACT MATCH      →  disp(int) when passing int              │
│  2. WIDENING         →  disp(long) when passing int             │
│  3. BOXING           →  disp(Integer) when passing int          │
│  4. VARARGS          →  disp(int...) when passing int           │
├──────────────────────────────────────────────────────────────────┤
│  Summary:  WIDENING > BOXING > VARARGS                           │
└──────────────────────────────────────────────────────────────────┘
```

---

## Code Examples with Flow

### All Test Cases Together:

```java
public class OverloadingComplete
{
    static void show(int x)      { System.out.println("int"); }
    static void show(long x)     { System.out.println("long"); }
    static void show(Integer x)  { System.out.println("Integer"); }
    static void show(int ...x)   { System.out.println("int varargs"); }
    
    public static void main(String args[])
    {
        int i = 10;
        byte b = 5;
        Integer ob = 20;
        
        show(i);    // Output: int       (exact match)
        show(b);    // Output: int       (widening: byte → int)
        show(ob);   // Output: Integer   (exact match for wrapper)
        show();     // Output: int varargs (only varargs matches 0 args)
        show(1,2);  // Output: int varargs (only varargs matches multiple args)
    }
}
```

### Decision Tree:
```
                    disp(argument)
                          │
                          ▼
                  ┌──────────────┐
                  │ Exact Match? │
                  └──────┬───────┘
                    YES  │  NO
                    ▼    │
                 CALL    ▼
                      ┌──────────────┐
                      │ Widening?    │
                      └──────┬───────┘
                        YES  │  NO
                        ▼    │
                     CALL    ▼
                          ┌──────────────┐
                          │ Boxing?      │
                          └──────┬───────┘
                            YES  │  NO
                            ▼    │
                         CALL    ▼
                              ┌──────────────┐
                              │ Varargs?     │
                              └──────┬───────┘
                                YES  │  NO
                                ▼    ▼
                             CALL  ERROR
```

---

## Key Takeaways

1. **Priority**: Widening > Boxing > Varargs
2. **Widening uses smallest type** for ambiguous cases
3. **Cannot widen between wrappers** (Integer ≠ Long)
4. **Cannot widen then box** (byte → Long NOT allowed)
5. **Can box then widen** (byte → Byte → Object)
6. **Varargs has lowest priority**
7. **Avoid ambiguity** with careful method design

---

*Previous: [05_Varargs_Variable_Arguments.md](./05_Varargs_Variable_Arguments.md)*
*Next: [07_Inner_Classes.md](./07_Inner_Classes.md)*
