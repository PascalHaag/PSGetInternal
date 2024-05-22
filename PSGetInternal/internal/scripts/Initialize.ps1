$localAppData = $env:LOCALAPPDATA

if ($IsLinux -or $IsMacOS){
	$localAppData = $Env:XDG_CONFIG_HOME
	if(-not $localAppData){
		$localAppData = Join-Path $HOME ".config"
	}
}

$Script:ConfigPath = Join-Path $localAppData "PowerShell\PSGetInternal"

if(-not (Test-Path -Path $Script:ConfigPath)){
    $null = New-Item -ItemType Directory -Path $Script:ConfigPath -Force
}