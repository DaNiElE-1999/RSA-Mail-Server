Add-Type -AssemblyName System.Windows.Forms

#using enviromental variables file
Get-Content .env | foreach {
    $name, $value = $_.split('=')
    if ([string]::IsNullOrWhiteSpace($name) || $name.Contains('#')) {
        continue
    }
    Set-Content env:\$name $value
}


# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Email Information"
$form.Size = New-Object System.Drawing.Size(400, 250)
$form.StartPosition = "CenterScreen"

# Recipient Email
$labelTo = New-Object System.Windows.Forms.Label
$labelTo.Location = New-Object System.Drawing.Point(10, 20)
$labelTo.Size = New-Object System.Drawing.Size(100, 23)
$labelTo.Text = "Recipient Email:"
$form.Controls.Add($labelTo)

$textBoxTo = New-Object System.Windows.Forms.TextBox
$textBoxTo.Location = New-Object System.Drawing.Point(120, 20)
$textBoxTo.Size = New-Object System.Drawing.Size(250, 23)
$form.Controls.Add($textBoxTo)

# Sender Email
$labelFrom = New-Object System.Windows.Forms.Label
$labelFrom.Location = New-Object System.Drawing.Point(10, 60)
$labelFrom.Size = New-Object System.Drawing.Size(100, 23)
$labelFrom.Text = "Sender Email:"
$form.Controls.Add($labelFrom)

$textBoxFrom = New-Object System.Windows.Forms.TextBox
$textBoxFrom.Location = New-Object System.Drawing.Point(120, 60)
$textBoxFrom.Size = New-Object System.Drawing.Size(250, 23)
$form.Controls.Add($textBoxFrom)

# Subject
$labelSubject = New-Object System.Windows.Forms.Label
$labelSubject.Location = New-Object System.Drawing.Point(10, 100)
$labelSubject.Size = New-Object System.Drawing.Size(100, 23)
$labelSubject.Text = "Subject:"
$form.Controls.Add($labelSubject)

$textBoxSubject = New-Object System.Windows.Forms.TextBox
$textBoxSubject.Location = New-Object System.Drawing.Point(120, 100)
$textBoxSubject.Size = New-Object System.Drawing.Size(250, 23)
$form.Controls.Add($textBoxSubject)

# Body
$labelBody = New-Object System.Windows.Forms.Label
$labelBody.Location = New-Object System.Drawing.Point(10, 140)
$labelBody.Size = New-Object System.Drawing.Size(100, 23)
$labelBody.Text = "Body:"
$form.Controls.Add($labelBody)

$textBoxBody = New-Object System.Windows.Forms.TextBox
$textBoxBody.Location = New-Object System.Drawing.Point(120, 140)
$textBoxBody.Size = New-Object System.Drawing.Size(250, 50)
$textBoxBody.Multiline = $true
$form.Controls.Add($textBoxBody)

# Button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150, 200)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Send Email"
$button.Add_Click({
        
        # Retrieve input values
        [string]$to = $textBoxTo.Text
        [string]$from = $textBoxFrom.Text
        [string]$subject = $textBoxSubject.Text
        [string]$body = $textBoxBody.Text

        #Check if communication channel already exists
        & .\checkCommunicationChannel.ps1 -to $to -from $from

        #If communication channel exists, encrypt email using the public key of the reciever
        $publicKeyXml = Get-Content -Path "../users/$from/$to/foreignKey.txt"
        $rsa = New-Object System.Security.Cryptography.RSACryptoServiceProvider
        $rsa.FromXmlString($publicKeyXml)
        $encryptedMessage = $rsa.Encrypt([System.Text.Encoding]::UTF8.GetBytes($body), $false)

        # Save encrypted message to file
        [System.IO.File]::WriteAllBytes("encrypted_message.txt", $encryptedMessage)

        # Your existing email sending code goes here
        $smtpServer = $env:smtpServer
        $port = $env:port
        $credentials = New-Object System.Net.NetworkCredential("$env:username", "")
        $message = New-Object System.Net.Mail.MailMessage($from, $to, $subject, $encryptedMessage)
        $message.IsBodyHtml = $false
        $client = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
        $client.Credentials = $credentials
        $client.Send($message)

        Write-Host "Email sent successfully to $to"

        #Save the email in the folder

        &  .\saveEmail.ps1 -from $from -path "..\users\$to\$from\mails"
    })

$form.Controls.Add($button)

$form.ShowDialog() | Out-Null
