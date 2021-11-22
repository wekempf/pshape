function Get-PShapeTemplate {
    [CmdletBinding(DefaultParameterSetName="Name")]
    param (
        [Parameter(Position=0, Mandatory=$False, ParameterSetName='Name')]
        [string[]]$Name,

        [Parameter(Mandatory=$True, ParameterSetName='Path')]
        [string[]]$Path,

        [switch]$AllVersions
    )

    begin {
    }

    process {
        $settings = ReadSettings
        if ($PSCmdlet.ParameterSetName -eq "Name") {
            ($env:PShapePath -split ';') + @(Join-Path $moduleRoot pshapes) |
                Where-Object { Test-Path $_ -PathType Container } |
                ForEach-Object {
                    Get-ChildItem -Path (Join-Path $_ '*/*.pshape.psd1') -ErrorAction SilentlyContinue |
                        ForEach-Object { [PShapeTemplate]::new($_, $settings) } |
                        Group-Object -Property Name |
                        Where-Object { (-not $Name) -or ($Name -contains $_.Name) } |
                        Sort-Object -Property $Name |
                        ForEach-Object {
                            $ordered = $_.Group | Sort-Object { [Version]$_.Version } -Descending
                            if ($allVersions) {
                                $ordered
                            } else {
                                $ordered | Select-Object -First 1
                            }
                        }
                }
        }
        else {
            $Path = Resolve-Path $Path -ErrorAction Stop
            if (-not $Path.EndsWith('.pshape.psd1')) {
                throw "$Path does not appear to be a PShape template manifest"
            }
            [PShapeTemplate]::new($Path)
        }
    }
}
