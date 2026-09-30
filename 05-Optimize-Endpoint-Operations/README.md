# Domain 5 - Optimize endpoint operations by using automation, monitoring, and reporting (10-15%)

Running Intune day to day: automating with PowerShell and Microsoft Graph, working with Security Copilot agents and Copilot in Intune, extending compliance with scripts, and keeping the estate healthy with reports, Endpoint analytics, remediations, service health and alerts.

**Suggested time:** ~8 hours (docs 3 h + labs 5 h, plus a 24-hour wait for Endpoint analytics data).

> **Agent status (verified September 30, 2026):** The **Vulnerability Remediation Agent** is the only Security Copilot agent still available in the Intune admin center. See [5.1.4](docs/5.1.4-security-copilot-agent-recommendations.md) for the retired agents.

## 5.1 Automate management tasks

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 5.1.1 | Automate Intune management tasks by using PowerShell and Microsoft Graph | [doc](docs/5.1.1-powershell-graph-automation.md) | [LAB-5.01](labs/LAB-5.01-graph-powershell-automation.md) |
| 5.1.2 | Investigate threats identified by Security Copilot agents in Intune | [doc](docs/5.1.2-security-copilot-agents-threat-investigation.md) | [LAB-5.02](labs/LAB-5.02-security-copilot-agents.md) |
| 5.1.3 | Analyze device performance by using Security Copilot agents in Intune | [doc](docs/5.1.3-security-copilot-agents-device-performance.md) | [LAB-5.02](labs/LAB-5.02-security-copilot-agents.md) |
| 5.1.4 | Review and respond to Security Copilot agent recommendations to make management decisions | [doc](docs/5.1.4-security-copilot-agent-recommendations.md) | [LAB-5.02](labs/LAB-5.02-security-copilot-agents.md) |
| 5.1.5 | Extend device compliance by using PowerShell | [doc](docs/5.1.5-custom-compliance-powershell.md) | [LAB-5.03](labs/LAB-5.03-custom-compliance.md) |

## 5.2 Monitor and optimize health

| ID | Objective | Doc | Lab |
|---|---|---|---|
| 5.2.1 | Implement reporting and data visibility in Microsoft Intune, including customizing reports and filters, using workbooks and dashboards, and exporting reporting data | [doc](docs/5.2.1-reporting-workbooks-export.md) | [LAB-5.04](labs/LAB-5.04-reports-workbooks-export.md) |
| 5.2.2 | Monitor endpoint performance by using Endpoint Analytics, including Remediations, device health scores, and app startup performance | [doc](docs/5.2.2-endpoint-analytics.md) | [LAB-5.05](labs/LAB-5.05-endpoint-analytics-remediations.md) |
| 5.2.3 | Configure and manage remediation scripts, including detecting and fixing common device issues, and scheduling remediation runs | [doc](docs/5.2.3-remediation-scripts.md) | [LAB-5.05](labs/LAB-5.05-endpoint-analytics-remediations.md) |
| 5.2.4 | Analyze endpoint reliability and user experience scores, including startup performance, restart frequency, and application reliability metrics | [doc](docs/5.2.4-reliability-user-experience-scores.md) | [LAB-5.05](labs/LAB-5.05-endpoint-analytics-remediations.md) |
| 5.2.5 | Monitor tenant health and Intune service communications, including reviewing service health dashboards, message center notifications, and establishing operational baselines | [doc](docs/5.2.5-service-health-message-center.md) | [LAB-5.06](labs/LAB-5.06-service-health-alerts.md) |
| 5.2.6 | Configure alerts and notifications for policy and compliance changes, including setting up alert rules for compliance drift, enrollment failures, and configuration conflicts | [doc](docs/5.2.6-alerts-notifications.md) | [LAB-5.06](labs/LAB-5.06-service-health-alerts.md) |

## Lab order

`5.05 (start early - 24 h data wait) → 5.01 → 5.03 → 5.04 → 5.06 → 5.02`

LAB-5.02 is last because Security Copilot capacity can cost money - do it in one sitting, or follow its paper path.

## Practice

- [Domain 5 practice questions](../06-Practice-Questions/05-optimize-endpoint-operations-questions.md) (26 questions)
- Scripts: [Export-IntuneReport.ps1](../08-Scripts/graph/Export-IntuneReport.ps1), [Discover-ContosoCompliance.ps1](../08-Scripts/compliance/Discover-ContosoCompliance.ps1) + [rules JSON](../08-Scripts/compliance/contoso-compliance-rules.json), [Detect-WindowsTempSize.ps1](../08-Scripts/remediations/Detect-WindowsTempSize.ps1) / [Remediate-WindowsTempSize.ps1](../08-Scripts/remediations/Remediate-WindowsTempSize.ps1)
- Diagram: [Endpoint operations monitoring](../assets/diagrams/endpoint-operations-monitoring.md)
