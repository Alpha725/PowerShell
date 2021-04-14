## Calling Outlook API (?)

Add-Type -assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -comobject Outlook.Application
$namespace = $Outlook.GetNameSpace("MAPI")
$emailaddress = 'example@example.com'
$destinationfolder = 'example'

## Setting "system enviroment" variables

$Inbox = $namespace.Folders.Item('Alex.Baxter@waterstons.com').folders.item('inbox')
$Items = $namespace.Folders.Item('Alex.Baxter@waterstons.com').folders.item('inbox').items
$emails = $namespace.Folders.Item('Alex.Baxter@waterstons.com').folders.item('inbox').items | Select-Object SenderName,SenderEmailAddress

## Getting all of the emails as an array (could be better)

$emails_arr = ('example', 'emails')
$counter = 0
foreach ($email in $emails) {
    $emails_arr += $emails[$counter].sendername
    $counter +=1
}

## Sorting and getting out unique items

$Unique_emails = $emails_arr | Sort-Object | Get-Unique

## creates a folder for each uinque sender

foreach ($Unique in $Unique_emails) {
    $namespace.Folders($emailaddress).folders('inbox').folders($destinationfolder).folders.Add("$Unique")
}

## sorts the emails into correct folder

foreach ($Unique in $Unique_emails) {
    $Item = $Items.Find("[Sendername] = $Unique")
    $DestFolder = $namespace.Folders.Item($emailaddress).folders.item('inbox').folders.item($destinationfolder).folders.item("$Unique")
    DO {
        $Item.move($DestFolder)
        $Item = $Items.FindNext()
    } While (!($Item -eq $null))
}
