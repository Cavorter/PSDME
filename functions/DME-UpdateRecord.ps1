function DME-UpdateRecord {

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
        $DomainID,
        [Parameter(Mandatory = $true)]
        $RecordID,
        [Parameter(Mandatory = $false)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [string]$Value,
        [Parameter(Mandatory = $false)]
        [ValidateSet('false', 'true')]
        [string]$Failover = 'false',
        [Parameter(Mandatory = $false)]
        [ValidateSet('False', 'True')]
        [string]$Monitor = 'False',
        [Parameter(Mandatory = $false)]
        [int]$mxLevel = 0,
        [Parameter(Mandatory = $false)]
        [int]$weight = 0,
        [Parameter(Mandatory = $false)]
        [int]$priority = 0,
        [Parameter(Mandatory = $false)]
        [int]$port = 0,
        [Parameter(Mandatory = $false)]
        [ValidateSet('A', 'AAAA', 'ANAME', 'CNAME', 'HTTPRED', 'MX', 'NS', 'PTR', 'SRV', 'TXT', 'SPF', 'SOA')]
        [string]$Type,
        [Parameter(Mandatory = $false)]
        [int]$TTL = 1800
    )

    $headers = DME-Headers -apikey $apikey -secret $secret -offset $offset

    $URI = "https://$APIEnvironment.dnsmadeeasy.com/V2.0/dns/managed/$DomainID/records/$RecordID"

    try {

        $postParams = @{name = $Name; type = $Type; value = $Value; ttl = $TTL; gtdLocation = 'DEFAULT'; weight = $weight; failover = $failover; mxLevel = $mxLevel; port = $port; priority = $priority; id = $RecordID; } | ConvertTo-Json

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-WebRequest -Method PUT -Uri $URI -Headers $headers -ContentType "application/json" -Body $postParams

        if ($response.StatusDescription -eq 'OK') {

            return "Updated"

        }

    }

    catch {
        
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        write-host -ForegroundColor Red "ERROR:" ($reader.ReadToEnd() | ConvertFrom-Json).error

    }

}
