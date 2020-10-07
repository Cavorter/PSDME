function DME-GetRecords {

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
        $DomainID
    )

    $headers = DME-Headers -apikey $apikey -secret $secret -offset $offset

    $URI = "https://$APIEnvironment.dnsmadeeasy.com/V2.0/dns/managed/$DomainID/records"

    try {

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-WebRequest -Method GET -Uri $URI -Headers $headers -ContentType "application/json"

        $object = $response.content | ConvertFrom-Json

        return $object.data

    }

    catch {
        

        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        write-host -ForegroundColor Red "ERROR:" ($reader.ReadToEnd() | ConvertFrom-Json).error

    }

}
