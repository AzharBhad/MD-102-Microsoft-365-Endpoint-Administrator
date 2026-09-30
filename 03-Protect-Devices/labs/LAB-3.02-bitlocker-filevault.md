# LAB-3.02 - BitLocker and FileVault with self-service recovery

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.02 | 3.1.2 | 60 min | Intermediate |

**Goal:** Silently encrypt a Windows device with BitLocker (TPM only, XTS-AES 256, key escrow to Entra ID), let the user recover their own key, monitor encryption status, and review the FileVault configuration for macOS.

## Prerequisites

- CONTOSO-LAB-03 (Gen2, **vTPM enabled**, Entra joined, user3 standard user).
- WinRE enabled on the VM (`reagentc /info` shows *Enabled*).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - BitLocker policy

**Endpoint security > Disk encryption > Create policy** → Windows → **BitLocker** → `BL-Lab-Silent`:

| Setting | Value |
|---|---|
| Require Device Encryption | Enabled |
| Allow Warning For Other Disk Encryption | **Disabled** |
| Allow Standard User Encryption | **Enabled** |
| Configure Recovery Password Rotation | Refresh on for Entra joined and hybrid joined devices |
| Choose drive encryption method (OS/fixed) | XTS-AES 256-bit |
| Enforce drive encryption type on OS drives | Used Space Only |
| Require additional authentication at startup | Enabled → Allow TPM, TPM PIN = **Do not allow** |
| Choose how BitLocker-protected OS drives can be recovered | Enabled → allow 48-digit recovery password, **Save to Entra ID**, **Do not enable BitLocker until recovery info is stored** |

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** No prompts on the device. Encryption starts in the background after sync.

### Step 2 - Watch it happen

```powershell
manage-bde -status C:
Get-BitLockerVolume C: | Select-Object VolumeStatus, EncryptionPercentage, EncryptionMethod
```

**Expected result:** *Fully Encrypted*, XTS-AES 256, protectors: TPM + Numerical Password.

### Step 3 - Encryption report

**Reports > Device management > Encryption report** (or **Endpoint security > Disk encryption > Encryption report**).

**Expected result:** CONTOSO-LAB-03 = *Encrypted*, TPM version 2.0. If *Not encrypted*, read **Status details** (for example, *WinRE not configured*).

### Step 4 - Admin key retrieval (audited)

Intune → CONTOSO-LAB-03 → **Recovery keys** → **Show recovery key**. Entra → Audit logs → activity **Read BitLocker key**.

**Expected result:** The key ID matches the Numerical Password ID from Step 2, and the read is audited.

### Step 5 - Self-service recovery

1. Entra → **Devices > Device settings** → *Restrict users from recovering the BitLocker key(s) for their owned devices* = **No**.
2. As user3 on another device/browser: `https://myaccount.microsoft.com` → **Devices** → CONTOSO-LAB-03 → **View BitLocker Keys**. Or Company Portal website → device → **Get recovery key**.

**Expected result:** user3 sees the key. The audit log records user3 reading it.

### Step 6 - Simulate recovery and rotation

Force recovery mode: `manage-bde -forcerecovery C:` → restart → enter the 48-digit key.

**Expected result:** Windows boots. Because client-driven rotation is on, a **new** recovery password is generated and escrowed (check **Recovery keys** in Intune for a new key after sync).

### Step 7 - Compliance

Confirm `CP-Windows-Baseline` (LAB-1.11) *Require encryption* now reports **Compliant**.

### Step 8 - FileVault (review/optional Mac)

**Disk encryption > Create > macOS > FileVault** → Enable, Defer until sign-out, escrow location description `Contoso IT`, rotate personal key every 6 months, hide key from user = Yes → assign to Mac group.

**Expected result:** On a Mac (optional), FileVault enables at next sign-out, and Intune → device → **Recovery keys** shows the personal key.

## Validation

| Check | Expected |
|---|---|
| Silent encryption | No user prompts |
| Key in Entra/Intune | ✅ |
| Self-service key read | ✅ + audited |
| Rotation after use | New key ID |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Encryption report: *TPM not ready/not available* | Enable vTPM on the VM (shut down → Security → TPM) |
| *WinRE not configured* | `reagentc /enable` |
| User prompted with the BitLocker wizard | *Allow warning for other disk encryption* not Disabled, or TPM+PIN required |
| Key missing in Entra | *Do not enable until stored* prevents encryption - check event log *BitLocker-API > Management* |

## Cleanup / rollback

Keep BitLocker on. To decrypt a lab VM: remove the policy assignment, then `manage-bde -off C:`.

## Stretch challenge

Configure **TPM + PIN** for a high-security group and explain what changes in the user experience and in silent-encryption behaviour.

## Knowledge check

1. Which two settings make BitLocker silent for standard users?
2. Where can users retrieve their own recovery key?
3. What does *Do not enable BitLocker until recovery information is stored* prevent?

<details>
<summary>Answers</summary>

1. *Allow warning for other disk encryption* = **Disabled** and *Allow standard user encryption* = **Enabled** (with TPM-only startup).
2. **My Account** (myaccount.microsoft.com) or the **Company Portal** website/app.
3. Encrypting a drive without a recovery key backed up to Entra ID/AD.

</details>
