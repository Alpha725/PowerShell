## script is to more place a script onto a server and run it
## it is "Multithreaded" as it will not wait for servers to complete before moving on.
## you will need to run ./wmiobject_fix.ps1 before this works
## Note you can pull the server name as you wish, just change out the $servers variable

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching'  | Where-Object {$_.FullDomainName -cnotlike "*wsus*"} | Where-Object {$_.FullDomainName -cnotlike "*hyp*"}

foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host starting update on $computer
    copy c:\Windows\System32\Windows_update.ps1 \\$computer\c$\temp\
    invoke-expression "cmd /c start powershell -Command {
        write-host ===========$computer===========
        Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -Command {
            c:\temp\Windows_update.ps1 YES YES
        }
        write-host When read to reboot hit enter, if no reboot required exit the script
        pause
        Restart-Computer -ComputerName $computer
    }"
}
write-host VMs are updating, once you have removed the snapshots and are ready to patch the hyper-v hosts
pause

$servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching'  | Where-Object {$_.FullDomainName -like "*hyp*"}

foreach ($server in $servers) {
    $computer = $server.FullDomainName
    write-host starting update on $computer
    copy c:\Windows\System32\Windows_update.ps1 \\$computer\c$\temp\
    invoke-expression "cmd /c start powershell -Command {
        write-host ===========$computer===========
        Invoke-Command -ComputerName $computer -ConfigurationName 'VirtualAccount' -Command {
            c:\temp\Windows_update.ps1 YES YES
        }
        write-host When read to reboot hit enter, if no reboot required exit the script
        pause
        Restart-Computer -ComputerName $computer
    }"
}
