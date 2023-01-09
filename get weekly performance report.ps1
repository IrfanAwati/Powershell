$TenantID = "enter-tenant-id-here"
$ApplicationID = "enter-application-id-here"
$ApplicationSecret = "enter-application-id-secret-here"

$SecurePassword = ConvertTo-SecureString "$ApplicationSecret" -AsPlainText -Force
$AzureCredentials = New-Object System.Management.Automation.PSCredential ("$ApplicationID", $SecurePassword)

Connect-AzAccount -ServicePrincipal -Tenant $TenantID -Credential $AzureCredentials -Force
Write-Host "Connected to the Azure Portal on" $TenantID -BackgroundColor DarkGreen

#Change the Subscription ID
Select-AzSubscription -Subscription "enter-subscription-id-here"

Remove-Item -Path "C:\temp\sandeep\*" -Force -Verbose -ErrorAction SilentlyContinue

$outputr2c= "C:" + "\" +"temp"+"\" +"sandeep" + "\" + "prod-stage" +"$DateTime" + ".xlsx" 
$outputr2cehtml= "C:" + "\" +"temp"+"\" +"sandeep" + "\" +"prod-stage-report.html"

$r2cresorces=Get-AzResource -ResourceGroupName "enter-resource-group-here"
$regioname="APAC"

    foreach($r2cresorce in $r2cresorces){
     $Headerhtml = @"
<style>
{font-family: Arial; font-size: 13pt;}
TABLE{border: 1px solid black; border-collapse: collapse; font-size:13pt; align=left}
TH{border: 1px solid black; background: skyblue; padding: 5px; color: #000000;}
TD{border: 1px solid black; padding: 5px; text-align:center;}
</style>
"@
    if($r2cresorce.type -eq "Microsoft.Web/sites"){
    $r2cresorce.name
        $region= if($r2cresorce.name -match "stag"){"STAGE"}else{"PROD"}
        $days = "-7"
        $startDate = [datetime]::Today.AddDays($days)
        $endDate = [datetime]::Today

        $https4xxstage_Average = 0.0
        $https4xxstage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "Http4xx" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $https4xxstage_Average = [System.Math]::Round($(($https4xxstage.Data.Total | Measure-Object -Sum).Sum),2.2)
        $https4xxstage_Average

        $https5xxstage_Average = 0.0
        $https5xxstage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "Http5xx" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $https5xxstage_Average = [System.Math]::Round($(($https5xxstage.Data.Total | Measure-Object -Sum).Sum),2.2)
        $https5xxstage_Average

        $HttpResponseTime_Average = 0.0
        $HttpResponseTime = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "HttpResponseTime" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $HttpResponseTime_Average = [System.Math]::Round($(($HttpResponseTime.Data.Average | Measure-Object -Average).Average),2.2)
        $HttpResponseTime_Average

         $r2cresorce | Select @{n="Region";e={"$regioname"}}, @{n="Enviornment";e={$region}}, ResourceGroupName,name,@{n="TotaLHttps-4xx";e={"$https4xxstage_Average"}},@{n="TotaLHttps-5xx";e={$https5xxstage_Average}},@{n="AverageresponseTime-MS";e={$HttpResponseTime_Average}}|
        Export-Excel -Path $outputr2c -WorksheetName "AppService" -Append -Verbose

    }

    if($r2cresorce.type -eq "Microsoft.Web/sites/slots"){
    $r2cresorce.name
        $region= if($r2cresorce.name -match "stag"){"STAGE"}else{"PROD"}
        $days = "-7"
        $startDate = [datetime]::Today.AddDays($days)
        $endDate = [datetime]::Today

        $https4xxstage_Average = 0.0
        $https4xxstage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "Http4xx" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $https4xxstage_Average = [System.Math]::Round($(($https4xxstage.Data.Total | Measure-Object -Sum).Sum),2.2)
        $https4xxstage_Average

        $https5xxstage_Average = 0.0
        $https5xxstage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "Http5xx" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $https5xxstage_Average = [System.Math]::Round($(($https5xxstage.Data.Total | Measure-Object -Sum).Sum),2.2)
        $https5xxstage_Average

        $HttpResponseTime_Average = 0.0
        $HttpResponseTime = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "HttpResponseTime" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $HttpResponseTime_Average = [System.Math]::Round($(($HttpResponseTime.Data.Average | Measure-Object -Average).Average),2.2)
        $HttpResponseTime_Average

        $r2cresorce | Select @{n="Region";e={"$regioname"}}, @{n="Enviornment";e={$region}}, ResourceGroupName,name,@{n="TotaLHttps-4xx";e={"$https4xxstage_Average"}},@{n="TotaLHttps-5xx";e={$https5xxstage_Average}},@{n="AverageresponseTime-MS";e={$HttpResponseTime_Average}}|
        Export-Excel -Path $outputr2c -WorksheetName "AppService" -Append -Verbose

    }

    if($r2cresorce.type -eq "Microsoft.Web/serverfarms"){
    $r2cresorce.name
        $region= if($r2cresorce.name -match "stag"){"STAGE"}else{"PROD"}
        $days = "-7"
        $startDate = [datetime]::Today.AddDays($days)
        $endDate = [datetime]::Today

        $CpuPercentage_Average = 0.0
        $aspCpuPercentage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "CpuPercentage" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $CpuPercentage_Average = [System.Math]::Round($(($aspCpuPercentage.Data.Average | Measure-Object -Average).Average),2.2)
        $CpuPercentage_Average

        $MemoryPercentage_Average = 0.0
        $aspMemoryPercentage = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "MemoryPercentage" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $MemoryPercentage_Average = [System.Math]::Round($(($aspMemoryPercentage.Data.Average | Measure-Object -Average).Average),2.2)
        $MemoryPercentage_Average

        $HttpQueueLength_Average = 0.0
        $aspHttpQueueLength = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "HttpQueueLength" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $HttpQueueLength_Average = [System.Math]::Round($(($aspHttpQueueLength.Data.Average | Measure-Object -Average).Average),2.2)
        $HttpQueueLength_Average

         $r2cresorce | Select @{n="Region";e={"$regioname"}}, @{n="Enviornment";e={$region}}, ResourceGroupName,name,@{n="AvgCPU-Percentage";e={$CpuPercentage_Average}},
           @{n="AvgMemory-Percentage";e={$MemoryPercentage_Average}},@{n="MaxHttpQueueLength";e={$HttpQueueLength_Average}}|
        Export-Excel -Path $outputr2c -WorksheetName "Appserviceplan" -Append -Verbose

    }

    if($r2cresorce.type -eq "microsoft.insights/components"){
    $r2cresorce.name
        $region= if($r2cresorce.name -match "stag"){"STAGE"}else{"PROD"}
        $days = "-7"
        $startDate = [datetime]::Today.AddDays($days)
        $endDate = [datetime]::Today

        $requestsfailed_Average = 0.0
        $appinsrequestsfailed = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "requests/failed" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $requestsfailed_Average = [System.Math]::Round($(($appinsrequestsfailed.Data.Average | Measure-Object -Average).Average),2.2)
        $requestsfailed_Average

        $exceptionscount_Average = 0.0
        $appinsexceptionscount = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "exceptions/count" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $exceptionscount_Average = [System.Math]::Round($(($appinsexceptionscount.Data.Average | Measure-Object -Average).Average),2.2)
        $exceptionscount_Average

        $dependenciesfailed_Average = 0.0
        $appinsdependenciesfailed = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "dependencies/failed" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $dependenciesfailed_Average = [System.Math]::Round($(($appinsdependenciesfailed.Data.Average | Measure-Object -Average).Average),2.2)
        $dependenciesfailed_Average

         $r2cresorce | Select @{n="Region";e={"$regioname"}}, @{n="Enviornment";e={$region}}, ResourceGroupName,name,@{n="AVG-requests/failed";e={$requestsfailed_Average}},
           @{n="AVG-exceptions/count";e={$exceptionscount_Average}},@{n="AVG-dependencies/failed";e={$dependenciesfailed_Average}}|
        Export-Excel -Path $outputr2c -WorksheetName "appinsight" -Append -Verbose

    }

    if($r2cresorce.type -eq "microsoft.sql/servers/databases"){
    $r2cresorce.name
        $region= if($r2cresorce.name -match "stag"){"STAGE"}else{"PROD"}
        $days = "-7"
        $startDate = [datetime]::Today.AddDays($days)
        $endDate = [datetime]::Today
        $sqldbname=($r2cresorce.name -split "/")[-1]
        $sqldbrg= $r2cresorce.ResourceGroupName
        $sqlservername=($r2cresorce.name -split "/")[-2]
        if($sqldbname -eq "master"){}
        else{
        $dtu_consumption_percent_Average = 0.0
        $dtu_consumption_percent = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "dtu_consumption_percent" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $dtu_consumption_percent_Average = [System.Math]::Round($(($dtu_consumption_percent.Data.Average | Measure-Object -Average).Average),2.2)
        $dtu_consumption_percent_Average

        $connection_failed_Average = 0.0
        $connection_failed = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "connection_failed" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $connection_failed_Average = [System.Math]::Round($(($connection_failed.Data.Total | Measure-Object -Sum).Sum),2.2)
        $connection_failed_Average

        $deadlock_Average = 0.0
        $deadlock = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "deadlock" -AggregationType Total -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $deadlock_Average = [System.Math]::Round($(($deadlock.Data.Total | Measure-Object -Sum).Sum),2.2)
        $deadlock_Average

        $storage_percent_Average = 0.0
        $storage_percent = Get-AzMetric -ResourceId $r2cresorce.Id -MetricName "storage_percent" -AggregationType Average -DetailedOutput -StartTime $startDate -EndTime $endDate -TimeGrain 12:00:00 -WarningAction SilentlyContinue
        $storage_percent_Average = [System.Math]::Round($(($storage_percent.Data.Average | Measure-Object -Average).Average),2.2)
        $storage_percent_Average

         $r2cresorce | Select @{n="Region";e={"$regioname"}}, @{n="Enviornment";e={$region}}, ResourceGroupName,Name,@{n="AVG-DTU percentage";e={$dtu_consumption_percent_Average}},
           @{n="Total-Failed Connections";e={$connection_failed_Average}},@{n="Total-Deadlocks";e={$deadlock_Average}},@{n="AVG-storage percentage";e={$storage_percent_Average}}|
        Export-Excel -Path $outputr2c -WorksheetName "sqldb" -Append -Verbose
        }
    }

    }


    $detailsappservice=Import-Excel -Path $outputr2c -WorksheetName "AppService" -Verbose
    $detailsAppserviceplan=Import-Excel -Path $outputr2c -WorksheetName "Appserviceplan" -Verbose
    $detailsappinsight=Import-Excel -Path $outputr2c -WorksheetName "appinsight" -Verbose 
    $detailssqldb=Import-Excel -Path $outputr2c -WorksheetName "sqldb" -Verbose

    

      
    "<h2><b><u>Report from $startDate to $endDate</u></b></h2>" | Out-File -FilePath $outputr2cehtml  -Append -Verbose 
    $detailsappservice=Import-Excel -Path $outputr2c -WorksheetName "AppService" -Verbose
    "<h2><b><u>App Service</u></b></h2>" | Out-File -FilePath $outputr2cehtml  -Append -Verbose
    "<BR>$Headerhtml" | Out-File -FilePath $outputr2cehtml -Append
'<table><tr><TH>Region</TH>
    <TH>Enviornment</TH>
    <TH>ResourceGroupName</TH>
    <TH>Name</TH>
    <TH>TotaLHttps-4xx</TH>
    <TH>TotaLHttps-5xx</TH>
    <TH>AverageresponseTime-MS</TH></tr>'| Out-File -FilePath $outputr2cehtml -Append
    $var2=''
$detailsappservice | foreach {

    $Region = $_.Region
    $Enviornment = $_.Enviornment
    $ResourceGroupName = $_.ResourceGroupName
    $Resourcename = $_.Name
    $http4xx = $_.'TotaLHttps-4xx'
    $http5xx = $_.'TotaLHttps-5xx'
    $MAXAverageresponseTime = $_.'AverageresponseTime-MS'
    

    $var2 += "<tr><TD>$Region</TD>
    <TD>$Enviornment</TD>
    <TD>$ResourceGroupName</TD>
    <TD>$Resourcename</TD>"
         
         if($http4xx -gt 10)
    {
        $var2 +="<TD style='background-color:#FF8080'>$http4xx</TD>"
    }
    else
    {

        $var2 +="<TD>$http4xx</TD>"
    }
         if($http5xx -gt 10)
    {
        $var2 +="<TD style='background-color:#FF8080'>$http5xx</TD>"
    }
    else
    {

        $var2 +="<TD>$http5xx</TD>"
    }

      $var2 += "<TD>$MAXAverageresponseTime</TD>"
  "</tr>"
    }
    
     $var2 
    "$var2</table>" |  Out-File -FilePath $outputr2cehtml -Append -Verbose


    $detailsAppserviceplan=Import-Excel -Path $outputr2c -WorksheetName "Appserviceplan" -Verbose
    "<h2><b><u>App Service Plan</u></b></h2>" | Out-File -FilePath $outputr2cehtml  -Append -Verbose
    $Headerhtml | Out-File -FilePath $outputr2cehtml -Append
'<table><tr><TH>Region</TH>
    <TH>Enviornment</TH>
    <TH>ResourceGroupName</TH>
    <TH>Name</TH>
    <TH>AvgCPU-Percentage</TH>
    <TH>AvgMemory-Percentage</TH>
    <TH>MaxHttpQueueLength</TH>'| Out-File -FilePath $outputr2cehtml -Append
    $var4=""
$detailsAppserviceplan | foreach {

    $Region = $_.Region
    $Enviornment = $_.Enviornment
    $ResourceGroupName = $_.ResourceGroupName
    $Resourcename = $_.name
    $AvgCPUPercentage = $_.'AvgCPU-Percentage'
    $AvgMemoryPercentage = $_.'AvgMemory-Percentage'
    $MaxHttpQueueLength = $_.MaxHttpQueueLength
 

    $var4 += "<tr><TD>$Region</TD>
    <TD>$Enviornment</TD>
    <TD>$ResourceGroupName</TD>
    <TD>$Resourcename</TD>"
    if($AvgCPUPercentage -gt 80)
    {
        $var4 +="<TD style='background-color:#FF8080'>$AvgCPUPercentage</TD>"
    }
    else
    {

        $var4 +="<TD>$AvgCPUPercentage</TD>"
    }
    if($AvgMemoryPercentage -gt 80)
    {
        $var4 +="<TD style='background-color:#FF8080'>$AvgMemoryPercentage</TD>"
    }
    else
    {

        $var4 +="<TD>$AvgMemoryPercentage</TD>"
    }

    $var4 += "<TD>$MaxHttpQueueLength</TD></tr>"

     $var4
    
}

"$var4</table>" |  Out-File -FilePath $outputr2cehtml -Append 

    $detailssqldb=Import-Excel -Path $outputr2c -WorksheetName "sqldb" -Verbose 
    "<h2><b><u>Sql Database</u></b></h2>" | Out-File -FilePath $outputr2cehtml  -Append -Verbose
    $Headerhtml | Out-File -FilePath $outputr2cehtml  -Append
'<table><tr><TH>Region</TH>
    <TH>Enviornment</TH>
    <TH>ResourceGroupName</TH>
    <TH>Name</TH>
    <TH>AVG-DTU percentage</TH>
    <TH>AVG-Failed Connections</TH>
    <TH>Total-Deadlocks</TH>
    <TH>AVG-storage percentage</TH></tr>'| Out-File -FilePath $outputr2cehtml -Append
    $var5= ""
$detailssqldb | foreach {

    $Region = $_.Region
    $Enviornment = $_.Enviornment
    $ResourceGroupName = $_.ResourceGroupName
    $Resourcename = $_.name
    $dtut = $_.'AVG-DTU percentage'
    $fll = $_.'Total-Failed Connections'
    $dddd = $_.'Total-Deadlocks'
    $stper = $_.'AVG-storage percentage'

    $var5 += "<tr><TD>$Region</TD>
    <TD>$Enviornment</TD>
    <TD>$ResourceGroupName</TD>
    <TD>$Resourcename</TD>"
    if($dtut -gt 80 )
    {
        $var5 +="<TD style='background-color:#FF8080'>$dtut</TD>"
         
    }
    else
    {
        $var5 +="<TD>$dtut</TD>"
        
    }
        if($fll -gt 10 )
    {
        $var5 +="<TD style='background-color:#FF8080'>$fll</TD>"
         
    }
    else
    {
        $var5 +="<TD>$fll</TD>"
        
    }
        if($dddd -gt 10 )
    {
        $var5 +="<TD style='background-color:#FF8080'>$dddd</TD>"
         
    }
    else
    {
        $var5 +="<TD>$dddd</TD>"
        
    }
        if($stper -gt 80 )
    {
        $var5 +="<TD style='background-color:#FF8080'>$stper</TD>"
         
    }
    else
    {
        $var5 +="<TD>$stper</TD>"
        
    }
    
    '</tr>'
    $var5
  
}

"$var5</table>" |  Out-File -FilePath $outputr2cehtml -Append 

$detailsappinsight=Import-Excel -Path $outputr2c -WorksheetName "appinsight" -Verbose

    "<h2><b><u>App Insight</u></b></h2>" | Out-File -FilePath $outputr2cehtml  -Append -Verbose
    $Headerhtml | Out-File -FilePath $outputr2cehtml -Append
'<table><tr><TH>Region</TH>
    <TH>Enviornment</TH>
    <TH>ResourceGroupName</TH>
    <TH>Name</TH>
    <TH>AVG-requests/failed</TH>
    <TH>AVG-exceptions/count</TH>
    <TH>AVG-dependencies/failed</TH>'| Out-File -FilePath $outputr2cehtml -Append
    $var6=""
$detailsappinsight | foreach {

    $Region = $_.Region
    $Enviornment = $_.Enviornment
    $ResourceGroupName = $_.ResourceGroupName
    $Resourcename = $_.name
    $fr = $_.'AVG-requests/failed'
    $ec = $_.'AVG-exceptions/count'
    $df = $_.'AVG-dependencies/failed'
 

    $var6 += "<tr><TD>$Region</TD>
    <TD>$Enviornment</TD>
    <TD>$ResourceGroupName</TD>
    <TD>$Resourcename</TD>"
    if($fr -gt 10)
    {
        $var6 +="<TD style='background-color:#FF8080'>$fr</TD>"
    }
    else
    {

        $var6 +="<TD>$fr</TD>"
    }
    if($ec -gt 10)
    {
        $var6 +="<TD style='background-color:#FF8080'>$ec</TD>"
    }
    else
    {

        $var6 +="<TD>$ec</TD>"
    }

       if($df -gt 10)
    {
        $var6 +="<TD style='background-color:#FF8080'>$df</TD>"
    }
    else
    {

        $var6 +="<TD>$df</TD>"
    }

     $var6
    
}

"$var6</table>" |  Out-File -FilePath $outputr2cehtml -Append



$report=Get-Content -Path $outputr2cehtml

