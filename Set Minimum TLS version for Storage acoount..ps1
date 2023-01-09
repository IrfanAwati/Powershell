#Connect-AzAccount
#Get-AzSubscription 
#Select-AzSubscription -Subscription "My Subscription"

$resourceGroupName = "samplicity-platform-sit-rg"
$stoAccountName = "stoaccountps"
(Get-AzStorageAccount -Name -ResourceGroupName).MinimumTlsVersion

Set-AzStorageAccount -AccountName $stoAccountName `
                     -ResourceGroupName $resourceGroupName `
                     -MinimumTlsVersion TLS1_2