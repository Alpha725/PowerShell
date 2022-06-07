# Needs to be tested

$Servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"'
$Master_Software = @()
$Array = @()
foreach ($Server in $Servers) {
    Invoke-Command -ComputerName $Server.Name -Command {
        $computer_name = hostname
        $software = @()
        $32bit = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
        $64bit = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
        $total = $32bit + $64bit
        $programs = $total | Where-Object {$_.displayname -ne $null} | sort-object displayname
        foreach ($program in $programs) {
            $Row = "" | Select Computer_Name, Software_Name, DisplayVersion, Publisher, InstallDate
            $Row.Computer_Name = $computer_name
            $Row.Software_Name = $program.DisplayName
            $Row.DisplayVersion = $program.DisplayVersion
            $Row.Publisher = $program.Publisher
            $Row.InstallDate = $program.InstallDate
            $Array += $Row
        }
    }
}
$Array | Export-csv c:\temp\serversoftware.csv
