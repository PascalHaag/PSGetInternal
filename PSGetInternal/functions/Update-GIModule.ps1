function Update-GIModule {
	<#
	.SYNOPSIS
	Update a module from configured Company-Internal repository.
	
	.DESCRIPTION
	Update a module from configured Company-Internal repository.
	
	.PARAMETER Name
	Name of the module.

	.PARAMETER RepositoryName
	Name of the repository.
	
	.PARAMETER Credential
	Credential to get access to the configured Company-Internal repository.

	.PARAMETER Force
	Forces an update of each specified module without a prompt to request confirmation.
    If the module is already installed, Force reinstalls the module.

	.PARAMETER AllowClobber
	Overrides warning messages about installation conflicts about existing commands on a computer.

	.PARAMETER AllowPrerelease
	Allows you to update a module with the newer module marked as a prerelease.

	.PARAMETER MaximumVersion
	Specifies the maximum version of a single module to update.
    You can't add this parameter if you're attempting to update multiple modules.
    The MaximumVersion and the RequiredVersion parameters can't be used in the same command.

	.PARAMETER RequiredVersion
	Specifies the exact version to which the existing installed module will be updated.
    The version specified by RequiredVersion must exist in the online gallery or an error is displayed.
    If more than one module is updated in a single command, you can't use RequiredVersion.
	
	.PARAMETER Scope
	Specifies the installation scope of the module. The acceptable values for this parameter are AllUsers and CurrentUser. If Scope isn't specified, the update is installed in the CurrentUser scope.

    The AllUsers scope requires elevated permissions and installs modules in a location that is accessible to all users of the computer:

    $env:ProgramFiles\PowerShell\Modules

    The CurrentUser doesn't require elevated permissions and installs modules in a location that is accessible only to the current user of the computer:

    $HOME\Documents\PowerShell\Modules

	When no Scope is defined, the default is CurrentUser.

	.EXAMPLE
	PS C:\> Update-GIModule -Name "Company-Module"

	Will update the module "Company-Module" from the configured Company-Internal repository.

	.EXAMPLE
	PS C:\> Update-GIModule -Name "Company-Module" -RepositoryName "Company-Repository"

	Will update the module "Company-Module" from the "Company-Internal" repository.
	#>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name,

		[ArgumentCompleter({ Get-RepoNameCompletion $args })]
		[ValidateScript({ Assert-RepoName -Name $_ })]
		[string]
		$RepositoryName,

		[pscredential]
		$Credential = (Get-RepoCredential -RepositoryName $RepositoryName),
	
		[switch]
		$Force,

		[switch]
		$AllowClobber,

		[switch]
		$AllowPrerelease,

		[string]
		$MaximumVersion,

		[string]
		$RequiredVersion

	)
	begin {
		$param = @{
			Name       = $Name
			Credential = $Credential
			Repository = $RepositoryName
		}
		if ($Force) { $param.Force = $Force }
		if ($AllowClobber) { $param.AllowClobber = $AllowClobber }
		if ($AllowPrerelease) { $param.AllowPrerelease = $AllowPrerelease }
		if ($MaximumVersion) { $param.MaximumVersion = $MaximumVersion }
		if ($RequiredVersion) { $param.RequiredVersion = $RequiredVersion }
	}
	process {
		Update-PSResource @param
	}
}