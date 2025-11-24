# Deploy ecommerce application to AKS using Helm
$CLUSTER_NAME = "aks-ecommerce-cluster"
$RESOURCE_GROUP = "rg-ecommerce-aks"

# Get AKS credentials (use Azure Cloud Shell if port 16443 is blocked)
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Install NGINX Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# Deploy the ecommerce application
helm upgrade --install ecommerce ./ecommerce-app/helm-chart/ecommerce/ --namespace ecommerce --create-namespace

# Get deployment status
kubectl get pods -n ecommerce
kubectl get services -n ecommerce
kubectl get ingress -n ecommerce

Write-Host "Deployment completed! Check the status above."