function Get-SandboxMode {
    <#
        .SYNOPSIS
            Returns the current sandbox mode setting.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    Param()

    Process {
        switch ( $script:SandboxMode ) {
            $false { Write-Output "Production" }
            $true { Write-Output "Sandbox" }
        }
    }
}

Export-ModuleMember -Function Get-SandboxMode