function ExpandTemplate {
    param (
        [Parameter(ValueFromPipeLine=$True)]
        [string]$TemplateText,
        [hashtable]$Context
    )

    begin {
        $builder = [Stubble.Core.Builders.StubbleBuilder]::new().Build()
    }
    process {
        $builder.render($TemplateText, [hashtable]$Context)
    }
}
