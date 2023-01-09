Connect-AzureAD -TenantId "enter-b2c-tenant id-here" -Verbose

$filepath= Import-Excel -path C:\Temp\b2c-userslist.xlsx -Verbose
$count=$filepath.Count
        
    
    Write-Verbose "Sucessfully Imported the entries from $filepath"
    Write-Verbose "Total number of entries  in csv are : $count"

foreach($entries in $filepath){

    $displayname=$entries.DisplayName
    $Firstname=$entries.GivenName
    $lastname=$entries.Surname
    $userpricipalname=$entries.upn
    $password=$entries.password
	
    $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $passwordProfile.Password = $password

    $signInNames = ((New-Object Microsoft.Open.AzureAD.Model.SignInName -Property @{Type = "email"; Value = "$userpricipalname"}))
 
    New-AzureADUser -AccountEnabled $True -DisplayName $displayname -GivenName $Firstname -Surname $lastname -PasswordProfile $passwordProfile -SignInNames $signInNames -CreationType "LocalAccount"
	
    Write-Host " User '$displayname' AAD B2C account is created sucessfully!" -BackgroundColor DarkGreen
    
}


