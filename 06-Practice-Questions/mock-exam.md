# Mock exam - 50 questions

Original questions written for this repository, weighted like the exam (Domain 1: 11, Domain 2: 14, Domain 3: 9, Domain 4: 9, Domain 5: 7). They aren't taken from the real exam.

**How to use:** set a timer for about 100 minutes, answer everything, then check answers. Score = correct / 50. Aim for **80%+** (40 correct) before booking. For each miss, open the objective's doc from [EXAM-OBJECTIVE-MAP.md](../EXAM-OBJECTIVE-MAP.md).

## Questions

### QM.01

Contoso acquires a startup with 300 new Windows 11 laptops. There's no on-premises Active Directory. Users need single sign-on to Microsoft 365 and the devices must be managed by Intune. Which device identity should you use?

- A. Microsoft Entra registered
- B. **Microsoft Entra joined**
- C. Microsoft Entra hybrid joined
- D. Workgroup devices enrolled with a DEM account

**Objective:** 1.1.1

<details>
<summary>Answer</summary>

**B.** Cloud-only, corporate devices, no on-premises AD → Entra join.

</details>

### QM.02

You need a Microsoft Entra group that automatically contains all corporate-owned Windows devices. Which membership rule should you use?

- A. `(user.department -eq "IT") -and (device.deviceOSType -eq "Windows")`
- B. `(device.deviceOSType -eq "Windows") -and (device.deviceOwnership -eq "Company")`
- C. `(device.deviceOwnership -eq "Corporate")`
- D. `(device.devicePhysicalIDs -any (_ -startsWith "[OrderID]"))`

**Objective:** 1.1.4

<details>
<summary>Answer</summary>

**B.** Device rules can't mix user attributes. Ownership values are `Company` and `Personal`.

</details>

### QM.03

Users are enrolling personal Android phones with the legacy device administrator method. All personal Android devices must use a work profile instead. What should you configure?

- A. A device limit restriction
- B. A **platform restriction** that blocks Android device administrator
- C. A compliance policy requiring a work profile
- D. An app protection policy

**Objective:** 1.2.1

<details>
<summary>Answer</summary>

**B.** Block device administrator in the enrollment platform restriction so users go through Android Enterprise.

</details>

### QM.04

Hybrid joined Windows devices must enroll in Intune automatically, using the signed-in user. What should you configure?

- A. An Autopilot profile with hybrid join
- B. A **Group Policy** *Enable automatic MDM enrollment using default Microsoft Entra credentials* with **User Credential**
- C. MDM user scope set to a device group
- D. A provisioning package

**Objective:** 1.2.2

<details>
<summary>Answer</summary>

**B.** Hybrid devices enroll through the GPO after they're hybrid joined. MDM user scope uses user groups.

</details>

### QM.05

Contoso bought 40 iPads from a retail store, not from an Apple reseller. They must be enrolled with ADE and supervised. What should you do first?

- A. Enroll them with Company Portal.
- B. Add them to Apple Business Manager with **Apple Configurator**.
- C. Use account driven user enrollment.
- D. Upload their serial numbers to Intune corporate identifiers.

**Objective:** 1.2.5

<details>
<summary>Answer</summary>

**B.** Apple Configurator can add devices not bought through ABM channels (with a provisional period).

</details>

### QM.06

Warehouse Android devices are shared between shifts. Each worker signs in to Teams and Outlook, and must be signed out for the next worker. Which enrollment should you use?

- A. Personally owned work profile
- B. Fully managed
- C. **Dedicated** with **Microsoft Entra shared device mode**
- D. Corporate-owned work profile

**Objective:** 1.2.4

<details>
<summary>Answer</summary>

**C.** Shared, task-focused devices with sign-in/sign-out = dedicated + shared device mode.

</details>

### QM.07

The German IT team must see only German Intune policies **and** only act on German devices. Which two should you configure? *Select two.*

- A. **Scope tags** on German policies and admin role assignments
- B. **Scope groups** containing German users/devices in the role assignment
- C. A separate Intune tenant
- D. An Entra administrative unit only
- E. Conditional Access for admins

**Objective:** 1.3.2

<details>
<summary>Answer</summary>

**A, B.** Scope tags control which objects admins see; scope groups control which users/devices they can target.

</details>

### QM.08

You must prevent any single administrator from deploying or changing app deployments. What should you configure?

- A. Scope tags on apps
- B. A **multi admin approval** access policy for **Apps**
- C. An Intune custom role without app permissions
- D. Conditional Access for the Intune admin center

**Objective:** 1.3.3

<details>
<summary>Answer</summary>

