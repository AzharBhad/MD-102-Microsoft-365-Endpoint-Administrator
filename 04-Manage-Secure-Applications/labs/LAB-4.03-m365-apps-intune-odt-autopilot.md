# LAB-4.03 - Microsoft 365 Apps via Intune and ODT during Autopilot

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.03 | 4.1.4, 4.1.6 | 90 min | Intermediate |

**Goal:** Deploy Microsoft 365 Apps with the built-in app type, then build the Microsoft-recommended Win32 ODT package and make it a blocking app in the Autopilot ESP.

## Prerequisites

- [LAB-2.01](../../02-Manage-Maintain-Devices/labs/LAB-2.01-autopilot-user-driven.md) Autopilot VM with an OOBE checkpoint.
- Office Deployment Tool (`setup.exe`) downloaded from the Microsoft Download Center.
- Users licensed for Microsoft 365 Apps (E5 includes them).

## Required licenses

Microsoft 365 Apps + Intune Plan 1.

## Steps

### Step 1 - Built-in app type (existing device)

**Apps > Create > Microsoft 365 Apps > Windows 10 and later** → `M365 Apps - Built-in - MEC x64`:

- Configuration designer: Word, Excel, PowerPoint, Outlook, OneNote, Teams
- Architecture 64-bit. Update channel **Monthly Enterprise**. Remove other versions = Yes. Latest version. Accept EULA

Assign **Required** to a test device group containing CONTOSO-LAB-01 (not the Autopilot VM).

**Expected result:** Office installs. `C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE` exists. **File > Account** shows *Monthly Enterprise Channel*.

### Step 2 - Build configuration.xml with the OCT

`config.office.com` → **Customization > Device configuration > Create** → Microsoft 365 Apps for enterprise, 64-bit, Monthly Enterprise Channel, exclude Groove and Skype for Business, *Remove all MSI*, *Accept EULA*, display none → **Export** → Office Open XML → save as `configuration.xml`.

Create `uninstall.xml`:

```xml
<Configuration>
  <Remove All="TRUE" />
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```

**Expected result:** Folder `C:\Packages\M365Apps\` contains `setup.exe`, `configuration.xml`, `uninstall.xml`.

### Step 3 - Package as Win32

```powershell
.\IntuneWinAppUtil.exe -c C:\Packages\M365Apps -s setup.exe -o C:\Packages\Out -q
```

Add a Win32 app `M365 Apps - ODT - MEC x64`:

- Install: `setup.exe /configure configuration.xml`
- Uninstall: `setup.exe /configure uninstall.xml`
- Install behavior: System. Restart: no specific action
- Requirement: 64-bit
- Detection: **Registry** → `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration` → value name `ProductReleaseIds` → detection method **String comparison** → operator **Equals** → `O365ProPlusRetail` (match your XML's Product ID; use **Key exists** if you install several products)

Assign **Required** to `DG-Lab-Autopilot`.

**Expected result:** App created.

### Step 4 - Make it blocking in the ESP

Edit `ESP-Lab-Standard` → *Block device use until these required apps are installed* → **Selected** → add `M365 Apps - ODT - MEC x64` (+ Company Portal, 7-Zip).

**Expected result:** ESP tracks three apps.

### Step 5 - Deploy with Autopilot

Delete the Autopilot VM's Intune/Entra records, restore the OOBE checkpoint, and run the user-driven deployment.

**Expected result:** The ESP device setup phase shows the apps installing in sequence. The desktop appears with Office already installed. The IME log shows M365 Apps installed by the IME.

### Step 6 - Compare (optional)

Swap the ESP to track the **built-in** M365 app type instead, alongside several Win32 apps, and observe (or read about) concurrency issues/timeouts.

**Expected result:** You can explain why Microsoft recommends the Win32 ODT approach for ESP-tracked installs.

## Validation

| Check | Expected |
|---|---|
| Office on first desktop | ✅ |
| Channel | Monthly Enterprise |
| ESP report | Success, M365 Apps listed as installed |

## Troubleshooting

| Symptom | Fix |
|---|---|
| ESP timeout on M365 Apps | CDN download slow - increase timeout, or add Delivery Optimization. Check `%windir%\Temp\*.log` C2R logs |
| Detection fails | Wrong registry path/value. Confirm with `reg query "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration"` |
| MSI Office blocks install | Add `<RemoveMSI />` |

## Cleanup / rollback

Keep the ODT package as your standard M365 deployment. Unassign the built-in app to avoid two owners.

## Stretch challenge

Add a language pack (for example, `de-de`) with a second Win32 ODT package using `<Product ID="LanguagePack">` and make it depend on the base package.

## Knowledge check

1. Why does Microsoft recommend a Win32 ODT package for M365 Apps in the Autopilot ESP?
2. What's the ODT install command line?
3. Which edition can only be deployed with XML in Intune's built-in app type?

<details>
<summary>Answers</summary>

1. The built-in type isn't managed by the **IME**, so it can install concurrently with Win32 apps and cause ESP failures. The Win32 package is sequenced by the IME.
2. `setup.exe /configure configuration.xml`.
3. **Microsoft 365 Apps for business** (`O365BusinessRetail`).

</details>
