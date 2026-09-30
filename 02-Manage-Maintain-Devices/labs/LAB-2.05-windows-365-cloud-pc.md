# LAB-2.05 - Windows 365 Cloud PC provisioning

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.05 | 2.1.7 | 60 min (+ provisioning) | Intermediate |

**Goal:** Provision a Windows 365 Enterprise Cloud PC on the Microsoft-hosted network with a gallery image, configure user settings (restore points), review an Azure network connection design, and manage the Cloud PC.

> **Licensing caveat:** You need at least one Windows 365 Enterprise license (paid or trial if offered). Without one, complete Steps 1-4 up to the review page and use the validation questions.

## Prerequisites

- user5 licensed with Microsoft 365 E5 (Windows Enterprise E3/E5 + Intune + Entra ID P1).
- Windows 365 Enterprise license for user5 (for provisioning).
- Group `SG-Lab-CloudPC-Users` containing user5.
- *(Optional ANC design task)* an Azure subscription.

## Required licenses

Windows 365 Enterprise (per user) + the base licenses above.

## Steps

### Step 1 - Explore the Windows 365 node

**Devices > Windows 365** → review *Overview*, *Provisioning policies*, *Custom images*, *Azure network connection*, *User settings*, *All Cloud PCs*.

**Expected result:** You can identify where each building block lives.

### Step 2 - User settings

**User settings > Create** → `W365-UserSettings-Lab` → *Enable local admin* = No → **Point-in-time restore service**: frequency **12 hours**, *Allow user to initiate restore* = Yes → assign `SG-Lab-CloudPC-Users`.

**Expected result:** Created.

### Step 3 - Provisioning policy

**Provisioning policies > Create policy** → `W365-Ent-EntraJoin-MSHosted`:

- License type: **Enterprise**
- Join type: **Microsoft Entra join** → Network: **Microsoft hosted network** → Geography/region: closest to you
- Use **Microsoft Entra single sign-on**: Yes
- Image: **Gallery image** → *Windows 11 Enterprise + Microsoft 365 Apps* (Windows 365 optimized)
- Language: English (United States)
- Additional services: **Windows Autopatch** (optional)
- Cloud PC naming: `CPC-%USERNAME:4%-%RAND:5%`
- Assign: `SG-Lab-CloudPC-Users`

**Expected result:** The policy is created. With a license, **All Cloud PCs** shows user5's Cloud PC as *Provisioning*.

### Step 4 - (Design) Azure network connection

Without creating it, list what an ANC for **hybrid join** needs: subscription, resource group, vNet/subnet, DNS that resolves AD, line of sight to DCs, AD domain FQDN, OU, domain-join service account, outbound access to Windows 365 endpoints. Note the **health checks** Intune runs.

**Expected result:** A written checklist in your notes.

### Step 5 - Connect

When the status is **Provisioned**: user5 goes to `https://windows365.microsoft.com` (or Windows App) → connect.

**Expected result:** A Windows 11 desktop. In Intune the Cloud PC appears under **Devices > Windows** as an Entra joined, Intune-managed device.

### Step 6 - Manage

Try: **Restart**, **Create restore point** (if available), **Restore** to a restore point, and **Collect diagnostics**. Review **Reports > Cloud PC overview** / *Connection quality*.

**Expected result:** Actions succeed. Reports show the session.

## Validation

| Check | Expected |
|---|---|
| Join type | Microsoft Entra joined |
| Managed by | Intune |
| Policy applied | Your configuration/compliance policies apply as to any Windows device |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No Cloud PC created | User lacks a Windows 365 license **or** isn't in the assigned group. Check **All Cloud PCs** for errors |
| Provisioning failed - Intune enrollment | MDM user scope/enrollment restrictions block the Cloud PC. Allow Windows in restrictions |
| ANC health check fails (hybrid) | DNS can't resolve the domain, the OU or service account is wrong, or outbound endpoints are blocked |

## Cleanup / rollback

**Remove the Windows 365 license** from user5 to deprovision (there's a grace period before deletion), or use **End grace period**. Delete the provisioning policy afterwards. **Stop trial billing** before conversion.

## Stretch challenge

Upload a **custom image** from an Azure managed image (Gen2, sysprep generalized) and create a second provisioning policy that uses it. Compare provisioning times.

## Knowledge check

1. Which network option is required for hybrid joined Cloud PCs?
2. Where does the Cloud PC's vCPU/RAM size come from (Enterprise)?
3. How do you let users roll back their Cloud PC themselves?

<details>
<summary>Answers</summary>

1. **Azure network connection**.
2. The assigned **Windows 365 license** SKU.
3. **User settings** policy with point-in-time restore and *Allow user to initiate restore*.

</details>
