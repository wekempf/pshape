---
external help file: pshape-help.xml
Module Name: pshape
online version:
schema: 2.0.0
---

# Set-PShapeDefaultValue

## SYNOPSIS

Sets a default value to use for a template parameter when not specified during scaffolding with New-PShape.

## SYNTAX

### Name (Default)

```
Set-PShapeDefaultValue [-Name] <String> [-ParameterName] <String> [-Value] <String> [<CommonParameters>]
```

### Path

```
Set-PShapeDefaultValue -Path <String> [-ParameterName] <String> [-Value] <String> [<CommonParameters>]
```

## DESCRIPTION

Sets a default value to use for a template parameter when not specified during scaffolding with New-PShape.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-DefaultPShapeValue pshape-template author 'John Doe'
```

Sets the default value of the 'author' template parameter for the 'pshape-template' to be 'John Doe'.

## PARAMETERS

### -Name

The name of the template to set the default value in.

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

### -ParameterName

The template parameter name to set the default value for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The path of the template set the default value in.

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

### -Value

The default value to set for the template parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
