$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = 'https://release.sozocode.com/releases/v1.0.2686/VisuaLeaf-Setup-1.0.2686.exe'
  checksum64     = '6FEFF192906C9EF353C69D92BA0C1A30C9CE205723984985EB4BDCBEC4C8F564'
  checksumType64 = 'sha256'
  softwareName   = 'VisuaLeaf*'
  silentArgs     = '/S /allusers'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
