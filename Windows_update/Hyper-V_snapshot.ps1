## This is to take snapshots/Checkpoints for the VMs on hyper-v servers

$hyp_servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching' | Where-Object {$_.FullDomainName -like "*hyp*"}
foreach ($hyp in $hyp_servers) {
    write-host =========Connecting to $hyp.FullDomainName=========
    Invoke-Command -ComputerName $hyp.FullDomainName -Command {
        $VMs = get-vm | Where-Object {$_.State -eq 'Running'}
        foreach ($VM in $VMs) {
            write-host Snapshoting $VM.Name
            Checkpoint-VM -Name $VM.Name -SnapshotName BeforeInstallingUpdates
        }
    }
}

write-host "All snapshots have been taken. Once you are ready to remove them, "
pause
## removing snapshots from hyper-v hosts

$hyp_servers = Get-WsusComputer -ComputerTargetGroups 'Manual Patching' | Where-Object {$_.FullDomainName -like "*hyp*"}
foreach ($hyp in $hyp_servers) {
    write-host =========Connecting to $hyp.FullDomainName=========
    Invoke-Command -ComputerName $hyp.FullDomainName -Command {
        $VMs = get-vm | Where-Object {$_.State -eq 'Running'}
        foreach ($VM in $VMs) {
            write-host Removing snapshot for  $VM.Name
            Get-VM $VM.Name | Remove-VMSnapshot -Name BeforeInstallingUpdates
        }
    }
}
