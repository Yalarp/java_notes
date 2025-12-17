# Design Patterns & Jakarta EE Notes

This document covers Creational Design Patterns (Simple Factory vs. Factory Method), Advanced Jakarta EE concepts (Connection Pooling, JNDI), and Request Processing (Parameters, Dispatching).

---

## 1. Design Patterns: Creational

### Simple Factory vs. Factory Method

#### The Problem with Simple Factory
Imagine you are building a UI framework that supports multiple operating systems (Windows, Linux, macOS).
*   **Scenario**: You have a lot of components (Buttons, Menus) that need to be created based on the user's OS.
*   **The Issue**: If you use a single "Factory" class with a bunch of `if-else` statements (e.g., `if (os == "Windows") return new WindowsButton()`), your code becomes tightly coupled.
*   **Consequence**: If you want to add a "macOS" style later, you have to modify the existing `Factory` code. This violates the **Open/Closed Principle** (Code should be Open for extension, but Closed for modification).

#### The Solution: Factory Method Pattern
Instead of one central factory deciding everything, we define a **contract** (Abstract Class or Interface) for creating objects and let **subclasses** decide which specific class to instantiate.

> **Core Concept**: Define an interface for creating an object, but let subclasses alter the type of objects that will be created.

#### Implementation Structure

1.  **`UIComponentCreator`** (Abstract Class/Interface):
    *   Defines the contract method, e.g., `public abstract Component createComponent();`
2.  **Concrete Creators** (The Subclasses):
    *   **`WindowsUIComponentCreator`**: Extends `UIComponentCreator`. Implementation of `createComponent()` returns a `new WindowsButton()`.
    *   **`LinuxUIComponentCreator`**: Extends `UIComponentCreator`. Implementation returns a `new LinuxButton()`.

**Benefit**: If you need to add macOS support, you simply create `MacUIComponentCreator`. You generally do *not* touch the existing Windows or Linux logic.

---

## 2. Jakarta EE Day 2: Database Connection Pooling

### What is a Connection Pool?
A **Connection Pool** is a cache of database connections maintained so that connections can be reused when future requests to the database are required.

#### The "Taxi Stand" Analogy
*   **Without Pool**: A passenger (Request) calls a taxi company, they buy a new car, hire a driver, drive to you, take you to destination, and then **scrap the car**. (Very wasteful!)
*   **With Pool**: You go to a Taxi Stand.
    1.  Taxis (Connections) are already waiting there (**Idle**).
    2.  You take a taxi, complete your ride (Query).
    3.  The taxi returns to the stand to wait for the next passenger. It is **not** destroyed.

### Why do we need it?
Connecting to a database manually using `DriverManager` is expensive:
1.  Load Driver -> 2. Open TCP/IP Socket -> 3. Authenticate -> 4. Use -> 5. Close.

Doing this for every single user request wastes CPU, Memory, and Time.

### Comparison: DriverManager vs. DataSource

| Feature | Without Pool (DriverManager) | With Pool (DataSource) |
| :--- | :--- | :--- |
| **Connection Creation** | Creates a **NEW** physical connection every time. | Reuses an **EXISTING** connection from the pool. |
| **Performance** | Slow (Resource intensive). | Fast (Connections are pre-created). |
| **Coupling** | Tightly Coupled (Hardcoded URL/User/Pwd). | Loosely Coupled (Configured in Server). |
| **Closing** | `con.close()` **destroys** the connection. | `con.close()` **returns** it to the pool. |

### Dependency Injection (DI) with DataSource
In Jakarta EE, we don't create the `DataSource` manually using `new`. The Server (Container) creates it, and we ask for it (Injection).

**Code Example:**
```java
// We use the javax.sql.DataSource interface
// The Lookup string points to the reference bound by the server
@Resource(lookup="java:comp/env/jdbc/mypool")
private DataSource ds;

public void doGet(...) {
    // ds.getConnection() takes a connection from the pool
    try (Connection con = ds.getConnection()) {
        // Use connection...
    } catch (SQLException e) {
        e.printStackTrace();
    }
    // Connection is automatically returned to pool here due to try-with-resources
}
```

---

### JNDI (Java Naming and Directory Interface)

#### What is it?
JNDI is a generic API that allows Java applications to look up data and objects via a name. It is similar to a Map (`Key` -> `Value`).

**Common Naming Services:**
*   **DNS**: Maps Domain Name -> IP Address.
*   **LDAP**: Maps User/Org -> Information.
*   **RMI Registry**: Maps Name -> Remote Object.

