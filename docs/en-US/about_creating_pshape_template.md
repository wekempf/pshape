# PShape

## about_Creating_PShape_Template

# SHORT DESCRIPTION

How to use PShape to create new PShape templates.

# LONG DESCRIPTION

This tutorial shows you how to use PShape to create new PShape templates. We'll create a 'my-function' template that generates a script function, similar to the built-in 'function' template.

## Generate Template

We'll start by generating a bare template using PShape commands. In a PowerShell session ensure you've imported the PShape module and then Set-Location to a working directory.

To become familiar with PShape we'll first just get a list of the PShape templates currently on your machine.

```PowerShell
PS> Get-PShapeTemplate
```

PShape commands support rich tab completions making them easy to use. Get a specific template by typing "Get-PShapeTemplate " (use tab completion to type only part of that command and expand the rest) and then press [Ctrl+Space] to get a list of available template names and use the arrow keys to select "pshape-template" and press [Enter] to complete the command.

```PowerShell
PS> Get-PShapeTemplate pshape-template
```

Now that you know how to use tab completions use them to enter the following command.

```PowerShell
PS> New-PShape pshape-template -TemplateName my-function
```

This will generate a new PShape template in the directory "my-function". Currently this template won't generate anything, so let's add content to it.

## Add a Template File

PShape uses Moustache (https://mustache.github.io/mustache.5.html) templates, so we'll use Moustache syntax to create a function script template. We can even use Moustache replacements in the file names, so create a "{{FunctionName}}.ps1" in the "my-function" template directory. The "{{FunctionName}}" is Moustache syntax for replacement text and during template generation it will be replaced with the user supplied "FunctionName" value.

    [!Note] By default any file other than the manifest ("my-function.pshape.psd1" in this case) or one of the special script hook files ("finalize.pshape.ps1", "init.pshape.ps1" or "validate.pshape.ps1"... more on these later) is considered to be part of what the template will generate. It is possible to include files that won't be part of the what's generated but the default of auto-including all files makes it easier to create templates.

Using your favorite editor edit the contents of "{{FunctionName}}.ps1" to have the following contents.

```
function {{FunctionName}} {
    {{#CommonParameters}}
    [CmdletBinding()]
    {{/CommonParameters}}
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
}
```

Again, this uses Moustache syntax to define our template. This is not a tutorial on Moustache so we won't cover everything, but let's look at a few key bits of this template just so you can understand it.

```
function {{FunctionName}} {
```

This is a simple replacement for the "FunctionName" value supplied by the user.

```
    {{#CommonParameters}}
    [CmdletBinding()]
    {{/CommonParameters}}
```

Text contained with the "{{#CommonParameters}}" and "{{/CommonParameters}}" tags are included in the output only if the "CommonParameters" value supplied by the user is "true" (or not null or an empty collection). There's similar support for including text only if the value supplied by the user is "false", as can be seen with the "{{^Advanced}}" and "{{/Advanced}}" tag pair.

## Update the Manifest

We have our template content defined, but that template file uses several values the user is expected to provide during template generation. We need to update the manifest ("my-function.pshape.psd1") with these parameters. Using your favorite text editor edit the manifest file and update it with this content.

    [!Note] The 'GUID' value was generated and does not need to be updated. Likewise the Author was generated and will be different for you.

```
@{
    Version = '1.0.0'
    GUID = '0127d66c-340b-460b-ab8a-6c07c48eb096'
    Author = 'William Kempf'
    Copyright = '© 2021, William Kempf. All rights reserved.'
    Description = 'PShape function template.'
    Parameters = @(
        @{ Name = 'FunctionName'; Mandatory = $True },
        @{ Name = 'CommonParameters'; Type = 'switch' },
        @{ Name = 'Advanced'; Type = 'switch' }
    )
}
```

We've specified in "Parameters" that the user can provide three input parameters (FunctionName, CommonParameters and Advanced). We've specified that the FunctionName parameter is mandatory. The user must supply this value during template generation. We've also declared CommonParameters and Advanced to be "switch" types, making it easier for the user to supply those boolean values. We've removed the "Files" specification as we don't need to specify any special file handling for any of the files in our template (this will usually be the case).

## Conclusion

That's it! You've created your first PShape template. Put the working directory that contains this PShape template directory onto the $env:PShapePath path spec you can start using it to generate script functions.

# SEE ALSO

- about_PShape
- Get-PShapeTemplate
- New-PShape
- Set-PShapeDefaultValue
- https://github.com/wekempf/pshape

# KEYWORDS

- PShape
- template
- scaffold
