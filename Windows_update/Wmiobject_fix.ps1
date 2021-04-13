## Only used to allow remote wmiobject work with windows update API.
## Notes on this are as follows:
##    - you need to run this on all servers you want to be able to remotely call update api.
##    - after running it will kill the WinRM Service and you need to reconnect another way to restart the 
##      service. I used another remote tool 

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching'  | Where-Object {$_.FullDomainName -cnotlike "*hyp*"}
foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host configuring $computer
    Invoke-Command -ComputerName $computer -Command {
        New-PSSessionConfigurationFile -RunAsVirtualAccount -Path .\VirtualAccount.pssc
        Register-PSSessionConfiguration -Name 'VirtualAccount' -Path .\VirtualAccount.pssc -Force 
    }
}
