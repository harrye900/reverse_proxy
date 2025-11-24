FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["EcommerceApi.csproj", "."]
RUN dotnet restore "EcommerceApi.csproj"
COPY . .
RUN dotnet build "EcommerceApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EcommerceApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EcommerceApi.dll"]