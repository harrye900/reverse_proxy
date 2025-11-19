# Ecommerce Microservice Application

A minimal ecommerce application with React frontend and .NET backend.

## Features
- Product catalog display
- Shopping cart functionality
- RESTful API for products
- CORS-enabled backend

## Setup Instructions

### Backend (.NET)
1. Navigate to backend directory:
   ```
   cd backend
   ```

2. Restore packages and run:
   ```
   dotnet restore
   dotnet run
   ```
   Backend will run on http://localhost:5000

### Frontend (React)
1. Navigate to frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies and start:
   ```
   npm install
   npm start
   ```
   Frontend will run on http://localhost:3000

## API Endpoints
- GET /api/products - Get all products
- GET /api/products/{id} - Get product by ID

## Architecture
- **Frontend**: React with Axios for API calls
- **Backend**: .NET 8 Web API with in-memory data
- **Communication**: HTTP REST API with CORS enabled