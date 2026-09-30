<#
.SYNOPSIS
    Intune Remediations remediation script - deletes files older than 7 days
    from Windows\Temp. Pair with Detect-WindowsTempSize.ps1 (LAB-5.05).

.DESCRIPTION
    Only runs when the detection script exits 1. Files in use are skipped.
    After this script, Intune runs the detection script again to decide
    whether the issue is "fixed" or "recurred".

.NOTES
    Run as SYSTEM (logged-on credentials = No), 64-bit PowerShell = Yes.
#>

$maxAgeDays = 7
$tempPath = Join-Path -Path $env:SystemRoot -ChildPath 'Temp'
$cutoff = (Get-Date).AddDays(-$maxAgeDays)

try {
    $files = Get-ChildItem -Path $tempPath -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoff }

    $removed = 0
    $freedBytes = 0
    foreach ($file in $files) {
        $length = $file.Length
        Remove-Item -LiteralPath $file.FullName -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path -LiteralPath $file.FullName)) {
            $removed++
            $freedBytes += $length
        }
    }

    Write-Output ("Removed {0} files, freed {1:N2} GB" -f $removed, ($freedBytes / 1GB))
    exit 0
}
catch {
    Write-Output "Remediation error: $($_.Exception.Message)"
    exit 1
}
