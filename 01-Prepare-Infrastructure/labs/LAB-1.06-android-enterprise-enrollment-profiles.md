# LAB-1.06 - Android Enterprise profiles and troubleshooting

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.06 | 1.2.4 | 75 min | Intermediate |

**Goal:** Bind Managed Google Play, create fully managed, dedicated and COPE enrollment profiles with enrollment time grouping, enroll a test device, and practice diagnosing enrollment failures.

## Prerequisites

- A lab Google account (for example `md102lab@gmail.com`).
- An Android 12+ phone you can **factory reset**, or an Android Studio emulator image **with Google Play** (work profile BYOD and QR provisioning work on Play images).
- LAB-1.01 completed (Android device administrator blocked for pilot users).

## Required licenses

Intune Plan 1 (user). Dedicated devices can use device-only licenses.

## Steps

### Step 1 - Bind Managed Google Play

1. Intune → **Devices > Enrollment > Android > Managed Google Play** → *I agree* → **Launch Google to connect now**.
2. Sign in with the lab Google account → **Get started** → organization name `Contoso Lab` → **Complete registration**.

**Expected result:** Intune shows *Status: Setup* with your Google account, and **Apps > Android** lists Company Portal, Intune, Authenticator and others automatically.

### Step 2 - Create the enrollment time grouping groups

Create three **assigned** security groups: `SG-Lab-ETG-AE-FullyManaged`, `SG-Lab-ETG-AE-Dedicated`, `SG-Lab-ETG-AE-COPE`. For each: **Owners > Add owners** → search **Intune Provisioning Client** (AppId `f1346770-5b25-470b-88bd-d5744ab7952c`).

**Expected result:** Each group has the service principal as owner and no members.

### Step 3 - Create the enrollment profiles

| Section (Devices > Enrollment > Android) | Profile | Settings |
|---|---|---|
| Corporate-owned, fully managed user devices | `AE-COBO-Lab` | Token type **Corporate-owned, fully managed** (default), device group `SG-Lab-ETG-AE-FullyManaged` |
| Corporate-owned dedicated devices | `AE-COSU-Kiosk` | Token type **Corporate-owned dedicated device (default)**, expiry 30 days, device group `SG-Lab-ETG-AE-Dedicated` |
| Corporate-owned devices with work profile | `AE-COPE-Lab` | Default token, device group `SG-Lab-ETG-AE-COPE` |

**Expected result:** Each profile has a **Token** page showing a QR code.

### Step 4 - Enroll a fully managed device via QR

1. Factory reset the device (or cold-boot the emulator).
2. On the welcome screen, **tap 6 times** in the same spot → connect to Wi-Fi → scan the `AE-COBO-Lab` QR code.
3. Accept the terms → sign in as **user2** → install required apps.

**Expected result:** Intune shows the device with *Ownership: Corporate* and *Enrollment profile: AE-COBO-Lab*, and it's a member of `SG-Lab-ETG-AE-FullyManaged` within minutes.

### Step 5 - BYOD work profile (alternative / additional)

On a *non-reset* device: browser → `https://aka.ms/enrollmyandroid` (or Company Portal) → sign in as user4 → create the work profile.

**Expected result:** Work apps appear with the briefcase badge. Intune shows *Personally owned work profile*.

### Step 6 - Troubleshooting exercise

1. Add user2 to `SG-Lab-Pilot-Users` (limit 3) and enroll more test devices/emulators until blocked, **or** temporarily set Android Enterprise (work profile) to **Block** in `PR-Android-Pilot`.
2. Attempt BYOD enrollment again.
3. Investigate: **Devices > Monitor > Enrollment failures**, and **Troubleshooting + support > Troubleshoot** → user → *Enrollment failures*.

**Expected result:** The failure reason shows *Device cap reached* or *Platform blocked by enrollment restriction*. Revert the change.

## Validation

| Check | Pass criteria |
|---|---|
| Managed Google Play | Bound, default apps synced |
| Profiles | 3 corporate profiles with tokens + ETG groups |
| ETG | Enrolled device is a member of the ETG group; **Devices > Monitor > Enrollment time grouping failures** is empty |

## Troubleshooting

| Symptom | Fix |
|---|---|
| QR reader doesn't open | Must be at the welcome screen after reset. Some OEMs need 6 taps exactly. Android 8 needs a QR app in setup |
| "Can't set up device" after QR | Token revoked/expired, or no internet - connect Wi-Fi first |
| ETG failure | Group owner missing, or staging token used |
| Emulator can't enroll | Use a **Google Play** system image, not AOSP/Google APIs |

## Cleanup / rollback

Retire/wipe test devices in Intune → delete their objects. Keep profiles and Managed Google Play binding for LAB-1.08 and domain 4.

## Stretch challenge

Change `AE-COSU-Kiosk` to use the **Microsoft Entra shared device mode** token type and research which apps (Teams, Managed Home Screen) support shared-device sign-out.

## Knowledge check

1. Which Android Enterprise mode fits "corporate phones where staff can also use personal apps"?
2. What must own the static group used for enrollment time grouping?
3. Name two ways to start a fully managed enrollment other than QR code.
4. Which enrollment failure reason points to Intune device limit restrictions?

<details>
<summary>Answers</summary>

1. **Corporate-owned work profile (COPE)**.
2. The **Intune Provisioning Client** service principal (AppId f1346770-...).
3. `afw#setup` token entry, NFC, **zero-touch**, **Knox Mobile Enrollment**.
4. **Device cap reached** (DeviceCapReached).

</details>