#### JNDI in Web Servers (`java:comp/env`)
*   **Name**: `jdbc/mypool` (Logical name given by dev).
*   **Object**: The actual `DataSource` implementation created by Tomcat/Glassfish.
*   **`java:comp/env`**: Standard prefix for component-environment resources.

**Flow:**
1.  **Bind**: Server acts as the Naming Service. It binds "jdbc/mypool" to the DataSource Object.
2.  **Lookup**: App asks JNDI "Give me the object named `java:comp/env/jdbc/mypool`".

---

### Setup Steps (Tomcat)

1.  **Define Resource in `context.xml`**
    (Located in `META-INF/context.xml` or `conf/context.xml`)
    ```xml
    <Resource name="jdbc/mypool"
              auth="Container"
              type="javax.sql.DataSource"
              maxTotal="100"       <!-- Max connections -->
              maxIdle="30"         <!-- Max waiting connections -->
              maxWaitMillis="10000"
              username="root"
              password="password"
              driverClassName="com.mysql.cj.jdbc.Driver"
              url="jdbc:mysql://localhost:3306/mydb"/>
    ```

2.  **Use in Servlet**:
    Use the `@Resource` annotation as shown in the code example above.

---

## 3. Jakarta EE Day 3: Parameters & Request Dispatching

### Types of Parameters

| Type | Scope | Access Method | Defined In | Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Request Param** | Single Request | `request.getParameter("name")` | HTML Form / URL | Form data (username, age). |
| **Init Param** | **Single Servlet** | `config.getInitParameter("name")` | `web.xml` (`<init-param>`) | Specific settings for ONE servlet (e.g., log file path for BookServlet). |
| **Context Param** | **Whole App** | `context.getInitParameter("name")` | `web.xml` (`<context-param>`) | Global settings (DB URL, Admin Email). |

### ServletConfig vs. ServletContext

*   **ServletConfig**:
    *   **One per Servlet**.
    *   Created during Servlet initialization (`init(config)`).
    *   Acts like your personal **Private Note**.
*   **ServletContext**:
    *   **One per Web Application**.
    *   Created when the App starts.
    *   Acts like the office **Public Notice Board**.

---

### Redirect vs. Forward

When a Servlet can't finish the job alone, it hands over control.

#### 1. Forward (`RequestDispatcher.forward()`)
*   **Internal Handoff**: The server passes the request from Servlet A to Servlet B.
*   **One Request**: The client (Browser) sends only 1 request.
*   **URL Unchanged**: Browser URL bar still shows "Servlet A".
*   **Data Preserved**: `request` attributes are preserved.
*   **Speed**: Faster.

```java
// Forwarding within the same context
RequestDispatcher rd = request.getRequestDispatcher("NextServlet");
rd.forward(request, response);
```

#### 2. Redirect (`response.sendRedirect()`)
*   **External Bounce**: Server tells Browser "Go look over there (URL B)".
*   **Two Requests**: Browser creates a NEW request to URL B.
*   **URL Changes**: Browser URL updates to "Servlet B" (or google.com).
*   **Data Lost**: Old `request` object is dead; new one is born.
*   **Speed**: Slower (Round trip).

```java
// Redirecting to another URL (internal or external)
response.sendRedirect("NextServlet");
// OR
response.sendRedirect("http://www.google.com");
```

#### 3. Include (`RequestDispatcher.include()`)
*   Like Forward, but Servlet A keeps control.
*   It "includes" the output of Servlet B into its own response.
*   Example: Including a common Header or Footer JSP in every page.

---

## 4. Viva / Interview Questions (40+)

### Design Patterns
1.  **What is the core difference between Simple Factory and Factory Method?**
    *   Simple Factory is a class with static methods/if-else logic. Factory Method is an interface allowing subclasses to decide instantiation, adhering to Open/Closed principle.
2.  **Why is "Tight Coupling" bad in Factory design?**
    *   It requires modifying existing tested code (the Factory class) every time a new component type is added, risking bugs.
3.  **Give a real-world analogy for Factory Method.**
    *   A Pizza franchise. The core "Ordering" process is standard, but a "NYStyleFranchise" creates NYPizza, while "ChicagoStyleFranchise" creates ChicagoPizza.
4.  **Is Factory Method a Creational or Structural pattern?**
    *   Creational.

### Connection Pooling & JNDI
5.  **What is a Connection Pool?**
    *   A cache of database connections maintained so they can be reused.
6.  **Why is `DriverManager.getConnection()` slow?**
    *   It performs a handshake, authentication, and resource allocation for every single call.
