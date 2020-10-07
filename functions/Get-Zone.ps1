function Get-Zone {
    <#
        .SYNOPSIS
            Get one or more zones from DNS Made Easy.
        .PARAMETER Credential
            A PSCredential object with the username set to the account API-Key and password set to the account Secret.
    #>
    [CmdletBinding()]
    [OutputType([DMEZone[]])]
    param(
        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,

        [Parameter(Mandatory = $false)]
        [string]$ID
    )

    Begin {
        $uriPrefix = Get-UriRoot
        $uri = $uriPrefix, "dns/managed/$ID" -join '/'
        Write-Verbose "Uri: $uri"
    }

    Process {
        $headers = New-Header -Credential $Credential -Offset 0

        $response = Invoke-RestMethod -Uri $uri -Headers $headers -ContentType "application/json"
        foreach ( $obj in $response.data ) {
            [DMEZone]$result = $obj
            $result | Write-Output
        }
    }
}

Export-ModuleMember -Function Get-Zone