# LAB-1.02 - Entra join and automatic enrollment

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.02 | 1.1.2, 1.2.2 | 60 min | Beginner |

**Goal:** Configure MDM user scope, Entra join a Windows 11 VM, and confirm it enrolls into Intune automatically.

## Prerequisites

- Hyper-V VM `CONTOSO-LAB-01` (Windows 11 Enterprise/Pro) at OOBE or a fresh desktop with a local account.
- `user1` licensed with Microsoft 365 E5 and member of `SG-Lab-Users`.
- LAB-1.01 completed. Use a user **not** in `SG-Lab-Pilot-Users` (for example user3), or add this VM's serial as a corporate identifier.

## Required licenses

Entra ID P1 (automatic enrollment) + Intune Plan 1.

## Steps

### Step 1 - Restrict who can join devices

1. Entra admin center → **Entra ID > Devices > Device settings**.
2. *Users may join devices to Microsoft Entra* = **Selected** → add `SG-Lab-Users`.
3. *Maximum number of devices per user* = **20**.
4. **Local administrator settings**: *Registering user is added as local administrator* = **None**.
5. **Save**.

**Expected result:** Settings saved. Only lab users can join.

### Step 2 - Configure MDM user scope

1. Intune admin center → **Devices > Windows > Enrollment > Automatic Enrollment**.
2. *MDM user scope* = **Some** → `SG-Lab-Users`. *MAM user scope* = **None**.
3. **Save**.

**Expected result:** MDM scope shows *Some (1 group)*.

### Step 3 - Require MFA to join (Conditional Access)

1. Entra → **Conditional Access > New policy** `CA001 - Require MFA to register or join devices`.
2. Users: `SG-Lab-Users`. Target resources: **User actions > Register or join devices**.
3. Grant: **Require multifactor authentication** → Enable **On**.

**Expected result:** Policy is enabled. (Device settings *Require MFA to register or join* should remain **No** to avoid double configuration.)

### Step 4 - Join the VM

*Option A - OOBE:* choose *Set up for work or school* and sign in as `user3@contoso.onmicrosoft.com`.

*Option B - existing desktop:* **Settings > Accounts > Access work or school > Connect** → select **Join this device to Microsoft Entra ID** (the link at the bottom) → sign in → complete MFA → **Join** → **Done** → sign out → *Other user* → sign in as user3.

**Expected result:** Desktop loads for the Entra user. Windows Hello PIN setup may appear (WHfB tenant default).

### Step 5 - Verify join and enrollment on the device

```powershell
dsregcmd /status | Select-String 'AzureAdJoined|DomainJoined|AzureAdPrt|TenantName|MdmUrl'
Get-WinEvent -LogName 'Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin' -MaxEvents 50 |
  Where-Object Id -in 75,76 | Select-Object TimeCreated, Id, Message
```

**Expected result:** `AzureAdJoined : YES`, `AzureAdPrt : YES`, `MdmUrl` set to `https://enrollment.manage.microsoft.com/...`. Event **75** (enrollment succeeded).

### Step 6 - Verify in the portals

- Intune → **Devices > Windows** → `CONTOSO-LAB-01` → *Join type* **Microsoft Entra joined**, *Ownership* **Corporate**, *Primary user* user3.
- Entra → **Devices > All devices** → *Join type* **Microsoft Entra joined**, *MDM* **Microsoft Intune**.

**Expected result:** The device appears in both portals within ~5 minutes.

## Validation

- `dsregcmd /status` shows joined + PRT.
- Intune shows the device with a recent *Last check-in*.
- **Settings > Accounts > Access work or school > [account] > Info** shows *Managed by Contoso Lab*, and **Sync** works.

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| Joined but not in Intune | User not in MDM scope at join time → add to `SG-Lab-Users`, then run **Info > Sync** or re-join |
| Error 80180014 | Enrollment restriction (personal block) or an old Intune record for this device → delete the stale record, check restrictions |
| "Something went wrong" 8018000a | Device already enrolled by another user → unjoin/reset |
| Can't find "Join this device..." | Windows Home edition → use Pro/Enterprise |
| MFA loop | CA requires MFA but user has no method registered → register at `aka.ms/mysecurityinfo` first |

## Cleanup / rollback

Keep the VM joined - later labs use it. Take a checkpoint named `LAB-1.02 joined`.

## Stretch challenge

Create a **provisioning package** in Windows Configuration Designer (*Provision desktop devices*, *Enroll in Microsoft Entra ID* with a bulk token) and apply it to a second VM. Compare the primary user and ownership with CONTOSO-LAB-01.

## Knowledge check

1. Which setting makes Entra join trigger Intune enrollment?
2. Where do you require MFA for joining without the legacy device setting?
3. What `dsregcmd` field shows the device has an SSO token?
4. Which Windows edition can't be Entra joined?

<details>
<summary>Answers</summary>

1. **MDM user scope** (Some/All) on the Microsoft Intune mobility app.
2. Conditional Access **user action "Register or join devices"** → Require MFA.
3. `AzureAdPrt : YES`.
4. **Windows 10/11 Home**.

</details>
