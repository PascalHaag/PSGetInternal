function Save-GIModule {
	<#
	.SYNOPSIS
	Save a module from configured Company-Internal repository to a specific path.
	
	.DESCRIPTION
	Save a module from configured Company-Internal repository to a specific path.
	
	.PARAMETER Name
	Name of the module.
	
	.PARAMETER Path
	Path where the module should be saved.

	.PARAMETER RepositoryName
	Name of the repository.
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.
	
	.EXAMPLE
	PS C:\> Save-GIModule -Name "Company-Module" -Path .

	Will save the module "Company-Module" from the default configured Company-Internal repository to the current path.
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory)]
		[string]
		$Name,

		[Parameter(Mandatory)]
		[string]
		$Path,

		[ArgumentCompleter({ Get-RepoNameCompletion $args })]
		[ValidateScript({ Assert-RepoName -Name $_ })]
		[string]
		$RepositoryName = (Get-DefaultRepo),

		[pscredential]
		$Credential = (Get-RepoCredential -RepositoryName $RepositoryName)		
	)
	process {
		Save-PSResource -Repository $RepositoryName -Name $Name -Credential $Credential -Path $Path
	}
}