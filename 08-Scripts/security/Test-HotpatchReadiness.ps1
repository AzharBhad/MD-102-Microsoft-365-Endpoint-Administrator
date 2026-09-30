<#
.SYNOPSIS
    Checks the local Windows device against the Hotpatch prerequisites.

.DESCRIPTION
    Reports edition, build (24H2+ = 26100+), architecture, virtualization-based
    security (VBS) state, CHPE restriction on Arm64, and whether the Hotpatch
    policy from Intune is present. Read-only. Used in LAB-3.08.

.EXAMPLE
    .\Test-HotpatchReadiness.ps1

.NOTES
    Run elevated for complete VBS information. Licensing (Windows Enterprise E3/E5 etc.)
    can't be verified locally - check it in the Microsoft 365 admin center.
#>
[CmdletBinding()]
param()

$os    = Get-CimInstance Win32_OperatingSystem
$build = [int]$os.BuildNumber
$arch  = $env:PROCESSOR_ARCHITECTURE
$dg    = Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard -ErrorAction SilentlyContinue

# VirtualizationBasedSecurityStatus: 0 = off, 1 = configured but not running, 2 = running
$vbsRunning = $dg -and $dg.VirtualizationBasedSecurityStatus -eq 2

$chpeOk = $true
if ($arch -eq 'ARM64') {
    $val = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' `
        -Name 'HotPatchRestrictions' -ErrorAction SilentlyContinue
    $chpeOk = ($val -eq 1)
}

$policyKey = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update'
$hotpatchPolicy = $null
if (Test-Path $policyKey) {
    $props = Get-ItemProperty $policyKey
    # Name of the value can vary by build; list anything hotpatch-related for the admin to inspect
    $hotpatchPolicy = $props.PSObject.Properties | Where-Object Name -match 'Hotpatch' | ForEach-Object { "$($_.Name)=$($_.Value)" }
}

$checks = @(
    [pscustomobject]@{ Check = 'Edition is Enterprise/Education'; Value = $os.Caption;       Pass = ($os.Caption -match 'Enterprise|Education') }
    [pscustomobject]@{ Check = 'Windows 11 24H2 or later (build >= 26100)'; Value = $build; Pass = ($build -ge 26100) }
    [pscustomobject]@{ Check = 'Architecture x64 (or Arm64 with CHPE disabled)'; Value = $arch; Pass = ($arch -eq 'AMD64' -or ($arch -eq 'ARM64' -and $chpeOk)) }
    [pscustomobject]@{ Check = 'Virtualization-based security running'; Value = ($dg.VirtualizationBasedSecurityStatus); Pass = [bool]$vbsRunning }
    [pscustomobject]@{ Check = 'Hotpatch policy from Intune detected'; Value = (($hotpatchPolicy -join '; ') -replace '^$', 'none'); Pass = [bool]$hotpatchPolicy }
)

$checks | Format-Table -AutoSize
if ($checks.Pass -contains $false) {
    Write-Warning 'Device is NOT ready for Hotpatch. It will receive the normal cumulative update (with restart).'
} else {
    Write-Host 'All local Hotpatch prerequisites met. The device must also be on the current quarterly baseline.' -ForegroundColor Green
}
