# 📚 Java Generics - Complete Guide (Basic to Advanced)

## Table of Contents
1. [Introduction to Generics](#introduction-to-generics)
2. [Why Generics?](#why-generics)
3. [Type Safety Before and After Java 5](#type-safety-before-and-after-java-5)
4. [Generic Classes](#generic-classes)
5. [Generic Methods](#generic-methods)
6. [Bounded Type Parameters](#bounded-type-parameters)
7. [Wildcards](#wildcards)
8. [Type Erasure](#type-erasure)
9. [Polymorphism and Generics](#polymorphism-and-generics)
10. [Common Pitfalls and Best Practices](#common-pitfalls-and-best-practices)
11. [Interview Questions](#interview-questions)

---

## 🎯 Introduction to Generics

**Generics** were introduced in **Java 5 (JDK 1.5)** to provide compile-time type safety. They allow you to write code that works with different types while catching type errors at compile time rather than runtime.

> [!IMPORTANT]
> Generics are a **compiler-level feature**. The JVM does not understand generics - all generic type information is removed during compilation through a process called **Type Erasure**.

### Before Java 5 (Non-Generic Era)
```java
List mylist = new ArrayList();  // Raw type - no type safety
```

### After Java 5 (Generic Era)
```java
List<String> mylist = new ArrayList<String>();  // Type-safe
```

---

## 🤔 Why Generics?

### Problems Before Generics

```java
// PROBLEM CODE - Before Java 5
// =============================

public class StorageClass {
    // Line 1: Instance variable of type Object (can hold any type)
    private Object ref;
    
    // Line 2-4: store() method accepts any Object
    public void store(Object ref) {
        this.ref = ref;  // Stores the reference
    }
    
    // Line 5-7: get() method returns Object (requires casting)
    public Object get() {
        return ref;  // Returns as Object type
    }
}

// USAGE:
StorageClass s = new StorageClass();  // Line 8: Create instance
s.store(100);                          // Line 9: Store Integer (autoboxed)
Integer ref1 = (Integer) s.get();      // Line 10: MUST cast - risk of ClassCastException!
```

### 🔴 The Risk Explained

```java
// DANGEROUS SCENARIO
// ==================

StorageClass s = new StorageClass();
s.store("hello");                      // Storing a String

// Later in code (maybe different developer or different file):
Integer ref1 = (Integer) s.get();      // COMPILES but CRASHES at runtime!
// ⚠️ ClassCastException: String cannot be cast to Integer
```

**Why is this dangerous?**
- Compiler allows this code (syntactically correct)
- Error only discovered at **RUNTIME** (ClassCastException)
- Very hard to debug in large applications

---

## 🔒 Type Safety Before and After Java 5

### Before Java 5 - Collection Without Generics

```java
// FILE: Before Java 5 - No Type Safety
// =====================================

import java.util.*;  // Line 1: Import utilities

public class OldStyleDemo {
    public static void main(String args[]) {
        
        // Line 2: Create ArrayList WITHOUT type parameter (raw type)
        List mylist = new ArrayList();
        
        // Lines 3-5: add() method accepts java.lang.Object
        // So ANY type can be added - NO compile-time check!
        mylist.add(new Integer(100));  // Adding Integer
        mylist.add("hello");            // Adding String - ALLOWED!
        mylist.add(new Double(3.4));    // Adding Double - ALLOWED!
        
        // Line 6: Retrieving element - MUST cast
        // get() returns Object, so casting is mandatory
        String str = (String) mylist.get(1);  // Cast needed
        
        // ⚠️ RISK: What if position 1 had Integer instead?
        // String str = (String) mylist.get(0);  // ClassCastException!
    }
}
```

**Flow Explanation:**
```
┌─────────────────────────────────────────────────────────────────┐
│ WITHOUT GENERICS                                                 │
├─────────────────────────────────────────────────────────────────┤
│  mylist.add(anything) ──► Object accepted ──► No compiler check │
│         ↓                                                        │
│  mylist.get(index) ──► Returns Object ──► MUST cast              │
│         ↓                                                        │
│  Wrong cast ──► ClassCastException at RUNTIME ❌                 │
└─────────────────────────────────────────────────────────────────┘
```

### After Java 5 - Collection With Generics

```java
// FILE: With Generics - Type Safe
// ================================

import java.util.*;  // Line 1: Import utilities

public class NewStyleDemo {
    public static void main(String args[]) {
        
        // Line 2: Create ArrayList WITH type parameter <String>
        // Now compiler knows this list is ONLY for Strings
        List<String> mylist = new ArrayList<String>();
        
        // Line 3-4: Only String can be added
        mylist.add("hello");     // ✓ Allowed - String
        mylist.add("welcome");   // ✓ Allowed - String
        
        // Line 5: This would cause COMPILATION ERROR!
        // mylist.add(100);      // ✗ ERROR: Integer is not String
        
        // Line 6: No casting needed - compiler knows type
        String str = mylist.get(1);  // Returns String directly!
        
        // Line 7: This would cause COMPILATION ERROR!
        // Integer ob = mylist.get(0);  // ✗ ERROR at compile time
    }
}
```

**Flow Explanation:**
```
┌─────────────────────────────────────────────────────────────────┐
│ WITH GENERICS                                                    │
├─────────────────────────────────────────────────────────────────┤
│  List<String> ──► Compiler knows type is String                 │
│         ↓                                                        │
│  add(wrongType) ──► COMPILATION ERROR ✓ (Caught early!)         │
│         ↓                                                        │
│  get(index) ──► Returns String ──► NO casting needed            │
│         ↓                                                        │
│  Assign to wrong type ──► COMPILATION ERROR ✓                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Generic Classes

### Creating a Simple Generic Class

```java
// FILE: Generic1.java
// ====================

import static java.lang.System.*;  // Line 1: Static import for System.out

// Line 2: Generic class declaration
// <T> is a TYPE PARAMETER (placeholder for actual type)
// T stands for "Type" - it's just a convention
public class Generic1<T> {
    
    // Line 3: Instance variable of generic type T
    // Actual type will be determined when object is created
    private T first;
    
    // Line 4-6: Setter method accepts type T
    void setVal(T first) {
        this.first = first;  // Assigns the value
    }
    
    // Line 7-9: Getter method returns type T
    T getVal() {
        return first;  // Returns the stored value
    }
    
    // Line 10: Main method for testing
    public static void main(String args[]) {
        
        // Line 11: Create Generic1 for String
        // <String> replaces T with String throughout the class
        Generic1<String> g1 = new Generic1<String>();
        g1.setVal("Hello Generic");  // Line 12: Sets String value
        out.println(g1.getVal());     // Line 13: Output: Hello Generic
        
        // Line 14: Create Generic1 for Integer
        // <Integer> replaces T with Integer
        Generic1<Integer> g2 = new Generic1<Integer>();
        g2.setVal(420);               // Line 15: Sets Integer value
        out.println(g2.getVal());     // Line 16: Output: 420
        
        // Line 17: Create Generic1 for Boolean
        Generic1<Boolean> g3 = new Generic1<Boolean>();
        g3.setVal(true);              // Line 18: Sets Boolean value
        out.println(g3.getVal());     // Line 19: Output: true
    }
}
```

**Flow Diagram:**
```
┌────────────────────────────────────────────────────────────────────┐
│ Generic1<T> - Template Class                                       │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Generic1<String>     Generic1<Integer>    Generic1<Boolean>       │
│       ↓                    ↓                    ↓                   │
│  T = String           T = Integer          T = Boolean             │
│  setVal(String)       setVal(Integer)      setVal(Boolean)         │
│  getVal():String      getVal():Integer     getVal():Boolean        │
│                                                                     │
│  ┌──────────┐        ┌──────────┐         ┌──────────┐             │
│  │ "Hello"  │        │   420    │         │   true   │             │
│  └──────────┘        └──────────┘         └──────────┘             │
└────────────────────────────────────────────────────────────────────┘
```

### Generic Class with Multiple Type Parameters

```java
// FILE: MultiTypeGeneric.java
// ===========================

// Line 1: Class with TWO type parameters A and B
class Gen<A, B> {
    
    A a;  // Line 2: First type parameter
    B b;  // Line 3: Second type parameter
    
    // Line 4-7: Constructor accepting both types
    Gen(A a, B b) {
        this.a = a;  // Assign first value
        this.b = b;  // Assign second value
    }
    
    // Line 8-10: Getter for first type
    A giveA() {
        return a;
    }
    
    // Line 11-13: Getter for second type
    B giveB() {
        return b;
    }
}

public class trial {
    
    // Line 14: Custom toString for demonstration
    public String toString() {
        return "i am trial";
    }
    
    public static void main(String args[]) {
        
        // Line 15: Create Gen with Integer and Float
        Gen<Integer, Float> g = new Gen<Integer, Float>(20, 5.6f);
        System.out.println(g.giveA());  // Line 16: Output: 20
        System.out.println(g.giveB());  // Line 17: Output: 5.6
        
        // Line 18: Create with custom class and Boolean
        trial t = new trial();
        Gen<trial, Boolean> g1 = new Gen<trial, Boolean>(t, true);
        System.out.println(g1.giveA()); // Line 19: Output: i am trial
        System.out.println(g1.giveB()); // Line 20: Output: true
    }
}
```

---

## 🔧 Generic Methods

You can create generic methods even in non-generic classes.

```java
// FILE: Generic4.java - Generic Methods
// =====================================

class a {}                    // Line 1: Base class
class b extends a {}          // Line 2: Subclass of a

class MyClass {
    
    // Line 3-5: Generic method that accepts ANY type
    // <T> before return type declares type parameter for this method
    <T> void accept(T t) {
        System.out.println(t);  // Prints any object using toString()
    }
    
    // Line 6-8: Bounded generic method
    // <T extends a> means T must be class 'a' or its subclass
    public <T extends a> void disp(T t) {
        System.out.println(t);  // Only accepts 'a' or its children
    }
}

public class Generic4 {
    public static void main(String args[]) {
        
        MyClass m1 = new MyClass();  // Line 9: Create instance
        
        // Line 10: accept() with Integer (autoboxed)
        m1.accept(20);        // Output: 20
        
        // Line 11: accept() with MyClass object
        m1.accept(m1);        // Output: MyClass@hashcode
        
        // Line 12: accept() with Generic4 object
        Generic4 tr = new Generic4();
        m1.accept(tr);        // Output: Generic4@hashcode
        
        // Line 13: disp() with class 'b' (subclass of 'a')
        b ob = new b();
        m1.disp(ob);          // ✓ Works - 'b' extends 'a'
        
        // Line 14: This would cause COMPILATION ERROR!
        // m1.disp(tr);       // ✗ ERROR: Generic4 doesn't extend 'a'
    }
}
```

**Method Flow:**
```
┌──────────────────────────────────────────────────────────────────┐
│ Generic Method: <T> void accept(T t)                             │
├──────────────────────────────────────────────────────────────────┤
│ accept(20) → T=Integer → prints 20                               │
│ accept(m1) → T=MyClass → prints MyClass@hash                     │
│ accept(tr) → T=Generic4 → prints Generic4@hash                   │
│                                                                   │
│ ✓ Accepts ANY type                                               │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│ Bounded Method: <T extends a> void disp(T t)                     │
├──────────────────────────────────────────────────────────────────┤
│ disp(ob) → T=b (b extends a) → ✓ Allowed                        │
│ disp(tr) → T=Generic4 (NOT extends a) → ✗ COMPILE ERROR         │
│                                                                   │
│ ⚠️ Only accepts 'a' or subclasses of 'a'                        │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔒 Bounded Type Parameters

When you want to restrict what types can be used with a generic class.

```java
// FILE: Generic3.java - Bounded Type Parameters
// ==============================================

import static java.lang.System.*;
import java.util.*;

// Line 1-5: Base class 'shape'
class shape {
    shape draw() {
        return this;  // Returns itself
    }
}

// Line 6-10: triangle extends shape
class triangle extends shape {
    shape draw() {
        return this;  // Overridden draw method
    }
}

// Line 11-15: rect extends shape
class rect extends shape {
    shape draw() {
        return this;  // Overridden draw method
    }
}

// Line 16-22: Bounded Generic Class
// <T extends shape> - T MUST be shape or its subclass
class common<T extends shape> {
    T ob;  // Can only be shape or subclass
    
    public common(T ob) {
        this.ob = ob;  // Store the object
    }
    
    public T fun() {
        return ob;  // Return the object
    }
}

public class Generic3 {
    public static void main(String args[]) {
        
        // Line 23: common with rect (valid - rect extends shape)
        common<rect> c1 = new common<rect>(new rect());
        rect r = c1.fun();  // Returns rect type
        out.println("in main   " + r);
        
        // Line 24: common with triangle (valid - triangle extends shape)
        common<triangle> c2 = new common<triangle>(new triangle());
        triangle t = c2.fun();  // Returns triangle type
        out.println("in main   " + t);
        
        // Line 25: This would NOT compile!
        // common<String> c3 = new common<String>("hello");
        // ✗ ERROR: String does not extend shape!
    }
}
```

> [!NOTE]
> In generics, the keyword `extends` is used for both classes AND interfaces. There is NO `implements` keyword in generics.

```java
// CORRECT - extends works for interfaces too!
List<? extends Serializable> mylist;

// WRONG - implements is NOT used in generics
// List<? implements Serializable> mylist;  // COMPILATION ERROR!
```

---

## ❓ Wildcards

### Understanding Wildcards

Wildcards (`?`) are used when you want to write code that works with unknown types.

### Three Types of Wildcards:

| Wildcard | Syntax | Meaning | Can Add? |
|----------|--------|---------|----------|
| **Unbounded** | `<?>` | Any type | ❌ No |
| **Upper Bounded** | `<? extends Type>` | Type or its subtypes | ❌ No |
| **Lower Bounded** | `<? super Type>` | Type or its supertypes | ✅ Yes (the Type) |

### Unbounded Wildcard `<?>`

```java
// FILE: UnboundedWildcard.java
// ============================

import java.util.*;

class Animal {
    void eat() {}
}

class Dog extends Animal {
    void eat() {
        System.out.println("Dog eat");
    }
}

class Cat extends Animal {
    void eat() {
        System.out.println("Cat eat");
    }
}

public class trial {
    
    // Line 1-4: Method with unbounded wildcard
    // <?> means "unknown type" - can be ANY type
    void disp(List<?> arr) {
        System.out.println(arr);  // Print the list
        
        // ⚠️ CANNOT ADD - compiler doesn't know actual type
        // arr.add(new Dog());  // ✗ COMPILATION ERROR!
    }
    
    public static void main(String args[]) {
        trial t = new trial();
        
        // Line 5: Pass List of Animal
        List<Animal> l = new ArrayList<Animal>();
        t.disp(l);  // ✓ Allowed
        
        // Line 6: Pass List of Dog
        List<Dog> l1 = new ArrayList<Dog>();
        l1.add(new Dog());
        t.disp(l1);  // ✓ Allowed
        
        // Line 7: Pass List of Integer (completely different type!)
        List<Integer> ob = new ArrayList<Integer>();
        ob.add(100);
        t.disp(ob);  // ✓ Allowed - <?> accepts ANY type
    }
}
```

### Upper Bounded Wildcard `<? extends Type>`

```java
// FILE: UpperBoundedWildcard.java
// ===============================

import java.util.*;

class Animal {
    void eat() {}
}

class Dog extends Animal {
    void eat() {
        System.out.println("Dog eat");
    }
}

class Cat extends Animal {
    void eat() {
        System.out.println("Cat eat");
    }
}

public class trial {
    
    // Line 1-6: Upper bounded wildcard
    // <? extends Animal> means Animal or any SUBTYPE of Animal
    void disp(List<? extends Animal> arr) {
        // Can iterate and call Animal methods
        for (Animal l : arr) {
            l.eat();  // ✓ Polymorphic call works
        }
        
        // ⚠️ CANNOT ADD - don't know exact subtype
        // arr.add(new Dog());  // ✗ COMPILATION ERROR!
        // arr.add(new Cat());  // ✗ COMPILATION ERROR!
    }
    
    public static void main(String args[]) {
        trial t = new trial();
        
        // Line 7: Create and pass List of Dog
        Dog d[] = {new Dog(), new Dog()};
        List<Dog> l = new ArrayList<Dog>();
        l.add(d[0]);
        l.add(d[1]);
        t.disp(l);  // Output: Dog eat, Dog eat
        
        // Line 8: Create and pass List of Cat
        Cat c[] = {new Cat(), new Cat()};
        List<Cat> l1 = new ArrayList<Cat>();
        l1.add(c[0]);
        l1.add(c[1]);
        t.disp(l1);  // Output: Cat eat, Cat eat
        
        // Line 9: Cannot pass List of Integer!
        // List<Integer> nums = new ArrayList<Integer>();
        // t.disp(nums);  // ✗ ERROR: Integer not subtype of Animal
    }
}
```

**Diagram: Upper Bounded Wildcard**
```
                    ┌─────────────────────────┐
                    │ <? extends Animal>      │
                    │ Accepts:                │
                    └───────────┬─────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        ↓                       ↓                       ↓
   ┌─────────┐            ┌─────────┐            ┌─────────┐
   │ List    │            │ List    │            │ List    │
   │ <Animal>│            │ <Dog>   │            │ <Cat>   │
   └─────────┘            └─────────┘            └─────────┘
        ✓                      ✓                      ✓

   ┌─────────┐
   │ List    │
   │<Integer>│  ❌ NOT allowed (Integer not subtype of Animal)
   └─────────┘
```

### Lower Bounded Wildcard `<? super Type>`

```java
// FILE: LowerBoundedWildcard.java
// ===============================

import java.util.*;

class Animal {
    void eat() {}
}

class Dog extends Animal {
    void eat() {
        System.out.println("Dog eat");
    }
}

class Cat extends Animal {
    void eat() {
        System.out.println("Cat eat");
    }
}

public class trial {
    
    // Line 1-10: Lower bounded wildcard
    // <? super Dog> means Dog or any SUPERTYPE of Dog
    void disp(List<? super Dog> arr) {
        
        // ✓ CAN ADD Dog (and its subtypes)!
        arr.add(new Dog());  // Allowed
        arr.add(new Dog());  // Allowed
        
        // Iterating requires Object type (unknown actual type)
        for (Object d : arr) {
            if (d instanceof Dog) {
                ((Dog) d).eat();
            } else if (d instanceof Cat) {
                ((Cat) d).eat();
            }
        }
        System.out.println(arr);
    }
    
    public static void main(String args[]) {
        trial t = new trial();
        
        // Line 11: Pass List of Animal (supertype of Dog)
        List<Animal> l = new ArrayList<Animal>();
        l.add(new Cat());  // Can have Cat in Animal list
        t.disp(l);  // ✓ Allowed
        
        // Line 12: Pass List of Dog
        List<Dog> l1 = new ArrayList<Dog>();
        l1.add(new Dog());
        t.disp(l1);  // ✓ Allowed
        
        // Line 13: Pass List of Object (supertype of Dog)
        List<Object> l2 = new ArrayList<Object>();
        t.disp(l2);  // ✓ Allowed
        
        // Line 14: Cannot pass List of Cat!
        // List<Cat> l3 = new ArrayList<Cat>();
        // t.disp(l3);  // ✗ ERROR: Cat is not supertype of Dog
    }
}
```

**Diagram: Lower Bounded Wildcard**
```
                    ┌─────────────────────────┐
                    │ <? super Dog>           │
                    │ Accepts:                │
                    └───────────┬─────────────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        ↓                       ↓                       ↓
   ┌─────────┐            ┌─────────┐            ┌─────────┐
   │ List    │            │ List    │            │ List    │
   │<Object> │            │<Animal> │            │ <Dog>   │
   └─────────┘            └─────────┘            └─────────┘
        ✓                      ✓                      ✓
   (super of Dog)         (super of Dog)         (itself)

   ┌─────────┐
   │ List    │
   │ <Cat>   │  ❌ NOT allowed (Cat not supertype of Dog)
   └─────────┘

   ┌─────────────────────────────────────────────────────────┐
   │ KEY BENEFIT: Can ADD Dog objects to the list!           │
   │ arr.add(new Dog()) → ✓ Allowed                          │
   └─────────────────────────────────────────────────────────┘
```

### Difference: `List<?>` vs `List<Object>`

```java
// IMPORTANT DIFFERENCE!
// =====================

// List<?> - Unknown type, can accept ANY List type
public void disp(List<?> mylist) {
    System.out.println(mylist);
    // mylist.add(new Dog());  // ✗ CANNOT add
}
// Can call with: List<Dog>, List<Cat>, List<Integer>, List<String>, etc.

// List<Object> - ONLY accepts List<Object>
public void disp(List<Object> mylist) {
    mylist.add(new Dog());  // ✓ CAN add
    mylist.add(200);         // ✓ CAN add (Object accepts all)
    System.out.println(mylist);
}
// Can ONLY call with: List<Object>
// disp(new ArrayList<Dog>());  // ✗ COMPILATION ERROR!
```

### Valid/Invalid Wildcard Examples

```java
// ✓ VALID Examples
// ================

// 1. Unbounded wildcard with Dog list
List<?> mylist = new ArrayList<Dog>();  // ✓

// 2. Upper bounded wildcard with Dog list
List<? extends Animal> mylist = new ArrayList<Dog>();  // ✓

// 5. Lower bounded wildcard with Animal list
List<? super Dog> mylist = new ArrayList<Animal>();  // ✓


// ✗ INVALID Examples
// ==================

// 3. Cannot use wildcard in object creation!
List<?> mylist = new ArrayList<? extends Animal>();  // ✗ ERROR
// Wildcards are for REFERENCES, not creation!

// 4. Upper bound mismatch
List<? extends Dog> mylist = new ArrayList<Integer>();  // ✗ ERROR
// Integer is NOT subtype of Dog!

// 6. Lower bound mismatch
List<? super Animal> mylist = new ArrayList<Dog>();  // ✗ ERROR
// Dog is "lower" than Animal (subtype, not supertype)!
```

---

## 🧹 Type Erasure

### What is Type Erasure?

**Type Erasure** is the process where the Java compiler removes all generic type information during compilation. The JVM has no knowledge of generics!

```java
// BEFORE COMPILATION (Your Code)
// ==============================

public class Generic1<T> {
    private T first;
    
    void setVal(T first) {
        this.first = first;
    }
    
    T getVal() {
        return first;
    }
}

// AFTER COMPILATION (What JVM Sees)
// =================================

public class Generic1 {
    private Object first;  // T replaced with Object
    
    void setVal(Object first) {
        this.first = first;
    }
    
    Object getVal() {
        return first;
    }
}
```

### Why Type Erasure Matters

```java
// This is WHY generics can't be used with arrays in certain ways

// Arrays DO know their type at runtime
Animal[] arr = new Dog[2];
arr[1] = new Cat();  // ArrayStoreException at RUNTIME
// ✓ JVM catches this because arrays retain type info

// Collections DON'T know their type at runtime (due to Type Erasure)
// That's why this is not allowed:
// List<Animal> mylist = new ArrayList<Dog>();  // COMPILE ERROR
// If allowed, mylist.add(new Cat()) wouldn't be caught at runtime!
```

---

## 🔄 Polymorphism and Generics

### Key Difference from Arrays

```java
// WITH ARRAYS - Polymorphism IS allowed
// =====================================

class Animal {}
class Dog extends Animal {}
class Cat extends Animal {}

// This IS allowed with arrays:
Animal[] arr = new Dog[3];  // ✓ Compiles

// But risky at runtime:
arr[0] = new Dog();   // ✓ OK
arr[1] = new Cat();   // ✗ ArrayStoreException at runtime!


// WITH GENERICS - Polymorphism is NOT allowed
// ===========================================

// This is NOT allowed:
// List<Animal> mylist = new ArrayList<Dog>();  // ✗ COMPILE ERROR!

// Why? Because JVM can't detect wrong additions:
// mylist.add(new Cat());  // Would be added to Dog list!
// No ArrayStoreException equivalent exists for generics
```

**Key Rule:**
> Generic type of reference and generic type of object must be **IDENTICAL**.
> Polymorphism applies to the **BASE TYPE** (the collection type), NOT the generic type.

```java
// ✓ ALLOWED - Base type polymorphism
List<Integer> mylist = new ArrayList<Integer>();  // List -> ArrayList

// ✗ NOT ALLOWED - Generic type polymorphism
// List<Animal> mylist = new ArrayList<Dog>();  // Animal -> Dog NOT allowed!
```

### Correct Usage with Generics

```java
// ✓ CORRECT - Same generic type
List<Animal> mylist = new ArrayList<Animal>();
mylist.add(new Dog());  // ✓ Dog IS-A Animal
mylist.add(new Cat());  // ✓ Cat IS-A Animal
```

---

## ⚠️ Common Pitfalls and Best Practices

### Mixing Generic and Non-Generic Code

```java
// RISKY CODE - Mixing generics with raw types
// ===========================================

import java.util.*;

public class Trial {
    
    // Method accepts RAW List (no generics)
    void disp(List mylist) {
        mylist.add("hello");  // Adding String to ANY list!
        // ...
    }
    
    public static void main(String args[]) {
        
        // Creating type-safe Integer list
        List<Integer> m = new ArrayList<Integer>();
        m.add(20);
        m.add(40);
        
        Trial t = new Trial();
        t.disp(m);  // Passing Integer list to raw method!
        
        // Later trying to get Integer...
        Integer ob = m.get(2);  // ✗ ClassCastException!
        // Because element at index 2 is "hello" (String)!
    }
}
```

> [!CAUTION]
> Never mix generic collections with raw-type methods. It defeats the purpose of type safety!

### Best Practices

1. **Always use generic types** - Never use raw types like `List` or `Map`
2. **Use diamond operator** (Java 7+): `List<String> list = new ArrayList<>();`
3. **Use bounded wildcards** when you need flexibility
4. **Remember PECS**: Producer Extends, Consumer Super
   - Use `<? extends T>` when you only READ from collection
   - Use `<? super T>` when you only WRITE to collection

---

## 📝 Interview Questions

### Q1: What are Generics in Java?
**Answer:** Generics enable types (classes and interfaces) to be parameters when defining classes, interfaces, and methods. They provide compile-time type safety by allowing developers to specify the type of objects a collection can hold.

### Q2: What is Type Erasure?
**Answer:** Type Erasure is the process where the Java compiler removes all generic type information during compilation. This ensures backward compatibility with pre-Java 5 code but means the JVM has no knowledge of generic types at runtime.

### Q3: Can we use primitives with Generics?
**Answer:** No, generics only work with reference types (objects). For primitives, use their wrapper classes: `List<Integer>` instead of `List<int>`.

### Q4: What is the difference between `<?>` and `<Object>`?
**Answer:** 
- `List<?>` accepts any List type (List<Dog>, List<Cat>, etc.) but you can't add elements
- `List<Object>` only accepts List<Object> specifically, but you can add any object

### Q5: When to use `extends` vs `super` in wildcards?
**Answer:** 
- Use `<? extends T>` when you READ from the structure (producer)
- Use `<? super T>` when you WRITE to the structure (consumer)
- This is known as the PECS principle (Producer Extends, Consumer Super)

### Q6: Why is `List<Dog>` not assignable to `List<Animal>`?
**Answer:** Because of type safety. If it were allowed, you could add a Cat to a Dog list through the Animal reference, which would cause runtime errors. Arrays allow this but catch it at runtime with ArrayStoreException. Generics prevent it at compile time.

### Q7: Can you create an instance of a generic type parameter?
**Answer:** No, you cannot do `new T()` due to type erasure. The actual type is not available at runtime.

---

> [!TIP]
> Practice writing generic classes and methods. Understanding generics thoroughly helps in working with Spring Framework, Hibernate, and other Java frameworks effectively!

