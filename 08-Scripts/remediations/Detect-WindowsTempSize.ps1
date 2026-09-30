<#
.SYNOPSIS
    Intune Remediations detection script - flags devices whose Windows\Temp
    folder is larger than a threshold. Sample for LAB-5.05.

.DESCRIPTION
    exit 1 = issue detected -> Intune runs Remediate-WindowsTempSize.ps1
    exit 0 = no issue

    The output line is captured by Intune (max 2,048 characters) and shown in
    the "Pre-remediation detection output" / "Post-remediation detection
    output" columns of the device status report.

.NOTES
    Run as SYSTEM (logged-on credentials = No), 64-bit PowerShell = Yes.
#>

$thresholdGB = 2
$tempPath = Join-Path -Path $env:SystemRoot -ChildPath 'Temp'

try {
    $bytes = (Get-ChildItem -Path $tempPath -Recurse -File -Force -ErrorAction SilentlyContinue |
        Measure-Object -Property Length -Sum).Sum
    $sizeGB = [math]::Round(([double]$bytes) / 1GB, 2)

    if ($sizeGB -gt $thresholdGB) {
        Write-Output "Windows\Temp is $sizeGB GB (threshold $thresholdGB GB)"
        exit 1
    }

    Write-Output "Windows\Temp OK: $sizeGB GB"
    exit 0
}
catch {
    Write-Output "Detection error: $($_.Exception.Message)"
    exit 1
}
