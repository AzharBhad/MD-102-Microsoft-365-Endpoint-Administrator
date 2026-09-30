# LAB-2.13 - Remote Help

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.13 | 2.3.3 | 45 min | Intermediate |

**Goal:** Enable Remote Help, grant help desk least-privilege permissions, deploy the Remote Help app, run a session with elevation, and review session reporting.

## Prerequisites

- helpdesk1 (helper) and user3 (sharer) licensed for Remote Help.
- Two Windows devices: the helper's (for example CONTOSO-LAB-01) and the sharer's (CONTOSO-LAB-03).
- Custom role from [LAB-1.09](../../01-Prepare-Infrastructure/labs/LAB-1.09-custom-roles-scope-tags.md) or a new one.

## Required licenses

Intune Plan 2 / Suite / Remote Help add-on / Microsoft 365 E3+ (July 2026) for **both** users.

## Steps

### Step 1 - Enable Remote Help

**Tenant administration > Remote Help > Settings > Configure** → *Enable Remote Help* = **Enabled**. *Allow Remote Help to unenrolled devices* = **Disabled**. *Disable chat* = No → Save.

**Expected result:** Status Enabled.

### Step 2 - Permissions

Edit role `Lab - EU Tier1 Helpdesk` → **Remote Help app** permissions: *View screen* Yes, *Take full control* Yes, **Elevation** Yes, *Unattended control* No.

**Expected result:** The role shows the Remote Help permissions. The assignment still scopes helpdesk1 to EU devices.

### Step 3 - Package and deploy the app

1. Download `RemoteHelpInstaller.exe` from `https://aka.ms/downloadremotehelp`.
2. Package with IntuneWinAppUtil ([LAB-4.01](../../04-Manage-Secure-Applications/labs/LAB-4.01-win32-packaging-troubleshooting.md) method): install `RemoteHelpInstaller.exe /quiet acceptTerms=1`, uninstall `RemoteHelpInstaller.exe /uninstall /quiet acceptTerms=1`, detection: file `C:\Program Files\Remote help\RemoteHelp.exe` exists.
3. Assign Required to `DG-Lab-Windows-Corporate`.

**Expected result:** Remote Help appears in the Start menu on both devices.

### Step 4 - Start a session from the admin center

As helpdesk1: **Devices > Windows > CONTOSO-LAB-03 > New remote assistance session** → **Launch Remote Help** → choose **Take full control**.

**Expected result:** user3 receives a prompt on CONTOSO-LAB-03 → accepts → helpdesk1 sees the screen, the sharer's name, and the **compliance status**.

### Step 5 - Elevation

In the session, launch an admin tool on the sharer's device (for example **Computer Management**) to trigger UAC.

**Expected result:** helpdesk1 can see and respond to the UAC prompt (because of the Elevation permission). Without the permission, the UAC secure desktop would be hidden.

### Step 6 - Reporting

**Tenant administration > Remote Help > Monitor / Remote Help sessions**.

**Expected result:** The session is listed with helper, sharer, device, start time and duration.

## Validation

- A helper outside the role can't start a session.
- The session appears in reporting.
- The compliance status was visible to the helper.

## Troubleshooting

| Symptom | Fix |
|---|---|
| *New remote assistance session* missing | Remote Help not enabled, no license, or the helper lacks permissions |
| Sharer can't sign in | Sharer not licensed. CA blocking the **Remote Assistance Service** app |
| UAC shows a black screen | Helper lacks the **Elevation** permission |

## Cleanup / rollback

Keep enabled for later troubleshooting labs.

## Stretch challenge

Create a Conditional Access policy targeting the **Remote Assistance Service** cloud app that requires a **compliant device** for helpers, and test from a noncompliant device.

## Knowledge check

1. Which permission lets a helper respond to UAC prompts?
2. Who needs a Remote Help license?
3. What does Remote Help show that Quick Assist doesn't?

<details>
<summary>Answers</summary>

1. **Elevation** (Remote Help app permission).
2. **Both** helper and sharer.
3. Entra-verified identities, **device compliance status**, RBAC-controlled actions, and session reports.

</details>
