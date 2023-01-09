$TenantID = "enter-tenant-id"
$ApplicationID = "enter-application-id"
$ApplicationSecret = "enter-application-id-secret"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)
                
Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force
            


[int]$month = (Get-Date -Format MM)-1
$year = (Get-Date -Format yyyy)
$startdate = "$year-$month-01"
#$enddate = Get-Date -Format yyyy-MM-dd
$enddate = "$year-$month-31"

Remove-Item -Path "C:\temp\AzureCost-ResourceGroup-Wise.csv" -ErrorAction SilentlyContinue -Force -Verbose

$outpath = "C:\temp\AzureCost-ResourceGroup-Wise.csv"

$monthname = switch($month){
   01 {"Jan"}
   02 {"Feb"}
   03 {"Mar"}
   04 {"Apr"}
   05 {"May"}
   06 {"Jun"}
   07 {"Jul"}
   08 {"Aug"}
   09 {"Sep"}
   10 {"Oct"}
   11 {"Nov"}
   12 {"Dec"}
}

$months = "$monthname-$year"

$subsctiptionlist = Get-AzSubscription

"ResourceGroupName,UsageMonth,SubscriptionName,Cost,Location,Region,ApplicationName,EnvironmentName,ApplicationType" | Out-File -FilePath $outpath -Encoding utf8


#===========================
function GetAccessToken
{
	$azureCmdlet = get-command -Name Get-AZContext -ErrorAction SilentlyContinue
	if ($azureCmdlet -eq $null)
	{
		$null = Import-Module AZ -ErrorAction Stop;
	}
	$AzureContext = & "Get-AZContext" -ErrorAction Stop;
	$authenticationFactory = New-Object -TypeName Microsoft.Azure.Commands.Common.Authentication.Factories.AuthenticationFactory
	if ((Get-Variable -Name PSEdition -ErrorAction Ignore) -and ('Core' -eq $PSEdition))
	{
		[Action[string]]$stringAction = { param ($s) }
		$serviceCredentials = $authenticationFactory.GetServiceClientCredentials($AzureContext, $stringAction)
	}
	else
	{
		$serviceCredentials = $authenticationFactory.GetServiceClientCredentials($AzureContext)
	}
	
	# We can't get a token directly from the service credentials. Instead, we need to make a dummy message which we will ask
	# the serviceCredentials to add an auth token to, then we can take the token from this message.

	$message = New-Object System.Net.Http.HttpRequestMessage -ArgumentList @([System.Net.Http.HttpMethod]::Get, "http://foobar/")
	$cancellationToken = New-Object System.Threading.CancellationToken
	$null = $serviceCredentials.ProcessHttpRequestAsync($message, $cancellationToken).GetAwaiter().GetResult()
	$accessToken = $message.Headers.GetValues("Authorization").Split(" ")[1] # This comes out in the form "Bearer <token>"
	
	$accessToken
}
function GetHeaders
{
	param (
		[string]$AccessToken,
		[switch]$IncludeStatistics,
		[switch]$IncludeRender,
		[int]$ServerTimeout
	)
	
	$preferString = "response-v1=true"
	
	if ($IncludeStatistics)
	{
		$preferString += ",include-statistics=true"
	}
	
	if ($IncludeRender)
	{
		$preferString += ",include-render=true"
	}
	
	if ($ServerTimeout -ne $null)
	{
		$preferString += ",wait=$ServerTimeout"
	}
	
	$headers = @{
		"Authorization"		     = "Bearer $accessToken";
		"prefer"				 = $preferString;
		"x-ms-app"			     = "LogAnalyticsQuery.psm1";
		"x-ms-client-request-id" = [Guid]::NewGuid().ToString();
	}
	
	$headers
}

$json = '
{
    "type": "Usage",
    "timeframe": "TheLastMonth",
    "dataset": {
    "granularity": "Monthly",
    "aggregation": {
        "totalCost": {
        "name": "PreTaxCost",
        "function": "Sum"
        }
    },
    "grouping": [
        {
        "type": "Dimension",
        "name": "ResourceId"
        }
    ]
    }
}
'

