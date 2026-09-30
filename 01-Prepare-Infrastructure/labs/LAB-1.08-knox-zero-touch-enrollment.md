# LAB-1.08 - Knox Mobile Enrollment and zero-touch

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.08 | 1.2.6 | 40 min (walkthrough) | Intermediate |

**Goal:** Configure the Intune side of Google zero-touch and Samsung Knox Mobile Enrollment, build the DPC-extras JSON correctly, and map zero-touch configurations to Intune enrollment profiles.

> **Walkthrough mode:** Real zero-touch requires devices registered by an authorized reseller. KME requires Samsung devices and a Knox account (free). You can link a zero-touch **customer account** only if a reseller created one for you. Complete the JSON and mapping tasks regardless - that's what the exam tests.

## Prerequisites

- [LAB-1.06](LAB-1.06-android-enterprise-enrollment-profiles.md) (Managed Google Play bound and corporate profiles `AE-COBO-Lab`, `AE-COSU-Kiosk` created).
- Optional: a zero-touch customer account, or a Samsung Knox account with a Samsung Galaxy device and the **Knox Deployment App** on a second Samsung device.

## Required licenses

Intune Plan 1 / device-only licenses. KME and zero-touch are free.

## Steps

### Step 1 - Collect the enrollment tokens

Open `AE-COBO-Lab` and `AE-COSU-Kiosk` → **Token** → copy each *token* string (not the QR image).

**Expected result:** Two tokens saved in your notes (they're lab-only; never publish real ones).

### Step 2 - Build the DPC extras JSON

Create two JSON snippets, one per profile:

```json
{
  "android.app.extra.PROVISIONING_ADMIN_EXTRAS_BUNDLE": {
    "com.google.android.apps.work.clouddpc.EXTRA_ENROLLMENT_TOKEN": "<AE-COBO-Lab token>"
  }
}
```

Validate each with `python3 -m json.tool file.json`.

**Expected result:** Valid JSON, correct key names (case-sensitive).

### Step 3 - Zero-touch in Intune

1. **Devices > Enrollment > Android > Zero-touch enrollment** (iframe).
2. If you have a customer account: **Link** it → **Configurations > +** → *EMM DPC* **Android Device Policy** → paste the COBO JSON → company name, support email → **Save**.
3. Create a second configuration for the dedicated profile.
4. **Devices** tab → assign configurations. Optionally set the COBO one as the default.

**Expected result (walkthrough):** You can describe which configuration a scanner vs a manager phone should use and why.

### Step 4 - Samsung KME

1. Knox Admin Portal → **Knox Mobile Enrollment > MDM profiles > Create** → **Android Enterprise**.
2. MDM: **Microsoft Intune** → *Custom JSON data* → paste the JSON from Step 2 → *Allow end user to cancel enrollment* = **No**.
3. **Devices > Add devices** → via reseller upload or **Knox Deployment App** (Bluetooth/NFC/Wi-Fi Direct from a Samsung device).
4. Assign the profile to the device IMEIs → factory reset the target device.

**Expected result (full mode):** On first boot the device shows *Knox Mobile Enrollment* → enrolls to `AE-COBO-Lab`.

### Step 5 - Mapping exercise

Complete the table in your notes:

| Device population | Intune profile | ZTE configuration / KME profile | Token type |
|---|---|---|---|
| Sales managers' Pixels, work only | | | |
| Warehouse Samsung scanners, kiosk | | | |
| Field Galaxy phones, personal use allowed | | | |

**Expected result:** COBO → fully managed, COSU → dedicated, COPE → corporate work profile. One ZT configuration or KME profile per Intune profile.

## Validation

- JSON validates and uses `EXTRA_ENROLLMENT_TOKEN` inside `PROVISIONING_ADMIN_EXTRAS_BUNDLE`.
- You can explain why a device must not be registered in **both** zero-touch and KME.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Device boots to normal setup | Not assigned a configuration, not registered by reseller, or no network |
| "Invalid token" | Token revoked/expired or copied with whitespace |
| Samsung ignores ZT configuration | Also registered in KME - remove from one service |

## Cleanup / rollback

Unassign/remove test devices from the zero-touch or Knox portals. Don't leave production tokens in configurations you no longer use.

## Stretch challenge

Research **enrollment time grouping** with zero-touch: which part of the chain (ZT configuration or Intune profile) decides the group, and why don't staging tokens support it?

## Knowledge check

1. Which zero-touch method supports Samsung devices you already own without the reseller?
2. What connects a zero-touch configuration to a specific Intune enrollment profile?
3. Can personally owned work profile devices use zero-touch?

<details>
<summary>Answers</summary>

1. **Knox Mobile Enrollment** with the **Knox Deployment App**.
2. The **Intune enrollment token** in the DPC extras / custom JSON.
3. No - zero-touch and KME are for **corporate** modes (fully managed, dedicated, COPE).

</details>
