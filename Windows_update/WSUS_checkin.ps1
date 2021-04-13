## Making sure everything has checked in
## From what understand 

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching' -ComputerUpdateStatus needed
foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host Checking $computer in with Wsus
    Invoke-Command -ComputerName $computer -Command {
            Wuauclt /detectnow
            Wuauclt /registernow
            Wuauclt /reportnow
    }
}
