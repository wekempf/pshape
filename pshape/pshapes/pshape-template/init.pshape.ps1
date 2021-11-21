[CmdletBinding()]
param (
    [PShapeTemplate]$PShape,
    [hashtable]$Context
)

if (-not $Context.ContainsKey('GUID')) {
    $Context.GUID = New-Guid
}

if (-not $Context.ContainsKey('author')) {
    $Context.author = $env:USERNAME
}

$Context.year = Get-Date | Select-Object -ExpandProperty Year
