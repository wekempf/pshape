function Set-PShapeDefaultValue {
    [CmdletBinding(DefaultParameterSetName='Name')]
    param (
        [Parameter(ParameterSetName='Name', Position=0, Mandatory=$True)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            Get-PShapeTemplate | Select-Object -ExpandProperty Name | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string]$Name,

        [Parameter(ParameterSetName='Path', Mandatory=$True, ValueFromPipelineByPropertyName=$True)]
        [string]$Path,

        [Parameter(Position=1, Mandatory=$True)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            if ($fakeBoundParameters.ContainsKey('Name')) {
                $pshape = Get-PShapeTemplate -Name $fakeBoundParameters.Name
            }
            elseif ($fakeBoundParameters.ContainsKey('Path')) {
                $pshape = Get-PShapeTemplate -Path $fakeBoundParameters.Path
            }
            if ($pshape) {
                $pshape |
                    Select-Object -ExpandProperty Parameters |
                    Select-Object -ExpandProperty $Name |
                    Where-Object { $_ -like "$wordToComplete*" }
            }
        })]
        [string]$ParameterName,

        [Parameter(Position=2, Mandatory=$True)]
        [string]$Value
    )

    if ($PSCmdlet.ParameterSetName -eq 'Name') {
        $PShape = Get-PShapeTemplate -Name $Name -ErrorAction Stop
    }
    else {
        $PShape = Get-PShapeTempalte -Path $Path -ErrorAction Stop
    }

    $parameter = $PShape.Parameters | Where-Object { $ParameterName -contains $_.Name }
    if ($parameter) {
        $settings = ReadSettings
        if ($settings.ContainsKey($PShape.GUID.ToString())) {
            $pshapeSettings = $settings[$PShape.GUID.ToString()]
        }
        else {
            $pshapeSettings = @{}
            $settings[$PShape.GUID.ToString()] = $pshapeSettings
        }

        $pshapeSettings[$ParameterName] = $Value
        SaveSettings $settings
    }
    else {
        Write-Warning "'$($PShape.Name)' does not have a parameter '$ParameterName'."
    }
}
