# Practice questions - Domain 3: Protect devices (15-20%)

All questions are **original** and written for this repository. They aren't taken from the exam. Expand each answer after you've chosen.

## Questions

### Q3.01

Two application teams each need Microsoft Defender Antivirus exclusions on the same devices. You want each team to manage its own list without creating conflicts. What should you do?

- A. Put all exclusions in one antivirus policy and give both teams edit rights.
- B. Create separate **Microsoft Defender Antivirus exclusions** policies per team.
- C. Use a security baseline for exclusions.
- D. Configure exclusions with a custom OMA-URI.

**Objective:** 3.1.1

<details>
<summary>Answer</summary>

**B.** Exclusion policies merge rather than conflict.

</details>

### Q3.02

Local administrators are adding their own Defender exclusions. You need only Intune-defined exclusions to apply. Which setting should you enable?

- A. Allow Cloud Protection
- B. Disable Local Admin Merge
- C. PUA Protection
- D. Enable Network Protection

**Objective:** 3.1.1

<details>
<summary>Answer</summary>

**B.** Tamper protection complements it by preventing other local changes.

</details>

### Q3.03

Windows devices must be encrypted without any user prompts, and standard users must not need admin rights for encryption to start. Which configuration is required? Select two.

- A. Allow warning for other disk encryption = Disabled
- B. Allow standard user encryption = Enabled
- C. Configure TPM startup PIN = Require startup PIN with TPM
- D. Configure encryption for removable data drives = Require
- E. Hide recovery options from users

**Objective:** 3.1.2

<details>
<summary>Answer</summary>

**A and B.** A TPM PIN would require user interaction.

</details>

### Q3.04

Users locked out at the BitLocker recovery screen must be able to retrieve their own recovery key from another device. What's required? Select two.

- A. Recovery keys backed up to Microsoft Entra ID
- B. Entra device setting *Restrict users from recovering the BitLocker key(s) for their owned devices* = No
- C. The user is a member of the Cloud Device Administrator role
- D. A Windows LAPS policy
- E. Keys escrowed only to on-premises AD DS

**Objective:** 3.1.2

<details>
<summary>Answer</summary>

**A and B.** Users then use My Account or the Company Portal.

</details>

### Q3.05

The encryption report shows several devices as *Not encrypted* with the status detail *WinRE not configured*. What should you do?

- A. Increase the key size to XTS-AES 256.
- B. Enable the Windows Recovery Environment on the devices (for example, `reagentc /enable`).
- C. Assign a FileVault policy.
- D. Disable the TPM requirement.

**Objective:** 3.1.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.06

On public networks, only firewall rules defined in Intune may apply. Local rules created by applications must be ignored. What should you configure?

- A. Default inbound action = Block (Public)
- B. Allow Local Policy Merge = False (Public)
- C. Disable Stealth Mode = True
- D. A firewall rules policy blocking all apps

**Objective:** 3.1.3

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.07

You deploy two Windows Firewall **rules** policies to the same device. What's the result?

- A. Conflict - neither applies.
- B. Rules from both policies are applied.
- C. Only the most recent policy applies.
- D. Only the policy with more rules applies.

**Objective:** 3.1.3

<details>
<summary>Answer</summary>

**B.** Rules are additive. Global firewall **settings** can conflict.

</details>

### Q3.08

You plan to enable ASR rules but need to understand impact on line-of-business Office macros first. Which mode should you use initially?

- A. Block
- B. Warn
- C. Audit
- D. Off

**Objective:** 3.1.4

<details>
<summary>Answer</summary>

**C.** Then review event 1122 / the Defender ASR report and add per-rule exclusions before moving to Block.

</details>

### Q3.09

Users must be prevented from copying data to unapproved USB drives. An approved encrypted USB model must remain writable. What should you configure?

- A. ASR rule *Block untrusted and unsigned processes that run from USB*
- B. **Device Control** policy with an allow rule for the approved device and a deny-write rule for other removable storage
- C. BitLocker To Go
- D. App Control for Business

**Objective:** 3.1.4

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.10

Which set of controls best maps to the Zero Trust principle **assume breach** on endpoints?

- A. MFA and Conditional Access
- B. ASR rules, network protection, EDR in block mode, device isolation
- C. Windows LAPS and EPM
- D. Company Portal branding

**Objective:** 3.1.4

<details>
<summary>Answer</summary>

**B.** A = verify explicitly. C = least privilege.

</details>

### Q3.11

You want Microsoft's recommended Windows hardening with the least configuration effort, and later adopt new recommendations when Microsoft updates them. What should you use?

- A. Settings catalog policy built manually
- B. Security baseline for Windows, updated to new versions as released
- C. Group Policy analytics
- D. Compliance policy

**Objective:** 3.1.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.12

After you assign the Windows security baseline, BitLocker settings show **Conflict** on devices that also receive your endpoint security disk encryption policy. The security team owns BitLocker. What should you do?

- A. Delete the disk encryption policy.
- B. Set the BitLocker settings in the baseline to Not configured.
- C. Assign the baseline to user groups.
- D. Change the baseline version.

**Objective:** 3.1.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.13

Devices that Defender for Endpoint rates as high risk must lose access to SharePoint Online. Which three components are required? Select three.

- A. Intune–Defender for Endpoint connector enabled on both sides
- B. Compliance policy with *Require the device to be at or under the machine risk score*
- C. Conditional Access policy requiring a compliant device
- D. An app protection policy
- E. A security baseline

