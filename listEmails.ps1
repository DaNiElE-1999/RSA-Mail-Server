# Define the base URL for your MailHog instance
$mailHogBaseUrl = "http://localhost:8025"

# Define the endpoint to fetch emails
$fetchEmailsEndpoint = "/api/v2/messages"

# Define filter criteria
$desiredSender = "example@example.com"
$desiredSubject = "Your desired subject"

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
            # Output email details
            Write-Host "From: $from"
            Write-Host "Subject: $subject"
            Write-Host "Date: $date"
            Write-Host "Body: $body"
            Write-Host "----------------------"
        }
    }
}
else {
    Write-Host "Failed to fetch emails from MailHog."
}
