# Variables
$script:SandboxMode = $false

# Classes
$classes = Get-ChildItem -Path $PSScriptRoot\classes\*.ps1 -Exclude *.Tests.*
foreach ( $file in $classes ) {
    . $file.FullName
}

# Functions
$functions = Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -Exclude *.Tests.*
foreach ( $file in $functions ) {
    . $file.FullName
}