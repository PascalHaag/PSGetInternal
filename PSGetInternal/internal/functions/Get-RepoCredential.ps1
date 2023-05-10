function Get-RepoCredential {
    <#
    .SYNOPSIS
    Function to get the credential file.
    
    .DESCRIPTION
    Function to get the credential file.
    
    .EXAMPLE
    PS C:\> Get-RepoCredential

    Function to get the credential file from the configuration path of the module.
    #>
    [OutputType([pscredential])]
    [CmdletBinding()]
    param()

    $credFilePath = Join-Path $Script:ConfigPath "RepoCred.clixml"

    Import-Clixml $credFilePath
}