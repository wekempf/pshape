Set-StrictMode -Version Latest

$moduleRoot = $PSScriptRoot

# The 'public' directory should contain '*.ps1' files that define functions to be exported
$public = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'public') '*.ps1') -Recurse

# The 'private' directory should contain '*.ps1' files that define functions to be used internally
$private = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'private') '*.ps1') -Recurse

# The 'types' directory should contain '*.ps1' files that define types (classes/enums)
$types = Get-ChildItem -Path (Join-Path (Join-Path $moduleRoot 'types') '*.ps1') -Recurse

Write-Verbose "Loading ($moduleRoot)..."
($public + $private + $types) |
    ForEach-Object {
        Write-Verbose "Loading $($_.FullName)"
        . $_.FullName
    }
