function global:Get-RepoNameCompletion {
	<#
	.SYNOPSIS
		Returns the values to complete for.repository names.
	
	.DESCRIPTION
		Returns the values to complete for.repository names.
		Use this command in argument completers.
	
	.PARAMETER ArgumentList
		The arguments an argumentcompleter receives.
		The third item will be the word to complete.
	
	.EXAMPLE
		PS C:\> Get-ServiceCompletion -ArgumentList $args
		
		Returns the values to complete for.repository names.
	#>
	[OutputType([System.Management.Automation.CompletionResult])]
	[CmdletBinding()]
	param (
		$ArgumentList
	)
	process {
		$wordToComplete = $ArgumentList[2].Trim("'`"")
		foreach ($repo in Get-PSResourceRepository) {
			if ($repo.Name -notlike "$($wordToComplete)*") { continue }

			$text = if ($repo.Name -notmatch '\s') { $repo.Name }	else { "'$($repo.Name)'" }
			[System.Management.Automation.CompletionResult]::new(
				$text,
				$text,
				'Text',
				$repo.Uri
			)
		}
	}
}
$ExecutionContext.InvokeCommand.GetCommand("Get-RepoNameCompletion","Function").Visibility = 'Private'