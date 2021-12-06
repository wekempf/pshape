BeforeDiscovery {
    $script:rules = Get-ScriptAnalyzerRule
}
BeforeAll {
    . $PSScriptRoot/BeforeAll.ps1
}
Describe 'PSScriptAnalyzer' {
    BeforeAll {
        # Excluded rule justification
        #   PSProvideCommentHelp             - We use PlatyPS isntead of comment help
        #   PSAvoudUsingWriteHost            - We're an interactive script and use Write-Host for UX purposes
        #   PSAvoidUsingPositionalParameters - Named parameters for things like Join-Path are just too verbose
        #   PSReviewUnusedParameter          - Results are flakey (https://github.com/PowerShell/PSScriptAnalyzer/issues/1472)
        $script:results = Invoke-ScriptAnalyzer -Path (Join-Path (Split-Path $script:ModuleManifest) '*') `
            -ExcludeRule 'PSProvideCommentHelp','PSAvoidUsingWriteHost','PSAvoidUsingPositionalParameters','PSReviewUnusedParameter'
    }
    Context 'Analyzing Module' {
        BeforeEach {
            $script:rule = $_
        }
        It 'should pass the PSScriptAnalyzer rule <rule>' -ForEach $script:rules {
            if ($script:results.RuleName -contains $script:rule) {
                $failures = $script:results | Where-Object { $_.RuleName -eq $script:rule }
                $failures | Select-Object -Property ScriptName,Line,Message | Out-Default
                $failures.Count | Should -Be 0
            }
        }
    }
}
