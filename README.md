# MD-102: Microsoft 365 Endpoint Administrator - Study Repository

[![Exam](https://img.shields.io/badge/Exam-MD--102-0078D4?logo=microsoft&logoColor=white)](https://learn.microsoft.com/credentials/certifications/exams/md-102/)
[![Outline](https://img.shields.io/badge/Skills%20measured-Oct%2027%2C%202026-2EA043)](https://learn.microsoft.com/credentials/certifications/resources/study-guides/md-102)
[![Markdown lint](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/markdown-lint.yml)
[![Link check](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/link-check.yml/badge.svg)](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/link-check.yml)
[![Objective coverage](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/objective-coverage.yml/badge.svg)](https://github.com/AzharBhad/MD-102-Microsoft-365-Endpoint-Administrator/actions/workflows/objective-coverage.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Study notes, hands-on labs, original practice questions and PowerShell/Microsoft Graph scripts for **Exam MD-102: Managing and Securing Microsoft 365 Endpoints by using Intune** (Microsoft 365 Certified: Endpoint Administrator Associate).

> **Exam update:** This repository targets the **skills measured as of October 27, 2026**. That outline replaced the one dated July 24, 2026 on the study guide page. Domain weightings did not change. Microsoft marks seven skill groups as having "minor" changes. See [CHANGELOG.md](CHANGELOG.md#exam-outline-tracking) for details.

✅ **Status:** v1.0.0 - all **83 objectives** have a doc, a hands-on lab and original practice questions ([coverage map](EXAM-OBJECTIVE-MAP.md)).

## Domains and weightings

| # | Domain | Weight |
|---|---|---|
| 1 | [Prepare infrastructure for devices](01-Prepare-Infrastructure/README.md) | 20-25% |
| 2 | [Manage and maintain devices](02-Manage-Maintain-Devices/README.md) | 25-30% |
| 3 | [Protect devices](03-Protect-Devices/README.md) | 15-20% |
| 4 | [Manage and secure applications](04-Manage-Secure-Applications/README.md) | 15-20% |
| 5 | [Optimize endpoint operations by using automation, monitoring, and reporting](05-Optimize-Endpoint-Operations/README.md) | 10-15% |

Folder numbering follows Microsoft's order in the study guide, where *Protect devices* comes before *Manage and secure applications*.

## Start here

1. [00-Getting-Started](00-Getting-Started/README.md) - study roadmap, [8-week plan](00-Getting-Started/8-week-study-plan.md), licensing and lab environment.
2. [EXAM-OBJECTIVE-MAP.md](EXAM-OBJECTIVE-MAP.md) - every objective → doc → lab → questions.
3. [PROGRESS-TRACKER.md](PROGRESS-TRACKER.md) - tick off objectives and labs, rate your confidence.
4. [06-Practice-Questions](06-Practice-Questions/README.md) - 142 domain questions + a 50-question [mock exam](06-Practice-Questions/mock-exam.md).
5. [07-Cheat-Sheets](07-Cheat-Sheets/README.md) - final-week revision.

## What's inside

| Folder / file | Contents |
|---|---|
| `01`-`05` domain folders | One doc per objective (`docs/`), hands-on labs (`labs/`), domain README with objective tables |
| [06-Practice-Questions](06-Practice-Questions/README.md) | 192 original questions tagged by objective |
| [07-Cheat-Sheets](07-Cheat-Sheets/README.md) | Scenario → answer, numbers and limits, enrollment, Autopilot, precedence, roles, Graph/KQL, licensing |
| [08-Scripts](08-Scripts/README.md) | PowerShell / Microsoft Graph samples used by the labs |
| [09-Troubleshooting](09-Troubleshooting/README.md) | Log locations, error codes, troubleshooting flows |
| [assets/diagrams](assets/diagrams/) | Mermaid diagrams (identity, Autopilot, endpoint security, app protection, operations) |
| [GLOSSARY.md](GLOSSARY.md) · [RESOURCES.md](RESOURCES.md) | Terms with current product names · official resources |
| [CONTRIBUTING.md](CONTRIBUTING.md) · [CHANGELOG.md](CHANGELOG.md) | Templates and rules · outline tracking and release notes |

Every doc follows the same template: objective verbatim, plain-English concept, how it works (diagram), licensing, configuration (admin center + PowerShell/Graph), comparisons, exam tips and traps, real-world notes, and Microsoft Learn links. Every lab lists prerequisites and licences, steps with expected results, validation, troubleshooting, cleanup, a stretch challenge and a knowledge check.

## Author

Maintained by [Azhar Bhad](https://github.com/AzharBhad), Endpoint Desktop Engineer (Microsoft Intune, Microsoft Entra ID, cloud-first endpoint management).

## Disclaimer

This is an independent study resource. It is not affiliated with or endorsed by Microsoft. It contains **no exam dumps or NDA content**. All practice questions are original. Product names and features were verified against Microsoft Learn on 2026-09-30 and can change. Always confirm against the [official study guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/md-102).
