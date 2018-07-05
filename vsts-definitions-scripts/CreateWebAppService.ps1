param(
  # Getting the control percentage as an argument
    [Parameter(Mandatory=$true)] $TenantID,
    [Parameter(Mandatory=$true)] $SubscriptionID,
    [Parameter(Mandatory=$true)] $AppID,
    [Parameter(Mandatory=$true)] $AppKey,
    [Parameter(Mandatory=$true)] $ResourceGroup
)

# Login to azure
$securePass = $AppKey | ConvertTo-SecureString -asPlainText -Force
$AzPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePass));
az login --service-principal -u $AppID -p $AzPass --tenant $TenantID;

# Create Service Plan
az appservice plan create --name DemoJavaServicePlan --resource-group $ResourceGroup --sku FREE

# Create WebApp Service
az webapp create --name demojava --resource-group $ResourceGroup --plan DemoJavaServicePlan

# Set up Java runtime configurations on WebApp Service
az webapp config set --name demojava --resource-group $ResourceGroup --java-version 1.8 --java-container Tomcat --java-container-version 8.0
