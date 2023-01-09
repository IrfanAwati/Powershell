$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)
Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force


$subscriptionname = Get-AzSubscription

foreach ($subscriptionname1 in $subscriptionname){

Select-AzSubscription -Subscription $subscriptionname1.Id

$getstorage = Get-AzStorageAccount


foreach ($getstorage1 in $getstorage){

if ($getstorage1.PrimaryLocation -eq "westeurope"){

$ResourceId = $getstorage1.Id
$storageId = "/subscriptions/enter-susbcription-id-here/resourcegroups/enter-resourcegroup-here/providers/Microsoft.Storage/storageAccounts/enter-storageaccount-here"
$DiagnosticSettingName = "setbyscript"

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category "Transaction" -Enabled
$setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $ResourceId -StorageAccountId $storageId -Setting $metric
Set-AzDiagnosticSetting -InputObject $setting

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category Transaction -Enabled
$readlog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageRead -Enabled
$writelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageWrite -Enabled
$deletelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageDelete -Enabled
$Ids = @($ResourceId + "/blobServices/default"
        $ResourceId + "/queueServices/default"
        
)
$Ids | ForEach-Object {
    $setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $_ -StorageAccountId $storageId -Setting $metric,$readlog,$writelog,$deletelog
    Set-AzDiagnosticSetting -InputObject $setting
}


}


if ($getstorage1.PrimaryLocation -eq "eastus"){

$ResourceId = $getstorage1.Id
$storageId = "/subscriptions/enter-susbcription-id-here/resourcegroups/enter-resourcegroup-here/providers/Microsoft.Storage/storageAccounts/enter-storageaccount-here"
$DiagnosticSettingName = "setbyscript"

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category "Transaction" -Enabled
$setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $ResourceId -StorageAccountId $storageId -Setting $metric
Set-AzDiagnosticSetting -InputObject $setting

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category Transaction -Enabled
$readlog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageRead -Enabled
$writelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageWrite -Enabled
$deletelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageDelete -Enabled
$Ids = @($ResourceId + "/blobServices/default"
        $ResourceId + "/queueServices/default"
        
)
$Ids | ForEach-Object {
    $setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $_ -StorageAccountId $storageId -Setting $metric,$readlog,$writelog,$deletelog
    Set-AzDiagnosticSetting -InputObject $setting
}


}


if ($getstorage1.PrimaryLocation -eq "eastasia"){

$ResourceId = $getstorage1.Id
$storageId = "/subscriptions/enter-susbcription-id-here/resourcegroups/enter-resourcegroup-here/providers/Microsoft.Storage/storageAccounts/enter-storageaccount-here"
$DiagnosticSettingName = "setbyscript"

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category "Transaction" -Enabled
$setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $ResourceId -StorageAccountId $storageId -Setting $metric
Set-AzDiagnosticSetting -InputObject $setting

$metric = New-AzDiagnosticDetailSetting -Metric -RetentionEnabled -Category Transaction -Enabled
$readlog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageRead -Enabled
$writelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageWrite -Enabled
$deletelog = New-AzDiagnosticDetailSetting -Log -RetentionEnabled -Category StorageDelete -Enabled
$Ids = @($ResourceId + "/blobServices/default"
        $ResourceId + "/queueServices/default"
        
)
$Ids | ForEach-Object {
    $setting = New-AzDiagnosticSetting -Name $DiagnosticSettingName -ResourceId $_ -StorageAccountId $storageId -Setting $metric,$readlog,$writelog,$deletelog
    Set-AzDiagnosticSetting -InputObject $setting
}


}



}

}