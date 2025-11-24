# Build and push all container images to ACR
$ACR_NAME = "acrecommerce1809"

# Login to ACR
az acr login --name $ACR_NAME

# Build and push frontend
docker build -t $ACR_NAME.azurecr.io/ecommerce-frontend:latest ./ecommerce-app/frontend/
docker push $ACR_NAME.azurecr.io/ecommerce-frontend:latest

# Build and push backend
docker build -t $ACR_NAME.azurecr.io/ecommerce-backend:latest ./ecommerce-app/backend/
docker push $ACR_NAME.azurecr.io/ecommerce-backend:latest

# Build and push auth service
docker build -t $ACR_NAME.azurecr.io/ecommerce-auth:latest ./ecommerce-app/microservices/auth-service/
docker push $ACR_NAME.azurecr.io/ecommerce-auth:latest

# Build and push checkout service
docker build -t $ACR_NAME.azurecr.io/ecommerce-checkout:latest ./ecommerce-app/microservices/checkout-service/
docker push $ACR_NAME.azurecr.io/ecommerce-checkout:latest

# Build and push payment service
docker build -t $ACR_NAME.azurecr.io/ecommerce-payment:latest ./ecommerce-app/microservices/payment-service/
docker push $ACR_NAME.azurecr.io/ecommerce-payment:latest

Write-Host "All images built and pushed successfully!"