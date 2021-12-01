[CmdletBinding()]
param (
    [PShapeTemplate]$PShape,
    [hashtable]$Context,
    [string]$Destination
)

@('public', 'private', 'types', 'tests') |
    ForEach-Object {
        New-Item -Path (Join-Path (Join-Path $Destination $Context.ModuleName) $_) -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    }
