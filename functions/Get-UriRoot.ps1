function Get-UriRoot {
    <#
        .SYNOPSIS
            Returns the initial portion of the DNS Made Easy api uri.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Process {
        $apiPart = "api"
        if ( $script:SandboxMode ) { $apiPart = $apiPart + ".sandbox" }
        $uri = "https://$apiPart.dnsmadeeasy.com/V2.0"

        Write-Output $uri
    }
}
