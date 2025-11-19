# Deploy Azure Infrastructure using ARM Template
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string]$AppNamePrefix,
    
    [string]$Location = "canadacentral"
)

Write-Host "Deploying Azure Infrastructure..." -ForegroundColor Green

# Login check
$context = az account show 2>$null
if (!$context) {
    Write-Host "Please login to Azure..." -ForegroundColor Yellow
    az login
}

# Create Resource Group
Write-Host "Creating Resource Group: $ResourceGroupName" -ForegroundColor Yellow
az group create --name $ResourceGroupName --location $Location

# Deploy ARM Template
Write-Host "Deploying ARM Template..." -ForegroundColor Yellow
$result = az deployment group create `
    --resource-group $ResourceGroupName `
    --template-file "azure-complete-infrastructure.json" `
    --parameters appNamePrefix=$AppNamePrefix

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deployment completed successfully!" -ForegroundColor Green
    
    Write-Host "`nApp Services Created:" -ForegroundColor Cyan
    Write-Host "  https://$AppNamePrefix-frontend.azurewebsites.net" -ForegroundColor White
    Write-Host "  https://$AppNamePrefix-backend.azurewebsites.net" -ForegroundColor White
    Write-Host "  https://$AppNamePrefix-microservices.azurewebsites.net" -ForegroundColor White
    
    Write-Host "`nNext Steps:" -ForegroundColor Yellow
    Write-Host "1. Download publish profiles from Azure Portal" -ForegroundColor White
    Write-Host "2. Add GitHub secrets for publish profiles" -ForegroundColor White
    Write-Host "3. Push code to trigger CI/CD deployment" -ForegroundColor White
} else {
    Write-Host "Deployment failed!" -ForegroundColor Red
}