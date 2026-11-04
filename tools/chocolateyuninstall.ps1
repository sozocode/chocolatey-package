$ErrorActionPreference = 'Stop'

$packageName  = $env:ChocolateyPackageName
$softwareName = 'VisuaLeaf*'

[array]$keys = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($keys.Count -eq 1) {
  $key = $keys[0]
  # UninstallString looks like: "C:\Program Files\VisuaLeaf\Uninstall VisuaLeaf.exe" /allusers
  if ($key.UninstallString -match '^\s*"([^"]+)"\s*(.*)$') {
    $file      = $Matches[1]
    $extraArgs = $Matches[2].Trim()
  } else {
    $file      = $key.UninstallString
    $extraArgs = ''
  }

  $packageArgs = @{
    packageName    = $packageName
    fileType       = 'exe'
    file           = $file
    silentArgs     = "$extraArgs /S".Trim()
    validExitCodes = @(0)
  }

  Uninstall-ChocolateyPackage @packageArgs
} elseif ($keys.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} else {
  Write-Warning "$($keys.Count) matches found for '$softwareName'. To avoid removing the wrong program, nothing was uninstalled."
  $keys | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
