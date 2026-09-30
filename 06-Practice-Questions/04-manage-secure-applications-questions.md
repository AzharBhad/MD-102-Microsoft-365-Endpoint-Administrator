# Practice questions - Domain 4: Manage and secure applications (15-20%)

All questions are **original** and written for this repository. They aren't taken from the exam. Expand each answer after you've chosen.

## Questions

### Q4.01

You need to deploy a vendor `setup.exe` plus its supporting files and a transform as a single Win32 app in Intune. What must you do first?

- A. Upload the folder to Azure Blob storage and paste the URL into Intune.
- B. Wrap the source folder with the **Microsoft Win32 Content Prep Tool** to create an `.intunewin` file.
- C. Convert the installer to an MSIX package.
- D. Sign the `setup.exe` with a code-signing certificate.

**Objective:** 4.1.1

<details>
<summary>Answer</summary>

**B.** Win32 apps are uploaded as `.intunewin` files created by IntuneWinAppUtil.exe. Everything in the source folder is packaged.

</details>

### Q4.02

A packaging engineer wants a custom detection rule for a Win32 app. When does Intune treat a PowerShell detection script as *detected*?

- A. The script exits with code 0 only.
- B. The script writes anything to STDERR.
- C. The script exits with code 0 **and** writes a string to STDOUT.
- D. The script returns `$true` as its last statement, whatever the exit code.

**Objective:** 4.1.1

<details>
<summary>Answer</summary>

**C.** Both are required: exit code 0 and output on STDOUT. Exit 0 with no output means *not detected*.

</details>

### Q4.03

App A requires the Visual C++ runtime (packaged as Win32 app B). You want Intune to install B automatically on devices that get A, without assigning B separately. What should you configure?

- A. A supersedence relationship from A to B
- B. A **dependency** on B in app A, with *Automatically install* selected
- C. A requirement rule on A that checks for B's registry key
- D. An assignment filter on B

**Objective:** 4.1.2

<details>
<summary>Answer</summary>

**B.** Dependencies can install automatically. A requirement rule would only *skip* A when B is missing.

</details>

### Q4.04

Version 2 of a Win32 app should replace version 1 on all devices. Version 1 has no clean in-place upgrade. What should you configure on version 2?

- A. A dependency on version 1
- B. **Supersedence** of version 1 with *Uninstall previous version* = Yes
- C. An Uninstall assignment for version 2
- D. A new detection rule on version 1

**Objective:** 4.1.2

<details>
<summary>Answer</summary>

**B.** Supersedence with uninstall removes the old version first. Without uninstall it's treated as an in-place update.

</details>

### Q4.05

You need to deploy a Microsoft Store app to Windows devices and keep it updated automatically. Which Intune app type should you use?

- A. Microsoft Store for Business app
- B. **Microsoft Store app (new)**
- C. Windows web link
- D. Line-of-business app (.appx)

**Objective:** 4.1.2

<details>
<summary>Answer</summary>

**B.** The new Store app type uses the WinGet-based Store integration. Microsoft Store for Business is retired.

</details>

### Q4.06

Autopilot devices intermittently fail the Enrollment Status Page. The ESP tracks one MSI line-of-business app and several Win32 apps. What's the recommended fix?

- A. Increase the ESP timeout to 240 minutes.
- B. Repackage the MSI as a **Win32 app** so the ESP doesn't mix LOB and Win32 installs.
- C. Assign the MSI to users instead of devices.
- D. Remove the MSI from the blocking apps list and install it with a remediation script.

**Objective:** 4.1.2

<details>
<summary>Answer</summary>

**B.** Mixing LOB (MSI via the OMA-DM agent) and Win32 (Intune Management Extension) installs can collide on the Windows Installer service during the ESP.

</details>

### Q4.07

HR wants employees not to receive work notifications on their phones on weekends. Which apps does an Intune Quiet Time policy silence?

- A. All apps in the work profile
- B. **Microsoft Outlook and Microsoft Teams**
- C. Any app with an app protection policy
- D. Only Microsoft Teams

**Objective:** 4.1.3

<details>
<summary>Answer</summary>

