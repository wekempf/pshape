[CmdletBinding()]
param (
    [Parameter(Position=0, Mandatory=$False)]
    $Name = 'World'
)

Set-StrictMode -Version Latest

Write-Host "Hello, $Name!"