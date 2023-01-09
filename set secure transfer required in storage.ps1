Connect-AzAccount

$subscription1 = Get-AzSubscription


foreach ($subscription in $subscription1){

Select-AzSubscription -Subscription $subscription.Id

$storagelist = Get-AzStorageAccount | Where-Object {$_.EnableHttpsTrafficOnly -eq $false}


foreach ($storagelist1 in $storagelist){

$storagename = $storagelist1.StorageAccountName
$storagergname = $storagelist1.ResourceGroupName

Set-AzStorageAccount -Name $storagename -ResourceGroupName $storagergname -EnableHttpsTrafficOnly $true

}
}