7.  **What happens when you close a connection in a pool? (`con.close()`)**
    *   It does **not** close the physical socket; it returns the connection to the pool (marks it as idle).
8.  **What is a Connection Leak?**
    *   When code gets a connection but fails to close/return it. The pool eventually runs out of connections.
9.  **What does JNDI stand for?**
    *   Java Naming and Directory Interface.
10. **What is the standard JNDI namespace for web apps?**
    *   `java:comp/env`.
11. **How do you inject a DataSource in a Servlet?**
    *   Using `@Resource(lookup="...")`.
12. **Which XML file is used to configure the Pool in Tomcat?**
    *   `context.xml`.
13. **Difference between `maxTotal` and `maxIdle`?**
    *   `maxTotal`: Absolute limit of connections (active + idle). `maxIdle`: Max connections kept sleeping in the pool without being released.
14. **What is the role of the Container in Pooling?**
    *   The Container (Tomcat) instantiates the pool and binds it to JNDI; the app just looks it up.

### Parameters & Scopes
15. **Name the three types of parameters in Jakarta EE.**
    *   Request, Init, and Context.
16. **How do you define a Context parameter?**
    *   In `web.xml` using `<context-param>`.
17. **How do you define an Init parameter?**
    *   In `web.xml` inside a specific `<servlet>` tag.
18. **Is `ServletContext` shared per user or per app?**
    *   Per Application (Global).
19. **How many `ServletConfig` objects exist for 5 servlets?**
    *   5 (One per Servlet).
20. **Can Servlet A access Servlet B's Init Parameters?**
    *   No.
21. **Example usage of a Context Parameter?**
    *   Database connection URL, Support Email, System Admin Name.
22. **Example usage of a Request Parameter?**
    *   Form input (username, password).

### Forward vs. Redirect
23. **Which method changes the URL in the browser?**
    *   `response.sendRedirect()`.
24. **Which method is faster?**
    *   `RequestDispatcher.forward()` (Server-side only).
25. **If I want to pass data from Servlet A to B, which should I use?**
    *   Forward (Request attributes are preserved).
26. **Can I forward to `google.com`?**
    *   No, Forward is generally within the same context (application). Redirect can go anywhere.
27. **What is `RequestDispatcher.include()`?**
    *   It merges the response of another resource into the current response (e.g., Header/Footer).
28. **Does a Redirect create a new Request object?**
    *   Yes.
29. **How do you pass data in a Redirect?**
    *   URL Query Strings (`?id=5`) or Session. Request attributes are lost.
30. **Which object is used to get a RequestDispatcher?**
    *   `request` or `getServletContext()`.

### General Servlet/JSP
31. **What is the lifecycle of a Servlet?**
    *   Load -> Instantiate -> `init()` -> `service()` (doGet/doPost) -> `destroy()`.
32. **When is `init()` called?**
    *   Only once when the Servlet is first created.
33. **What is the difference between `@Resource` and `@Autowired` (Spring)?**
    *   `@Resource` is standard Jakarta EE (JSR-250) usually by name. `@Autowired` is Spring-specific usually by type.
34. **Where is `web.xml` located?**
    *   In `WEB-INF/web.xml`.
35. **What is a "Deployment Descriptor"?**
    *   It's the `web.xml` file.
36. **Can we have a Servlet without `web.xml`?**
    *   Yes, using annotations like `@WebServlet`.
37. **What is the interface for Connection Pooling?**
    *   `javax.sql.DataSource`.
38. **What protocol does `redirect` use?**
    *   HTTP 302 Status Code (Temporary Redirect).
39. **Why prefer Annotations over XML?**
    *   Development speed and keeping configuration close to code.
40. **Why prefer XML over Annotations?**
    *   Centralized configuration; can change settings without recompiling code.

### Advanced/Scenario
41. **If I have a login page, validation fails, should I Forward or Redirect back to login?**
    *   Forward (to keep the error messages/data in request scope).
42. **If login is successful, should I Forward or Redirect to Home?**
    *   Redirect (to prevent "Form Resubmission" on refresh).
43. **How does the server know which `DataSource` implementation to use?**
    *   Specified in `context.xml` (e.g., `type="javax.sql.DataSource"` and the driver class name).
44. **What happens if the Connection Pool reaches `maxTotal`?**
    *   The next request waits (blocks) until a connection is returned, or throws an exception after `maxWaitMillis`.
45. **Can `ServletContext` store objects?**
    *   Yes, using `setAttribute("key", object)`. It acts as global application memory.
