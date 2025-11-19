using Microsoft.AspNetCore.Mvc;
using CheckoutService.Models;

namespace CheckoutService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CheckoutController : ControllerBase
{
    [HttpGet("/")]
    public ActionResult<string> HealthCheck()
    {
        return Ok("Checkout Service is running!");
    }

    private static List<Order> _orders = new();
    private static int _nextOrderId = 1;

    [HttpPost]
    public ActionResult<CheckoutResponse> ProcessCheckout([FromBody] CheckoutRequest request)
    {
        var order = new Order
        {
            Id = _nextOrderId++,
            UserId = request.UserId,
            Items = request.Items,
            TotalAmount = request.TotalAmount,
            ShippingAddress = request.ShippingAddress,
            CreatedAt = DateTime.Now,
            Status = "Confirmed"
        };

        _orders.Add(order);

        return Ok(new CheckoutResponse
        {
            Success = true,
            Message = "Order placed successfully",
            Order = order
        });
    }

    [HttpGet("orders/{userId}")]
    public ActionResult<List<Order>> GetUserOrders(int userId)
    {
        var userOrders = _orders.Where(o => o.UserId == userId).ToList();
        return Ok(userOrders);
    }
}