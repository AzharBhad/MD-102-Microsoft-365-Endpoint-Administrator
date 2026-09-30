# LAB-2.12 - Enterprise App Catalog

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.12 | 2.3.2 | 30 min | Beginner |

**Goal:** Deploy a prepackaged Win32 app from the Enterprise App Catalog, inspect its generated settings, and prepare an update with supersedence.

## Prerequisites

- Enterprise App Management licensed/trial (**Tenant administration > Intune add-ons**).
- A Windows test device in `DG-Lab-Windows-Corporate`.

## Required licenses

Intune Suite / Enterprise App Management add-on / Microsoft 365 E5 (July 2026+).

## Steps

### Step 1 - Add a catalog app

**Apps > Windows > Add** → **Enterprise App Catalog app** → **Search the Enterprise App Catalog** → `7-Zip` → select the x64 package → **Select**.

**Expected result:** App information is prefilled (publisher Igor Pavlov, version, description).

### Step 2 - Review the generated configuration

Step through **Program**, **Requirements** and **Detection rules**. Record:

- Install command
- Uninstall command
- Detection rule type (MSI product code / registry / file)

**Expected result:** All fields prefilled. You understand what Intune will run.

### Step 3 - Assign

Required → `DG-Lab-Windows-Corporate`. Available → `SG-Lab-Users`.

**Expected result:** The device installs 7-Zip (IME log: `IntuneManagementExtension.log` shows download and detection success).

### Step 4 - Check updates

**Apps > Windows** → the catalog app → look for **Update available** (or the **Apps > Monitor > Enterprise App Management** update report).

**Expected result:** If a newer version exists, *Update* creates a new app with **supersedence** configured. If not, note where the prompt will appear.

### Step 5 - Use in Autopilot device preparation

Edit `APDP-UserDriven-Lab` (LAB-2.02) → add the 7-Zip catalog app to the allowed apps list.

**Expected result:** Saved. Catalog apps are valid device preparation apps.

## Validation

- 7-Zip installed on the test device. App status *Installed*.
- You can explain how an update of a catalog app is delivered (new app + supersedence).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Catalog option missing | Add-on not active. Trials can take time to propagate |
| Install fails 0x87D1041C (not detected) | Detection rule mismatch - review, or check that the app installed to the expected path |
| App shows *Pending* | IME polls about every hour. Restart the IME service or sync the device |

## Cleanup / rollback

Uninstall assignment → then delete the app if not needed.

## Stretch challenge

Compare deployment effort for the same app via **Microsoft Store (WinGet)**, **Enterprise App Catalog**, and **manual Win32 packaging** (LAB-4.01). Which would you choose for Chrome, and why?

## Knowledge check

1. What type of Intune app does the Enterprise App Catalog create?
2. How are updates to catalog apps delivered?
3. Where are catalog app binaries hosted?

<details>
<summary>Answers</summary>

1. A **Win32** app.
2. A new app version configured with **supersedence**.
3. In **Microsoft storage** (Microsoft-hosted).

</details>
