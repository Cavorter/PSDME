function New-Header {
    <#
        .SYNOPSIS
            Generates standard headers for interacting with the DNS Made Easy API
        .PARAMETER Credential
            A PSCredential object with the username set to the account API-Key and password set to the account Secret.
        .PARAMETER Offset
            Value in milliseconds to correct for time drift between the local system and the DNS Made Easy remotes.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,

        [Parameter(Mandatory = $false)]
        [int]$Offset = 0
    )

    # x-dnsme-requestDate
    [string]$date = Get-Date -Date (Get-Date).ToUniversalTime().AddMilliseconds( +$Offset ) -Format R

    # x-dnsme-hmac
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA1
    $hmacsha.key = [Text.Encoding]::ASCII.GetBytes( $Credential.GetNetworkCredential().Password )
    $signature = $hmacsha.ComputeHash( [Text.Encoding]::ASCII.GetBytes( $date ) )
    $hash = [string]::join("", ($signature.ForEach({ ([int]$_).toString('x2') })))

    $headers = @{
        "x-dnsme-apiKey"      = $Credential.UserName
        "x-dnsme-requestDate" = $date;
        "x-dnsme-hmac"        = $hash 
    }
    return $headers
}
