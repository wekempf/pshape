param(
    [Parameter(Position=0)]
    [ValidateSet('?', '.')] # add defined tasks
    [string[]]$Tasks
)

Set-StrictMode -Version Latest

. .bootstrap.ps1

Use-Module InvokeBuild # -RequiredVersion x.x.x

# call the build engine with this script and return
if ($MyInvocation.ScriptName -notlike '*Invoke-Build.ps1') {
    Invoke-Build $Tasks $MyInvocation.MyCommand.Path @PSBoundParameters
    return
}

# use required dependencies
# Use-Module <name>
# Use-Script <name>
# Use-Package <name>

# declare variables and tasks

# modules referenced by Use-Module above that include an InvokeBuildTasks directory
# containing PS1 files that define tasks are aliased and can be "dot sourced"
# . somecool.task # somecool.task.ps1 in a module

task . { Write-Output 'Example task' }
