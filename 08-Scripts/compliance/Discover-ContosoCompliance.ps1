<#
.SYNOPSIS
    Intune custom compliance discovery script (Windows) - sample for LAB-5.03.

.DESCRIPTION
    Returns the current values of three custom compliance settings as a single
    line of compressed JSON, which Intune evaluates against
    contoso-compliance-rules.json:

        DiskFreePct       Int64     Free space on the system drive, in percent
        BiosReleaseDate   DateTime  BIOS/UEFI firmware release date (ISO 8601)
        EdrSensorRunning  Boolean   Microsoft Defender for Endpoint sensor (Sense) running

    Rules for discovery scripts:
    - Output ONLY the JSON line (no Write-Host/Write-Output of anything else).
    - Keep it read-only and fast (Windows limit: 10 minutes, 1 MB script/output).
    - Setting names are case-sensitive and must match the JSON rules file.

.NOTES
    Upload in Intune: Devices > Compliance > Scripts > Add > Windows 10 and later.
    Run as SYSTEM (logged-on credentials = No), 64-bit PowerShell = Yes.
#>

$systemDrive = $env:SystemDrive
$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$systemDrive'"
$diskFreePct = if ($disk -and $disk.Size -gt 0) {
    [int][math]::Floor(($disk.FreeSpace / $disk.Size) * 100)
} else {
    0
}

$bios = Get-CimInstance -ClassName Win32_BIOS
$biosReleaseDate = if ($bios.ReleaseDate) {
    ([datetime]$bios.ReleaseDate).ToString('yyyy-MM-ddTHH:mm:ss')
} else {
    '1900-01-01T00:00:00'
}

$sense = Get-Service -Name 'Sense' -ErrorAction SilentlyContinue
$edrSensorRunning = [bool]($sense -and $sense.Status -eq 'Running')

$hash = @{
    DiskFreePct      = $diskFreePct
    BiosReleaseDate  = $biosReleaseDate
    EdrSensorRunning = $edrSensorRunning
}
return $hash | ConvertTo-Json -Compress
