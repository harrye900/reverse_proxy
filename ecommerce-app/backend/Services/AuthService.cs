using EcommerceApi.Models;

namespace EcommerceApi.Services;

public class AuthService
{
    private readonly List<User> _users = new()
    {
        new User { Id = 1, Username = "admin", Email = "admin@example.com", Password = "admin123" },
        new User { Id = 2, Username = "user", Email = "user@example.com", Password = "user123" }
    };

    public LoginResponse Login(LoginRequest request)
    {
        var user = _users.FirstOrDefault(u => u.Username == request.Username && u.Password == request.Password);
        
        if (user != null)
        {
            return new LoginResponse 
            { 
                Success = true, 
                Message = "Login successful", 
                User = new User { Id = user.Id, Username = user.Username, Email = user.Email }
            };
        }

        return new LoginResponse { Success = false, Message = "Invalid credentials" };
    }
}