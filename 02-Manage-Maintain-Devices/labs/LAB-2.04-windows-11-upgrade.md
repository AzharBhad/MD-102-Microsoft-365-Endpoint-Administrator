# LAB-2.04 - Windows 11 upgrade

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.04 | 2.1.6 | 60 min (+ upgrade time) | Intermediate |

**Goal:** Enable Windows data, assess readiness, and upgrade a device to a newer Windows 11 feature update with a feature update policy using gradual rollout.

## Prerequisites

- A Windows VM on an **older** Windows 11 version (for example 23H2), or a Windows 10 22H2 VM that meets Windows 11 hardware requirements (vTPM, Secure Boot, 4 GB RAM, 64 GB disk).
- Enrolled in Intune and in `DG-Lab-Windows-Corporate`.
- Diagnostic data at **Required** or higher.

## Required licenses

Windows Enterprise E3/E5 (included in M365 E5) for feature update policies and readiness reports.

## Steps

### Step 1 - Enable Windows data

**Tenant administration > Connectors and tokens > Windows data** → *Enable features that require Windows diagnostic data in processor configuration* = **On** → *Windows license verification* = **On** → Save.

**Expected result:** Saved. Reports populate within 24-48 hours.

### Step 2 - Configure diagnostic data on devices

Settings catalog → **System > Allow Telemetry** = *Basic (Required)* or higher → assign to the device group.

**Expected result:** Policy *Succeeded* on the device.

### Step 3 - Run readiness reports

**Reports > Windows updates > Reports > Windows feature update device readiness report** → target *Windows 11, version 25H2* → scope: all → **Generate**. Then run the **compatibility risks** report.

**Expected result:** Your VM appears as *Low risk* / *Upgrade ready* (or *Replace device* if hardware requirements fail).

### Step 4 - Update ring (behavior)

If you don't already have one (LAB-3.07 builds it fully): **Devices > Windows updates > Update rings > Create** → feature update deferral **0**, deadline for feature updates **2** days, grace period **1** → assign to the device group.

**Expected result:** Ring assigned.

### Step 5 - Feature update policy

**Devices > Windows updates > Feature updates > Create** → `FU-Win11-25H2-Pilot` → *Windows 11, version 25H2* → rollout **Make update available gradually** (start today, end in 7 days, 1 day between groups) → assign to the device group.

**Expected result:** Policy created. The device is offered the update within its rollout wave.

### Step 6 - Monitor

**Reports > Windows updates > Feature update report** → select the policy.

**Expected result:** Status moves *Offering → Installing → Installed / Pending restart*. The VM restarts (per deadline) and `winver` shows the new version.

## Validation

```powershell
Get-ComputerInfo | Select-Object OsName, OsVersion, OsBuildNumber
```

The Feature update report shows **Installed** for the device.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Reports empty | Windows data connector off, no license verification, or telemetry too low. Wait 24-48 h |
| Device *Ineligible* | Hardware requirements not met, or a **safeguard hold** (see alert details) |
| Nothing offered | Conflicting policy (for example a ring pausing feature updates, or a GPO/WSUS setting). Check `Get-WindowsUpdateLog` / **Settings > Windows Update** |
| Offered newer than target | Another feature update policy with a higher version targets the device |

## Cleanup / rollback

Keep the policy for LAB-3.07. Feature updates can be rolled back from **Settings > System > Recovery** within 10 days, or via the update ring *Uninstall* action.

## Stretch challenge

Convert a Pro VM to Enterprise via **subscription activation**: sign in with a licensed Entra user and confirm `slmgr /dlv` shows Enterprise without a reboot.

## Knowledge check

1. Which policy type sets the Windows **version** target?
2. What must be enabled for readiness reports?
3. What's a safeguard hold?

<details>
<summary>Answers</summary>

1. **Feature updates for Windows 10 and later** policy.
2. **Windows data** connector + **Windows license verification** (and diagnostic data on devices).
3. A Microsoft-applied block on offering an update to devices with a known compatibility issue.

</details>
