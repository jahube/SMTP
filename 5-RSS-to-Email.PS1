Set-ExecutionPolicy RemoteSigned -Force

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

##########################################################

$FROM = "sender@domain.com"

$TO = "first@recipient.com", "second@recipient.com", "third@recipient.com"

$attachment = "c:\send-emails-with-office365-smtp.png"

##########################################################
$credential = get-credential $FROM
$smtpserver = "smtp.office365.com"
$Port = "587"
##########################################################
$Subject = "Test message Powershell"

############ choose short vs long ########################
#Example 1
$body = "Please find attached - test"

#Example 2
$Subject = "This is a test message to trigger an ETR"
$Body = @"
<!DOCTYPE html>
<html>
<head>
</head>
<body>
This is a test message to trigger an ETR.
The message was sent on: $(get-date)
</body>
</html>
"@

#Example 3
$Subject = "Sent with Powershell using Html template"
$web = wget "https://raw.githubusercontent.com/jahube/SMTP/main/misc/template.html"
$Body = [System.Web.HttpUtility]::HtmlDecode($web.content)

#Example 4 
$Subject = "Blog RSS Feed"
$Url = 'https://powershellexplained.com/feed.xml'
$webclient = new-object system.net.webclient
$rssFeed = [xml]$webclient.DownloadString($Url)
$Body = $rssFeed.rss.channel.item | Select-Object title,description,link -First 5 | ConvertTo-Html

#Example 5 
$Subject = "Google Feed"
$webclient = new-object system.net.webclient
$rssFeed = [xml]$webclient.DownloadString('http://news.google.com/?output=rss')
$Body = $rssFeed.rss.channel.item | Select-Object title,description,link -First 5 | ConvertTo-Html

#test
$test =  Invoke-RestMethod "https://powershellexplained.com/feed.xml"

##########################################################
$message = new-object System.Net.Mail.MailMessage
$message.From = $FROM
$message.To.Add($TO)
$message.IsBodyHtml = $True
$message.Subject = $Subject
$attach = new-object Net.Mail.Attachment($attachment)
$message.Attachments.Add($attach)
$message.body = $body

$smtp = new-object Net.Mail.SmtpClient($SmtpServer, 587)
$smtp.EnableSsl = $true
$smtp.Credentials = $credential;
$smtp.Send($message)
##########################################################

#Example 6
$Subject = "Blog RSS Feed"
$Url = 'https://powershellexplained.com/feed.xml'
$webclient = new-object system.net.webclient
$rssFeed = [xml]$webclient.DownloadString($Url)
$Body2 = $rssFeed.rss.channel.item | Select-Object title,description,link -First 5 | ConvertTo-Html
$Body = "
<!DOCTYPE html>
<html>
<head>
<ul>"

foreach($B in $Body2) {
   $item = '<li>';
   $line = '<a href="' + $($B.link) + '" title="' + $($B.title) + '" target="_blank">' +  $($B.title)  +  '</a>'; # output link & title
   $item += $line
   $item +=  $($B.description)
   $item +=  '</li>';
   $body += $item
}

$body += "</ul> The message was sent on: $(get-date)
</body>
</html>" 
