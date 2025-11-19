@echo off
echo Starting Ecommerce Microservices...

start "Product Service" cmd /k "cd backend && dotnet run"
start "Auth Service" cmd /k "cd microservices\auth-service && dotnet run"
start "Checkout Service" cmd /k "cd microservices\checkout-service && dotnet run"
start "Payment Service" cmd /k "cd microservices\payment-service && dotnet run"

timeout /t 5
start "Frontend" cmd /k "cd frontend && npm start"

echo All services started!
pause