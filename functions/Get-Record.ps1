function Get-Record {
    <#
        .SYNOPSIS
            Gets one or more records from the specified zone.
        .PARAMETER Zone
            A DMEZone object of the zone to retrieve records from.
        .PARAMETER ZoneId
            The numeric ID of the zone to retrieve records from.
        .PARAMETER Credential
            A PSCredential object with the username set to the account API-Key and password set to the account Secret.
        .PARAMETER Id
            The id of one or more zones to retrieve.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$ZoneId,

        [pscredential]$Credential,

        [ValidateSet("A", "AAAA", "ANAME", "CNAME", "HTTPRED", "MX", "NS", "PTR", "SRV", "TXT", "SPF", "SOA")]
        [string]$Type,

        [string]$Name
    )

    Begin {
        if ( $Zone ) {
            $ZoneId = $Zone.id
        }
        
        $uriParts = @( ( Get-UriRoot ) , "dns/managed" , $ZoneId , "records" )
        if ( $Id ) { $uriParts += $Id }
        $uri = $uriParts -join '/'

        if ( $Type -or $Name ) {
            $queryParts = @()
            if ( $Type ) {
                $queryParts += "type=$Type"
            }
            if ( $Name ) {
                $nameLower = $Name.ToLower()
                $queryParts += "recordName=$nameLower"
            }
            $uri += "?" + ( $queryParts -join '&' )
        }
        Write-Verbose "Uri: $uri"
    }

    Process {
        $headers = New-Header -Credential $Credential -Offset 0

        $response = Invoke-RestMethod -Uri $uri -Headers $headers -ContentType "application/json"
        Write-Output $response.data
    }
}

Export-ModuleMember -Function Get-Record
