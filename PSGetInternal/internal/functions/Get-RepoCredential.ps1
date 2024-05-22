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
    param(
		[Parameter(Mandatory)]
		$RepositoryName
	)


    $credFilePath = Join-Path $Script:ConfigPath "$($RepositoryName)_RepoCred.clixml"

	if(-not (Test-Path -Path $credFilePath)){
		Write-Verbose "No existing credential file for $($RepositoryName)."
		return
	}

    Import-Clixml $credFilePath
}