param(
  # Getting the control percentage as an argument
    [Parameter(Mandatory=$true)] $SubscriptionId,
    [Parameter(Mandatory=$true)] $ADApplicationName,
    [Parameter(Mandatory=$true)] $HomePage,
    [Parameter(Mandatory=$true)] $ResourceGroupName
)

# Azure Login
Connect-AzureRmAccount

# Move to selected Subscription
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

# Create the Azure ActiveDirectory Application
Add-Type -Assembly System.Web
$password = [System.Web.Security.Membership]::GeneratePassword(16,3)
$securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password
$AppInfo = New-AzureRmADApplication -DisplayName "$ADApplicationName" -HomePage $HomePage -IdentifierUris $HomePage -Password $securePassword

# Create the Service Principal
New-AzureRmADServicePrincipal -ApplicationId $AppInfo.ApplicationId

# Assing contributor role to Service Principal
Write-Output "Waiting for Service Principal creation to reflect in Directory before Role assignment"
Start-Sleep 20
New-AzureRmRoleAssignment -RoleDefinitionName "contributor" -ServicePrincipalName $AppInfo.ApplicationId

# Create Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Central US"

# Output message
Write-Host("-------------------- SAVE THIS INFORMATION --------------------") -ForegroundColor Yellow
Write-Host("ServicePrincipalId = " + $AppInfo.ApplicationId) -ForegroundColor Yellow
Write-Host("ServicePrincipalKey = " + $password) -ForegroundColor Yellow