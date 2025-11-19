@echo off
echo Stopping Ecommerce Microservices...

taskkill /F /IM dotnet.exe /T
taskkill /F /IM node.exe /T

echo All services stopped!
pause