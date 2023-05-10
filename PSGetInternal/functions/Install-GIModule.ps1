function Install-GIModule {
	<#
	.SYNOPSIS
	Install a module from configured Company-Internal repository.
	
	.DESCRIPTION
	Install a module from configured Company-Internal repository.
	
	.PARAMETER Name
	Name of the module.
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.
	
	.EXAMPLE
	PS C:\> Install-GIModule -Name "Company-Module"

	Will install the module "Company-Module" from the configured Company-Internal repository.
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,

		[pscredential]
		$Credential = (Get-RepoCredential),

		[swtich]
		$Force,

		[switch]
		$AllowClobber,

		[swtich]
		$AllowPrerelease,

		[string]
		$MinimumVersion,

		[string]
		$MaximumVersion,

		[string]
		$RequiredVersion,

		[ValidateSet('AllUsers', 'CurrentUser')]
		[string]
		$Scope = 'CurrentUser'
	)
	begin{
		if(-not $Script:Config){
			throw "Internal PSGallery not configured! Use Set-GIRepository to set up an internal Repository."
		}
		
		$param = @{
			Repository = $Script:Config.Name
			Name = $Name
			Credential = $Credential
			Scope = $Scope
		}
		if($Force){$param.Force = $Force}
		if($AllowClobber){$param.AllowClobber = $AllowClobber}
		if($AllowPrerelease){$param.AllowPrerelease = $AllowPrerelease}
		if($MinimumVersion){$param.MinimumVersion = $MinimumVersion}
		if($MaximumVersion){$param.MaximumVersion = $MaximumVersion}
		if($RequiredVersion){$param.RequiredVersion = $RequiredVersion}
	}
	process {
		Install-Module @param
	}
}