# LAB-1.12 - Windows Hello for Business

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.12 | 1.3.6 | 45 min | Intermediate |

**Goal:** Configure WHfB tenant-wide at enrollment and with a targeted settings catalog policy, provision a PIN on an Entra joined VM, and verify the key registration.

## Prerequisites

- CONTOSO-LAB-01 with a **vTPM** (Hyper-V Gen2, TPM enabled).
- user1 with MFA registered.
- *(Optional hybrid extension)* an AD DS lab with Entra Connect for cloud Kerberos trust.

## Required licenses

Intune Plan 1. WHfB itself needs no premium license.

## Steps

### Step 1 - Review the tenant-wide setting

**Devices > Enrollment > Windows > Windows Hello for Business**.

Set *Configure Windows Hello for Business* = **Enabled**, *Use a Trusted Platform Module (TPM)* = **Required**, *Minimum PIN length* = **6**, *Special characters* = **Allowed**, *Enable PIN recovery* = **Yes**, *Use security keys for sign-in* = **Enabled** → Save.

**Expected result:** Saved. It applies to devices at **enrollment** time.

### Step 2 - Create a targeted settings catalog policy

**Devices > Configuration > Create > Windows 10 and later > Settings catalog** → `WHfB-Lab-Device`:

| Category | Setting | Value |
|---|---|---|
| Windows Hello For Business | Use Windows Hello For Business (Device) | true |
| | Require Security Device (Device) | true |
| | Minimum PIN Length | 8 |
| | Enable Pin Recovery | true |
| | Use Cloud Trust For On Prem Auth | Enabled (for hybrid; harmless for cloud-only) |
| | Enable ESS with Supported Peripherals | Enhanced Sign-in Security enabled (if the hardware supports it) |

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** The policy applies after sync. **Device configuration** shows *Succeeded*.

### Step 3 - Provision on the device

Sync CONTOSO-LAB-01 → sign out → sign in as user1 → the *Set up a PIN* / *Use Windows Hello* prompt appears → complete MFA → create an 8-digit PIN.

**Expected result:** PIN created. The next sign-in offers PIN.

### Step 4 - Verify

```powershell
dsregcmd /status | Select-String 'NgcSet|NgcKeyId|CanReset|AzureAdPrt'
certutil -csp "Microsoft Passport Key Storage Provider" -key   # lists WHfB keys
```

Event Viewer → **Microsoft > Windows > User Device Registration > Admin** → look for key registration success.

Entra → **Users > user1 > Authentication methods** → **Windows Hello for Business** listed.

**Expected result:** `NgcSet : YES`, and the Entra user shows a WHfB method with the device name.

### Step 5 - Test PIN reset

At the lock screen → **I forgot my PIN** → authenticate → set a new PIN.

**Expected result:** Non-destructive reset (the key container is kept) because PIN recovery is enabled.

## Validation

| Check | Expected |
|---|---|
| Policy status | Succeeded |
| `NgcSet` | YES |
| Entra authentication methods | WHfB present |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No PIN prompt | Conflicting policies (tenant-wide disabled + group policy), or the device wasn't targeted. Check **MDM diagnostics report** |
| "Your organization requires Windows Hello but this device doesn't have a TPM" | Enable vTPM on the VM, or set *Require TPM* = false (lab only) |
| Stuck on MFA during provisioning | User has no MFA method → register at `aka.ms/mysecurityinfo` |
| Event 358 shows `Prerequisites not met` | Read the event detail: TPM, policy, or PRT missing |

## Cleanup / rollback

Keep WHfB. To remove a PIN: **Settings > Accounts > Sign-in options > PIN > Remove**. Remove the key from Entra authentication methods if needed.

## Stretch challenge

In a hybrid lab, create the Entra Kerberos server object with `Set-AzureADKerberosServer`, deploy *Use Cloud Trust For On Prem Auth*, and verify `CloudTgt : YES` and `OnPremTgt : YES` in `dsregcmd /status`.

## Knowledge check

1. Why is WHfB considered phishing-resistant?
2. What's the difference between the tenant-wide enrollment WHfB setting and a settings catalog policy?
3. Which trust model does Microsoft recommend for hybrid deployments?
4. What makes a PIN reset non-destructive?

<details>
<summary>Answers</summary>

1. Authentication uses a **TPM-bound private key** that never leaves the device, and the credential is bound to the device and origin.
2. The enrollment setting applies **tenant-wide at enrollment**. Settings catalog policies target **specific groups** and override it.
3. **Cloud Kerberos trust**.
4. Enabling **PIN recovery** (Microsoft PIN reset service).

</details>
