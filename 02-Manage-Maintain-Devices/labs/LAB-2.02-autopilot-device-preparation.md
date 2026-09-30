# LAB-2.02 - Autopilot device preparation vs deployment profile

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.02 | 2.1.1 | 60 min | Intermediate |

**Goal:** Deploy a Windows 11 VM with a Windows Autopilot **device preparation** policy (no hardware hash), use enrollment time grouping, and compare the experience and reporting with [LAB-2.01](LAB-2.01-autopilot-user-driven.md).

## Prerequisites

- A **new** Gen2 VM `CONTOSO-LAB-04` (Windows 11 24H2 Enterprise) at OOBE. It must **not** be registered with classic Autopilot.
- `SG-Lab-ETG-Windows` static group with **Intune Provisioning Client** as owner (LAB setup / [LAB-1.06](../../01-Prepare-Infrastructure/labs/LAB-1.06-android-enterprise-enrollment-profiles.md) method).
- user2 in `SG-Lab-Users`. If personal Windows is blocked for user2, add a **corporate identifier** for the VM ([LAB-1.01](../../01-Prepare-Infrastructure/labs/LAB-1.01-tenant-baseline-enrollment-settings.md) Step 5).

## Required licenses

Windows 11 Pro/Enterprise, Intune Plan 1, Entra ID P1.

## Steps

### Step 1 - Assign apps and a script to the ETG group

- Assign **Company Portal** (Microsoft Store app) as **Required** to `SG-Lab-ETG-Windows`.
- **Devices > Scripts and remediations > Platform scripts > Add** → a simple script that writes `C:\ProgramData\Contoso\provisioned.txt` → run in system context → assign to `SG-Lab-ETG-Windows`.

**Expected result:** Both assigned to the device group.

### Step 2 - Create the device preparation policy

**Devices > Windows > Enrollment > Device preparation policies > Create** → `APDP-UserDriven-Lab`:

- Deployment mode: **User-driven**. Join type: **Microsoft Entra joined**
- User account type: **Standard**
- **Device security group**: `SG-Lab-ETG-Windows`
- Minutes allowed before installation error: 60. Custom error message: help desk contact
- Allow users to skip setup after multiple attempts: Yes (lab)
- **Apps**: add Company Portal. **Scripts**: add the provisioning script
- Assignments: **user group** `SG-Lab-Users`

**Expected result:** The policy appears with priority 1.

### Step 3 - Deploy

Boot the VM → OOBE → network → **Set up for work or school** → sign in as user2 → MFA.

**Expected result:** A simplified progress screen with a **percentage** indicator. The device reaches the desktop after the selected apps and scripts finish.

### Step 4 - Check enrollment time grouping

Entra → `SG-Lab-ETG-Windows` → **Members**.

**Expected result:** CONTOSO-LAB-04 is a member immediately after enrollment, with no dynamic-rule delay.

### Step 5 - Review the deployment report

**Devices > Monitor > Windows Autopilot device preparation deployments** → open the deployment.

**Expected result:** Near real-time status: phase, duration, and per-app and per-script status.

### Step 6 - Compare with LAB-2.01

Complete the table:

| | [LAB-2.01](LAB-2.01-autopilot-user-driven.md) (profile) | LAB-2.02 (device preparation) |
|---|---|---|
| Hash upload needed | | |
| Assigned to (user/device group) | | |
| Progress UI | | |
| Name template | | |
| Report detail | | |

**Expected result:** Yes/No/ESP/Yes/limited vs No/User/percentage/No/detailed.

## Validation

- `C:\ProgramData\Contoso\provisioned.txt` exists.
- The device is in `SG-Lab-ETG-Windows`, and the deployment report shows *Success*.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Classic OOBE, no device preparation | Device registered in classic Autopilot → deregister it, or use device association |
| Enrollment blocked | Personal Windows blocked → add corporate identifier |
| Device not added to group | Group owner isn't Intune Provisioning Client → fix. See **Enrollment time grouping failures** |
| Apps don't install during OOBE | App not selected in the policy **and** not assigned to the ETG group |

## Cleanup / rollback

Keep the VM, or wipe it and delete the device records.

## Stretch challenge

Research **device association** for device preparation and describe how it lets you use device preparation while also marking devices corporate and targeting device-based OOBE customizations.

## Knowledge check

1. To what type of group is a device preparation policy assigned?
2. Who must own the device security group?
3. Name two scenarios that require the classic Autopilot profile instead.

<details>
<summary>Answers</summary>

1. A **user** group.
2. The **Intune Provisioning Client** service principal.
3. Any two: hybrid join, self-deploying, pre-provisioning, Autopilot Reset, device name template, HoloLens/Teams Rooms, Windows 10.

</details>
