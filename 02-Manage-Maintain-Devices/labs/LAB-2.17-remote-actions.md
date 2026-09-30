# LAB-2.17 - Remote actions

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.17 | 2.4.1, 2.4.2, 2.4.3, 2.4.4, 2.4.5 | 75 min | Intermediate |

**Goal:** Practise sync, restart, retire and wipe; run bulk actions from the portal and Graph; update Defender security intelligence; rotate BitLocker recovery keys and LAPS passwords; and audit everything.

## Prerequisites

- CONTOSO-LAB-01 (LAPS from LAB-1.13) and CONTOSO-LAB-03.
- A **disposable** device for retire/wipe (for example the LAB-2.02 VM, or CONTOSO-LAB-02 registered).
- BitLocker enabled with key escrow to Entra ID and **client-driven recovery password rotation** enabled (complete LAB-3.02 first, or enable BitLocker manually and back up the key: `BackupToAAD-BitLockerKeyProtector`).
- Multi Admin Approval for Device actions **removed or ready** (LAB-1.10) - otherwise expect approval requests.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Sync and restart

CONTOSO-LAB-01 → **Sync** → then **Restart**.

**Expected result:** *Last check-in* updates. The VM restarts. **Devices > Monitor > Device actions** lists both.

### Step 2 - Update Defender security intelligence

Record the current version on the device: `(Get-MpComputerStatus).AntivirusSignatureVersion` → Intune → **Update Windows Defender security intelligence** → wait → check again. Then run **Quick scan**.

**Expected result:** Version/timestamp updated (if a newer version was available). The quick scan appears in the Defender history.

### Step 3 - Rotate the BitLocker recovery key

Note the current key ID: `manage-bde -protectors -get C:` → Intune → **BitLocker key rotation** → sync → check again. Intune → device → **Recovery keys**.

**Expected result:** A new numerical password ID. A new key listed in Intune with the current date.

### Step 4 - Rotate the LAPS password

Intune → **Rotate local admin password** → sync → **Local admin password** blade.

**Expected result:** *Last rotation* updated. The old password no longer works.

### Step 5 - Bulk action in the portal

**Devices > All devices > Bulk device actions** → Windows → **Sync** → select CONTOSO-LAB-01 and -03 → create. Repeat with **Rename** (template `LAB-{{serialnumber}}`) on a test device only.

**Expected result:** Two per-device entries in **Device actions**. The renamed device shows the new name after its restart.

### Step 6 - Bulk action with Graph

```powershell
cd 08-Scripts/graph
.\Invoke-BulkDeviceAction.ps1 -Action Sync -OperatingSystem Windows -WhatIf
.\Invoke-BulkDeviceAction.ps1 -Action Sync -OperatingSystem Windows
```

**Expected result:** `-WhatIf` lists target devices. The real run queues syncs and writes a summary.

### Step 7 - Retire and wipe (disposable device)

1. Registered/personal device → **Retire**.
2. Corporate test VM → **Wipe** → select **Retain enrollment state and user account** → confirm.

**Expected result:** The retired device loses Intune-managed apps/profiles and leaves Intune. The wiped VM resets but stays enrolled/joined.

### Step 8 - Audit

**Tenant administration > Audit logs** → filter *Activity* containing `Wipe`, `Retire`, `rotate`.

**Expected result:** Entries showing initiator, target and time.

## Validation

| Action | Evidence |
|---|---|
| Defender update | New signature version / timestamp |
| BitLocker rotation | New key ID in Intune + `manage-bde` |
| LAPS rotation | New *Last rotation* time |
| Bulk | Per-device entries in Device actions |
| Retire/Wipe | Device state + audit log |

## Troubleshooting

| Symptom | Fix |
|---|---|
| BitLocker rotation fails | Client-driven rotation not enabled, key not escrowed to Entra, or OS too old |
| LAPS rotation *pending* | Device offline. Sync when online |
| Wipe stuck pending | Device offline, or MAA approval pending |
| Rename not applied | Needs restart. Entra joined Windows only |

## Cleanup / rollback

Re-enroll the wiped test device if needed. Keep CONTOSO-LAB-01/03.

## Stretch challenge

Extend `Invoke-BulkDeviceAction.ps1` to accept a CSV of device names and write a results CSV.

## Knowledge check

1. What's the maximum number of devices per portal bulk action run?
2. Which wipe option keeps the device Entra joined and enrolled?
3. What must be enabled before Intune can rotate BitLocker keys?

<details>
<summary>Answers</summary>

1. **100**.
2. **Retain enrollment state and user account**.
3. **Client-driven recovery password rotation** + key escrow to Entra ID.

</details>
