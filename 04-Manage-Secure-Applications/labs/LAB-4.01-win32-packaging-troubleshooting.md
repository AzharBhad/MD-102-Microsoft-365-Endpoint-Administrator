# LAB-4.01 - Win32 packaging with IntuneWinAppUtil and IME log troubleshooting

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.01 | 4.1.1, 4.1.2, 4.1.9 | 75 min | Intermediate |

**Goal:** Package an MSI and an EXE as Win32 apps, add requirements, detection, a dependency and supersedence, deploy them, then break detection on purpose and troubleshoot with the IME logs.

## Prerequisites

- A Windows admin workstation (can be CONTOSO-LAB-01) with the **Microsoft Win32 Content Prep Tool** (`IntuneWinAppUtil.exe`) from GitHub.
- Installers: 7-Zip MSI (two versions, for example 24.07 and 24.08) and Notepad++ EXE installer.
- CMTrace (from the Configuration Manager toolkit) or another log viewer.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Test silent installs as SYSTEM

```powershell
# Sysinternals PsExec
psexec.exe -i -s powershell.exe
msiexec /i "C:\Packages\7zip-2407\7z2407-x64.msi" /qn /l*v C:\Temp\7zip.log
& "C:\Packages\npp\npp.8.x.Installer.x64.exe" /S
```

**Expected result:** Both install silently. Note the MSI product code: `Get-CimInstance Win32_Product -Filter "Name like '7-Zip%'" | Select IdentifyingNumber`. Uninstall both afterwards.

### Step 2 - Package

```powershell
.\IntuneWinAppUtil.exe -c C:\Packages\7zip-2407 -s 7z2407-x64.msi -o C:\Packages\Out -q
.\IntuneWinAppUtil.exe -c C:\Packages\7zip-2408 -s 7z2408-x64.msi -o C:\Packages\Out -q
.\IntuneWinAppUtil.exe -c C:\Packages\npp -s npp.8.x.Installer.x64.exe -o C:\Packages\Out -q
```

Or use [`New-IntuneWinAppPackage.ps1`](../../08-Scripts/apps/New-IntuneWinAppPackage.ps1).

**Expected result:** Three `.intunewin` files.

### Step 3 - Add 7-Zip 24.07

**Apps > Windows > Create > Windows app (Win32)** → upload → install/uninstall commands prefilled for MSI → *Install behavior* System → **Requirements**: 64-bit, Windows 11 22H2+ → **Detection**: *MSI* (product code prefilled) → assign **Required** to `DG-Lab-Windows-Corporate`.

**Expected result:** Installed on the device within ~1 hour (or after IME restart: `Restart-Service IntuneManagementExtension`).

### Step 4 - Notepad++ with a dependency and a script detection

Add the Notepad++ package → install `npp.8.x.Installer.x64.exe /S`, uninstall `"C:\Program Files\Notepad++\uninstall.exe" /S` → **Detection**: *Use a custom detection script*:

```powershell
if (Test-Path 'C:\Program Files\Notepad++\notepad++.exe') { Write-Output 'Detected'; exit 0 }
exit 1
```

**Dependencies** → add 7-Zip 24.07 (*Automatically install* = Yes) → assign **Available** to `SG-Lab-Users`.

**Expected result:** Notepad++ appears in Company Portal. Installing it ensures 7-Zip is present first.

### Step 5 - Supersedence

Add 7-Zip 24.08 → **Supersedence** → add 24.07 → *Uninstall previous version* = **No** (in-place upgrade for MSI) → assign Required to the same group.

**Expected result:** Devices upgrade to 24.08. 24.07 reports as superseded.

### Step 6 - Break detection on purpose

Create a copy of the 24.08 app with a **file** detection rule pointing to a wrong path (`C:\Program Files\7-Zip\7zWRONG.exe`) → assign to a test device.

**Expected result:** Install runs, then status **Failed - 0x87D1041C** (not detected).

### Step 7 - Troubleshoot with logs

On the device, open with CMTrace:

- `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\AppWorkload.log`
- `IntuneManagementExtension.log`

Search for the app's GUID (from the Intune app URL) → find *Detection rule*, *Download*, *Execution exit code 0*, *Detection = NotDetected*.

**Expected result:** You can point to the exact log lines proving the installer succeeded but detection failed. Fix detection → the status turns to *Installed* after re-evaluation.

### Step 8 - Monitor

**Apps > Monitor > App install status** → export CSV. **Troubleshooting + support > Troubleshoot** → user3 → *Apps*.

**Expected result:** A tenant-wide and a user-centric view of the same failure.

## Validation

| Check | Expected |
|---|---|
| 7-Zip 24.08 installed | ✅ via supersedence |
| Notepad++ from Company Portal with dependency | ✅ |
| Broken detection | 0x87D1041C diagnosed from logs |

## Troubleshooting

| Symptom | Fix |
|---|---|
| App stays *Pending* | IME polls about every hour - restart the IME service or sync |
| *Not applicable* | Requirement rule (architecture/OS) or filter excluded the device |
| Script detection never detects | Script must **exit 0 and write STDOUT**. Check 32/64-bit script setting |

## Cleanup / rollback

Uninstall assignments → delete the broken test app. Keep 7-Zip 24.08 (used by App Control and ESP labs).

## Stretch challenge

Wrap an install in PSAppDeployToolkit (open source) and add a *custom requirement script* that only installs when a specific registry key exists.

## Knowledge check

1. What do the `-c`, `-s` and `-o` switches of IntuneWinAppUtil mean?
2. What does 0x87D1041C indicate?
3. How does a detection script report "installed"?

<details>
<summary>Answers</summary>

1. **Source folder**, **setup file**, **output folder**.
2. The app isn't **detected** after installation (detection rule mismatch).
3. **Exit code 0** and **writes something to STDOUT**.

</details>
