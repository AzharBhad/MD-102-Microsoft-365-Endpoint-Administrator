# Practice questions - Domain 2: Manage and maintain devices (25-30%)

All questions are **original** and written for this repository. They aren't taken from the exam. Expand each answer after committing to your choice.

## Questions

### Q2.01

Contoso operates in a GCC High tenant and wants to deploy new Windows 11 laptops without collecting hardware hashes. Users sign in during setup. What should you use?

- A. Windows Autopilot deployment profile in user-driven mode
- B. Windows Autopilot device preparation policy in user-driven mode
- C. Windows Autopilot self-deploying mode
- D. A provisioning package

**Objective:** 2.1.1

<details>
<summary>Answer</summary>

**B.** Device preparation doesn't need registration and supports GCC High/DoD. Classic profiles need hardware hash registration.

</details>

### Q2.02

Which requirement forces you to use a classic Windows Autopilot deployment profile instead of a device preparation policy?

- A. Devices must be Microsoft Entra joined.
- B. Win32 and LOB apps must install during OOBE.
- C. Devices must be Microsoft Entra hybrid joined.
- D. Deployment progress must be visible in near real time.

**Objective:** 2.1.1

<details>
<summary>Answer</summary>

**C.** Device preparation supports Entra join only. B and D are advantages of device preparation.

</details>

### Q2.03

You assign a Windows Autopilot device preparation policy. Which object must the policy's **device security group** have as its owner?

- A. The Microsoft Intune Enrollment app
- B. The Intune Provisioning Client service principal
- C. The Windows Autopilot Deployment Service
- D. The Global Administrator who created the policy

**Objective:** 2.1.1

<details>
<summary>Answer</summary>

**B.** It allows enrollment time grouping to add devices to the static group.

</details>

### Q2.04

A retail company needs lobby kiosks to be deployed without any user signing in. Devices have TPM 2.0 and a wired network. Which Autopilot mode should you use?

- A. User-driven
- B. Pre-provisioning
- C. Self-deploying
- D. Existing devices

**Objective:** 2.1.2

<details>
<summary>Answer</summary>

**C.**

</details>

### Q2.05

Users at remote sites complain that the first sign-in on new laptops takes more than two hours because of large engineering apps. A partner can stage devices before shipping. What should you implement?

- A. Self-deploying mode
- B. Pre-provisioning (technician flow + reseal)
- C. Increase the ESP timeout to 240 minutes
- D. Remove the apps from the ESP

**Objective:** 2.1.2

<details>
<summary>Answer</summary>

**B.** Device-targeted apps install during the technician flow. The user phase is short. Assign the large apps to device groups.

</details>

### Q2.06

*Yes/No series.* You configure Autopilot devices to be Microsoft Entra hybrid joined.

1. You can use self-deploying mode.
2. The device name template in the Autopilot profile determines the computer name.
3. You need the Intune Connector for Active Directory.

**Objective:** 2.1.2, 2.1.3

<details>
<summary>Answer</summary>

1. **No** - self-deploying is Entra join only.
2. **No** - hybrid devices get names from the **Domain Join** profile's prefix.
3. **Yes**.

</details>

### Q2.07

You configure the device name template `CONTOSO-LAPTOP-%SERIAL%`. What's the problem?

- A. `%SERIAL%` isn't supported.
- B. The name exceeds the 15-character limit before the serial is added.
- C. Hyphens aren't allowed.
- D. Templates only work with self-deploying mode.

**Objective:** 2.1.3

<details>
<summary>Answer</summary>

**B.** `CONTOSO-LAPTOP-` is already 15 characters, leaving no room. Use a shorter prefix such as `CON-%SERIAL%`.

</details>

### Q2.08

You import 50 Autopilot hardware hashes and create a profile. A technician starts OOBE on one device 2 minutes later and sees the standard Windows OOBE. What's the most likely cause?

- A. The ESP isn't configured.
- B. The profile status isn't yet **Assigned** for the device.
- C. Company branding is missing.
- D. The device needs a device name template.

**Objective:** 2.1.4

<details>
<summary>Answer</summary>

**B.** Wait until the profile shows *Assigned*, then reset/restart OOBE.

</details>

### Q2.09

Which component displays your company logo on the Autopilot sign-in page?

- A. Intune Company Portal customization
- B. Microsoft Entra company branding
- C. The Autopilot deployment profile
- D. The Enrollment Status Page

