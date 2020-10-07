function Set-Record {
    <#
        .SYNOPSIS
            Updates the properties of one or more records.
        .PARAMETER Record
            One or more objects that represent updates to existing records in DNS Made Easy. Each object must
            have the following properties:
                'sourceId'  : The ID for the zone the record is in.
                'id'        : The ID for the record to be updated.
                'name'      : The name property for the record.
                'ttl'       : The TTL property for the record.
            All other properties should be values that can be modified according to the DNS Made Easy API documentation.
        .PARAMETER Credential
            A PSCredential object with the username set to the account API-Key and password set to the account Secret.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,
    
        [Parameter(Mandatory = $true)]
        [object[]]$Record
    )
    
    Begin {
        $cmdList = @()

        foreach ( $zone in ( $Record.sourceId | Select-Object -Unique ) ) {
            $uriParts = @( ( Get-UriRoot ) , "dns/managed" , $zone , "records/updateMulti" )
            if ( $Id ) { $uriParts += $Id }
            $uri = $uriParts -join '/'

            $zoneRecords = $Record.Where({ $_.sourceId -eq $zone })
            $body = $zoneRecords | ConvertTo-Json -Compress
            if ( $zoneRecords.Count -lt 2 ) { $body = "[$body]"}

            $cmdList += @{
                Uri = $uri
                Body = $body
            }
        }
    }
    
    Process {
        foreach ( $item in $cmdList ) {
            Write-Verbose "Uri: $( $item.Uri )"
            Write-Verbose "Body: $( $item.Body )"
            $headers = New-Header -Credential $Credential -Offset 0
            $response = Invoke-RestMethod -Headers $headers -ContentType "application/json" -Method Put @item
            Write-Output $response
        }
    }
}
    
Export-ModuleMember -Function Set-Record
