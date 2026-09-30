# Domain 3 - Protect devices (15-20%)

Endpoint security in Intune: antivirus, encryption, firewall, attack surface reduction, security baselines, Microsoft Defender for Endpoint integration and App Control for Business. Plus the full update management story for Windows, Apple and Android.

**Suggested time:** ~10 hours (docs 4 h + labs 6 h).

## 3.1 Configure endpoint security

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 3.1.1 | Create antivirus policies by using Microsoft Intune | [doc](docs/3.1.1-antivirus-policies.md) | [LAB-3.01](labs/LAB-3.01-antivirus-firewall-policies.md) |
| 3.1.2 | Create and manage disk encryption policies by using Microsoft Intune, including managing BitLocker recovery keys, configuring user self-service recovery, and monitoring encryption compliance status | [doc](docs/3.1.2-disk-encryption-bitlocker-filevault.md) | [LAB-3.02](labs/LAB-3.02-bitlocker-filevault.md) |
| 3.1.3 | Create firewall policies by using Microsoft Intune | [doc](docs/3.1.3-firewall-policies.md) | [LAB-3.01](labs/LAB-3.01-antivirus-firewall-policies.md) |
| 3.1.4 | Configure Attack surface reduction policies by using Microsoft Intune, including applying Zero Trust principles for endpoint protection | [doc](docs/3.1.4-attack-surface-reduction-zero-trust.md) | [LAB-3.03](labs/LAB-3.03-attack-surface-reduction.md) |
| 3.1.5 | Plan and implement security baselines by using Microsoft Intune | [doc](docs/3.1.5-security-baselines.md) | [LAB-3.04](labs/LAB-3.04-security-baselines.md) |
| 3.1.6 | Integrate Intune with Microsoft Defender for Endpoint, including configuring Endpoint Detection and Response (EDR) policies, investigating endpoint threats, and triaging incidents | [doc](docs/3.1.6-defender-for-endpoint-integration-edr.md) | [LAB-3.05](labs/LAB-3.05-defender-for-endpoint.md) |
| 3.1.7 | Onboard devices into Microsoft Defender for Endpoint | [doc](docs/3.1.7-onboard-defender-for-endpoint.md) | [LAB-3.05](labs/LAB-3.05-defender-for-endpoint.md) |
| 3.1.8 | Configure App Control for Business policies by using Microsoft Intune | [doc](docs/3.1.8-app-control-for-business.md) | [LAB-3.06](labs/LAB-3.06-app-control-for-business.md) |

## 3.2 Manage device updates

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 3.2.1 | Plan for device updates by using Intune | [doc](docs/3.2.1-plan-device-updates.md) | [LAB-3.07](labs/LAB-3.07-windows-update-rings-feature-quality.md) |
| 3.2.2 | Create and manage update rings, feature updates, and quality updates for Windows devices by using Intune | [doc](docs/3.2.2-update-rings-feature-quality-updates.md) | [LAB-3.07](labs/LAB-3.07-windows-update-rings-feature-quality.md) |
| 3.2.3 | Implement Windows Autopatch and configure Hotpatch policies | [doc](docs/3.2.3-windows-autopatch-hotpatch.md) | [LAB-3.08](labs/LAB-3.08-autopatch-hotpatch.md) |
| 3.2.4 | Create and manage update policies for iOS/iPadOS and macOS devices by using the Settings Catalog in Microsoft Intune | [doc](docs/3.2.4-apple-update-policies-settings-catalog.md) | [LAB-3.09](labs/LAB-3.09-apple-android-updates.md) |
| 3.2.5 | Manage Android updates by using configuration profiles or firmware-over-the-air (FOTA) deployments | [doc](docs/3.2.5-android-updates-fota.md) | [LAB-3.09](labs/LAB-3.09-apple-android-updates.md) |
| 3.2.6 | Configure Windows client Delivery Optimization by using Intune | [doc](docs/3.2.6-delivery-optimization.md) | [LAB-3.10](labs/LAB-3.10-delivery-optimization-update-reports.md) |
| 3.2.7 | Monitor device updates by using Intune | [doc](docs/3.2.7-monitor-device-updates.md) | [LAB-3.10](labs/LAB-3.10-delivery-optimization-update-reports.md) |

## Lab order

`3.01 → 3.02 → 3.05 → 3.03 → 3.04 → 3.06 → 3.07 → 3.08 → 3.10 → 3.09`

## Practice

- [Domain 3 practice questions](../06-Practice-Questions/03-protect-devices-questions.md) (26 questions)
- Scripts: [Get-EncryptionStatusReport.ps1](../08-Scripts/graph/Get-EncryptionStatusReport.ps1), [Test-HotpatchReadiness.ps1](../08-Scripts/security/Test-HotpatchReadiness.ps1)
- Diagram: [Endpoint security stack](../assets/diagrams/endpoint-security-stack.md)
