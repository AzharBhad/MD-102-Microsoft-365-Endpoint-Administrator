# LAB-1.13 - Windows LAPS and local group membership

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.13 | 1.3.7, 1.3.8 | 60 min | Intermediate |

**Goal:** Enable Windows LAPS with Entra ID backup, retrieve and rotate the password, then control the local Administrators and Remote Desktop Users groups with an Account protection policy.

## Prerequisites

- CONTOSO-LAB-01 (Entra joined, Windows 11 22H2+).
- `SG-Lab-Helpdesk` with helpdesk1.
- Microsoft Graph PowerShell and the in-box **LAPS** module (Windows 11).

## Required licenses

Intune Plan 1. Entra ID Free is enough for LAPS backup (P1 for custom Entra roles).

## Steps

### Step 1 - Enable Microsoft Entra LAPS

Entra → **Devices > Device settings** → *Enable Microsoft Entra Local Administrator Password Solution (LAPS)* = **Yes** → Save.

**Expected result:** Saved.

### Step 2 - Enable the built-in Administrator account

Settings catalog policy `Enable-BuiltIn-Admin` → **Local Policies Security Options > Accounts Enable Administrator Account Status** = Enable → assign `DG-Lab-Windows-Corporate`.

*(Windows 11 24H2+ alternative: use LAPS **Automatic Account Management** instead.)*

**Expected result:** The policy applies. `Get-LocalUser Administrator` shows `Enabled : True`.

### Step 3 - Create the LAPS policy

**Endpoint security > Account protection > Create > Windows > Local admin password solution (Windows LAPS)** → `LAPS-Lab`:

- Backup Directory: **Backup the password to Microsoft Entra only**
- Password Age Days: **7**
- Password Complexity: large + small + numbers + special
- Password Length: **16**
- Post-authentication actions: **Reset password and logoff**, delay **1** hour

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** Policy created.

### Step 4 - Force processing and check events on the device

```powershell
Invoke-LapsPolicyProcessing
Get-WinEvent -LogName 'Microsoft-Windows-LAPS/Operational' -MaxEvents 15 | Select-Object TimeCreated, Id, Message
```

**Expected result:** Event **10029** ("LAPS successfully updated Azure Active Directory with the new password") and **10020**.

### Step 5 - Retrieve the password

- Intune → Devices → CONTOSO-LAB-01 → **Local admin password** → **Show**.
- PowerShell:

```powershell
Connect-MgGraph -Scopes 'Device.Read.All','DeviceLocalCredential.Read.All'
Get-LapsAADPassword -DeviceIds 'CONTOSO-LAB-01' -IncludePasswords -AsPlainText
```

**Expected result:** Account name *Administrator*, password, and last/next rotation times.

### Step 6 - Use and rotate

1. Sign in on the VM as `.\Administrator` with the password → sign out.
2. Wait for the post-authentication delay (or skip) → then Intune → device → **Rotate local admin password**.

**Expected result:** A new password with an updated *Last rotation* time. Event **10041** was logged when the account authenticated.

### Step 7 - Local user group membership policy

**Endpoint security > Account protection > Create > Windows > Local user group membership** → `LUGM-Lab`:

| Local group | Action | User selection | Members |
|---|---|---|---|
| Administrators | **Add (Update)** | Users/Groups | `SG-Lab-Helpdesk` |
| Remote Desktop Users | Add (Update) | Users/Groups | `SG-Lab-Helpdesk` |

Assign to `DG-Lab-Windows-Corporate` → sync the device.

```powershell
Get-LocalGroupMember Administrators
Get-LocalGroupMember 'Remote Desktop Users'
```

**Expected result:** A new SID `S-1-12-1-...` (the Entra group) appears in both groups.

### Step 8 - Replace (observe the risk)

Duplicate the policy → change Administrators to **Add (Replace)** with only `SG-Lab-Helpdesk` → assign to a **test** group containing only CONTOSO-LAB-01 → sync → check the group again.

**Expected result:** Previously present SIDs (Global Administrator role, Joined Device Local Administrator role) are **removed**. The built-in Administrator stays. Revert to Update afterwards.

## Validation

| Check | Expected |
|---|---|
| LAPS password visible in Intune and Entra | ✅ |
| Rotation updates timestamp | ✅ |
| helpdesk1 is local admin on LAB-01 | ✅ (after sign-in token refresh) |
| Entra audit log | "Recover device local administrator password" entries |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No password in Intune | Tenant LAPS switch off, policy not applied, or backup failed - check the LAPS event log |
| `Get-LapsAADPassword` access denied | Missing `DeviceLocalCredential.Read.All` consent or role |
| Group policy conflict | Two policies both using Replace on Administrators |
| helpdesk1 still not admin | Group SIDs evaluate at sign-in - sign out/in on the device |

## Cleanup / rollback

Keep LAPS. Delete the Replace test policy. Keep `LUGM-Lab` (Update) if you want helpdesk access for later labs.

## Stretch challenge

Create a custom **Entra** role `LAPS Password Reader` with only `microsoft.directory/deviceLocalCredentials/password/read` and assign it to helpdesk1. Confirm they can read the password but can't manage Intune policies.

## Knowledge check

1. Which two configurations are required for LAPS backup to Entra ID?
2. Which event ID confirms the password was backed up to Entra ID?
3. Which local group action removes existing members?
4. Which Entra role can see LAPS metadata but **not** the password?

<details>
<summary>Answers</summary>

1. Entra device setting **Enable Microsoft Entra LAPS = Yes** + the Intune (or CSP) **LAPS policy**.
2. **10029**.
3. **Add (Replace)**.
4. **Helpdesk Administrator** (also Security Administrator/Security Reader).

</details>
