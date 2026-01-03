# 🔐 JWT with Spring Security

## Table of Contents
1. [Introduction](#introduction)
2. [JwtAuthFilter](#jwtauthfilter)
3. [SecurityConfig](#securityconfig)
4. [Application Flow](#application-flow)
5. [First vs Subsequent Requests](#first-vs-subsequent-requests)
6. [Complete Integration Code](#complete-integration-code)
7. [Interview Questions](#interview-questions)

---

## Introduction

This note covers integrating **JWT with Spring Security** - the critical filter and configuration that protects APIs.

```
┌─────────────────────────────────────────────────────────────┐
│           JWT Spring Security Integration                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Key Components:                                            │
│    1. JwtAuthFilter - Extracts & validates JWT              │
│    2. SecurityConfig - Configures protected endpoints       │
│    3. SecurityContextHolder - Stores authentication         │
│                                                             │
│  Goal: Every API call checked for valid JWT                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## JwtAuthFilter

### What is JwtAuthFilter?

Custom filter that runs **once per request** to validate JWT tokens.

```java
// JwtAuthFilter.java
package com.example.demo;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;
import java.util.Collections;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;

    public JwtAuthFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        // Step 1: Get Authorization header
        String authHeader = request.getHeader("Authorization");

        // Step 2: Check if header exists and starts with "Bearer "
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            
            // Step 3: Extract token (remove "Bearer " prefix)
            String token = authHeader.substring(7);

            // Step 4: Validate token
            if (jwtUtil.isTokenValid(token)) {
                
                // Step 5: Extract username from token
                String username = jwtUtil.extractUsername(token);

                // Step 6: Create authentication object
                UsernamePasswordAuthenticationToken authToken =
                    new UsernamePasswordAuthenticationToken(
                        username,                    // Principal
                        null,                        // Credentials
                        Collections.emptyList()      // Authorities
                    );

                authToken.setDetails(
                    new WebAuthenticationDetailsSource()
                        .buildDetails(request)
                );

                // Step 7: Set authentication in SecurityContext
                SecurityContextHolder.getContext()
                    .setAuthentication(authToken);
            }
        }

        // Step 8: Continue filter chain
        filterChain.doFilter(request, response);
    }
}
```

### Line-by-Line Explanation

| Line | Code | Explanation |
|------|------|-------------|
| `extends OncePerRequestFilter` | Base class | Ensures filter runs exactly once per request |
| `request.getHeader("Authorization")` | Get header | Extracts Authorization header from request |
| `authHeader.startsWith("Bearer ")` | Check format | JWT tokens use "Bearer " prefix |
| `authHeader.substring(7)` | Extract token | Removes "Bearer " (7 chars) prefix |
| `jwtUtil.isTokenValid(token)` | Validate | Checks signature and expiry |
| `jwtUtil.extractUsername(token)` | Get user | Gets subject claim from token |
| `UsernamePasswordAuthenticationToken` | Auth object | Spring Security's authentication holder |
| `SecurityContextHolder.getContext().setAuthentication()` | Store auth | Makes user "authenticated" for this request |
| `filterChain.doFilter()` | Continue | Passes request to next filter/controller |

### Filter Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│           JwtAuthFilter Execution Flow                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Request arrives                                            │
│       ↓                                                     │
│  [Check Authorization Header]                               │
│       ↓                                                     │
│  Header exists and starts with "Bearer "?                   │
│       ↓ YES              ↓ NO                               │
│  Extract token           Skip validation                    │
│       ↓                       ↓                             │
│  Token valid?            Continue to next filter            │
│       ↓ YES     ↓ NO                                        │
│  Set auth      Skip                                         │
│       ↓          ↓                                          │
│  Continue filter chain                                      │
│       ↓                                                     │
│  [Next filter checks if authenticated]                      │
│       ↓                                                     │
│  Authenticated? → Allow access                              │
│  Not authenticated? → 401 Unauthorized                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## SecurityConfig

### What SecurityConfig Does

Configures which endpoints need authentication and adds JWT filter.

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
    public SecurityFilterChain securityFilterChain(HttpSecurity http) 
            throws Exception {
        http
            // 1. Disable CSRF (not needed for stateless JWT)
            .csrf(csrf -> csrf.disable())
            
            // 2. Configure endpoint authorization
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/login").permitAll()  // Public
                .anyRequest().authenticated()                 // All else protected
            )
            
            // 3. Add JWT filter BEFORE default auth filter
            .addFilterBefore(jwtFilter, 
                UsernamePasswordAuthenticationFilter.class)
            
            // 4. Stateless session (no server-side session)
            .sessionManagement(sess -> 
                sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }
}
```

### Configuration Breakdown

| Configuration | Purpose |
|---------------|---------|
| `.csrf(csrf -> csrf.disable())` | JWT is stateless, no CSRF needed |
| `.requestMatchers("/auth/login").permitAll()` | Login endpoint is public |
| `.anyRequest().authenticated()` | All other endpoints require JWT |
| `.addFilterBefore(jwtFilter, ...)` | Run JWT filter before default auth |
| `SessionCreationPolicy.STATELESS` | No server session, rely on JWT |

### Why STATELESS?

```
┌─────────────────────────────────────────────────────────────┐
│           Session Policy: STATELESS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Traditional (Session-based):                               │
│    Server stores session → Consumes memory                  │
│    Cookie: JSESSIONID → Server looks up user                │
│                                                             │
│  JWT (Stateless):                                           │
│    Server stores NOTHING                                    │
│    Token contains all user info                             │
│    Each request is independent                              │
│                                                             │
│  Benefits of STATELESS:                                     │
│    ✅ No server memory used                                 │
│    ✅ Easy horizontal scaling                               │
│    ✅ Works across multiple servers                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Application Flow

### Complete JWT Authentication Flow

```
┌─────────────────────────────────────────────────────────────┐
│           JWT Request Flow                                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Client sends request with JWT                           │
│     GET /api/hello                                          │
│     Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...           │
│                                                             │
│  2. JwtAuthFilter intercepts                                │
│     → Extracts token from header                            │
│     → Validates signature                                   │
│     → Checks expiry                                         │
│                                                             │
│  3. If valid: Set SecurityContext                           │
│     SecurityContextHolder.getContext()                      │
│         .setAuthentication(authToken)                       │
│                                                             │
│  4. Request passes to controller                            │
│     @RestController handles request                         │
│                                                             │
│  5. Response returned to client                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## First vs Subsequent Requests

### First Request (Login)

```
┌─────────────────────────────────────────────────────────────┐
│           First Request: Login                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  POST /auth/login                                           │
│  Body: { "username": "Abc", "password": "123" }             │
│                                                             │
│  Flow:                                                      │
│    1. JwtAuthFilter runs (no token found)                   │
│    2. /auth/login is permitAll() → No auth needed           │
│    3. AuthController receives request                       │
│    4. Validates credentials                                 │
│    5. Generates JWT token                                   │
│    6. Returns token to client                               │
│                                                             │
│  Response:                                                  │
│  { "token": "eyJhbGciOiJIUzI1NiJ9..." }                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Subsequent Requests (API Access)

```
┌─────────────────────────────────────────────────────────────┐
│           Subsequent Requests: Protected API                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GET /api/hello                                             │
│  Header: Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...      │
│                                                             │
│  Flow:                                                      │
│    1. JwtAuthFilter runs                                    │
│    2. Token found in Authorization header                   │
│    3. Token validated → User authenticated                  │
│    4. SecurityContext populated                             │
│    5. /api/hello requires authentication ✓                  │
│    6. HelloController handles request                       │
│    7. Returns response                                      │
│                                                             │
│  Response: "Hello Abc, you accessed protected API!"         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete Integration Code

### HelloController.java

```java
package com.example.demo;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        // Get authenticated user from SecurityContext
        Authentication auth = SecurityContextHolder.getContext()
                                                   .getAuthentication();
        String username = (String) auth.getPrincipal();
        
        return "Hello " + username + ", you accessed a protected API!";
    }
}
```

### Key Points

| Concept | Explanation |
|---------|-------------|
| `SecurityContextHolder` | Thread-local storage for auth info |
| `getAuthentication()` | Gets current user's authentication |
| `getPrincipal()` | Returns username (set in filter) |

---

## Interview Questions

### Q1: What is OncePerRequestFilter?
**Answer**: A Spring filter that guarantees execution only once per request, even if request is forwarded internally. JwtAuthFilter extends it to ensure token validation happens exactly once.

### Q2: Why add JWT filter BEFORE UsernamePasswordAuthenticationFilter?
**Answer**: We want JWT validation to happen first. If valid, it sets authentication and skips username/password processing. Order matters in filter chain.

### Q3: What is SecurityContextHolder?
**Answer**: Thread-local storage that holds the current authenticated user's details. Set by filter, read by controllers. Cleared after request completes.

### Q4: What if token is invalid or missing?
**Answer**: 
- Missing: SecurityContext stays empty → 401 Unauthorized
- Invalid: Validation fails → SecurityContext not set → 401
- Expired: Considered invalid → 401

### Q5: Why STATELESS session policy?
**Answer**: JWT is self-contained. Server doesn't need sessions. STATELESS means:
- No JSESSIONID cookie
- No server-side session storage
- Better for horizontal scaling

### Q6: What does permitAll() do?
**Answer**: Allows requests to specified endpoints without any authentication. Used for login, register, and public APIs.

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           JWT Spring Security Summary                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  JwtAuthFilter:                                             │
│    → Extends OncePerRequestFilter                           │
│    → Extracts token from "Authorization: Bearer ..."        │
│    → Validates and sets SecurityContext                     │
│                                                             │
│  SecurityConfig:                                            │
│    → Disables CSRF                                          │
│    → Configures public vs protected endpoints               │
│    → Adds JWT filter to chain                               │
│    → Sets STATELESS session policy                          │
│                                                             │
│  Flow:                                                      │
│    Login → Get token → Send with requests → Filter validates│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Next: [09_JWT_Refresh_Tokens.md](./09_JWT_Refresh_Tokens.md)*
