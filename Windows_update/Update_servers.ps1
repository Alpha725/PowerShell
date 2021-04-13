## script is to more place a script onto a server and run it
## it is "Multithreaded" as it will not wait for servers to complete before moving on.
## you will need to run ./wmiobject_fix.ps1 before this works
## Note you can pull the server name as you wish, just change out the $servers variable

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching'  | Where-Object {$_.FullDomainName -cnotlike "*wsus*"} | Where-Object {$_.FullDomainName -cnotlike "*hyp*"}

foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host starting update on $computer
    copy c:\Windows\System32\Windows_update.ps1 \\$computer\c$\temp\
    Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -Command {
        Start-Process -FilePath "c:\temp\Windows_update.ps1" -ArgumentList "YES YES"
    }
}
