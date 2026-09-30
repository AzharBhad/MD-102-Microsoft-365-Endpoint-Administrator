# LAB-2.18 - KQL device query and diagnostics collection

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.18 | 2.4.6, 2.4.7 | 45 min | Intermediate |

**Goal:** Query a single device and the fleet with KQL, collect diagnostics remotely, and troubleshoot a user with the Troubleshooting blade.

## Prerequisites

- CONTOSO-LAB-01 online, corporate-owned.
- Properties catalog deployed (LAB-2.16) and inventory collected.
- Advanced Analytics active.

## Required licenses

Advanced Analytics (Plan 2 / Suite / M365 E3+ July 2026) for device query. Intune Plan 1 for diagnostics.

## Steps

### Step 1 - Single device query

**Devices > Windows > CONTOSO-LAB-01 > Device query** → run each:

```kusto
EncryptableVolume | project DriveLetter, ProtectionStatus, EncryptionMethod
```

```kusto
LocalUserAccount | project Username, Enabled, LastLogon
```

```kusto
Process | order by WorkingSetSizeBytes desc | take 5 | project ProcessName, WorkingSetSizeBytes
```

```kusto
WindowsEvent('System', 1d) | where Level == "Error" | take 10
```

**Expected result:** Results in seconds. The Administrator account shows as enabled (LAPS).

> If a column name errors, open the **properties pane** on the left and use the exact names shown (the schema evolves).

### Step 2 - Copilot-generated KQL (optional)

Open **Copilot** in the device query pane: *"Show me expired certificates on this device"*.

**Expected result:** Copilot proposes a KQL query and explains it.

### Step 3 - Query the fleet

**Devices > Device query** →

```kusto
Tpm
| project Device, SpecVersion, Activated, Enabled
```

```kusto
Device
| summarize Count = count() by Manufacturer = Device.Manufacturer
```

Select a result set → **Add all items to a group** → `SG-Lab-Query-Result` → **Export** CSV.

**Expected result:** A static group containing the devices, and a CSV download.

### Step 4 - Collect diagnostics

CONTOSO-LAB-01 → **Collect diagnostics** → wait → **Device diagnostics** tab → **Download**.

Open the ZIP and locate: `MDMDiagReport.html`, `IntuneManagementExtension.log`, `dsregcmd` output, event logs.

**Expected result:** Collection *Complete* in minutes. Files present.

### Step 5 - Troubleshooting blade

**Troubleshooting + support > Troubleshoot** → **Select user** → user3 → review Devices, Policies (filter by device), Applications, **Enrollment failures**, App protection status.

**Expected result:** A single view of everything assigned to user3 and its status per device.

### Step 6 - Correlate

Pick one failed or pending item from Step 5 and find its evidence in the diagnostics ZIP (for example, an app install error in the IME log).

**Expected result:** You can trace the portal status to a log line.

## Validation

- Single-device query returned live data.
- A fleet query result became an Entra group.
- The diagnostics ZIP downloaded and was reviewed.

## Troubleshooting

| Symptom | Fix |
|---|---|
| *Device query not available* | License missing, personal device, or device offline |
| Fleet query returns nothing | No properties catalog / inventory not collected yet |
| Collect diagnostics greyed out | Personal device, unsupported OS build, or *Device diagnostics* disabled in tenant settings |

## Cleanup / rollback

Delete `SG-Lab-Query-Result` when finished.

## Stretch challenge

Write a fleet query that finds devices where BitLocker protection is off, then assign a remediation or the disk encryption policy to the resulting group (Domain 3 / Domain 5).

## Knowledge check

1. What's the difference between the data returned by a single-device query and a multiple-device query?
2. Where do you download diagnostics collected from a device, and for how long are they kept?
3. Which blade gives a user-centric view across all a user's devices?

<details>
<summary>Answers</summary>

1. Single = **live** state from the online device. Multiple = **collected inventory** in the cloud.
2. Device → **Device diagnostics** tab. Kept **28 days**.
3. **Troubleshooting + support > Troubleshoot** (select user).

</details>
