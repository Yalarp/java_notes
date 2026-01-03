# 🔍 Spring Boot Actuator

## Table of Contents
1. [What is Actuator](#what-is-actuator)
2. [Enabling Actuator](#enabling-actuator)
3. [Built-in Endpoints](#built-in-endpoints)
4. [Endpoint Configuration](#endpoint-configuration)
5. [Production Monitoring](#production-monitoring)
6. [Security Considerations](#security-considerations)
7. [Interview Questions](#interview-questions)

---

## What is Actuator

### Definition

**Spring Boot Actuator** provides production-ready features to monitor and manage your application.

```
┌─────────────────────────────────────────────────────────────┐
│           What is Spring Boot Actuator?                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Spring Boot Actuator provides special features to          │
│  monitor and manage your application when you push it       │
│  to production (deployment).                                │
│                                                             │
│  Use Cases:                                                 │
│    ✓ Check "health" of your application                     │
│    ✓ View application info (beans, mappings)                │
│    ✓ Get metrics (memory, CPU, requests)                    │
│    ✓ View environment properties                            │
│    ✓ Perform heap dump                                      │
│    ✓ Shutdown application remotely                          │
│                                                             │
│  How it works:                                              │
│    Actuator exposes HTTP endpoints (URLs) that              │
│    return JSON data about your application                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Why Use Actuator?

| Feature | Benefit |
|---------|---------|
| **Health Check** | Verify app is running, DB connected |
| **Metrics** | Monitor memory, CPU, request counts |
| **Environment** | View all properties and their values |
| **Mappings** | See all REST endpoints in application |
| **Beans** | List all Spring beans and their types |
| **Shutdown** | Gracefully stop application remotely |

---

## Enabling Actuator

### Add Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### Default Behavior

```
┌─────────────────────────────────────────────────────────────┐
│           Actuator Default Behavior                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  After adding dependency:                                   │
│                                                             │
│  By default, ONLY these endpoints are exposed:              │
│    /actuator         → List all available endpoints         │
│    /actuator/health  → Application health status            │
│                                                             │
│  Other endpoints are DISABLED by default for security       │
│                                                             │
│  To expose more endpoints:                                  │
│    application.properties configuration required            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Built-in Endpoints

### Common Actuator Endpoints

| Endpoint | Description | Default |
|----------|-------------|---------|
| `/actuator/health` | Application health status | Enabled |
| `/actuator/info` | Application information | Enabled |
| `/actuator/beans` | List of all Spring beans | Disabled |
| `/actuator/mappings` | List of all @RequestMapping | Disabled |
| `/actuator/env` | Environment properties | Disabled |
| `/actuator/metrics` | Application metrics | Disabled |
| `/actuator/loggers` | Logger configuration | Disabled |
| `/actuator/heapdump` | Heap dump file | Disabled |
| `/actuator/threaddump` | Thread dump | Disabled |
| `/actuator/shutdown` | Shutdown application | Disabled |

### Health Endpoint Response

```json
{
  "status": "UP"
}
```

### Mappings Endpoint Response (Sample)

```json
{
  "contexts": {
    "application": {
      "mappings": {
        "dispatcherServlets": {
          "dispatcherServlet": [
            {
              "handler": "com.example.ProductController#getProducts()",
              "predicate": "{GET /products}",
              "details": {
                "handlerMethod": {
                  "className": "com.example.ProductController",
                  "name": "getProducts"
                }
              }
            }
          ]
        }
      }
    }
  }
}
```

---

## Endpoint Configuration

### application.properties

```properties
# Expose specific endpoints only
management.endpoints.web.exposure.include=info,health

# OR expose all endpoints (not recommended for production)
# management.endpoints.web.exposure.include=*

# Exclude specific endpoints
management.endpoints.web.exposure.exclude=env,beans

# Change base path (default is /actuator)
management.endpoints.web.base-path=/manage

# Show detailed health information
management.endpoint.health.show-details=always
```

### Configuration Options Explained

| Property | Purpose | Values |
|----------|---------|--------|
| `exposure.include` | Which endpoints to expose | Comma-separated or `*` |
| `exposure.exclude` | Which endpoints to hide | Comma-separated |
| `base-path` | URL prefix | Default: `/actuator` |
| `show-details` | Health details | `never`, `when_authorized`, `always` |

### Example: Expose Only Health and Info

```properties
management.endpoints.web.exposure.include=info,health
```

**Result:**
- `/actuator/health` ✓ Available
- `/actuator/info` ✓ Available
- `/actuator/beans` ✗ Not available
- `/actuator/mappings` ✗ Not available

### Example: Expose All Endpoints

```properties
management.endpoints.web.exposure.include=*
```

**Result:** All endpoints available (security risk!)

---

## Production Monitoring

### Health Check Use Case

```
┌─────────────────────────────────────────────────────────────┐
│           Health Check in Production                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Load Balancer / Kubernetes:                                │
│    Periodically calls: /actuator/health                     │
│                                                             │
│  Response: {"status": "UP"}                                 │
│    → Application is healthy                                 │
│    → Continue sending traffic                               │
│                                                             │
│  Response: {"status": "DOWN"}                               │
│    → Application is unhealthy                               │
│    → Stop sending traffic                                   │
│    → Possibly restart container                             │
│                                                             │
│  Detailed Health (with show-details=always):                │
│  {                                                          │
│    "status": "UP",                                          │
│    "components": {                                          │
│      "db": {"status": "UP"},                                │
│      "diskSpace": {"status": "UP"},                         │
│      "ping": {"status": "UP"}                               │
│    }                                                        │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Use Case

```
┌─────────────────────────────────────────────────────────────┐
│           Metrics Monitoring                                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  /actuator/metrics                                          │
│    Returns list of available metrics                        │
│                                                             │
│  /actuator/metrics/jvm.memory.used                          │
│    Returns current JVM memory usage                         │
│                                                             │
│  /actuator/metrics/http.server.requests                     │
│    Returns HTTP request statistics                          │
│                                                             │
│  Common Metrics:                                            │
│    jvm.memory.used → Memory consumption                     │
│    jvm.gc.pause → Garbage collection time                   │
│    process.cpu.usage → CPU utilization                      │
│    http.server.requests → Request count, response time      │
│                                                             │
│  Integration:                                               │
│    Prometheus → Scrapes /actuator/prometheus                │
│    Grafana → Visualizes metrics                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Security Considerations

### Protecting Actuator Endpoints

```
┌─────────────────────────────────────────────────────────────┐
│           Actuator Security Best Practices                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ⚠️ DANGER: Actuator endpoints can expose sensitive data   │
│                                                             │
│  Risks:                                                     │
│    /actuator/env → Shows all environment variables          │
│       (including passwords, API keys!)                      │
│    /actuator/heapdump → Contains all object data            │
│    /actuator/shutdown → Can stop your application!          │
│                                                             │
│  Best Practices:                                            │
│                                                             │
│  1. Only expose what you need:                              │
│     management.endpoints.web.exposure.include=health,info   │
│                                                             │
│  2. Use different port for actuator:                        │
│     management.server.port=9090                             │
│     (only accessible within internal network)               │
│                                                             │
│  3. Require authentication:                                 │
│     Add Spring Security and protect /actuator/**            │
│                                                             │
│  4. Never expose /shutdown in production                    │
│                                                             │
│  5. Use HTTPS for all actuator endpoints                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Securing with Spring Security

```java
@Configuration
public class SecurityConfig {
    
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health").permitAll()
                .requestMatchers("/actuator/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .httpBasic(withDefaults());
        return http.build();
    }
}
```

---

## Interview Questions

### Q1: What is Spring Boot Actuator?
**Answer**: Spring Boot Actuator provides production-ready features to monitor and manage applications. It exposes HTTP endpoints for health checks, metrics, environment info, and more.

### Q2: How do you enable Actuator?
**Answer**: Add the dependency:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

### Q3: Which endpoints are exposed by default?
**Answer**: Only `/actuator/health` and `/actuator/info` are exposed by default. Others must be explicitly enabled in configuration.

### Q4: How do you expose all Actuator endpoints?
**Answer**: 
```properties
management.endpoints.web.exposure.include=*
```
Note: This is not recommended for production due to security risks.

### Q5: Why is the /actuator/env endpoint dangerous?
**Answer**: It exposes all environment variables including potentially sensitive data like database passwords, API keys, and secrets. Should never be exposed publicly.

### Q6: How is /actuator/health used in production?
**Answer**: Load balancers and container orchestrators (Kubernetes) use it to check if the application is healthy. If status is "DOWN", traffic is routed away from that instance.

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│           Spring Boot Actuator Summary                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  What it does:                                              │
│    Production monitoring and management                     │
│                                                             │
│  Key Endpoints:                                             │
│    /actuator/health → App health status                     │
│    /actuator/info → App information                         │
│    /actuator/metrics → Performance metrics                  │
│    /actuator/mappings → All REST endpoints                  │
│                                                             │
│  Configuration:                                             │
│    management.endpoints.web.exposure.include=health,info    │
│                                                             │
│  Security:                                                  │
│    • Only expose necessary endpoints                        │
│    • Use separate port for internal access                  │
│    • Require authentication for sensitive endpoints         │
│    • Never expose /shutdown in production                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

*Next: [17_Spring_Boot_Profiles.md](./17_Spring_Boot_Profiles.md)*
