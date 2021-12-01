[CmdletBinding()]
param (
    [PShapeTemplate]$PShape,
    [hashtable]$Context
)

# Add code to initialize default values. Remove this file if it's not needed!!

$generatedDate = Get-Date
$Context.GeneratedDate = '{0:d}' -f $generatedDate
$Context.Year = $generatedDate.Year
$Context.GUID = New-Guid | Select-Object -ExpandProperty Guid
if ($Context.ContainsKey('CompatiblePSEditions')) {
    $Context.CompatiblePSEditions = ($Context.CompatiblePSEditions | ForEach-Object { "'$_'" }) -join ', '
}
if ($Context.ContainsKey('Author')) {
    $Context.Author = $Context.Author -join ', '
}
else {
    $Context.Author = $env:USERNAME
}
if ($Context.ContainsKey('RequiredModules')) {
    $Context.RequiredModules = ($Context.RequiredModules | ForEach-Object { "'$_'" }) -join ', '
}
if ($Context.ContainsKey('RequiredAssemblies')) {
    $Context.RequiredAssemblies = ($Context.RequiredAssemblies | ForEach-Object { "'$_'" }) -join ', '
}
if ($Context.ContainsKey('Tags')) {
    $Context.Tags = ($Context.Tags | ForEach-Object { "'$_'" }) -join ', '
}
