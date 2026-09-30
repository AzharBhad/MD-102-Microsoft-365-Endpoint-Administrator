<#
.SYNOPSIS
    Lists Intune managed devices that are not compliant, with the failing policies.

.DESCRIPTION
    Queries Microsoft Graph for managed devices whose complianceState is noncompliant
    (optionally including inGracePeriod), then retrieves the per-policy compliance
    states so you can see WHICH policy failed. Optional CSV export.

.PARAMETER IncludeGracePeriod
    Also return devices that are in their compliance grace period.

.PARAMETER Platform
    Filter by operating system (Windows, iOS, Android, macOS).

.PARAMETER CsvPath
    Optional path to export results.

.EXAMPLE
    .\Get-NoncompliantDevices.ps1 -Platform Windows -CsvPath .\noncompliant.csv

.NOTES
    Requires Microsoft.Graph.DeviceManagement.
    Scope: DeviceManagementManagedDevices.Read.All, DeviceManagementConfiguration.Read.All
#>
[CmdletBinding()]
param(
    [switch]$IncludeGracePeriod,
    [ValidateSet('Windows', 'iOS', 'Android', 'macOS')]
    [string]$Platform,
    [string]$CsvPath
)

$ErrorActionPreference = 'Stop'
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All', 'DeviceManagementConfiguration.Read.All' -NoWelcome

$states = @('noncompliant')
if ($IncludeGracePeriod) { $states += 'inGracePeriod' }

$filter = ($states | ForEach-Object { "complianceState eq '$_'" }) -join ' or '
$devices = Get-MgDeviceManagementManagedDevice -Filter $filter -All
if ($Platform) { $devices = $devices | Where-Object OperatingSystem -eq $Platform }

$results = foreach ($d in $devices) {
    $policyStates = Invoke-MgGraphRequest -Method GET `
        -Uri "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices/$($d.Id)/deviceCompliancePolicyStates"
    $failing = $policyStates.value | Where-Object { $_.state -in 'nonCompliant', 'error', 'conflict' } |
        ForEach-Object { $_.displayName }

    [pscustomobject]@{
        DeviceName       = $d.DeviceName
        User             = $d.UserPrincipalName
        OS               = "$($d.OperatingSystem) $($d.OsVersion)"
        ComplianceState  = $d.ComplianceState
        LastSync         = $d.LastSyncDateTime
        FailingPolicies  = ($failing -join '; ')
    }
}

$results | Sort-Object LastSync | Format-Table -AutoSize
if ($CsvPath) {
    $results | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding utf8
    Write-Host "Exported $($results.Count) devices to $CsvPath"
}