**B.** Quiet Time policies mute Outlook and Teams notifications on iOS/iPadOS and Android.

</details>

### Q4.08

A frontline organization wants notifications muted outside each worker's scheduled shifts rather than on fixed days. Which Quiet Time policy type fits, and what does it depend on?

- A. Date Range - the Microsoft 365 admin center holiday calendar
- B. Days of the week - Outlook working hours
- C. **Non-working time** - the **Working Time API** integration
- D. Days of the week - Teams Shifts channel

**Objective:** 4.1.3

<details>
<summary>Answer</summary>

**C.** Non-working time uses the working-time integration. Without it, use Days of the week or Date Range.

</details>

### Q4.09

You deploy Microsoft 365 Apps with the built-in Intune app type. Devices still have Office 2016 MSI installed. What should you set?

- A. An Uninstall assignment for Office 2016
- B. *Remove other versions* = **Yes** in the app suite settings
- C. A supersedence relationship to Office 2016
- D. A PowerShell remediation that runs `msiexec /x`

**Objective:** 4.1.4

<details>
<summary>Answer</summary>

**B.** The built-in app type can remove MSI versions of Office during install.

</details>

### Q4.10

The finance team wants Office feature updates only once a month on a predictable date, with security fixes the same day. Which update channel should you configure?

- A. Current Channel
- B. **Monthly Enterprise Channel**
- C. Semi-Annual Enterprise Channel
- D. Beta Channel

**Objective:** 4.1.4

<details>
<summary>Answer</summary>

**B.** Monthly Enterprise Channel releases once a month (second Tuesday), with features and security together.

</details>

### Q4.11

Contractors use personal, unenrolled Windows PCs with Microsoft 365 Apps. You must block internet macros for them. What should you use?

- A. An Intune settings catalog profile
- B. Group Policy administrative templates
- C. The **Cloud Policy service** (Policies for Microsoft 365 apps)
- D. An app protection policy for Windows

**Objective:** 4.1.5

<details>
<summary>Answer</summary>

**C.** Cloud Policy is user-based and applies when the user signs in to Office - no enrollment or domain join needed.

</details>

### Q4.12

The same Office setting is configured by Group Policy and by the Cloud Policy service with different values. Which value applies?

- A. Group Policy
- B. **Cloud Policy service**
- C. Whichever was applied last
- D. Neither - Office flags a conflict and uses the default

**Objective:** 4.1.5

<details>
<summary>Answer</summary>

**B.** Cloud Policy settings take precedence over Group Policy, preferences and installation settings.

</details>

### Q4.13

The ESP should block until Microsoft 365 Apps is installed during Autopilot, and you need full control over the Office configuration. What does Microsoft recommend?

- A. The built-in Microsoft 365 Apps app type set as a blocking app
- B. A **Win32 app** that runs the **Office Deployment Tool** with a `configuration.xml`
- C. A Microsoft Store app (new) for Office
- D. A remediation script that runs after the ESP

**Objective:** 4.1.6

<details>
<summary>Answer</summary>

**B.** A Win32 ODT package installs through the Intune Management Extension alongside other Win32 apps and is tracked cleanly in the ESP.

</details>

### Q4.14

Your ODT `configuration.xml` must remove existing MSI-based Office products before installing Microsoft 365 Apps. Which element should you add?

- A. `<Remove All="TRUE" />`
- B. **`<RemoveMSI />`**
- C. `<Display Level="None" />`
- D. `<Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />`

**Objective:** 4.1.6

<details>
<summary>Answer</summary>

**B.** `RemoveMSI` removes MSI versions. `Remove All` removes Click-to-Run products.

</details>

### Q4.15

A helpdesk lead needs to manage cloud update and view inventory in the Microsoft 365 Apps admin center. Which role follows least privilege?

- A. Global Administrator
- B. Intune Administrator
- C. **Office Apps Administrator**
- D. Helpdesk Administrator

**Objective:** 4.1.7

<details>
<summary>Answer</summary>

**C.** Office Apps Administrator covers the Microsoft 365 Apps admin center.

</details>

### Q4.16

A bad Office build is causing crashes. You manage updates with cloud update. What can you do?

