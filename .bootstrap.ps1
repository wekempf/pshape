function Write-Info([string]$Text) { Write-Build -Color White -Text $Text }

function Use-Module {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Name,

        [Parameter(Position=1, Mandatory=$False)]
        [string]$Path = (Join-Path $MyInvocation.PSScriptRoot '.buildtools'),

        [Parameter(Mandatory=$False)]
        [string]$MinimumVersion,

        [Parameter(Mandatory=$False)]
        [string]$MaximumVersion,

        [Parameter(Mandatory=$False)]
        [string]$RequiredVersion,

        [Parameter(Mandatory=$False)]
        [string[]]$Repository = 'PSGallery',

        [switch]$AllowPrerelease
    )

    $cmdArgs = @{ 'Name' = $Name; 'Repository' = $Repository; 'Path' = $Path; 'AllowPrerelease' = $AllowPrerelease }
    Write-Verbose "Use-Module: Name: $Name"
    if ($MinimumVersion) {
        $cmdArgs.Add('MinimumVersion', $MinimumVersion)
        Write-Verbose "            MinimumVersion: $MinimumVersion"
    }
    if ($MaximumVersion) {
        $cmdArgs.Add('MaximumVersion', $MaximumVersion)
        Write-Verbose "            MaximumVersion: $MaximumVersion"
    }
    if ($RequiredVersion) {
        $cmdArgs.Add('RequiredVersion', $RequiredVersion)
        Write-Verbose "            RequiredVersion: $RequiredVersion"
    }
    Write-Verbose "            Repository: $Repository"
    Write-Verbose "            Path: $Path"
    Write-Verbose "            AllowPrerelease: $AllowPrerelease"

    $module = Get-Module -Name $Name -ErrorAction SilentlyContinue
    if ($module -and (*TestVersion -Version $module.Version -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion)) {
        Write-Verbose 'Module already imported'
        return
    }

    $moduleRootPath = Join-Path $Path $Name
    if (Test-Path $moduleRootPath) {
        $moduleDir = *FindVersionDir -RootPath $moduleRootPath -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion
        if ($moduleDir) {
            $psd1 = Join-Path $moduleDir "$Name.psd1"
            if (Test-Path $psd1) {
                Write-Verbose "Import-Module $psd1"
                Import-Module $psd1 -Force
                return
            }
            throw "$moduleDir does not appear to be a valid module (couldn't find $Name.psd1 file)"
        }
    }

    if (-not (Test-Path $Path -PathType Container)) {
        New-Item -ItemType Directory $Path -Force -ErrorAction Stop | Out-Null
    }

    Write-Verbose "Save-Module $Name"
    Save-Module @cmdArgs
    $moduleDir = *FindVersionDir -RootPath $moduleRootPath -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion
    if ($moduleDir) {
        $psd1 = Join-Path $moduleDir "$Name.psd1"
        if (Test-Path $psd1) {
            Import-Module $psd1 -Force
            return
        }
        throw "$moduleDir does not appear to be a valid module (couldn't find $Name.psd1 file)"
    }

    throw "Unable to import module $Name"
}

