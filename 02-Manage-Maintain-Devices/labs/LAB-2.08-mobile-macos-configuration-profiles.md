# LAB-2.08 - Android, iOS and macOS configuration profiles

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.08 | 2.2.2, 2.2.3, 2.2.4 | 75 min | Intermediate |

**Goal:** Create one meaningful configuration profile per non-Windows platform, understand which settings depend on the management mode (Android) or supervision (iOS), and apply macOS privacy/SSO payloads.

> Profiles can be created and assigned without devices. Validation on a device is optional but recommended.

## Prerequisites

- Managed Google Play bound ([LAB-1.06](../../01-Prepare-Infrastructure/labs/LAB-1.06-android-enterprise-enrollment-profiles.md)) and APNs certificate ([LAB-1.05](../../01-Prepare-Infrastructure/labs/LAB-1.05-apple-personal-enrollment.md)).
- Optional devices: Android (fully managed from [LAB-1.06](../../01-Prepare-Infrastructure/labs/LAB-1.06-android-enterprise-enrollment-profiles.md)), iPhone (BYOD or ADE), Mac.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Android Enterprise fully managed restrictions

**Devices > Configuration > Create > Android Enterprise > Fully managed, dedicated, and corporate-owned work profile > Device restrictions** → `AE-COBO-Restrictions`:

- General: *Screen capture* Block, *Factory reset* Block, *USB file transfer* Block
- Password: Numeric complex, length 6
- System update: **Maintenance window** 02:00-04:00

Assign to `SG-Lab-ETG-AE-FullyManaged`.

**Expected result:** On the device, screenshots are blocked and factory reset is greyed out in Settings.

### Step 2 - Android BYOD work profile restrictions

**Personally owned work profile > Device restrictions** → `AE-BYOD-WorkProfile`:

- *Copy and paste between work and personal profiles* = Block
- *Data sharing between work and personal profiles* = Block all sharing between profiles
- *Work profile password* required, 6 digits

Assign to `SG-Lab-Users`.

**Expected result:** Copying text from the work profile into a personal app fails.

### Step 3 - Dedicated kiosk (Managed Home Screen)

**Device restrictions** for dedicated devices → `AE-COSU-Kiosk` → *Kiosk mode* = **Multi app** → add Microsoft Edge and Calculator → *Exit kiosk mode PIN* 1234 → assign to `SG-Lab-ETG-AE-Dedicated`.

**Expected result:** Profile created (validate on a dedicated device if available).

### Step 4 - iOS SSO extension and supervised restrictions

1. If you didn't do [LAB-1.05](../../01-Prepare-Infrastructure/labs/LAB-1.05-apple-personal-enrollment.md) Step 2: **iOS/iPadOS > Templates > Device features** → **Single sign-on app extension** → *Microsoft Entra ID* → assign `SG-Lab-Users`.
2. **Settings catalog** → `iOS-Supervised-Restrictions`: *Allow AirDrop* = False, *Allow Erase Content and Settings* = False, *Force automatic date and time* = True → assign to `SG-Lab-Users` with a **filter** `(device.deviceOwnership -eq "Corporate")`.

**Expected result:** On a BYOD iPhone the supervised settings show *Not applicable* / aren't enforced. On ADE devices they apply.

### Step 5 - macOS FileVault, PPPC and Platform SSO

**macOS > Settings catalog** → `macOS-Security`:

- *Full Disk Encryption > FileVault*: Enable = On, Defer = Enabled, escrow location description "Contoso IT"
- *Firewall*: Enable Firewall = true, Enable Stealth Mode = true
- *Privacy > Privacy Preferences Policy Control*: add `com.microsoft.wdav` with *SystemPolicyAllFiles* = Allow (bundle identifier; code requirement from Microsoft's docs)

Second policy `macOS-PlatformSSO` → *Authentication > Extensible Single Sign On (SSO)* → Extension ID `com.microsoft.CompanyPortalMac.ssoextension`, Team ID `UBF8T346G9`, Type **Redirect**, URLs per Microsoft's Platform SSO docs, *Platform SSO > Authentication Method* **User Secure Enclave Key**.

**Expected result:** Policies created. On a Mac (optional), the user is prompted to register Platform SSO, and FileVault enables at next sign-out.

## Validation

| Platform | Evidence |
|---|---|
| Android COBO | Screenshot blocked |
| Android BYOD | Cross-profile paste blocked |
| iOS | Supervised settings apply only to corporate devices |
| macOS | FileVault key visible under the device's **Recovery keys** |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Android profile "Not applicable" | Profile created for a different management mode |
| iOS setting not applied on BYOD | Setting requires **supervision** |
| macOS PPPC not honoured | Device lacks **user-approved MDM**, or the code requirement is wrong |

## Cleanup / rollback

Keep the profiles. Unassign the kiosk profile if it interferes with other Android tests.

## Stretch challenge

Create an Android **OEMConfig** profile (for example, the Samsung **Knox Service Plugin** from Managed Google Play) and explore which settings aren't available in standard device restrictions.

## Knowledge check

1. Why might a restriction apply to ADE iPhones but not to BYOD iPhones?
2. Which Android feature provides a multi-app kiosk launcher?
3. Which macOS payload pre-grants Full Disk Access?

<details>
<summary>Answers</summary>

1. The setting requires **supervised** mode, which only corporate ADE/Configurator devices have.
2. **Managed Home Screen** (dedicated devices, multi-app kiosk).
3. **Privacy Preferences Policy Control (PPPC)**.

</details>
