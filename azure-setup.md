# Azure App Service Deployment Setup

## Required Azure Resources

Create these App Services in Azure Portal:

1. **Backend API**: `your-ecommerce-backend`
2. **Frontend React**: `your-ecommerce-frontend` 
3. **Auth Service**: `your-ecommerce-auth`
4. **Checkout Service**: `your-ecommerce-checkout`
5. **Payment Service**: `your-ecommerce-payment`

## GitHub Secrets Required

Add these secrets in your GitHub repository settings:

### App Names
- `AZURE_BACKEND_APP_NAME`: your-ecommerce-backend
- `AZURE_FRONTEND_APP_NAME`: your-ecommerce-frontend
- `AZURE_AUTH_APP_NAME`: your-ecommerce-auth
- `AZURE_CHECKOUT_APP_NAME`: your-ecommerce-checkout
- `AZURE_PAYMENT_APP_NAME`: your-ecommerce-payment

### Publish Profiles
Download publish profiles from Azure Portal for each App Service:
- `AZURE_BACKEND_PUBLISH_PROFILE`
- `AZURE_FRONTEND_PUBLISH_PROFILE`
- `AZURE_AUTH_PUBLISH_PROFILE`
- `AZURE_CHECKOUT_PUBLISH_PROFILE`
- `AZURE_PAYMENT_PUBLISH_PROFILE`

### Environment Variables
- `REACT_APP_API_URL`: https://your-ecommerce-backend.azurewebsites.net

## App Service Configuration

### Backend Services (.NET)
- Runtime: .NET 8
- Platform: Linux
- Enable CORS for frontend domain

### Frontend (React)
- Runtime: Node.js 18
- Platform: Linux
- Build command: `npm run build`

## Deployment Triggers

- **Manual**: Use "Run workflow" button in GitHub Actions
- **Automatic**: Push to `deploytoappservce` branch triggers deployment
- **Path-based**: Only deploys when specific service files change

## Service URLs After Deployment

- Frontend: https://your-ecommerce-frontend.azurewebsites.net
- Backend: https://your-ecommerce-backend.azurewebsites.net
- Auth: https://your-ecommerce-auth.azurewebsites.net
- Checkout: https://your-ecommerce-checkout.azurewebsites.net
- Payment: https://your-ecommerce-payment.azurewebsites.net