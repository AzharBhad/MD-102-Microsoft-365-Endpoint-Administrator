# Domain 2 - Manage and maintain devices (25-30%)

The heaviest domain. It covers Windows deployment with Autopilot and Windows 365, configuration profiles on every platform, the Intune Suite add-ons (EPM, Enterprise App Catalog, Remote Help, Cloud PKI, Tunnel for MAM, Advanced Analytics), and day-2 remote actions.

**Suggested time:** ~18 hours (docs 7 h + labs 11 h).

## 2.1 Deploy and upgrade Windows clients by using cloud-based tools

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 2.1.1 | Choose between Windows Autopilot deployment profiles and device preparation policies | [doc](docs/2.1.1-autopilot-profiles-vs-device-preparation.md) | [LAB-2.02](labs/LAB-2.02-autopilot-device-preparation.md) |
| 2.1.2 | Choose between Windows Autopilot deployment modes, including user-driven, pre-provisioning, and self-deploying | [doc](docs/2.1.2-autopilot-deployment-modes.md) | [LAB-2.01](labs/LAB-2.01-autopilot-user-driven.md), [LAB-2.03](labs/LAB-2.03-autopilot-preprovisioning-self-deploying.md) |
| 2.1.3 | Apply a device name template by using Windows Autopilot | [doc](docs/2.1.3-autopilot-device-name-template.md) | [LAB-2.01](labs/LAB-2.01-autopilot-user-driven.md) |
| 2.1.4 | Implement Windows client deployment by using Windows Autopilot | [doc](docs/2.1.4-implement-autopilot-deployment.md) | [LAB-2.01](labs/LAB-2.01-autopilot-user-driven.md) |
| 2.1.5 | Create an Enrollment Status Page (ESP) | [doc](docs/2.1.5-enrollment-status-page.md) | [LAB-2.01](labs/LAB-2.01-autopilot-user-driven.md) |
| 2.1.6 | Plan and implement device upgrades for Windows 11 by using Intune | [doc](docs/2.1.6-windows-11-upgrades.md) | [LAB-2.04](labs/LAB-2.04-windows-11-upgrade.md) |
| 2.1.7 | Provision and configure Windows 365 Cloud PCs by using Intune, including provisioning policies, network connections, and image management | [doc](docs/2.1.7-windows-365-cloud-pcs.md) | [LAB-2.05](labs/LAB-2.05-windows-365-cloud-pc.md) |
| 2.1.8 | Implement Windows Backup by using Intune | [doc](docs/2.1.8-windows-backup.md) | [LAB-2.06](labs/LAB-2.06-windows-backup.md) |

## 2.2 Plan and implement device configuration profiles

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 2.2.1 | Create device configuration profiles for Windows devices, including importing ADMX files and using Group Policy analytics | [doc](docs/2.2.1-windows-configuration-profiles.md) | [LAB-2.07](labs/LAB-2.07-windows-settings-catalog-admx-gpa.md) |
| 2.2.2 | Create device configuration profiles for Android devices | [doc](docs/2.2.2-android-configuration-profiles.md) | [LAB-2.08](labs/LAB-2.08-mobile-macos-configuration-profiles.md) |
| 2.2.3 | Create device configuration profiles for iOS/iPadOS devices | [doc](docs/2.2.3-ios-ipados-configuration-profiles.md) | [LAB-2.08](labs/LAB-2.08-mobile-macos-configuration-profiles.md) |
| 2.2.4 | Create device configuration profiles for macOS devices | [doc](docs/2.2.4-macos-configuration-profiles.md) | [LAB-2.08](labs/LAB-2.08-mobile-macos-configuration-profiles.md) |
| 2.2.5 | Create device configuration profiles for specialty devices, including Microsoft Teams Rooms, HoloLens 2, and Zebra | [doc](docs/2.2.5-specialty-devices.md) | [LAB-2.09](labs/LAB-2.09-specialty-devices.md) |
| 2.2.6 | Target a profile by using assignment filters and enrollment time grouping | [doc](docs/2.2.6-assignment-filters-enrollment-time-grouping.md) | [LAB-2.10](labs/LAB-2.10-assignment-filters-etg.md) |