function Use-Package {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Name,

        [Parameter(Position=1, Mandatory=$False)]
        [string]$Path = (Join-Path $MyInvocation.PSScriptRoot '.buildtools'),

        [Parameter(Mandatory=$False)]
        [string]$MinimumVersion,

        [Parameter(Mandatory=$False)]
        [string]$MaximumVersion,

        [Parameter(Mandatory=$False)]
        [string]$RequiredVersion,

        [Parameter(Mandatory=$False)]
        [string]$ProviderName = 'NuGet',

        [switch]$AllowPrerelease
    )

    $cmdArgs = @{
        'Name' = $Name
        'ProviderName' = $ProviderName
        'Path' = $Path
        'AllowPrerelease' = $AllowPrerelease
    }
    Write-Verbose "Use-Package: Name: $Name"
    if ($MinimumVersion) {
        Write-Verbose "            MinimumVersion: $MinimumVersion"
        $cmdArgs.Add('MinimumVersion', $MinimumVersion)
    }
    if ($MaximumVersion) {
        Write-Verbose "            MaximumVersion: $MaximumVersion"
        $cmdArgs.Add('MaximumVersion', $MaximumVersion)
    }
    if ($RequiredVersion) {
        Write-Verbose "            RequiredVersion: $RequiredVersion"
        $cmdArgs.Add('RequiredVersion', $RequiredVersion)
    }
    Write-Verbose "            ProviderName : $ProviderName"
    Write-Verbose "            Path: $Path"
    Write-Verbose "            AllowPrerelease: $AllowPrerelease"

    $packageRootPath = Join-Path $Path $Name
    if (Test-Path $packageRootPath -PathType Container) {
        $packageDir = *FindVersionDir -RootPath $packageRootPath -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion
        if ($packageDir) {
            $tools = Join-Path $packageDir "tools"
            if (Test-Path $tools) {
                Write-Verbose "Adding tools directory to path"
                Add-Path $tools -Front
                return
            }
            else {
                return $packageDir
            }
            throw "$packageDir does not appear to be a valid package"
        }
    }

    if (-not (Test-Path $Path -PathType Container)) {
        New-Item -ItemType Directory $Path -Force -ErrorAction Stop | Out-Null
    }

    Write-Verbose "Save-Package $Name"
    $nupkg = Save-Package @cmdArgs
    $nupkgPath = Join-Path $Path "$($nupkg.Name).$($nupkg.Version).nupkg"
    $packageDir = Join-Path (Join-Path $Path $nupkg.Name) $nupkg.Version
    try {
        Expand-Archive -Path $nupkgPath -DestinationPath $packageDir
    } finally {
        Remove-Item $nupkgPath
    }

    $tools = Join-Path $packageDir "tools"
    if (Test-Path $tools) {
        Write-Verbose "Adding tools directory to path"
        Add-Path $tools -Front
        return
    }
    elseif (Test-Path $packageDir) {
        return $packageDir
    }

    throw "Unable to save package $Name"
}

function Use-Script {
    param (
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Name,

        [Parameter(Mandatory=$False)]
        [string]$MinimumVersion,

        [Parameter(Mandatory=$False)]
        [string]$MaximumVersion,

        [Parameter(Mandatory=$False)]
        [string]$RequiredVersion,

        [Parameter(Mandatory=$False)]
        [string]$Repository = 'PSGallery',

        [Parameter(Mandatory=$False)]
        [string]$Path = (Join-Path $MyInvocation.PSScriptRoot '.buildtools'),

        [switch]$AllowPrerelease
    )

    Write-Verbose "Use-Script: Name: $Name"
    if ($MinimumVersion) {
        Write-Verbose "            MinimumVersion: $MinimumVersion"
    }
    if ($MaximumVersion) {
        Write-Verbose "            MaximumVersion: $MaximumVersion"
    }
    if ($RequiredVersion) {
        Write-Verbose "            RequiredVersion: $RequiredVersion"
    }
    Write-Verbose "            Repository: $Repository"
    Write-Verbose "            Path: $Path"
    Write-Verbose "            AllowPrerelease: $AllowPrerelease"

    if ($MyInvocation.InvocationName -eq '.') {
        $DotSource = $True
    }

    $scriptRootPath = Join-Path $Path $Name
    if (Test-Path $scriptRootPath) {
        $scriptDir = *FindVersionDir -RootPath $scriptRootPath -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion
        if ($scriptDir) {
            $script = Join-Path $scriptDir "$Name.ps1"
            if (Test-Path $script) {
                if ($DotSource) {
                    Write-Verbose "Dot sourcing script '$script'"
                    . $script
                } else {
                    Write-Verbose "Adding script directory '$scriptDir' to path"
                    Add-Path $scriptDir
                }
                return
            }
            throw "$scriptDir does not appear to contain a valid script (couldn't find $Name.ps1 file)"
        }
    }

    if (-not (Test-Path $Path -PathType Container)) {
        New-Item -ItemType Directory $Path -Force -ErrorAction Stop | Out-Null
    }

    $version = Find-Script -Name $Name -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion -Repository $Repository | Select-Object -ExpandProperty Version
    $scriptRootPath = Join-Path $Path $Name
    $scriptDir = Join-Path $scriptRootPath $version
    New-Item -Path $scriptDir -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Verbose "Save-Script -Name $Name -Path $Path -RequiredVersion $version -Repository $Repository"
    Save-Script -Name $Name -Path $scriptDir -RequiredVersion $version -Repository $Repository
    $scriptDir = *FindVersionDir -RootPath $scriptRootPath -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion
    Write-Verbose "Script directory: $scriptDir"
    if ($scriptDir) {
        $script = Join-Path $moduleDir "$Name.ps1"
        if (Test-Path $script) {
            if ($DotSource) {
                Write-Verbose "Dot sourcing script '$script'"
                . $script
            } else {
                Write-Verbose "Adding script directory '$scriptDir' to path"
                Add-Path $scriptDir
            }
            return
        }
        throw "$scriptDir does not appear to contain a valid script (couldn't find $Name.ps1 file)"
    }

    throw "Unable to use script $Name"
}

