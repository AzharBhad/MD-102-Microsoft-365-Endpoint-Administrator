# LAB-2.09 - Specialty devices

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.09 | 2.2.5 | 45 min (walkthrough) | Intermediate |

**Goal:** Design and build (in Intune) the configuration for Microsoft Teams Rooms on Windows, HoloLens 2 and Zebra rugged devices, including exclusion filters that protect specialty devices from general policies.

> **Walkthrough mode:** Most readers won't have MTR, HoloLens or Zebra hardware. You can build every Intune object. Validation is by review and knowledge check.

## Prerequisites

- Autopilot knowledge (LAB-2.01/2.03).
- Managed Google Play bound (LAB-1.06).

## Required licenses

Intune Plan 1 for the objects. Specialty device management needs **Intune Plan 2** (Microsoft 365 E3/E5 since July 2026). Teams Rooms Pro licenses for real MTR resource accounts.

## Steps

### Step 1 - MTR device group and exclusion filter

1. Dynamic device group `DG-MTR-Windows`: `(device.devicePhysicalIDs -any (_ -eq "[OrderID]:MTR"))`.
2. **Tenant administration > Filters > Create** → `WIN-EXCL-MTR` → Windows → rule `(device.deviceName -startsWith "MTR-")`.
3. Edit `WIN-Lab-Baseline` (LAB-2.07) → assignment → filter `WIN-EXCL-MTR` in **Exclude** mode.

**Expected result:** The baseline shows the exclude filter on its assignment.

### Step 2 - MTR Autopilot profile

Deployment profile `AP-MTR-SelfDeploying` → **Self-Deploying**, Entra joined, name template `MTR-%SERIAL%` → assign `DG-MTR-Windows`. Document the extra step: in **Windows Autopilot devices** assign the **Teams Rooms resource account** to each MTR device (autologon).

**Expected result:** Profile created.

### Step 3 - MTR compliance policy

`CP-MTR-Windows`: BitLocker Require, Firewall Require, Defender Require, Minimum OS `10.0.22631` → assign `DG-MTR-Windows`. Note: don't include password/Windows Hello requirements.

**Expected result:** Created.

### Step 4 - HoloLens 2

1. Dynamic group `DG-HoloLens`: `(device.deviceOSType -eq "Windows") and (device.deviceModel -eq "HoloLens 2")`.
2. **Configuration > Templates > Kiosk** → `HL2-Kiosk` → *Multi-app kiosk* → target **Windows 10 Holographic for Business** → add Dynamics 365 Guides and Microsoft Edge → assign `DG-HoloLens`.
3. Document the HoloLens Autopilot requirements (self-deploying, Windows Holographic 20H2+, Ethernet or Wi-Fi via provisioning package).

**Expected result:** Kiosk profile created.

### Step 5 - Zebra OEMConfig

1. **Apps > Android > Add > Managed Google Play** → search **Zebra OEMConfig Powered by MX** → **Approve** → sync.
2. **Configuration > Android Enterprise > OEMConfig** → `ZEB-Scanner-Config` → app *Zebra OEMConfig Powered by MX* → configuration designer → *Barcode Configuration*: enable Code 128, disable UPC-E → assign to `SG-Lab-ETG-AE-Dedicated`.
3. Review **Tenant administration > Connectors and tokens > Firmware over-the-air update** (Zebra LifeGuard OTA connector).

**Expected result:** The OEMConfig profile is created with settings from the Zebra schema.

## Validation

- An exclude filter protects MTR devices from general Windows policies.
- Each specialty device type has its own group, enrollment approach and profile.

## Troubleshooting (real hardware)

| Symptom | Fix |
|---|---|
| MTR shows sign-in screen instead of the Teams Rooms app | Resource account not assigned in Autopilot, or conflicting WHfB/password policy |
| HoloLens doesn't pick up the Autopilot profile | Holographic version too old, or not connected to a network during OOBE |
| Zebra OEMConfig not applied | Device not Android Enterprise corporate, or the OEMConfig app not approved/installed |

## Cleanup / rollback

Delete the objects if unused. Keep the MTR exclusion filter pattern for your own tenant.

## Stretch challenge

Write a one-page "specialty device onboarding standard" for your organization, covering enrollment, groups/filters, policies to exclude, and ownership.

## Knowledge check

1. Which Autopilot mode and extra configuration do Teams Rooms on Windows use?
2. How do you configure Zebra-specific scanner settings?
3. Why use exclude filters on broad Windows policies?

<details>
<summary>Answers</summary>

1. **Self-deploying** + assigning the **Teams Rooms resource account** for **autologon**.
2. **OEMConfig** profile with the **Zebra OEMConfig** app.
3. To keep settings like Windows Hello, restart schedules or security baselines from breaking specialty devices, without creating separate groups for every policy.

</details>
