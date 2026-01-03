# 🔧 JWT Implementation - Basic Example

## Table of Contents
1. [Project Overview](#project-overview)
2. [Dependencies](#dependencies)
3. [Project Structure](#project-structure)
4. [Complete Code Implementation](#complete-code-implementation)
5. [JwtUtil Class Deep Dive](#jwtutil-class-deep-dive)
6. [AuthController Explained](#authcontroller-explained)
7. [HelloController Explained](#hellocontroller-explained)
8. [JwtAuthFilter Explained](#jwtauthfilter-explained)
9. [SecurityConfig Explained](#securityconfig-explained)
10. [Application Flow](#application-flow)
11. [Testing the Application](#testing-the-application)
12. [Interview Questions](#interview-questions)

---

## Project Overview

### What We're Building

```
┌─────────────────────────────────────────────────────────┐
│              Basic JWT Authentication App                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Endpoints:                                             │
│    POST /auth/login  → Get JWT token                    │
│    GET  /api/hello   → Protected (requires JWT)         │
│                                                         │
│  Flow:                                                  │
│    1. Login with username/password → Get token          │
│    2. Call protected API with token                     │
│    3. Server validates token → Returns response         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### User Credentials

| Username | Password |
|----------|----------|
| Abc | 123 |

---

## Dependencies

### Maven Dependencies

```xml
<!-- Standard Spring Boot dependencies -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>

<!-- JWT Dependencies (JJWT Library) -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

### JJWT Library Components

| Dependency | Purpose |
|------------|---------|
| `jjwt-api` | Core JWT API interfaces |
| `jjwt-impl` | Implementation of JWT operations |
| `jjwt-jackson` | JSON processing with Jackson |

---

## Project Structure

```
src/main/java/
└── com/example/demo/
    ├── JwtEx1Application.java      (Main class)
    ├── JwtUtil.java                (Token generation/validation)
    ├── JwtAuthFilter.java          (Security filter)
    ├── AuthController.java         (Login endpoint)
    ├── HelloController.java        (Protected endpoint)
    ├── SecurityConfig.java         (Security configuration)
    └── LoginRequest.java           (Request DTO)

src/main/resources/
└── application.properties
```

---

## Complete Code Implementation

### 1. Main Application

```java
// JwtEx1Application.java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class JwtEx1Application {
    public static void main(String[] args) {
        SpringApplication.run(JwtEx1Application.class, args);
    }
}
```

---

### 2. LoginRequest DTO

```java
// LoginRequest.java
package com.example.demo;

public class LoginRequest {
    private String username;
    private String password;
    
    // Getters and Setters
    public String getUsername() { 
        return username; 
    }
    
    public void setUsername(String username) { 
        this.username = username; 
    }
    
    public String getPassword() { 
        return password; 
    }
    
    public void setPassword(String password) { 
        this.password = password; 
    }
}
```

---

### 3. JwtUtil (Token Generation & Validation)

```java
// JwtUtil.java
package com.example.demo;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;

@Component
public class JwtUtil {

    // Secret key (must be at least 32 characters for HS256)
    private final Key secretKey = Keys.hmacShaKeyFor(
        "MySecretKeyForJwt123456789012345".getBytes()
    );

    // Generate JWT token
    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuer("NitinAuthServer")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 60 * 60 * 1000)) // 1 hour
                .signWith(secretKey, SignatureAlgorithm.HS256)
                .compact();
    }

    // Validate token
    public boolean isTokenValid(String token) {
        try {
            getClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // Extract username from token
    public String extractUsername(String token) {
        return getClaims(token).getSubject();
    }

    // Get all claims from token
    private Claims getClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
```

---

### 4. AuthController (Login Endpoint)

```java
// AuthController.java
package com.example.demo;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtUtil jwtUtil;

    // Constructor injection
    public AuthController(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/login")
    public String login(@RequestBody LoginRequest request) {
        // Simple credential check (in production, use database + BCrypt)
        if (request.getUsername().equals("Abc") && 
            request.getPassword().equals("123")) {
            return jwtUtil.generateToken(request.getUsername());
        }
        return "Invalid username or password";
    }
}
```

---

### 5. HelloController (Protected Endpoint)

```java
// HelloController.java
package com.example.demo;

import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String hello(Authentication auth) {
        return "Hello " + auth.getName() + ", you accessed a protected resource!";
    }
}
```

---

### 6. JwtAuthFilter (Security Filter)

```java
// JwtAuthFilter.java
package com.example.demo;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;

    public JwtAuthFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain chain)
            throws ServletException, IOException {
        
        // Get Authorization header
        String authHeader = request.getHeader("Authorization");
        
        // Check if header exists and starts with "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7); // Remove "Bearer " prefix
            
            // Validate token
            if (jwtUtil.isTokenValid(token)) {
                String username = jwtUtil.extractUsername(token);
                
                // Create authentication object
                UsernamePasswordAuthenticationToken auth =
                    new UsernamePasswordAuthenticationToken(username, null, null);
                
                // Set authentication in SecurityContext
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        
        // Continue filter chain
        chain.doFilter(request, response);
    }
}
```

---

### 7. SecurityConfig

```java
// SecurityConfig.java
package com.example.demo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
public class SecurityConfig {

    private final JwtAuthFilter jwtFilter;

    public SecurityConfig(JwtAuthFilter jwtFilter) {
        this.jwtFilter = jwtFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())  // Disable CSRF for REST API
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/login").permitAll()  // Login is public
                .anyRequest().authenticated()  // All other URLs need auth
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
            .sessionManagement(sess -> 
                sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }
}
```

---

## JwtUtil Class Deep Dive

### Secret Key Creation

```java
private final Key secretKey = Keys.hmacShaKeyFor(
    "MySecretKeyForJwt123456789012345".getBytes()
);
```

| Component | Explanation |
|-----------|-------------|
| `Keys.hmacShaKeyFor()` | Creates HMAC-SHA key from byte array |
| 32+ characters | Required for HS256 algorithm (256 bits) |
| `getBytes()` | Converts string to byte array |

> [!WARNING]
> In production, store the secret key in `application.properties` or environment variables, NOT in code!

---

### Token Generation

```java
public String generateToken(String username) {
    return Jwts.builder()
            .setSubject(username)           // Who this token is for
            .setIssuer("NitinAuthServer")   // Who created the token
            .setIssuedAt(new Date())        // When created
            .setExpiration(new Date(        // When it expires
                System.currentTimeMillis() + 60 * 60 * 1000))  // 1 hour
            .signWith(secretKey, SignatureAlgorithm.HS256)     // Sign it
            .compact();                     // Build final string
}
```

**Line-by-Line:**

| Method | Purpose |
|--------|---------|
| `Jwts.builder()` | Start building a JWT |
| `.setSubject(username)` | Set "sub" claim (user identifier) |
| `.setIssuer("NitinAuthServer")` | Set "iss" claim (issuer) |
| `.setIssuedAt(new Date())` | Set "iat" claim (timestamp) |
| `.setExpiration(...)` | Set "exp" claim (expiry time) |
| `.signWith(key, algo)` | Create signature using key and algorithm |
| `.compact()` | Build final token string |

---

### Token Validation

```java
public boolean isTokenValid(String token) {
    try {
        getClaims(token);  // If this succeeds, token is valid
        return true;
    } catch (Exception e) {
        return false;  // Any exception means invalid token
    }
}

private Claims getClaims(String token) {
    return Jwts.parserBuilder()
            .setSigningKey(secretKey)  // Use same key for verification
            .build()
            .parseClaimsJws(token)     // Parse and verify signature
            .getBody();                // Return claims
}
```

**What parseClaimsJws() Does:**
1. Splits token into header, payload, signature
2. Recalculates signature using secretKey
3. Compares with received signature
4. Checks expiration (exp claim)
5. Throws exception if invalid

---

## AuthController Explained

```java
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtUtil jwtUtil;

    public AuthController(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @PostMapping("/login")
    public String login(@RequestBody LoginRequest request) {
        if (request.getUsername().equals("Abc") && 
            request.getPassword().equals("123")) {
            return jwtUtil.generateToken(request.getUsername());
        }
        return "Invalid username or password";
    }
}
```

### Flow

```
┌─────────────────────────────────────────────────────────┐
│                    Login Flow                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Client sends POST /auth/login                       │
│     Body: { "username": "Abc", "password": "123" }      │
│                                                         │
│  2. Controller receives LoginRequest                    │
│                                                         │
│  3. Check credentials:                                  │
│     username == "Abc" && password == "123"              │
│                                                         │
│  4. If valid:                                           │
│     Generate token → Return to client                   │
│                                                         │
│  5. If invalid:                                         │
│     Return "Invalid username or password"               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

> [!NOTE]
> In production, use database + BCrypt for credential verification, not hardcoded values!

---

## HelloController Explained

```java
@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String hello(Authentication auth) {
        return "Hello " + auth.getName() + ", you accessed a protected resource!";
    }
}
```

### Key Points

| Element | Explanation |
|---------|-------------|
| `@RequestMapping("/api")` | Base URL for all methods |
| `@GetMapping("/hello")` | Maps GET /api/hello |
| `Authentication auth` | Spring injects authenticated user |
| `auth.getName()` | Gets username from token |

### How Authentication Object Gets Populated

```
JWT Token in Request
       ↓
JwtAuthFilter extracts token
       ↓
Validates and extracts username
       ↓
Creates UsernamePasswordAuthenticationToken
       ↓
Sets in SecurityContextHolder
       ↓
Spring injects into Controller method
```

---

## JwtAuthFilter Explained

### Filter Purpose

JwtAuthFilter is a **security filter** that:
1. Intercepts every incoming request
2. Extracts JWT from Authorization header
3. Validates the token
4. Sets user in SecurityContext

### Complete Flow

```java
@Override
protected void doFilterInternal(HttpServletRequest request,
                                HttpServletResponse response,
                                FilterChain chain)
        throws ServletException, IOException {
    
    // STEP 1: Get Authorization header
    String authHeader = request.getHeader("Authorization");
    
    // STEP 2: Check if header exists and is Bearer token
    if (authHeader != null && authHeader.startsWith("Bearer ")) {
        
        // STEP 3: Extract token (remove "Bearer " prefix)
        String token = authHeader.substring(7);
        
        // STEP 4: Validate token
        if (jwtUtil.isTokenValid(token)) {
            
            // STEP 5: Extract username
            String username = jwtUtil.extractUsername(token);
            
            // STEP 6: Create authentication object
            UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(username, null, null);
            
            // STEP 7: Set in SecurityContext
            SecurityContextHolder.getContext().setAuthentication(auth);
        }
    }
    
    // STEP 8: Continue to next filter/controller
    chain.doFilter(request, response);
}
```

### Visual Flow

```mermaid
flowchart TD
    A["Request arrives"] --> B["JwtAuthFilter.doFilterInternal()"]
    B --> C{"Has Authorization header?"}
    C -->|No| D["chain.doFilter()"]
    C -->|Yes| E{"Starts with 'Bearer '?"}
    E -->|No| D
    E -->|Yes| F["Extract token"]
    F --> G{"Token valid?"}
    G -->|No| D
    G -->|Yes| H["Extract username"]
    H --> I["Create Authentication object"]
    I --> J["Set in SecurityContext"]
    J --> D
    D --> K["Controller receives request"]
```

---

## SecurityConfig Explained

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(auth -> auth
            .requestMatchers("/auth/login").permitAll()
            .anyRequest().authenticated()
        )
        .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
        .sessionManagement(sess -> 
            sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        );

    return http.build();
}
```

### Configuration Breakdown

| Configuration | Purpose |
|---------------|---------|
| `.csrf(csrf -> csrf.disable())` | Disable CSRF (not needed for stateless API) |
| `.requestMatchers("/auth/login").permitAll()` | Login endpoint is public |
| `.anyRequest().authenticated()` | All other endpoints need authentication |
| `.addFilterBefore(jwtFilter, ...)` | Add our JWT filter before Spring's default |
| `.sessionCreationPolicy(STATELESS)` | Don't create HTTP sessions |

### Why STATELESS?

```
┌─────────────────────────────────────────────────────────┐
│              SessionCreationPolicy.STATELESS             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  What it means:                                         │
│    "Don't create or use HTTP sessions"                  │
│    "Every request must be self-sufficient"              │
│    "Authentication is NOT stored between requests"      │
│                                                         │
│  Why needed for JWT:                                    │
│    - JWT is stateless by design                         │
│    - Token contains all auth info                       │
│    - No need for session cookies                        │
│    - Better scalability                                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Application Flow

### Complete Request Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant SC as SecurityConfig
    participant JF as JwtAuthFilter
    participant AC as AuthController
    participant JU as JwtUtil
    participant HC as HelloController

    Note over C,HC: STEP 1: Login
    C->>AC: POST /auth/login<br/>{username, password}
    AC->>JU: generateToken(username)
    JU-->>AC: JWT token
    AC-->>C: "eyJhbGci..."

    Note over C,HC: STEP 2: Access Protected API
    C->>JF: GET /api/hello<br/>Authorization: Bearer <token>
    JF->>JU: isTokenValid(token)
    JU-->>JF: true
    JF->>JU: extractUsername(token)
    JU-->>JF: "Abc"
    JF->>JF: Set SecurityContext
    JF->>HC: Forward request
    HC-->>C: "Hello Abc, you accessed..."
```

### Step-by-Step

**STEP 1 — LOGIN (Get Token)**

```
Client sends:
POST /auth/login
Body: { "username": "Abc", "password": "123" }

Server returns:
"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBYmMiLCJpc3MiOiJOaXRpbkF1dGhTZXJ2ZXIi..."
```

**STEP 2 — ACCESS PROTECTED API**

```
Client sends:
GET /api/hello
Header: Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

Server returns:
"Hello Abc, you accessed a protected resource!"
```

---

## Testing the Application

### Using Postman/ARC

#### Step 1: Login

```
Method: POST
URL: http://localhost:8080/auth/login

Headers:
  Content-Type: application/json

Body (raw JSON):
{
  "username": "Abc",
  "password": "123"
}

Response:
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBYmMiLCJpc3MiOiJOaXRpbkF1dGhTZXJ2ZXIi...
```

#### Step 2: Access Protected API

```
Method: GET
URL: http://localhost:8080/api/hello

Headers:
  Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

Response:
Hello Abc, you accessed a protected resource!
```

### Test Cases

| Scenario | Expected Result |
|----------|-----------------|
| Login with correct credentials | Returns JWT token |
| Login with wrong credentials | "Invalid username or password" |
| Access /api/hello with valid token | "Hello Abc..." |
| Access /api/hello without token | 403 Forbidden |
| Access /api/hello with expired token | 403 Forbidden |
| Access /api/hello with tampered token | 403 Forbidden |

---

## Interview Questions

### Q1: What does OncePerRequestFilter do?
**Answer**: OncePerRequestFilter ensures the filter executes exactly once per request, even if the request is forwarded or included internally. It's ideal for authentication filters like JwtAuthFilter.

### Q2: What is the purpose of SecurityContextHolder?
**Answer**: SecurityContextHolder stores the authentication information for the current thread. After JWT validation, we set the Authentication object here so Spring Security knows the user is authenticated for this request.

### Q3: Why use addFilterBefore()?
**Answer**: We add JwtAuthFilter BEFORE UsernamePasswordAuthenticationFilter so our JWT validation runs first. If we added it after, Spring would try form-based authentication before JWT validation.

### Q4: What happens if the Authorization header is missing?
**Answer**: The filter simply continues without setting authentication. The request proceeds to the controller, but Spring Security blocks it because no authentication exists, returning 403 Forbidden.

### Q5: Why disable sessions for JWT?
**Answer**: JWT is stateless by design. Each request carries the token with all auth info. Sessions would store state on the server, defeating JWT's purpose and scalability benefits.

### Q6: What exceptions can parseClaimsJws() throw?
**Answer**:
- `ExpiredJwtException` - Token expired
- `SignatureException` - Invalid signature (tampered)
- `MalformedJwtException` - Invalid token format
- `UnsupportedJwtException` - Unsupported JWT

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              Basic JWT Implementation                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Components:                                            │
│    JwtUtil      → Generate & validate tokens            │
│    JwtAuthFilter → Extract token, set authentication    │
│    AuthController → Login endpoint                      │
│    HelloController → Protected endpoint                  │
│    SecurityConfig → Wire everything together            │
│                                                         │
│  Flow:                                                  │
│    1. POST /auth/login → Get token                      │
│    2. GET /api/hello with token → Access resource       │
│                                                         │
│  Key Settings:                                          │
│    • CSRF disabled (stateless API)                      │
│    • Sessions disabled (STATELESS)                      │
│    • JWT filter before default auth filter              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

*Next: [08_JWT_with_Spring_Security.md](./08_JWT_with_Spring_Security.md)*
