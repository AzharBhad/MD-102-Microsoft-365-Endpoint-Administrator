# LAB-4.04 - Cloud Policy and the Microsoft 365 Apps admin center

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.04 | 4.1.5, 4.1.7 | 45 min | Beginner |

**Goal:** Apply user-based Office policies with the Cloud Policy service (including on an unmanaged device), then use Inventory, Security update status and cloud update in the Microsoft 365 Apps admin center.

## Prerequisites

- Microsoft 365 Apps installed on at least one device (LAB-4.03) and signed in by user3.
- Optional: a personal/unenrolled Windows VM with Office signed in as user4.
- **Office Apps Administrator** role assigned to your admin (or use Intune/Global Administrator).

## Required licenses

Microsoft 365 E3/E5 (Microsoft 365 Apps for enterprise).

## Steps

### Step 1 - Cloud Policy (macros + default save location)

`config.office.com` → **Customization > Policy Management > Create** (or Intune **Apps > Policies for Microsoft 365 apps > Create**) → `OFF-Security-Lab`:

- Scope: users in `SG-Lab-Users`
- Filter *Recommendation* = **Security baseline** → set *Block macros from running in Office files from the internet* (Word, Excel, PowerPoint) = Enabled
- *VBA Macro Notification Settings* (Word) = Disable all except digitally signed macros
- *Default location for new files* not required - optional

**Expected result:** The policy is listed with priority 1.

### Step 2 - Verify on devices

On CONTOSO-LAB-03 (managed) and the unmanaged VM, restart Word (policy fetch at app start, then about every 90 min).

```powershell
Get-ItemProperty 'HKCU:\Software\Policies\Microsoft\Cloud\Office\16.0\Word\Security' -ErrorAction SilentlyContinue
```

**Expected result:** Cloud policy values appear under `HKCU\Software\Policies\Microsoft\Cloud\...` on **both** devices - including the one not enrolled in Intune.

### Step 3 - Inventory

**Inventory** → complete onboarding if prompted → open device list.

**Expected result:** Your devices with channel (Monthly Enterprise), version, build, architecture and last user.

### Step 4 - Security update status

**Health > Security update status** → run the setup → set a **goal** (95% in 7 days).

**Expected result:** Up to date / Not up to date counts per channel (may take ~2 hours for first data).

### Step 5 - Cloud update

**Servicing > Cloud update** → select the **Monthly Enterprise** profile → review settings:

- Rollout waves: create *Wave 1* = `SG-Lab-Pilot-Users` devices, *Wave 2* = everyone else
- **Exclusion window**: last 3 days of each month
- **Exclude group**: a group for VDI/non-persistent machines

Enable the profile (lab) and view the device list and update status.

**Expected result:** Devices listed with *Up to date / Updating*. Pause and **Roll back** actions are available.

### Step 6 - Office Customization Tool

**Customization > Device configuration** → open the configuration from LAB-4.03 → note you can edit and re-export it.

**Expected result:** You know where the ODT XML lives.

## Validation

| Check | Expected |
|---|---|
| Cloud Policy on unmanaged device | ✅ registry keys present |
| Inventory | Devices listed |
| Cloud update | Profile active, waves and exclusion window configured |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Policy not applied | User not in the group, Office not signed in with work account, or wait ~90 min |
| Inventory empty | Onboarding not completed, or devices need diagnostic connectivity to `*.config.office.com` |
| Cloud update greyed out | Role missing (Office Apps Administrator) or unsupported cloud (GCC) |

## Cleanup / rollback

Disable cloud update if you don't want it managing lab devices. Keep the Cloud Policy.

## Stretch challenge

Configure the same macro setting in the Intune **settings catalog** (Word 2016 > Security > Trust Center) with a **different** value and prove which one wins.

## Knowledge check

1. Which tool applies Office policies to users on unmanaged devices?
2. Which feature replaced servicing profiles for Office update management?
3. What's the least-privilege role for the Microsoft 365 Apps admin center?

<details>
<summary>Answers</summary>

1. **Cloud Policy service** (config.office.com / Intune *Policies for Microsoft 365 apps*).
2. **Cloud update**.
3. **Office Apps Administrator**.

</details>
