# LAB-3.06 - App Control for Business

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.06 | 3.1.8 | 60 min | Advanced |

**Goal:** Designate the Intune Management Extension as a managed installer, deploy an App Control for Business policy in audit mode with built-in controls, read CodeIntegrity events, then enforce on a test device.

> ⚠️ Enforced App Control can block tools you need. Use a **dedicated test VM** with a checkpoint.

## Prerequisites

- A test VM (for example, CONTOSO-LAB-04) enrolled, with a checkpoint.
- A Win32 app deployable via Intune (7-Zip from [LAB-2.12](../../02-Manage-Maintain-Devices/labs/LAB-2.12-enterprise-app-catalog.md) or [LAB-4.01](../../04-Manage-Secure-Applications/labs/LAB-4.01-win32-packaging-troubleshooting.md)).
- A "rogue" portable EXE downloaded manually (for example, a portable utility not installed via Intune).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Managed installer

**Endpoint security > App Control for Business > Managed installer** tab → **Add** → enable **Intune Management Extension** as managed installer → confirm.

**Expected result:** Status shows the managed installer policy deployed. Apps installed by the IME **from now on** are tagged.

### Step 2 - Install an app via Intune

Assign 7-Zip as **Required** to the test VM (or reinstall it so it's written after Step 1).

**Expected result:** 7-Zip installs. Its binaries carry the managed-installer origin claim.

### Step 3 - Audit policy (built-in controls)

**App Control for Business > Create policy** → `ACB-Lab-Audit` → Configuration settings format **Built-in controls**:

- *Enable trust of Windows components and store apps* = **Audit only**
- *Trust apps with good reputation* ✔
- *Trust apps from managed installers* ✔

Assign to the test VM group.

**Expected result:** Policy *Succeeded*.

### Step 4 - Generate audit events

Run the rogue portable EXE, 7-Zip, Notepad, and a Store app.

```powershell
Get-WinEvent -LogName 'Microsoft-Windows-CodeIntegrity/Operational' -MaxEvents 50 |
  Where-Object Id -in 3076,3077 | Select-Object TimeCreated, Id, Message -First 10
```

**Expected result:** Event **3076** (audit - would have been blocked) for the rogue EXE. No events for Windows components, 7-Zip (managed installer) or reputable apps.

### Step 5 - Enforce

Edit the policy (or create `ACB-Lab-Enforce`) → *Enable trust of Windows components and store apps* = **Enabled** → sync → restart if prompted.

Run the rogue EXE again.

**Expected result:** Blocked with a "Your organization used App Control for Business to block this app" message and event **3077**. 7-Zip still runs.

### Step 6 - Supplemental policy (optional)

Use the **App Control Wizard** (`webapp-wdac-wizard.azurewebsites.net` or the desktop app) → *Supplemental policy* → base PolicyID from the built-in controls table in the Intune docs → add a publisher/hash rule for the rogue tool → export XML → Intune **Create policy** → **Enter xml data** → upload → assign to the same VM.

**Expected result:** The previously blocked tool runs.

## Validation

| App | Audit mode | Enforce mode |
|---|---|---|
| Windows components / Store apps | Allowed | Allowed |
| 7-Zip via Intune (managed installer) | Allowed | Allowed |
| Rogue portable EXE | Event 3076 | **Blocked** (3077) |

## Troubleshooting

| Symptom | Fix |
|---|---|
| 7-Zip blocked in enforce | Installed **before** the managed installer was enabled - reinstall via Intune or add a rule |
| Nothing is audited | Policy not applied (check `CiTool -lp` on Windows 11 for active policies) |
| Device won't boot/sign-in issues | Restore the checkpoint. Always test enforce on disposable VMs first |

## Cleanup / rollback

Unassign/delete the enforce policy, restore the checkpoint, or set it back to audit. Remove the managed installer only if you don't need it (it's an AppLocker rule collection on the device).

## Stretch challenge

Query all App Control audit events across onboarded devices in Defender advanced hunting:

```kusto
DeviceEvents
| where ActionType startswith "AppControl"
| summarize count() by ActionType, FileName, DeviceName
```

## Knowledge check

1. What does the managed installer do?
2. Which event ID indicates an audit-mode would-have-blocked?
3. When do you need a supplemental policy?

<details>
<summary>Answers</summary>

1. It tags files written by the designated installer (the **Intune Management Extension**) so App Control trusts them automatically.
2. **3076** (3077 = enforced block).
3. To **extend** a base policy with extra rules (specific apps/teams) without editing the base.

</details>
