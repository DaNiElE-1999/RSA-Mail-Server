# Load private key
$privateKeyXml = Get-Content -Path "private_key.txt"
$rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
$rsa.FromXmlString($privateKeyXml)

# Load encrypted message
# $encryptedMessage = [System.IO.File]::ReadAllBytes("encrypted_message.txt")

# Read the content of the file
$content = Get-Content -Path "encrypted_message.txt"

# Split the content into an array of decimal numbers
$numbers = $content -split ' '

# Convert the decimal numbers to bytes
$bytes = [byte[]]($numbers | ForEach-Object { [byte]$_ })

# Output the byte array
$bytes

# Decrypt message
try {
    $decryptedBytes = $rsa.Decrypt($bytes, $false)
    $decryptedMessage = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

    Write-Host "Decrypted message:"
    Write-Host $decryptedMessage
}
catch {
    Write-Host "Failed to decrypt the message. Error: $_"
}