**Objective:** 3.1.6

<details>
<summary>Answer</summary>

**A, B and C.**

</details>

### Q3.14

A SOC analyst needs to stop a compromised laptop from communicating on the network while keeping the Defender connection for investigation. Which action should they take?

- A. Intune Wipe
- B. Defender **Isolate device**
- C. Intune Retire
- D. Disable the user in Entra ID

**Objective:** 3.1.6

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.15

You need to onboard all Intune-managed Windows 11 devices to Defender for Endpoint with the least administrative effort. What should you do?

- A. Download the onboarding script and run it on each device.
- B. Create an **EDR** policy with *Auto from connector*.
- C. Deploy the Defender app from the Microsoft Store.
- D. Use Group Policy.

**Objective:** 3.1.7

<details>
<summary>Answer</summary>

**B.** Windows has a built-in sensor. Onboarding only configures it.

</details>

### Q3.16

How are iOS devices onboarded to Defender for Endpoint with Intune?

- A. EDR policy for iOS
- B. Deploy the Microsoft Defender app (with app configuration). Onboarding completes when the user signs in, or via zero-touch on supervised devices
- C. SCEP certificate profile
- D. Custom .mobileconfig

**Objective:** 3.1.7

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.17

Only Windows components, Microsoft Store apps, and applications deployed through Intune may run. Which configuration should you use? Select two.

- A. Configure the Intune Management Extension as a **managed installer**
- B. App Control for Business built-in controls: trust Windows components/Store apps + **trust apps from managed installers**
- C. AppLocker executable rules
- D. ASR rule *Block executable files unless they meet a prevalence criterion*
- E. SmartScreen

**Objective:** 3.1.8

<details>
<summary>Answer</summary>

**A and B.**

</details>

### Q3.18

An app installed six months ago is blocked after you enforce an App Control policy that trusts managed installers. The app was deployed by Intune. Why?

- A. The managed installer only tags files installed **after** it was enabled.
- B. Managed installers don't support Win32 apps.
- C. The app lacks a Store signature.
- D. ISG must be disabled.

**Objective:** 3.1.8

<details>
<summary>Answer</summary>

**A.** Reinstall through Intune or add a rule (supplemental policy).

</details>

### Q3.19

You need devices to stay on Windows 11, version 24H2 while you validate 25H2, and still receive monthly security updates. What should you configure?

- A. Update ring with a 365-day feature deferral
- B. **Feature update policy** targeting 24H2 + update ring for quality updates
- C. Pause feature updates for 35 days
- D. Expedited quality update

**Objective:** 3.2.1, 3.2.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.20

A critical zero-day patch was released. Devices in the broad ring have a 7-day quality deferral. You must install the patch within 24 hours. What should you do?

- A. Change the ring deferral to 0 and wait.
- B. Create an **expedited** quality update policy with a 1-day restart.
- C. Pause the ring.
- D. Create a driver update policy.

**Objective:** 3.2.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.21

You need Windows, Microsoft 365 Apps, Edge and driver updates managed in coordinated rings with minimal policy maintenance. What should you use?

- A. Individual update ring policies
- B. **Windows Autopatch groups**
- C. WSUS
- D. Configuration Manager

**Objective:** 3.2.3

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.22

*Yes/No series.* A device is targeted by a quality update policy with Hotpatch = Allow.

1. The device must run Windows 11 24H2 or later Enterprise.
2. Virtualization-based security must be running.
3. The device will never restart for updates again.

**Objective:** 3.2.3

<details>
<summary>Answer</summary>

1. **Yes**.
2. **Yes**.
3. **No** - quarterly baselines and some fixes still require a restart.

</details>

### Q3.23

Corporate iPhones on iOS 18 must update to iOS 18.6 by Friday 18:00 local time. What should you configure?

- A. iOS update policy (MDM) with a schedule
- B. Settings catalog **DDM Software Update** with Target OS Version and Target Local Date Time
- C. Compliance policy minimum OS 18.6 only
- D. App configuration policy

**Objective:** 3.2.4

<details>
<summary>Answer</summary>

**B.** MDM update policies are deprecated. Compliance can back it up but doesn't install anything.

</details>

### Q3.24

Zebra scanners enrolled as dedicated devices must be locked to a validated firmware version and updated only during a scheduled window. What should you use?

- A. Device restrictions > System update > Automatic
- B. **Zebra LifeGuard OTA** FOTA deployment (Intune Plan 2)
- C. OEMConfig for Samsung
- D. Compliance minimum patch level

**Objective:** 3.2.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q3.25

A branch office has two subnets behind different NAT addresses. Devices in both subnets should share update content with each other but not with devices at other sites. Which Delivery Optimization configuration should you use?

- A. Download mode LAN (1)
- B. Download mode Group (2) with a Group ID per site
- C. Download mode Internet (3)
- D. Download mode Simple (99)

**Objective:** 3.2.6

<details>
<summary>Answer</summary>

**B.** LAN peers only behind the same public IP.

</details>

### Q3.26

An update ring shows *Succeeded* for all devices, but management asks which devices actually installed last month's security update. Which report should you use?

- A. Update ring device status
- B. Windows Autopatch quality update report (or Windows quality update reports)
- C. Device compliance report
- D. Enrollment failures report

**Objective:** 3.2.7

<details>
<summary>Answer</summary>

**B.** Ring status shows policy delivery, not patch level.

</details>