**B.** MAA requires a second admin to approve changes to protected resources such as app deployments.

</details>

### QM.09

After you create a Conditional Access policy requiring a compliant device for **all cloud apps**, new Windows devices can't enroll. What should you do?

- A. Disable the policy.
- B. **Exclude the Microsoft Intune Enrollment** app from the policy (and require MFA for it instead).
- C. Set the compliance validity period to 120 days.
- D. Mark devices with no compliance policy as compliant.

**Objective:** 1.3.5

<details>
<summary>Answer</summary>

**B.** Devices can't be compliant before they enroll. Exclude the enrollment app to avoid the chicken-and-egg problem.

</details>

### QM.10

You assigned an Intune Windows LAPS policy backing up to Microsoft Entra ID. Devices never show a password and event 10029 never appears. What's most likely missing?

- A. A device restart
- B. The tenant setting **Enable Microsoft Entra Local Administrator Password Solution (LAPS)**
- C. Entra ID P2 licences
- D. The legacy LAPS MSI

**Objective:** 1.3.7

<details>
<summary>Answer</summary>

**B.** Both the tenant switch and the Intune policy are required.

</details>

### QM.11

Windows Hello for Business should be enabled only for a pilot group, not for every device at enrollment. What should you do?

- A. Enable the tenant-wide Windows Hello setting under Enrollment.
- B. Disable the tenant-wide Windows Hello for Business enrollment setting and assign an **Account protection** (or settings catalog) policy to the pilot group.
- C. Use a compliance policy that requires Windows Hello.
- D. Configure WHfB in Group Policy only.

**Objective:** 1.3.6

<details>
<summary>Answer</summary>

**B.** The enrollment-level setting applies to all devices. Targeted policies scope WHfB to groups.

</details>

### QM.12

A supplier can't provide hardware hashes for new Windows 11 laptops. Devices will be Entra joined and users will set them up themselves. You want to minimize administrative effort. What should you use?

- A. Classic Autopilot user-driven profile
- B. **Windows Autopilot device preparation**
- C. Autopilot pre-provisioning
- D. A provisioning package

**Objective:** 2.1.1

<details>
<summary>Answer</summary>

**B.** Device preparation needs no hash registration and uses a user-group policy.

</details>

### QM.13

During Autopilot pre-provisioning, a required app assigned to a **user** group didn't install in the technician phase. What should you do?

- A. Increase the ESP timeout.
- B. Assign the app to a **device** group.
- C. Convert the app to Available.
- D. Use self-deploying mode.

**Objective:** 2.1.2

<details>
<summary>Answer</summary>

**B.** Only device-targeted apps install in the technician phase.

</details>

### QM.14

An Autopilot profile uses the naming template `CON-%SERIAL%`. Hybrid joined devices don't get that name. Why?

- A. The template exceeds 15 characters.
- B. **Hybrid join ignores the template** - the Domain Join profile's prefix is used.
- C. %SERIAL% isn't supported.
- D. Names only apply after Autopilot Reset.

**Objective:** 2.1.3

<details>
<summary>Answer</summary>

**B.** For hybrid join, naming comes from the Domain Join configuration profile.

</details>

### QM.15

Users who add an existing PC to Intune through Settings see the Enrollment Status Page. You want the ESP only during OOBE. What should you configure?

- A. Disable the ESP.
- B. *Only show page to devices provisioned by out-of-box experience (OOBE)* = **Yes**
- C. Remove blocking apps.
- D. A device limit restriction.

**Objective:** 2.1.5

<details>
<summary>Answer</summary>

**B.** That ESP setting prevents the page for non-OOBE enrollments.

</details>

### QM.16

A Windows 365 Enterprise user needs a Cloud PC with more CPU and RAM. What determines the Cloud PC size?

- A. The provisioning policy
- B. The **Windows 365 licence** assigned to the user (change it or resize)
- C. The Azure network connection
- D. The gallery image

**Objective:** 2.1.7

<details>
<summary>Answer</summary>

**B.** Size comes from the licence. Resize to move to a larger licence.

</details>

### QM.17

Windows Backup is configured, but the restore page never appears on new **hybrid joined** devices. Why?

- A. Backup isn't enabled in the settings catalog.
- B. **Restore requires Microsoft Entra join**.
- C. Restore only works with pre-provisioning.
- D. The users lack OneDrive licences.

**Objective:** 2.1.8

<details>
<summary>Answer</summary>

**B.** Hybrid joined devices can back up, but restore requires Entra join.

</details>

### QM.18

Importing a vendor ADMX file in Intune fails because it references definitions from another ADMX file. What should you do?

