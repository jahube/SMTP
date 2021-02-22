it worked 
######## PLAINTEXT ########
# Sender Credentials
$Username = "sender@domain.com"
$Password = "P@SSW0rd"
$credential = New-Object System.Net.NetworkCredential($Username,$Password)

########  STORED  #########
#Ask for credentials and store them
$credential = Get-Credential "sender@domain.com"

$credential.Password | ConvertFrom-SecureString | Set-Content C:\scriptsencrypted_password1.txt

# Read encrypted password
$encrypted = Get-Content C:\scriptsencrypted_password1.txt | ConvertTo-SecureString

# Set variables
$emailusername = "sender@domain.com"
$credential = New-Object System.Management.Automation.PsCredential($emailusername, $encrypted)

########################################
$fromaddress = "sender@domain.com"
$toaddress = "first@recipient.com", "second@recipient.com", "third@recipient.com"
$Subject = "Test message Powershell" 
$body = "Please find attached - test"
$attachment = "c:\send-emails-with-office365-smtp.png" 
$smtpserver = "smtp.office365.com"

#Use the variables in the script:
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress)
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach)
$message.body = $body
$smtp = new-object Net.Mail.SmtpClient($SmtpServer, 587) 
