function Set-GIRepository {
	<#
	.SYNOPSIS
	This function will register a repository and create config and credential file.
	
	.DESCRIPTION
	This function will register a repository and create config and credential file.
	
	.PARAMETER Name
	Name of repository which should be registered.
	
	.PARAMETER SourceLocation
	URL of the repository, which should be registered.
	
	.PARAMETER Credential
	Credentials to get access to Company-Internal repository.
	
	.PARAMETER InstallationPolicy
	Parameter to trust or untrust the source of the repository.
	
	.EXAMPLE
	PS C:\> Set-GIRepository -Name "Contoso-Repository" -SourceLocation "https://pkgs.dev.azure.com/contosoINF/_packaging/InfernalAccounting/nuget/v2" -InstallationPolicy Trusted -Credential $cred
	
	Will register the trusted repository "Contoso-Repository" with SourceLocation "https://pkgs.dev.azure.com/contosoINF/_packaging/InfernalAccounting/nuget/v2".
	And will generate a config and credential file.
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory)]
		[string]
		$Name,

		[Parameter(Mandatory)]
		[uri]
		$SourceLocation,

		[Parameter(Mandatory)]
		[pscredential]
		$Credential,

		[ValidateSet('Trusted', 'Untrusted')]
		[string]
		$InstallationPolicy
	)
	process {
		$existingRepo = Get-PSRepository -Name $Name -ErrorAction Ignore
		if (-not $existingRepo) {
			try {
				Register-PSRepository -Name $Name -SourceLocation $SourceLocation -InstallationPolicy $InstallationPolicy -Credential $Credential -ErrorAction Stop
			}
			catch {
				Write-Warning -Message "Error register Company-Internal Repository: $_"
				return
			}
		}else{
			if (($existingRepo.SourceLocation -ne $SourceLocation) -or ($existingRepo.InstallationPolicy -ne $InstallationPolicy)) {
				try {
					Set-PSRepository -Name $Name -SourceLocation $SourceLocation -InstallationPolicy $InstallationPolicy -Credential $Credential -ErrorAction Stop
				}
				catch {
					Write-Warning -Message "Error setting up Company-Internal Repository: $_"
					return
				}
			}
		}
		
		$credFile = Join-Path $Script:configPath "RepoCred.clixml"
		$Credential | Export-Clixml -Path $credFile -Force

		$repository = [PSCustomObject]@{
			Name               = $Name
			SourceLocation     = $SourceLocation
			InstallationPolicy = $InstallationPolicy
		}
		$repoFile = Join-Path $Script:configPath "config.clixml"
		$repository | Export-Clixml -Path $repoFile -Force
		$Script:Config = $repository	
	}
}