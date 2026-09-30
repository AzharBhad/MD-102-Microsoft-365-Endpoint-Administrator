# LAB-5.03 - Custom compliance with PowerShell

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.03 | 5.1.5 | 45 min | Intermediate |

**Goal:** Extend Windows compliance with a PowerShell discovery script and JSON rules (Defender for Endpoint sensor running, free disk space, minimum BIOS date), break one rule on purpose, and see the result in Company Portal and Intune.

## Prerequisites

- CONTOSO-LAB-01 (Windows 11 Enterprise/Pro, Entra joined, enrolled) and a user who signs in to it.
- Sample files: [Discover-ContosoCompliance.ps1](../../08-Scripts/compliance/Discover-ContosoCompliance.ps1) and [contoso-compliance-rules.json](../../08-Scripts/compliance/contoso-compliance-rules.json).
- Device group `DG-Lab-CustomCompliance` containing CONTOSO-LAB-01.

## Required licenses

Intune Plan 1 (plus Defender for Endpoint if you want the EDR rule to pass; otherwise expect it to fail).

## Steps

### Step 1 - Test the script locally

On CONTOSO-LAB-01 (elevated PowerShell):

```powershell
.\Discover-ContosoCompliance.ps1
```

**Expected result:** One line of JSON, for example `{"DiskFreePct":41,"BiosReleaseDate":"2025-03-11T00:00:00","EdrSensorRunning":true}`.

### Step 2 - Upload the discovery script

**Devices > Compliance > Scripts > Add > Windows 10 and later** → name `CC-Discovery-Contoso` → paste the script →

- Run this script using the logged on credentials: **No**
- Enforce script signature check: **No** (lab)
- Run script in 64 bit PowerShell Host: **Yes**

**Expected result:** Script listed under compliance scripts.

### Step 3 - Create the compliance policy

**Devices > Compliance > Create policy > Windows 10 and later** → `CP-WIN-CustomChecks` → **Custom Compliance** = Require → *Select your discovery script* `CC-Discovery-Contoso` → upload `contoso-compliance-rules.json` → review the parsed rules (setting name, operator, operand, data type).

Actions for noncompliance: **Mark device noncompliant** immediately (lab). Assign to `DG-Lab-CustomCompliance`.

**Expected result:** Policy created with three custom rules.

### Step 4 - Evaluate

On the device: **Company Portal > Devices > CONTOSO-LAB-01 > Check status** (Check compliance). Or wait for the 8-hour cycle.

In Intune: device → **Device compliance** → `CP-WIN-CustomChecks` → per-setting status.

**Expected result:** Each custom setting shows Compliant or Not compliant, next to built-in settings.

### Step 5 - Break a rule on purpose

Edit the JSON: change the `DiskFreePct` operand from `10` to `95` → upload the new JSON to the policy → **Check compliance** again.

**Expected result:** Device becomes **Not compliant**. Company Portal shows the **remediation string** title and description from the JSON with the *More info* link. If Conditional Access requires compliant devices ([LAB-1.11](../../01-Prepare-Infrastructure/labs/LAB-1.11-compliance-conditional-access.md)), access to Microsoft 365 is blocked from this device.

### Step 6 - Restore and review logs

Set the operand back to `10`, re-upload, check compliance. Review `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\IntuneManagementExtension.log` for the script run.

**Expected result:** Device compliant again.

## Validation

| Check | Expected |
|---|---|
| Script outputs single-line JSON | ✅ |
| Custom rules visible in device compliance | ✅ |
| Broken rule → noncompliant with remediation text | ✅ |
| Restored → compliant | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Rule shows *Error* / *Not applicable* | `SettingName` doesn't match the JSON key (case-sensitive), or wrong `DataType` |
| Nothing evaluated | IME not installed yet, device not in group, or waiting for the 8-hour cycle - use Check compliance |
| JSON upload rejected | Invalid JSON, missing `en_US` remediation string, or unsupported operator |
| Script returns multiple lines | Add `-Compress` to `ConvertTo-Json` and don't `Write-Output` anything else |

## Cleanup / rollback

Unassign `CP-WIN-CustomChecks` (or keep it in report-only style without CA). A discovery script can't be deleted until it's removed from the policy.

## Stretch challenge

Add a rule for **Windows version** using `DataType` = `Version` and `GreaterEquals` (for example, 10.0.26100), returned by the script from `[Environment]::OSVersion.Version`. Then pair it with a **remediation** ([LAB-5.05](LAB-5.05-endpoint-analytics-remediations.md)) that fixes one of the conditions automatically.

## Knowledge check

1. What must the last line of a Windows discovery script do?
2. How often does the IME run discovery scripts?
3. Where do users see how to fix a failing custom setting?
4. How many discovery scripts can one compliance policy use?

<details>
<summary>Answers</summary>

1. Return compressed JSON: `return $hash | ConvertTo-Json -Compress`.
2. **Every 8 hours** (and when the user selects Check compliance).
3. In **Company Portal**, from the JSON **RemediationStrings** (and `MoreInfoUrl`).
4. **One** (and each script can be used by only one policy).

</details>
