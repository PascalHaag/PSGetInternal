# PSGetInternal

Welcome to the module toolkit designed to work easily with internal repository.
If you work with internal repositories, there are two problems.

1. Getting users onboarded, this can be complex and difficult.
2. Every single call requires specified credentials.

The toolkit will help to solve these problems. 
Using the bootstrap script, users can get onboarded by running a single line of code.
The module itself and the related function will be used to call the internal repository without entering the credentials every call.    

## Installing

To use this module directly, you need to install it from the PowerShell Gallery:

```powershell
Install-Module PSGetInternal -Scope CurrentUser
```

Alternatively, you may want to deploy it via bootstrap script to solve the fundamental chicken/egg problem of deploying the tools to deploy tools.
For details on this see below.

## Getting Started

Only use one time to register the repository.
Is not needed, if bootstrap got used.

```powershell
# Register the trusted repository "Internal-Repository" with SourceLocation "<Repository-URL>". And generate a config and credential file.
$cred = Get-Credential -UserName "<UserPrincipalName>" -Message "Provide PAT used to authenticate to the internal PowerShell Gallery"
Set-GIRepository -Name "Internal-Repository" -SourceLocation "<Repository-URL>" -InstallationPolicy "Trusted" -Credential $cred
```

```powershell
# Install the module "<Internal-ModuleName>" from the configured Internal-Repository repository.
Install-GIModule -Name "<Internal-ModuleName>"
```

## Bootstraping

1. Provide a network share for the bootstrap script, where specific users have access to.
2. Download bootstrap.ps1 from GitHub repository and store it on the network share.
3. Perform the following command in PowerShell from a computer with access to both that network share and the PSGallery:
    
> Be aware that "&lt;network share path&gt;" should be the same path, where the bootstrap script is stored!

```powershell
# Save the module "PSGetInternal" to "<network share path>".
Save-Module -Name "PSGetInternal" -Path "<network share path>" -Repository "PSGallery"
```
    
4. Edit the bootstrap script to your internal repository. Add your personal default settings under the first paramblock:
<br/>`$RepositoryName = "&lt;Name of the internal Repository&gt;"`
<br/>`$Url = "&lt;Url of the internal Repository&gt;"`