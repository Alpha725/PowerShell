$Servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"'
$Master_Software = @()
foreach ($Server in $Servers) {
    Invoke-Command -ComputerName $Server.Name -Command {
        $computer_name = hostname
        $software = @()
        $32bit = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
        $64bit = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
        $total = $32bit + $64bit
        $programs = $total | Where-Object {$_.displayname -ne $null} | sort-object displayname
        foreach ($program in $programs) {
            $name =  $program.DisplayName
            $DisplayVersion =  $program.DisplayVersion
            $Publisher =  $program.Publisher
            $InstallDate =  $program.InstallDate
            $payload = @{Computer_Name = $computer_name ;  Software_Name = $name; DisplayVersion = $DisplayVersion; Publisher = $Publisher; InstallDate = $InstallDate}
            $software += , $payload
        }
        foreach ($item in $software) {$item}
    } | ForEach-Object -Process {$Master_Software += , $_}}

$Array = @()
foreach ($software in $Master_Software) {
    $Row = "" | Select Computer_Name, Software_Name, DisplayVersion, Publisher, InstallDate
    $Row.Computer_Name = $software.Computer_Name
    $Row.Software_Name = $software.Software_Name
    $Row.DisplayVersion = $software.DisplayVersion
    $Row.Publisher = $software.Publisher
    $Row.InstallDate = $software.InstallDate
    $Array += $Row
}
$Array | Export-csv c:\temp\serversoftware.csv
