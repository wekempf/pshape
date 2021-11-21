function SaveSettings {
    [CmdletBinding()]
    param (
        [hashtable]$Settings
    )
    $path = Join-Path $pshapeDataFolder 'pshape/settings.json'
    New-Item -Path $path -ItemType File -Force | Out-Null
    Set-Content -Path $path -Value ($Settings | ConvertTo-Json)
}