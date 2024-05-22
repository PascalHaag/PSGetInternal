function Find-GIModule {
	<#
	.SYNOPSIS
	Will search all modules in configured Company-Internal repository.
	
	.DESCRIPTION
	Will search all modules in configured Company-Internal repository.
	
	.PARAMETER Name
	Name of the module.

	.PARAMETER RepositoryName
	Name of the repository.
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.
	
	.EXAMPLE
	PS C:\> Find-GIModule

	Will list all modules in the default configured Company-Internal repository.

	.EXAMPLE
	PS C:\> Find-GIModule -Name "Company-Module"

	Will search the module "Company-Module" in the default configured Company-Internal repository.

	.EXAMPLE
	PS C:\> Find-GIModule -Name "Company-Module" -RepositoryName "Company-Repository"

	Will search the module "Company-Module" in the "Company-Repository" repository.
	#>
	[CmdletBinding()]
	Param (
		[string]
		$Name = "*",
		
		[ArgumentCompleter({ Get-RepoNameCompletion $args })]
		[ValidateScript({ Assert-RepoName -Name $_ })]
		[string]
		$RepositoryName = (Get-DefaultRepo),

		[pscredential]
		$Credential = (Get-RepoCredential -RepositoryName $RepositoryName)
	)
	
	process {
		Write-Verbose "Seach Modules in $($RepositoryName)"
		Find-PSResource -Repository $RepositoryName -Name $Name -Credential $Credential | Sort-Object -Unique Name, Version
	}
}