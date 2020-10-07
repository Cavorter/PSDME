function DME-AddMultiZones {

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
        $domains
    )

    $headers = DME-Headers -apikey $apikey -secret $secret -offset $offset

    $URI = "https://$APIEnvironment.dnsmadeeasy.com/V2.0/dns/managed/"

    try {

        $postParams = @{names = $domains } | ConvertTo-Json

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-WebRequest -Method POST -Uri $URI -Headers $headers -ContentType "application/json" -Body $postParams

        $object = $response.content | ConvertFrom-Json
    
        $status = $response.StatusDescription

        $objects = @()

        foreach ($obj in $object) {

            $zone_info = New-Object -TypeName psobject
            $zone_info | Add-Member -MemberType NoteProperty -Name Status -Value $status
            $zone_info | Add-Member -MemberType NoteProperty -Name ID -Value $obj
            
            $objects += $zone_info

        }
        return $objects

    }

    catch {

        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        write-host -ForegroundColor Red "ERROR:" ($reader.ReadToEnd() | ConvertFrom-Json).error

    }

}
