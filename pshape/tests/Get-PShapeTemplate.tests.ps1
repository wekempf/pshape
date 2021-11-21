BeforeAll {
    Write-Host 'Import'
    Write-Host 'Next'
    Write-Host "$PSScriptRoot"
    Write-Host 'xyzzy'
    Import-Module $PSScriptRoot/../pshape.psd1
    Write-Host 'Imported'
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

        It "Finds module included templates" {
            $expected = @('pshape-template', 'script') | Sort-Object

            $actual = Get-PShapeTemplate -Verbose | Select-Object -ExpandProperty Name | Sort-Object

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

        It "Finds all templates" {
            $expected = @('pshape-template', 'script', 'example') | Sort-Object

            $actual = Get-PShapeTemplate -Verbose | Select-Object -ExpandProperty Name | Sort-Object

            $actual | Should -Be $expected
        }
    }
}