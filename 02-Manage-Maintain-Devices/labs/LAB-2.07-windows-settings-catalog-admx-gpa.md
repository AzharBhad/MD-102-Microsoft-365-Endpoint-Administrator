# LAB-2.07 - Settings catalog, ADMX import, Group Policy analytics and OMA-URI

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.07 | 2.2.1 | 75 min | Intermediate |

**Goal:** Build Windows configuration with the settings catalog, import a third-party ADMX, migrate a GPO with Group Policy analytics, deploy a custom OMA-URI, and resolve a deliberate conflict.

## Prerequisites

- CONTOSO-LAB-01 or -03 enrolled, in `DG-Lab-Windows-Corporate`.
- A GPO XML export. If you have no AD, use the sample `08-Scripts/samples/sample-gpo-report.xml` provided in this repo.
- Google Chrome ADMX templates (download the enterprise bundle from Google) or any vendor ADMX/ADML.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Settings catalog baseline

**Devices > Configuration > Create > Windows 10 and later > Settings catalog** → `WIN-Lab-Baseline`:

| Category | Setting | Value |
|---|---|---|
| Camera | Allow Camera | Not allowed |
| Microsoft Edge | Configure the new tab page URL | `https://www.office.com` |
| Start | Hide Recommended Section | Enabled (Windows 11) |
| Experience | Allow Windows Spotlight (User) | Block |

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** Sync the device → the policy reports **Succeeded**. The camera app is blocked, and Edge opens office.com in a new tab.

### Step 2 - Import a custom ADMX

1. **Devices > Configuration > Import ADMX > Import** → upload `chrome.admx` + `en-US\chrome.adml`. If the upload complains about a missing reference, upload `google.admx` / `google.adml` first.
2. Wait for **Available**.
3. **Create > Templates > Imported Administrative templates** → `WIN-Chrome` → *Google Chrome > Startup, Home page and New Tab page* → *Action on startup* = Open a list of URLs → URLs `https://portal.manage.microsoft.com` → assign.

**Expected result:** The ADMX is *Available*. The Chrome policy applies (`chrome://policy` on the device lists it).

### Step 3 - Group Policy analytics

1. **Devices > Manage devices > Group Policy analytics > Import** → upload your GPO XML.
2. Review **MDM Support** % and unsupported settings.
3. Select supported settings → **Migrate** → create settings catalog policy `WIN-Migrated-GPO` (don't assign yet).

**Expected result:** The migration creates a settings catalog policy with the mapped settings.

### Step 4 - Custom OMA-URI

**Create > Templates > Custom** → `WIN-OMA-DisableConsumerFeatures`:

| Name | OMA-URI | Type | Value |
|---|---|---|---|
| Turn off consumer features | `./Device/Vendor/MSFT/Policy/Config/Experience/AllowWindowsConsumerFeatures` | Integer | `0` |

Assign → sync.

**Expected result:** Succeeded. The registry key `HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Experience` shows `AllowWindowsConsumerFeatures = 0`.

### Step 5 - Create and resolve a conflict

Create `WIN-Lab-Conflict` (settings catalog) with **Allow Camera = Allowed** → assign to the same device group → sync.

**Expected result:** Both policies show **Conflict** for *Allow Camera*. Remove the setting from `WIN-Lab-Conflict` → sync → the conflict clears.

### Step 6 - Inspect on the device

**Settings > Accounts > Access work or school > [account] > Info** → *Areas managed by…*. Then **Export your management log files** → open `MDMDiagReport.html`.

**Expected result:** The report lists the configured policies (Camera, Experience, Start...).

## Validation

| Check | Expected |
|---|---|
| WIN-Lab-Baseline | Succeeded |
| Chrome ADMX | Available + policy applied |
| GPA migration | Settings catalog policy created |
| Conflict exercise | Conflict shown then resolved |

## Troubleshooting

| Symptom | Fix |
|---|---|
| ADMX upload error | Upload dependency ADMX files first. Check the file size limit |
| Policy "Not applicable" | Edition/OS doesn't support the setting (see *Applies to*) or an assignment filter excludes the device |
| OMA-URI error 0x87d1fde8 (remediation failed) | Wrong path/data type, or the setting isn't supported on this build |

## Cleanup / rollback

Delete `WIN-Lab-Conflict`. Keep the baseline and the Chrome ADMX. Don't assign `WIN-Migrated-GPO` unless you've reviewed every setting.

## Stretch challenge

Use Graph to export `WIN-Lab-Baseline` as JSON (`deviceManagement/configurationPolicies/{id}?$expand=settings`) and re-import it as a copy with a POST - the start of "policy as code".

## Knowledge check

1. Which tool assesses GPOs for MDM support and migrates them?
2. What must you do if an ADMX references another vendor ADMX?
3. What status do two policies with different values for the same setting show?

<details>
<summary>Answers</summary>

1. **Group Policy analytics**.
2. Import the **dependency** ADMX/ADML first.
3. **Conflict**.

</details>
