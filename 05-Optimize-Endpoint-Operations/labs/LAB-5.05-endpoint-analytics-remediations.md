# LAB-5.05 - Endpoint analytics, scores and Remediations

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.05 | 5.2.2, 5.2.3, 5.2.4 | 75 min (+ 24 h data wait) | Intermediate |

**Goal:** Onboard devices to Endpoint analytics, read startup, restart and app reliability data, set a baseline, and deploy built-in and custom remediations on a schedule and on demand.

## Prerequisites

- Windows 11 Enterprise/Pro devices, Entra joined or hybrid joined, enrolled (ideally 5+ for scores; VMs work).
- Sample scripts: [Detect-WindowsTempSize.ps1](../../08-Scripts/remediations/Detect-WindowsTempSize.ps1) and [Remediate-WindowsTempSize.ps1](../../08-Scripts/remediations/Remediate-WindowsTempSize.ps1).
- Intune Administrator.

## Required licenses

Intune Plan 1 for Endpoint analytics. **Remediations**: users need Windows Enterprise E3/E5 (Microsoft 365 E3/E5/F3), Education A3/A5, or VDA - Microsoft 365 E5 trial covers it.

## Steps

### Step 1 - Onboard

**Reports > Endpoint analytics** → *Collect device data from* = **All cloud-managed devices** (or *Selected devices* → your lab device group) → **Start**.

Check **Devices > Configuration** → profile **Intune data collection policy** is assigned. On a device, confirm the telemetry service is running:

```powershell
Get-Service -Name DiagTrack | Select-Object Status, StartType
```

Restart each device, sign in, and use it for a few minutes.

**Expected result:** Policy assigned, DiagTrack running. Data appears **up to 24 h after a restart**.

### Step 2 - Turn on Windows license verification

**Tenant administration > Connectors and tokens > Windows data** → **Windows data** = On → confirm *I confirm that my tenant owns one of these licenses* → **Save**.

**Expected result:** Remediations become available (not greyed out).

### Step 3 - Built-in remediation

**Devices > Manage devices > Scripts and remediations > Remediations** → *Restart Office Click-to-run service* → **Properties > Assignments > Edit** → lab device group → schedule **Daily**, every 1 day.

**Expected result:** Package assigned. After it runs: *Without issues* on healthy devices.

### Step 4 - Custom remediation with an hourly schedule

1. **Create** → `RM-Clean-WindowsTemp` → upload the detection and remediation scripts.
2. Settings: logged-on credentials **No**, signature check **No**, 64-bit **Yes**.
3. Assign the device group → schedule **Hourly**, repeats every **1** hour.
4. To force an issue on a test device (elevated):

   ```powershell
   $f = Join-Path $env:SystemRoot 'Temp\lab-fill.bin'
   fsutil file createnew $f 2200000000
   (Get-Item $f).LastWriteTime = (Get-Date).AddDays(-10)
   ```

**Expected result:** After the next run: **With issues** → **Issue fixed**. Device status → add columns *Pre-remediation detection output* / *Post-remediation detection output* → you see "Temp folder 2.1 GB" then the fixed value.

### Step 5 - Run remediation on demand

Recreate the file, then device → **...** → **Run remediation** → `RM-Clean-WindowsTemp` → **Run remediation**.

**Expected result:** The fix runs within minutes (device must be online). `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\HealthScripts.log` shows the run.

### Step 6 - Read the scores (after 24 h+)

1. **Overview**: Endpoint analytics score and the three subscores. *Insufficient data* if fewer than 5 devices.
2. **Startup performance**: boot score, sign-in score → **Startup processes** (needs ≥ 10 devices per process in real tenants) → **Restart frequency**.
3. Restart a VM normally, then **hard power-off** another (simulates *Unknown/Long power button press*). Next day → device → **OS restart history** shows the categories.
4. **Application reliability**: app crashes, MTTF → **OS versions performance**.
5. **Work from anywhere**: which devices lack cloud identity, cloud management or Autopilot.

**Expected result:** You can name the lowest subscore and one insight for it.

### Step 7 - Baseline

**Endpoint analytics > Settings > Baseline management** → **Create baseline** `Lab-Baseline-Day1` → set as current → note the regression threshold.

**Expected result:** Triangle markers on charts show your baseline.

## Validation

| Check | Expected |
|---|---|
| Intune data collection policy assigned | ✅ |
| Remediations enabled (license verification) | ✅ |
| Custom remediation: issue fixed with output columns | ✅ |
| On-demand run | ✅ |
| Restart categories visible in OS restart history | ✅ |
| Custom baseline created | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No Endpoint analytics data | Device not restarted since the policy, DiagTrack disabled, proxy blocks `*.events.data.microsoft.com`, or < 24 h |
| *Insufficient data* | Fewer than 5 devices reporting |
| Remediations greyed out | Windows license verification not confirmed |
| Remediation never runs | Detection doesn't `exit 1`, device not in group, IME not installed, schedule not reached |
| Remediation runs but "Issue recurred" | Remediation didn't fix what detection checks, or runs in the wrong context (32-bit / user) |

## Cleanup / rollback

Unassign `RM-Clean-WindowsTemp` (keep the package). Delete `lab-fill.bin` if still present. Keep Endpoint analytics on for Domain 5 practice.

## Stretch challenge

Create a detection-only package that reports the **BitLocker protection status** and **TPM version** in its output, schedule it daily, and export the device status to CSV - a quick fleet inventory without Advanced Analytics.

## Knowledge check

1. Which three subscores make up the Endpoint analytics score?
2. What exit code must a detection script return to trigger remediation?
3. Name the three schedule types for remediations.
4. Which restart category should average about one per device per month?
5. What licence gates Remediations?

<details>
<summary>Answers</summary>

1. **Startup performance, Application reliability, Work from anywhere**.
2. **`exit 1`**.
3. **Once, Hourly, Daily** (plus on-demand via the *Run remediation* device action).
4. **Update** restarts.
5. **Windows Enterprise E3/E5** (in Microsoft 365 F3/E3/E5), **Education A3/A5**, or **Windows VDA** per user.

</details>
