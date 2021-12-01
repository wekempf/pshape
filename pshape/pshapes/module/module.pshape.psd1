@{
    Version = '1.0.0'
    GUID = '3294fb8c-e0e6-4fd1-9d38-e22f6bd96444'
    Author = 'William E. Kempf'
    CompanyName = 'Unknown'
    Copyright = '© 2021, William E. Kempf. All rights reserved.'
    Description = 'Module template.'
    Parameters = @(
        @{ Name = 'ModuleName'; Mandatory = $True },
        'Author',
        @{ Name = 'CompanyName'; DefaultValue = 'Unknown' },
        'Copyright',
        @{ Name = 'ModuleVersion'; Type = 'version'; DefaultValue = '0.1.0' },
        'Description',
        @{ Name = 'ProcessorArchitecture'; ValidateSet = 'None,MSIL,X86,IA64,Amd64,Arm' },
        @{ Name = 'PowerShellVersion'; Type = 'version' },
        @{ Name = 'ClrVersion'; Type = 'version' },
        @{ Name = 'DotNetFrameworkVersion'; Type = 'version' },
        'PowerShellHostName',
        @{ Name = 'PowerShellHostVersion'; Type = 'version' },
        @{ Name = 'RequiredModules'; Type = 'object[]' },
        @{ Name = 'RequiredAssemblies'; Type = 'string[]' },
        @{ Name = 'CompatiblePSEditions'; Type = 'string[]'; ValidateSet='Core,Desktop' },
        @{ Name = 'Tags'; Type = 'string[]' },
        @{ Name = 'ProjectUri'; Type = 'uri' },
        @{ Name = 'LicenseUri'; Type = 'uri' },
        @{ Name = 'IconUri'; Type = 'uri' },
        @{ Name = 'RequireLicenseAcceptance'; Type = 'switch' }
    )
}
