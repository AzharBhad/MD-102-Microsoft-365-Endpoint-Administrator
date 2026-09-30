# LAB-1.09 - Custom roles and scope tags

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.09 | 1.3.1, 1.3.2 | 60 min | Intermediate |

**Goal:** Create a least-privilege help desk role scoped to one "region", tag objects and devices with a scope tag, assign a Windows 365 role, and prove what the help desk account can and can't see.

## Prerequisites

- `helpdesk1` in `SG-Lab-Helpdesk`, licensed.
- CONTOSO-LAB-01 enrolled. At least two configuration profiles exist (create two empty settings catalog profiles `EU-Test-Profile` and `US-Test-Profile` if needed).
- A second browser profile / InPrivate window for helpdesk1.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Create scope tags

**Tenant administration > Roles > Scope tags > Create**: `Lab-EU` and `Lab-US`.

For `Lab-EU` → **Assignments** → add `DG-Lab-Windows-Corporate`.

**Expected result:** CONTOSO-LAB-01 shows scope tag **Lab-EU** in its properties after the next evaluation (a few minutes).

### Step 2 - Tag the objects

- `EU-Test-Profile` → Properties → Scope tags → **Lab-EU** (remove *Default*).
- `US-Test-Profile` → **Lab-US** (remove *Default*).

**Expected result:** Each profile lists only its regional tag.

### Step 3 - Create a custom role

**Roles > All roles > Create** → `Lab - EU Tier1 Helpdesk`:

| Category | Permissions |
|---|---|
| Managed devices | Read |
| Remote tasks | Sync devices, Reboot now, Collect diagnostics, Rotate local admin password |
| Device configurations | Read |
| Organization | Read |

**Expected result:** The role appears as *Custom*.

### Step 4 - Assign the role

Role → **Assignments > Assign** → name `EU Helpdesk` → Admin groups `SG-Lab-Helpdesk` → Scope groups **Selected** `DG-Lab-Windows-Corporate` → Scope tags **Lab-EU** → **Create**.

**Expected result:** Assignment listed with 1 member group and 1 scope tag.

### Step 5 - Test as helpdesk1

Sign in to the Intune admin center as helpdesk1:

- **Devices > Configuration** → you should see `EU-Test-Profile` only.
- **Devices > Windows** → CONTOSO-LAB-01 is visible → **Sync** works. **Wipe** is greyed out.
- **Tenant administration > Roles > My permissions** → review.

**Expected result:** Profile visibility matches the tag. Remote actions match the role.

### Step 6 - Windows 365 role

As admin: **Tenant administration > Roles > Windows 365 roles** (or filter *All roles* for *Cloud PC*) → **Cloud PC Reader** → assign to `SG-Lab-Helpdesk`.

**Expected result:** helpdesk1 can open **Devices > Windows 365** read-only (no provisioning policies can be created).

### Step 7 - Export role assignments with Graph

```powershell
Connect-MgGraph -Scopes DeviceManagementRBAC.Read.All
Get-MgBetaDeviceManagementRoleAssignment |
  Select-Object displayName, @{n='Tags';e={$_.roleScopeTagIds -join ','}}, scopeType
```

**Expected result:** `EU Helpdesk` shows the Lab-EU tag ID.

## Validation

| Test | Expected |
|---|---|
| helpdesk1 sees US-Test-Profile | ❌ |
| helpdesk1 syncs CONTOSO-LAB-01 | ✅ |
| helpdesk1 wipes a device | ❌ (no permission) |
| helpdesk1 edits EU-Test-Profile | ❌ (read only) |

## Troubleshooting

| Problem | Fix |
|---|---|
| helpdesk1 sees nothing | Assignment not propagated (wait ~15 min), or no scope tag on devices yet |
| Device not tagged | Scope tag *Assignments* uses **device** groups - check membership |
| Can't sign in to admin center | Tenant created before July 2021 without unlicensed admin access → license helpdesk1 or enable the setting |

## Cleanup / rollback

Keep role and tags for later labs, or delete the assignment then the role, and remove tags from objects before deleting the tags.

## Stretch challenge

Duplicate the built-in **Help Desk Operator** role, remove *Wipe*, *Retire* and *Delete*, and compare its permission count with your custom role.

## Knowledge check

1. What's the difference between scope groups and scope tags in a role assignment?
2. How can devices receive a scope tag automatically?
3. Which built-in Intune role can manage roles but not device policies?
4. Which Entra role gives full Windows 365 management, including licensing-related tasks?

<details>
<summary>Answers</summary>

1. Scope **groups** = users/devices the admin can manage or target. Scope **tags** = which objects the admin can see.
2. Assign the scope tag to a **device group** (scope tag *Assignments*).
3. **Intune Role Administrator**.
4. **Windows 365 Administrator** (Intune Administrator also works).

</details>
