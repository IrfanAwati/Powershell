Connect-AzAccount

$subscriptionlist = Get-AzSubscription

$outfile = "C:\temp\access1.csv"

"SubscriptionName,DisplayName,ObjectType,SignInName,AccessType" | Out-File -FilePath $outfile

foreach ($subscriptionlist1 in $subscriptionlist){

$subname = $subscriptionlist1.Name
$subid = $subscriptionlist1.Id

Select-AzSubscription -Subscription $subid

$accesslist = Get-AzRoleAssignment

foreach ($accesslist1 in $accesslist){

$displayname = $accesslist1.DisplayName
$objecttype = $accesslist1.ObjectType
$signinname = $accesslist1.SignInName
$accesstype = $accesslist1.RoleDefinitionName

"$subname,$displayname,$objecttype,$signinname,$accesstype" | Out-File -FilePath $outfile -Append

}

}