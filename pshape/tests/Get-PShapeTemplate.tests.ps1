BeforeAll {
    . $PSScriptRoot/BeforeAll.ps1
}

Describe "Get-PShapeTemplate" {
    Context "When env:PShapePath is not set" {
        BeforeAll {
            $script:OldPShapePath = Get-Item env:PShapePath -ErrorAction SilentlyContinue
            Remove-Item env:PShapePath -ErrorAction SilentlyContinue
        }
        AfterAll {
            if ($script:OldPShapePath) {
                Set-Item env:PShapePath $script:OldPShapePath
            }
        }

        It "should find module templates" {
            $pshapes = Join-Path (Get-Module PShape | Select-Object -ExpandProperty Path | Split-Path) PShapes
            $expected = Get-ChildItem $pshapes -Directory | Select-Object -ExpandProperty Name

            $actual = Get-PShapeTemplate |
                Where-Object { (Split-Path (Split-Path $_.Path)) -eq $pshapes } |
                Select-Object -ExpandProperty Name |
                Sort-Object

            $actual | Should -Be $expected
        }
    }

    Context "When env:PShapePath is set" {
        BeforeAll {
            $script:OldPShapePath = Get-Item env:PShapePath -ErrorAction SilentlyContinue
            Set-Item env:PShapePath TestDrive:\pshapes
            mkdir TestDrive:\pshapes
            mkdir TestDrive:\pshapes\example
            Set-Content TestDrive:\pshapes\example\example.pshape.psd1 @"
@{
    Version = '1.0.0'
    GUID = 'c4ea1f9c-e7ef-4a49-a6d2-14947f6c6013'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '(c) William E. Kempf. All rights reserved.'
    Description = 'Example template.'
}
"@
        }
        AfterAll {
            if ($script:OldPShapePath) {
                Set-Item env:PShapePath $script:OldPShapePath
            }
        }

        It "should finds templates on path" {
            $expected = @('example')

            $actual = Get-PShapeTemplate |
                Where-Object { $_.Path.StartsWith("$TestDrive") } |
                Select-Object -ExpandProperty Name

            Compare-Object $actual $expected | Should -BeNullOrEmpty
        }
    }

    Context "When default value is set" {
        BeforeEach {
            $guid = Get-PShapeTemplate -Name module | Select-Object -ExpandProperty GUID
            $name = 'CompanyName'
            $expected = 'xyzzy'
            Mock -ModuleName PShape ReadSettings {
                return @{
                    $guid = @{
                        $name = $expected
                    }
                }
            }
        }

        It "should get settings default value" {
            $template = Get-PShapeTemplate -Name module
            $parameter = $template.Parameters | Where-Object { $_.Name -eq $name } | Select-Object -First 1
            $parameter.DefaultValue | Should -Be $expected
        }
    }

    Context 'When default value is not set' {
        BeforeEach {
            Mock -ModuleName PShape ReadSettings { return @{} }
        }

        It 'should get template default value' {
            $template = Get-PShapeTemplate -Name module
            $parameter = $template.Parameters | Where-Object { $_.Name -eq 'CompanyName' } | Select-Object -First 1
            $parameter.DefaultValue | Should -Be 'Unknown'
        }
    }
}
