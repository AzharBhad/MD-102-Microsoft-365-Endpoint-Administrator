# LAB-2.06 - Windows Backup

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.06 | 2.1.8 | 60 min | Intermediate |

**Goal:** Enable Windows Backup for Organizations on one device, turn on the tenant-wide restore page, and restore settings during OOBE on a second Entra joined device.

## Prerequisites

- CONTOSO-LAB-03 (Entra joined, user3 signed in, Windows 11 22H2+ with recent updates) as the **source**.
- A clean VM at OOBE (for example the LAB-2.03 checkpoint of a registered VM, or CONTOSO-LAB-04 reset) as the **target**. It will be deployed with **user-driven** Autopilot or OOBE Entra join.
- Intune Service Administrator (Intune Administrator) role.

## Required licenses

Intune Plan 1 + Entra ID.

## Steps

### Step 1 - Backup policy

**Devices > Configuration > Create > Windows 10 and later > Settings catalog** → `WIN-WindowsBackup` → search **Sync your settings** → **Enable Windows backup** = Enabled → assign to `SG-Lab-Users`.

**Expected result:** Policy *Succeeded* on CONTOSO-LAB-03.

### Step 2 - Personalize the source device

As user3 on CONTOSO-LAB-03: change the wallpaper, set dark mode, add a keyboard language, pin a Store app, and install one Microsoft Store app. Then **Settings > Accounts > Windows backup** → confirm backup is on → **Back up now** if shown.

**Expected result:** The Windows backup page shows a recent backup time.

### Step 3 - Enable restore (tenant-wide)

**Devices > Enrollment > Windows > Windows Backup and Restore** → *Show restore page* = **On** → Save.

**Expected result:** *Last modified* updated.

### Step 4 - Check the ESP setting

Your ESP profile (LAB-2.01) → **Install Windows quality updates** = Yes.

**Expected result:** Enabled.

### Step 5 - Deploy the target device

Boot the target VM → user-driven OOBE → sign in as **user3**.

**Expected result:** After sign-in, a **Restore from backup** page lists CONTOSO-LAB-03 → choose it → continue.

### Step 6 - Verify

On the target: wallpaper, dark mode, language and pinned apps match. The Store app reinstalls.

Intune → target device → **Enrollment** → *Windows Backup and Restore profile* = **Succeeded**.

**Expected result:** Settings restored and status Succeeded.

## Validation

- Status *Succeeded* on the target device's enrollment page.
- Files are **not** restored (they belong to OneDrive KFM) - confirm Documents is empty unless KFM is configured.

## Troubleshooting

| Symptom | Fix |
|---|---|
| No restore page | Setting enabled after the device enrolled, **self-deploying/pre-provisioning** flow, hybrid join, or an OS build that's too old |
| *No Backup Profiles* | Backup policy never applied to the source, or no backup yet |
| Restore page skipped on VM | Phishing-resistant MFA prompts on Hyper-V VMs can block the flow - use password + Authenticator for the lab user |

## Cleanup / rollback

Set *Show restore page* back to Off if you don't want it in other labs. Keep the backup policy.

## Stretch challenge

Configure **OneDrive Known Folder Move** silently (settings catalog OneDrive > *Silently move Windows known folders to OneDrive*) and repeat the migration. Document the full "new laptop" user experience.

## Knowledge check

1. Where is the restore setting configured and what's its scope?
2. Which join type is required to restore?
3. Does Windows Backup restore user files?

<details>
<summary>Answers</summary>

1. **Devices > Enrollment > Windows > Windows Backup and Restore**. It's **tenant-wide**.
2. **Microsoft Entra joined**.
3. **No** - settings and the Store app list only. Use OneDrive for files.

</details>
