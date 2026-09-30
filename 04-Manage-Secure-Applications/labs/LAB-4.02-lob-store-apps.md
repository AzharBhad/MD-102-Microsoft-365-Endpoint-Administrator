# LAB-4.02 - LOB and Microsoft Store apps

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.02 | 4.1.2 | 40 min | Beginner |

**Goal:** Deploy a Windows MSI line-of-business app and Microsoft Store (new) apps with Required, Available and Uninstall intents, and compare how each is delivered and updated.

## Prerequisites

- A small MSI (for example, a lab MSI from a vendor, or the 7-Zip MSI - using a different app name to avoid clashing with LAB-4.01).
- CONTOSO-LAB-03 with user3.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Windows LOB (MSI)

**Apps > Windows > Create > Line-of-business app** → upload the `.msi` → *Publisher* required → *App install context* Device → *Ignore app version* = No → assign **Required** to `DG-Lab-Windows-Corporate`.

**Expected result:** Installed. On the device, `Get-Package` lists it. Note that the LOB app is delivered by **MDM** (EnterpriseDesktopAppManagement), not the IME.

### Step 2 - Microsoft Store app (new) - Required

**Apps > Windows > Create > Microsoft Store app (new)** → search **Company Portal** → *Installation behavior* System → assign **Required** to devices.

**Expected result:** Company Portal installs. **IntuneManagementExtension.log** shows a WinGet-based install.

### Step 3 - Microsoft Store app (new) - Available

Add **Microsoft PowerToys** → *Installation behavior* User → assign **Available** to `SG-Lab-Users`.

**Expected result:** PowerToys appears in Company Portal for user3 → install works without admin rights.

### Step 4 - Uninstall intent

Edit the MSI LOB app assignments: keep the **Required** assignment, and add a device group that contains CONTOSO-LAB-03 under **Uninstall**.

**Expected result:** The app is removed from devices in the Uninstall group (Uninstall wins over Required).

### Step 5 - Compare

Complete the table:

| | LOB MSI | Store app (new) |
|---|---|---|
| Delivered by | | |
| Updates | | |
| Supports supersedence/dependencies | | |

**Expected result:** MDM / manual re-upload / No vs IME+WinGet / automatic from Store / No.

## Validation

- Store app installs even though the Microsoft Store UI may be blocked by policy (only the *private store*/Store UI settings affect users).
- Uninstall intent removes the MSI.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Store app fails 0x8A15000F-type WinGet errors | Store/WinGet sources blocked by proxy, or app not available in the device's region |
| MSI LOB fails in Autopilot | Mixing with Win32 in ESP - repackage as Win32 |
| Available app not in Company Portal | Assigned to a device group (not supported for Available), or user not in group |

## Cleanup / rollback

Remove test assignments. Keep Company Portal Required.

## Stretch challenge

Add an **MSIX** package signed with a lab certificate and deploy the signing certificate with a **Trusted certificate** profile first.

## Knowledge check

1. What replaced the Microsoft Store for Business in Intune?
2. Which intent wins if a device gets Required and Uninstall?
3. Can you assign *Available* to device groups for Win32 apps?

<details>
<summary>Answers</summary>

1. **Microsoft Store app (new)** (WinGet-backed).
2. **Uninstall**.
3. **No** - Available (enrolled devices) targets **user** groups.

</details>
