BeforeAll {
    . $PSScriptRoot/BeforeAll.ps1
}

Describe "New-PShape" {
    Context "When creating a script" {
        BeforeEach {
            Push-Location $TestDrive
        }
        AfterEach {
            Pop-Location
            Get-ChildItem (Join-Path $TestDrive '*') | Remove-Item -Recurse -Force
        }
        It "should create a script file with proper name" {
            New-PShape -Name script -ScriptName foo -InformationAction Ignore
            Join-Path $TestDrive foo.ps1 | Should -Exist
        }
        It "should create a simple script" {
            New-PShape -Name script -ScriptName foo -InformationAction Ignore
            $filePath = Join-Path $TestDrive foo.ps1
            Get-Content $filePath | Select-String '\[CmdletBinding\(.*\)\]' | Should -BeNullOrEmpty
        }
        It "should create advanced script" {
            New-PShape -Name script -ScriptName foo -Advanced -InformationAction Ignore
            $filePath = Join-Path $TestDrive foo.ps1
            Get-Content $filePath | Select-String '\[CmdletBinding\(.*\)\]' | Should -Not -BeNullOrEmpty
        }
    }
    Context "When creating a function" {
        BeforeEach {
            Push-Location $TestDrive
        }
        AfterEach {
            Pop-Location
            Get-ChildItem (Join-Path $TestDrive '*') | Remove-Item -Recurse -Force
        }
        It "should create a script function file with proper name" {
            New-PShape -Name function -FunctionName foo -InformationAction Ignore
            Join-Path $TestDrive foo.ps1 | Should -Exist
        }
        It "should create a simple function" {
            New-PShape -Name function -FunctionName foo -InformationAction Ignore
            $filePath = Join-Path $TestDrive foo.ps1
            Get-Content $filePath | Select-String '\[CmdletBinding\(.*\)\]' | Should -BeNullOrEmpty
        }
        It "should create advanced function" {
            New-PShape -Name function -FunctionName foo -Advanced -InformationAction Ignore
            $filePath = Join-Path $TestDrive foo.ps1
            Get-Content $filePath | Select-String '\[CmdletBinding\(.*\)\]' | Should -Not -BeNullOrEmpty
        }
    }
    Context "When creating a pshape-template" {
        BeforeEach {
            Push-Location $TestDrive
            Mock -ModuleName PShape ReadSettings { return @{} }
        }
        AfterEach {
            Pop-Location
            Get-ChildItem (Join-Path $TestDrive '*') | Remove-Item -Recurse -Force
        }
        It "should create a template directory with expected files" {
            New-PShape -Name pshape-template -TemplateName foo -InformationAction Ignore
            Join-Path $TestDrive foo | Should -Exist
            Join-Path $TestDrive foo foo.pshape.psd1 | Should -Exist
            Join-Path $TestDrive foo init.pshape.ps1 | Should -Exist
            Join-Path $TestDrive foo validate.pshape.ps1 | Should -Exist
            Join-Path $TestDrive foo finalize.pshape.ps1 | Should -Exist
        }
        It "should create a manifest with default author" {
            New-PShape -Name pshape-template -TemplateName foo -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.Author | Should -Be $env:USERNAME
        }
        It "should create a manifest with specified author" {
            New-PShape -Name pshape-template -TemplateName foo -Author 'Indiana Jones' -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.Author | Should -Be 'Indiana Jones'
        }
        It 'should create a manifest with a GUID' {
            New-PShape -Name pshape-template -TemplateName foo -Author 'Indiana Jones' -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.GUID | Should -not -BeNullOrEmpty
        }
        It 'should create a manifest with a copyright with the current year' {
            $year = (Get-Date).Year
            New-PShape -Name pshape-template -TemplateName foo -Author 'Indiana Jones' -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.Copyright | Should -BeLike "* $year *"
        }
        It 'should create a manifest with a default descrption' {
            New-PShape -Name pshape-template -TemplateName foo -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.Description | Should -Be 'PShape Template description'
        }
        It 'should create a manifest with the specified descrption' {
            New-PShape -Name pshape-template -TemplateName foo -Description "xyzzy" -InformationAction Ignore
            $manifest = Import-PowerShellDataFile (Join-Path $TestDrive foo foo.pshape.psd1)
            $manifest.Description | Should -Be 'xyzzy'
        }
    }
}
