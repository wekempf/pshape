BeforeAll {
    . (Join-Path $PSScriptRoot ModuleImport.helper.ps1)
}

Describe "Module Manifest" {
    Context "Manifest Tests" {
        It 'Has a valid manifest' {
            { $script:Manifest = Test-ModuleManifest $script:ModuleManifest -ErrorAction Stop -WarningAction SilentlyContinue } |
                Should -Not -Throw
        }
        It 'Has a valid manifest name' {
            $script:Manifest.Name | Should -Be $ModuleName
        }
        It 'Has a valid manifest version' {
            $script:Manifest.Version -as [Version] | Should -Not -BeNullOrEmpty
        }
        It 'Has a valid manifest description' {
            $script:Manifest.Description | Should -Not -BeNullOrEmpty
        }
        It 'Has a valid manifest GUID' {
            $script:Manifest.Guid -as [Guid] | SHould -Not -BeNullOrEmpty
        }
        It 'Has a valid manifest root module' {
            $script:Manifest.RootModule | Should -Be "$ModuleName.psm1"
        }
    }
}
