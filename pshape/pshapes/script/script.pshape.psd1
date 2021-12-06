@{
    Version = '1.0.0'
    GUID = '937e9cb7-c63a-4e7f-8dc0-239537aa7306'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '© 2021, William E. Kempf. All rights reserved.'
    Description = 'Basic PowerShell script.'
    Parameters = @(
        @{ Name = 'ScriptName'; Mandatory = $True },
        @{ Name = 'Advanced'; Type = 'switch' }
    )
}
