#Requires -Version 7.0
<#
.SYNOPSIS
    Summarizes Microsoft Entra device objects by join type, management and staleness.

.DESCRIPTION
    Groups devices by trustType (AzureAd = Entra joined, ServerAd = hybrid joined,
    Workplace = Entra registered) and flags stale objects. Used with LAB-1.03 and
    for the Device Offboarding discussion in Domain 5.

.PARAMETER StaleDays
    Devices with no sign-in activity for this many days are flagged as stale. Default 90.

.EXAMPLE
    .\Get-DeviceJoinTypeReport.ps1 -StaleDays 60

.NOTES
    Requires Microsoft.Graph.Identity.DirectoryManagement. Scope: Device.Read.All
#>
[CmdletBinding()]
param(
    [ValidateRange(7, 365)]
    [int]$StaleDays = 90
)

$ErrorActionPreference = 'Stop'
Connect-MgGraph -Scopes 'Device.Read.All' -NoWelcome

$joinName = @{
    'AzureAd'   = 'Microsoft Entra joined'
    'ServerAd'  = 'Microsoft Entra hybrid joined'
    'Workplace' = 'Microsoft Entra registered'
}

$cutoff = (Get-Date).AddDays(-$StaleDays)
$devices = Get-MgDevice -All -Property id, displayName, trustType, operatingSystem, isManaged, isCompliant, approximateLastSignInDateTime

$rows = $devices | ForEach-Object {
    [pscustomobject]@{
        DisplayName = $_.DisplayName
        JoinType    = $joinName[[string]$_.TrustType] ?? [string]$_.TrustType
        OS          = $_.OperatingSystem
        Managed     = [bool]$_.IsManaged
        Compliant   = [bool]$_.IsCompliant
        LastSignIn  = $_.ApproximateLastSignInDateTime
        Stale       = ($null -eq $_.ApproximateLastSignInDateTime) -or ($_.ApproximateLastSignInDateTime -lt $cutoff)
    }
}

Write-Host "`nDevices by join type" -ForegroundColor Cyan
$rows | Group-Object JoinType | Select-Object Count, Name | Format-Table -AutoSize

Write-Host "Stale devices (> $StaleDays days)" -ForegroundColor Cyan
$rows | Where-Object Stale | Sort-Object LastSignIn | Format-Table DisplayName, JoinType, OS, LastSignIn -AutoSize
