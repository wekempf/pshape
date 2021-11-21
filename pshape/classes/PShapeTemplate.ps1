class PShapeTemplate
{
    PShapeTemplate([string]$Path, [Hashtable]$Settings) {
        $this.Path = Resolve-Path $Path
        $this.Name = [IO.Path]::GetFileNameWithoutExtension([IO.Path]::GetFileNameWithoutExtension($Path))
        $data = Import-PowerShellDataFile -Path $Path
        $this.GUID = $data.GUID
        $this.Version = $data.Version
        $this.Author = $data.Author
        $this.CompanyName = $data.CompanyName
        $this.Copyright = $data.Copyright
        $this.Description = $data.Description
        if ($data.ContainsKey('Parameters')) {
            $pshapeSettings = $Settings.ContainsKey($data.GUID.ToString()) ? $Settings[$data.GUID.ToString()] : @{}
            $this.Parameters = $data.Parameters | ForEach-Object { [PShapeParameter]::new($_, $pshapeSettings) }
        }

        $templateRoot = Split-Path $this.Path
        Push-Location $templateRoot
        try {
            if ($data.ContainsKey('Files')) {
                $tempFiles = $data.Files | ForEach-Object { [PShapeFile]::new($_) }
            }
            else {
                $tempFiles = @()
            }

            $included = [System.Collections.Generic.HashSet[string]](
                [string[]]@($tempFiles | Select-Object -ExpandProperty Path) + @(
                    (Join-Path $templateRoot "$($this.Name).pshape.psd1")
                    (Join-Path $templateRoot 'init.pshape.ps1')
                    (Join-Path $templateRoot 'validate.pshape.ps1')
                    (Join-Path $templateRoot 'finalize.pshape.ps1')
                )
            )
            $implicitFiles = Get-ChildItem -Path (Split-Path $this.Path) -File -Recurse |
                Where-Object { -not $included.Contains($_) } |
                ForEach-Object { [PShapeFile]::new($_.FullName) }

            $this.Files = @($tempFiles) + $implicitFiles | Sort-Object -Property Path
        }
        finally {
            Pop-Location
        }
    }

    [string]$Name
    [string]$Path
    [guid]$GUID
    [version]$Version
    [string]$Author
    [string]$CompanyName
    [string]$Copyright
    [string]$Description
    [PShapeParameter[]]$Parameters
    [PShapeFile[]]$Files
}
