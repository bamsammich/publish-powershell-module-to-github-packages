[CmdletBinding()]
param(
  [parameter(Mandatory)]
  [string]$Username,
  [parameter(Mandatory)]
  [string]$Token,
  [parameter(Mandatory)]
  # [ValidateScript( { (Test-Path $_) -and (Test-Path $_ -PathType Container) })]
  [System.IO.FileInfo]$ModulePath
)

begin {
  $sourceName = 'GitHub'
  $source = "https://nuget.pkg.github.com/$Username/index.json"

  # register the github package registry as a powershell repository
  $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $Username, (ConvertTo-SecureString -AsPlainText $Token -Force)
  Register-PSRepository -Name $sourceName -SourceLocation $source -PublishLocation $source -Credential $creds

}

process {
  Get-Location
  Get-ChildItem /workspace
  $module_manifest = Get-ChildItem -Path "." -filter *.psd1
  if (-not $module_manifest) {
    Write-Error "No module manifest found."
    return
  }
  Import-Module $module_manifest.FullName
  <# --
  Publish PowerShell module
  -- #>
  $manifest_info = Test-ModuleManifest $module_manifest.FullName
  $apiKey = 'n/a' # keep this as n/a!

  # Publish-Module -Name $manifest_info.Name `
  #   -Repository $sourceName `
  #   -RequiredVersion $manifest_info.Version `
  #   -Credential $creds `
  #   -Force `
  #   -NuGetApiKey $apiKey
}



