# Changelog

All notable changes to this repository are documented here. Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## Exam outline tracking

| Item | Value |
|---|---|
| Outline this repo targets | **Skills measured as of October 27, 2026** (English exam) |
| Certification page "Last updated" (verified 2026-09-30) | 07/24/2026 |
| Previous outline | Skills measured prior to October 27, 2026 (in effect since July 24, 2026) |
| Localized exams | Updated about 8 weeks after English; if you sit a localized exam before late December 2026 you may still receive the July 24 outline |
| Source | [MD-102 study guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/md-102) |

### Microsoft change log: prior to October 27, 2026 → as of October 27, 2026

| Skill area | Change (per Microsoft) |
|---|---|
| Audience profile | No change |
| **Prepare infrastructure for devices** | No change |
| Enroll devices to Microsoft Intune | Minor |
| **Manage and maintain devices** | No change |
| Deploy and upgrade Windows clients by using cloud-based tools | Minor |
| Plan and implement device configuration profiles | Minor |
| Implement Intune Suite add-on capabilities → Implement **Microsoft** Intune Suite add-on capabilities | Minor |
| Perform remote actions on devices | Minor |
| **Manage applications** → **Manage and secure applications** | No change (per Microsoft) |
| Deploy and update apps | Minor |
| **Optimize endpoint operations by using automation, monitoring, and reporting** | No change |
| Monitor and optimize health | Minor |

Domain weightings are unchanged. Microsoft publishes the change log only at skill-group level, so bullet-level differences are not enumerated by Microsoft.

### Compared with the older four-domain MD-102 outline

- **Added:** a fifth domain, *Optimize endpoint operations by using automation, monitoring, and reporting* (PowerShell/Graph, Security Copilot agents in Intune, custom compliance, Endpoint analytics, Remediations, service health, alerts).
- **Added bullets:** Windows Backup, specialty devices (Teams Rooms, HoloLens 2, Zebra), enrollment time grouping, Samsung Knox Mobile Enrollment / Google zero-touch, local group membership, multi-admin approval, device query (KQL), Hotpatch, Android FOTA, Delivery Optimization, App Control for Business, Quiet Time, Microsoft 365 Apps admin center, Intune Advanced Analytics.
- **Removed:** Configuration Manager, co-management, workload switching, tenant attach / cloud attach. Explicit Microsoft Entra Connect, SSPR, and MFA bullets are gone (still useful background, covered inside related docs).

### Product changes that affect the exam content (verified 2026-09-30)

- **July 2026 licensing change:** Microsoft 365 E3 now includes Intune Plan 2, Remote Help, and Advanced Analytics; Microsoft 365 E5/E7 additionally include Endpoint Privilege Management, Microsoft Cloud PKI, and Enterprise App Management.
- **Security Copilot** is included with Microsoft 365 E5 and E7 (monthly SCU allocation) since the rollout that began November 18, 2025.
- **Intune agents:** the **Device Offboarding Agent** was removed from the Intune admin center on **June 1, 2026** (no new setups after April 30, 2026). The **Policy Configuration Agent** and **Change Review Agent** are no longer available after **August 31, 2026**. The **Vulnerability Remediation Agent** (preview) is the Intune agent that remains. This repo covers the retired agents only as historical context.

## [Unreleased]

Nothing yet. Open an issue if the study guide changes.

## [1.0.0] - 2026-09-30

First complete release: all 83 objectives in the October 27, 2026 outline have a doc, a lab and practice questions.

### Added

- Repository foundation: README, contribution guide, issue/PR templates, markdownlint and lychee link-check workflows.
- `00-Getting-Started`: lab environment setup and licensing guide.
- **Domain 1 - Prepare infrastructure for devices:** 18 docs (1.1.1-1.3.8), 13 labs (LAB-1.01-1.13), 26 practice questions, 3 Graph scripts, device identity diagram.
- **Domain 2 - Manage and maintain devices:** 27 docs (2.1.1-2.4.7), 18 labs (LAB-2.01-2.18), 40 practice questions, Autopilot hash export and bulk device action scripts, sample GPO report, Autopilot flow diagram.
- **Domain 3 - Protect devices:** 15 docs (3.1.1-3.2.7), 10 labs (LAB-3.01-3.10), 26 practice questions, encryption status and Hotpatch readiness scripts, endpoint security stack diagram.
- **Domain 4 - Manage and secure applications:** 12 docs (4.1.1-4.2.3), 8 labs (LAB-4.01-4.08), 24 practice questions, Win32 packaging script, app protection flow diagram.
- **Domain 5 - Optimize endpoint operations:** 11 docs (5.1.1-5.2.6), 6 labs (LAB-5.01-5.06), 26 practice questions, Graph report export, custom compliance and remediation sample scripts, endpoint operations monitoring diagram.
- **Study aids:** study roadmap, 8-week study plan, Configuration Manager context note, 8 cheat sheets, troubleshooting references (log locations, error codes, flows), 50-question weighted mock exam, glossary, resources, full progress tracker (83 objectives, 55 labs), scripts catalogue.
- Cross-references between docs and labs are now links throughout.

### Fixed

- Security Copilot agent status (Device Offboarding Agent removed June 1, 2026) and Vulnerability Remediation Agent prerequisites (no Entra ID P2 requirement).
- App assignment intent conflicts: **Required beats Uninstall** (Uninstall only beats Available), and Win32 apps support *Available* assignments to device groups (4.1.2, LAB-4.02).
