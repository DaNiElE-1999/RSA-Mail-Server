# Load public key
$publicKeyXml = Get-Content -Path "public_key.txt"
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.FromXmlString($publicKeyXml)

# Encrypt message
$message = "This is a secret message."
$encryptedMessage = $rsa.Encrypt([System.Text.Encoding]::UTF8.GetBytes($message), $false)

# Save encrypted message to file
[System.IO.File]::WriteAllBytes("encrypted_message.txt", $encryptedMessage)

Write-Host "Message encrypted and saved successfully."
