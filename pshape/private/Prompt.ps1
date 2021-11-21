function Prompt {
    param(
        [PShapeTemplate]$PShape,
        [hashtable]$Context
    )

    foreach ($prop in $PShape.Parameters) {
        if ((-not $Context.ContainsKey($prop.Name)) -and $prop.DefaultValue) {
            $Context["$($_.Name)"] = $prop.DefaultValue
        }
    }

    $missing = $PShape.Parameters | Where-Object { -not $Context.ContainsKey($_.Name) }
    if ($missing) {
        Write-Host 'Supply values for the following properties:'
        foreach ($prop in $missing) {
            $name = $prop.Name
            $prompt = $prop.Prompt ? ' ' + $prop.Prompt : ''
            Write-Host "$($name + $prompt): " -NoNewline
            $reply = Read-Host
            if (-not $reply) {
                Write-Error "Cannot bind argument to property '$name' because it is empty." -ErrorAction Stop
            }
            $Context.$name = $reply
        }
    }
}