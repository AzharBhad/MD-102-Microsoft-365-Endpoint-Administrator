<#
.SYNOPSIS
    Collects the Windows Autopilot hardware hash of the local device into a CSV
    that can be imported in the Intune admin center.

.DESCRIPTION
    Reads the device's 4K hardware hash from the MDM_DevDetail_Ext01 WMI class
    (the same source used by the community Get-WindowsAutopilotInfo script),
    plus the serial number, and writes a CSV in the Intune import format:

        Device Serial Number,Windows Product ID,Hardware Hash,Group Tag,Assigned User

    Run elevated. Works in full Windows or at OOBE (Shift+F10 -> powershell).
    Used in LAB-2.01.

.PARAMETER OutputPath
    CSV path. Default: .\AutopilotHWID-<serial>.csv

.PARAMETER GroupTag
    Optional Autopilot group tag (becomes [OrderID]:<tag> in devicePhysicalIDs).

.PARAMETER AssignedUser
    Optional UPN to pre-assign (shown on the branded sign-in page).

.EXAMPLE
    .\Export-AutopilotHash.ps1 -GroupTag Sales

.NOTES
    The hash identifies hardware - treat the CSV as sensitive and never commit it
    to source control (see .gitignore: AutopilotHWID*.csv).
#>
[CmdletBinding()]
param(
    [string]$OutputPath,
    [ValidatePattern('^[A-Za-z0-9 _-]{0,64}$')]
    [string]$GroupTag = '',
    [string]$AssignedUser = ''
)

$ErrorActionPreference = 'Stop'

$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an elevated PowerShell session.'
}

$devDetail = Get-CimInstance -Namespace 'root/cimv2/mdm/dmmap' -ClassName 'MDM_DevDetail_Ext01' `
    -Filter "InstanceID='Ext' AND ParentID='./DevDetail'"
if (-not $devDetail -or [string]::IsNullOrEmpty($devDetail.DeviceHardwareData)) {
    throw 'Hardware hash not available. Is this Windows 10/11 Pro/Enterprise/Education and elevated?'
}

$serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber.Trim()
if (-not $OutputPath) {
    $safeSerial = ($serial -replace '[^A-Za-z0-9-]', '')
    $OutputPath = Join-Path -Path (Get-Location) -ChildPath "AutopilotHWID-$safeSerial.csv"
}

$row = [pscustomobject][ordered]@{
    'Device Serial Number' = $serial
    'Windows Product ID'   = ''
    'Hardware Hash'        = $devDetail.DeviceHardwareData
    'Group Tag'            = $GroupTag
    'Assigned User'        = $AssignedUser
}

# Intune expects no quotes around values and UTF-8 without BOM is safest across portals.
$header = ($row.PSObject.Properties.Name) -join ','
$values = ($row.PSObject.Properties.Value) -join ','
[System.IO.File]::WriteAllLines($OutputPath, @($header, $values), (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Hardware hash for serial '$serial' written to $OutputPath" -ForegroundColor Green
Write-Host 'Import it in Intune: Devices > Windows > Enrollment > Windows Autopilot > Devices > Import'
