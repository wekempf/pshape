@{
    Version = '1.0.0'
    GUID = '{{GUID}}'
    Author = '{{author}}'
    Copyright = '© {{year}} {{author}}. All rights reserved.'
    Description = 'PShape template.'
    Parameters = @(
        # Include all template parameters here either as a basic string
        # or in the form @{ Name= '<name>'; Prompt='<prompt>'; DefaultValue=<defaultvalue> }
    )
    Files = @(
        # All files other than the manifest and control files are included implicitly
        # and do not need to be added here. Files that need special treatment can be added
        # in the form @{ Path='<path>'; Copy=$True; Process=$True } where the Path is relative
        # to the PShape template directory, 'Copy' specifies whether or not the file should be
        # copied to the destination and 'Process' specifies whether or not the file should be
        # processed as a Moustache template (both 'Copy' and 'Process' default to $True).
    )
}