param (
    [string]$from,
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
$mailHogBaseUrl = "http://localhost:8025"

# Define the endpoint to fetch emails
$fetchEmailsEndpoint = "/api/v2/messages"

# Define filter criteria
$desiredSender = "$from"
$desiredSubject = "Public Key"

# Make a GET request to fetch emails from MailHog
$response = Invoke-RestMethod -Uri "$mailHogBaseUrl$fetchEmailsEndpoint" -Method Get

# Check if the request was successful
if ($response) {
    # Loop through each email in the response
    foreach ($email in $response.items) {
        # Extract email details
        $from = $email.Content.Headers.From[0]
        $subject = $email.Content.Headers.Subject[0]
        $body = $email.Content.Body
        $date = $email.Created

        # Check if the email matches the filter criteria
        if ($from -eq $desiredSender -and $subject -eq $desiredSubject) {
            Write-Output $body > "$path\foreignKey.pub"
        }
    }
}
else {
    Write-Host "Failed to fetch emails from MailHog."
}
