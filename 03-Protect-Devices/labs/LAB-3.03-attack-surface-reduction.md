# LAB-3.03 - Attack surface reduction rules, audit then block

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.03 | 3.1.4 | 60 min | Intermediate |

**Goal:** Deploy ASR rules in audit mode, trigger and read audit events, move selected rules to block, add a per-rule exclusion, and restrict USB storage with device control, applying Zero Trust "assume breach".

## Prerequisites

- CONTOSO-LAB-01 with Microsoft Defender Antivirus active (no third-party AV).
- Microsoft Office installed (Microsoft 365 Apps, [LAB-4.03](../../04-Manage-Secure-Applications/labs/LAB-4.03-m365-apps-intune-odt-autopilot.md)), or use the PowerShell-based test for other rules.
- Optional: onboarded to Defender for Endpoint ([LAB-3.05](LAB-3.05-defender-for-endpoint.md)) for portal reporting.

## Required licenses

Intune Plan 1. Defender for Endpoint (P1+) for full ASR reporting and device control reporting.

## Steps

### Step 1 - ASR rules in audit

**Endpoint security > Attack surface reduction > Create policy** → Windows → **Attack Surface Reduction Rules** → `ASR-Lab-Audit`:

- *Block all Office applications from creating child processes* = **Audit**
- *Block execution of potentially obfuscated scripts* = **Audit**
- *Block Win32 API calls from Office macros* = **Audit**
- *Block credential stealing from the Windows local security authority subsystem* = **Block** (standard protection)
- *Block abuse of exploited vulnerable signed drivers* = **Block**
- *Block persistence through WMI event subscription* = **Block**

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:**

```powershell
Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Actions
# 2 = Audit, 1 = Block, 6 = Warn
```

### Step 2 - Trigger an audit event

Create a Word document with a macro that launches `cmd.exe` (Developer > Visual Basic > `Shell "cmd.exe"`), enable content, run it.

**Expected result:** cmd opens (audit only). Event **1122** appears:

```powershell
Get-WinEvent -LogName 'Microsoft-Windows-Windows Defender/Operational' |
  Where-Object Id -in 1121,1122 | Select-Object -First 5 TimeCreated, Id, Message
```

### Step 3 - Review in Defender (optional)

Defender portal → **Reports > Attack surface reduction rules** → *Detections* → filter Audited.

**Expected result:** The Office child-process audit is listed with the file and device.

### Step 4 - Move to block with an exclusion

Edit `ASR-Lab-Audit` → rename `ASR-Lab-Enforce` → *Block all Office applications from creating child processes* = **Block** → *ASR Only Per Rule Exclusions* for that rule: `C:\Program Files\Contoso\Approved\helper.exe`.

Re-run the macro.

**Expected result:** A Windows Security toast says the action was blocked. Event **1121**.

### Step 5 - Warn mode

Set *Block execution of potentially obfuscated scripts* = **Warn**.

**Expected result:** Users see a warning and can unblock for 24 h (event 1129 when allowed).

### Step 6 - Device control (removable storage)

**Attack surface reduction > Create** → **Device Control** → `DC-Lab-USB`:

- Reusable setting group *Approved USB* (Vendor/Product ID of an approved drive, or a serial).
- Rule 1: **Allow** full access for *Approved USB*.
- Rule 2: **Deny** Write and Execute for all removable storage (`Default`).

Assign to the device group. Insert a USB stick (pass through to the VM, or use a VHD attached as removable if not possible).

**Expected result:** Unapproved USB is read-only. Writing fails with an access denied / notification.

### Step 7 - Map to Zero Trust

Fill in: which of today's controls implement *verify explicitly*, *least privilege*, *assume breach*?

**Expected result:** ASR + device control + network protection = assume breach. LAPS/EPM/no admin = least privilege. Compliance + CA = verify explicitly.

## Validation

- Audit events (1122) then block events (1121) observed.
- The per-rule exclusion works for the approved helper path.
- Unapproved USB writes are blocked.

## Troubleshooting

| Symptom | Fix |
|---|---|
| No ASR events | Defender AV not primary / real-time off / rule GUIDs not applied - check `Get-MpPreference` |
| Macro can't run at all | Office macro policy blocks internet macros (expected in hardened baselines) - run from a trusted location |
| Device control not enforced | Requires a Defender platform version with device control. Check `Get-MpComputerStatus` for DeviceControlState |

## Cleanup / rollback

Set the Office child-process rule back to Audit if it blocks other lab work. Remove the USB deny rule if you need USB.

## Stretch challenge

Hunt in Defender: `DeviceEvents | where ActionType startswith "Asr" | summarize count() by ActionType, FileName`.

## Knowledge check

1. What are the event IDs for ASR block and audit?
2. Which rule stops Office macros from launching PowerShell?
3. Which profile restricts USB writes?

<details>
<summary>Answers</summary>

1. **1121** block, **1122** audit (1129 = user allowed a warn).
2. **Block all Office applications from creating child processes**.
3. **Device Control** (attack surface reduction).

</details>
