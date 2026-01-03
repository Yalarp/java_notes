# 🔄 JWT Refresh Tokens Implementation

## Table of Contents
1. [Introduction](#introduction)
2. [Why Refresh Tokens](#why-refresh-tokens)
3. [Access Token vs Refresh Token](#access-token-vs-refresh-token)
4. [Project Setup](#project-setup)
5. [Complete Code Implementation](#complete-code-implementation)
6. [JwtUtil Enhanced](#jwtutil-enhanced)
7. [Application Flow](#application-flow)
8. [Token Storage Strategies](#token-storage-strategies)
9. [Testing the Application](#testing-the-application)
10. [Interview Questions](#interview-questions)

---

## Introduction

This note covers implementing **JWT with Refresh Tokens** in Spring Boot. Refresh tokens allow users to obtain new access tokens without re-entering credentials.

### What We're Building

```
┌─────────────────────────────────────────────────────────┐
│            JWT with Refresh Tokens                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Endpoints:                                             │
│    POST /auth/login    → Get access + refresh tokens    │
│    POST /auth/refresh  → Get new access token           │
│    GET  /api/hello     → Protected API                  │
│                                                         │
│  Token Expiry:                                          │
│    Access Token:  5 minutes (short-lived)               │
│    Refresh Token: 15 minutes (longer-lived)             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Why Refresh Tokens

### Problem with Single Token

```
┌─────────────────────────────────────────────────────────┐
│           Problem: Single Access Token                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  If access token expires after 1 hour:                  │
│                                                         │
│  ❌ Long expiry = Higher risk if stolen                 │
│  ❌ Short expiry = User logs in frequently              │
│                                                         │
│  Dilemma:                                               │
│    Want short expiry (security)                         │
│    But don't want frequent logins (UX)                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Solution: Dual Token System

```
┌─────────────────────────────────────────────────────────┐
│           Solution: Access + Refresh Tokens              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Access Token (Short-lived: 5-15 minutes)               │
│    • Used for API calls                                 │
│    • If stolen, limited damage window                   │
│    • Sent with every request                            │
│                                                         │
│  Refresh Token (Longer-lived: days/weeks)               │
│    • Used ONLY to get new access tokens                 │
│    • Stored securely (not in localStorage)              │
│    • Never sent to regular APIs                         │
│                                                         │
│  Result:                                                │
│    ✅ Security: Short access token expiry               │
│    ✅ UX: No frequent logins (refresh token renews)     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Access Token vs Refresh Token

### Comparison Table

| Feature | Access Token | Refresh Token |
|---------|-------------|---------------|
| **Purpose** | Access APIs | Get new access tokens |
| **Expiry** | 5-15 minutes | Days to weeks |
| **Sent to** | Every protected API | Only /auth/refresh |
| **Storage** | Memory/localStorage | Secure cookie/encrypted |
| **If Stolen** | Limited damage | More serious (revoke!) |

### Token Flow Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant C as Client App
    participant S as Server

    Note over U,S: Initial Login
    U->>C: Enter credentials
    C->>S: POST /auth/login
    S-->>C: {accessToken, refreshToken}
    C->>C: Store both tokens

    Note over U,S: Normal API Calls
    C->>S: GET /api/hello (Access Token)
    S-->>C: Response

    Note over U,S: Access Token Expires
    C->>S: GET /api/hello (Expired Token)
    S-->>C: 401 Unauthorized

    Note over U,S: Token Refresh
    C->>S: POST /auth/refresh (Refresh Token)
    S-->>C: {newAccessToken, sameRefreshToken}
    C->>C: Store new access token

    Note over U,S: Continue with New Token
    C->>S: GET /api/hello (New Access Token)
    S-->>C: Response
```

---

## Project Setup

### Additional Configuration

```properties
# application.properties
jwt.secret=MySecretKeyForJwt123456789012345
```

### Project Structure

```
src/main/java/
└── com/example/demo/
    ├── JwtEx2Application.java
    ├── JwtUtil.java           (Enhanced with refresh token)
    ├── JwtAuthFilter.java
    ├── AuthController.java    (Login + Refresh endpoints)
    ├── HelloController.java
    ├── SecurityConfig.java
    ├── LoginRequest.java
    └── AuthResponse.java      (Response DTO)
```

---

## Complete Code Implementation

### 1. AuthResponse DTO

```java
// AuthResponse.java
package com.example.demo;

public class AuthResponse {
    private String accessToken;
    private String refreshToken;

    public AuthResponse(String accessToken, String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }

    // Getters and Setters
    public String getAccessToken() { 
        return accessToken; 
    }
    
    public void setAccessToken(String accessToken) { 
        this.accessToken = accessToken; 
    }
    
    public String getRefreshToken() { 
        return refreshToken; 
    }
    
    public void setRefreshToken(String refreshToken) { 
        this.refreshToken = refreshToken; 
    }
}
```

---

### 2. JwtUtil (Enhanced with Refresh Token)

```java
// JwtUtil.java
package com.example.demo;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;

@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String secret;

    // Token expiry times
    private final long ACCESS_TOKEN_EXPIRY = 5 * 60 * 1000;   // 5 minutes
    private final long REFRESH_TOKEN_EXPIRY = 15 * 60 * 1000; // 15 minutes

    // Get signing key from secret
    private Key getSigningKey() {
        return Keys.hmacShaKeyFor(secret.getBytes());
    }

    // Generate Access Token (short-lived)
    public String generateAccessToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuer("NitinAuthServer")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + ACCESS_TOKEN_EXPIRY))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    // Generate Refresh Token (longer-lived)
    public String generateRefreshToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuer("NitinAuthServer")
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + REFRESH_TOKEN_EXPIRY))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    // Validate any token
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

    // Get all claims
    private Claims getClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}
```

---

### 3. AuthController (Login + Refresh)

```java
// AuthController.java
package com.example.demo;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final JwtUtil jwtUtil;

    public AuthController(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    // Login endpoint - returns both tokens
    @PostMapping("/login")
    public AuthResponse login(@RequestBody LoginRequest request) {
        // Simple credential check (use database in production)
        if (request.getUsername().equals("Abc") && 
            request.getPassword().equals("123")) {
            
            String accessToken = jwtUtil.generateAccessToken(request.getUsername());
            String refreshToken = jwtUtil.generateRefreshToken(request.getUsername());
            
            return new AuthResponse(accessToken, refreshToken);
        }
        throw new RuntimeException("Invalid credentials");
    }

    // Refresh endpoint - returns new access token
    @PostMapping("/refresh")
    public AuthResponse refresh(@RequestBody RefreshRequest request) {
        String refreshToken = request.getRefreshToken();
        
        // Validate refresh token
        if (jwtUtil.isTokenValid(refreshToken)) {
            String username = jwtUtil.extractUsername(refreshToken);
            
            // Generate new access token
            String newAccessToken = jwtUtil.generateAccessToken(username);
            
            // Return new access token with SAME refresh token
            return new AuthResponse(newAccessToken, refreshToken);
        }
        throw new RuntimeException("Invalid or expired refresh token");
    }
}
```

---

### 4. RefreshRequest DTO

```java
// RefreshRequest.java
package com.example.demo;

public class RefreshRequest {
    private String refreshToken;

    public String getRefreshToken() { 
        return refreshToken; 
    }
    
    public void setRefreshToken(String refreshToken) { 
        this.refreshToken = refreshToken; 
    }
}
```

---

### 5. SecurityConfig

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
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/login", "/auth/refresh").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class)
            .sessionManagement(sess -> 
                sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );

        return http.build();
    }
}
```

> [!NOTE]
> Both `/auth/login` and `/auth/refresh` are public endpoints (permitAll).

---

## JwtUtil Enhanced

### Key Differences from Basic Version

```
┌─────────────────────────────────────────────────────────┐
│            JwtUtil Enhancement                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Secret from application.properties                  │
│     @Value("${jwt.secret}")                             │
│     private String secret;                              │
│                                                         │
│  2. Two token generation methods                        │
│     generateAccessToken()  → 5 min expiry               │
│     generateRefreshToken() → 15 min expiry              │
│                                                         │
│  3. Configurable expiry times                           │
│     ACCESS_TOKEN_EXPIRY = 5 * 60 * 1000;                │
│     REFRESH_TOKEN_EXPIRY = 15 * 60 * 1000;              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Why @Value for Secret?

```java
@Value("${jwt.secret}")
private String secret;
```

**Benefits:**
- Secret not hardcoded in source
- Can use different secrets per environment
- Easier to rotate secrets
- More secure for production

---

## Application Flow

### Complete Flow with Refresh

```
┌─────────────────────────────────────────────────────────┐
│            JWT Refresh Token Flow                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  STEP 1 — LOGIN                                         │
│  ─────────────────                                      │
│  POST /auth/login                                       │
│  Body: { "username": "Abc", "password": "123" }         │
│                                                         │
│  Response:                                              │
│  {                                                      │
│    "accessToken": "eyJhbG...",   // expires in 5 min   │
│    "refreshToken": "eyJhbG..."   // expires in 15 min  │
│  }                                                      │
│                                                         │
│  STEP 2 — CALL SECURED API                              │
│  ─────────────────────────                              │
│  GET /api/hello                                         │
│  Header: Authorization: Bearer <accessToken>            │
│                                                         │
│  Response: "Hello Abc, you accessed..."                 │
│                                                         │
│  STEP 3 — ACCESS TOKEN EXPIRES (after 5 min)            │
│  ───────────────────────────────────────────            │
│  GET /api/hello → 401 Unauthorized                      │
│                                                         │
│  STEP 4 — REFRESH TOKEN                                 │
│  ──────────────────────                                 │
│  POST /auth/refresh                                     │
│  Body: { "refreshToken": "eyJhbG..." }                  │
│                                                         │
│  Response:                                              │
│  {                                                      │
│    "accessToken": "NEW_TOKEN",   // new access token   │
│    "refreshToken": "SAME_TOKEN"  // same refresh token │
│  }                                                      │
│                                                         │
│  STEP 5 — CONTINUE USING NEW ACCESS TOKEN               │
│  ────────────────────────────────────────               │
│  GET /api/hello with new accessToken → Success!         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Refresh Token Lifecycle

```
┌─────────────────────────────────────────────────────────┐
│           Token Lifecycle                                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Time: 0 min                                            │
│  ├─ Access Token created (valid until 5 min)            │
│  └─ Refresh Token created (valid until 15 min)          │
│                                                         │
│  Time: 5 min                                            │
│  ├─ Access Token EXPIRED ❌                             │
│  └─ Refresh Token still valid ✓                         │
│      └─ Use to get new Access Token                     │
│                                                         │
│  Time: 10 min                                           │
│  ├─ New Access Token (from refresh at 5 min) EXPIRED ❌ │
│  └─ Refresh Token still valid ✓                         │
│      └─ Use to get another Access Token                 │
│                                                         │
│  Time: 15 min                                           │
│  ├─ Access Token EXPIRED ❌                             │
│  └─ Refresh Token EXPIRED ❌                            │
│      └─ User must LOGIN again with credentials          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Token Storage Strategies

### Where to Store Tokens (Client-Side)

```
┌─────────────────────────────────────────────────────────┐
│           Token Storage Options                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. localStorage                                        │
│     ✅ Easy to use                                      │
│     ❌ Vulnerable to XSS attacks                        │
│     Use: Access token (short-lived)                     │
│                                                         │
│  2. HttpOnly Cookie                                     │
│     ✅ Not accessible by JavaScript                     │
│     ✅ Automatically sent with requests                 │
│     ❌ Vulnerable to CSRF (mitigate with token)         │
│     Use: Refresh token (secure)                         │
│                                                         │
│  3. Memory (JavaScript variable)                        │
│     ✅ Most secure (cleared on refresh)                 │
│     ❌ Lost on page refresh                             │
│     Use: Access token in SPAs                           │
│                                                         │
│  RECOMMENDED APPROACH:                                  │
│     Access Token  → Memory or localStorage              │
│     Refresh Token → HttpOnly Secure Cookie              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Testing the Application

### Step 1: Login

```
Method: POST
URL: http://localhost:8080/auth/login

Headers:
  Content-Type: application/json

Body:
{
  "username": "Abc",
  "password": "123"
}

Response:
{
  "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBYmMi...",
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBYmMi..."
}
```

### Step 2: Access Protected API

```
Method: GET
URL: http://localhost:8080/api/hello

Headers:
  Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

Response:
"Hello Abc, you accessed a protected resource!"
```

### Step 3: Refresh Token

```
Method: POST
URL: http://localhost:8080/auth/refresh

Headers:
  Content-Type: application/json

Body:
{
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9..."
}

Response:
{
  "accessToken": "eyJhbGciOiJIUzI1NiJ9...(NEW)",
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9...(SAME)"
}
```

### Test Matrix

| Scenario | Expected |
|----------|----------|
| Login with valid credentials | Returns both tokens |
| Call /api/hello with valid access token | Success |
| Call /api/hello with expired access token | 401 Unauthorized |
| Refresh with valid refresh token | New access token |
| Refresh with expired refresh token | Error |
| Refresh with invalid refresh token | Error |

---

## Interview Questions

### Q1: What is a refresh token?
**Answer**: A refresh token is a long-lived token used exclusively to obtain new access tokens without requiring the user to re-enter credentials. It's stored securely and only sent to the refresh endpoint.

### Q2: Why return the same refresh token during refresh?
**Answer**: In this simple implementation, we return the same refresh token. In production, you might:
- Issue a new refresh token (rotation)
- Keep the same one if it's still valid
- Implement "sliding window" expiry

### Q3: What happens when refresh token expires?
**Answer**: User must log in again with credentials. The refresh token cannot be renewed without credentials - this is the security boundary.

### Q4: Where should refresh tokens be stored?
**Answer**: Refresh tokens should be stored in HttpOnly Secure cookies, which are:
- Not accessible by JavaScript (XSS protection)
- Sent automatically with requests
- Protected by HTTPS (Secure flag)

### Q5: What's the difference between access and refresh token expiry?
**Answer**:
- **Access Token**: Short (5-60 minutes) - limits damage if stolen
- **Refresh Token**: Longer (hours to days) - for user convenience

### Q6: Should access and refresh tokens use the same secret?
**Answer**: They can use the same secret, but production systems often use different secrets or key pairs for additional security and flexibility in token management.

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           JWT with Refresh Tokens Summary                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Two Token Types:                                       │
│    Access Token  → Short-lived, for API access          │
│    Refresh Token → Long-lived, for getting new access   │
│                                                         │
│  Endpoints:                                             │
│    /auth/login   → Returns both tokens                  │
│    /auth/refresh → Returns new access token             │
│    /api/hello    → Protected, needs access token        │
│                                                         │
│  Token Lifecycle:                                       │
│    Access expired? → Use refresh token                  │
│    Refresh expired? → Login again                       │
│                                                         │
│  Security Best Practices:                               │
│    Store refresh token in HttpOnly cookie               │
│    Keep access token short-lived                        │
│    Consider token rotation                              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

*Next: [10_JWT_Advanced_Concepts.md](./10_JWT_Advanced_Concepts.md)*
