function DME-RemoveMultiZones {

    param(
        [Parameter(Mandatory = $true)]
        [string]$apikey,
        [Parameter(Mandatory = $true)]
        [string]$secret,
        [Parameter(Mandatory = $false)]
        [int]$offset = 0,
        [Parameter(Mandatory = $false)]
        [ValidateSet('api.sandbox', 'api')]
        [string]$APIEnvironment = 'api.sandbox',
        [Parameter(Mandatory = $true)]
        $ids
    )

    $headers = DME-Headers -apikey $apikey -secret $secret -offset $offset

    $URI = "https://$APIEnvironment.dnsmadeeasy.com/V2.0/dns/managed/"

    try {

        $ids = $($ids | sort -Unique) -join ","
    
        $postParams = "[$ids]"

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $approve = read-host "Are you sure you want to DELETE?(type yes)"
    
        if ($approve -eq 'yes') {

            $response = Invoke-WebRequest -Method DELETE -Uri $URI -Headers $headers -ContentType "application/json" -Body $postParams
    
        }
    
        $status = $response.StatusDescription


        return "$ids Deleted"

    }

    catch {

        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        write-host -ForegroundColor Red "ERROR:" ($reader.ReadToEnd() | ConvertFrom-Json).error

    }

}
