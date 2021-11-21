Set-StrictMode -Version Latest

$moduleRoot = $PSScriptRoot
$pshapeDataFolder = Join-Path ([System.Environment]::GetFolderPath("LocalApplicationData")) 'PShape'

$public = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'public') '*.ps1') -Recurse
$private = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'private') '*.ps1') -Recurse
$classes = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'classes') '*.ps1') -Recurse

Write-Verbose "Loading ($moduleRoot)..."
($public + $private + $classes) |
    ForEach-Object {
        Write-Verbose "Loading $($_.FullName)"
        . $_.FullName
    }

Add-Type -Path $moduleRoot/bin/System.Threading.Tasks.Extensions.dll
Add-Type -Path $moduleRoot/bin/Stubble.Core.dll