function *IsVersion {
    param(
        [Parameter(Position=0, Mandatory=$True)]
        [string]$Text
    )

    [ref]$version = [Version]'0.0'
    [Version]::TryParse($Text, $version)
}

function *TestVersion {
    param(
        [Parameter(Position=0, Mandatory=$False)]
        $Version,

        [Parameter(Position=1, Mandatory=$False)]
        [string]$MinimumVersion,

        [Parameter(Position=2, Mandatory=$False)]
        [string]$MaximumVersion,

        [Parameter(Position=3, Mandatory=$False)]
        [string]$RequiredVersion
    )

    if ($RequiredVersion) {
        return $version -eq [Version]$RequiredVersion
    }
    elseif ($MinimumVersion -and ($version -lt [Version]$MinimumVersion)) {
        return $False
    }
    elseif ($MaximumVersion -and ($version -gt [Version]$MaximumVersion)) {
        return $False
    }
    else {
        return $True
    }
}

function *FindVersionDir {
    param(
        [Parameter(Position=0)]
        [string]$RootPath,

        [Parameter(Position=2, Mandatory=$False)]
        [string]$MinimumVersion,

        [Parameter(Position=3, Mandatory=$False)]
        [string]$MaximumVersion,

        [Parameter(Position=4, Mandatory=$False)]
        [string]$RequiredVersion
    )

    Write-Verbose "*FindVersionDir - RootPath: $RootPath MinimumVersion $MinimumVersion MaximumVersion: $MaximumVersion RequiredVersion: $RequiredVersion"
    Get-ChildItem $RootPath |
        Sort-Object -Property 'Name' |
        Where-Object { (*IsVersion $_.Name) -and (*TestVersion -Version $_.Name -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -RequiredVersion $RequiredVersion) } |
        Select-Object -First 1
}

function Add-Path {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $True)]
        [string[]]$Path,

        [Parameter(Mandatory = $False, ParameterSetName='name')]
        [string]$Name = 'env:Path',

        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ParameterSetName='pathspec')]
        [string]$Pathspec,

        [switch]$Front
    )

    begin {
        $Path = $Path | ForEach-Object { Resolve-Path $_ }
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            $isEnv = $Name.StartsWith('env:', 'CurrentCultureIgnoreCase')
            if ($isEnv) {
                $Name = $Name.Substring(4)
            }
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            if ($isEnv) {
                $pathspec = (Get-Item "env:$Name").Value
            }
            else {
                $pathspec = Get-Variable -Name $Name
            }
        }
        $paths = $Pathspec -split ';' | Where-Object { $_ -and -not ($Path -contains $_) }
        if ($Front) {
            $paths = $Path + $paths
        }
        else {
            $paths += $Path
        }
        $Pathspec = ($paths | Where-Object { Test-Path $_ } | Select-Object -Unique) -join ';'
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            if ($isEnv) {
                Set-Item "env:$Name" $pathspec
            }
            else {
                Set-Variable -Name $Name -Value $pathspec
            }
        }
        else {
            $Pathspec
        }
    }
}