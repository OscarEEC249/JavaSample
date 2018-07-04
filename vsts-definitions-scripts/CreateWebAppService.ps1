param(
  # Getting the control percentage as an argument
    [Parameter(Mandatory=$true)] $TenantName,
    [Parameter(Mandatory=$true)] $SubscriptionID,
    [Parameter(Mandatory=$true)] $AppID,
    [Parameter(Mandatory=$true)] $AppKey,
    [Parameter(Mandatory=$true)] $ResourceGroup,
)

# Login data
$TenantName = "oscargarciacolonoutlook"
$SubscriptionID = "f76ded42-39e7-4923-97b0-ca78ce7b5d46"
$AppID = "d6314392-8ee3-4a96-a341-1e27e255a9ec"
$AppKey = "23uvEbcqjM22EF6rw7spmgplVJ74OjazOOILQgJFt5o="
 
# Login to azure
$resp = Invoke-RestMethod -Uri "https://login.windows.net/$TenantName.onmicrosoft.com/.well-known/openid-configuration"
$TenantID = $resp.authorization_endpoint.Split("/")[3]
$password = $AppKey | ConvertTo-SecureString -asPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($AppID,$password)
Add-AzureRmAccount -Credential $creds -ServicePrincipal -TenantId $TenantId -SubscriptionID $SubscriptionID 

# Create AppService
az appservice plan create --name DemoJavaServicePlan --resource-group $ResourceGroup --sku FREE

# Create WebApp Service
az webapp create --name demojava --resource-group $ResourceGroup --plan DemoJavaServicePlan

# Set up Java runtime configurations on WebApp Service
az webapp config set --name <app_name> --resource-group myResourceGroup --java-version 1.8 --java-container Tomcat --java-container-version 8.0