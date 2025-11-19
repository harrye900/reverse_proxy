using EcommerceApi.Models;

namespace EcommerceApi.Services;

public class ProductService
{
    private readonly List<Product> _products = new()
    {
        new Product { Id = 1, Name = "Nike Air Max", Price = 129.99m, Description = "Premium running shoes", ImageUrl = "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop", Stock = 25 },
        new Product { Id = 2, Name = "Designer Handbag", Price = 299.99m, Description = "Luxury leather handbag", ImageUrl = "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop", Stock = 15 },
        new Product { Id = 3, Name = "Gold Chain Necklace", Price = 89.99m, Description = "18k gold plated chain", ImageUrl = "https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=300&h=300&fit=crop", Stock = 30 },
        new Product { Id = 4, Name = "Kids Summer Dress", Price = 39.99m, Description = "Colorful cotton dress", ImageUrl = "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=300&h=300&fit=crop", Stock = 20 },
        new Product { Id = 5, Name = "Men's Casual Shirt", Price = 49.99m, Description = "100% cotton casual shirt", ImageUrl = "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&h=300&fit=crop", Stock = 18 },
        new Product { Id = 6, Name = "Women's Jacket", Price = 79.99m, Description = "Stylish winter jacket", ImageUrl = "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&h=300&fit=crop", Stock = 12 },
        new Product { Id = 7, Name = "Adidas Sneakers", Price = 99.99m, Description = "Comfortable sports shoes", ImageUrl = "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300&h=300&fit=crop", Stock = 22 },
        new Product { Id = 8, Name = "Silver Bracelet", Price = 59.99m, Description = "Elegant silver bracelet", ImageUrl = "https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=300&h=300&fit=crop", Stock = 35 },
        new Product { Id = 9, Name = "Kids Sneakers", Price = 34.99m, Description = "Fun colorful sneakers", ImageUrl = "https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=300&h=300&fit=crop", Stock = 28 }
    };

    public List<Product> GetAllProducts() => _products;
    
    public Product? GetProductById(int id) => _products.FirstOrDefault(p => p.Id == id);
}