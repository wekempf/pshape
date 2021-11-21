param(
    [Parameter(Position=0)]
    [ValidateSet('?', '.', 'clean', 'build', 'analyze', 'unit-test', 'update-docs', 'shell')]
    [string[]]$Tasks
)

Set-StrictMode -Version Latest

. .bootstrap.ps1

Use-Module InvokeBuild -RequiredVersion 5.8.4

# call the build engine with this script and return
if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1') {
    Invoke-Build $Tasks $MyInvocation.MyCommand.Path @PSBoundParameters
    return
}

Use-Package GitVersion.CommandLine -RequiredVersion 5.7.0
Use-Module PSScriptAnalyzer -RequiredVersion 1.20.0
Use-Module Pester -RequiredVersion 5.3.1
Use-Module platyPS -RequiredVersion 0.14.2

$moduleName = 'pshape'
$buildOutput = Join-Path $BuildRoot '.build'
$moduleSourcePath = Join-Path $BuildRoot $moduleName
$modulePath = Join-Path $buildOutput $moduleName
$testPath = Join-Path $modulePath tests
$docsPath = Join-Path $BuildRoot docs
$docLanguages = @('en-US')

task clean {
    remove $buildOutput
}

task build clean, {
    Copy-Item -Path $moduleSourcePath -Destination $modulePath -Recurse
    if (Test-Path $docsPath) {
        $docLanguages | ForEach-Object {
            $source = Join-Path $docsPath $_
            $destination = Join-Path $modulePath $_
            New-ExternalHelp -Path $source -OutputPath $destination | Out-Null
        }
    }
}

task shell build, {
    Write-Host "Entering subshell with module loaded. Type 'exit' to return to parent shell."
    $module = Resolve-Path "$modulePath/$moduleName.psd1"
    pwsh -NoExit -Command "Import-Module $module"
    Write-Host "Subshell exited."
}

task analyze build, {
    $records = Invoke-ScriptAnalyzer -Path $modulePath |
        Where-Object { $_.ScriptName -ne 'build.ps1' }
    $records
    if ($records) {
        throw "Script analysis failures"
    }
}

task unit-test build, {
    if (Test-Path $testPath) {
        $testResults = Invoke-Pester -Path $testPath -PassThru -Output Detailed
        assert ($testResults.FailedCount -eq 0) 'One or more tests failed'
    }
}

task update-docs build, {
    Add-Path -Path $buildOutput -Name 'env:PSModulePath' -Front
    Import-Module $moduleName -Force
    if (Test-Path $docsPath) {
        $docLanguages | ForEach-Object {
            $parameters = @{
                Path = Join-Path $docsPath $_
                RefreshModulePage = $true
                AlphabeticParamsOrder = $true
                UpdateInputOutput = $true
                ExcludeDontShow = $true
                LogPath = $buildOutput
                Encoding = [System.Text.Encoding]::UTF8
            }
            Update-MarkdownHelpModule @parameters
        }
    } else {
        $docLanguages | ForEach-Object {
            $parameters = @{
                Module = $moduleName
                OutputFolder = Join-Path $docsPath $_
                AlphabeticParamsOrder = $true
                WithModulePage = $true
                ExcludeDontShow = $true
                Encoding = [System.Text.Encoding]::UTF8
            }
            New-MarkdownHelp @parameters | Out-Null
            New-MarkdownAboutHelp -OutputFolder (Join-Path $docsPath $_) -AboutName "topic_name" | Out-Null
        }
    }
}

task . analyze, unit-test
