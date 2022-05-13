# requirements #
# Outlook configured for user run as
# expected #
# This would run every 5 minutes as a scheduled task

$emailaddress = ''
$teamswebhookuri = ''
$filters = (
    'THIS_IS_AN_EXAMPLE_OF_A_FILTER_HOWEVER_I_DONT_WANT_IT_TO_MATCH_1', 
    'THIS_IS_AN_EXAMPLE_OF_A_FILTER_HOWEVER_I_DONT_WANT_IT_TO_MATCH_2'
    )

function Get-MailItems ($emailaddress){
    Add-Type -assembly "Microsoft.Office.Interop.Outlook"
    Add-Type -assembly "System.Runtime.Interopservices"
    $Outlook = New-Object -comobject Outlook.Application
    $namespace = $Outlook.GetNameSpace("MAPI")
    $namespace.Folders.Item($emailaddress).folders.item('inbox').items 
}

function Send-TeamsWebhook ($email, $teamswebhookuri, $title, $text) {
    [String]$var = "$summary"
    $JSONBody = [PSCustomObject][Ordered]@{
    "@type" = "MessageCard"
    "@context" = "<http://schema.org/extensions>"
    "summary" = "$summary"
    "themeColor" = '0078D7'
    "title" = "$title has been reassigned"
    "text" = "$text"
    }
    $TeamMessageBody = ConvertTo-Json $JSONBody
    $parameters = @{
    "URI" = $teamswebhookuri
    "Method" = 'POST'
    "Body" = $TeamMessageBody
    "ContentType" = 'application/json'
    }
    Invoke-RestMethod @parameters
}

$emails = Get-mailitems $emailaddress
$recent_emails = $emails | ? {$_.ReceivedTime -gt (get-date).AddMinutes(-5)}

foreach ($filter in $filters) {
    $filtered_emails = $recent_emails | ? {$_.Subject -like "*$filter*"}
    if ($filtered_emails.count -eq 0) {exit}
    switch ($filter)
    {
        "THIS_IS_AN_EXAMPLE_OF_A_FILTER_HOWEVER_I_DONT_WANT_IT_TO_MATCH_1" {
            foreach ($email in $filtered_emails){
                $title = $email.subject.Split(':')[0]
                $text = $email.body
                $summary = "$title"
                Send-TeamsWebhook $email $teamswebhookuri $title $text
            }
        }
        "THIS_IS_AN_EXAMPLE_OF_A_FILTER_HOWEVER_I_DONT_WANT_IT_TO_MATCH_2" {
            echo "example filter to demonstrate modularity"
            echo "you need to define $title $text and $summary"
            echo "before calling Send-TeamsWebhook $email $teamswebhookuri $title $text"
        }
    }
}
