# 08 - Scripts

PowerShell and Microsoft Graph samples used by the labs. They're written for **lab/test tenants**. Read each script before running it, run with `-WhatIf` where supported, and never commit output files (CSV exports, hardware hashes, `.intunewin` packages) - see [.gitignore](../.gitignore).

## Requirements

- PowerShell 7.4+ (Windows PowerShell 5.1 works for the device-side scripts).
- `Microsoft.Graph.Authentication` (plus the `Microsoft.Graph.*` modules each script lists) and an existing `Connect-MgGraph` session with the least-privilege scopes named in the script help.
- Run `Get-Help .\<script>.ps1 -Full` for parameters and examples.

## Catalogue

| Folder | Script | What it does | Used in |
|---|---|---|---|
| setup | [New-LabUsersAndGroups.ps1](setup/New-LabUsersAndGroups.ps1) | Creates the standard lab users and groups in a test tenant | [Lab setup](../00-Getting-Started/lab-environment-setup.md) |
| graph | [New-DynamicDeviceGroup.ps1](graph/New-DynamicDeviceGroup.ps1) | Creates a dynamic device security group | LAB-1.04 |
| graph | [Get-DeviceJoinTypeReport.ps1](graph/Get-DeviceJoinTypeReport.ps1) | Summarizes Entra devices by join type, management and staleness | LAB-1.03 |
| graph | [Get-NoncompliantDevices.ps1](graph/Get-NoncompliantDevices.ps1) | Lists noncompliant devices with failing policies | [1.3.4](../01-Prepare-Infrastructure/docs/1.3.4-compliance-policies.md) |
| graph | [Invoke-BulkDeviceAction.ps1](graph/Invoke-BulkDeviceAction.ps1) | Runs a remote action (sync, restart, ...) on many devices | LAB-2.17, LAB-5.01 |
| graph | [Get-EncryptionStatusReport.ps1](graph/Get-EncryptionStatusReport.ps1) | BitLocker/FileVault encryption state report | LAB-3.02 |
| graph | [Export-IntuneReport.ps1](graph/Export-IntuneReport.ps1) | Exports any Intune report via the Graph `exportJobs` API | LAB-5.01, LAB-5.04 |
| autopilot | [Export-AutopilotHash.ps1](autopilot/Export-AutopilotHash.ps1) | Collects the local hardware hash into an Intune import CSV | LAB-2.01 |
| security | [Test-HotpatchReadiness.ps1](security/Test-HotpatchReadiness.ps1) | Checks local Hotpatch prerequisites | LAB-3.08 |
| apps | [New-IntuneWinAppPackage.ps1](apps/New-IntuneWinAppPackage.ps1) | Wraps a source folder into `.intunewin` (+ optional detection script) | LAB-4.01 |
| compliance | [Discover-ContosoCompliance.ps1](compliance/Discover-ContosoCompliance.ps1) + [contoso-compliance-rules.json](compliance/contoso-compliance-rules.json) | Custom compliance discovery script and JSON rules | LAB-5.03 |
| remediations | [Detect-WindowsTempSize.ps1](remediations/Detect-WindowsTempSize.ps1) / [Remediate-WindowsTempSize.ps1](remediations/Remediate-WindowsTempSize.ps1) | Remediations detection/remediation pair | LAB-5.05 |
| samples | [sample-gpo-report.xml](samples/sample-gpo-report.xml) | Fictitious GPO backup for Group Policy analytics | LAB-2.07 |

## Script conventions

- Comment-based help with `.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE` and `.NOTES` (required permissions).
- `$ErrorActionPreference = 'Stop'` and least-privilege Graph scopes.
- Placeholders only: `contoso.onmicrosoft.com`, `CONTOSO-LAB-xx`. No real tenant IDs, secrets or personal data.
- Before committing, parse-check scripts locally - see [CONTRIBUTING.md](../CONTRIBUTING.md#local-checks).
