$context = Get-AzContext

$storageAccounts = Get-AzResource -ResourceType 'Microsoft.Storage/storageAccounts' 

[System.Collections.ArrayList]$saUsage = New-Object -TypeName System.Collections.ArrayList

 foreach ($storageAccount in $storageAccounts) {

   #list containers
   $conatiners= Get-AzRmStorageContainer -ResourceGroupName $storageAccount.ResourceGroupName -StorageAccountName $storageAccount.Name

     if($conatiners -ne $null){
          foreach($container in $conatiners){
            $StorageAccountDetails = [ordered]@{
                    SubscriptionName = $context.Subscription.Name
                    SubscrpitionID = $context.Subscription.Id
                    StorageAccountName = $storageAccount.Name
                    ContainerName = $container.Name
                    ResourceGroup = $storageAccount.ResourceGroupName
                    Location = $storageAccount.Location
               }
             $saUsage.add((New-Object psobject -Property $StorageAccountDetails))  | Out-Null   
            }     
      }else{
      
        $StorageAccountDetails = [ordered]@{
                SubscriptionName = $context.Subscription.Name
                SubscrpitionID = $context.Subscription.Id
                StorageAccountName = $storageAccount.Name
                ContainerName = $null
                ResourceGroup = $storageAccount.ResourceGroupName
                Location = $storageAccount.Location      
         }
        $saUsage.add((New-Object psobject -Property $StorageAccountDetails)) | Out-Null
     }     
}
$saUsage | Export-Csv -Path e:\test.csv -NoTypeInformation
