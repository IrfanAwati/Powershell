################# Azure Blob Storage - PowerShell ####################  
 
## Input Parameters  
$resourceGroupName="azpractice"   
 
## Connect to Azure Account  
Connect-AzAccount   
 
## Function to get all the storage accounts  
Function GetAllStorageAccount  
{  
    Write-Host -ForegroundColor Green "Retrieving the storage accounts..."  
 
    ## Get the list of Storage Accounts  
    $storageAccColl=Get-AzStorageAccount  
    foreach($storageAcc in $storageAccColl)  
    {  
        write-host -ForegroundColor Yellow $storageAcc.StorageAccountName  
    }   
  
    Write-Host -ForegroundColor Green "Retrieving the storage accounts from specific resource group..."  
 
    ## Get the list of Storage Accounts from specific resource group  
    $storageAccCollRG=Get-AzStorageAccount -ResourceGroupName $resourceGroupName  
    foreach($storageAcc in $storageAccCollRG)  
    {  
        write-host -ForegroundColor Yellow $storageAcc.StorageAccountName  
    }  
}  
  
GetAllStorageAccount  
 
## Disconnect from Azure Account  
Disconnect-AzAccount   