## 2.3 Implement Intune Suite add-on capabilities

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 2.3.1 | Configure Endpoint Privilege Management including configuring elevation policies, monitoring elevated actions, and adjusting EPM settings | [doc](docs/2.3.1-endpoint-privilege-management.md) | [LAB-2.11](labs/LAB-2.11-endpoint-privilege-management.md) |
| 2.3.2 | Manage applications by using the Enterprise App Catalog | [doc](docs/2.3.2-enterprise-app-catalog.md) | [LAB-2.12](labs/LAB-2.12-enterprise-app-catalog.md) |
| 2.3.3 | Configure Microsoft Intune Remote Help | [doc](docs/2.3.3-remote-help.md) | [LAB-2.13](labs/LAB-2.13-remote-help.md) |
| 2.3.4 | Plan and implement Microsoft Cloud PKI, including setting up cloud-based PKI, automating certificate issuance, and monitoring certificate health | [doc](docs/2.3.4-cloud-pki.md) | [LAB-2.14](labs/LAB-2.14-cloud-pki-scep.md) |
| 2.3.5 | Implement Microsoft Tunnel for Mobile Application Management, including configuring the Microsoft Tunnel VPN Gateway, extending support to MAM devices, and monitoring tunnel connections | [doc](docs/2.3.5-microsoft-tunnel-for-mam.md) | [LAB-2.15](labs/LAB-2.15-microsoft-tunnel-mam.md) |
| 2.3.6 | Implement Microsoft Intune Advanced Analytics, including anomaly detection, proactive insights, and risk-based policy recommendations | [doc](docs/2.3.6-advanced-analytics.md) | [LAB-2.16](labs/LAB-2.16-advanced-analytics.md) |

## 2.4 Perform remote actions on devices

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 2.4.1 | Sync, restart, retire, or wipe devices | [doc](docs/2.4.1-sync-restart-retire-wipe.md) | [LAB-2.17](labs/LAB-2.17-remote-actions.md) |
| 2.4.2 | Perform bulk remote actions | [doc](docs/2.4.2-bulk-remote-actions.md) | [LAB-2.17](labs/LAB-2.17-remote-actions.md) |
| 2.4.3 | Update Microsoft Defender Antivirus security intelligence | [doc](docs/2.4.3-defender-security-intelligence-update.md) | [LAB-2.17](labs/LAB-2.17-remote-actions.md) |
| 2.4.4 | Rotate BitLocker recovery keys | [doc](docs/2.4.4-rotate-bitlocker-keys.md) | [LAB-2.17](labs/LAB-2.17-remote-actions.md) |
| 2.4.5 | Rotate local administrator passwords | [doc](docs/2.4.5-rotate-local-admin-passwords.md) | [LAB-2.17](labs/LAB-2.17-remote-actions.md) |
| 2.4.6 | Run a device query by using KQL | [doc](docs/2.4.6-device-query-kql.md) | [LAB-2.18](labs/LAB-2.18-device-query-diagnostics.md) |
| 2.4.7 | Collect device diagnostics and logs by using Microsoft Intune, including using the Troubleshooting blade for user-based diagnostics | [doc](docs/2.4.7-collect-diagnostics-logs.md) | [LAB-2.18](labs/LAB-2.18-device-query-diagnostics.md) |

## Lab order

`2.01 → 2.02 → 2.03 → 2.07 → 2.10 → 2.04 → 2.06 → 2.12 → 2.11 → 2.13 → 2.17 → 2.16 → 2.18 → 2.14`, then the optional-hardware/cost labs `2.05 (Windows 365) → 2.08 (mobile/mac) → 2.09 (specialty) → 2.15 (Tunnel, delete the VM afterwards)`.

## Practice

- [Domain 2 practice questions](../06-Practice-Questions/02-manage-maintain-devices-questions.md) (40 questions)
- Scripts: [Export-AutopilotHash.ps1](../08-Scripts/autopilot/Export-AutopilotHash.ps1), [Invoke-BulkDeviceAction.ps1](../08-Scripts/graph/Invoke-BulkDeviceAction.ps1), [sample GPO report](../08-Scripts/samples/sample-gpo-report.xml)
- Diagram: [Windows Autopilot flows](../assets/diagrams/autopilot-flow.md)
