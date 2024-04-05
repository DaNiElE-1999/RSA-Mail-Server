param (
    [string]$from,
    [string]$to,
    [string]$path
)

#using enviromental variables file
Get-Content .env | foreach {
    $name, $value = $_.split('=')
    if ([string]::IsNullOrWhiteSpace($name) || $name.Contains('#')) {
        continue
    }
    Set-Content env:\$name $value
}

# Define the base URL for your MailHog instance
$mailHogBaseUrl = "http://localhost:8025" # to be fixed with env

# Define the endpoint to fetch emails
$fetchEmailsEndpoint = "/api/v2/messages"

# Define filter criteria
$desiredSender = "$from"
$desiredReciever = "$to"
$desiredSubject = "Public Key"

# Make a GET request to fetch emails from MailHog
$response = Invoke-RestMethod -Uri "$mailHogBaseUrl$fetchEmailsEndpoint" -Method Get

# Check if the request was successful
if ($response) {
    # Loop through each email in the response
    foreach ($email in $response.items) {
        # Extract email details
        $from = $email.Content.Headers.From[0]
        $to = $email.Content.Headers.To[0]
        $subject = $email.Content.Headers.Subject[0]
        $body = $email.Content.Body

        # Check if the email matches the filter criteria
        if ($from -eq $desiredSender -and $to -eq $desiredReciever -and $subject -eq $desiredSubject) {
            $unitedContent = $body -replace '=\r\n', ''
            $pattern = "(?<==)3D"
            $outputString = [regex]::Replace($unitedContent, $pattern, "")
            Write-Output $outputString > "$path\foreignKey.txt"
        }
    }
}
else {
    Write-Host "Failed to fetch emails from MailHog."
}
