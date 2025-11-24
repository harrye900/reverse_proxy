FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5002

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["CheckoutService.csproj", "."]
RUN dotnet restore "CheckoutService.csproj"
COPY . .
RUN dotnet build "CheckoutService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CheckoutService.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CheckoutService.dll"]