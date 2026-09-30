# Domain 1 - Prepare infrastructure for devices (20-25%)

This domain covers device identity in Microsoft Entra ID, getting devices into Intune on every platform, and the guardrails around them: RBAC, multi-admin approval, compliance with Conditional Access, Windows Hello for Business, Windows LAPS and local groups.

**Suggested time:** ~12 hours (docs 5 h + labs 7 h).

## 1.1 Add devices to Microsoft Entra ID

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 1.1.1 | Choose an appropriate device join type, including considerations such as device registration and Microsoft Entra join | [doc](docs/1.1.1-choose-device-join-type.md) | [LAB-1.03](labs/LAB-1.03-register-byod-compare-join-types.md) |
| 1.1.2 | Join devices to Microsoft Entra ID | [doc](docs/1.1.2-join-devices-to-entra-id.md) | [LAB-1.02](labs/LAB-1.02-entra-join-automatic-enrollment.md) |
| 1.1.3 | Register devices to Microsoft Entra ID | [doc](docs/1.1.3-register-devices-to-entra-id.md) | [LAB-1.03](labs/LAB-1.03-register-byod-compare-join-types.md) |
| 1.1.4 | Plan and implement groups for devices in Microsoft Entra ID, including dynamic group membership rules | [doc](docs/1.1.4-device-groups-dynamic-membership.md) | [LAB-1.04](labs/LAB-1.04-dynamic-device-groups.md) |

## 1.2 Enroll devices to Microsoft Intune

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 1.2.1 | Configure enrollment settings in Microsoft Intune | [doc](docs/1.2.1-intune-enrollment-settings.md) | [LAB-1.01](labs/LAB-1.01-tenant-baseline-enrollment-settings.md) |
| 1.2.2 | Configure automatic enrollment for Windows | [doc](docs/1.2.2-windows-automatic-enrollment.md) | [LAB-1.02](labs/LAB-1.02-entra-join-automatic-enrollment.md) |
| 1.2.3 | Configure personal enrollment for macOS, iOS, iPadOS | [doc](docs/1.2.3-apple-personal-enrollment.md) | [LAB-1.05](labs/LAB-1.05-apple-personal-enrollment.md) |
| 1.2.4 | Configure enrollment profiles for Android devices, including fully managed, dedicated, corporate-owned devices with a work profile, enrollment restrictions and troubleshooting enrollment failures | [doc](docs/1.2.4-android-enterprise-enrollment-profiles.md) | [LAB-1.06](labs/LAB-1.06-android-enterprise-enrollment-profiles.md) |
| 1.2.5 | Configure corporate enrollment for macOS and iOS devices by integrating Intune with Apple Business Manager | [doc](docs/1.2.5-apple-business-manager-integration.md) | [LAB-1.07](labs/LAB-1.07-apple-business-manager-ade.md) |
| 1.2.6 | Configure enrollment for Android devices by integrating Intune with Samsung Knox Mobile Enrollment or Google zero-touch enrollment | [doc](docs/1.2.6-knox-mobile-enrollment-zero-touch.md) | [LAB-1.08](labs/LAB-1.08-knox-zero-touch-enrollment.md) |

## 1.3 Implement identity and compliance

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 1.3.1 | Manage built-in and custom roles for Intune and Windows 365, including role assignments | [doc](docs/1.3.1-intune-windows365-rbac.md) | [LAB-1.09](labs/LAB-1.09-custom-roles-scope-tags.md) |
| 1.3.2 | Configure scope tags and scoped administration for multi-admin environments | [doc](docs/1.3.2-scope-tags-scoped-administration.md) | [LAB-1.09](labs/LAB-1.09-custom-roles-scope-tags.md) |
| 1.3.3 | Implement and manage multi-admin approval | [doc](docs/1.3.3-multi-admin-approval.md) | [LAB-1.10](labs/LAB-1.10-multi-admin-approval.md) |
| 1.3.4 | Implement compliance policies for all supported device platforms by using Intune | [doc](docs/1.3.4-compliance-policies.md) | [LAB-1.11](labs/LAB-1.11-compliance-conditional-access.md) |
| 1.3.5 | Implement Microsoft Entra Conditional Access policies that require a compliance status | [doc](docs/1.3.5-conditional-access-require-compliance.md) | [LAB-1.11](labs/LAB-1.11-compliance-conditional-access.md) |
| 1.3.6 | Configure Windows Hello for Business by using Intune | [doc](docs/1.3.6-windows-hello-for-business.md) | [LAB-1.12](labs/LAB-1.12-windows-hello-for-business.md) |
| 1.3.7 | Implement and manage Windows Local Administrator Password Solution (Windows LAPS) by using Microsoft Intune and Microsoft Entra ID | [doc](docs/1.3.7-windows-laps.md) | [LAB-1.13](labs/LAB-1.13-windows-laps-local-groups.md) |
| 1.3.8 | Manage the membership of local groups on Windows devices by using Intune | [doc](docs/1.3.8-local-group-membership.md) | [LAB-1.13](labs/LAB-1.13-windows-laps-local-groups.md) |

## Lab order

`LAB-1.01 → 1.02 → 1.03 → 1.04 → 1.09 → 1.10 → 1.11 → 1.12 → 1.13`, then the mobile labs `1.05 → 1.06 → 1.07 → 1.08` when you have devices (or as walkthroughs).

## Practice

- [Domain 1 practice questions](../06-Practice-Questions/01-prepare-infrastructure-questions.md) (26 questions)
- Scripts: [New-DynamicDeviceGroup.ps1](../08-Scripts/graph/New-DynamicDeviceGroup.ps1), [Get-NoncompliantDevices.ps1](../08-Scripts/graph/Get-NoncompliantDevices.ps1), [Get-DeviceJoinTypeReport.ps1](../08-Scripts/graph/Get-DeviceJoinTypeReport.ps1)
- Diagram: [Device identity and enrollment flow](../assets/diagrams/device-identity-and-enrollment.md)
