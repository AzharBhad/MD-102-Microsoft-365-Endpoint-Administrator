# LAB-3.07 - Update rings, feature, quality, expedited and driver updates

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.07 | 3.2.1, 3.2.2 | 60 min | Intermediate |

**Goal:** Build a two-ring Windows update plan, pin the feature update version, expedite a quality update, manage drivers, and practise pause/resume/uninstall.

## Prerequisites

- Windows data connector enabled (LAB-2.04).
- Groups: `SG-Lab-Update-Pilot` (CONTOSO-LAB-01), `SG-Lab-Update-Broad` (CONTOSO-LAB-03).

## Required licenses

Update rings: Intune Plan 1. Feature/quality/driver policies: Windows Enterprise E3/E5 (M365 E5).

## Steps

### Step 1 - Write the plan

In your notes, define for each ring: members, quality deferral, deadlines, grace period, feature version, pause authority.

| Ring | Quality deferral | Quality deadline | Feature deadline | Grace |
|---|---|---|---|---|
| Pilot | 0 | 2 | 3 | 1 |
| Broad | 5 | 5 | 7 | 2 |

**Expected result:** A table like the one above.

### Step 2 - Update rings

**Devices > Windows updates > Update rings > Create profile**:

- `UR-Pilot`: quality deferral 0, feature deferral 0, deadlines 2/3, grace 1, active hours 08-17, *Option to pause Windows updates* = Disable → assign `SG-Lab-Update-Pilot`.
- `UR-Broad`: 5 / 0 / 5 / 7 / 2 → assign `SG-Lab-Update-Broad`.

**Expected result:** On the device, **Settings > Windows Update > Advanced options > Configured update policies** lists the deferral and deadline policies.

### Step 3 - Feature update

**Feature updates > Create** → `FU-Win11-Pinned` → the version currently installed on your devices (for example, *Windows 11, version 24H2*) → assign both groups.

**Expected result:** Devices are held on that version (not offered newer ones).

### Step 4 - Expedite a quality update

**Quality updates > Create** → **Expedite** → `QU-Expedite-Latest` → choose the latest security release → *days until restart* = 1 → assign `SG-Lab-Update-Pilot`.

**Expected result:** **Reports > Windows updates > Windows expedited update report** shows CONTOSO-LAB-01 progressing (*Offering → Installed*), even with deferrals.

### Step 5 - Driver updates

**Driver updates > Create** → `DRV-Lab-Manual` → **Manually approve and deploy driver updates** → assign both groups. After ~1 day, open the policy → **Recommended drivers** → **Approve** one (VM drivers may be few) or note that none are applicable.

**Expected result:** The policy shows driver inventory/recommendations when available.

### Step 6 - Pause, resume, uninstall

`UR-Broad` → **Pause** → *Quality* → OK. Then **Resume**. Then explore **Uninstall** (quality) - read the warning but only run it on a disposable VM.

**Expected result:** Ring status shows *Quality updates paused* with an expiry up to 35 days, then resumed.

## Validation

```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update' |
  Select-Object DeferQualityUpdatesPeriodInDays, ConfigureDeadlineForQualityUpdates, ConfigureDeadlineGracePeriod
```

Values match your rings.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Ring settings not applied | GPO/WSUS settings conflict (hybrid) - remove WSUS GPO or set scan source |
| Expedite report empty | Windows data connector / diagnostic data / license verification |
| Device offered newer feature update | Another feature policy targets it, or it isn't in the pinned policy's group |

## Cleanup / rollback

Keep rings for LAB-3.08 (Autopatch will create its own - you'll compare them). Delete `QU-Expedite-Latest` after it completes.

## Stretch challenge

Write a one-page update SLA for Contoso, mapping each ring to business groups and each update type to a target compliance time.

## Knowledge check

1. What's the maximum pause duration for a ring?
2. Which policy overrides quality deferrals for an emergency patch?
3. What's the difference between a deadline and a grace period?

<details>
<summary>Answers</summary>

1. **35 days**.
2. **Expedited** quality update policy.
3. **Deadline** = days after offer before forced install. **Grace period** = minimum days after the deadline before a forced restart (for devices that were offline).

</details>
