# LAB-3.04 - Security baselines

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.04 | 3.1.5 | 45 min | Intermediate |

**Goal:** Deploy the Windows and Defender for Endpoint security baselines to a pilot, find and resolve conflicts with your endpoint security policies, and practice changing a baseline version.

## Prerequisites

- [LAB-3.01](LAB-3.01-antivirus-firewall-policies.md) and [LAB-3.02](LAB-3.02-bitlocker-filevault.md) policies assigned (they'll conflict with the baseline on purpose).
- A pilot device group `SG-Lab-Baseline-Pilot` containing CONTOSO-LAB-01 only.

## Required licenses

Intune Plan 1. Defender for Endpoint for the MDE baseline.

## Steps

### Step 1 - Windows security baseline

**Endpoint security > Security baselines > Security Baseline for Windows 10 and later > Create profile** → `SB-Windows-Pilot` → keep the defaults → assign to `SG-Lab-Baseline-Pilot`.

**Expected result:** Profile created on the latest version.

### Step 2 - Defender for Endpoint baseline

**Security baselines > Microsoft Defender for Endpoint Security Baseline > Create profile** → `SB-MDE-Pilot` → assign to the same group.

**Expected result:** Created.

### Step 3 - Find conflicts

Sync the device → **Devices > CONTOSO-LAB-01 > Device configuration** → look for **Conflict** status. Open `SB-Windows-Pilot` → **Per setting status**.

**Expected result:** Settings such as BitLocker encryption method, Defender cloud block level or firewall settings show *Conflict* if values differ from [LAB-3.01](LAB-3.01-antivirus-firewall-policies.md)/3.02.

### Step 4 - Resolve by ownership

Decide: endpoint security policies own AV, firewall and BitLocker. Edit `SB-Windows-Pilot` → set the conflicting settings to **Not configured** (for example, *BitLocker > Encryption method*, *Defender > Cloud block level*). Sync.

**Expected result:** Conflicts clear. The endpoint security policies remain authoritative.

### Step 5 - Test for breakage

On the pilot device check: RDP, SMB access to a share, Office macros, local sign-in, Windows Hello. Note anything blocked by the baseline (for example, *LAN Manager authentication level*, *Block Office macros from the internet*).

**Expected result:** A short list of "baseline impact" items with a decision each (accept / deviate + reason).

### Step 6 - Change version

Open `SB-Windows-Pilot` → **Properties / Change version** (available when a newer baseline version exists) → review the list of **added, removed and changed** settings → confirm.

**Expected result:** Your customizations are preserved. New settings get Microsoft defaults.

## Validation

| Check | Expected |
|---|---|
| Baseline assigned to pilot only | ✅ |
| Conflicts | Resolved by setting overlaps to Not configured |
| Deviation log | Written |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Device *Error* on many settings | Edition doesn't support them (Pro vs Enterprise) - check *Not applicable* vs *Error* details |
| Can't sign in after baseline | Account lockout / interactive logon settings - restore the checkpoint, set Not configured |
| No "change version" option | You're already on the newest version |

## Cleanup / rollback

Unassign both baselines before continuing to other labs if they cause noise, or keep the pilot as a realistic hardened device.

## Stretch challenge

Export the baseline settings with Graph (`deviceManagement/configurationPolicies` where `templateReference.templateFamily eq 'endpointSecurityBaseline'`) and diff two versions.

## Knowledge check

1. What happens to your customizations when you move a baseline profile to a new version?
2. How do you resolve a conflict between a baseline and an antivirus policy?
3. Are security baselines compliance policies?

<details>
<summary>Answers</summary>

1. They're **kept**. New/changed settings are shown and use defaults unless customized.
2. Set the setting to **Not configured** in one of them (single owner per setting).
3. **No** - baselines configure settings. Compliance policies evaluate.

</details>
