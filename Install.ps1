<#
    .SYNOPSIS
        Download the module files from GitHub.

    .DESCRIPTION
        Download the module files from GitHub to the local client in the module folder.
#>

[CmdLetBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [String]$ModuleName = 'Gridify',
    [String]$InstallDirectory,
    [ValidateNotNullOrEmpty()]
    [String]$GitPath = 'https://github.com/PrateekKumarSingh/Gridify/master/'
)

$Pre = $VerbosePreference
$VerbosePreference = 'continue'

    Try {
        Write-Verbose "$ModuleName module installation started"

        $Files = @(
            'Gridify.psd1',
            'Gridify.psm1',
            'README.md',
            'Source\MoveApplication.ps1',
            'Source\Set-GridLayout.ps1'
        )
    }
    Catch {
        throw "Failed installing the module in the install directory '$InstallDirectory': $_"
    }

    Try {
        if (-not $InstallDirectory) {
            Write-Verbose "$ModuleName no installation directory provided"

            $PersonalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules

            if (($env:PSModulePath -split ';') -notcontains $PersonalModules) {
                Write-Warning "$ModuleName personal module path '$PersonalModules' not found in '`$env:PSModulePath'"
            }

            if (-not (Test-Path $PersonalModules)) {
                Write-Error "$ModuleName path '$PersonalModules' does not exist"
            }

            $InstallDirectory = Join-Path -Path $PersonalModules -ChildPath $ModuleName
            Write-Verbose "$ModuleName default installation directory is '$InstallDirectory'"
        }

        if (-not (Test-Path $InstallDirectory)) {
            New-Item -Path $InstallDirectory -ItemType Directory -EA Stop | Out-Null
            New-Item -Path $InstallDirectory\Source -ItemType Directory -EA Stop | Out-Null
            Write-Verbose "$ModuleName created module folder '$InstallDirectory'"
        }

        $WebClient = New-Object System.Net.WebClient

        $Files | ForEach-Object {
            $WebClient.DownloadFile("$GitPath/$_","$installDirectory\$_")
            Write-Verbose "$ModuleName installed module file '$_'"
        }

        Write-Verbose "$ModuleName module installation successful"
    }
    Catch {
        throw "Failed installing the module in the install directory '$InstallDirectory': $_"
    }
$VerbosePreference = $Pre