<#
.SYNOPSIS
    Reports BitLocker/FileVault encryption state of Intune managed devices and
    whether a recovery key is escrowed in Microsoft Entra ID.

.DESCRIPTION
    Combines managedDevices.isEncrypted with the Entra bitlockerRecoveryKeys
    list (key metadata only - key values are NOT read) so you can find devices
    that are encrypted without an escrowed key, or not encrypted at all.
    Used in LAB-3.02.

.PARAMETER CsvPath
    Optional export path.

.EXAMPLE
    .\Get-EncryptionStatusReport.ps1 -CsvPath .\encryption.csv

.NOTES
    Scopes: DeviceManagementManagedDevices.Read.All, BitlockerKey.ReadBasic.All
    BitlockerKey.ReadBasic.All returns key metadata only; reading key values needs
    BitlockerKey.Read.All and is audited - intentionally not used here.
#>
[CmdletBinding()]
param([string]$CsvPath)

$ErrorActionPreference = 'Stop'
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All', 'BitlockerKey.ReadBasic.All' -NoWelcome

$devices = Get-MgDeviceManagementManagedDevice -All -Filter "operatingSystem eq 'Windows' or operatingSystem eq 'macOS'" `
    -Property deviceName, operatingSystem, isEncrypted, azureADDeviceId, complianceState, lastSyncDateTime

# Key metadata (paged)
$keys = @{}
$uri = 'https://graph.microsoft.com/v1.0/informationProtection/bitlocker/recoveryKeys?$select=id,deviceId,createdDateTime'
while ($uri) {
    $page = Invoke-MgGraphRequest -Method GET -Uri $uri
    foreach ($k in $page.value) {
        if (-not $keys.ContainsKey($k.deviceId) -or $keys[$k.deviceId] -lt $k.createdDateTime) {
            $keys[$k.deviceId] = $k.createdDateTime
        }
    }
    $uri = $page.'@odata.nextLink'
}

$report = foreach ($d in $devices) {
    $escrowed = $d.OperatingSystem -eq 'Windows' -and $keys.ContainsKey($d.AzureAdDeviceId)
    [pscustomobject]@{
        DeviceName     = $d.DeviceName
        OS             = $d.OperatingSystem
        Encrypted      = $d.IsEncrypted
        KeyInEntra     = if ($d.OperatingSystem -eq 'Windows') { $escrowed } else { 'n/a (FileVault key in Intune)' }
        LatestKeyDate  = if ($escrowed) { $keys[$d.AzureAdDeviceId] } else { $null }
        Compliance     = $d.ComplianceState
        LastSync       = $d.LastSyncDateTime
        Attention      = (-not $d.IsEncrypted) -or ($d.OperatingSystem -eq 'Windows' -and $d.IsEncrypted -and -not $escrowed)
    }
}

$report | Sort-Object Attention -Descending | Format-Table -AutoSize
Write-Host ("Devices needing attention: {0}" -f @($report | Where-Object Attention).Count) -ForegroundColor Yellow
if ($CsvPath) { $report | Export-Csv $CsvPath -NoTypeInformation -Encoding utf8 }
