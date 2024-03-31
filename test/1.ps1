# Generate RSA key pair
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider 2048

# Export private key
$privateKey = $rsa.ExportParameters($true)
$privateKeyXml = $rsa.ToXmlString($true)
$privateKeyXml | Out-File -FilePath "private_key.txt"

# Export public key
$publicKey = $rsa.ExportParameters($false)
$publicKeyXml = $rsa.ToXmlString($false)
$publicKeyXml | Out-File -FilePath "public_key.txt"

Write-Host "Private and public keys exported successfully."
