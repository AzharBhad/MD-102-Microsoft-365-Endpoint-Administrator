# LAB-3.09 - Apple updates (settings catalog) and Android FOTA

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.09 | 3.2.4, 3.2.5 | 45 min | Intermediate |

**Goal:** Enforce iOS/iPadOS and macOS versions with Declarative Device Management in the settings catalog, delay update visibility, set an Android system update maintenance window with freeze periods, and walk through a FOTA deployment.

## Prerequisites

- APNs + an Apple device optional (iOS 17+ / macOS 14+).
- Android corporate device optional (LAB-1.06).
- FOTA connectors need Zebra/Samsung entitlements - walkthrough otherwise.

## Required licenses

Intune Plan 1. FOTA: Intune Plan 2 (M365 E3+ since July 2026).

## Steps

### Step 1 - iOS DDM software update

**Devices > Configuration > Create > iOS/iPadOS > Settings catalog** → `iOS-DDM-Update` → *Declarative Device Management > Software Update*:

- Target OS Version: the current latest minor release (for example `18.6`)
- Target Local Date Time: 7 days from today, 18:00
- Details URL: `https://contoso.com/updates`

Assign to corporate iOS devices.

**Expected result:** On an iPhone below the target, a notification about the required update appears, with a countdown to the deadline.

### Step 2 - Delay visibility (supervised)

Settings catalog → *Restrictions* → **Force Delayed Software Updates** = True, **Enforced Software Update Delay** = 14 → assign to the same group.

**Expected result:** New Apple releases are hidden for 14 days on supervised devices (DDM targets still take precedence).

### Step 3 - macOS DDM

`macOS-DDM-Update` → Target OS Version `15.6` (example), deadline 10 days out → assign to Macs.

**Expected result:** The Mac shows *A required update is available*, then installs by the deadline.

### Step 4 - Android system update window

**Android Enterprise > Fully managed, dedicated, COPE > Device restrictions** → `AE-SystemUpdate-Window`:

- System update: **Maintenance window**, 01:00-05:00
- Freeze periods: add 11/25 → 12/05

Assign to `SG-Lab-ETG-AE-FullyManaged`.

**Expected result:** Profile *Succeeded* on the device. OEM updates install only in the window.

### Step 5 - FOTA walkthrough

**Tenant administration > Connectors and tokens > Firmware over-the-air update** → view the **Zebra** and **Samsung** connector options. Read the steps for each:

- Zebra: connect → **Devices > Android FOTA deployments > Create** → target group → choose LifeGuard update → schedule.
- Samsung: connect Knox E-FOTA → deploy *Knox E-FOTA* + *Knox Service Plugin* apps → OEMConfig with firmware controls → register groups → create deployment.

**Expected result:** You can explain the difference between a system update policy (when) and FOTA (which firmware).

### Step 6 - Compliance backstop

Edit `CP-iOS-Baseline` (LAB-1.11) → *Minimum OS version* = the target from Step 1. Create/Edit an Android compliance policy → *Minimum security patch level* = a recent date.

**Expected result:** Devices that miss deadlines become noncompliant → CA blocks access.

## Validation

| Platform | Evidence |
|---|---|
| iOS/macOS | DDM declaration status: pending/installed. Device OS version |
| Android | Maintenance window configured, freeze period listed |
| Compliance | Min OS/patch rules present |

## Troubleshooting

| Symptom | Fix |
|---|---|
| DDM policy "Not applicable" | OS below iOS 17 / macOS 14 |
| Update doesn't install at deadline | Device off power/Wi-Fi, low storage, or passcode prompt pending |
| Android window ignored | Personally owned work profile (not supported), or OEM doesn't honour the policy |

## Cleanup / rollback

Remove the deadline policies if you don't want lab devices forced to update.

## Stretch challenge

Design an update approach for 200 shared iPads in retail stores: deadlines outside opening hours, power/Wi-Fi requirements, and CA behaviour for devices that miss the deadline.

## Knowledge check

1. Which Intune feature replaces deprecated Apple MDM update policies?
2. What's the maximum total freeze period per year for Android system updates?
3. Which FOTA integrations does Intune support?

<details>
<summary>Answers</summary>

1. **Settings catalog > Declarative Device Management > Software Update**.
2. **90 days**.
3. **Samsung Knox E-FOTA** and **Zebra LifeGuard OTA**.

</details>
