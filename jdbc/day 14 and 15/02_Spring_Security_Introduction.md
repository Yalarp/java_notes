# 🔐 Spring Security Introduction

## Table of Contents
1. [What is Spring Security](#what-is-spring-security)
2. [Core Concepts](#core-concepts)
3. [Authentication vs Authorization](#authentication-vs-authorization)
4. [Security Techniques in Spring](#security-techniques-in-spring)
5. [How Spring Security Works](#how-spring-security-works)
6. [CSRF Protection](#csrf-protection)
7. [ResponseEntity in Spring](#responseentity-in-spring)
8. [Key Annotations](#key-annotations)
9. [Interview Questions](#interview-questions)

---

## What is Spring Security

### Definition

**Spring Security** is a powerful and highly customizable authentication and access-control framework for Java/Spring applications.

### What Spring Security Provides

```
┌────────────────────────────────────────────────────────────┐
│              Spring Security Capabilities                   │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ✅ Authenticate users (Who are you?)                      │
│  ✅ Authorize users (What are you allowed to do?)          │
│  ✅ Protect APIs, URLs, and resources                      │
│  ✅ Password encryption                                    │
│  ✅ Session management                                     │
│  ✅ CSRF protection                                        │
│  ✅ Integration with OAuth2/SSO                            │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Problems Spring Security Solves

| Without Spring Security | With Spring Security |
|------------------------|---------------------|
| Anyone can access APIs | Login is required |
| No login control | Authentication enforced |
| No role-based access | Roles like ADMIN/USER enforced |
| Passwords stored in plain text | Passwords encrypted |
| Security rules scattered | Security rules centralized |

> [!IMPORTANT]
> Spring Security works using **filters** that run **before** the controller. These filters intercept every request and apply security rules.

---

## Core Concepts

### The Two Pillars of Security

```mermaid
flowchart LR
    A[Security] --> B[Authentication]
    A --> C[Authorization]
    B --> D["WHO are you?"]
    C --> E["WHAT can you access?"]
```

### Key Terms

| Term | Meaning | Example |
|------|---------|---------|
| **Principal** | Currently logged-in user | "admin", "john@email.com" |
| **Credentials** | Proof of identity | Password, Token, Certificate |
| **Authority** | Permission granted to user | READ, WRITE, DELETE |
| **Role** | Group of authorities | ROLE_ADMIN, ROLE_USER |
| **GrantedAuthority** | Interface representing authority | SimpleGrantedAuthority |

---

## Authentication vs Authorization

### Authentication - "Who are you?"

**Authentication** is the process of verifying the identity of a user.

```
┌────────────────────────────────────────────────────────────┐
│                    Authentication Flow                      │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  User provides:    Username = admin                        │
│                    Password = admin123                     │
│                           ↓                                │
│  System verifies:  Does this user exist?                   │
│                    Is password correct?                    │
│                           ↓                                │
│  Result:           ✅ Authenticated (Identity confirmed)   │
│              or    ❌ 401 Unauthorized (Invalid credentials)│
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Authorization - "What can you access?"

**Authorization** determines what resources an authenticated user can access.

```
┌────────────────────────────────────────────────────────────┐
│                    Authorization Flow                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  User requests:    GET /admin/dashboard                    │
│                           ↓                                │
│  System checks:    Is user authenticated? ✅               │
│                    Does user have ROLE_ADMIN?              │
│                           ↓                                │
│  Result:           ✅ Access Granted (has required role)   │
│              or    ❌ 403 Forbidden (insufficient privileges)│
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Comparison Table

| Aspect | Authentication | Authorization |
|--------|---------------|---------------|
| **Question** | Who are you? | What can you do? |
| **Happens** | First | After authentication |
| **Verifies** | User identity | User permissions |
| **Error Code** | 401 Unauthorized | 403 Forbidden |
| **Example** | Login with username/password | Access admin panel |

### Visual Flow

```
          Authentication                Authorization
               ↓                             ↓
        ┌─────────────┐              ┌─────────────┐
        │   Login     │              │   Access    │
        │   Check     │      →       │   Check     │
        │ (Identity)  │              │ (Permissions)│
        └─────────────┘              └─────────────┘
               ↓                             ↓
         401 if fails                 403 if fails
```

---

## Security Techniques in Spring

Spring Security supports multiple authentication mechanisms:

### 1. Basic Authentication

```
┌────────────────────────────────────────────────────────────┐
│                    Basic Authentication                     │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  How it works:                                             │
│  - Username and password sent with EVERY request           │
│  - Encoded using Base64 (NOT encrypted!)                   │
│  - Sent in Authorization header                            │
│                                                            │
│  Header format:                                            │
│  Authorization: Basic dXNlcjpwYXNz (base64 of user:pass)  │
│                                                            │
│  Use case:                                                 │
│  - Testing                                                 │
│  - Internal services                                       │
│  - API clients (Postman)                                   │
│                                                            │
│  ⚠️ No cookies, no sessions, no logout concept            │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 2. Form-Based Authentication

```
┌────────────────────────────────────────────────────────────┐
│                   Form-Based Authentication                 │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  How it works:                                             │
│  - Traditional login form                                  │
│  - Username & password submitted via POST                  │
│  - Server creates a session                                │
│  - Session ID stored in cookie                             │
│                                                            │
│  Use case:                                                 │
│  - Traditional web applications                            │
│  - JSP / Thymeleaf applications                           │
│  - Applications requiring logout functionality             │
│                                                            │
│  ✅ Spring Boot supports this by default                   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 3. JWT (Token-Based Authentication)

```
┌────────────────────────────────────────────────────────────┐
│                    JWT Authentication                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  How it works:                                             │
│  - Server issues a JWT token after login                   │
│  - Client sends token in Authorization header              │
│  - No session stored on server (stateless)                 │
│                                                            │
│  Header format:                                            │
│  Authorization: Bearer eyJhbGciOiJIUzI1NiIs...             │
│                                                            │
│  Use case:                                                 │
│  - REST APIs                                               │
│  - Mobile apps                                             │
│  - Single Page Applications (React, Angular)               │
│  - Microservices                                           │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 4. OAuth2 / Single Sign-On (SSO)

```
┌────────────────────────────────────────────────────────────┐
│                    OAuth2 / SSO                             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  How it works:                                             │
│  - Login using Google, Facebook, GitHub, etc.              │
│  - One login works for multiple applications               │
│  - Application doesn't handle passwords                    │
│                                                            │
│  Use case:                                                 │
│  - Large applications                                      │
│  - Enterprise systems                                      │
│  - Consumer apps (Login with Google)                       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 5. Database / LDAP Authentication

```
┌────────────────────────────────────────────────────────────┐
│                Database/LDAP Authentication                 │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Credentials stored in:                                    │
│  - Database (MySQL, PostgreSQL)                            │
│  - LDAP / Active Directory                                 │
│                                                            │
│  Use case:                                                 │
│  - Corporate environments                                  │
│  - Custom user management                                  │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Comparison Matrix

| Feature | Basic Auth | Form Login | JWT | OAuth2 |
|---------|-----------|------------|-----|--------|
| **Session** | No | Yes | No | Depends |
| **Stateless** | Yes | No | Yes | Depends |
| **Logout** | None | Yes | Manual | Yes |
| **Best for** | APIs | Web Apps | REST/Mobile | SSO |
| **Scalable** | Yes | Limited | Yes | Yes |

---

## How Spring Security Works

### SecurityFilterChain

Spring Security uses a **chain of filters** to process requests:

```
┌────────────────────────────────────────────────────────────┐
│                 Security Filter Chain                       │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Request → SecurityContextPersistenceFilter                │
│              ↓                                             │
│         → CsrfFilter                                       │
│              ↓                                             │
│         → UsernamePasswordAuthenticationFilter             │
│              ↓                                             │
│         → BasicAuthenticationFilter                        │
│              ↓                                             │
│         → ExceptionTranslationFilter                       │
│              ↓                                             │
│         → FilterSecurityInterceptor                        │
│              ↓                                             │
│         → DispatcherServlet → Controller                   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Key Filters Explained

| Filter | Purpose |
|--------|---------|
| **SecurityContextPersistenceFilter** | Stores/retrieves security context between requests |
| **CsrfFilter** | Protects against CSRF attacks |
| **UsernamePasswordAuthenticationFilter** | Handles form login |
| **BasicAuthenticationFilter** | Handles Basic auth |
| **ExceptionTranslationFilter** | Converts security exceptions to HTTP responses |
| **FilterSecurityInterceptor** | Makes authorization decisions |

---

## CSRF Protection

### What is CSRF?

**CSRF (Cross-Site Request Forgery)** is an attack where an attacker tricks a user into performing unwanted actions on a website they're authenticated with.

```
┌────────────────────────────────────────────────────────────┐
│                    CSRF Attack Scenario                     │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  1. User logs into bank website (bank.com)                 │
│  2. User visits malicious site (evil.com)                  │
│  3. Evil.com has hidden form:                              │
│     <form action="bank.com/transfer" method="POST">        │
│       <input name="to" value="attacker">                   │
│       <input name="amount" value="1000">                   │
│     </form>                                                │
│  4. Form auto-submits using user's existing session!       │
│  5. Money transferred to attacker ⚠️                       │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### How Spring Protects Against CSRF

Spring Security generates a **CSRF token** for each session:

```java
// Token is automatically included in forms
<input type="hidden" name="_csrf" value="abc123..."/>

// Server validates token on POST requests
// If token missing/invalid → request rejected
```

### When to Disable CSRF

```java
// Disable CSRF for REST APIs (stateless, no sessions)
http.csrf(csrf -> csrf.disable())
```

| Scenario | CSRF Protection |
|----------|----------------|
| Traditional web app (sessions) | **Enable** (default) |
| REST API (stateless/JWT) | **Disable** |
| Mobile app backend | **Disable** |

> [!WARNING]
> Only disable CSRF protection when you're using stateless authentication (JWT, API tokens). Never disable it for session-based applications!

---

## ResponseEntity in Spring

### What is ResponseEntity?

**ResponseEntity** represents the complete HTTP response: status code, headers, and body.

```java
// Simple string response with 200 OK
return ResponseEntity.ok("Hello World");

// Custom status with body
return ResponseEntity.status(403).body("Access Denied");

// With headers
return ResponseEntity.ok()
    .header("Custom-Header", "value")
    .body(data);
```

### Common ResponseEntity Methods

| Method | HTTP Status | Use Case |
|--------|-------------|----------|
| `ResponseEntity.ok(body)` | 200 OK | Successful response |
| `ResponseEntity.created(uri)` | 201 Created | Resource created |
| `ResponseEntity.noContent()` | 204 No Content | Successful, no body |
| `ResponseEntity.badRequest()` | 400 Bad Request | Invalid input |
| `ResponseEntity.status(code)` | Custom | Any status code |

### Example Usage

```java
@RestController
@RequestMapping("/home")
public class HomeController {
    
    @GetMapping("/wish")
    public ResponseEntity<String> normalUser() {
        return ResponseEntity.ok("Hello from Spring Boot");
    }
    
    @GetMapping("/access-denied")
    public ResponseEntity<String> accessDenied() {
        return ResponseEntity
            .status(403)
            .body("<h2 style='color:red;'>You do not have permission</h2>");
    }
}
```

---

## Key Annotations

### Security-Related Annotations

| Annotation | Purpose | Example |
|------------|---------|---------|
| `@EnableWebSecurity` | Enables Spring Security configuration | On config class |
| `@Configuration` | Marks class as configuration | Bean definitions |
| `@PreAuthorize` | Method-level authorization | `@PreAuthorize("hasRole('ADMIN')")` |
| `@Secured` | Method-level security | `@Secured("ROLE_ADMIN")` |
| `@RolesAllowed` | JSR-250 role check | `@RolesAllowed("ADMIN")` |

### Controller Annotations

| Annotation | Purpose |
|------------|---------|
| `@RestController` | REST controller (JSON responses) |
| `@Controller` | MVC controller (views) |
| `@RequestMapping` | Base URL mapping |
| `@GetMapping` / `@PostMapping` | HTTP method mapping |
| `@AuthenticationPrincipal` | Injects current user |

---

## Spring Security Version

> [!NOTE]
> **Spring Security 6** is used with **Spring Boot 3**
> 
> Many APIs changed from Spring Security 5 to 6:
> - `antMatchers()` → `requestMatchers()`
> - Lambda DSL is now preferred
> - `authorizeRequests()` → `authorizeHttpRequests()`

---

## Interview Questions

### Q1: What is Spring Security?
**Answer**: Spring Security is a powerful framework for authentication and access-control in Java/Spring applications. It provides features like:
- User authentication (verifying identity)
- Authorization (access control)
- Password encryption
- CSRF protection
- Session management

### Q2: What is the difference between authentication and authorization?
**Answer**:
- **Authentication**: Verifying WHO the user is (login process)
- **Authorization**: Determining WHAT the user can access (permissions)

Authentication happens first; authorization happens after.

### Q3: What are the ways to implement security in Spring Boot?
**Answer**:
1. **Basic Authentication** - Credentials in every request
2. **Form-based Authentication** - Login form with sessions
3. **JWT** - Token-based, stateless authentication
4. **OAuth2/SSO** - Login with Google, Facebook, etc.
5. **Database Authentication** - Credentials stored in database

### Q4: What is CSRF and when should you disable it?
**Answer**: 
CSRF (Cross-Site Request Forgery) is an attack where malicious sites trick users into performing unwanted actions. Spring Security protects against this by default.

**Disable CSRF when**:
- Building stateless REST APIs
- Using JWT authentication
- Building mobile app backends

### Q5: How does Spring Security Filter Chain work?
**Answer**: Spring Security uses a chain of filters that run BEFORE the DispatcherServlet. Each filter handles a specific security concern:
1. CSRF protection
2. Authentication
3. Session management
4. Exception handling
5. Authorization

If any filter rejects the request, it never reaches the controller.

### Q6: What is the difference between @Controller and @RestController?
**Answer**:
- `@Controller`: Returns view names, used with template engines
- `@RestController`: Returns data directly (JSON/XML), combines `@Controller` + `@ResponseBody`

---

## Quick Reference

```
┌────────────────────────────────────────────────────────────┐
│              Spring Security Quick Reference                │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Authentication = WHO are you?                             │
│  Authorization = WHAT can you access?                      │
│                                                            │
│  401 Unauthorized = Authentication failed                  │
│  403 Forbidden = Authorization failed                      │
│                                                            │
│  Basic Auth → Credentials every request                    │
│  Form Login → Session-based                                │
│  JWT → Token-based, stateless                              │
│  OAuth2 → Third-party login (Google, Facebook)             │
│                                                            │
│  Spring Security 6 + Spring Boot 3                         │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

*Next: [03_Spring_Security_Basic_Authentication.md](./03_Spring_Security_Basic_Authentication.md)*
