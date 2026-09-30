# LAB-1.07 - Apple Business Manager and Automated Device Enrollment

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.07 | 1.2.5 | 45 min (walkthrough) / 90 min (with ABM + device) | Intermediate |

**Goal:** Connect Intune to Apple Business Manager with an ADE token, build iOS and macOS ADE enrollment profiles, and understand the enrollment flow.

> **Walkthrough mode:** ABM requires a verified organization (a D-U-N-S number) and devices from an Apple reseller, or added with Apple Configurator. Most lab users can't do that, so Steps 1-2 show the portal side and Steps 3-5 can be completed in Intune **without** a real token by studying the profile wizard (you can open it once a token exists). If you have access to a test ABM org, do everything.

## Prerequisites

- APNs certificate (LAB-1.05).
- *(Full mode)* ABM account with **Device Enrollment Manager** or **Administrator** role. An iPhone/iPad or Mac assigned in ABM, or Apple Configurator for iPhone to add one.

## Required licenses

Intune Plan 1. Device-only licenses for userless iPads.

## Steps

### Step 1 - Download the Intune public key

Intune → **Devices > Enrollment > Apple > Enrollment program tokens > Add** → accept → **Download your public key** (`.pem`).

**Expected result:** A file like `AppleDEPPublicKey.pem` is saved.

### Step 2 - Create the MDM server in ABM

1. ABM → your account → **Preferences > Your MDM Servers > Add**.
2. Name `Intune-ContosoLab` → **Upload public key** → **Save** → **Download token** (`.p7m`).
3. **Preferences > MDM Server Assignment** → *Default Server* for iPhone, iPad and Mac = `Intune-ContosoLab`.

**Expected result:** The token file downloads, and default assignments are set.

### Step 3 - Upload the token to Intune

Back in the Intune wizard: enter the Apple Account used in ABM → upload the `.p7m` → **Create** → open the token → **Sync**.

**Expected result:** The token shows the expiry date (1 year). Devices assigned in ABM appear under **Devices** within minutes of sync.

### Step 4 - Create an iOS/iPadOS ADE profile

Token → **Profiles > Create profile > iOS/iPadOS**:

| Setting | Value |
|---|---|
| Name | `ADE-iOS-UserAffinity` |
| User affinity | **Enroll with User Affinity** |
| Authentication method | **Setup Assistant with modern authentication** |
| Install Company Portal with VPP | No (Yes after LAB-4.05) |
| Supervised | Yes |
| **Locked enrollment** | **Yes** |
| Await final configuration | Yes |
| Device name template | `CONTOSO-{{DEVICETYPE}}-{{SERIAL}}` |
| Setup Assistant | Hide: Apple Pay, Siri, Screen Time, iCloud Analytics. Show: Location Services, Passcode |

Then create `ADE-iPad-Shared` with **Enroll without User Affinity** + **Shared iPad = Yes**.

**Expected result:** Both profiles are listed. Set `ADE-iOS-UserAffinity` as **Default profile** (**Set default profile**).

### Step 5 - Create a macOS ADE profile

`ADE-macOS-Corp`: User affinity **with**, authentication **Setup Assistant with modern authentication**, **Locked enrollment Yes**, **Await final configuration Yes**, account settings → create local primary account (or **Platform SSO** if you'll do LAB-2.08 stretch).

**Expected result:** Profile created.

### Step 6 - Enroll (full mode)

Erase the device → Setup Assistant → Wi-Fi → **Remote Management** screen → sign in as user1 (Entra, MFA) → continue → *Awaiting final configuration*.

**Expected result:** Intune shows *Ownership: Corporate*, *Supervised: Yes*, *Enrollment type: ADE*.

## Validation

| Check | Pass criteria |
|---|---|
| Token | Active, expiry recorded in your calendar |
| Profiles | iOS user affinity (default), iPad shared, macOS |
| Device (full mode) | Supervised. The management profile can't be removed in Settings |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Device doesn't show in Intune | Not assigned to the Intune MDM server in ABM → assign, then **Sync** (Intune allows a full sync every 15 minutes) |
| Setup Assistant skips Remote Management | Device was already set up → must **Erase All Content and Settings** |
| Sign-in fails during Setup Assistant | CA policy requires compliant device for *Microsoft Intune Enrollment* → exclude that app. User lacks licence |
| Token expired | Renew in ABM (same MDM server) → **Renew token** in Intune |

## Cleanup / rollback

Retire/wipe the test device, unassign it in ABM, and optionally delete the token (removing a token removes its devices from Intune).

## Stretch challenge

Read Apple's guidance on adding devices to ABM with **Apple Configurator** (the Mac app for iPhone/iPad, or Apple Configurator for iPhone for Macs), then document what the user can do during the **30-day provisional period** and how that differs from a reseller-registered device.

## Knowledge check

1. What file do you upload to ABM, and what file do you download from ABM?
2. Which setting prevents users from removing the management profile?
3. When would you choose *Enroll without User Affinity*?
4. Name the three Apple-related tokens/certificates that expire yearly.

<details>
<summary>Answers</summary>

1. Upload Intune's **public key (.pem)**. Download the **server token (.p7m)**.
2. **Locked enrollment**.
3. Shared/kiosk devices or Shared iPad, where no single user signs in and Company Portal/CA aren't needed.
4. **APNs certificate**, **ADE (enrollment program) token**, **VPP (Apps and Books) location token**.

</details>
