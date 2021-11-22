function New-PShape {
    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess=$True)]
    param (
        [Parameter(ParameterSetName='Name', Position=0, Mandatory=$True)]
        [string]$Name,

        [Parameter(ParameterSetName='Path', Mandatory=$True, ValueFromPipelineByPropertyName=$True)]
        [string]$Path,

        [Parameter(ParameterSetName='Name', Position=1, Mandatory=$False)]
        [Parameter(ParameterSetName='Path', Position=1, Mandatory=$False)]
        [string]$Destination = '.',

        [Parameter(ParameterSetName='Name', Position=2, Mandatory=$False)]
        [Parameter(ParameterSetName='Path', Position=2, Mandatory=$False)]
        [hashtable]$InputObject = @{},

        [switch]$Force
    )

    begin {
        if ($Force) {
            $ConfirmImpact = 'None'
        }

        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $PShape = Get-PShapeTemplate -Name $Name -ErrorAction Stop
        }
        else {
            $PShape = Get-PShapeTempalte -Path $Path -ErrorAction Stop
        }

        $templateRoot = Split-Path $PShape.Path
        $Destination = [IO.Path]::GetFullPath($Destination, (Get-Location))
    }

    process {
        $initScript = Join-Path $templateRoot 'init.pshape.ps1'
        $validateScript = Join-Path $templateRoot 'validate.pshape.ps1'
        $finalizeScript = Join-Path $templateRoot 'finalize.pshape.ps1'

        if (Test-Path $initScript) {
            & $initScript $PShape $InputObject
        }

        Prompt $PShape $InputObject

        if (Test-Path $validateScript) {
            & $validateScript $PShape $InputObject
        }

        Push-Location $templateRoot
        try {
            $noToAll = $False
            $yesToAll = $False
            foreach ($file in $PShape.Files) {
                if ($file.Copy) {
                    $source = Resolve-Path $file.Path -Relative
                    $dest = [System.IO.Path]::GetFullPath((Join-Path $Destination (ExpandTemplate $source $InputObject)))
                    if ($PSCmdlet.ShouldProcess($dest)) {
                        $exists = Test-Path $dest
                        if ($exists -and (-not $noToAll)) {
                            Write-Warning "'$dest' already exists."
                        }
                        if ($Force -or (-not $exists) -or $PSCmdlet.ShouldContinue($dest, 'Generate file', [ref]$yesToAll, [ref]$noToAll)) {
                            Write-Host "Generating '$dest'..." -ForegroundColor Green
                            New-Item -Path (Split-Path $dest) -ItemType Directory -Force -Confirm:$False | Out-Null
                            if ($file.Process) {
                                Get-Content $source |
                                    Out-String |
                                    ExpandTemplate -Context $InputObject |
                                    Set-Content -Path $dest -Force -Confirm:$False
                            }
                            else {
                                Copy-Item $source $dest -Force
                            }
                        }
                    }
                }
            }
        } finally {
            Pop-Location
        }

        if (Test-Path $finalizeScript) {
            & $finalizeScript $PShape $InputObject $Destination
        }
    }

    end {

    }
}
