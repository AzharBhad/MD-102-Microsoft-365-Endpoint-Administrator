# LAB-3.01 - Antivirus and firewall policies

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.01 | 3.1.1, 3.1.3 | 60 min | Intermediate |

**Goal:** Configure Microsoft Defender Antivirus, a separate exclusions policy, Windows Security experience (tamper protection), a Windows Firewall policy and firewall rules. Then verify them on a device and in reports.

## Prerequisites

- CONTOSO-LAB-01 and -03 in `DG-Lab-Windows-Corporate`.
- For tamper protection: [LAB-3.05](LAB-3.05-defender-for-endpoint.md) onboarding (you can do this lab first and add tamper protection later).

## Required licenses

Intune Plan 1. Defender for Endpoint for tamper protection management.

## Steps

### Step 1 - Antivirus policy

**Endpoint security > Antivirus > Create policy** → Windows → **Microsoft Defender Antivirus** → `AV-Lab-Standard`:

- Allow Cloud Protection = Allowed. Cloud Block Level = High. Cloud Extended Timeout = 50
- Submit Samples Consent = Send safe samples automatically
- PUA Protection = On
- Enable Network Protection = Enabled (block mode)
- Signature Update Interval = 4
- Schedule quick scan time = 12:00
- **Disable Local Admin Merge** = Enabled

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** Policy *Succeeded* after sync.

### Step 2 - Exclusions policy (merge test)

Create two exclusion policies:

- `AV-Excl-App1` → Excluded paths `C:\ContosoApp1\Data`
- `AV-Excl-App2` → Excluded paths `C:\ContosoApp2\Cache`

Assign both to the same group.

**Expected result:** On the device both exclusions exist (exclusions **merge**):

```powershell
(Get-MpPreference).ExclusionPath
```

### Step 3 - Verify Defender settings and a PUA/test detection

```powershell
Get-MpPreference | Select-Object MAPSReporting, CloudBlockLevel, PUAProtection, EnableNetworkProtection, DisableLocalAdminMerge
```

Download the **EICAR** test string (from eicar.org) into a text file.

**Expected result:** Defender blocks the file. **Endpoint security > Antivirus > Windows 10 and later unhealthy endpoints / Reports > Detected malware** shows the detection within a few hours.

### Step 4 - Windows Security experience (tamper protection)

**Antivirus > Create** → **Windows Security experience** → *TamperProtection (Device)* = On → assign.

**Expected result:** After onboarding ([LAB-3.05](LAB-3.05-defender-for-endpoint.md)), `(Get-MpComputerStatus).IsTamperProtected` = True.

### Step 5 - Windows Firewall profile

**Endpoint security > Firewall > Create policy** → Windows → **Windows Firewall** → `FW-Lab-Profile`: enable Domain/Private/Public firewall, default inbound Block, **Allow Local Policy Merge (Public) = False**, log dropped packets → assign.

**Expected result:**

```powershell
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, AllowLocalFirewallRules
```

Public shows `AllowLocalFirewallRules = False`.

### Step 6 - Firewall rules

**Create policy** → **Windows Firewall rules** → `FW-Lab-Rules`:

1. *Allow RDP from IT subnet*: Inbound, Allow, TCP 3389, remote addresses `10.10.50.0/24`, profiles Domain+Private.
2. *Block outbound Telnet*: Outbound, Block, TCP 23, all profiles.

**Expected result:** `Get-NetFirewallRule -PolicyStore ActiveStore | Where DisplayName -like '*Telnet*'` shows the MDM rule. `Test-NetConnection example.com -Port 23` fails.

### Step 7 - Reports

**Reports > Firewall > MDM Firewall status for Windows 10 and later** and **Reports > Microsoft Defender Antivirus > Antivirus agent status**.

**Expected result:** Firewall *Enabled*, AV *Active* and signatures current.

## Validation

| Check | Expected |
|---|---|
| Exclusions from both policies present | ✅ |
| Local admin can't add exclusions | `Add-MpPreference -ExclusionPath C:\Temp` has no effect (not in `Get-MpPreference`) |
| Public profile local merge | Disabled |
| EICAR blocked | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Setting shows **Conflict** | Same setting in a security baseline or settings catalog policy - set one to Not configured |
| Tamper protection not applied | Device not onboarded to Defender for Endpoint |
| Firewall report empty | Wait for reporting cycle. Device must sync |

## Cleanup / rollback

Remove the Telnet block rule if it interferes. Keep the AV and firewall profiles.

## Stretch challenge

Use advanced hunting (after [LAB-3.05](LAB-3.05-defender-for-endpoint.md)) to find the EICAR detection: `DeviceEvents | where ActionType == "AntivirusDetection"`.

## Knowledge check

1. Why keep exclusions in a separate profile?
2. Which setting ensures only Intune firewall rules apply on public networks?
3. What prevents local admins from turning off real-time protection?

<details>
<summary>Answers</summary>

1. Exclusion profiles **merge** across policies instead of conflicting, and they're easier to govern.
2. **Allow Local Policy Merge = False** on the Public profile.
3. **Tamper protection** (plus Disable Local Admin Merge for exclusions).

</details>
