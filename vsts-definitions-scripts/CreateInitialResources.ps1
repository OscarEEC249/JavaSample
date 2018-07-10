param(
  # Getting the control percentage as an argument
    [Parameter(Mandatory=$true)] [string] $SubscriptionId,
    [Parameter(Mandatory=$true)] [string] $ADApplicationName,
    [Parameter(Mandatory=$true)] [string] $HomePageOfADApplication,
    [Parameter(Mandatory=$true)] [string] $ResourceGroupName,
    [Parameter(Mandatory=$true)] [string] $VmName,
    [Parameter(Mandatory=$true)] [string] $VmAdminUser,
    [Parameter(Mandatory=$true)] [string] $VmAdminPassword,
    [Parameter(Mandatory=$true)] [string] $VstsAgentToken,
    [Parameter(Mandatory=$true)] [string] $VstsAgentPool
)

#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = "Stop"

try{
    #################### Azure Login ###################
    
    Connect-AzureRmAccount

    #################### Move to selected Subscription ###################
    
    Select-AzureRmSubscription -SubscriptionId $SubscriptionId

    ################### Create the Azure ActiveDirectory Application ###################
    
    Write-Host("Creating Azure ActiveDirectory Application...") -ForegroundColor Magenta
    Add-Type -Assembly System.Web
    $password = [System.Web.Security.Membership]::GeneratePassword(16,3)
    $securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password
    $AppInfo = New-AzureRmADApplication -DisplayName "$ADApplicationName" -HomePage $HomePageOfADApplication -IdentifierUris $HomePageOfADApplication -Password $securePassword
    Write-Host("")
    Write-Host("Azure ActiveDirectory Application created") -ForegroundColor Green
    Write-Host("")

    #################### Create the Service Principal ###################

    Write-Host("Creating Service Principal...") -ForegroundColor Magenta
    New-AzureRmADServicePrincipal -ApplicationId $AppInfo.ApplicationId

    # Assing CONTRIBUTOR role to Service Principal
    Write-Output "Waiting for Service Principal creation to reflect in Directory before Role assignment..."
    Start-Sleep 30
    New-AzureRmRoleAssignment -RoleDefinitionName "contributor" -ServicePrincipalName $AppInfo.ApplicationId
    Write-Host("Service Principal created") -ForegroundColor Green
    Write-Host("")

    #################### Create Resource Group ###################

    Write-Host("Creating Resource Group...") -ForegroundColor Magenta
    New-AzureRmResourceGroup -Name $ResourceGroupName -Location "Central US"
    Write-Host("Resource Group created") -ForegroundColor Green
    Write-Host("")

    #################### Create Storage Account ###################

    Write-Host("Creating Storage Account...") -ForegroundColor Magenta
    $StorageAccountInfo = New-AzureRMStorageAccount -ResourceGroupName $ResourceGroupName -AccountName "demojavastorage1x" -Location "Central US" -Type "Standard_LRS"
    Write-Host("")
    Write-Host("Storage Account created") -ForegroundColor Green
    Write-Host("")

    #################### Create VM ###################

    # Create a new clean VM
    Write-Host("Creating and Configuring Virtual Machine...") -ForegroundColor Magenta
    $TemplatePath = $PSScriptRoot + "\VM_Template.json"
    $AzureParams = @{
        ResourceGroupName = $ResourceGroupName
        virtualMachineName = $VmName
        adminUsername = $VmAdminUser
        adminPassword = $VmAdminPassword
        diagnosticsStorageAccountName = $StorageAccountInfo.StorageAccountName
        diagnosticsStorageAccountId = $StorageAccountInfo.Id
    }

    New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -ResourceGroupNameFromTemplate $ResourceGroupName -TemplateFile $TemplatePath -TemplateParameterObject $AzureParams
    Start-Sleep 30
    Write-Host("Virtual Machine created")

    # Enable Remote Powershell
    Write-Host("Enabling RemotePS...")
    Invoke-AzureRmVMRunCommand -ResourceGroupName $ResourceGroupName -Name "DemoAgent" -CommandId "EnableRemotePS"
    Write-Host("RemotePS enabled")

    # Enable Admin Account
    #Write-Host("Enabling Admin Account...")
    #Invoke-AzureRmVMRunCommand -ResourceGroupName $ResourceGroupName -Name "DemoAgent" -CommandId "EnableAdminAccount"
    #Write-Host("Admin Account enabled")

    #Install .NetFramework 3.5
    Write-Host("Installing .Net Framework 3.5...")
    $ScriptPath = $PSScriptRoot + "\NetFrameworkInstall.ps1"
    Invoke-AzureRmVMRunCommand -ResourceGroupName $ResourceGroupName -Name "DemoAgent" -CommandId "RunPowerShellScript" -ScriptPath $ScriptPath
    Write-Host("VSTS Agent installed")
    Write-Host(".Net Framework 3.5 installed")

    # Run Agent installation on VM
    Write-Host("Installing VSTS Agent...")
    $ScriptPath = $PSScriptRoot + "\VstsAgentInstall.ps1"
    $AgentParams = @{
        vstsAccount = "itzdatacoka"
        vstsUserPassword = $VstsAgentToken
        agentName = $VmName
        poolName = $VstsAgentPool
        windowsLogonAccount = $VmAdminUser
        windowsLogonPassword = $VmAdminPassword
        driveLetter = "C"
        workDirectory = "_work"
        runMode = "Service"
    }

    Invoke-AzureRmVMRunCommand -ResourceGroupName $ResourceGroupName -Name "DemoAgent" -CommandId "RunPowerShellScript" -ScriptPath $ScriptPath -Parameter $AgentParams
    Write-Host("VSTS Agent installed")

    Write-Host("Virtual Machine created and configured complete") -ForegroundColor Green
    Write-Host("")


    #################### Create WebApp Service ###################

    # Create Service Plan
    az appservice plan create --name DemoJavaServicePlan --resource-group $ResourceGroup --sku FREE

    # Create WebApp Service
    az webapp create --name demojava --resource-group $ResourceGroup --plan DemoJavaServicePlan

    # Set up Java runtime configurations on WebApp Service
    az webapp config set --name demojava --resource-group $ResourceGroup --java-version 1.8 --java-container Tomcat --java-container-version 8.0

    #################### Output message ###################

    Write-Host("")
    Write-Host("-------------------- SAVE THIS INFORMATION --------------------") -ForegroundColor Yellow
    Write-Host("ServicePrincipalId = " + $AppInfo.ApplicationId) -ForegroundColor Yellow
    Write-Host("ServicePrincipalKey = " + $password) -ForegroundColor Yellow
}
finally
{
    popd
}

