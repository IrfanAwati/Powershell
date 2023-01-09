Connect-AzAccount -TenantId 'enter-tenant-id-here'

    $subscriptions=Get-AzSubscription
        foreach($subscription in $subscriptions){

            Select-AzSubscription -Subscription $subscription.Name
            Write-Host "Wroking on Subscription Name $($subscription.Name)" -BackgroundColor Green

$vms=Get-AzVM | Where-Object {$_.StorageProfile.OsDisk.OsType -eq 'Windows'}

$vms.Name

    foreach($vm in $vms){

        $rgname= $vm.ResourceGroupName
        $vmname= $vm.Name

            Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId 'RunPowerShellScript' -ScriptPath 'D:\script\deletewindowsusers.ps1' -Verbose
          

       }
}
 