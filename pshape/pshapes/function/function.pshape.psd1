@{
    Version = '1.0.0'
    GUID = 'b2120e33-f02d-4e48-a8b6-dfdd54dd9d43'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '© {{year}} {{author}}. All rights reserved.'
    Description = 'Basic PowerShell function script.'
    Parameters = @(
        'Name'
        @{ Name = 'CommonParameters'; DefaultValue = $True }
        @{ Name = 'Advanced'; DefaultValue = $False }
    )
}
