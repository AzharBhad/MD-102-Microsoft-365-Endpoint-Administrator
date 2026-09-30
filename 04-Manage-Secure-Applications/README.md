# Domain 4 - Manage and secure applications (15-20%)

App lifecycle in Intune: packaging and deploying Win32, LOB and store apps, Microsoft 365 Apps (Intune, ODT, Autopilot and the Microsoft 365 Apps admin center), Quiet Time, and troubleshooting installs. Then protecting data inside apps with app protection policies, Conditional Access and app configuration policies.

**Suggested time:** ~9 hours (docs 3.5 h + labs 5.5 h).

## 4.1 Deploy and update apps

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 4.1.1 | Prepare applications for deployment by using Intune | [doc](docs/4.1.1-prepare-apps-for-deployment.md) | [LAB-4.01](labs/LAB-4.01-win32-packaging-troubleshooting.md) |
| 4.1.2 | Deploy apps by using Intune, including Win32 apps, line-of-business (LOB) apps, and Microsoft Store apps | [doc](docs/4.1.2-deploy-win32-lob-store-apps.md) | [LAB-4.01](labs/LAB-4.01-win32-packaging-troubleshooting.md), [LAB-4.02](labs/LAB-4.02-lob-store-apps.md) |
| 4.1.3 | Configure Quiet Time policies for Android and iOS apps | [doc](docs/4.1.3-quiet-time-policies.md) | [LAB-4.06](labs/LAB-4.06-quiet-time.md) |
| 4.1.4 | Deploy Microsoft 365 Apps by using Intune | [doc](docs/4.1.4-deploy-microsoft-365-apps.md) | [LAB-4.03](labs/LAB-4.03-m365-apps-intune-odt-autopilot.md) |
| 4.1.5 | Configure policies for Microsoft 365 apps by using Microsoft Intune or the Microsoft 365 Apps admin center | [doc](docs/4.1.5-microsoft-365-apps-policies.md) | [LAB-4.04](labs/LAB-4.04-cloud-policy-m365-apps-admin-center.md) |
| 4.1.6 | Deploy Microsoft 365 Apps as part of a Windows Autopilot deployment, including using the Office Deployment Tool (ODT) or Microsoft Intune | [doc](docs/4.1.6-m365-apps-autopilot-odt.md) | [LAB-4.03](labs/LAB-4.03-m365-apps-intune-odt-autopilot.md) |
| 4.1.7 | Manage Microsoft 365 Apps by using the Microsoft 365 Apps admin center | [doc](docs/4.1.7-microsoft-365-apps-admin-center.md) | [LAB-4.04](labs/LAB-4.04-cloud-policy-m365-apps-admin-center.md) |
| 4.1.8 | Deploy apps from platform-specific app stores by using Intune, including Apple Business Manager and Managed Google Play | [doc](docs/4.1.8-store-apps-abm-managed-google-play.md) | [LAB-4.05](labs/LAB-4.05-abm-vpp-managed-google-play.md) |
| 4.1.9 | Monitor app deployment status and troubleshoot installation failures by using Microsoft Intune | [doc](docs/4.1.9-monitor-troubleshoot-app-deployment.md) | [LAB-4.01](labs/LAB-4.01-win32-packaging-troubleshooting.md) |

## 4.2 Plan and implement app protection and app configuration policies

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 4.2.1 | Plan and implement app protection policies for managed and unmanaged (BYOD) devices by using Microsoft Intune | [doc](docs/4.2.1-app-protection-policies.md) | [LAB-4.07](labs/LAB-4.07-app-protection-conditional-access.md) |
| 4.2.2 | Implement Microsoft Entra Conditional Access policies for app protection policies | [doc](docs/4.2.2-conditional-access-app-protection.md) | [LAB-4.07](labs/LAB-4.07-app-protection-conditional-access.md) |
| 4.2.3 | Plan and implement app configuration policies for managed apps and managed devices | [doc](docs/4.2.3-app-configuration-policies.md) | [LAB-4.08](labs/LAB-4.08-app-configuration-policies.md) |

## Lab order

`4.01 → 4.02 → 4.03 → 4.04 → 4.05 → 4.06 → 4.07 → 4.08`

LAB-4.03 reuses the Autopilot setup from Domain 2. LAB-4.08 reuses the unenrolled phone from LAB-4.07.

## Practice

- [Domain 4 practice questions](../06-Practice-Questions/04-manage-secure-applications-questions.md) (24 questions)
- Script: [New-IntuneWinAppPackage.ps1](../08-Scripts/apps/New-IntuneWinAppPackage.ps1)
- Diagram: [App protection and Conditional Access flow](../assets/diagrams/app-protection-flow.md)
