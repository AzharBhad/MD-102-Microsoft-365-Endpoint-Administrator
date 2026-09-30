# Lab environment setup

Every lab in this repo assumes the environment below. Build it once (about 3-4 hours) and reuse it for all 55 labs.

> **Golden rule:** Use a **dedicated lab tenant**. Never run these labs in your employer's production tenant. Several labs wipe devices, change tenant-wide enrollment settings, or turn on multi-admin approval.

## 1. Choose a tenant option

| Option | Cost | Duration | Includes | Notes |
|---|---|---|---|---|
| **Microsoft 365 E5 trial** (recommended) | Free (card may be required) | 30 days, typically one extension | 25 × Microsoft 365 E5 (Intune Plan 1, Entra ID P2, Windows Enterprise E5, Defender for Endpoint P2) | Create a *new* tenant for it. Set a calendar reminder for expiry. |
| **Microsoft 365 Developer Program E5 sandbox** | Free | 90 days, renews with activity | 25 × E5 | Eligibility has been restricted since 2024 (Visual Studio Professional/Enterprise subscribers or qualifying program members). Check your eligibility at [developer.microsoft.com/microsoft-365/dev-program](https://developer.microsoft.com/microsoft-365/dev-program). |
| **Intune trial** (standalone) | Free | 30 days | Intune + EMS trial (Entra ID P1/P2) | Useful to add to an existing test tenant. |
| **Intune Suite trial** | Free | Trial via **Tenant administration > Intune add-ons** | EPM, Enterprise App Management, Cloud PKI, Remote Help, Advanced Analytics | Needed only if your tenant does not already get them through the July 2026 Microsoft 365 E3/E5 inclusion. |
| **Windows 365** | Paid, or a time-limited trial if offered in **Microsoft 365 admin center > Marketplace** | Monthly | Cloud PCs | Trial availability changes. If unavailable, complete [LAB-2.05](../02-Manage-Maintain-Devices/labs/LAB-2.05-windows-365-cloud-pc.md) as a portal walkthrough up to the licence-assignment step. |

### Naming convention used in every lab

| Object | Placeholder |
|---|---|
| Tenant | `contoso.onmicrosoft.com` (replace with your trial domain) |
| Tenant ID | `00000000-0000-0000-0000-000000000000` |
| Admin | `admin@contoso.onmicrosoft.com` |
| Second admin (multi-admin approval) | `admin2@contoso.onmicrosoft.com` |
| Help desk | `helpdesk1@contoso.onmicrosoft.com` |
| Standard users | `user1@...` through `user5@...` |
| VMs | `CONTOSO-LAB-01`, `CONTOSO-LAB-02` |

## 2. Create users and groups

Run [`08-Scripts/setup/New-LabUsersAndGroups.ps1`](../08-Scripts/setup/New-LabUsersAndGroups.ps1) (Microsoft Graph PowerShell), or create them manually in the Microsoft Entra admin center.

| Group | Type | Membership | Used in |
|---|---|---|---|
| `SG-Lab-Users` | Security, assigned | user1-user5 | Most labs |
| `SG-Lab-Pilot-Users` | Security, assigned | user1, user2 | Update rings, EPM, app deployment |
| `SG-Lab-Helpdesk` | Security, assigned | helpdesk1 | RBAC, Remote Help |
| `SG-Lab-MAA-Approvers` | Security, assigned | admin2 | Multi-admin approval |
| `DG-Lab-Windows-Corporate` | Security, dynamic device | `(device.deviceOSType -eq "Windows") and (device.deviceOwnership -eq "Company")` | Configuration, security |
| `DG-Lab-Autopilot` | Security, dynamic device | `(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))` | Autopilot |
| `SG-Lab-ETG-Windows` | Security, assigned, **owner = Intune Provisioning Client** | Empty | Autopilot device preparation (enrollment time grouping) |

Assign **Microsoft 365 E5** licences to admin, user1-user5, and helpdesk1. Enable **group-based licensing** on `SG-Lab-Users` if you prefer.

## 3. Baseline tenant settings

1. **Intune admin center > Tenant administration > Tenant status** → confirm *MDM authority = Microsoft Intune*.
2. **Entra admin center > Mobility (MDM and WIP) > Microsoft Intune** → *MDM user scope = Some* → `SG-Lab-Users`. ([LAB-1.02](../01-Prepare-Infrastructure/labs/LAB-1.02-entra-join-automatic-enrollment.md) walks through this in detail.)
3. **Entra admin center > Devices > Device settings** → *Users may join devices to Microsoft Entra = All* (lab only), *Maximum number of devices per user = 50*.
4. Turn **Security defaults off** once you create Conditional Access policies in [LAB-1.11](../01-Prepare-Infrastructure/labs/LAB-1.11-compliance-conditional-access.md). Keep a break-glass admin excluded from every CA policy.
5. Create a break-glass account `breakglass@contoso.onmicrosoft.com` with Global Administrator, a long random password stored offline, and exclusion from all CA policies.

## 4. Windows client VMs (Hyper-V)

Windows Autopilot, BitLocker, Windows Hello for Business and Hotpatch labs need **Generation 2 VMs with a virtual TPM**.

| Setting | Value |
|---|---|
| Host | Windows 11 Pro/Enterprise with Hyper-V, 16 GB RAM or more recommended |
| Generation | 2 |
| Secure Boot | On (Microsoft Windows template) |
| Trusted Platform Module | **On** (Hyper-V Manager > Security) |
| Memory | 4 GB static (dynamic memory can break Autopilot TPM attestation and some ESP scenarios) |
| vCPU | 2 or more |
| Disk | 64 GB or more |
| ISO | Windows 11 Enterprise evaluation or media from your Visual Studio subscription |
| Checkpoints | Take a checkpoint at OOBE (`CONTOSO-LAB-01 - OOBE clean`) so you can replay Autopilot labs |

```powershell
# Run on the Hyper-V host (elevated). Creates a Gen2 VM with vTPM.
$vm = 'CONTOSO-LAB-01'
New-VM -Name $vm -Generation 2 -MemoryStartupBytes 4GB -NewVHDPath "D:\Hyper-V\$vm.vhdx" -NewVHDSizeBytes 64GB -SwitchName 'Default Switch'
Set-VMProcessor -VMName $vm -Count 2
Set-VMMemory -VMName $vm -DynamicMemoryEnabled $false
Set-VMKeyProtector -VMName $vm -NewLocalKeyProtector
Enable-VMTPM -VMName $vm
Add-VMDvdDrive -VMName $vm -Path 'D:\ISO\Win11_Enterprise_x64.iso'
Set-VMFirmware -VMName $vm -FirstBootDevice (Get-VMDvdDrive -VMName $vm)
```

> **Limitations of VMs:** TPM attestation for Autopilot **self-deploying** and **pre-provisioning** modes works on Hyper-V vTPM in most builds but is not officially supported for production; if attestation fails, treat [LAB-2.03](../02-Manage-Maintain-Devices/labs/LAB-2.03-autopilot-preprovisioning-self-deploying.md) as a walkthrough. Hotpatch requires VBS, which needs nested virtualization (`Set-VMProcessor -ExposeVirtualizationExtensions $true`).

### Azure VMs (alternative)

Azure VMs are fine for Entra join, enrollment, configuration, security policy, app deployment and Endpoint analytics labs. **Windows Autopilot is not supported on Azure VMs.** Use a Trusted Launch VM (vTPM + Secure Boot) with a Windows 11 Enterprise image, and **deallocate or delete** it after each session.

## 5. Mobile and macOS devices

| Platform | Minimum lab kit | If you have no device |
|---|---|---|
| Android | Any Android 10+ phone, or an Android emulator with Google Play (Android Studio) for work profile | Walk through the portal and use the enrollment-profile QR code screen as the validation point |
| iOS/iPadOS | Any supported iPhone/iPad for BYOD user enrollment | ADE requires an Apple Business Manager organization and devices from a participating reseller - [LAB-1.07](../01-Prepare-Infrastructure/labs/LAB-1.07-apple-business-manager-ade.md) is a portal walkthrough |
| macOS | A spare Mac or a macOS VM on Apple hardware | Portal walkthrough |

Required connectors (free): **Apple MDM Push certificate** (needs an Apple Account - use a shared, non-personal lab Apple Account), **Managed Google Play** binding (Google account).

## 6. Security Copilot (Domain 5 agent labs)

- Microsoft 365 **E5/E7 paid** tenants get auto-provisioned capacity. Trial tenants may not be eligible for inclusion; check **Security Copilot portal > Owner settings** or the Intune **Agents** node.
- Otherwise, provision **1 SCU** in the Azure portal only for the duration of [LAB-5.02](../05-Optimize-Endpoint-Operations/labs/LAB-5.02-security-copilot-agents.md) and **delete the capacity immediately afterward**. Provisioned SCUs are billed every hour.
- The Vulnerability Remediation Agent also needs Defender Vulnerability Management data (Defender for Endpoint P2 or Defender Vulnerability Management Standalone). Onboard at least one VM to Defender for Endpoint in [LAB-3.05](../03-Protect-Devices/labs/LAB-3.05-defender-for-endpoint.md) first.

## 7. Configuration Manager

Configuration Manager, co-management and tenant attach are **not in the October 27, 2026 skills outline**, so no ConfigMgr lab is required. If you want background for job interviews, Microsoft's [Configuration Manager evaluation lab kit](https://learn.microsoft.com/intune/configmgr/core/get-started/2019/evaluation-and-lab) is still available.

## Cost-avoidance checklist

- [ ] Calendar reminder 5 days before each trial expires (E5, Intune Suite, Windows 365).
- [ ] Delete any **Security Copilot capacity** created in Azure the same day you finish [LAB-5.02](../05-Optimize-Endpoint-Operations/labs/LAB-5.02-security-copilot-agents.md).
- [ ] **Deallocate or delete Azure VMs**, public IPs, and managed disks after each session (`az group delete -n rg-md102-lab`).
- [ ] Delete the **Microsoft Tunnel** Linux server VM after [LAB-2.15](../02-Manage-Maintain-Devices/labs/LAB-2.15-microsoft-tunnel-mam.md).
- [ ] Remove Windows 365 licences from users before a paid trial converts.
- [ ] Do not attach a payment method you are not willing to have charged; set an **Azure budget alert** (for example, US$10) on the lab subscription.
- [ ] Export anything you want to keep (scripts, notes) - trial tenants are deleted after expiry.

## Microsoft Learn references

- [Sign up for a Microsoft Intune free trial](https://learn.microsoft.com/intune/fundamentals/free-trial-sign-up)
- [Use Microsoft Intune Suite add-on capabilities](https://learn.microsoft.com/intune/fundamentals/add-ons)
- [Windows Autopilot requirements](https://learn.microsoft.com/autopilot/requirements)
- [Get started with Microsoft Security Copilot](https://learn.microsoft.com/copilot/security/get-started-security-copilot)
- [Hyper-V: Generation 2 VM security settings](https://learn.microsoft.com/windows-server/virtualization/hyper-v/learn-more/generation-2-virtual-machine-security-settings-for-hyper-v)
