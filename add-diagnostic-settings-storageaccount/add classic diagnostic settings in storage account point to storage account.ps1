$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)
Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force


$sublist = Get-AzSubscription
foreach($sub in $sublist){
Select-AzSubscription -Subscription "$($sub.Id)"

Write-Host "Current subscription is" $($sub.Name) -BackgroundColor Green

$storageAccounts = Get-AzStorageAccount



foreach($storageAccount in $storageAccounts){
$storageAccountdetail = Get-AzStorageAccount -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName
$ctx = $storageAccountdetail.Context
Set-AzStorageServiceLoggingProperty -ServiceType Queue -LoggingOperations read,write,delete -RetentionDays 7 -Context $ctx -Verbose
Set-AzStorageServiceLoggingProperty -ServiceType blob -LoggingOperations read,write,delete -RetentionDays 7 -Context $ctx -Verbose



Set-AzStorageServiceMetricsProperty -ServiceType Queue -MetricsType Hour -RetentionDays 7 -Context $ctx -Verbose
Set-AzStorageServiceMetricsProperty -ServiceType Blob -MetricsType Hour -RetentionDays 7 -Context $ctx -Verbose



}



}