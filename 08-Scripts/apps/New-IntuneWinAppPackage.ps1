<#
.SYNOPSIS
    Wraps a Win32 app source folder into an .intunewin package with the
    Microsoft Win32 Content Prep Tool (IntuneWinAppUtil.exe).

.DESCRIPTION
    - Validates the source folder and setup file.
    - Optionally downloads IntuneWinAppUtil.exe from the official Microsoft
      GitHub repository (microsoft/Microsoft-Win32-Content-Prep-Tool) if it
      isn't found.
    - Runs the tool in quiet mode and reports the output file.
    - Optionally writes a sample detection script (file-version based) next
      to the package, as a starting point for the Win32 app detection rule.

    Used in LAB-4.01. Run on Windows (the tool is a Windows executable).

.PARAMETER SourceFolder
    Folder with everything the installer needs. Everything in it is packaged,
    so keep it minimal.

.PARAMETER SetupFile
    The installer file name inside SourceFolder (for example setup.exe,
    install.ps1 or app.msi).

.PARAMETER OutputFolder
    Where the .intunewin file is written. Created if missing.

.PARAMETER ToolPath
    Path to IntuneWinAppUtil.exe. Default: .\IntuneWinAppUtil.exe

.PARAMETER DownloadTool
    Download IntuneWinAppUtil.exe to ToolPath if it doesn't exist.

.PARAMETER DetectionFilePath
    Optional. Full path of the file the installed app creates
    (for example C:\Program Files\7-Zip\7z.exe). Used with DetectionVersion to
    write Detect-<name>.ps1 next to the package.

.PARAMETER DetectionVersion
    Optional. Minimum file version that counts as "installed".

.EXAMPLE
    .\New-IntuneWinAppPackage.ps1 -SourceFolder C:\Packages\7zip -SetupFile install.ps1 `
        -OutputFolder C:\Packages\Out -DownloadTool

.EXAMPLE
    .\New-IntuneWinAppPackage.ps1 -SourceFolder C:\Packages\7zip -SetupFile 7z-x64.msi `
        -OutputFolder C:\Packages\Out `
        -DetectionFilePath 'C:\Program Files\7-Zip\7z.exe' -DetectionVersion 24.8.0.0

.NOTES
    .intunewin files are build output - don't commit them (.gitignore: *.intunewin).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$SourceFolder,

    [Parameter(Mandatory)]
    [string]$SetupFile,

    [Parameter(Mandatory)]
    [string]$OutputFolder,

    [string]$ToolPath = (Join-Path -Path (Get-Location) -ChildPath 'IntuneWinAppUtil.exe'),

    [switch]$DownloadTool,

    [string]$DetectionFilePath,

    [version]$DetectionVersion
)

$ErrorActionPreference = 'Stop'

if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') {
    throw 'IntuneWinAppUtil.exe is a Windows tool. Run this script on Windows.'
}

$SourceFolder = (Resolve-Path -Path $SourceFolder).Path
$setupPath = Join-Path -Path $SourceFolder -ChildPath $SetupFile
if (-not (Test-Path -Path $setupPath -PathType Leaf)) {
    throw "Setup file '$SetupFile' not found in '$SourceFolder'."
}

$sourceSizeMB = [math]::Round(((Get-ChildItem -Path $SourceFolder -Recurse -File |
    Measure-Object -Property Length -Sum).Sum / 1MB), 1)
Write-Verbose "Source folder size: $sourceSizeMB MB"

if (-not (Test-Path -Path $ToolPath -PathType Leaf)) {
    if (-not $DownloadTool) {
        throw "IntuneWinAppUtil.exe not found at '$ToolPath'. Use -DownloadTool or -ToolPath."
    }
    $toolUrl = 'https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe'
    Write-Host "Downloading IntuneWinAppUtil.exe from $toolUrl"
    Invoke-WebRequest -Uri $toolUrl -OutFile $ToolPath -UseBasicParsing
}

if (-not (Test-Path -Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}
$OutputFolder = (Resolve-Path -Path $OutputFolder).Path

# -c source, -s setup file, -o output, -q quiet (overwrite without prompting)
$toolArgs = @('-c', $SourceFolder, '-s', $SetupFile, '-o', $OutputFolder, '-q')
& $ToolPath @toolArgs
if ($LASTEXITCODE -ne 0) {
    throw "IntuneWinAppUtil.exe exited with code $LASTEXITCODE."
}

$packageName = [IO.Path]::GetFileNameWithoutExtension($SetupFile) + '.intunewin'
$packagePath = Join-Path -Path $OutputFolder -ChildPath $packageName
if (-not (Test-Path -Path $packagePath)) {
    throw "Expected package '$packagePath' was not created."
}

if ($DetectionFilePath -and $DetectionVersion) {
    $detectionScript = @"
# Intune Win32 detection script - exit 0 AND write to STDOUT = detected.
`$file = '$DetectionFilePath'
if (Test-Path -Path `$file) {
    `$version = [version](Get-Item -Path `$file).VersionInfo.FileVersionRaw
    if (`$version -ge [version]'$DetectionVersion') {
        Write-Output "Detected `$version"
        exit 0
    }
}
exit 1
"@
    $appName = [IO.Path]::GetFileNameWithoutExtension($DetectionFilePath)
    $detectionPath = Join-Path -Path $OutputFolder -ChildPath "Detect-$appName.ps1"
    Set-Content -Path $detectionPath -Value $detectionScript -Encoding UTF8
    Write-Host "Detection script: $detectionPath"
}

$package = Get-Item -Path $packagePath
[pscustomobject]@{
    Package      = $package.FullName
    SizeMB       = [math]::Round($package.Length / 1MB, 1)
    SourceSizeMB = $sourceSizeMB
    SetupFile    = $SetupFile
}
