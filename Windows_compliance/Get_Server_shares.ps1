$Master_Shares_server = @()
$Servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"'
foreach ($Server in $Servers) {
    Get-CimInstance -ComputerName $Server.name -ClassName win32_share -ErrorAction SilentlyContinue | foreach-object -process {
        $Computer_Name = $_.PSComputerName
        $Name =  $_.Name
        $Path =  $_.Path
        $Description =  $_.Description
        $Share = "\\$Computer_Name\$Name"
        $payload = @{Computer_Name = $computer_name ;  Share_Name = $Name; Local_Path = $Path; Description = $Description ; Share = $Share}
        $Master_Shares_server += , $payload
    }
}
$Array = @()
foreach ($share in $Master_Shares_server) {
    $Row = "" | Select Computer_Name, Name, Path, Description, Share
    $Row.Computer_Name = $Computer =$share.Computer_Name
    $Row.Name = $Name = $share.Share_Name
    $Row.Path = $share.Local_Path
    $Row.Description = $share.Description
    $Row.Share = $share.Share
    $Array += $Row
}
$Array | Export-csv c:\temp\servershares.csv