- A. Use Group Policy analytics.
- B. **Upload the dependent ADMX/ADML files first**, then the vendor ADMX.
- C. Use a custom OMA-URI only.
- D. Convert the ADMX to JSON.

**Objective:** 2.2.1

<details>
<summary>Answer</summary>

**B.** ADMX ingestion requires dependencies to be uploaded before the file that references them.

</details>

### QM.19

A Wi-Fi profile assigned to All devices must apply only to Surface devices. You can't create new groups. What should you use?

- A. Scope tags
- B. An **assignment filter** in Include mode on manufacturer/model
- C. A dynamic user group
- D. Enrollment time grouping

**Objective:** 2.2.6

<details>
<summary>Answer</summary>

**B.** Filters narrow an assignment without new groups.

</details>

### QM.20

You create an EPM elevation rule with **Automatic** elevation type, but you can't save it. What's missing?

- A. A publisher certificate only
- B. The **file hash**
- C. A support approval workflow
- D. A device restart

**Objective:** 2.3.1

<details>
<summary>Answer</summary>

**B.** Automatic elevation rules require a file hash.

</details>

### QM.21

Users need S/MIME certificates with **key escrow** for email encryption. Can you issue them with Microsoft Cloud PKI?

- A. Yes, with a SCEP profile.
- B. **No** - Cloud PKI supports SCEP only; S/MIME with key escrow needs PKCS and a traditional CA.
- C. Yes, with BYOCA.
- D. Yes, with a trusted certificate profile.

**Objective:** 2.3.4

<details>
<summary>Answer</summary>

**B.** Cloud PKI doesn't support PKCS or key escrow.

</details>

### QM.22

Help desk staff can view and control users' screens with Remote Help but can't respond to UAC prompts. What should you change?

- A. Enable unattended control.
- B. Add the **Elevation** permission to their Remote Help role.
- C. Assign them Intune Administrator.
- D. Enable Remote Help for unenrolled devices.

**Objective:** 2.3.3

<details>
<summary>Answer</summary>

**B.** UAC interaction requires the Elevation permission.

</details>

### QM.23

You deleted a lost corporate laptop from Intune. What happens to the corporate data on it?

- A. It's wiped at the next check-in.
- B. **Nothing is wiped** - Delete only removes the record; the device unenrolls when it next checks in.
- C. BitLocker keys are rotated.
- D. The device is retired.

**Objective:** 2.4.1

<details>
<summary>Answer</summary>

**B.** Use Wipe (or Retire) before Delete when data must be removed.

</details>

### QM.24

You must find every Windows device with a specific BIOS version across the fleet. What should you use?

- A. Single-device query
- B. **Device query for multiple devices** (with a properties catalog policy)
- C. Collect diagnostics
- D. Endpoint analytics

**Objective:** 2.4.6

<details>
<summary>Answer</summary>

**B.** Fleet-wide KQL over inventory; Windows needs a properties catalog policy.

</details>

### QM.25

You must rename 300 Windows devices with a naming template. What's the most efficient approach?

- A. Bulk device actions once
- B. **Microsoft Graph** (bulk actions are limited to 100 devices per run), or three bulk runs
- C. Autopilot Reset
- D. A configuration profile

**Objective:** 2.4.2

<details>
<summary>Answer</summary>

**B.** Bulk device actions handle up to 100 devices per run. Graph scales further.

</details>

### QM.26

You want to manage **tamper protection** from Intune for Windows devices. What's required?

- A. Entra ID P2
- B. Devices **onboarded to Microsoft Defender for Endpoint**
- C. A security baseline
- D. Defender for Endpoint Plan 1 only

**Objective:** 3.1.1

<details>
<summary>Answer</summary>

**B.** Tamper protection from Intune requires MDE onboarding.

</details>

### QM.27

Security requires BitLocker **TPM + PIN** at startup. Can encryption be completely silent?

- A. Yes, with standard user encryption allowed.
- B. **No** - the user must set a PIN, so it isn't silent.
- C. Yes, if keys escrow to Entra ID.
- D. Yes, on Windows 11 only.

**Objective:** 3.1.2

<details>
<summary>Answer</summary>

**B.** Silent encryption uses TPM-only protectors.

</details>

### QM.28

You deployed ASR rules in **Audit** mode. Which event ID shows what would have been blocked?

- A. 1121
- B. **1122**
- C. 3076
- D. 10029

**Objective:** 3.1.4

<details>
<summary>Answer</summary>

**B.** 1122 = audited; 1121 = blocked.

</details>

### QM.29

Two instances of the same Windows security baseline are assigned to overlapping groups. Some settings show *Conflict*. What should you do?

