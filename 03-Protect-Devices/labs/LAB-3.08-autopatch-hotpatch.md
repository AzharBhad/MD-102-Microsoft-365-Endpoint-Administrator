# LAB-3.08 - Windows Autopatch and Hotpatch

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.08 | 3.2.3 | 60 min | Intermediate |

**Goal:** Create a Windows Autopatch group with custom rings, review the policies it generates, enable Hotpatch on an eligible device, and read Autopatch reports and alerts.

## Prerequisites

- Microsoft 365 E5 (Windows Enterprise E5) - Autopatch features available without activation.
- A Windows 11 **24H2+ Enterprise** VM with **VBS running** for Hotpatch. Hyper-V: `Set-VMProcessor -VMName <vm> -ExposeVirtualizationExtensions $true`, then enable VBS/Memory integrity.
- Remove [LAB-3.07](LAB-3.07-windows-update-rings-feature-quality.md) ring assignments from these devices (avoid overlapping ring policies).

## Required licenses

Autopatch: E3+/Business Premium/A3+/F3. Hotpatch: Windows 11 Enterprise E3/E5 (and equivalents).

## Steps

### Step 1 - Autopatch group

**Devices > Windows updates > Autopatch groups** (or **Tenant administration > Windows Autopatch**) → **Create** → `AG-Lab`:

- Rings: **Test** = `SG-Lab-Update-Pilot`. Add **Ring1** = dynamic distribution 100% of `DG-Lab-Windows-Corporate` (excluding Test). **Last** = empty group.
- Windows quality updates: Test deferral 0 / deadline 1. Ring1 deferral 3 / deadline 5. Last 7/7.
- Feature update: Windows 11 25H2 (or keep current).
- Include driver updates (automatic), Microsoft 365 Apps, Edge.

**Expected result:** Autopatch creates Entra groups `Windows Autopatch - …` and policies (update rings, feature, driver, M365 Apps, Edge) prefixed *Windows Autopatch*.

### Step 2 - Inspect the generated policies

**Devices > Windows updates > Update rings** and **Feature updates** → filter "Autopatch".

**Expected result:** One ring policy per Autopatch ring, assigned to the generated groups.

### Step 3 - Enable VBS and check Hotpatch readiness

Settings catalog `WIN-VBS-On` → *Device Guard > Enable Virtualization Based Security* = Enabled, *Require platform security features* = Secure Boot → assign to the Hotpatch test VM → reboot.

`msinfo32` → *Virtualization-based security: Running*.

**Expected result:** VBS running.

### Step 4 - Hotpatch policy

**Quality updates > Create** → **Windows quality update policy** → `QU-Hotpatch-Lab` → *When available, apply without restarting the device ("Hotpatch")* = **Allow** → assign to the VM's group.

**Expected result:** On the device: **Settings > Windows Update > Advanced options > Configured update policies** shows *Enable hotpatching when available*.

### Step 5 - Reports and alerts

- **Reports > Windows Autopatch > Quality updates**: *Up to Date / Not up to Date / Not ready*.
- **Hotpatch quality updates** report.
- **Alerts and remediations** (Devices > Windows updates > Feature/quality updates > Alerts): read any alerts such as *Hotpatch - VBS not running*.

**Expected result:** Devices listed with status. Alerts include remediation text.

### Step 6 - Pause a release (practice)

Autopatch group → **Release management / Releases** → pause quality updates for Ring1 → resume.

**Expected result:** The pause is visible with the reason you entered.

## Validation

| Check | Expected |
|---|---|
| Autopatch group created policies | ✅ |
| Hotpatch configured policy on device | ✅ |
| Next monthly update | Installs without restart on the eligible VM (outside baseline months) |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Autopatch group creation fails | Missing permissions (Intune Administrator / Autopatch admin), or devices belong to another Autopatch group |
| Hotpatch not offered | Not on current baseline, VBS not running, Arm64 without CHPE disabled, or ineligible SKU |
| Conflicting ring policies | Old [LAB-3.07](LAB-3.07-windows-update-rings-feature-quality.md) rings still assigned - remove them |

## Cleanup / rollback

Keep the Autopatch group if you like. Deleting it removes its policies/groups (confirm the prompt).

## Stretch challenge

Configure a **multi-phase feature update release** for the Autopatch group with a 7-day gap between phases.

## Knowledge check

1. What does an Autopatch group create for you?
2. List four Hotpatch prerequisites.
3. Do Hotpatch devices ever restart for updates?

<details>
<summary>Answers</summary>

1. Entra groups per ring + update ring, feature update, driver, Microsoft 365 Apps and Edge policies, assigned per ring.
2. Eligible licence, **Windows 11 24H2+ Enterprise**, **VBS running**, current **baseline**, x64 (or Arm64 with CHPE disabled), and a **quality update policy with Hotpatch = Allow**.
3. Yes - for **quarterly baseline** updates and non-hotpatchable fixes.

</details>
