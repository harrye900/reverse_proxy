using Microsoft.AspNetCore.Mvc;
using PaymentService.Models;

namespace PaymentService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PaymentController : ControllerBase
{
    [HttpGet("/")]
    public ActionResult<string> HealthCheck()
    {
        return Ok("Payment Service is running!");
    }

    private static List<Payment> _payments = new();
    private static int _nextPaymentId = 1;

    [HttpPost("process")]
    public ActionResult<PaymentResponse> ProcessPayment([FromBody] PaymentRequest request)
    {
        // Simulate payment processing
        var isSuccess = !string.IsNullOrEmpty(request.CardNumber) && request.Amount > 0;

        var payment = new Payment
        {
            Id = _nextPaymentId++,
            OrderId = request.OrderId,
            Amount = request.Amount,
            Status = isSuccess ? "Completed" : "Failed",
            ProcessedAt = DateTime.Now,
            TransactionId = Guid.NewGuid().ToString("N")[..8].ToUpper()
        };

        _payments.Add(payment);

        return Ok(new PaymentResponse
        {
            Success = isSuccess,
            Message = isSuccess ? "Payment processed successfully" : "Payment failed",
            Payment = payment
        });
    }

    [HttpGet("{orderId}")]
    public ActionResult<Payment> GetPaymentByOrderId(int orderId)
    {
        var payment = _payments.FirstOrDefault(p => p.OrderId == orderId);
        if (payment == null)
            return NotFound();

        return Ok(payment);
    }
}