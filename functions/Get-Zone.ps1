function Get-Zone {
    <#
        .SYNOPSIS
            Get one or more zones from DNS Made Easy.
        .PARAMETER Credential
            A PSCredential object with the username set to the account API-Key and password set to the account Secret.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,

        [Parameter(Mandatory = $false)]
        [string]$ID
    )

    Begin {
        $uriParts = @( ( Get-UriRoot ) , "dns/managed" )
        if ( $ID ) { $uriParts += $ID }
        $uri = $uriParts -join '/'
        Write-Verbose "Uri: $uri"
    }

    Process {
        $headers = New-Header -Credential $Credential -Offset 0

        $response = Invoke-RestMethod -Uri $uri -Headers $headers -ContentType "application/json"

        $result = $response
        if ( -not $ID ) { $result = $response.data }
        
        Write-Output $result
    }
}

Export-ModuleMember -Function Get-Zone