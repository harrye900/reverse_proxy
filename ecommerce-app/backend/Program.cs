using EcommerceApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddSingleton<ProductService>();
builder.Services.AddSingleton<AuthService>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp",
        policy =>
        {
            policy.WithOrigins("http://localhost:3000")
                  .AllowAnyHeader()
                  .AllowAnyMethod();
        });
});

var app = builder.Build();

app.UseCors("AllowReactApp");
app.UseRouting();
app.MapControllers();

// Health check endpoint for Application Gateway
app.MapGet("/", () => "Backend API is healthy");
app.MapGet("/health", () => "OK");

app.Run("http://0.0.0.0:5000");