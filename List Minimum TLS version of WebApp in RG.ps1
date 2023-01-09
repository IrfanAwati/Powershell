Connect-AzAccount
Get-AzSubscription 
Select-AzSubscription -Subscription "11f812dd-4376-4d60-9015-34abb521f5f2"


$grouname = "samplicity-demo-rg"
$apps = Get-AzWebApp -ResourceGroupName $grouname
$names = $apps.Name
foreach($name in $names){
    $tls = (Get-AzWebApp -ResourceGroupName $grouname -Name $name).SiteConfig.MinTlsVersion
    Write-Host "minTlsVersion of web app" $name "is" $tls
}