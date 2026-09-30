# LAB-5.04 - Reports, Log Analytics workbooks and export

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.04 | 5.2.1 | 60 min | Intermediate |

**Goal:** Customize and export built-in reports, route Intune logs to Log Analytics, query them with KQL, build a small workbook, and export a report through the Graph `exportJobs` API.

> 💰 **Cost guardrail:** Log Analytics charges per GB ingested. A small lab tenant ingests very little, but set a **daily cap** (for example, 0.1 GB/day) and **30-day retention**, and delete the workspace and diagnostic setting when you finish.

## Prerequisites

- Enrolled devices with compliance policies (Domains 1-3 labs).
- An Azure subscription where you can create a resource group and Log Analytics workspace (Azure free account works).
- Intune Administrator (lab).

## Required licenses

Intune Plan 1 + Azure subscription (pay-as-you-go).

## Steps

### Step 1 - Customize and export a built-in report

1. **Reports > Device compliance > Reports** → **Noncompliant devices and settings** → filter OS = Windows → **Columns**: add *Last check-in*, *Primary user UPN* → **Generate report**.
2. **Export** → open the ZIP.

**Expected result:** CSV with only the filtered rows and chosen columns.

### Step 2 - Create a Log Analytics workspace

Azure portal → **Log Analytics workspaces > Create** → resource group `rg-intune-lab`, name `law-intune-lab`, region near you → after creation: **Usage and estimated costs > Daily cap** = 0.1 GB, **Data retention** = 30 days.

**Expected result:** Workspace ready.

### Step 3 - Diagnostic settings

Intune → **Reports > Diagnostic settings > Add diagnostic setting** → `Intune-to-LA` → tick **AuditLogs, OperationalLogs, DeviceComplianceOrg, IntuneDevices** → **Send to Log Analytics workspace** → `law-intune-lab` → **Save**.

Generate data: edit a test policy description (audit event), sync a device, enroll or re-enroll a test device.

**Expected result:** After ~30 minutes, `IntuneAuditLogs` has rows. `IntuneDeviceComplianceOrg` and `IntuneDevices` can take up to 48 h.

### Step 4 - KQL queries

**Reports > Log analytics** (or the workspace **Logs**):

```kusto
IntuneAuditLogs
| where TimeGenerated > ago(1d)
| project TimeGenerated, Identity, OperationName, ResultType
| order by TimeGenerated desc
```

```kusto
IntuneDevices
| summarize arg_max(TimeGenerated, *) by DeviceName
| summarize Devices = count() by OS, CompliantState
```

Adjust column names to your workspace schema (open the table in the schema pane).

**Expected result:** Your policy edit appears with your UPN as `Identity`. Device counts by OS and compliance state.

### Step 5 - Build a workbook

**Reports > Workbooks** (or workspace **Workbooks**) → **New** →

1. Add query: the audit query → visualization **Grid** → title *Recent Intune changes*.
2. Add query: the device summary → visualization **Pie chart** → title *Devices by compliance*.
3. Add a **time range parameter** and reference it in the queries.
4. **Save** as `Endpoint health - lab` in `rg-intune-lab`.

Also open one of the built-in Intune workbooks and compare.

**Expected result:** A two-tile workbook you could share with the ops team.

### Step 6 - Export with Graph exportJobs

```powershell
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All','DeviceManagementConfiguration.Read.All' -NoWelcome
.\08-Scripts\graph\Export-IntuneReport.ps1 -ReportName Devices -Columns DeviceName, UPN, complianceState, OS, OSVersion, LastContact -OutputFolder .\exports
```

**Expected result:** The script shows the job going from *notStarted/inProgress* to *completed* and saves the extracted CSV.

### Step 7 - Copilot Explorer custom report (optional, uses SCUs)

**Explorer** → *"Windows devices that are noncompliant"* → **Save as report** (or export).

**Expected result:** A saved custom view.

## Validation

| Check | Expected |
|---|---|
| Filtered/custom-column export | ✅ |
| Diagnostic setting sending 4 log categories | ✅ |
| Audit event visible in `IntuneAuditLogs` | ✅ |
| Workbook with 2 tiles | ✅ |
| exportJobs CSV | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Subscription not listed in diagnostic settings | Switch directory to the tenant that owns the subscription, or you lack Contributor on the workspace |
| No `IntuneDeviceComplianceOrg` data | Normal for up to 48 h - it's a daily export |
| Workbook shows "no results" | Time range too short, or table not populated yet |
| exportJobs returns 400 | Invalid `reportName` or column name - check the report reference |

## Cleanup / rollback

Delete the diagnostic setting, then delete `rg-intune-lab` (workspace + workbook). Delete exported CSVs.

## Stretch challenge

Stream **AuditLogs** to an **Event Hub** instead and read the events with a small script - the pattern a SIEM integration uses.

## Knowledge check

1. Which Intune log categories arrive in near real time, and which are daily?
2. Where do you configure Intune log routing?
3. Which destination would you choose for a SIEM like Splunk?
4. What API exports Intune reports, and how do you know when the export is ready?

<details>
<summary>Answers</summary>

1. **AuditLogs** and **OperationalLogs** are near real time. **DeviceComplianceOrg** and **IntuneDevices** are daily (up to 48 h).
2. **Reports > Diagnostic settings** in the Intune admin center.
3. **Event Hubs** (stream to SIEM).
4. `deviceManagement/reports/exportJobs`. Poll the job until `status` = `completed`, then download from `url`.

</details>
