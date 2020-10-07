function Set-SandboxMode {
    <#
        .SYNOPSIS
            Sets a global flag to determine if module commands should execute against the sandbox api or not
        .DESCRIPTION
            DNS Made Easy makes two different implementations of the API available: The main API
            available at api.dnsmadeeasy.com and a "sandbox" available at api.sandbox.dnsmadeeasy.com.
            You can set the API that module commands will invoke by using this function which manipulate
            an internal variable called SandboxMode.

            When the Mode is set to "Production" the value of SandboxMode will be set to $false and all
            module commands will execute against the main API.

            When the Mode is set to "Sandbox" the value of SandboxMode is set to $true and all module
            commands will execute against the sandbox API.

            NOTE: The sandbox environment uses a different set of accounts and so the same set of credentials
            will NOTE work between the two environments.
        .PARAMETER Mode
            Specifies which environment you want the module commands to execute against.
    #>
    [CmdletBinding()]
    Param(
        [ValidateSet("Production", "Sandbox")]
        [string]$Mode = "Production"
    )

    switch ( $Mode ) {
        "Production" { $script:SandboxMode = $false }
        "Sandbox" { $script:SandboxMode = $true }
    }
}

Export-ModuleMember -Function Set-SandboxMode