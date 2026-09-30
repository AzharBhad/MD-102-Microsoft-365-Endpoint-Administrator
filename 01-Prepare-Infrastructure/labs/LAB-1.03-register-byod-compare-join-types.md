# LAB-1.03 - Register a BYOD device and compare join types

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.03 | 1.1.1, 1.1.3 | 45 min | Beginner |

**Goal:** Register a "personal" Windows device and a mobile device, then compare the device objects with the Entra joined device from LAB-1.02 so you can pick the right join type in scenario questions.

## Prerequisites

- A second Windows 11 VM `CONTOSO-LAB-02` signed in with a **local account** (represents a personal PC).
- Optional: an iPhone or Android phone with Microsoft Authenticator.
- LAB-1.02 completed (CONTOSO-LAB-01 is Entra joined).

## Required licenses

Entra ID Free for registration. Intune Plan 1 if the device also enrolls.

## Steps

### Step 1 - Allow personal Windows for this test user

Use **user4** (not in the pilot group that blocks personal Windows). Confirm *Users may register their devices with Microsoft Entra* = **All** in Entra device settings.

**Expected result:** user4 is covered by the default (permissive) platform restriction.

### Step 2 - Register CONTOSO-LAB-02

1. Signed in as the local user: **Settings > Accounts > Access work or school > Connect**.
2. Type `user4@contoso.onmicrosoft.com` in the **main box** (don't choose *Join this device*).
3. Complete sign-in and MFA → **Done**.

**Expected result:** The account appears under *Access work or school* as *Work or school account*.

### Step 3 - Inspect the device state

```powershell
dsregcmd /status | Select-String 'AzureAdJoined|WorkplaceJoined|DomainJoined|WorkplaceTenantName'
```

**Expected result:** `AzureAdJoined : NO`, `WorkplaceJoined : YES`.

### Step 4 - Register a mobile device (optional)

Install **Microsoft Authenticator** → *Add work or school account* → sign in as user4.

**Expected result:** A new device object with trust type *Microsoft Entra registered* and OS iOS/Android appears in Entra. There's **no** Intune record (not enrolled).

### Step 5 - Compare in Entra and Intune

1. Entra → **Devices > All devices** → add the **Join type**, **Owner**, **MDM**, **Compliant** columns.
2. Intune → **Devices > All devices**.

Fill in the table:

| Device | Join type | Owner | MDM | In Intune? | Ownership in Intune |
|---|---|---|---|---|---|
| CONTOSO-LAB-01 | | | | | |
| CONTOSO-LAB-02 | | | | | |
| Phone | | | | | |

**Expected result:** LAB-01 = *Microsoft Entra joined* / Intune / Corporate. LAB-02 = *Microsoft Entra registered* / Intune (if user4 is in MDM scope) / **Personal**. Phone = *registered* / no MDM / not in Intune.

### Step 6 - Query with Graph

```powershell
Connect-MgGraph -Scopes Device.Read.All
Get-MgDevice -All -Property displayName,trustType,isManaged,operatingSystem |
  Select-Object displayName, trustType, isManaged, operatingSystem | Format-Table
```

**Expected result:** `trustType` = `AzureAd` (joined), `Workplace` (registered). `ServerAd` would mean hybrid.

## Validation

You can explain, for each device, why it has that join type and which Conditional Access grant it could satisfy (compliant device vs app protection).

## Troubleshooting

| Symptom | Fix |
|---|---|
| LAB-02 became *joined* | You clicked *Join this device...* - disconnect the account and redo Step 2 |
| LAB-02 not in Intune | user4 isn't in MDM user scope (Some) or personal Windows is blocked. Either is fine for this lab - note it |
| Phone not listed | Authenticator registration requires *Users may register devices = All* and completed MFA |

## Cleanup / rollback

Disconnect the work account on CONTOSO-LAB-02 (**Access work or school > Disconnect**), delete the phone's device object in Entra, and remove the account from Authenticator.

## Stretch challenge

Read [1.1.1](../docs/1.1.1-choose-device-join-type.md) and write a one-paragraph recommendation for a 2,000-seat company that has an on-premises AD, GPO-dependent line-of-business apps, and a new laptop refresh starting next quarter.

## Knowledge check

1. A registered-only phone tries to open Outlook with a *Require compliant device* CA policy. What happens?
2. Which `trustType` value represents hybrid joined devices?
3. Why does Windows Autopilot self-deploying mode rule out hybrid join?

<details>
<summary>Answers</summary>

1. Blocked - a registered device without Intune enrollment has no compliance state.
2. `ServerAd`.
3. Self-deploying mode has no user and no domain join step. It supports **Microsoft Entra join only** (with TPM attestation).

</details>
