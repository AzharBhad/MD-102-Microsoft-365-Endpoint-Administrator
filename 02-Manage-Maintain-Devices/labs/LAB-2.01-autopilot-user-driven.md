# LAB-2.01 - Autopilot user-driven with name template and ESP

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.01 | 2.1.2, 2.1.3, 2.1.4, 2.1.5 | 90 min | Intermediate |

**Goal:** Register a Hyper-V VM with Windows Autopilot, assign a user-driven Entra join profile with a device name template, block the desktop with an ESP until critical apps install, and deploy the device end to end.

## Prerequisites

- Hyper-V Gen2 VM `CONTOSO-LAB-03` with vTPM, 4 GB static RAM, Windows 11 Enterprise ISO, **checkpoint at OOBE**.
- `DG-Lab-Autopilot` and `DG-Lab-Autopilot-Sales` groups ([LAB-1.04](../../01-Prepare-Infrastructure/labs/LAB-1.04-dynamic-device-groups.md)).
- Entra **Company branding** configured (logo + sign-in text).
- At least one Win32 app to track (Company Portal from the Microsoft Store (new) works, or the 7-Zip Win32 app from [LAB-4.01](../../04-Manage-Secure-Applications/labs/LAB-4.01-win32-packaging-troubleshooting.md)/LAB-2.12).

## Required licenses

Windows Enterprise/Pro, Intune Plan 1, Entra ID P1 (user3).

## Steps

### Step 1 - Capture the hardware hash

At OOBE press **Shift+F10**:

```powershell
powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -OutputFile C:\HWID.csv -GroupTag Sales
```

Copy `C:\HWID.csv` off the VM (for example, enable enhanced session and copy, or use `-Online` with an admin sign-in instead).

**Expected result:** A CSV with *Device Serial Number, Windows Product ID, Hardware Hash, Group Tag*.

### Step 2 - Import the device

**Devices > Windows > Enrollment > Windows Autopilot > Devices > Import** → upload the CSV → wait → **Sync**.

**Expected result:** The device appears with group tag **Sales** within ~15 minutes. `DG-Lab-Autopilot` and `DG-Lab-Autopilot-Sales` gain a member.

### Step 3 - Create the deployment profile

**Deployment profiles > Create profile > Windows PC** → `AP-UserDriven-EntraJoin`:

- Convert all targeted devices to Autopilot: No
- Deployment mode: **User-Driven**. Join: **Microsoft Entra joined**
- License terms/Privacy/Change account options: **Hide**
- User account type: **Standard**
- Allow pre-provisioned deployment: **Yes** (reused in [LAB-2.03](LAB-2.03-autopilot-preprovisioning-self-deploying.md))
- **Apply device name template: Yes** → `CON-%SERIAL%`
- Assign: `DG-Lab-Autopilot-Sales`

**Expected result:** The device's *Profile status* becomes **Assigned** (can take 15+ minutes).

### Step 4 - Create the ESP

**Devices > Windows > Enrollment > Enrollment Status Page > Create** → `ESP-Lab-Standard`:

- Show app and profile configuration progress: **Yes**
- Error timeout: **60** min. Custom message with help desk contact
- Turn on log collection: **Yes**
- Only show page to devices provisioned by OOBE: **Yes**
- Block device use until all apps and profiles are installed: **Yes**
- Allow reset on error: **Yes**. Allow use on error: **No**
- Block device use until these required apps are installed: **Selected** → Company Portal (+ one Win32 app)
- Install Windows quality updates: **Yes**
- Assign: `DG-Lab-Autopilot`

**Expected result:** The ESP is listed with priority 1.

### Step 5 - Deploy

Apply the OOBE checkpoint → power on → region/keyboard → network → the **company branding** sign-in page appears → sign in as **user3** → MFA → ESP: *Device preparation → Device setup → Account setup*.

**Expected result:** The device renames (a reboot happens during OOBE), and the ESP completes. The desktop appears for user3, who is a **standard** user.

### Step 6 - Verify

```powershell
hostname                       # CON-<serial truncated to 15 chars>
net localgroup administrators  # user3 NOT listed
dsregcmd /status | Select-String 'AzureAdJoined|TenantName'
```

Intune: **Devices > Monitor > Autopilot deployments** → your deployment shows *Success*, with profile and ESP names and duration.

## Validation

| Check | Expected |
|---|---|
| Device name | `CON-...` |
| Autopilot deployments report | Success |
| user3 local admin | No |
| Blocking apps installed before desktop | Yes |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Normal Windows OOBE, no branding | Profile not **Assigned** yet, or the device OOBE'd before assignment → wait, apply checkpoint, retry |
| ESP timeout on app | App failing - check `IntuneManagementExtension.log`. Reduce blocking apps |
| "Securing your hardware" failure (0x800705b4) | TPM attestation issue - normal for some VMs in user-driven with pre-provisioning. Retry or disable pre-provisioning |
| Name not applied | Template only works for **Entra join** and needs a reboot during OOBE |

Collect logs: `mdmdiagnosticstool.exe -area Autopilot;TPM -cab C:\Temp\ap.cab`.

## Cleanup / rollback

Keep the device for later labs. To redeploy: **Wipe** or re-apply the OOBE checkpoint (delete the Intune/Entra records first if you apply a checkpoint).

## Stretch challenge

Add a second profile `AP-Kiosk-SelfDeploying` targeted at group tag `Kiosk`, and explain how Autopilot chooses between two profiles when a device is in both groups (hint: creation date).

## Knowledge check

1. What must the Autopilot *Profile status* be before deploying?
2. Which ESP setting prevents the page appearing when an existing PC enrolls via Settings?
3. Why track only *Selected* apps in the ESP?
4. Which character limit applies to the device name template?

<details>
<summary>Answers</summary>

1. **Assigned**.
2. **Only show page to devices provisioned by OOBE**.
3. To keep OOBE fast and reduce timeout failures - only critical apps should block.
4. **15** characters.

</details>