- A. Nothing - the newest wins.
- B. **Avoid overlapping assignments**, or set one instance's conflicting settings to *Not configured*.
- C. Convert one to a compliance policy.
- D. Increase the baseline version.

**Objective:** 3.1.5

<details>
<summary>Answer</summary>

**B.** Overlapping instances of the same baseline create conflicts.

</details>

### QM.30

Before enforcing an App Control for Business policy, you run it in audit mode. What should you review?

- A. Event 1122 in Defender logs
- B. CodeIntegrity **event 3076**
- C. IntuneManagementExtension.log
- D. Event 10029

**Objective:** 3.1.8

<details>
<summary>Answer</summary>

**B.** 3076 = would have been blocked (audit). 3077 = blocked (enforced).

</details>

### QM.31

Devices must stay on Windows 11 24H2 for the next year but keep receiving monthly security updates. What should you configure?

- A. A 365-day feature update deferral on the ring
- B. A **feature update policy** targeting 24H2, with the update ring for quality updates
- C. Pause feature updates
- D. Hotpatch

**Objective:** 3.2.2

<details>
<summary>Answer</summary>

**B.** Feature update policies pin the version; rings keep delivering quality updates.

</details>

### QM.32

A Hotpatch-enabled Windows 11 device restarted for a monthly security update in January. Why?

- A. Hotpatch was disabled.
- B. January delivered a **quarterly baseline** update, which requires a restart.
- C. VBS is off.
- D. The device is Arm64.

**Objective:** 3.2.3

<details>
<summary>Answer</summary>

**B.** Hotpatch devices restart for quarterly baselines.

</details>

### QM.33

macOS devices must update to a specific version by a deadline, using the recommended method. What should you use?

- A. Legacy macOS update policies
- B. **Settings catalog DDM software update** (macOS 14+)
- C. A shell script
- D. Compliance minimum OS only

**Objective:** 3.2.4

<details>
<summary>Answer</summary>

**B.** DDM via the settings catalog is recommended; MDM update policies are deprecated.

</details>

### QM.34

Devices in an isolated network must not use peer-to-peer and must not contact Delivery Optimization cloud services. Which download mode?

- A. LAN (1)
- B. Group (2)
- C. Internet (3)
- D. **Simple (99)**

**Objective:** 3.2.6

<details>
<summary>Answer</summary>

**D.** Simple disables peering and DO cloud services.

</details>

### QM.35

A Win32 app must install only on 64-bit devices with at least 8 GB RAM. What should you configure?

- A. Detection rules
- B. **Requirement rules**
- C. An assignment filter on user department
- D. Dependencies

**Objective:** 4.1.1

<details>
<summary>Answer</summary>

**B.** Requirement rules check OS architecture, memory, disk space and more before install.

</details>

### QM.36

Shared lab PCs must offer Visio in Company Portal to anyone who signs in. The app is packaged as Win32. How can you target it?

- A. Available to a user group only - device groups are never supported
- B. **Available to the device group** - Win32 apps support Available assignments to device groups
- C. Required to the device group
- D. Uninstall to all users

**Objective:** 4.1.2

<details>
<summary>Answer</summary>

**B.** Win32 (and Android Enterprise fully managed/COPE apps) are exceptions that allow Available to device groups.

</details>

### QM.37

A Quiet Time policy has no effect. It's assigned to a device group containing corporate phones. What should you change?

- A. Enable end-user overrides.
- B. **Assign the policy to user groups**.
- C. Add an app protection policy.
- D. Use a Date Range policy.

**Objective:** 4.1.3

<details>
<summary>Answer</summary>

**B.** Quiet Time policies target users.

</details>

### QM.38

Microsoft 365 Apps will run on Azure Virtual Desktop multi-session hosts. What must you enable?

- A. Remove other versions
- B. **Shared computer activation**
- C. Monthly Enterprise Channel
- D. Office Customization Tool

**Objective:** 4.1.4

<details>
<summary>Answer</summary>

**B.** Multi-user environments need shared computer activation.

</details>

### QM.39

Office updates must not install during the last three days of each month. You use cloud update. What should you configure?

- A. A servicing profile
- B. An **exclusion window**
- C. Semi-Annual Enterprise Channel
- D. An Office Cloud Policy

**Objective:** 4.1.7

<details>
<summary>Answer</summary>

**B.** Cloud update exclusion windows block updates during set periods.

</details>

### QM.40

You upload a VPP token and Intune reports that it's assigned to another MDM. What should you do?

- A. Create a new Apple Account.
- B. Select **Take control of token from another MDM**.
- C. Delete the APNs certificate.
- D. Wait for the next sync.

