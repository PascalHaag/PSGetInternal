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
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.
	
	.EXAMPLE
	PS C:\> Save-GIModule -Name "Company-Module" -Path .

	Will save the module "Company-Module" from the configured Company-Internal repository to the current path.
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory)]
		[string]
		$Name,

		[Parameter(Mandatory)]
		[string]
		$Path,

		[pscredential]
		$Credential = (Get-RepoCredential)
	)
	process {
		Save-Module -Repository $Script:Config.Name -Name $Name -Credential $Credential -Path $Path
	}
}