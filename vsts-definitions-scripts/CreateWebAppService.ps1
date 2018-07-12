param(
  # Getting the control percentage as an argument
    [Parameter(Mandatory=$true)] $TenantID,
    [Parameter(Mandatory=$true)] $ServicePrincipalId,
    [Parameter(Mandatory=$true)] $ServicePrincipalKey,
    [Parameter(Mandatory=$true)] $ResourceGroup
)

# Login to azure
$securePass = $ServicePrincipalKey | ConvertTo-SecureString -asPlainText -Force
$AzPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass));
az login --service-principal -u $ServicePrincipalId -p $AzPass --tenant $TenantID;

Write-Host("Creating WebApp Service...") -ForegroundColor Magenta

# Create Service Plan
Write-Host("Creating Service Plan...")
az appservice plan create --name demojava-ServicePlan --resource-group $ResourceGroup --sku FREE

# Create WebApp Service
Write-Host("Creating WebApp Service...")
az webapp create --name demojava --resource-group $ResourceGroup --plan demojava-ServicePlan

Write-Host("Adding Java configuration to WebApp Service...")
# Set up Java runtime configurations on WebApp Service
az webapp config set --name demojava --resource-group $ResourceGroup --java-version 1.8 --java-container Tomcat --java-container-version 8.0
Write-Host("Web App Service created and configured") -ForegroundColor Green