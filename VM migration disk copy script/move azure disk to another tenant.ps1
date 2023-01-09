$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"
$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)
Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force


$sourcediskexporturi = "enter-disk-uri"
$destinationstorageaccoutname = "enter-storageaccount-name"
$destinationstoragekey = "enter-storageaccount-primary-key"
$destinationstoragecontainer = "enter-destination-containername"
$destinationdiskname = "enterdiskname.vhd"


$destinationContext = New-AzureStorageContext -StorageAccountName $destinationstorageaccoutname -StorageAccountKey $destinationstoragekey
Start-AzureStorageBlobCopy -AbsoluteUri $sourcediskexporturi -DestContainer $destinationstoragecontainer -DestContext $destinationContext -DestBlob $destinationdiskname


Get-AzureStorageBlobCopyState -Blob $destinationdiskname -Container $destinationstoragecontainer -Context $destinationContext