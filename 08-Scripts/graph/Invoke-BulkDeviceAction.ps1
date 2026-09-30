<#
.SYNOPSIS
    Runs a remote action against many Intune managed devices via Microsoft Graph.

.DESCRIPTION
    Selects devices by operating system, name prefix and/or last-sync age, then
    runs one action per device with light throttling. Supports -WhatIf.
    Used in LAB-2.17.

    Actions:
      Sync                   - POST managedDevices/{id}/syncDevice
      Restart                - POST managedDevices/{id}/rebootNow
      DefenderSignatures     - POST managedDevices/{id}/windowsDefenderUpdateSignatures
      QuickScan              - POST managedDevices/{id}/windowsDefenderScan {quickScan:true}
      RotateBitLockerKeys    - POST managedDevices/{id}/rotateBitLockerKeys          (beta)
      RotateLocalAdminPassword - POST managedDevices/{id}/rotateLocalAdminPassword  (beta)

    Destructive actions (wipe/retire/delete) are intentionally NOT included -
    use the portal with Multi Admin Approval for those.

.PARAMETER Action
    One of the actions listed above.

.PARAMETER OperatingSystem
    Filter, for example Windows, iOS, Android, macOS.

.PARAMETER NamePrefix
    Only devices whose name starts with this prefix.

.PARAMETER NotSyncedForDays
    Only devices whose last sync is older than N days.

.PARAMETER LogPath
    CSV log of results. Default .\BulkDeviceAction-<timestamp>.csv

.EXAMPLE
    .\Invoke-BulkDeviceAction.ps1 -Action DefenderSignatures -OperatingSystem Windows -WhatIf

.EXAMPLE
    .\Invoke-BulkDeviceAction.ps1 -Action Sync -OperatingSystem Windows -NotSyncedForDays 3

.NOTES
    Requires Microsoft.Graph.Authentication (Invoke-MgGraphRequest).
    Scopes: DeviceManagementManagedDevices.Read.All,
            DeviceManagementManagedDevices.PrivilegedOperations.All
    If Multi Admin Approval protects device actions, protected calls may be rejected.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateSet('Sync', 'Restart', 'DefenderSignatures', 'QuickScan', 'RotateBitLockerKeys', 'RotateLocalAdminPassword')]
    [string]$Action,

    [ValidateSet('Windows', 'iOS', 'Android', 'macOS')]
    [string]$OperatingSystem = 'Windows',

    [string]$NamePrefix,

    [ValidateRange(0, 365)]
    [int]$NotSyncedForDays = 0,

    [string]$LogPath = (Join-Path (Get-Location) ("BulkDeviceAction-{0:yyyyMMdd-HHmmss}.csv" -f (Get-Date)))
)

$ErrorActionPreference = 'Stop'
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All', 'DeviceManagementManagedDevices.PrivilegedOperations.All' -NoWelcome

$map = @{
    Sync                     = @{ Api = 'v1.0'; Path = 'syncDevice' }
    Restart                  = @{ Api = 'v1.0'; Path = 'rebootNow' }
    DefenderSignatures       = @{ Api = 'v1.0'; Path = 'windowsDefenderUpdateSignatures' }
    QuickScan                = @{ Api = 'v1.0'; Path = 'windowsDefenderScan'; Body = @{ quickScan = $true } }
    RotateBitLockerKeys      = @{ Api = 'beta'; Path = 'rotateBitLockerKeys' }
    RotateLocalAdminPassword = @{ Api = 'beta'; Path = 'rotateLocalAdminPassword' }
}
$spec = $map[$Action]

# Collect devices (handles paging)
$uri = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=operatingSystem eq '$OperatingSystem'&`$select=id,deviceName,lastSyncDateTime,operatingSystem"
$devices = [System.Collections.Generic.List[object]]::new()
while ($uri) {
    $page = Invoke-MgGraphRequest -Method GET -Uri $uri
    $page.value | ForEach-Object { $devices.Add($_) }
    $uri = $page.'@odata.nextLink'
}

if ($NamePrefix) { $devices = @($devices | Where-Object { $_.deviceName -like "$NamePrefix*" }) }
if ($NotSyncedForDays -gt 0) {
    $cutoff = (Get-Date).ToUniversalTime().AddDays(-$NotSyncedForDays)
    $devices = @($devices | Where-Object { [datetime]$_.lastSyncDateTime -lt $cutoff })
}

Write-Host "Targets: $($devices.Count) device(s) for action '$Action'" -ForegroundColor Cyan

$results = foreach ($d in $devices) {
    $target = "$($d.deviceName) ($($d.id))"
    if (-not $PSCmdlet.ShouldProcess($target, $Action)) { continue }
    $actionUri = "https://graph.microsoft.com/$($spec.Api)/deviceManagement/managedDevices/$($d.id)/$($spec.Path)"
    try {
        if ($spec.Body) {
            Invoke-MgGraphRequest -Method POST -Uri $actionUri -Body ($spec.Body | ConvertTo-Json) -ContentType 'application/json' | Out-Null
        } else {
            Invoke-MgGraphRequest -Method POST -Uri $actionUri | Out-Null
        }
        $status = 'Queued'
    } catch {
        $status = "Failed: $($_.Exception.Message)"
    }
    Start-Sleep -Milliseconds 250   # stay well under Graph throttling limits
    [pscustomobject]@{ DeviceName = $d.deviceName; DeviceId = $d.id; Action = $Action; Status = $status; Time = (Get-Date).ToString('s') }
}

if ($results) {
    $results | Export-Csv -Path $LogPath -NoTypeInformation -Encoding utf8
    $results | Group-Object Status | Select-Object Count, Name | Format-Table -AutoSize
    Write-Host "Log written to $LogPath"
}
