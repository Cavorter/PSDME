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
        $uriPrefix = Get-UriRoot
        $uri = $uriPrefix, "dns/managed/$ID" -join '/'
        Write-Verbose "Uri: $uri"
    }

    Process {
        $headers = New-Header -Credential $Credential -Offset 0

        $response = Invoke-RestMethod -Uri $uri -Headers $headers -ContentType "application/json"
        Write-Output $response.data
    }
}

Export-ModuleMember -Function Get-Zone