**Objective:** 2.1.4

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.10

Users must not reach the desktop until Microsoft 365 Apps, the VPN client, and the Wi-Fi certificate are installed. Other apps may install later. How should you configure the ESP? Select two.

- A. Block device use until all apps and profiles are installed = Yes
- B. Block device use until required apps are installed = **Selected** (M365 Apps, VPN client)
- C. Block device use until required apps are installed = **All**
- D. Only show page to devices provisioned by OOBE = No
- E. Allow users to use device if installation error occurs = Yes

**Objective:** 2.1.5

<details>
<summary>Answer</summary>

**A and B.** Certificates and profiles are tracked with the blocking setting. Selected apps keep OOBE short.

</details>

### Q2.11

Autopilot deployments fail in the ESP when a device installs both an MSI line-of-business app and several Win32 apps. What should you do?

- A. Increase the ESP timeout.
- B. Repackage the MSI as a Win32 app.
- C. Disable the account setup phase.
- D. Use a provisioning package.

**Objective:** 2.1.5

<details>
<summary>Answer</summary>

**B.** Mixing LOB MSI and Win32 installs in the ESP (classic Autopilot) causes TrustedInstaller conflicts.

</details>

### Q2.12

You need to upgrade Windows 10 devices to Windows 11, version 25H2 over two weeks with automatic batching. Which policy should you create?

- A. Update ring with a feature update deferral of 14 days
- B. Feature update policy with **Make update available gradually**
- C. Expedited quality update policy
- D. Edition upgrade profile

**Objective:** 2.1.6

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.13

The **Windows feature update device readiness report** is empty. Which two settings should you check? Select two.

- A. Windows data connector: *Enable features that require Windows diagnostic data*
- B. Windows license verification
- C. MDM user scope
- D. Device limit restriction
- E. Company Portal branding

**Objective:** 2.1.6

<details>
<summary>Answer</summary>

**A and B** (plus devices sending diagnostic data).

</details>

### Q2.14

Cloud PCs must be Microsoft Entra hybrid joined so users can authenticate to legacy on-premises apps with their domain accounts. What must you configure?

- A. Microsoft-hosted network
- B. An Azure network connection
- C. A custom image
- D. Windows 365 Business

**Objective:** 2.1.7

<details>
<summary>Answer</summary>

**B.** Hybrid join requires an ANC with line of sight to domain controllers.

</details>

### Q2.15

You want Cloud PC users to roll back their own Cloud PC to an earlier state. What should you configure?

- A. A provisioning policy
- B. A user settings policy with point-in-time restore and user-initiated restore
- C. Windows Backup for Organizations
- D. An Autopilot Reset

**Objective:** 2.1.7

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.16

Users replacing laptops want their Windows personalization and Microsoft Store apps restored automatically. New devices are deployed with user-driven Autopilot and Microsoft Entra join. Which two actions should you perform? Select two.

- A. Enable **Enable Windows backup** in a settings catalog policy.
- B. Turn on **Show restore page** under Devices > Enrollment > Windows > Windows Backup and Restore.
- C. Configure Autopilot self-deploying mode.
- D. Enable OneDrive Known Folder Move.
- E. Hybrid join the new devices.

**Objective:** 2.1.8

<details>
<summary>Answer</summary>

