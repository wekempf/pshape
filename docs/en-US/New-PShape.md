---
external help file: pshape-help.xml
Module Name: pshape
online version:
schema: 2.0.0
---

# New-PShape

## SYNOPSIS

Scaffolds (generates) one or more files as specified by the template.

## SYNTAX

### Name (Default)

```
New-PShape [-Name] <String> [[-Destination] <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Path

```
New-PShape -Path <String> [[-Destination] <String>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Scaffolds (generates) one or more files as specified by the template with the specified Name or Path. Dynamic PowerShell parameters (limited tab completion support) are used to provide template parameters.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PShape pshape-template -TemplateName mytemplate
```

Uses the 'pshape-template' template to scaffold a new pshape template in the current directory passing 'mytemplate' as the 'TemplateName'.

## PARAMETERS

### -Destination

The directory to generate files into.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: '.' (the current directory)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Overwrite existing files without prompting.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of the template to use.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The path of the template to use.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before overwriting files.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### None

## NOTES

## RELATED LINKS
