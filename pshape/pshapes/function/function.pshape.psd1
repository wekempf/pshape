@{
    Version = '1.0.0'
    GUID = 'b2120e33-f02d-4e48-a8b6-dfdd54dd9d43'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '© 2021, William E. Kempf. All rights reserved.'
    Description = 'Basic PowerShell function script.'
    Parameters = @(
        @{ Name = 'FunctionName'; Mandatory = $True },
        @{ Name = 'Advanced'; Type = 'switch' }
    )
}
