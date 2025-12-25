# MVC Architecture

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [MVC Components](#mvc-components)
3. [Flow in Web Applications](#flow-in-web-applications)
4. [Implementation](#implementation)
5. [Key Takeaways](#key-takeaways)
6. [Interview Questions](#interview-questions)

---

## 🎯 Introduction

**MVC (Model-View-Controller)** is an architectural pattern that separates an application into three components.

---

## 📖 MVC Components

| Component | Contains | Example |
|-----------|----------|---------|
| **Model** | Business logic, data | JavaBeans, DAOs |
| **View** | Presentation | JSP, HTML |
| **Controller** | Navigation logic | Servlets |

---

## 📖 Flow in Web Applications

```
1. Client sends request to Controller (Servlet)
        ↓
2. Controller calls Model for data
        ↓
3. Model returns data to Controller
        ↓
4. Controller stores data in request scope
        ↓
5. Controller forwards to View (JSP)
        ↓
6. View renders and sends response
```

---

## 📖 Implementation

### Controller (Servlet)
```java
@WebServlet("/products")
public class ProductController extends HttpServlet {
    private ProductService service = new ProductService();
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res) {
        List<Product> products = service.getAllProducts();
        req.setAttribute("products", products);
        req.getRequestDispatcher("/products.jsp").forward(req, res);
    }
}
```

### Model (Service)
```java
public class ProductService {
    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }
}
```

### View (JSP)
```jsp
<c:forEach var="product" items="${products}">
    <p>${product.name} - ${product.price}</p>
</c:forEach>
```

---

## ✅ Key Takeaways

1. **Model**: Business logic, database
2. **View**: Presentation only
3. **Controller**: Request handling, navigation
4. Controller **forwards** to view
5. Model and View **don't know about each other**

---

## 🎤 Interview Questions

**Q1: What is MVC architecture?**
> **A:** Separates app into Model (logic), View (presentation), Controller (navigation) for better maintainability.

**Q2: Why should business logic not be in JSP?**
> **A:** Violates separation of concerns, makes testing difficult, prevents reuse.
