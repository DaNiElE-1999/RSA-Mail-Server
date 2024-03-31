param (
    [string]$path,
    [string]$from,
    [string]$to
)

$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048

# Export private key
$privateKey = $rsa.ExportParameters($true)
$privateKeyXml = $rsa.ToXmlString($true)
$privateKeyXml | Out-File -FilePath "$path/private_key.txt"

# Export public key
$publicKey = $rsa.ExportParameters($false)
$publicKeyXml = $rsa.ToXmlString($false)
$publicKeyXml | Out-File -FilePath "$path/public_key.txt"

#Send the public key via e-mail
$smtpServer = $env:smtpServer
$port = $env:port
$credentials = New-Object System.Net.NetworkCredential("$env:username", "")
$message = New-Object System.Net.Mail.MailMessage($from, $to, "Public Key", "$publicKeyXml")
$message.IsBodyHtml = $false
$client = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
$client.Credentials = $credentials
$client.Send($message)