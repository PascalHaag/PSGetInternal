function Find-GIModule {
	<#
	.SYNOPSIS
	Will search all modules in configured Company-Internal repository.
	
	.DESCRIPTION
	Will search all modules in configured Company-Internal repository.
	
	.PARAMETER Name
	Name of the module.
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.
	
	.EXAMPLE
	PS C:\> Find-GIModule

	Will list all modules in the configured Company-Internal repository.

	.EXAMPLE
	PS C:\> Find-GIModule -Name "Company-Module"

	Will search the module "Company-Module" in the configured Company-Internal repository.
	#>
	[CmdletBinding()]
	Param (
		[string]
		$Name = "*",

		[pscredential]
		$Credential = (Get-RepoCredential)
	)
	begin{
		if(-not $Script:Config){
			throw "Internal PSGallery not configured! Use Set-GIRepository to set up an internal Repository."
		}
	}
	process {
		Find-Module -Repository $Script:Config.Name -Name $Name -Credential $Credential
	}
}