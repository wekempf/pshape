$script:ModuleRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$script:ModuleName = Split-Path $script:ModuleRoot -Leaf
$script:ModuleManifest = Join-Path $script:ModuleRoot "$($script:ModuleName).psd1"
Import-Module $script:ModuleManifest
