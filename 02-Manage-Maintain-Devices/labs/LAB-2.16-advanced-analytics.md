# LAB-2.16 - Advanced Analytics

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.16 | 2.3.6 | 45 min (+ data collection time) | Intermediate |

**Goal:** Onboard devices to Endpoint analytics, deploy a properties catalog, and explore anomalies, the device timeline, battery health, resource performance and device scopes.

> Lab tenants have few devices, so anomaly detection may show no results. Focus on configuration, navigation and interpretation, and use Microsoft's documentation screenshots as reference.

## Prerequisites

- 2+ Windows devices enrolled for at least 24 hours.
- Scope tag `Lab-EU` (LAB-1.09).

## Required licenses

Intune Plan 2 / Suite / Advanced Analytics add-on / Microsoft 365 E3+ (July 2026). Remediations also need Windows Enterprise E3/E5.

## Steps

### Step 1 - Onboard to Endpoint analytics

**Reports > Endpoint analytics > Settings** → confirm the **Intune data collection policy** is assigned to all (or your lab) Windows devices. Check *Connected* status.

**Expected result:** Devices appear in **Startup performance** after ~24 hours.

### Step 2 - Properties catalog

**Devices > Configuration > Create > Windows 10 and later > Properties catalog** → `WIN-Inventory-Lab` → add **Battery**, **BIOS info**, **CPU**, **Disk drive**, **Memory info**, **TPM**, **Video controller**, **Windows QFE** → assign to `DG-Lab-Windows-Corporate`.

**Expected result:** Policy *Succeeded*. **Devices > [device] > Resource Explorer** shows inventory after the collection cycle.

### Step 3 - Device timeline

**Devices > [device] > Device timeline** (or Endpoint analytics > device performance > device).

**Expected result:** Events such as restarts, app crashes and updates in chronological order.

### Step 4 - Battery health and resource performance

**Reports > Endpoint analytics > Battery health** and **Resource performance** → view by device and by model.

**Expected result:** Scores for your devices (VMs may show *no battery* - note it).

### Step 5 - Anomalies

**Reports > Endpoint analytics > Anomalies** → review the columns: severity, anomaly type (app crash / hang / stop error), **device correlation groups**, affected devices.

**Expected result:** Possibly empty in a lab. You can describe how you'd act on a correlation group (driver policy, remediation, update rollback).

### Step 6 - Device scopes

**Endpoint analytics > Settings > Device scopes > Create** → from scope tag `Lab-EU` → switch the report scope at the top of Endpoint analytics.

**Expected result:** Reports now show only devices tagged `Lab-EU`.

### Step 7 - Insights and recommendations

**Endpoint analytics > Overview** → *Insights and recommendations*.

**Expected result:** Recommendations such as startup process impact or SSD upgrades appear where data exists.

## Validation

- Properties catalog deployed. Resource Explorer populated.
- Device scope created and applied.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Endpoint analytics shows no devices | Data collection policy not assigned, diagnostic data too low, or wait 24h |
| Advanced Analytics tabs missing | License not active (up to 48 h after purchase/trial) |
| Resource Explorer empty | Properties catalog not assigned, or collection hasn't run yet |

## Cleanup / rollback

Keep - Domain 5 labs build on this data.

## Stretch challenge

Run **device query for multiple devices** (LAB-2.18) to find devices whose battery capacity is below 80% of design capacity, and add them to a group.

## Knowledge check

1. What does a *device correlation group* in anomalies tell you?
2. Which policy enables fleet inventory for Windows device query?
3. How do you limit Advanced Analytics reports to one region's devices?

<details>
<summary>Answers</summary>

1. The common factor (model, OS build, driver, app version) shared by devices affected by the anomaly.
2. **Properties catalog**.
3. **Device scopes** based on **scope tags**.

</details>
