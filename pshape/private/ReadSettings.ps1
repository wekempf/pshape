function ReadSettings {
    $path = Join-Path $pshapeDataFolder 'pshape/settings.json'
    if (Test-Path $path) {
        $settings = Get-Content -Path $path | ConvertFrom-Json -AsHashtable
        Write-Verbose "Read settings from '$Path'."
        return $settings
    }
    Write-Verbose "Settings file '$path' does not exist"
    return @{}
}
