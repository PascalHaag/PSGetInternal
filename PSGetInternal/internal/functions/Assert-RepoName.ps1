function Assert-RepoName {
	<#
	.SYNOPSIS
		Asserts a repository name actually exists.
	
	.DESCRIPTION
		Asserts a repository name actually exists.
		Used in validation scripts to ensure proper repository names were provided.
	
	.PARAMETER Name
		The name of the repository to verify.
	
	.EXAMPLE
		PS C:\> Assert-repositoryName -Name $_
		
		Returns $true if the repository exists and throws a terminating exception if not so.
	#>
	[OutputType([bool])]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[AllowEmptyString()]
		[AllowNUll()]
		[string]
		$Name
	)
	process {
		if ((Get-PSResourceRepository).Name -contains $Name) { return $true }

		$repoNames = (Get-PSResourceRepository).Name -join ', '
		Write-Warning "Invalid repository name: '$Name'. Legal repository names: $repoNames"
		Invoke-TerminatingException -Cmdlet $PSCmdlet -Message "Invalid repository name: '$Name'. Legal repository names: $repoNames"
	}
}