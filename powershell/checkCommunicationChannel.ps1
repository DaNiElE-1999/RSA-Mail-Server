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
    Copy-Item ./getPublicKey.ps1 $channel
    & ./$channel/getPublicKey.ps1 -from $to

    Copy-Item ./getPublicKey.ps1 $recieverChannel
    & ./$recieverChannel/getPublicKey.ps1 -from $from

}
else {
    Write-Host "Channel $from - $channel already exists."
}