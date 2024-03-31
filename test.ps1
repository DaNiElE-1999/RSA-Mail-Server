# Generate RSA key pair
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)

# Public key for encryption
$publicKey = $rsa.ExportSubjectPublicKeyInfo()

# Private key for decryption
$privateKey = $rsa.ExportPkcs8PrivateKey()

# Convert keys to Base64 strings for storage or transmission
$publicKeyBase64 = [Convert]::ToBase64String($publicKey)
$privateKeyBase64 = [Convert]::ToBase64String($privateKey)

# Text to encrypt
$textToEncrypt = "Hello, World!"

# Convert text to bytes
$bytesToEncrypt = [System.Text.Encoding]::UTF8.GetBytes($textToEncrypt)

# Encrypt the text using the public key
$encryptedBytes = $rsa.Encrypt($bytesToEncrypt, $false)

# Convert encrypted bytes to Base64 string for storage or transmission
$encryptedText = [Convert]::ToBase64String($encryptedBytes)

# Decrypt the encrypted text using the private key
$decryptedBytes = $rsa.Decrypt($encryptedBytes, $false)

# Convert decrypted bytes back to text
$decryptedText = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

# Output
Write-Host "Original text: $textToEncrypt"
Write-Host "Encrypted text: $encryptedText"
Write-Host "Decrypted text: $decryptedText"
