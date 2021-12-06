BeforeAll {
    . $PSScriptRoot/BeforeAll.ps1
}

Describe "Set-PShapeDefaultValue" {
    Context "When setting a default value" {
        BeforeEach {
            . $PSScriptRoot/Mock.Settings.ps1
        }
        It "should set the default retrieved by Get-PShapeTemplate when using template name" {
            Set-PShapeDefaultValue -Name pshape-template -ParameterName Author -Value 'Indiana Jones'
            $pshape = Get-PShapeTemplate -Name pshape-template
            $parameter = $pshape.Parameters | Where-Object { $_.Name -eq 'Author' } | Select-Object -First 1
            $parameter.DefaultValue | Should -Be 'Indiana Jones'
        }
        It "should set the default retrieved by Get-PShapeTemplate when using template path" {
            $path = Get-PShapeTemplate -Name pshape-template | Select-Object -ExpandProperty Path
            Set-PShapeDefaultValue -Path $path -ParameterName Author -Value 'Indiana Jones'
            $pshape = Get-PShapeTemplate -Name pshape-template
            $parameter = $pshape.Parameters | Where-Object { $_.Name -eq 'Author' } | Select-Object -First 1
            $parameter.DefaultValue | Should -Be 'Indiana Jones'
        }
        It "should throw when setting an uknown parameter's default value" {
            $act = { Set-PShapeDefaultValue -Name pshape-template -ParameterName Foo -Value 'Bar' }
            $act | Should -Throw
        }
    }
}
