# Cheat sheet: PowerShell, Microsoft Graph and KQL

## Microsoft Graph PowerShell SDK

```powershell
Install-Module Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement -Scope CurrentUser
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All' -NoWelcome   # delegated
Connect-MgGraph -ClientId <appId> -TenantId contoso.onmicrosoft.com -CertificateThumbprint <thumb>  # app-only
Connect-MgGraph -Identity                                                       # managed identity (Azure Automation)
Get-MgContext                                                                   # who/what am I connected as?
Find-MgGraphCommand -Uri '/deviceManagement/managedDevices'                     # cmdlet + permissions for a URI
```

| Task | Command |
|---|---|
| List devices (all pages) | `Get-MgDeviceManagementManagedDevice -All -Property deviceName,lastSyncDateTime` |
| Filter | `-Filter "operatingSystem eq 'Windows'"` |
| Sync a device | `Sync-MgDeviceManagementManagedDevice -ManagedDeviceId $id` |
| Any endpoint (incl. beta) | `Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies'` |
| Export a report | `POST /beta/deviceManagement/reports/exportJobs` → poll → download `url` ([script](../08-Scripts/graph/Export-IntuneReport.ps1)) |

## Graph permissions (least privilege)

| Need | Permission |
|---|---|
| Read devices | `DeviceManagementManagedDevices.Read.All` |
| Sync/restart/wipe/retire | `DeviceManagementManagedDevices.PrivilegedOperations.All` |
| Configuration & compliance policies | `DeviceManagementConfiguration.Read.All` / `.ReadWrite.All` |
| Apps | `DeviceManagementApps.Read.All` / `.ReadWrite.All` |
| Enrollment/Autopilot | `DeviceManagementServiceConfig.Read.All` / `.ReadWrite.All` |
| RBAC | `DeviceManagementRBAC.Read.All` / `.ReadWrite.All` |

Rules: **v1.0** for production, **beta** when the feature is beta-only · handle **paging** (`-All`) · **429** → honour `Retry-After` · `$batch` up to **20** requests · app-only ignores **scope tags**.

## Script patterns Intune runs

| Script type | Success / trigger | Output |
|---|---|---|
| Win32 **detection** script | **exit 0 + STDOUT** = detected | - |
| **Remediations** detection | **exit 1** = issue → run remediation | STDOUT ≤ 2,048 chars |
| **Custom compliance** discovery | Return **compressed JSON** (`ConvertTo-Json -Compress`) | JSON evaluated by rules file |
| **Platform script** | Runs once (retries on failure) | Success/fail |

Samples: [08-Scripts](../08-Scripts/README.md).

## KQL - Log Analytics (Intune diagnostic settings)

```kusto
IntuneAuditLogs            // who changed what (near real time)
| where TimeGenerated > ago(7d)
| project TimeGenerated, Identity, OperationName, ResultType

IntuneOperationalLogs      // enrollment + noncompliance events (near real time)
| where TimeGenerated > ago(1d)
| summarize count() by OperationName, Result

IntuneDeviceComplianceOrg  // daily compliance snapshot
IntuneDevices              // daily device inventory
```

## KQL - Device query (Advanced Analytics)

```kusto
// Single device (live)
Process
| top 10 by WorkingSetSizeBytes desc

// Multiple devices (inventory; Windows needs a properties catalog policy)
// Browse the property list in the left pane of Devices > Device query
```

Device query supports a **subset** of KQL (table operators `where`, `project`, `summarize`, `top`, `take`, `count`, `distinct`, `order by`, and `join` on the device). Copilot can write the query for you.

Docs: [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) · [5.1.5](../05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) · [5.2.1](../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) · [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) · [2.4.6](../02-Manage-Maintain-Devices/docs/2.4.6-device-query-kql.md)
