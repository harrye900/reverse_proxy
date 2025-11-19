using Microsoft.AspNetCore.Mvc;
using AuthService.Models;

namespace AuthService.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private static List<User> _users = new()
    {
        new User { Id = 1, Username = "admin", Email = "admin@example.com", Password = "admin123" },
        new User { Id = 2, Username = "user", Email = "user@example.com", Password = "user123" }
    };

    [HttpPost("login")]
    public ActionResult<AuthResponse> Login([FromBody] LoginRequest request)
    {
        var user = _users.FirstOrDefault(u => u.Username == request.Username && u.Password == request.Password);
        
        if (user != null)
        {
            return Ok(new AuthResponse 
            { 
                Success = true, 
                Message = "Login successful", 
                User = new User { Id = user.Id, Username = user.Username, Email = user.Email }
            });
        }

        return Ok(new AuthResponse { Success = false, Message = "Invalid credentials" });
    }

    [HttpPost("register")]
    public ActionResult<AuthResponse> Register([FromBody] RegisterRequest request)
    {
        if (_users.Any(u => u.Username == request.Username))
        {
            return Ok(new AuthResponse { Success = false, Message = "Username already exists" });
        }

        var newUser = new User
        {
            Id = _users.Count + 1,
            Username = request.Username,
            Email = request.Email,
            Password = request.Password
        };

        _users.Add(newUser);

        return Ok(new AuthResponse 
        { 
            Success = true, 
            Message = "Registration successful", 
            User = new User { Id = newUser.Id, Username = newUser.Username, Email = newUser.Email }
        });
    }
}