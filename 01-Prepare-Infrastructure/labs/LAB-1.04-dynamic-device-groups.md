# LAB-1.04 - Dynamic device groups

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.04 | 1.1.4 | 40 min | Beginner |

**Goal:** Build and validate dynamic device groups for OS, ownership, Autopilot and group tags, then create one with Microsoft Graph PowerShell.

## Prerequisites

- CONTOSO-LAB-01 (Entra joined, corporate) and CONTOSO-LAB-02 (registered, personal) from [LAB-1.02](LAB-1.02-entra-join-automatic-enrollment.md)/1.03.
- Microsoft Graph PowerShell SDK (`Install-Module Microsoft.Graph -Scope CurrentUser`).

## Required licenses

**Entra ID P1** (dynamic groups).

## Steps

### Step 1 - Corporate Windows group (portal)

1. Intune → **Groups > New group** → Security → `DG-Lab-Windows-Corporate` → Membership **Dynamic Device**.
2. **Add dynamic query > Edit** and paste:

   ```text
   (device.deviceOSType -eq "Windows") and (device.deviceOwnership -eq "Company")
   ```

3. **Validate Rules** tab → add CONTOSO-LAB-01 and CONTOSO-LAB-02 → **Validate**.

**Expected result:** LAB-01 ✔ (member), LAB-02 ✖ (Personal).

### Step 2 - Autopilot device group

Create `DG-Lab-Autopilot` with:

```text
(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))
```

**Expected result:** 0 members for now. Autopilot devices appear after [LAB-2.01](../../02-Manage-Maintain-Devices/labs/LAB-2.01-autopilot-user-driven.md).

### Step 3 - Group-tag group

Create `DG-Lab-Autopilot-Sales` with:

```text
(device.devicePhysicalIDs -any (_ -eq "[OrderID]:Sales"))
```

**Expected result:** Group created. You'll import a device with group tag `Sales` in [LAB-2.01](../../02-Manage-Maintain-Devices/labs/LAB-2.01-autopilot-user-driven.md).

### Step 4 - Create a group with Graph PowerShell

```powershell
..\..\08-Scripts\graph\New-DynamicDeviceGroup.ps1 -DisplayName 'DG-Lab-Windows11' `
  -MembershipRule '(device.deviceOSType -eq "Windows") and (device.deviceOSVersion -startsWith "10.0.2")'
```

**Expected result:** The script prints the new group ID. The group shows *Membership type: Dynamic Device*.

### Step 5 - Check processing status

Open each group → **Overview** → *Dynamic rule processing status*.

**Expected result:** *Update complete* within minutes (can take longer in busy tenants).

### Step 6 - Test a typo

Edit `DG-Lab-Windows11` and change `Windows` to `Windwos`. Validate with LAB-01.

**Expected result:** ✖ - the rule is syntactically valid but matches nothing. Revert the typo.

## Validation

| Group | Expected members now |
|---|---|
| DG-Lab-Windows-Corporate | CONTOSO-LAB-01 |
| DG-Lab-Windows11 | CONTOSO-LAB-01, CONTOSO-LAB-02 (if Windows 11) |
| DG-Lab-Autopilot | none (until [LAB-2.01](../../02-Manage-Maintain-Devices/labs/LAB-2.01-autopilot-user-driven.md)) |

## Troubleshooting

| Problem | Fix |
|---|---|
| *Dynamic Device* option missing | Tenant lacks Entra ID P1 or you're creating a Microsoft 365 group - choose **Security** |
| "Property not supported" | Check attribute spelling. Device rules use `device.` prefix |
| Membership never updates | *Paused* processing → **Resume processing** on the group |

## Cleanup / rollback

Keep the groups - later labs assign policies to them.

## Stretch challenge

Write one rule that captures **iPads enrolled through a specific ADE profile** named `iPad-Shared` and explain which attribute you used.

## Knowledge check

1. Why do Autopilot deployment profiles usually target a `[ZTDid]` group?
2. Can one dynamic group contain both users and devices?
3. Which feature adds a device to a group *at enrollment time* instead of waiting for dynamic evaluation?
4. What licence do dynamic groups require?

<details>
<summary>Answers</summary>

1. `[ZTDid]` is added to `devicePhysicalIDs` when a device is registered with Autopilot, so every Autopilot device is captured automatically.
2. No - a dynamic group is either user **or** device.
3. **Enrollment time grouping** (static group owned by the Intune Provisioning Client).
4. **Microsoft Entra ID P1**.

</details>
