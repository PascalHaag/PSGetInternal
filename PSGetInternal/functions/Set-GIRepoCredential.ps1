function Set-GIRepoCredential {
	<#
	.SYNOPSIS
	Creates or sets the repository credential.
	
	.DESCRIPTION
	Creates or sets the repository credential for internal repositories.

	.PARAMETER RepositoryName
	Name of the repository, to link the credentails.
	
	.PARAMETER Credential
	Credentials that should be set.
	
	.EXAMPLE
	C:\> Set-GIRepoCredential -RepositoryName "Company-Repository" -Credential $cred

	Will create or set for the repository "Company-Repository" the credential $cred.
	#>
	[CmdletBinding()]
	param (
		[ArgumentCompleter({ Get-RepoNameCompletion $args })]
		[ValidateScript({ Assert-RepoName -Name $_ })]
		[Parameter(Mandatory)]
		$RepositoryName,

		[Parameter(Mandatory)]
		[pscredential]
		$Credential
	)
	process {
		$credFile = Join-Path $Script:configPath "$($RepositoryName)_RepoCred.clixml"
		$Credential | Export-Clixml -Path $credFile -Force
	}
}