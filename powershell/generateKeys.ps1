param (
    [string]$path,
    [string]$from,
    [string]$to
)

$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)

$publicKey = $rsa.ExportSubjectPublicKeyInfo()
$privateKey = $rsa.ExportPkcs8PrivateKey()

# Convert keys to Base64 strings for storage or transmission
$publicKeyBase64 = [Convert]::ToBase64String($publicKey)
$privateKeyBase64 = [Convert]::ToBase64String($privateKey)

Write-Output $publicKeyBase64 > "$path/id_rsa.pub"
Write-Output $privateKeyBase64 > "$path/id_rsa"

#Send the public key via e-mail
$smtpServer = $env:smtpServer
$port = $env:port
$credentials = New-Object System.Net.NetworkCredential("$env:username", "")
$message = New-Object System.Net.Mail.MailMessage($from, $to, "Public Key", $publicKeyBase64)
$message.IsBodyHtml = $false
$client = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
$client.Credentials = $credentials
$client.Send($message)