**A and B.** D is for files (a good idea, but not what's asked). C and E aren't supported for restore.

</details>

### Q2.17

You need to configure Google Chrome settings on Windows devices by using Intune. Google provides ADMX templates. What should you do first?

- A. Create a custom OMA-URI profile.
- B. Import the ADMX and ADML files in Intune.
- C. Use Group Policy analytics.
- D. Create an administrative templates profile.

**Objective:** 2.2.1

<details>
<summary>Answer</summary>

**B.** Then create an *Imported Administrative templates* profile.

</details>

### Q2.18

You're migrating from on-premises Group Policy. You need to know which GPO settings have MDM equivalents and create Intune policies with the least effort. What should you use?

- A. Security baselines
- B. Group Policy analytics
- C. Settings catalog search
- D. Microsoft Configuration Manager

**Objective:** 2.2.1

<details>
<summary>Answer</summary>

**B.** It reports MDM support and can **migrate** supported settings into a settings catalog policy.

</details>

### Q2.19

Two settings catalog policies assigned to the same device configure *Allow Camera* with different values. What happens?

- A. The most recently created policy wins.
- B. Both report **Conflict**, and the result isn't guaranteed.
- C. The more restrictive value always wins.
- D. The device ignores both.

**Objective:** 2.2.1

<details>
<summary>Answer</summary>

**B.** (Compliance policies use "most restrictive". Configuration profiles report conflicts.)

</details>

### Q2.20

Warehouse Android devices are enrolled as **dedicated**. They must show only three apps and prevent users from leaving the launcher. What should you configure?

- A. App protection policy
- B. Device restrictions profile with multi-app kiosk mode (Managed Home Screen)
- C. OEMConfig for Samsung
- D. Personally owned work profile restrictions

**Objective:** 2.2.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.21

An iOS restriction that blocks AirDrop applies to company iPads but not to employees' personal iPhones enrolled with the Company Portal. Why?

- A. The APNs certificate expired.
- B. The setting requires supervised devices.
- C. Personal devices need an app protection policy.
- D. The profile must be assigned to device groups.

**Objective:** 2.2.3

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.22

macOS devices must allow Microsoft Defender Full Disk Access without users approving prompts. Which payload should you deploy?

- A. System extensions
- B. Privacy Preferences Policy Control (PPPC)
- C. Platform SSO
- D. FileVault

**Objective:** 2.2.4

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.23

You need to configure barcode symbologies on Zebra rugged devices enrolled as Android Enterprise dedicated devices. What should you use?

- A. Custom OMA-URI profile
- B. OEMConfig profile with the Zebra OEMConfig app
- C. App configuration policy for Managed Home Screen
- D. Device restrictions profile

**Objective:** 2.2.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.24

How should you deploy Microsoft Teams Rooms on Windows devices with Windows Autopilot?

- A. User-driven mode with the room's resource account signing in during OOBE
- B. Self-deploying mode, with the Teams Rooms resource account assigned to the Autopilot device for autologon
- C. Pre-provisioning with hybrid join
- D. Autopilot device preparation assigned to the resource account

**Objective:** 2.2.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.25

A configuration profile is assigned to **All devices**. You need to prevent it from applying to devices whose name starts with `MTR-`, without creating new groups. What should you do?

- A. Add an exclusion group.
- B. Add an assignment filter in **Exclude** mode with `(device.deviceName -startsWith "MTR-")`.
- C. Create a scope tag.
- D. Use a device category.

**Objective:** 2.2.6

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.26

Apps assigned to corporate Android fully managed devices arrive hours after enrollment because a dynamic group takes time to evaluate. What should you configure?

- A. An assignment filter
- B. Enrollment time grouping in the Android enrollment profile
- C. A device limit restriction
- D. A staging token

**Objective:** 2.2.6

<details>
<summary>Answer</summary>

**B.** Note that staging tokens don't support ETG.

</details>

### Q2.27

Standard users must be able to run a specific signed diagnostic tool with administrative rights. The elevation must be silent. Which Endpoint Privilege Management configuration is required?

- A. User confirmed rule with the publisher certificate
- B. Automatic rule including the file hash
- C. Support approved rule
- D. Default elevation response = Require user confirmation

**Objective:** 2.3.1

<details>
<summary>Answer</summary>

**B.** Automatic rules require a file hash.

</details>

### Q2.28

A user is targeted by a user-scoped *User confirmed* rule and a device-scoped *Deny* rule for the same file. What happens when the user requests elevation?

- A. User confirmed wins because user-targeted rules take precedence.
- B. Deny wins.
- C. The default elevation response applies.
- D. Both prompts appear.

**Objective:** 2.3.1

<details>
<summary>Answer</summary>

**B.** Deny rules always take precedence.

</details>

### Q2.29

You need to deploy 7-Zip, Notepad++ and VLC to Windows devices without packaging them yourself, and be notified when updates are available. What should you use?

- A. Microsoft Store app (new)
- B. Enterprise App Catalog
- C. Line-of-business app
- D. Windows web app

**Objective:** 2.3.2

<details>
<summary>Answer</summary>

**B.** (The Store/WinGet can also avoid packaging, but update notification with supersedence is an Enterprise App Management feature.)

</details>

### Q2.30

Help desk operators must be able to respond to UAC prompts during remote sessions with Microsoft Entra-authenticated users, and sessions must be reported. What should you configure?

- A. Quick Assist
- B. Remote Help with the Elevation permission in the help desk role
- C. Remote Desktop with LAPS
- D. Windows 365 Frontline

**Objective:** 2.3.3

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.31

You need to issue certificates for EAP-TLS Wi-Fi to Intune-managed devices without deploying NDES or any on-premises servers, while keeping your existing enterprise root CA. What should you implement?

- A. Microsoft Cloud PKI with a Cloud PKI root CA
- B. Microsoft Cloud PKI bring your own CA (BYOCA)
- C. PKCS certificate profile
- D. PKCS imported certificate profile

**Objective:** 2.3.4

<details>
<summary>Answer</summary>

**B.** Sign the Cloud PKI issuing CA's CSR with your existing root. Then use SCEP profiles.

</details>

### Q2.32

Unenrolled Android devices must reach intranet sites through Microsoft Edge. Which app acts as the tunnel client?

- A. Company Portal
- B. Microsoft Authenticator
- C. Microsoft Defender
- D. Microsoft Tunnel app

**Objective:** 2.3.5

<details>
<summary>Answer</summary>

**C.** Configured through an app configuration policy. Edge gets its own app configuration + app protection policy.

</details>

### Q2.33

After a driver update, several laptops of one model show frequent stop errors. You want Intune to highlight the common factor automatically. What should you use?

- A. Endpoint analytics startup performance
- B. Advanced Analytics anomalies (device correlation groups)
- C. The device compliance report
- D. Windows Update for Business reports

**Objective:** 2.3.6

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.34

A contractor's personal Android phone has a work profile. The contract ends. You must remove corporate data without affecting personal photos. Which action should you use?

- A. Wipe
- B. Retire
- C. Delete
- D. Autopilot Reset

**Objective:** 2.4.1

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.35

You need to rename 450 Windows devices with a naming template. What should you use?

- A. Bulk device actions in the portal, in one run
- B. Bulk device actions in several runs of up to 100 devices, or Microsoft Graph
- C. The Autopilot device name template
- D. A configuration profile

**Objective:** 2.4.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.36

Compliance reports show many devices with outdated antivirus security intelligence after a network outage. What's the fastest way to fix it?

- A. Change the update ring deferrals.
- B. Run the **Update Windows Defender security intelligence** action in bulk.
- C. Reinstall Microsoft Defender.
- D. Create a new antivirus policy.

**Objective:** 2.4.3

<details>
<summary>Answer</summary>

**B.**

</details>

### Q2.37

A help desk technician read a BitLocker recovery key to a user over the phone. You need the key to be replaced automatically whenever a recovery key is used in the future. What should you configure?

- A. The BitLocker key rotation remote action
- B. Client-driven recovery password rotation in the BitLocker policy
- C. Save BitLocker recovery information to AD DS
- D. A Windows LAPS policy

**Objective:** 2.4.4

<details>
<summary>Answer</summary>

**B.** (The remote action fixes the current key once. The policy handles all future uses.)

</details>

### Q2.38

You click **Rotate local admin password** for a device, but the old password still works an hour later. What's the most likely reason?

- A. LAPS backs up to AD DS.
- B. The device hasn't checked in since the action was issued.
- C. Post-authentication actions are disabled.
- D. The password age is 30 days.

**Objective:** 2.4.5

<details>
<summary>Answer</summary>

**B.** (A would also prevent Intune-driven rotation, but "most likely" given the action was accepted is an offline device.)

</details>

### Q2.39

You need to list every corporate Windows device where the TPM spec version isn't 2.0, then target them with a remediation. What should you use?

- A. Single-device query
- B. Device query for multiple devices, then **Add all items to a group**
- C. Collect diagnostics
- D. Endpoint analytics startup performance

**Objective:** 2.4.6

<details>
<summary>Answer</summary>

**B.** Windows devices need a **properties catalog** policy for inventory.

</details>

### Q2.40

A user reports that three different apps failed to install across her laptop and phone. You want one view of everything assigned to her and its status. Where should you look?

- A. Devices > Monitor > Device actions
- B. Troubleshooting + support > Troubleshoot (select the user)
- C. Collect diagnostics on the laptop
- D. Reports > Endpoint analytics

**Objective:** 2.4.7

<details>
<summary>Answer</summary>

**B.**

</details>
