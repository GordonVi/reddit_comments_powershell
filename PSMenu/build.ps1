param ($Task = 'Default')

function Ensure-Module($Name, [Switch]$SkipPublisherCheck, [Switch]$SkipImport) {
    if (Get-Module -Name $Name) {
        Return
    }

    if (Get-Module -Name $Name -ListAvailable) {
        if (!$SkipImport) {
            Import-Module -Name $Name
        }
        Return
    }

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Install-Module $Name -Scope CurrentUser -SkipPublisherCheck:$SkipPublisherCheck

    if (!SkipImport) {
        Import-Module -Name $Name
    }
}

# Grab nuget bits, install modules, set build variables, start build.
Ensure-Module -Name Psake
Ensure-Module -Name BuildHelpers
Ensure-Module -Name PSDeploy -SkipImport
Ensure-Module -Name Pester -SkipPublisherCheck

Set-BuildEnvironment -Force

Invoke-psake -buildFile .\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )