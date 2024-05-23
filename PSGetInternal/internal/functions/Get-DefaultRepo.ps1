function Get-DefaultRepo {
	[CmdletBinding()]
	param ()
	process {
		$defaultRepoFile = Join-Path $Script:configPath "DefaultRepo.clixml"
		$existingRepoNames = (Get-PSResourceRepository).Name

		if (-not (Test-Path -Path $defaultRepoFile)) {
			if ("PSGallery" -in $existingRepoNames) {
				"PSGallery"
				return
			}
			Write-Warning "No default repository defined and could not found 'PSGallery' as repository"
			Invoke-TerminatingException -Cmdlet $PSCmdlet -Message "No default repository defined and could not found 'PSGallery' as repository"
		}

		$defaultRepoName = Import-Clixml $defaultRepoFile

		if (-not ($defaultRepoName -in $existingRepoNames)) {
			Write-Warning "The default repository $($defaultRepoName) could not found as repository. Legal repository names: $($existingRepoNames -join ', ')"
			Invoke-TerminatingException -Cmdlet $PSCmdlet -Message "The default repository $($defaultRepoName) could not found as repository. Legal repository names: $($existingRepoNames -join ', ')"
		}
		$defaultRepoName
	}
}