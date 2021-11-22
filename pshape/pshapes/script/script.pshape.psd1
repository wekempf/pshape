@{
    Version = '1.0.0'
    GUID = '937e9cb7-c63a-4e7f-8dc0-239537aa7306'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '© {{year}} {{author}}. All rights reserved.'
    Description = 'Basic PowerShell script.'
    Parameters = @(
        'Name'
        @{ Name = 'CommonParameters'; DefaultValue = $True }
        @{ Name = 'Advanced'; DefaultValue = $False }
    )
}
