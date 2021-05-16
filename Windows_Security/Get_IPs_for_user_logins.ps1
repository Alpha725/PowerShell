$DCs = Get-ADDomainController -filter *
$users = ('gloriane.ledean', 'maurice.brouchoud', 'joel.couedic')
foreach ($DC in $DCs) {
    Invoke-Command -ComputerName $DC.HostName -Command {
        foreach ($user in $users) {
            $messages = Get-EventLog -LogName security |? {$_.message -like "*$user*"}
            foreach ($message in $messages) {
                $result = $message.Message -match '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'
                if ( $result -ne $False){
                    write-host $user logged on from $result
                }
            }
        }
    }
}
