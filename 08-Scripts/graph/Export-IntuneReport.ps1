<#
.SYNOPSIS
    Exports an Intune report with the Microsoft Graph exportJobs API and saves
    the extracted CSV. Used in LAB-5.01 and LAB-5.04.

.DESCRIPTION
    1. POST /deviceManagement/reports/exportJobs with reportName, select and filter.
    2. Poll the job until status = completed (or failed).
    3. Download the ZIP from the returned url and extract the CSV.

    Always pass explicit -Columns: Microsoft advises not to build automation
    on a report's default columns. Report names are listed in
    "Intune reports and properties available using Graph API" on Learn
    (for example Devices, DeviceCompliance, DeviceNonCompliance,
    DeviceConfigurationPolicyStatusesV3, AppInvRawData).

    Throttling: exportJobs allows about 100 requests per tenant per minute
    (8 per user, 48 per app) - this script polls every few seconds only.

.PARAMETER ReportName
    The exportJobs reportName, for example Devices.

.PARAMETER Columns
    Columns to include (select). Check valid names for the report on Learn.

.PARAMETER Filter
    Optional OData-style filter string supported by the report,
    for example "(OwnerType eq '1')".

.PARAMETER OutputFolder
    Folder for the extracted CSV. Created if missing.

.PARAMETER TimeoutSeconds
    Maximum time to wait for the export job. Default 300.

.EXAMPLE
    Connect-MgGraph -Scopes DeviceManagementManagedDevices.Read.All
    .\Export-IntuneReport.ps1 -ReportName Devices -Columns DeviceName, UPN, OS, OSVersion, LastContact -OutputFolder .\exports

.NOTES
    Requires Microsoft.Graph.Authentication and an existing Connect-MgGraph
    session (delegated or app-only) with read permission for the report's
    data, for example DeviceManagementManagedDevices.Read.All or
    DeviceManagementConfiguration.Read.All.
    Exported files contain user and device data - don't commit them.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z0-9]+$')]
    [string]$ReportName,

    [Parameter(Mandatory)]
    [string[]]$Columns,

    [string]$Filter,

    [string]$OutputFolder = (Join-Path -Path (Get-Location) -ChildPath 'exports'),

    [ValidateRange(30, 3600)]
    [int]$TimeoutSeconds = 300
)

$ErrorActionPreference = 'Stop'

if (-not (Get-MgContext)) {
    throw 'Not connected to Microsoft Graph. Run Connect-MgGraph first.'
}

$baseUri = 'https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs'

$body = @{
    reportName       = $ReportName
    format           = 'csv'
    localizationType = 'LocalizedValuesAsAdditionalColumn'
    select           = $Columns
}
if ($Filter) {
    $body.filter = $Filter
}

Write-Verbose "Requesting export of '$ReportName'"
$job = Invoke-MgGraphRequest -Method POST -Uri $baseUri -Body ($body | ConvertTo-Json -Depth 5) -ContentType 'application/json'
Write-Host "Export job $($job.id) created (status: $($job.status))"

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
do {
    Start-Sleep -Seconds 5
    $job = Invoke-MgGraphRequest -Method GET -Uri "$baseUri('$($job.id)')"
    Write-Verbose "Status: $($job.status)"
    if ($job.status -eq 'failed') {
        throw "Export job $($job.id) failed."
    }
} until ($job.status -eq 'completed' -or (Get-Date) -gt $deadline)

if ($job.status -ne 'completed') {
    throw "Export job $($job.id) didn't complete within $TimeoutSeconds seconds (last status: $($job.status))."
}

if (-not (Test-Path -Path $OutputFolder)) {
    New-Item -Path $OutputFolder -ItemType Directory | Out-Null
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$zipPath = Join-Path -Path $OutputFolder -ChildPath "$ReportName-$stamp.zip"

# The download URL is a pre-authenticated storage link - no Graph token needed.
Invoke-WebRequest -Uri $job.url -OutFile $zipPath -UseBasicParsing

$extractPath = Join-Path -Path $OutputFolder -ChildPath "$ReportName-$stamp"
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
Remove-Item -Path $zipPath

$csv = Get-ChildItem -Path $extractPath -Filter '*.csv' | Select-Object -First 1
if (-not $csv) {
    throw "No CSV found in the export for '$ReportName'."
}

$rows = @(Import-Csv -Path $csv.FullName)
[pscustomobject]@{
    ReportName = $ReportName
    JobId      = $job.id
    Rows       = $rows.Count
    CsvPath    = $csv.FullName
}
