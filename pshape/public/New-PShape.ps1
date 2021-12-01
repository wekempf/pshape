function New-PShape {
    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess=$True)]
    param (
        [Parameter(ParameterSetName='Name', Position=0, Mandatory=$True)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            Get-PShapeTemplate | Select-Object -ExpandProperty Name | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string]$Name,

        [Parameter(ParameterSetName='Path', Mandatory=$True, ValueFromPipelineByPropertyName=$True)]
        [string]$Path,

        [Parameter(Position=1, Mandatory=$False)]
        [string]$Destination = '.',

        [switch]$Force
    )

    DynamicParam {
        if ($PSBoundParameters.ContainsKey('Name')) {
            GetDynamicParameters (Get-PShapeTemplate -Name $Name -ErrorAction Stop)
        }
        elseif ($PSBoundParameters.ContainsKey('Path')) {
            GetDynamicParameters (Get-PShapeTempalte -Path $Path -ErrorAction Stop)
        }
    }

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
        $InputObject = @{}
        foreach ($param in $PShape.Parameters) {
            if ($PSBoundParameters.ContainsKey($param.Name)) {
                $InputObject[$param.Name] = $PSBoundParameters[$param.Name]
            }
            elseif ($param.DefaultValue) {
                $InputObject[$param.Name] = $param.DefaultValue
            }
        }

        $initScript = Join-Path $templateRoot 'init.pshape.ps1'
        $validateScript = Join-Path $templateRoot 'validate.pshape.ps1'
        $finalizeScript = Join-Path $templateRoot 'finalize.pshape.ps1'

        if (Test-Path $initScript) {
            & $initScript $PShape $InputObject
        }

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
