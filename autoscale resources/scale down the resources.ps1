$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)

Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force
Write-Host "Connected to the Azure Portal on" $TenantID -BackgroundColor DarkGreen

#Change the Subscription ID
Select-AzSubscription -Subscription "enter-subscription-id-here"

#Change the Resource Group Name
$perfresourcelist = Get-AzResource -ResourceGroupName "enter-resourcegroupname"

foreach ($perfresourcelist1 in $perfresourcelist){

    if ($perfresourcelist1.ResourceType -eq "Microsoft.Web/sites"){

    $aspname = ((((Get-AzWebApp -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $perfresourcelist1.Name).ServerFarmId) -split"/")[-1])
    $asptiername = (Get-AzAppServicePlan -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $aspname).Sku.Tier

        if ($asptiername -match "PremiumV2"){

        Set-AzAppServicePlan -Tier Standard -Name $aspname -ResourceGroupName $perfresourcelist1.ResourceGroupName -Verbose
        $newasptier = (Get-AzAppServicePlan -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $aspname).Sku.Tier
        Write-Host "App Service Plan" $aspname "is Downgraded to" $newasptier -BackgroundColor DarkGreen

        

        }


    }
    
    if ($perfresourcelist1.ResourceType -eq "microsoft.containerregistry/registries"){

    $conregistryname = Get-AzContainerRegistry -ResourceGroupName $perfresourcelist1.ResourceGroupName
    $conregistrysku = $conregistryname.SkuTier

        if ($conregistrysku -match "Premium"){
        
        Update-AzContainerRegistry -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $perfresourcelist1.Name -Sku Standard -Verbose
        $newconregistrysku = (Get-AzContainerRegistry -ResourceGroupName $perfresourcelist1.ResourceGroupName).Name
        Write-Host "Container Registry" $conregistryname "is Downgraded to" $newconregistrysku -BackgroundColor DarkGreen
        
        }



    }

    if ($perfresourcelist1.ResourceType -eq "Microsoft.Sql/servers"){
    
    
    $sqlserver = (Get-AzSqlServer -ResourceGroupName $perfresourcelist1.ResourceGroupName).ServerName
    $databasename = (Get-AzSqlDatabase -ResourceGroupName $perfresourcelist1.ResourceGroupName -ServerName $sqlserver)
    
            foreach ($databasename1 in $databasename.DatabaseName){
        
            $databasename2 = Get-AzSqlDatabase -ResourceGroupName $perfresourcelist1.ResourceGroupName -ServerName $sqlserver -DatabaseName $databasename1


                if ($databasename1 -eq "master"){
                Write-Host "no action required for master database"
                }
                Else {
            
                if ($databasename2.SkuName -match "Standard"){
                Set-AzSqlDatabase -DatabaseName $databasename2.DatabaseName -ServerName $sqlserver -ResourceGroupName $perfresourcelist1.ResourceGroupName -Edition Basic -Verbose
                $newdbtier = (Get-AzSqlDatabase -DatabaseName $databasename2.DatabaseName -ServerName $sqlserver -ResourceGroupName $perfresourcelist1.ResourceGroupName).SkuName
                Write-Host "SQL Database" $databasename2.DatabaseName "is Downgraded to" $newdbtier -BackgroundColor DarkGreen

                }
                else {
        
                Write-Host "SQL Databse is already in" $newdbtier "Tier"
        
                }

                }
    
    }
    
    
    
    }

    if ($perfresourcelist1.ResourceType -eq "microsoft.web/sites/slots"){
    
        $webappslotname = $perfresourcelist1.Name 
        $slotname = ($webappslotname.split([string[]]' (', [StringSplitOptions]::None) -split "/")[0]
        $slotappname = ($webappslotname.split([string[]]' (', [StringSplitOptions]::None) -split "/")[1]

        $aspname = ((((Get-AzWebAppSlot -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $slotname -Slot $slotappname).ServerFarmId) -split "/")[-1])
        $asptiername = (Get-AzAppServicePlan -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $aspname).Sku.Tier

            if ($asptiername -match "PremiumV2"){
            
             Set-AzAppServicePlan -Tier Standard -Name $aspname -ResourceGroupName $perfresourcelist1.ResourceGroupName -Verbose
             $newasptier = (Get-AzAppServicePlan -ResourceGroupName $perfresourcelist1.ResourceGroupName -Name $aspname).Sku.Tier
             Write-Host "App Service Plan" $aspname "is Downgraded to" $newasptier -BackgroundColor DarkGreen
            
            }

   
    
    
    }

}