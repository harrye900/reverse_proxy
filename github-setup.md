# GitHub Secrets Setup for AKS Deployment

## Required Steps

1. **Create Service Principal** (if not done already):
   ```bash
   az ad sp create-for-rbac --name "github-actions-ecommerce" --role contributor --scopes /subscriptions/<subscription-id>/resourceGroups/rg-ecommerce-aks --sdk-auth
   ```

2. **Add GitHub Secret**:
   - Go to GitHub repository > Settings > Secrets and variables > Actions
   - Create new secret named: `AZURE_CREDENTIALS`
   - Use the JSON output from the service principal creation command

3. **Deploy**:
   - Push code to main branch to trigger CI/CD pipeline
   - Monitor deployment in Actions tab

## What the Pipeline Does
- Builds 5 container images (frontend, backend, 3 microservices)
- Pushes to Azure Container Registry
- Deploys to AKS using Helm charts
- Creates ecommerce namespace and services