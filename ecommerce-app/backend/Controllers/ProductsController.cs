using Microsoft.AspNetCore.Mvc;
using EcommerceApi.Models;
using EcommerceApi.Services;

namespace EcommerceApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly ProductService _productService;

    public ProductsController(ProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public ActionResult<List<Product>> GetProducts()
    {
        return Ok(_productService.GetAllProducts());
    }

    [HttpGet("{id}")]
    public ActionResult<Product> GetProduct(int id)
    {
        var product = _productService.GetProductById(id);
        if (product == null)
            return NotFound();
        
        return Ok(product);
    }
}