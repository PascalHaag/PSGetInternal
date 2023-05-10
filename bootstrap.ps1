<#
    .SYNOPSIS
    Configuration of the client for Company Internal repository.
    
    .DESCRIPTION
    Configuration of the client for Company Internal repository.
    Install necessary module and tools.

    This script expects the module "PSGetInternal" to be stored in the same folder as this script.

    .PARAMETER RepositoryName
    Name of repository which should be registered.

    .PARAMETER Url
    URL of the repository, which should be registered.

    .PARAMETER InstallationPolicy
    Parameter to trust or untrust the source of the repository
    
    .EXAMPLE
    PS C:\> .\bootstrap.ps1 -RepositoryName 'Contoso-Accounting' -Url 'https://pkgs.dev.azure.com/contosoLTD/_packaging/InfernalAccounting/nuget/v2'

    Will ask for credentials for Company Internal nuget package (UPN and PAT).
    Will install in the main module path the module PSGetInternal.
    And will register a repository with:
        -Name "Contoso-Accounting",
        -URL: "https://pkgs.dev.azure.com/contosoLTD/_packaging/InfernalAccounting/nuget/v2",
        -InstallationPolicy = 'Trusted'
#>

[cmdletbinding()]
param(
    [string]
    $RepositoryName = "Company",

    [Uri]
    $Url = "<insert repo url>",

    [ValidateSet('Trusted', 'Untrusted')]
    [string]
    $InstallationPolicy = 'Trusted'
)

trap {
    Write-Warning "Script failed: $_"
    throw $_
}
$ErrorActionPreference = 'Stop'

#region functions
function Get-NugetCred {
    <#
    .SYNOPSIS
    Function to get the credential for Company Internal nuget package.
    
    .DESCRIPTION
    Function to get the credential for Company Internal nuget package.
    Credentials are user principal name as User and Azure DevOps personal access token.
    
    .EXAMPLE
    PS C:\> Get-NugetCred

    Will ask for credentials for Company Internal nuget package (UPN and PAT)

    #>
    [OutputType([pscredential])]
    [CmdletBinding()]
    param ()
    
    Write-Host -Object "Please enter Azure DevOps personal access token
    
    How to generate and get the the PAT, see following documentation:
    https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
    Expiration (UTC) should be 'Custom defined' : 'One year after today' (use date-picker to select the latest possible day)  
    Scopes need to be 'Custom defined' : 'Packaging > Read'
    
    Use the Company Internal user principal name (MusterM1@contoso.com) as 'User'"

    Get-Credential -Message "Provide UPN and PAT"

}
function Install-NugetTools {
    <#
    .SYNOPSIS
    This function will install Company Internal nuget tools of GetInternal
    
    .DESCRIPTION
    This function will install Company Internal nuget tools of GetInternal
    
    .EXAMPLE
    PS C:\> Install-NugetTools

    Will install in the main module path the module PSGetInternal
    #>
    [CmdletBinding()]
    param ()
    if (-not (Test-Path -Path "$($PSScriptRoot)\PSGetInternal")) {
        throw "Please install the module 'PSGetInternal' and store this script in the same folder"
    }

    $modulesRoot = $env:PSModulePath -split ';' | Where-Object { $_ -match 'documents' } | Select-Object -First 1

    Copy-Item -Path "$($PSScriptRoot)\PSGetInternal" -Destination $modulesRoot -Force -Recurse
    
}

#endregion functions

$cred = Get-NugetCred
Install-NugetTools
Set-GIRepository -Name $RepositoryName -SourceLocation $Url -InstallationPolicy $InstallationPolicy -Credential $cred