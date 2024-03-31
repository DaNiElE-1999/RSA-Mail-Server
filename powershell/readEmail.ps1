# Get all directories and add them to the array
$directories = Get-ChildItem -Directory | Select-Object -ExpandProperty FullName

# Extract only the last directory name for display
$directoryNames = $directories | ForEach-Object { Split-Path $_ -Leaf }

# Display the list of directory names in a GUI and allow selection
$selectedDirectory = $directoryNames | Out-GridView -Title "Select a receiver" -OutputMode Single

if ($selectedDirectory) {
    # Load private key
    $privateKeyXml = Get-Content -Path (Join-Path $selectedDirectory "private_key.txt")
    $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
    $rsa.FromXmlString($privateKeyXml)

    # Get all text files in the selected directory/mails folder
    $textFiles = Get-ChildItem -Path (Join-Path $selectedDirectory "mails") -Filter *.txt | ForEach-Object { $_.BaseName }

    if ($textFiles.Count -gt 0) {
        # Display the list of text files in a GUI and allow selection
        $selectedTextFile = $textFiles | Out-GridView -Title "Select an e-mail" -OutputMode Single

        if ($selectedTextFile) {
            # Construct the full path of the selected text file
            $selectedTextFilePath = Join-Path -Path (Join-Path $selectedDirectory "mails") -ChildPath "$selectedTextFile.txt"

            # Read the content of the selected text file
            $content = Get-Content -Path $selectedTextFilePath -Raw

            # Split the content into an array of decimal numbers
            $numbers = $content -split ' '

            # Convert the decimal numbers to bytes
            $bytes = [byte[]]($numbers | ForEach-Object { [byte]$_ })

            # Decrypt message
            try {
                $decryptedBytes = $rsa.Decrypt($bytes, $false)
                $decryptedMessage = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

                # Display decrypted message in a GUI
                $decryptedMessage | Out-GridView -Title "Decrypted Message"
            }
            catch {
                Write-Host "Failed to decrypt the message. Error: $_"
            }
        }
        else {
            Write-Host "No text file selected."
        }
    }
    else {
        Write-Host "No text files found in $($selectedDirectory)\mails."
    }

}
else {
    Write-Host "No directory selected."
}