**Objective:** 4.1.8

<details>
<summary>Answer</summary>

**B.** A token can be managed by only one MDM at a time.

</details>

### QM.41

A Win32 app shows *Not applicable* for several devices. What's the most likely reason?

- A. The detection rule is wrong.
- B. A **requirement rule or assignment filter** excluded those devices.
- C. The content failed to download.
- D. The app needs a restart.

**Objective:** 4.1.9

<details>
<summary>Answer</summary>

**B.** Not applicable = device doesn't meet requirements or was filtered out.

</details>

### QM.42

Corporate data in Outlook on personal phones must be wiped if the app hasn't connected to the service for 30 days. What should you configure?

- A. A device compliance policy
- B. APP conditional launch **Offline grace period** with action **Wipe data** at 30 days
- C. An app configuration policy
- D. A Retire device action

**Objective:** 4.2.1

<details>
<summary>Answer</summary>

**B.** Offline grace period supports block and wipe actions.

</details>

### QM.43

On enrolled Android Enterprise devices, Outlook must allow only the work account. What should you create?

- A. An app protection policy
- B. An **app configuration policy for managed devices** targeting Outlook
- C. A device restrictions profile
- D. A Quiet Time policy

**Objective:** 4.2.3

<details>
<summary>Answer</summary>

**B.** Managed-devices app configuration with allowed accounts settings.

</details>

### QM.44

An Azure Automation runbook uses **application** permissions to wipe devices. The German admins' scope tags don't stop it from wiping French devices. Why?

- A. The runbook uses Graph beta.
- B. **App-only calls aren't limited by Intune scope tags**.
- C. Scope tags apply only to policies.
- D. Wipe isn't a privileged operation.

**Objective:** 5.1.1

<details>
<summary>Answer</summary>

**B.** Scope app-only automation with minimal permissions and logic, or use delegated calls.

</details>

### QM.45

A custom compliance rule compares a returned value like `2.10.1.4` against a minimum version. Which `DataType` should the JSON use?

- A. String
- B. Int64
- C. **Version**
- D. Double

**Objective:** 5.1.5

<details>
<summary>Answer</summary>

**C.** Version compares dotted versions correctly; String would compare text.

</details>

### QM.46

Compliance requires keeping Intune audit logs for two years at the lowest cost. No querying is needed. Which destination?

- A. Log Analytics with 2-year retention
- B. **Storage account** archive
- C. Event Hubs
- D. CSV export monthly

**Objective:** 5.2.1

<details>
<summary>Answer</summary>

**B.** Storage accounts are the archive option.

</details>

### QM.47

What is the name of the configuration profile that onboards Intune devices to Endpoint analytics?

- A. Windows health monitoring - Update
- B. **Intune data collection policy**
- C. Endpoint analytics baseline
- D. Properties catalog

**Objective:** 5.2.2

<details>
<summary>Answer</summary>

**B.** Created by the Endpoint analytics setup (a Windows health monitoring profile scoped to Endpoint analytics).

</details>

### QM.48

A remediation must run every 4 hours. Which schedule should you configure?

- A. Once
- B. **Hourly**, repeating every 4 hours
- C. Daily
- D. On demand only

**Objective:** 5.2.3

<details>
<summary>Answer</summary>

**B.** Hourly schedules repeat every N hours.

</details>

### QM.49

Tenant status shows the Apple VPP token connector as **Warning**. What does that most likely mean?

- A. The token expired.
- B. The token **expires within 7 days** (or hasn't synced for more than a day).
- C. No apps are assigned.
- D. APNs failed.

**Objective:** 5.2.5

<details>
<summary>Answer</summary>

**B.** Warning = expiring within 7 days or sync older than a day; Unhealthy = expired or no sync for 3+ days.

</details>

### QM.50

You build an Azure Monitor alert for compliance drift on `IntuneDeviceComplianceOrg` that evaluates every 5 minutes, but it rarely changes. Why?

- A. The table isn't supported for alerts.
- B. That table is a **daily** export (up to 48 h), so frequent evaluation adds nothing - run it daily.
- C. You need Event Hubs.
- D. The action group is missing.

**Objective:** 5.2.6

<details>
<summary>Answer</summary>

**B.** Compliance org and device inventory logs are daily; audit/operational logs are near real time.

</details>

## Scoring

| Score | Next step |
|---|---|
| 45-50 | Ready - book the exam |
| 40-44 | Review every missed objective, then retake in a week |
| 30-39 | Go back to the docs and labs for your weakest domain |
| < 30 | Follow the [8-week plan](../00-Getting-Started/8-week-study-plan.md) |
