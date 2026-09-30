# LAB-2.03 - Pre-provisioning and self-deploying

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.03 | 2.1.2 | 60 min | Advanced |

**Goal:** Run the pre-provisioning technician flow and a self-deploying (kiosk) deployment, and understand the TPM attestation requirement.

> **VM caveat:** Both modes need **TPM 2.0 attestation**. Hyper-V vTPM attestation often works on current builds but is unsupported for production. If you see *"Securing your hardware (0x800705b4)"* or a red screen with attestation errors, finish the lab as a walkthrough and focus on the flow and requirements.

## Prerequisites

- CONTOSO-LAB-03 registered with Autopilot ([LAB-2.01](LAB-2.01-autopilot-user-driven.md)) and restored to the OOBE checkpoint. Delete its Intune and Entra device objects first (keep the Autopilot record).
- A device-targeted Win32 app (for example, 7-Zip) assigned to `DG-Lab-Autopilot`.
- For self-deploying: a second registered VM with group tag `Kiosk` and a dynamic group `DG-Lab-Autopilot-Kiosk` (`[OrderID]:Kiosk`).

## Required licenses

As [LAB-2.01](LAB-2.01-autopilot-user-driven.md). The kiosk can use an Intune device-only license.

## Steps

### Step 1 - Pre-provisioning: technician flow

1. Confirm `AP-UserDriven-EntraJoin` has **Allow pre-provisioned deployment = Yes**.
2. Boot CONTOSO-LAB-03 to the first OOBE screen → press the **Windows key 5 times** → **Pre-provision with Windows Autopilot** → **Next**.
3. Review the QR code/profile summary → **Provision**.

**Expected result:** The device ESP runs (device-targeted apps and policies) and ends with a **green** screen.

### Step 2 - Reseal

Select **Reseal**.

**Expected result:** The device shuts down. In Intune it's enrolled with no primary user yet.

### Step 3 - Pre-provisioning: user flow

Start the VM → sign in as user3.

**Expected result:** Only the **account setup** (user) phase runs, which is fast. Desktop appears.

### Step 4 - Self-deploying profile

**Deployment profiles > Create** → `AP-Kiosk-SelfDeploying` → Deployment mode **Self-Deploying** → Join **Microsoft Entra joined** (the only option) → name template `KIOSK-%RAND:4%` → assign `DG-Lab-Autopilot-Kiosk`.

Create a **Kiosk** profile (Devices > Configuration > Windows > Templates > Kiosk) → single-app kiosk, Microsoft Edge in public browsing mode, **Auto logon** → assign to the kiosk group.

**Expected result:** The profile status for the kiosk VM is *Assigned*.

### Step 5 - Self-deploy

Boot the kiosk VM with **Ethernet** (Default Switch) → no user interaction.

**Expected result:** The device joins, enrolls, runs the device ESP, and signs in automatically to the kiosk account showing Edge.

## Validation

| Check | Pre-provisioned | Self-deploying |
|---|---|---|
| Primary user in Intune | user3 (after user flow) | None |
| Device-targeted apps installed before user | ✅ | ✅ |
| User ESP phase | ✅ (user flow) | ❌ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Win×5 does nothing | Must be the **first** OOBE screen. The profile must allow pre-provisioning and be *Assigned* |
| Red screen - TPM attestation | VM limitation or firmware TPM. Use physical hardware, or treat as walkthrough |
| Self-deploying stuck at network | Requires wired network (no user to select Wi-Fi) |
| Kiosk doesn't auto-logon | Kiosk profile not assigned to the device group, or the ESP is blocking on a user app |

## Cleanup / rollback

Delete the kiosk VM and its Autopilot/Intune/Entra records. Keep CONTOSO-LAB-03.

## Stretch challenge

Assign a **user-targeted** Win32 app to user3 and repeat the pre-provisioning flow. Record in which phase it installs and why.

## Knowledge check

1. What key sequence starts the technician flow?
2. Which modes require TPM 2.0 attestation?
3. Can self-deploying devices be hybrid joined?

<details>
<summary>Answers</summary>

1. **Windows key × 5** at the first OOBE screen.
2. **Pre-provisioning** and **self-deploying**.
3. **No** - Entra join only.

</details>
