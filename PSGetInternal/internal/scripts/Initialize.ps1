$Script:ConfigPath = Join-Path $env:LOCALAPPDATA "PowerShell\PSGetInternal"  
$packagePath = Join-Path $env:LOCALAPPDATA "PackageManagement\ProviderAssemblies\nuget\2.8.5.208\Microsoft.PackageManagement.NuGetProvider.dll"

if(-not (Test-Path -Path $packagePath)){
    $null = New-Item -ItemType Directory -Path (Split-Path $packagePath) -Force
    Copy-Item -Path "$Script:ModuleRoot\bin\Microsoft.PackageManagement.NuGetProvider.dll" -Destination $packagePath -Force -Recurse
}

if(-not (Test-Path -Path $Script:ConfigPath)){
    $null = New-Item -ItemType Directory -Path $Script:ConfigPath -Force
}

$script:config = Import-Clixml -Path (Join-Path $Script:ConfigPath 'config.clixml') -ErrorAction Ignore