# LAB-5.01 - Automate Intune with Microsoft Graph PowerShell

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.01 | 5.1.1 | 60 min | Intermediate |

**Goal:** Connect to Microsoft Graph interactively and app-only, report on stale devices, run a remote action, call a beta endpoint, and export a report with the `exportJobs` API.

## Prerequisites

- PowerShell 7.4+ on your admin workstation.
- At least two enrolled Windows devices (CONTOSO-LAB-01/02 from earlier labs).
- An account with the **Intune Administrator** role (lab), and an Entra role that can create app registrations and grant admin consent (for Steps 5-6).

## Required licenses

Intune Plan 1. No Azure subscription needed (Step 7 optional Azure Automation is described but not required).

## Steps

### Step 1 - Install the SDK

```powershell
Install-Module Microsoft.Graph.Authentication, Microsoft.Graph.DeviceManagement, Microsoft.Graph.Beta.DeviceManagement -Scope CurrentUser
Get-InstalledModule Microsoft.Graph* | Select-Object Name, Version
```

**Expected result:** Modules installed (versions 2.x).

### Step 2 - Connect with least-privilege delegated scopes

```powershell
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.Read.All' -NoWelcome
Get-MgContext | Select-Object Account, Scopes, AuthType
```

**Expected result:** `AuthType` = Delegated, with only the scope you asked for.

### Step 3 - Stale device report

```powershell
$cutoff = (Get-Date).AddDays(-14)
Get-MgDeviceManagementManagedDevice -All `
    -Property deviceName, operatingSystem, userPrincipalName, lastSyncDateTime, complianceState |
    Where-Object lastSyncDateTime -lt $cutoff |
    Select-Object deviceName, operatingSystem, userPrincipalName, lastSyncDateTime, complianceState |
    Export-Csv -Path .\stale-devices.csv -NoTypeInformation
```

Change `-14` to `-0` if all your lab devices are active, so you get output.

**Expected result:** `stale-devices.csv` with the selected columns.

### Step 4 - Remote action (sync) with a separate scope

```powershell
Disconnect-MgGraph
Connect-MgGraph -Scopes 'DeviceManagementManagedDevices.PrivilegedOperations.All','DeviceManagementManagedDevices.Read.All' -NoWelcome
$device = Get-MgDeviceManagementManagedDevice -Filter "deviceName eq 'CONTOSO-LAB-01'"
Sync-MgDeviceManagementManagedDevice -ManagedDeviceId $device.Id
```

Or run [Invoke-BulkDeviceAction.ps1](../../08-Scripts/graph/Invoke-BulkDeviceAction.ps1) with `-WhatIf` first.

**Expected result:** No error. The device's **Last check-in** updates within minutes. **Tenant administration > Audit logs** shows the action with your account as the actor.

### Step 5 - Beta endpoint and raw requests

```powershell
Connect-MgGraph -Scopes 'DeviceManagementConfiguration.Read.All' -NoWelcome
$uri = 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies?$select=id,name,platforms,technologies'
(Invoke-MgGraphRequest -Method GET -Uri $uri).value |
    ForEach-Object { [pscustomobject]@{ Name = $_.name; Platform = $_.platforms; Tech = $_.technologies } }
Find-MgGraphCommand -Uri '/deviceManagement/configurationPolicies' -ApiVersion beta | Select-Object Command, Permissions
```

**Expected result:** Your settings catalog policies listed. `Find-MgGraphCommand` shows the matching cmdlet and required permissions.

### Step 6 - App-only authentication with a certificate

1. Create a self-signed certificate (lab only):

   ```powershell
   $cert = New-SelfSignedCertificate -Subject 'CN=Intune-Automation-Lab' -CertStoreLocation Cert:\CurrentUser\My -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddMonths(6)
   Export-Certificate -Cert $cert -FilePath .\Intune-Automation-Lab.cer
   ```

2. **Entra admin center > App registrations > New registration** `Intune-Automation-Lab` → **Certificates & secrets > Certificates > Upload** the `.cer`.
3. **API permissions > Add > Microsoft Graph > Application** → `DeviceManagementManagedDevices.Read.All` → **Grant admin consent**.
4. Connect:

   ```powershell
   Connect-MgGraph -ClientId '<application-id>' -TenantId 'contoso.onmicrosoft.com' -CertificateThumbprint $cert.Thumbprint -NoWelcome
   (Get-MgContext).AuthType
   (Get-MgDeviceManagementManagedDevice -All).Count
   ```

**Expected result:** `AuthType` = AppOnly and a device count. Try `Sync-MgDeviceManagementManagedDevice` → **403 Forbidden** (the app doesn't have PrivilegedOperations).

### Step 7 - Export a report with exportJobs

```powershell
.\08-Scripts\graph\Export-IntuneReport.ps1 -ReportName Devices -Columns DeviceName, UPN, OS, OSVersion, LastContact -OutputFolder .\exports
```

(Run with the delegated connection from Step 2 or app-only from Step 6.)

**Expected result:** A CSV in `.\exports` matching **Devices > All devices** export.

*(Optional, costs money)* Move the Step 3 script to an **Azure Automation** runbook with a **system-assigned managed identity** and assign it the `DeviceManagementManagedDevices.Read.All` app role.

## Validation

| Check | Expected |
|---|---|
| Delegated connection with minimum scopes | ✅ |
| Stale device CSV | ✅ |
| Sync action in audit log | Actor = your account |
| App-only read works, privileged action fails | ✅ 403 |
| exportJobs CSV | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| `Insufficient privileges` / 403 | Missing Graph scope or admin consent, or your Intune RBAC role/scope tags don't include the device |
| Only some devices returned | Paging: add `-All` |
| 429 Too Many Requests | Throttling: wait for `Retry-After`, reduce frequency, use `$select` |
| Cmdlet not found | Wrong module (v1.0 vs Beta) - use `Find-MgGraphCommand` |
| Certificate auth fails | Certificate not in `CurrentUser\My` of the running account, or wrong thumbprint/tenant |

## Cleanup / rollback

- Delete the `Intune-Automation-Lab` app registration and remove the certificate from `Cert:\CurrentUser\My`.
- Delete exported CSVs (they contain user names).
- `Disconnect-MgGraph`.

## Stretch challenge

Write a script that exports all **settings catalog** policies (beta `configurationPolicies` with `$expand=settings`) to JSON files, one per policy - a simple configuration-as-code backup.

## Knowledge check

1. Which permission does a script need to **wipe** or **sync** devices?
2. Why is app-only access riskier than delegated access in Intune?
3. What do you do when Graph returns HTTP 429?
4. Which cmdlet shows the permissions needed for a Graph URI?

<details>
<summary>Answers</summary>

1. `DeviceManagementManagedDevices.PrivilegedOperations.All`.
2. App-only calls aren't limited by Intune **RBAC scope tags** - the permission applies to the whole tenant.
3. Wait for the `Retry-After` interval and retry with backoff; reduce request volume (`$select`, `$batch`).
4. `Find-MgGraphCommand`.

</details>
