function DME-Headers {

    param(
           [Parameter(Mandatory=$true)]
           [string]$apikey,
           [Parameter(Mandatory=$true)]
           [string]$secret,
           [Parameter(Mandatory=$false)]
           [int]$offset = 0
       )

   [string] $Date = (get-date -format R (get-date).AddHours(0-(Get-Date -UFormat "%Z")).AddMilliseconds(+$offset))
   $hmacsha = New-Object System.Security.Cryptography.HMACSHA1
   $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($Secret)
   $signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($Date))
   $hash = [string]::join("", ($signature | % {([int]$_).toString('x2')}))

   $headers = @{
   "x-dnsme-apiKey" = $apikey;
   "x-dnsme-requestDate" = $Date;
   "x-dnsme-hmac" = $hash 
   }
   return $headers
}
