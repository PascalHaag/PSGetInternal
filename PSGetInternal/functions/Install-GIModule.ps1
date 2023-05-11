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

	.PARAMETER Force
	Installs a module and overrides warning messages about module installation conflicts.
	If a module with the same name already exists on the computer, Force allows for multiple versions to be installed.
	If there is an existing module with the same name and version, Force overwrites that version.

	.PARAMETER AllowClobber
	Overrides warning messages about installation conflicts about existing commands on a computer.

	.PARAMETER AllowPrerelease
	Allows you to install a module marked as a pre-release.

	.PARAMETER MinimumVersion
	Specifies the minimum version of a single module to install. The version installed must be greater than or equal to MinimumVersion.
	If there is a newer version of the module available, the newer version is installed.
	If you want to install multiple modules, you can't use MinimumVersion.
	MinimumVersion and RequiredVersion can't be used in the same Install-GIModule command.

	.PARAMETER MaximumVersion
	Specifies the maximum version of a single module to install. The version installed must be less than or equal to MaximumVersion.
	If you want to install multiple modules, you can't use MaximumVersion.
	MaximumVersion and RequiredVersion can't be used in the same Install-GIModule command.

	.PARAMETER RequiredVersion
	Specifies the exact version of a single module to install.
	If there is no match in the repository for the specified version, an error is displayed.
	If you want to install multiple modules, you can't use RequiredVersion.
	RequiredVersion can't be used in the same Install-GIModule command as MinimumVersion or MaximumVersion.
	
	.PARAMETER Scope
	Specifies the installation scope of the module. The acceptable values for this parameter are AllUsers and CurrentUser.

	The AllUsers scope installs modules in a location that's accessible to all users of the computer:

	$env:ProgramFiles\PowerShell\Modules

	The CurrentUser installs modules in a location that's accessible only to the current user of the computer. For example:

	$HOME\Documents\PowerShell\Modules

	When no Scope is defined, the default is CurrentUser.

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

		[switch]
		$Force,

		[switch]
		$AllowClobber,

		[switch]
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
	begin {
		if (-not $Script:Config) {
			throw "Internal PSGallery not configured! Use Set-GIRepository to set up an internal Repository."
		}
		
		$param = @{
			Repository = $Script:Config.Name
			Name       = $Name
			Credential = $Credential
			Scope      = $Scope
		}
		if ($Force) { $param.Force = $Force }
		if ($AllowClobber) { $param.AllowClobber = $AllowClobber }
		if ($AllowPrerelease) { $param.AllowPrerelease = $AllowPrerelease }
		if ($MinimumVersion) { $param.MinimumVersion = $MinimumVersion }
		if ($MaximumVersion) { $param.MaximumVersion = $MaximumVersion }
		if ($RequiredVersion) { $param.RequiredVersion = $RequiredVersion }
	}
	process {
		Install-Module @param
	}
}