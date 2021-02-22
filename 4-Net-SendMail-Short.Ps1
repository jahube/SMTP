Set-ExecutionPolicy RemoteSigned -Force

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-Module-ExchangeonlineManagement

Connect-Exchangeonline -userprincipalname "admin@domain.com"

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

####################  choose 1/2/3  ######################

# (1) minimalist <<
$body = "Please find attached - test"

# (2) HTML Block <<
$Body = @'
<!DOCTYPE html>
<html>
<head>
</head>
<body>
This is a test message to trigger an ETR.
The message was sent on: $(get-date)
</body>
</html>
'@

# (3) Hmtl Template
$web = wget "https://raw.githubusercontent.com/jahube/SMTP/main/misc/template.html"
$Body = [System.Web.HttpUtility]::HtmlDecode($web.content)

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
