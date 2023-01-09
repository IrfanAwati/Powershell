#Install-Module -Name AzureAD
#Install-Module -Name ImportExcel


Connect-AzAccount -Tenant "enter-tenant-id-here"

Remove-Item -Path C:\temp\AppEXpirydetails.xlsx -Force -Verbose
$tenantId='enter-tenant-id-here'
$currentUTCtime = (Get-Date).ToUniversalTime()

Write-Host 'Gathering necessary information...'
$applications = Get-AzADApplication
$totalapps=$applications.Count
$servicePrincipals = Get-AzADServicePrincipal


$appWithCredentials = @()
$appWithCredentials += $applications | Sort-Object -Property DisplayName | % {
    $application = $_
    $sp = $servicePrincipals | ? ApplicationId -eq $application.ApplicationId
    Write-Host ('Fetching information for application {0}' -f $application.DisplayName)
    $application | Get-AzADAppCredential -ErrorAction SilentlyContinue | Select-Object -Property @{Name='DisplayName'; Expression={$application.DisplayName}},@{Name='AvailableToOtherTenants'; Expression={$application.AvailableToOtherTenants}}, @{Name='ApplicationId'; Expression={$application.ApplicationId}}, @{Name='KeyId'; Expression={$_.KeyId}}, @{Name='Type'; Expression={$_.Type}},@{Name='StartDate'; Expression={$_.StartDate -as [datetime]}},@{Name='EndDate'; Expression={$_.EndDate -as [datetime]}},@{Name='HomePage'; Expression={$application.HomePage}}

  }

  $appWithCredentials.Count
    Write-Host 'Validating expiration data...'
    $today = (Get-Date).ToUniversalTime()
    $limitDate = $today.AddDays($ExpiresInDays)

    $appexpired=(($appWithCredentials | Where-Object{$_.EndDate -lt $today})| Measure-Object).Count
    $appexpringsoon=(($appWithCredentials | Where-Object {$_.EndDate-le $limitDate -and $_.EndDate -gt $today})| Measure-Object).Count
    $appvalid=(($appWithCredentials | Where-Object{$_.EndDate -gt $limitDate -and $_.EndDate -gt $today})| Measure-Object).Count

    foreach($appWithCredential in $appWithCredentials){
        if($appWithCredential.EndDate -lt $today) {

            $obj = New-Object -TypeName PsObject
            $obj | Add-Member -MemberType NoteProperty -Name 'DisplayName' -Value $appWithCredential.DisplayName
            $obj | Add-Member -MemberType NoteProperty -Name 'ApplicationId' -Value $appWithCredential.ApplicationId.Guid
            $obj | Add-Member -MemberType NoteProperty -Name 'AvailableToOtherTenants' -Value $appWithCredential.AvailableToOtherTenants
            $obj | Add-Member -MemberType NoteProperty -Name 'HomePage' -Value $appWithCredential.HomePage
            $obj | Add-Member -MemberType NoteProperty -Name 'KeyId' -Value $appWithCredential.KeyId
            $obj | Add-Member -MemberType NoteProperty -Name 'Type' -Value $appWithCredential.Type
            $obj | Add-Member -MemberType NoteProperty -Name 'StartDate' -Value ($appWithCredential.StartDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'EndDate' -Value ($appWithCredential.EndDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Expired'
            $obj| Export-Excel -Path C:\temp\AppEXpirydetails.xlsx -WorksheetName 'Expired' -Append -Verbose

        } elseif ($appWithCredential.EndDate -le $limitDate -and $appWithCredential.EndDate -gt $today) {
            $obj = New-Object -TypeName PsObject
            $obj | Add-Member -MemberType NoteProperty -Name 'DisplayName' -Value $appWithCredential.DisplayName
            $obj | Add-Member -MemberType NoteProperty -Name 'ApplicationId' -Value $appWithCredential.ApplicationId.Guid
            $obj | Add-Member -MemberType NoteProperty -Name 'AvailableToOtherTenants' -Value $appWithCredential.AvailableToOtherTenants
            $obj | Add-Member -MemberType NoteProperty -Name 'HomePage' -Value $appWithCredential.HomePage
            $obj | Add-Member -MemberType NoteProperty -Name 'KeyId' -Value $appWithCredential.KeyId
            $obj | Add-Member -MemberType NoteProperty -Name 'Type' -Value $appWithCredential.Type
            $obj | Add-Member -MemberType NoteProperty -Name 'StartDate' -Value ($appWithCredential.StartDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'EndDate' -Value ($appWithCredential.EndDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'ExpiringSoon'
            $obj | Export-Excel -Path C:\temp\AppEXpirydetails.xlsx -WorksheetName 'ExpiringSoon' -Append -Verbose
        } 
        elseif ($appWithCredential.EndDate -gt $limitDate -and $appWithCredential.EndDate -gt $today){
            $obj = New-Object -TypeName PsObject
            $obj | Add-Member -MemberType NoteProperty -Name 'DisplayName' -Value $appWithCredential.DisplayName
            $obj | Add-Member -MemberType NoteProperty -Name 'ApplicationId' -Value $appWithCredential.ApplicationId.Guid
            $obj | Add-Member -MemberType NoteProperty -Name 'AvailableToOtherTenants' -Value $appWithCredential.AvailableToOtherTenants
            $obj | Add-Member -MemberType NoteProperty -Name 'HomePage' -Value $appWithCredential.HomePage
            $obj | Add-Member -MemberType NoteProperty -Name 'KeyId' -Value $appWithCredential.KeyId
            $obj | Add-Member -MemberType NoteProperty -Name 'Type' -Value $appWithCredential.Type
            $obj | Add-Member -MemberType NoteProperty -Name 'StartDate' -Value ($appWithCredential.StartDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'EndDate' -Value ($appWithCredential.EndDate).DateTime
            $obj | Add-Member -MemberType NoteProperty -Name 'Status' -Value 'Valid'
            $obj | Export-Excel -Path C:\temp\AppEXpirydetails.xlsx -WorksheetName 'Valid' -Append -Verbose
        }
}

<#
$SMTPServer = "smtp.office365.com"
$sendgridusername = "enter-smtp-mail id"
$SecurePassword = ConvertTo-SecureString 'enter-smtp-mail-password' –asplaintext –force 
$cred = New-Object System.Management.Automation.PsCredential($sendgridusername, $SecurePassword)

$EmailFrom = "enter-smtp-mail id"
$EmailTo = "enter receipent mail"
$CC = "enter receipent mail 1", "enter receipent mail 2"
$attachment = "C:\temp\AppEXpirydetails.xlsx"
$Subject = "Notification | Application Registration | MYTENANTNAME Tenant | $currentUTCtime"
$body=@"
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style="font-size:24px;color:#002060;">Application Registration on SAMALSONS Tenant</span></strong></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;background:white;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;'>&nbsp;</span></p>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse;">
   <tbody>
      <tr>
         <td style="border: 1pt solid windowtext;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Tenant ID</span></strong></p>
         </td>
         <td style="border-top: 1pt solid windowtext;border-right: 1pt solid windowtext;border-bottom: 1pt solid windowtext;border-image: initial;border-left: none;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>$tenantId</span></p>
         </td>
      </tr>
      <tr>
         <td style="border-right: 1pt solid windowtext;border-bottom: 1pt solid windowtext;border-left: 1pt solid windowtext;border-image: initial;border-top: none;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Total Apps Registered</span></strong></p>
         </td>
         <td style="border-top: none;border-left: none;border-bottom: 1pt solid windowtext;border-right: 1pt solid windowtext;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>$totalapps</span></p>
         </td>
      </tr>
      <tr>
         <td style="border-right: 1pt solid windowtext;border-bottom: 1pt solid windowtext;border-left: 1pt solid windowtext;border-image: initial;border-top: none;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Valid</span></strong></p>
         </td>
         <td style="border-top: none;border-left: none;border-bottom: 1pt solid windowtext;border-right: 1pt solid windowtext;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>$appvalid</span></p>
         </td>
      </tr>
      <tr>
         <td style="border-right: 1pt solid windowtext;border-bottom: 1pt solid windowtext;border-left: 1pt solid windowtext;border-image: initial;border-top: none;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Expring Soon</span></strong></p>
         </td>
         <td style="border-top: none;border-left: none;border-bottom: 1pt solid windowtext;border-right: 1pt solid windowtext;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#FF0000;'>$appexpringsoon</span></p>
         </td>
      </tr>
      <tr>
         <td style="border-right: 1pt solid windowtext;border-bottom: 1pt solid windowtext;border-left: 1pt solid windowtext;border-image: initial;border-top: none;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Expired</span></strong></p>
         </td>
         <td style="border-top: none;border-left: none;border-bottom: 1pt solid windowtext;border-right: 1pt solid windowtext;padding: 0in 5.4pt;height: 15pt;vertical-align: bottom;" valign="bottom">
            <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#8B0000;'>$appexpired</span><span style="font-size:13px;color:#002060;"></span></p>
         </td>
      </tr>
      
   </tbody>
</table>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;background:white;'>&nbsp;</p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;background:white;'>&nbsp;</p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;background:white;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>Kindly find the attached sheet with contains the list of SPN's which is Valid, Already Expired and which is going to Expire within 30 days. Request you kindly take appropriate action and renew the secret before its going to expire.</span></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;background:white;'><span style="font-size:15px;">&nbsp;</span></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>Enclosing with Application registration details as attachment.</span></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style="font-size:15px;">&nbsp;</span></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Thanks &amp; Regards</span><strong><span style='font-size:15px;font-family:"Century Gothic",sans-serif;color:#002060;'>,</span></strong></p>
<p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style="font-size:15px;">&nbsp;</span></p>

"@



Send-MailMessage -From $EmailFrom -To $EmailTo -Cc $CC -Subject $Subject -Body $body  -Priority High -SmtpServer $SMTPServer -Credential $cred -UseSsl -Port 587 -Attachments $attachment -BodyAsHtml
    Write-Host "Completed Sucessfully"

#>