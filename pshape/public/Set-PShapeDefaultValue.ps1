function Set-PShapeDefaultValue {
    [CmdletBinding(DefaultParameterSetName='Name', SupportsShouldProcess)]
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

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $PShape = Get-PShapeTemplate -Name $Name -ErrorAction Stop
        }
        else {
            $PShape = Get-PShapeTemplate -Path $Path -ErrorAction Stop
        }
    }
    process {
        $parameter = $PShape.Parameters | Where-Object { $ParameterName -contains $_.Name }
        if ($parameter -and $PSCmdlet.ShouldProcess($ParameterName)) {
            $settings = ReadSettings
            $pshapeSettings = $Settings[$PShape.GUID] ?? @{}
            $pshapeSettings[$ParameterName] = $Value
            $Settings[$PShape.GUID] = $pshapeSettings
            SaveSettings $settings
        }
        else {
            throw "'$($PShape.Name)' does not have a parameter '$ParameterName'."
        }
    }
}
