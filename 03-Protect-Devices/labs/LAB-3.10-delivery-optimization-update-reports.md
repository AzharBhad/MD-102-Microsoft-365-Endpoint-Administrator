# LAB-3.10 - Delivery Optimization and update reports

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.10 | 3.2.6, 3.2.7 | 45 min | Intermediate |

**Goal:** Configure Delivery Optimization for group peering with bandwidth limits, verify peering statistics on devices, and use Intune update reports to find and explain devices that aren't up to date.

## Prerequisites

- Two or more Windows VMs on the same Hyper-V switch (so they can peer).
- [LAB-3.07](LAB-3.07-windows-update-rings-feature-quality.md)/3.08 update policies in place.

## Required licenses

Intune Plan 1 (DO). Update reports: Autopatch-eligible Windows licences.

## Steps

### Step 1 - Delivery Optimization profile

**Devices > Configuration > Create > Windows 10 and later > Templates > Delivery Optimization** → `DO-Lab`:

- Download mode: **HTTP blended with peering across private group (2)**
- Group ID source: **Custom** → `11111111-1111-1111-1111-111111111111` (lab site GUID)
- Bandwidth: background max 50% (business hours 08-17), 90% outside
- Minimum RAM to use peer caching: 4 GB. Minimum disk: 32 GB
- **Enable peer caching while the device connects via VPN** = Block
- Max cache age: 3 days

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** Policy *Succeeded*.

### Step 2 - Verify DO configuration

```powershell
Get-DOConfig -Verbose | Select-Object DownloadMode, DOGroupIdSource, DOGroupId
Get-DeliveryOptimizationStatus | Select-Object FileId, Status, BytesFromPeers, BytesFromHttp -First 10
Get-DeliveryOptimizationPerfSnap
```

**Expected result:** `DownloadMode = Group`, and your group ID. After both VMs download the same update or Store app, `BytesFromPeers > 0` on the second VM.

### Step 3 - Trigger a shared download

Install the same Microsoft Store app (for example, Microsoft PowerToys) via Intune on VM1, then on VM2 a few minutes later.

**Expected result:** VM2 shows peer bytes for that file ID.

### Step 4 - Update reports

1. **Reports > Windows updates > Summary** → note devices by quality release.
2. **Reports > Windows updates > Reports > Windows feature update report** → select `FU-Win11-Pinned` → **Generate**.
3. **Reports > Windows Autopatch > Quality updates** → filter *Not up to Date* → open alerts.

**Expected result:** Each device has a state. For any *Needs attention / Not up to Date* device you can quote the alert reason.

### Step 5 - Assigned vs installed

Compare **Update rings > UR-Pilot > Device status** (policy succeeded) with the quality update report (installed release).

**Expected result:** You can explain why a device can show *Succeeded* for the ring but still be *Not up to Date*.

### Step 6 - Export

Export the quality update report to CSV (**Export**).

**Expected result:** A CSV for your patch KPI (used again in [LAB-5.04](../../05-Optimize-Endpoint-Operations/labs/LAB-5.04-reports-workbooks-export.md)).

## Validation

- DO group mode active and peer bytes observed (or explanation why not, for example, a single VM).
- A written explanation for each non-compliant device.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `BytesFromPeers = 0` | Devices not on the same group/subnet, files too small (DO minimum file size), or VMs don't meet RAM/disk minimums |
| Reports empty | Windows data connector / diagnostic data |
| Ring status error | Conflicting GPO/WSUS settings |

## Cleanup / rollback

Keep DO. Lower bandwidth limits if your host network is constrained.

## Stretch challenge

Read about **Microsoft Connected Cache for Enterprise and Education** and design where you'd place cache nodes for a 3-site company with one thin-WAN branch.

## Knowledge check

1. Which DO download mode allows peering across NATs within a defined group?
2. Why can a ring policy be *Succeeded* while the device isn't up to date?
3. Which report gives actionable alerts for devices that aren't up to date?

<details>
<summary>Answers</summary>

1. **Group (2)** with a Group ID source.
2. The ring status only shows **policy delivery**, not **installation** of the latest release.
3. **Windows Autopatch** quality/feature update reports (alerts and remediations).

</details>
