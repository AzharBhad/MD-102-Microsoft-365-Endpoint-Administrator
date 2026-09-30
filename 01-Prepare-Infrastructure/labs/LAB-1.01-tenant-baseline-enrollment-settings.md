# LAB-1.01 - Tenant baseline and enrollment restrictions

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.01 | 1.2.1 | 45 min | Beginner |

**Goal:** Prepare the Intune tenant so only the platforms and device counts you allow can enroll, and users see a branded Company Portal.

## Prerequisites

- Lab tenant from [lab-environment-setup.md](../../00-Getting-Started/lab-environment-setup.md) with `SG-Lab-Users` and `SG-Lab-Pilot-Users`.
- Account with **Intune Administrator**.

## Required licenses

Microsoft 365 E5 (or Intune Plan 1 + Entra ID P1) for lab users.

## Steps

### Step 1 - Confirm the MDM authority and licences

1. Intune admin center → **Tenant administration > Tenant status > Tenant details**.
2. Note *MDM authority*, *Total licensed users*, and *Total Intune licenses*.

**Expected result:** *MDM authority = Microsoft Intune*. Licensed users ≥ 6.

### Step 2 - Brand the Company Portal

1. **Tenant administration > Customization > Default policy > Edit**.
2. Set *Organization name* `Contoso Lab`, a theme colour, the IT contact name/email `it-support@contoso.onmicrosoft.com`, and a privacy statement URL (`https://contoso.com/privacy` as a placeholder).
3. Under *Enrollment*, set **Device enrollment** = *Available, with prompts*.
4. **Review + save**.

**Expected result:** The policy shows *Last modified* = now.

### Step 3 - Create a strict platform restriction for pilot users

1. **Devices > Enrollment > Device platform restriction > Windows restrictions > Create restriction**.
2. Name `PR-Windows-Pilot`. Windows (MDM) = **Allow**. *Minimum version* `10.0.22631` (Windows 11 23H2). *Personally owned devices* = **Block**.
3. Assign to `SG-Lab-Pilot-Users` → **Create**.
4. Repeat on the **Android restrictions** tab: `PR-Android-Pilot` → Android Enterprise (work profile) = Allow, **Android device administrator = Block** → assign `SG-Lab-Pilot-Users`.

**Expected result:** Both restrictions show **Priority 1** on their tabs. *All Users* stays at the bottom (Default).

### Step 4 - Create a device limit restriction

1. **Devices > Enrollment > Device limit restriction > Create restriction** → `DL-Pilot-3` → Device limit **3** → assign `SG-Lab-Pilot-Users`.

**Expected result:** Priority 1 above the default (limit 5).

### Step 5 - Add corporate device identifiers (Windows)

1. **Devices > Enrollment > Corporate device identifiers > Add > Upload CSV**, type **Manufacturer, model and serial number (Windows only)**.
2. CSV content (use your VM's values from `Get-CimInstance Win32_ComputerSystem` / `Win32_BIOS`):

   ```text
   Microsoft Corporation,Virtual Machine,LAB-SERIAL-0001
   ```

**Expected result:** The identifier appears with state *Not contacted*.

### Step 6 - Create a device category and enrollment notification

1. **Devices > Device categories > Create** → `Finance`, `Engineering`.
2. **Devices > Enrollment > Windows > Enrollment notifications > Create notification** → email + push → assign `SG-Lab-Users`.

**Expected result:** Categories are listed. The notification policy is assigned.

## Validation

| Check | How | Pass criteria |
|---|---|---|
| Restriction priority | Platform restriction tab | Pilot policy priority 1 |
| Effective restriction for user1 | **Troubleshooting + support > Troubleshoot** → user1 → *Enrollment restrictions* | Shows `PR-Windows-Pilot` and `DL-Pilot-3` |
| Company Portal branding | `https://portal.manage.microsoft.com` as user1 | Contoso Lab branding visible |

## Troubleshooting

| Problem | Fix |
|---|---|
| Can't create restriction - greyed out | You need the *Enrollment programs* / *Device enrollment* permissions (Policy and Profile Manager or Intune Administrator) |
| user1 still gets default policy | Check user1 is in `SG-Lab-Pilot-Users`. Group changes can take a few minutes |
| CSV upload fails | No header row, comma-separated, and the Windows format needs exactly three columns |

## Cleanup / rollback

Keep everything - later labs use these settings. To roll back: delete `PR-*`/`DL-*` restrictions and reset customization.

## Stretch challenge

Use Graph to export all enrollment configurations with their priorities to CSV (`deviceManagement/deviceEnrollmentConfigurations`). Explain why the *Default* restriction has priority `0` in Graph yet shows last in the portal.

## Knowledge check

1. A user is in two groups with platform restrictions at priority 1 and priority 3. Which applies?
2. You block personally owned Windows devices. Which enrollment methods still succeed without corporate identifiers?
3. What's the maximum value for an Intune device limit restriction?
4. Where do you stop Android device administrator enrollment?

<details>
<summary>Answers</summary>

1. Only the **priority 1** restriction. Restrictions aren't merged.
2. Windows Autopilot, bulk enrollment (provisioning package), device enrollment manager, Group Policy (hybrid) auto-enrollment, and co-management.
3. **15** devices.
4. **Device platform restriction** → Android tab → *Android device administrator* = **Block**.

</details>