#==============================




$subsctiptionlist | foreach {

    $subscription = $_.Name
    $tenantid = $_.TenantId
    $subid = $_.id

      
        $subselect = Select-AzSubscription -Subscription $subscription -Tenant $tenantid
    
       

        $rglist = Get-AzResourceGroup
        #===========================
        $accessToken = GetAccessToken
        $headers = GetHeaders $accessToken -IncludeStatistics:$null -IncludeRender:$null -ServerTimeout 1000
        #===========================
        $rglist | foreach {
       
            $rgname = $_.ResourceGroupName
            $rglocation = $_.Location

            $tags = $_.Tags

            $ENVIRONMENTNAME = $null
            $APPLICATIONNAME = $null
            $REGION = $null
            $APPLICATIONTYPE = $null
            
            $ENVIRONMENTNAME = ($tags.GetEnumerator() | Where {$_.Key -eq "ENVIRONMENT NAME"}).Value
            $APPLICATIONNAME = ($tags.GetEnumerator() | Where {$_.Key -eq "APPLICATION NAME"}).Value
            $REGION = ($tags.GetEnumerator() | Where {$_.Key -eq "REGION"}).Value
            $APPLICATIONTYPE = ($tags.GetEnumerator() | Where {$_.Key -eq "APPLICATION TYPE"}).Value

            $uri = "https://management.azure.com/subscriptions/$subid/resourceGroups/$rgname/providers/Microsoft.CostManagement/query?api-version=2019-11-01"
	        $response = Invoke-WebRequest -UseBasicParsing -Uri $uri -ContentType "application/json" -Headers $headers -Method POST -Body $json
            $costvalue = 0
            (($response.Content | ConvertFrom-Json).properties.rows) | foreach {
		       
		        $PreTaxCost = $null
		        		
		        $costdata = $_
		        $PreTaxCost = $costdata[0]
                $costvalue = $costvalue + $PreTaxCost
            }
           
            

        
            $cost = $null

            $cost = [math]::Round($costvalue,2)

          


            "$rgname,$months,$subscription,$cost,$rglocation,$REGION,$APPLICATIONNAME,$ENVIRONMENTNAME,$APPLICATIONTYPE" | Out-File -FilePath $outpath -Append -Encoding utf8

        }
    
    

}


            $SMTPServer = "smtp.office365.com"
            $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 587)
            $SMTPClient.EnableSsl = $true
            $sendgridusername = "demoemailtosend@xyz.com"
            $SecurePassword = ConvertTo-SecureString 'put-password-here' –asplaintext –force 
            $cred = New-Object System.Management.Automation.PsCredential($sendgridusername, $SecurePassword)
            
            $EmailFrom = "demoemailtosend@xyz.com"
            $EmailTo = "demoemailtosend@abc.com"
            $attachment = $outpath
            $Subject = "Resource Group wise Azure Cost Report for the month of $monthname-$year"
            $Body =  @"
    <p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>Hello Team,</span></strong></p><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>&nbsp;</span></p><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><strong><em><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>Please find attached Azure Cost Report for the month of $monthname-$year.</span></em></strong></p><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>&nbsp;</span></p><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#041E42;'>Please open the report and check if there is any Resource Group which doesn't have TAG's assigned and assign the TAG's before 26th-$monthname-$year</span><span style='font-size: 13px; font-family: "Century Gothic", sans-serif; color: rgb(226, 80, 65);'><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'>&nbsp;</p><p style='margin-right:0in;margin-left:0in;font-size:15px;font-family:"Calibri",sans-serif;margin:0in;margin-bottom:.0001pt;'><span style='font-size:13px;font-family:"Century Gothic",sans-serif;color:#002060;'>Thanks &amp; Regards</span></p>
"@
            Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $Subject -Body $Body -Priority High -SmtpServer $SMTPServer -Credential $cred -UseSsl -Port 587 -BodyAsHtml -Attachments $attachment -Verbose

