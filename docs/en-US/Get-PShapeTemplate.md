---
external help file: pshape-help.xml
Module Name: pshape
online version:
schema: 2.0.0
---

# Get-PShapeTemplate

## SYNOPSIS

Gets the known PShape templates.

## SYNTAX

### Name (Default)

```
Get-PShapeTemplate [[-Name] <String[]>] [-AllVersions] [<CommonParameters>]
```

### Path

```
Get-PShapeTemplate -Path <String[]> [-AllVersions] [<CommonParameters>]
```

## DESCRIPTION

Gets the known PShape templates. PShape templates are discovered in the following order: in directories specified in the PShapePath environment variable then in 'PShapes' directories in all of the known PowerShell modules. Note that the order of templates found in modules is non-deterministic, so if you have a reason to need to control the order you should specify them in the PShapePath.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-PShapeTemplate
```

Gets all of the known PShape templates on the machine.

### Example 2

```powershell
PS C:\> Get-PShapeTemplate pshape-template
```

Gets the PShape template named 'pshape-template'.

## PARAMETERS

### -AllVersions

Return all versions when there are multiple versions of a template installed on the machine.

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

Gets the PShape template with the specified name.

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Gets the PShape template at the specified path.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### PShapeTemplate

## NOTES

## RELATED LINKS
