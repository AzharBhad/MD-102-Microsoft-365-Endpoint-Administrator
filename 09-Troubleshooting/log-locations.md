# Log locations and diagnostic commands

Where to look first, by symptom area. Paths are for Windows 11 unless noted.

## Windows - Intune management

| Area | Location / command | Look for |
|---|---|---|
| MDM enrollment and policy (OMA-DM) | Event Viewer: *Applications and Services Logs > Microsoft > Windows > DeviceManagement-Enterprise-Diagnostics-Provider > Admin* | Enrollment errors, CSP failures, policy conflicts |
| Full MDM report | Settings > Accounts > Access work or school > **Export your management log files** → `C:\Users\Public\Documents\MDMDiagnostics` (`MDMDiagReport.html`) | Applied policies, certificates, enrollment IDs |
| Targeted collection | `mdmdiagnosticstool.exe -area Autopilot;DeviceEnrollment;DeviceProvisioning;TPM -cab C:\Temp\diag.cab` | Autopilot/enrollment/TPM cab for support |
| Win32 apps, scripts, remediations, custom compliance | `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\` - `IntuneManagementExtension.log`, **`AppWorkload.log`** (download/install/detection), `AgentExecutor.log` (scripts), **`HealthScripts.log`** (remediations) | Detection results, exit codes, content download |
| Remediation script cache | `C:\Windows\IMECache\HealthScripts` | Script versions actually on the device |
| Remote log collection | Intune: device → **Collect diagnostics** → *Device diagnostics* (kept 28 days) | ZIP with event logs, IME logs, `dsregcmd` output |
| Read logs | **CMTrace** (Configuration Manager tools) or any log viewer | Red/yellow lines, error codes |

## Windows - identity and join

| Area | Location / command | Look for |
|---|---|---|
| Join state | `dsregcmd /status` | `AzureAdJoined`, `DomainJoined`, `WorkplaceJoined`, `AzureAdPrt`, `NgcSet` |
| Registration events | *Microsoft > Windows > User Device Registration > Admin* | Hybrid join / registration failures |
| Entra sign-in | *Microsoft > Windows > AAD > Operational* | PRT and token errors |
| Windows Hello for Business | `dsregcmd /status` (NgcSet, CanReset) + *User Device Registration* | Provisioning prerequisites |

## Windows - Autopilot and ESP

| Area | Location / command |
|---|---|
| Autopilot events | *Microsoft > Windows > ModernDeployment-Diagnostics-Provider > Autopilot* |
| Autopilot/ESP logs | `mdmdiagnosticstool.exe -area Autopilot -cab ...`, or **Collect logs** on the ESP error page |
| Deployment history | Intune: **Devices > Monitor > Autopilot deployments** (30 days) |
| TPM attestation | `tpm.msc`, `Get-Tpm`, and the TPM area in mdmdiagnosticstool |

## Windows - security

| Area | Location / command |
|---|---|
| BitLocker | `manage-bde -status`; *Microsoft > Windows > BitLocker-API > Management* (key backup, encryption errors) |
| Windows LAPS | *Microsoft > Windows > LAPS > Operational* (event **10029** = backed up to Entra ID); `Get-LapsDiagnostics` |
| Defender Antivirus | `Get-MpComputerStatus`, `Get-MpPreference`; *Microsoft > Windows > Windows Defender > Operational* |
| ASR | Defender operational log events **1121** (block) / **1122** (audit) |
| App Control for Business | *Microsoft > Windows > CodeIntegrity > Operational* - **3076** audit, **3077** block |
| Defender for Endpoint sensor | `Get-Service Sense`; Defender portal device page |

## Windows - updates and delivery

| Area | Location / command |
|---|---|
| Windows Update | `Get-WindowsUpdateLog` (creates WindowsUpdate.log on the desktop); Settings > Windows Update > Update history |
| Delivery Optimization | `Get-DeliveryOptimizationStatus`, `Get-DeliveryOptimizationPerfSnap` |
| Update reports | Intune **Reports > Windows updates** (needs the Windows data connector) |

## Other platforms

| Platform | Where |
|---|---|
| **macOS** | `/Library/Logs/Microsoft/Intune/` (Intune agent, scripts, PKG/DMG apps) and `~/Library/Logs/Microsoft/Intune/`; Company Portal > Help > Save diagnostic report; `profiles status -type enrollment` |
| **iOS/iPadOS** | Company Portal > **Send logs** (incident ID); Settings > General > VPN & Device Management; Edge `about:intunehelp` for MAM |
| **Android** | Company Portal / **Intune app** > Help > **Upload logs**; Edge `about:intunehelp` for app protection |
| **MAM (any platform)** | Edge `about:intunehelp`; Intune **Apps > Monitor > App protection status**; Troubleshooting blade *App protection* tab |

## Service side

| Need | Where |
|---|---|
| Everything about one user | **Troubleshooting + support > Troubleshoot** (devices, assignments, enrollment and app failures, APP status) |
| Admin changes | **Tenant administration > Audit logs** (or `IntuneAuditLogs` in Log Analytics) |
| Connectors and Microsoft incidents | **Tenant administration > Tenant status** |
| Enrollment failures | **Devices > Monitor > Enrollment failures** |
| Sign-in / Conditional Access result | Entra **Sign-in logs** → *Conditional Access* tab |

Related: [error codes](error-codes.md) · [troubleshooting flows](troubleshooting-flows.md) · objective [2.4.7](../02-Manage-Maintain-Devices/docs/2.4.7-collect-diagnostics-logs.md)
