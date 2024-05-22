function Set-GIRepository {
	<#
	.SYNOPSIS
	This function will register a repository and create config and credential file.
	
	.DESCRIPTION
	This function will register a repository and create config and credential file.
	
	.PARAMETER Name
	Name of repository which should be registered.
	
	.PARAMETER Uri
	URL of the repository, which should be registered.
	
	.PARAMETER Credential
	Credentials to get access to Company-Internal repository.
	
	.PARAMETER InstallationPolicy
	Parameter to trust or untrust the source of the repository.
	
	.EXAMPLE
	PS C:\> Set-GIRepository -Name "Company-Repository" -Uri "https://pkgs.dev.azure.com/contosoINF/_packaging/InfernalAccounting/nuget/v2" -InstallationPolicy Trusted -Credential $cred
	
	Will register the trusted repository "Company-Repository" with Uri "https://pkgs.dev.azure.com/contosoINF/_packaging/InfernalAccounting/nuget/v2".
	And will generate a config and credential file.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory)]
		[string]
		$Name,

		[Alias('SourceLocation')]
		[Parameter(Mandatory)]
		[uri]
		$Uri,

		[Parameter(Mandatory)]
		[pscredential]
		$Credential,

		[ValidateSet('Trusted', 'Untrusted')]
		[string]
		$InstallationPolicy = 'Trusted',

		[switch]
		$Default
	)
	process {
		$existingRepo = Get-PSResourceRepository -Name $Name -ErrorAction Ignore
		if (-not $existingRepo) {
			try {
				Register-PSResourceRepository -Name $Name -Uri $Uri -Trusted:$($InstallationPolicy -eq "Trusted") -ErrorAction Stop
			}
			catch {
				Write-Warning -Message "Error register Company-Internal Repository: $_"
				return
			}
		}
		else {
			if (($existingRepo.Uri -ne $Uri) -or ($existingRepo.Trusted -ne ($InstallationPolicy -eq "Trusted"))) {
				try {
					Unregister-PSResourceRepository -Name $Name -ErrorAction Stop
					Register-PSResourceRepository -Name $Name -Uri $Uri -Trusted:$($InstallationPolicy -eq "Trusted") -ErrorAction Stop
				}
				catch {
					Write-Warning -Message "Error to update Company-Internal Repository: $_"
					return
				}
			}
		}

		Set-GIRepoCredential -RepositoryName $Name -Credential $Credential
		
		if ($Default) {
			$defaultRepoFile = Join-Path $Script:configPath "DefaultRepo.clixml"
			$Name | Export-Clixml -Path $defaultRepoFile -Force
		}
	}
}