{{#Advanced}}
[CmdletBinding()]
{{/Advanced}}
param (
    [Parameter(Position=0, Mandatory=$False)]
    [string]$Name = 'World'
)

{{#Advanced}}
begin {

}

process {
    Write-Output "Hello $Name!"
}

end {

}
{{/Advanced}}
{{^Advanced}}
Write-Output "Hello $Name!"
{{/Advanced}}

