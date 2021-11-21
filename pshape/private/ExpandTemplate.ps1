function ExpandTemplate {
    param (
        [Parameter(ValueFromPipeLine=$True)]
        [string]$TemplateText,
        [hashtable]$Context
    )
    
    $builder = [Stubble.Core.Builders.StubbleBuilder]::new().Build()
    return $builder.render($TemplateText, [hashtable]$Context)
}