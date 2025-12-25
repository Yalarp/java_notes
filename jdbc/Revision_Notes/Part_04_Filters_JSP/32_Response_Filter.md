# Response Filter

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [Response Postprocessing](#response-postprocessing)
3. [Compression Filter](#compression-filter)
4. [Response Wrapper](#response-wrapper)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**Response Filters** process the response AFTER the servlet executes. Common uses include compression (GZIP), adding headers, and modifying content.

---

## 📖 Response Postprocessing

```java
public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) {
    
    chain.doFilter(req, res);  // Servlet executes
    
    // ════════════════════════════════════════════
    // RESPONSE POSTPROCESSING (after servlet)
    // ════════════════════════════════════════════
    
    HttpServletResponse httpRes = (HttpServletResponse) res;
    httpRes.setHeader("X-Processed-By", "MyFilter");
    
    System.out.println("Response status: " + httpRes.getStatus());
}
```

---

## 📖 Compression Filter

```java
@WebFilter("/*")
public class CompressionFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpReq = (HttpServletRequest) req;
        HttpServletResponse httpRes = (HttpServletResponse) res;
        
        // Check if client accepts gzip
        String encoding = httpReq.getHeader("Accept-Encoding");
        
        if (encoding != null && encoding.contains("gzip")) {
            // Wrap response to compress
            GZIPResponseWrapper wrappedRes = new GZIPResponseWrapper(httpRes);
            chain.doFilter(req, wrappedRes);
            wrappedRes.finish();
        } else {
            chain.doFilter(req, res);
        }
    }
}
```

---

## 📖 Response Wrapper

To modify response content, use `HttpServletResponseWrapper`:

```java
public class GZIPResponseWrapper extends HttpServletResponseWrapper {
    
    private GZIPOutputStream gzipStream;
    private ServletOutputStream outputStream;
    private PrintWriter writer;
    
    public GZIPResponseWrapper(HttpServletResponse response) throws IOException {
        super(response);
        response.addHeader("Content-Encoding", "gzip");
    }
    
    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        if (outputStream == null) {
            gzipStream = new GZIPOutputStream(getResponse().getOutputStream());
            outputStream = new GZIPServletOutputStream(gzipStream);
        }
        return outputStream;
    }
    
    public void finish() throws IOException {
        if (gzipStream != null) {
            gzipStream.finish();
        }
    }
}
```

---

## ✅ Key Takeaways

1. Response filters process **after** servlet executes
2. Code after chain.doFilter() is postprocessing
3. Use `HttpServletResponseWrapper` to modify content
4. Common: compression, adding security headers

---

## 🎤 Interview Questions

**Q1: How can a filter modify the response body?**
> **A:** Use `HttpServletResponseWrapper` to wrap the response and intercept `getOutputStream()` or `getWriter()`.

**Q2: What is GZIP compression filter?**
> **A:** A filter that compresses the response body using GZIP algorithm to reduce bandwidth. It checks if the client supports gzip via Accept-Encoding header.
