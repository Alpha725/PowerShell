$script = Get-Content .\Windows_update.ps1
$manual_servers = Get-Content .\manual_patching.txt
foreach ($server in $manual_servers) {
	start-process Invoke-Command -ComputerName $server -Command {
	$script >> c:\temp\Windows_update.ps1
	c:\temp\Windows_update.ps1 YES YES
	}
}
