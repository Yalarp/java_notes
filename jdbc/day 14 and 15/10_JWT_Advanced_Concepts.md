# 🌐 JWT Advanced Concepts

## Table of Contents
1. [JWT in Distributed Systems](#jwt-in-distributed-systems)
2. [Symmetric vs Asymmetric Keys](#symmetric-vs-asymmetric-keys)
3. [Public/Private Key JWT](#publicprivate-key-jwt)
4. [Token Blacklisting](#token-blacklisting)
5. [JWT Security Risks and Fixes](#jwt-security-risks-and-fixes)
6. [Importance of Signature](#importance-of-signature)
7. [Server Shutdown and Token Validity](#server-shutdown-and-token-validity)
8. [JWT with Thymeleaf Integration](#jwt-with-thymeleaf-integration)
9. [Best Practices](#best-practices)
10. [Interview Questions](#interview-questions)

---

## JWT in Distributed Systems

### The Challenge

```
┌─────────────────────────────────────────────────────────┐
│           Distributed System Challenge                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Scenario: Multiple servers behind load balancer        │
│                                                         │
│          ┌─────────────┐                               │
│  User ──→│Load Balancer│──→ Server A ✓                 │
│          └─────────────┘──→ Server B                   │
│                          ──→ Server C                   │
│                                                         │
│  Problem:                                               │
│    Token created by Server A                            │
│    Next request goes to Server B                        │
│    Can Server B validate the token?                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Solution: Shared Secret (HS256)

```
┌─────────────────────────────────────────────────────────┐
│           Shared Secret Approach                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ALL servers share the SAME secret key:                 │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ Server A │  │ Server B │  │ Server C │              │
│  │   KEY    │  │   KEY    │  │   KEY    │              │
│  │ = XYZ    │  │ = XYZ    │  │ = XYZ    │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  ✅ Any server can validate tokens from any server     │
│  ✅ Simple to implement                                 │
│  ❌ Secret must be distributed securely                 │
│  ❌ If one server compromised, all are                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Solution: Public/Private Keys (RS256)

```
┌─────────────────────────────────────────────────────────┐
│           Public/Private Key Approach                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Auth Server: Has PRIVATE key (signs tokens)            │
│  API Servers: Have PUBLIC key (verify tokens)           │
│                                                         │
│  ┌──────────────┐                                      │
│  │ Auth Server  │ ← Private Key (SECRET)               │
│  │ Signs tokens │                                      │
│  └──────────────┘                                      │
│         ↓                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ Server A │  │ Server B │  │ Server C │              │
│  │ Public   │  │ Public   │  │ Public   │              │
│  │ Key only │  │ Key only │  │ Key only │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                         │
│  ✅ API servers can't create fake tokens                │
│  ✅ More secure for microservices                       │
│  ❌ More complex setup                                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Symmetric vs Asymmetric Keys

### Comparison Table

| Feature | Symmetric (HS256) | Asymmetric (RS256) |
|---------|-------------------|-------------------|
| **Key Type** | Single shared key | Public + Private key pair |
| **Signing** | Same key signs & verifies | Private signs, Public verifies |
| **Speed** | Faster | Slower |
| **Security** | Key must be shared | Private key stays secret |
| **Use Case** | Single server, simple apps | Microservices, distributed |
| **Algorithm** | HMAC-SHA256 | RSA-SHA256 |

### When to Use Which

```
┌─────────────────────────────────────────────────────────┐
│           Choosing the Right Algorithm                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Use SYMMETRIC (HS256) when:                            │
│    • Single server or tightly coupled services          │
│    • Same team controls all services                    │
│    • Simpler implementation preferred                   │
│    • Performance is critical                            │
│                                                         │
│  Use ASYMMETRIC (RS256) when:                           │
│    • Microservices architecture                         │
│    • Different teams own different services             │
│    • Third parties need to verify tokens                │
│    • Higher security requirements                       │
│    • Auth server separate from API servers              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Public/Private Key JWT

### How It Works

```
┌─────────────────────────────────────────────────────────┐
│           RS256 Token Flow                               │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. USER LOGS IN                                        │
│     User → Auth Server                                  │
│     Auth Server creates JWT                             │
│     Signs with PRIVATE KEY                              │
│     Returns token to user                               │
│                                                         │
│  2. USER ACCESSES API                                   │
│     User → API Server (with JWT)                        │
│     API Server verifies signature                       │
│     Uses PUBLIC KEY (cannot sign!)                      │
│     If valid → returns data                             │
│                                                         │
│  KEY INSIGHT:                                           │
│    Private Key = CAN sign, CAN verify                   │
│    Public Key = CANNOT sign, CAN verify                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Why API Servers Can't Fake Tokens

```
┌─────────────────────────────────────────────────────────┐
│           Security Benefit                               │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Compromised API Server scenario:                       │
│                                                         │
│  HS256 (Shared Secret):                                 │
│    Attacker has the key                                 │
│    Can create ANY token ❌                              │
│    Can impersonate ANY user ❌                          │
│                                                         │
│  RS256 (Public/Private):                                │
│    Attacker only has PUBLIC key                         │
│    Cannot create valid tokens ✅                        │
│    Damage limited to that server only ✅                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Token Blacklisting

### The Logout Problem

```
┌─────────────────────────────────────────────────────────┐
│           JWT Logout Challenge                           │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Problem:                                               │
│    JWT is stateless                                     │
│    Token valid until expiry                             │
│    How to "logout" a user immediately?                  │
│                                                         │
│  Scenario:                                              │
│    User clicks LOGOUT                                   │
│    Token still valid for 2 more hours                   │
│    If stolen, attacker can still use it!                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Solution: Token Blacklist/Denylist

```
┌─────────────────────────────────────────────────────────┐
│           Token Blacklisting                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Approach:                                              │
│    Store invalidated tokens in a "blacklist"            │
│    Check blacklist on every request                     │
│    If token in blacklist → reject                       │
│                                                         │
│  Storage Options:                                       │
│                                                         │
│  1. Redis (Recommended)                                 │
│     ✅ In-memory, very fast                             │
│     ✅ TTL support (auto-cleanup)                       │
│     ✅ Distributed (works with multiple servers)        │
│                                                         │
│  2. Database                                            │
│     ✅ Persistent                                       │
│     ❌ Slower                                           │
│     ❌ Needs manual cleanup                             │
│                                                         │
│  3. In-Memory Set                                       │
│     ✅ Fastest                                          │
│     ❌ Lost on restart                                  │
│     ❌ Not distributed                                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Redis Implementation Concept

```java
// Conceptual implementation
@Service
public class TokenBlacklistService {
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    
    // Add token to blacklist with TTL
    public void blacklistToken(String token, long expiryMillis) {
        long ttl = expiryMillis - System.currentTimeMillis();
        if (ttl > 0) {
            redisTemplate.opsForValue().set(
                "blacklist:" + token, 
                "revoked",
                ttl, 
                TimeUnit.MILLISECONDS
            );
        }
    }
    
    // Check if token is blacklisted
    public boolean isBlacklisted(String token) {
        return redisTemplate.hasKey("blacklist:" + token);
    }
}
```

### TTL (Time To Live) Explained

```
┌─────────────────────────────────────────────────────────┐
│           TTL for Blacklisted Tokens                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Why use TTL?                                           │
│    Token expires at: 3:00 PM                            │
│    User logs out at: 2:30 PM                            │
│    Blacklist entry needed for: 30 minutes only          │
│                                                         │
│  After token naturally expires:                         │
│    No point keeping in blacklist                        │
│    Redis auto-deletes after TTL                         │
│    Saves memory                                         │
│                                                         │
│  Formula:                                               │
│    TTL = Token Expiry Time - Current Time               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## JWT Security Risks and Fixes

### Common Vulnerabilities

| Risk | Description | Fix |
|------|-------------|-----|
| **Token Theft** | Attacker steals token from browser | HTTPS, HttpOnly cookies, short expiry |
| **Replay Attack** | Reusing stolen token | Short expiry, token rotation |
| **Key Leakage** | Secret key exposed | Secure storage, key rotation |
| **Weak Algorithm** | Using "none" or weak algo | Always use HS256/RS256, validate algo |
| **Info Disclosure** | Sensitive data in payload | Don't put secrets in JWT |
| **Long Expiry** | Token valid too long | Short access tokens + refresh tokens |

### Secure JWT Checklist

```
┌─────────────────────────────────────────────────────────┐
│           JWT Security Checklist                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ✓ Use HTTPS everywhere                                 │
│  ✓ Use strong algorithm (HS256 or RS256)                │
│  ✓ Validate algorithm in header (prevent "none")        │
│  ✓ Keep expiry short (15-60 minutes for access)         │
│  ✓ Implement refresh token mechanism                    │
│  ✓ Store secrets securely (env vars, vault)             │
│  ✓ Don't put sensitive data in payload                  │
│  ✓ Validate all claims (exp, iss, aud)                  │
│  ✓ Consider token blacklisting for logout               │
│  ✓ Rotate secrets periodically                          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Importance of Signature

### What Signature Protects

```
┌─────────────────────────────────────────────────────────┐
│           Why Signature is Critical                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Without Signature:                                     │
│    Anyone can create fake tokens                        │
│    Attackers can modify claims                          │
│    No way to verify authenticity                        │
│                                                         │
│  With Signature:                                        │
│    Only server with secret can sign                     │
│    Any modification detected                            │
│    Authenticity guaranteed                              │
│                                                         │
│  Example Attack (prevented by signature):               │
│    Original: { "sub": "user", "role": "USER" }          │
│    Modified: { "sub": "user", "role": "ADMIN" }         │
│    Signature check fails → Attack blocked ✅            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Signature Verification Flow

```
┌─────────────────────────────────────────────────────────┐
│           Signature Verification                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Token received: header.payload.signature               │
│                                                         │
│  Step 1: Server extracts header + payload               │
│  Step 2: Server calculates expected signature:          │
│          expected = HMAC(header + payload, SECRET)      │
│  Step 3: Compare expected vs received signature         │
│                                                         │
│  If match:                                              │
│    → Token is authentic                                 │
│    → Content not modified                               │
│    → Proceed with request                               │
│                                                         │
│  If no match:                                           │
│    → Token tampered OR                                  │
│    → Wrong secret key used                              │
│    → Reject request                                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Server Shutdown and Token Validity

### Common Question

```
┌─────────────────────────────────────────────────────────┐
│           Server Downtime and JWT                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Q: If server shuts down for 10 min, does               │
│     token expiry time extend?                           │
│                                                         │
│  A: NO! Absolutely NOT!                                 │
│                                                         │
│  Reason:                                                │
│    Expiry is EMBEDDED in the token                      │
│    It's a fixed timestamp                               │
│    Server state doesn't affect it                       │
│                                                         │
│  Example:                                               │
│    Token created: 10:00 AM                              │
│    Token expires: 10:20 AM (embedded in token)          │
│    Server down: 10:05 - 10:15 (10 min)                  │
│    Token still expires: 10:20 AM                        │
│                                                         │
│  The exp claim contains:                                │
│    Unix timestamp (e.g., 1716242622)                    │
│    This is a fixed point in time                        │
│    Independent of server uptime                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## JWT with Thymeleaf Integration

### Use Case

```
┌─────────────────────────────────────────────────────────┐
│           JWT + Thymeleaf                                │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Typical flow for web app with Thymeleaf:               │
│                                                         │
│  1. User logs in via form                               │
│  2. Server generates JWT                                │
│  3. Token stored in:                                    │
│     - HttpOnly cookie (secure)                          │
│     - Or hidden form field (less secure)                │
│                                                         │
│  4. Thymeleaf pages include token in requests           │
│  5. Server validates JWT for each page                  │
│                                                         │
│  Note: For pure Thymeleaf apps, session-based           │
│  auth might be simpler. JWT shines for:                 │
│    - REST APIs                                          │
│    - SPAs (React/Angular + backend)                     │
│    - Hybrid apps (Thymeleaf + AJAX calls)               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Best Practices

### Production Recommendations

```
┌─────────────────────────────────────────────────────────┐
│           JWT Best Practices                             │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. SECRET KEY MANAGEMENT                               │
│     ✓ Store in environment variables                    │
│     ✓ Use secret managers (Vault, AWS Secrets)          │
│     ✓ Never commit to source control                    │
│     ✓ Rotate periodically                               │
│                                                         │
│  2. TOKEN EXPIRY                                        │
│     ✓ Access: 5-60 minutes                              │
│     ✓ Refresh: hours to days                            │
│     ✓ Consider sliding expiry for UX                    │
│                                                         │
│  3. PAYLOAD CONTENT                                     │
│     ✓ Include: sub, iss, iat, exp                       │
│     ✓ Optional: roles, permissions                      │
│     ✗ Never: passwords, credit card, PII               │
│                                                         │
│  4. TRANSPORT                                           │
│     ✓ Always use HTTPS                                  │
│     ✓ Authorization: Bearer <token>                     │
│     ✓ Consider HttpOnly cookies for refresh             │
│                                                         │
│  5. VALIDATION                                          │
│     ✓ Verify signature                                  │
│     ✓ Check expiration                                  │
│     ✓ Validate issuer (iss)                             │
│     ✓ Validate audience (aud) if used                   │
│     ✓ Check algorithm (prevent "none" attack)           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Interview Questions

### Q1: What's the difference between HS256 and RS256?
**Answer**:
- **HS256** (Symmetric): Uses single shared secret for signing and verification. Faster, simpler, but all parties need the secret.
- **RS256** (Asymmetric): Uses private key to sign, public key to verify. More secure for distributed systems as API servers can't forge tokens.

### Q2: How do you implement logout with JWT?
**Answer**: Since JWT is stateless, there are several approaches:
1. **Token blacklisting**: Store revoked tokens in Redis with TTL
2. **Short expiry**: Use very short access tokens + refresh tokens
3. **Token rotation**: Issue new token ID on each request
4. **Client-side logout**: Delete token from client (not truly secure)

### Q3: What is token blacklisting?
**Answer**: Token blacklisting is storing invalidated tokens (e.g., after logout) in a fast data store like Redis. On each request, check if token is blacklisted before allowing access. Use TTL matching token expiry for automatic cleanup.

### Q4: Which is better for microservices: HS256 or RS256?
**Answer**: **RS256** is better because:
- Auth server keeps private key
- API servers only have public key
- Compromised API server can't forge tokens
- More secure separation of concerns

### Q5: If server restarts, does JWT expiry change?
**Answer**: No. JWT expiry is encoded as a Unix timestamp in the token itself. It's a fixed point in time, completely independent of server state.

### Q6: How do you store JWT secrets securely?
**Answer**:
- Environment variables (minimum)
- Secret managers (Vault, AWS Secrets Manager)
- Kubernetes Secrets
- Never in source code or config files committed to Git

### Q7: What's the "none" algorithm attack?
**Answer**: Attacker modifies JWT header to use "alg": "none", removing signature requirement. Fix: Always validate algorithm on server side and reject "none".

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│           JWT Advanced Concepts Summary                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Distributed Systems:                                   │
│    HS256 = Shared secret across all servers             │
│    RS256 = Private signs, Public verifies               │
│                                                         │
│  Token Blacklisting:                                    │
│    Use Redis with TTL for logout                        │
│    Only keep until token would naturally expire         │
│                                                         │
│  Security Best Practices:                               │
│    HTTPS always                                         │
│    Short access tokens                                  │
│    Refresh token mechanism                              │
│    Validate all claims                                  │
│    Secure secret storage                                │
│                                                         │
│  Key Takeaways:                                         │
│    Signature = Integrity + Authenticity                 │
│    Expiry is embedded, server-independent               │
│    RS256 better for microservices                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

*Next: [11_SSO_OAuth2_Introduction.md](./11_SSO_OAuth2_Introduction.md)*
