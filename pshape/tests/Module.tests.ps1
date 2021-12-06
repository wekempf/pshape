BeforeAll {
    . $PSScriptRoot/BeforeAll.ps1
}

Describe "Module Tests" {
    Context "Manifest" {
        BeforeAll {
            $script:Manifest = Import-PowerShellDataFile $script:ModuleManifest
        }
        It 'should be a valid manifest' {
            { Test-ModuleManifest $script:ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue } |
                Should -Not -Throw
        }
        It 'should have a valid version' {
            $script:Manifest.ModuleVersion -as [Version] | Should -Not -BeNullOrEmpty
        }
        It 'should have a valid description' {
            $script:Manifest.Description | Should -Not -BeNullOrEmpty
        }
        It 'should have a valid GUID' {
            $script:Manifest.Guid -as [Guid] | Should -Not -BeNullOrEmpty
        }
        It 'should have a valid root module' {
            $script:Manifest.RootModule | Should -Be "$($script:ModuleManifest.BaseName).psm1"
        }
        It 'should have a valid author' {
            $script:Manifest.Author | Should -Not -BeNullOrEmpty
        }
        It 'should have a valid license URI' {
            $script:Manifest.PrivateData.PSData.LicenseUri | Should -Not -BeNullOrEmpty
        }
        It 'should have a copyright with this year' {
            $year = Get-Date | Select-Object -ExpandProperty Year
            $script:Manifest.Copyright.Contains("$year") | Should -BeTrue
        }
        It 'should have expected formats to process' {
            $expected = Get-ChildItem $PSScriptRoot/../*.format.ps1xml
            if ($expected) {
                $actual = @($script:Manifest.FormatsToProcess)
                $actual | Should -Not -BeNullOrEmpty
                Compare-Object $actual $expected | Should -Not -BeNullOrEmpty
            }
            else {
                $script:Manifest.FormatsToProcess | Should -BeNullOrEmpty
            }
        }
        It 'should have expected functions to export' {
            $expected = Get-ChildItem $PSScriptRoot/../public/*.ps1
            if ($expected) {
                $actual = @($script:Manifest.FunctionsToExport)
                $actual | Should -Not -BeNullOrEmpty
                Compare-Object $actual $expected | Should -Not -BeNullOrEmpty
            }
            else {
                $script:Manifest.FunctionsToExport | Should -BeNullOrEmpty
            }
        }
        It 'should have expected types to process' {
            $expected = Get-ChildItem $PSScriptRoot/../*.ps1xml -Exclude '*.format.ps1xml'
            if ($expected) {
                $actual = @($script:Manifest.TypesToProcess)
                $actual | Should -Not -BeNullOrEmpty
                Compare-Object $actual $expected | Should -Not -BeNullOrEmpty
            }
            else {
                $script:Manifest.TypesToProcess | Should -BeNullOrEmpty
            }
        }
    }
}
