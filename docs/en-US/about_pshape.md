# PShape
## about_PShape

# SHORT DESCRIPTION

PShape is a modern PowerShell based templating and scaffolding engine using Moustache (https://mustache.github.io/mustache.5.html) templates.

# LONG DESCRIPTION

PShape is a modern PowerShell templating and scaffolding engine designed to be easy to use and easy to author templates for. When scaffolding with New-PShape you use a template's name and dynamic parameters with tab completion for template parameters. Authoring is simple with a slim manifest file, authored in JSON, with useful default behavior. The template files are authored using Moustache a very simple "logic-less" templating syntax. Packaging templates is as simple as creating a PowerShell module (a PShape template exists for that!) with a 'PShapes' directory and sharing is as easy as publishing that module to the PowerShell Gallery.

## Default Template Values

PShape templates can specify default values (or may generate them at run time) for template parameters. In addition the user can specify default values to use for a template by using the Set-PShapeDefaultValue cmdlet.

# EXAMPLES

## Scaffolding

```PowerShell
PS> New-PShape pshape-template -TemplateName mytemplate
```

Scaffolds (generate files) using the 'pshape-template' template, providing the 'TemplateName' template parameter.

# NOTE

The New-PShape cmdlet uses dynamic PowerShell parameters for passing template parameters. PowerShell dynamic parameters provide limited tab completion to aid in the discovery and input of these template parameters. However, it's recommended that you use Get-PShapeTemplate to view the full list of parameter information.

# SEE ALSO

- Get-PShapeTemplate
- New-PShape
- Set-PShapeDefaultValue
- https://github.com/wekempf/pshape

# KEYWORDS

- PShape
- template
- scaffold
