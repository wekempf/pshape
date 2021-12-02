param(
    [Parameter(Position=0)]
    [ValidateSet('?', '.', 'clean', 'build', 'analyze', 'test', 'update-docs', 'shell', 'version', 'publish')]
    [string[]]$Tasks,

    [string]$Repository,
    [string]$NuGetApiKey,

    [switch]$SkipBuild
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
$moduleManifest = Join-Path $modulePath "$moduleName.psd1"
$testPath = Join-Path $modulePath tests
$docsPath = Join-Path $BuildRoot docs
$docLanguages = @('en-US')

task clean {
    remove $buildOutput -ErrorAction SilentlyContinue
}

task version {
    $script:verInfo = gitversion | ConvertFrom-Json
    $ver = $script:verInfo.MajorMinorPatch
    if ($script:verInfo.PreReleaseTag) {
        $ver = "$ver-$($script:verInfo.PreReleaseTag -replace '\.','')"
    }
    Write-Build DarkGreen $ver
}

task build version, {
    Copy-Item -Path $moduleSourcePath -Destination $modulePath -Recurse -ErrorAction SilentlyContinue

    $manifestUpdates = @{
        'Path' = $moduleManifest
        'ModuleVersion' = $script:verInfo.MajorMinorPatch
    }
    $functionsToExport = Get-ChildItem (Join-Path $modulePath 'public' '*.ps1') |
        Select-Object -ExpandProperty BaseName
    if ($functionsToExport) {
        $manifestUpdates['FunctionsToExport'] = $functionsToExport
    }
    $typesToProcess = Get-ChildItem (Join-Path $modulePath '*.ps1xml') -Exclude '*.format.ps1xml' |
        Select-Object -ExpandProperty Name
    if ($typesToProcess) {
        $manifestUpdates['TypesToProcess'] = $typesToProcess
    }
    $formatsToProcess = Get-ChildItem (Join-Path $modulePath '*.format.ps1xml') |
        Select-Object -ExpandProperty Name
    if ($formatsToProcess) {
        $manifestUpdates['FormatsToProcess'] = $formatsToProcess
    }
    if ($script:verInfo.PreReleaseTag) {
        $manifestUpdates['Prerelease'] = $script:verInfo.PreReleaseTag -replace '\.',''
    }
    Update-ModuleManifest @manifestUpdates

    if (Test-Path $docsPath) {
        $docLanguages | ForEach-Object {
            $source = Join-Path $docsPath $_
            $destination = Join-Path $modulePath $_
            New-ExternalHelp -Path $source -OutputPath $destination -Force | Out-Null
        }
    }
}

task skippable-build -If { -not $SkipBuild } build

task shell build, {
    Write-Host "Entering subshell with module loaded. Type 'exit' to return to parent shell."
    $module = Resolve-Path "$modulePath/$moduleName.psd1"
    pwsh -NoExit -Command "Import-Module $module"
    Write-Host "Subshell exited."
}

task lint build, {
    $records = Invoke-ScriptAnalyzer -Path $modulePath |
        Where-Object { $_.ScriptName -ne 'build.ps1' }
    $records
    if ($records) {
        Write-Error "Script analysis failures"
    }
}

task test skippable-build, {
    Write-Output "testPath: $testPath"
    if (Test-Path $testPath) {
        $testResults = Invoke-Pester -Path $testPath -PassThru -Output Detailed
        assert ($testResults.FailedCount -eq 0) 'One or more tests failed'
    }
}

task update-docs build, {
    $module = Resolve-Path "$modulePath/$moduleName.psd1"
    Import-Module $module -Force
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
            New-MarkdownAboutHelp -OutputFolder (Join-Path $docsPath $_) -AboutName $moduleName | Out-Null
        }
    }
}

task publish skippable-build, {
    requires Repository

    $publishModuleArgs = @{
        'Path' = $modulePath
        'Repository' = $Repository
    }
    if ($NuGetApiKey) {
        $publishModuleArgs['NuGetApiKey'] = $NuGetApiKey
    }
    Publish-Module @publishModuleArgs
}

task . lint, unit-test
