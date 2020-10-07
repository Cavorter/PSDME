function DME-SetFailover {

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
        $RecordID,
        [Parameter(Mandatory = $true)]
        [int]$port,
        [Parameter(Mandatory = $false)]
        [string]$failover = "true",
        [Parameter(Mandatory = $true)]
        [string]$ip1,
        [Parameter(Mandatory = $true)]
        [string]$ip2,
        [Parameter(Mandatory = $true)]
        [int]$protocolId,
        [Parameter(Mandatory = $false)]
        [string]$monitor,
        [Parameter(Mandatory = $false)]
        [string]$sensitivity = 5,
        [Parameter(Mandatory = $false)]
        [string]$systemDescription = "Default Description",
        [Parameter(Mandatory = $false)]
        [int]$maxEmails = 3,
        [Parameter(Mandatory = $false)]
        [string]$autoFailover,
        [Parameter(Mandatory = $false)]
        [string]$httpFqdn,
        [Parameter(Mandatory = $false)]
        [string]$httpFile,
        [Parameter(Mandatory = $false)]
        [string]$httpQueryString

    )

    $headers = DME-Headers -apikey $apikey -secret $secret -offset $offset

    $URI = "https://$APIEnvironment.dnsmadeeasy.com/V2.0/monitor/$RecordID"

    try {

        $postParams = @{port = $port; failover = $failover; ip1 = $ip1; ip2 = $ip2; protocolId = $protocolId; monitor = $monitor; sensitivity = $sensitivity; systemDescription = $systemDescription; maxEmails = $maxEmails; autoFailover = $autoFailover; httpFqdn = $httpFqdn; httpFile = $httpFile; httpQueryString = $httpQueryString; } | ConvertTo-Json

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

        $response = Invoke-WebRequest -Method PUT -Uri $URI -Headers $headers -ContentType "application/json" -Body $postParams

        $record = $response.content | ConvertFrom-Json  

        return "Updated"

    }

    catch {
        
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        write-host -ForegroundColor Red "ERROR:" ($reader.ReadToEnd() | ConvertFrom-Json).error

    }

}
