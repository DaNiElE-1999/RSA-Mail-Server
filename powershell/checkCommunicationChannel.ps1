param (
    [string]$to,
    [string]$from
)

# Output the provided string
Write-Host "Input string: $from"

#Check if user exists
$user = "..\users\$from"
if (-not (Test-Path $user -PathType Container)) {
    mkdir $user
}
else {
    Write-Host "User $user already exists."
}

#Check if channel exists
$channel = "..\users\$from\$to"
if (-not (Test-Path $channel -PathType Container)) {

    #Create channel of communication for sender
    mkdir $channel
    & ./generateKeys.ps1 -path $channel -to $to -from $from

    #Create channel of communication for the reciever
    $recieverChannel = "..\users\$to\$from"
    mkdir $recieverChannel
    & ./generateKeys.ps1 -path $recieverChannel -to $from -from $to

    #Get the keys  from other side and add them to the folder
    & ./getPublicKey.ps1 -from $to -path $channel
    & ./getPublicKey.ps1 -from $from -path $recieverChannel

    #Create mail directory
    mkdir ..\users\$from\$to\mails 
    mkdir ..\users\$to\$from\mails 

    Copy-Item "./readEmail.ps1" "../users/$from/readEmail.ps1"
    Copy-Item "./readEmail.ps1" "../users/$to/readEmail.ps1"

}
else {
    Write-Host "Channel $from - $to already exists."
}