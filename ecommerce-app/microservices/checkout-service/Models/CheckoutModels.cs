namespace CheckoutService.Models;

public class CheckoutRequest
{
    public int UserId { get; set; }
    public List<CartItem> Items { get; set; } = new();
    public decimal TotalAmount { get; set; }
    public string ShippingAddress { get; set; } = string.Empty;
}

public class CartItem
{
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Quantity { get; set; }
}

public class Order
{
    public int Id { get; set; }
    public int UserId { get; set; }
    public List<CartItem> Items { get; set; } = new();
    public decimal TotalAmount { get; set; }
    public string ShippingAddress { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public string Status { get; set; } = "Pending";
}

public class CheckoutResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Order? Order { get; set; }
}