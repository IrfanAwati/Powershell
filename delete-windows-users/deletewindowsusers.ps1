$users="sandeep.rawat"
    foreach($user in $users){

        $getuser=Get-LocalUser -Name $user
        if($getuser.Name.Length -gt 0){
        
        Remove-LocalUser -Name $user
        $deletion= "User Found,$($user) deletion is Completed"
        Write-Output $deletion
    }
    else{
    $deletion= "User not found"
        Write-Output $deletion
    }

}