# Deploy to Local Kubernetes (Docker Desktop)
param(
    [string]$DockerUsername = "yourusername"
)

Write-Host "Deploying Ecommerce App to Local Kubernetes..." -ForegroundColor Green

# Create namespace
kubectl create namespace ecommerce --dry-run=client -o yaml | kubectl apply -f -

# Deploy using Helm with Docker Hub images
helm upgrade --install ecommerce ./ecommerce-app/helm-chart/ecommerce/ `
    --namespace ecommerce `
    --set global.registry="" `
    --set frontend.image.repository="$DockerUsername/ecommerce-frontend" `
    --set backend.image.repository="$DockerUsername/ecommerce-backend" `
    --set authService.image.repository="$DockerUsername/ecommerce-auth" `
    --set checkoutService.image.repository="$DockerUsername/ecommerce-checkout" `
    --set paymentService.image.repository="$DockerUsername/ecommerce-payment" `
    --set frontend.service.type="LoadBalancer" `
    --set backend.service.type="LoadBalancer" `
    --set ingress.enabled=false

Write-Host "Deployment complete!" -ForegroundColor Green
Write-Host "Check status with: kubectl get all -n ecommerce" -ForegroundColor Yellow
Write-Host "Access frontend at: http://localhost" -ForegroundColor Yellow