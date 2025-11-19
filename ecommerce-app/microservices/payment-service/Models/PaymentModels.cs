namespace PaymentService.Models;

public class PaymentRequest
{
    public int OrderId { get; set; }
    public decimal Amount { get; set; }
    public string CardNumber { get; set; } = string.Empty;
    public string ExpiryDate { get; set; } = string.Empty;
    public string CVV { get; set; } = string.Empty;
    public string CardHolderName { get; set; } = string.Empty;
}

public class Payment
{
    public int Id { get; set; }
    public int OrderId { get; set; }
    public decimal Amount { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime ProcessedAt { get; set; }
    public string TransactionId { get; set; } = string.Empty;
}

public class PaymentResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Payment? Payment { get; set; }
}