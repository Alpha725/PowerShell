## cleans up Windows_update.ps1

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching' 
foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host Cleaning up $computer
    Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -Command {
        del c:\temp\Windows_update.ps1
    }
}
