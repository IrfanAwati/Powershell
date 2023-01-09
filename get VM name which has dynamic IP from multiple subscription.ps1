Connect-AzAccount

$subscriptionlist = Get-AzSubscription

$outpath = "C:\temp\dynamiciplist.csv"

"SubscriptionName,VirtualMachine,ResourceGroupName,NIC Name" | Out-File -FilePath $outpath

foreach ($subscriptionlist1 in $subscriptionlist){

$subname = $subscriptionlist1.Name

Select-AzSubscription -Subscription $subname

$dynamiciplist = Get-AzNetworkInterface | Where-Object {$_.IpConfigurations.PrivateIpAllocationMethod -eq "Dynamic"}

foreach ($dynamiciplist1 in $dynamiciplist){

$nicname = $dynamiciplist1.Name
$resourcegroupname = $dynamiciplist1.ResourceGroupName
$virtualmachineid = (($dynamiciplist1.Id) -split "/virtualMachines/")[-1]
$virtualmachine = (($dynamiciplist1.Virtualmachine.Id) -split "/virtualMachines/")[-1]



"$subname,$virtualmachine,$resourcegroupname,$nicname" | Out-File -FilePath $outpath -Append


}
}