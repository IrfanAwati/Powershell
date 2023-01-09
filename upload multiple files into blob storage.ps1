$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)
Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force

Select-AzSubscription -Subscription "enter-subscription-id-here"

$azcopypath = "C:\azcopy_windows_amd64_10.12.2\"

Set-Location -Path $azcopypath

$context = (Get-AzStorageAccount -ResourceGroupName 'enter-resource-group' -AccountName 'enter-storage-account-name').context

$newstorageblobSAStoken = New-AzStorageAccountSASToken -Context $context -Service Blob -Permission "racwdlup" -ResourceType Service,Container,Object

$storagecontainer = "enter-azure-blobname"
$sourcepath = "enter-source-path"
$destinationpath = "https://enter-storage-accout-name.blob.core.windows.net/$storagecontainer$newstorageblobSAStoken"


.\azcopy.exe sync "$sourcepath" "$destinationpath" --delete-destination=true