- A. Nothing - cloud update only moves forward.
- B. Use **Roll back** in cloud update to move devices to a previous build.
- C. Delete the cloud update profile to uninstall the build.
- D. Switch devices to Beta Channel.

**Objective:** 4.1.7

<details>
<summary>Answer</summary>

**B.** Cloud update supports pause and roll back, plus exclusion windows and waves.

</details>

### Q4.17

Corporate supervised iPhones enrolled with ADE must get Outlook silently without users signing in with an Apple Account. How should you assign the VPP app?

- A. Available, user licensing
- B. Required, user licensing
- C. **Required, device licensing**
- D. Available, device licensing

**Objective:** 4.1.8

<details>
<summary>Answer</summary>

**C.** Device licensing on supervised devices installs without an Apple Account prompt.

</details>

### Q4.18

You approved Microsoft Teams in the Managed Google Play iframe, but it doesn't appear in the Intune app list. What should you do?

- A. Wait 7 days for the next automatic sync.
- B. **Sync** Managed Google Play in Intune.
- C. Re-bind the Managed Google Play account.
- D. Upload the Teams APK as a LOB app.

**Objective:** 4.1.8

<details>
<summary>Answer</summary>

**B.** After approval, sync so the app appears and can be assigned.

</details>

### Q4.19

A Win32 app installs successfully, but Intune reports *The application was not detected after installation completed successfully (0x87D1041C)*. What's the most likely cause?

- A. The device isn't licensed for Intune.
- B. The **detection rule** doesn't match what the installer actually creates.
- C. The app requires a restart.
- D. The `.intunewin` file is corrupted.

**Objective:** 4.1.9

<details>
<summary>Answer</summary>

**B.** 0x87D1041C = installed but not detected. Check the path, version or product code in the detection rule.

</details>

### Q4.20

Which log folder on a Windows device should you check first when troubleshooting a Win32 app install?

- A. `C:\Windows\Logs\CBS`
- B. **`C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`**
- C. `C:\Windows\CCM\Logs`
- D. `%TEMP%\Office`

**Objective:** 4.1.9

<details>
<summary>Answer</summary>

**B.** IntuneManagementExtension.log and AppWorkload.log are there. `CCM\Logs` is the Configuration Manager client.

</details>

### Q4.21

A user leaves the company. Their personal phone is not enrolled but has Outlook and Teams protected by app protection policies. You need to remove corporate data only. What should you do?

- A. Retire the device.
- B. Wipe the device.
- C. Create an **app selective wipe** request for the user.
- D. Block the user in Microsoft Entra ID.

**Objective:** 4.2.1

<details>
<summary>Answer</summary>

**C.** Selective wipe removes org data from managed apps. There's no enrolled device to retire or wipe.

</details>

### Q4.22

Users on unenrolled iPhones get stuck in a sign-in loop in Outlook after you enforce app protection with Conditional Access. What's missing?

- A. The Company Portal app
- B. **Microsoft Authenticator** (the broker on iOS)
- C. A VPN profile
- D. A device compliance policy

**Objective:** 4.2.1

<details>
<summary>Answer</summary>

**B.** On iOS, Authenticator is the broker. On Android, it's Company Portal (no enrollment needed).

</details>

### Q4.23

You're creating a new Conditional Access policy so only apps with an Intune app protection policy can reach Office 365 from iOS and Android. Which grant control should you use?

- A. Require approved client app
- B. **Require app protection policy**
- C. Require device to be marked as compliant
- D. Require Microsoft Entra hybrid joined device

**Objective:** 4.2.2

<details>
<summary>Answer</summary>

**B.** *Require approved client app* is read-only since June 30, 2026. Use *Require app protection policy*.

</details>

### Q4.24

You must pre-configure Microsoft Edge bookmarks for users on **unenrolled** phones. Which app configuration policy type should you create?

- A. Managed devices
- B. **Managed apps**
- C. Device configuration - custom profile
- D. Android Enterprise OEMConfig

**Objective:** 4.2.3

<details>
<summary>Answer</summary>

**B.** Managed apps policies are delivered via the Intune SDK and don't need enrollment. Managed devices policies need enrollment and an Intune-deployed app.

</details>
