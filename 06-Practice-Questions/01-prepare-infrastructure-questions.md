# Practice questions - Domain 1: Prepare infrastructure for devices (20-25%)

All questions are **original** and written for this repository. They aren't taken from the exam. Answers and explanations are collapsed under each question. Try to answer before expanding.

Question styles mirror the formats Microsoft uses (single answer, multiple answer, yes/no series, ordering) without reproducing any real item.

## Questions

### Q1.01

Contoso is replacing 800 laptops. The new laptops will be deployed with Windows Autopilot. Contoso has no requirement for Group Policy, but some users access an on-premises file server that uses Kerberos authentication. You need to choose a join type that minimizes on-premises dependencies.

Which join type should you use?

- A. Microsoft Entra registered
- B. Microsoft Entra joined
- C. Microsoft Entra hybrid joined
- D. Active Directory domain joined only

**Objective:** 1.1.1

<details>
<summary>Answer</summary>

**B.** Entra joined devices get Kerberos SSO to on-premises resources when they have line of sight to a domain controller. Hybrid join is only needed for Group Policy or computer-account authentication. Registered is for BYOD.

</details>

### Q1.02

A user reports that their new corporate Windows 11 device appears in Microsoft Entra ID with join type **Microsoft Entra registered** instead of **Microsoft Entra joined**. The user signed in with their work account in **Settings > Accounts > Access work or school**.

What is the most likely cause?

- A. The user isn't in the MDM user scope.
- B. The user entered their account in the Connect dialog instead of selecting **Join this device to Microsoft Entra ID**.
- C. The device limit restriction was exceeded.
- D. The device is running Windows 11 Enterprise.

**Objective:** 1.1.2

<details>
<summary>Answer</summary>

**B.** The main Connect box **registers** the device (adds a work account). Joining requires the separate *Join this device to Microsoft Entra ID* link or OOBE/Autopilot. MDM scope affects enrollment, not join type.

</details>

### Q1.03

Employees use personal iPhones to read corporate email in Outlook. Management requires that corporate data is protected, but IT must not enroll the phones in MDM.

Which two actions should you perform? Each correct answer presents part of the solution.

- A. Create an Intune app protection policy for Outlook.
- B. Create a Conditional Access policy that requires a compliant device.
- C. Create a Conditional Access policy that requires an app protection policy.
- D. Create an iOS device enrollment profile.
- E. Configure the Apple MDM push certificate.

**Objective:** 1.1.3

<details>
<summary>Answer</summary>

**A and C.** The devices become **Entra registered** through Authenticator (the broker) without MDM enrollment. App protection + CA *Require app protection policy* protect the data. A compliant device requires enrollment. APNs and enrollment profiles are for MDM.

</details>

### Q1.04

You need a group that automatically contains every Windows device registered with Windows Autopilot whose group tag is **Kiosk**.

Which membership rule should you use?

- A. `(device.deviceCategory -eq "Kiosk")`
- B. `(device.devicePhysicalIDs -any (_ -eq "[OrderID]:Kiosk"))`
- C. `(device.enrollmentProfileName -eq "Kiosk")`
- D. `(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))`

**Objective:** 1.1.4

<details>
<summary>Answer</summary>

**B.** Autopilot group tags are stored in `devicePhysicalIDs` as `[OrderID]:<tag>`. D captures all Autopilot devices regardless of tag. `enrollmentProfileName` holds the Autopilot profile name after enrollment, not the tag.

</details>

### Q1.05

You create a dynamic device group for Windows 11 devices. Several newly enrolled devices take hours before receiving the apps assigned to the group. You need devices provisioned with Windows Autopilot device preparation to receive the apps **during** OOBE.

What should you use?

- A. An assignment filter
- B. A second dynamic group with a simpler rule
- C. Enrollment time grouping with a static device group
- D. Device categories

**Objective:** 1.1.4

<details>
<summary>Answer</summary>

**C.** Autopilot device preparation adds the device to a **static** group (owned by the Intune Provisioning Client) at enrollment time, so assigned apps and scripts are delivered immediately.

</details>

### Q1.06

Users in the **Contractors** group must be limited to enrolling **two** devices in Intune. All other users can enroll up to five devices.

What should you configure?

- A. The Microsoft Entra *Maximum number of devices per user* setting
- B. An Intune device limit restriction assigned to Contractors, with a higher priority than the default
- C. A device platform restriction assigned to Contractors
- D. A compliance policy with a device count rule

**Objective:** 1.2.1

<details>
<summary>Answer</summary>

**B.** Device limit restrictions are per user group with priority. The Entra setting is directory-wide and applies to join/register, not per group.

</details>

### Q1.07

*Yes/No series*

You block personally owned Windows devices with a device platform restriction. For each statement, select **Yes** if the enrollment succeeds.

1. A device deployed with Windows Autopilot user-driven mode enrolls.
2. A user joins a new laptop through OOBE without Autopilot, and the laptop's serial isn't in corporate identifiers.
3. A hybrid joined device enrolls through the Group Policy automatic enrollment setting.

**Objective:** 1.2.1

<details>
<summary>Answer</summary>

1. **Yes** - Autopilot devices are corporate.
2. **No** - it's treated as personal unless a corporate identifier (manufacturer, model, serial) exists.
3. **Yes** - GPO auto-enrollment of hybrid joined devices is considered corporate.

</details>

### Q1.08

Hybrid joined Windows devices aren't enrolling in Intune. You verify that `dsregcmd /status` shows `AzureAdJoined : YES` and `DomainJoined : YES`. Users are licensed.

What should you configure next?

- A. A Windows Autopilot deployment profile
- B. The Group Policy setting **Enable automatic MDM enrollment using default Microsoft Entra credentials**
- C. A CNAME record for EnterpriseRegistration
- D. A device limit restriction

**Objective:** 1.2.2

<details>
<summary>Answer</summary>

**B.** Hybrid joined devices enroll through the GPO (or co-management). The user must also be in MDM user scope. CNAMEs are only needed for manual enrollment with a custom domain.

</details>

### Q1.09

You set MDM user scope to **Some** and select a group. Which type of group must you select?

- A. A dynamic device group
- B. A user group
- C. A Microsoft 365 group with devices
- D. Any group containing users or devices

**Objective:** 1.2.2

<details>
<summary>Answer</summary>

**B.** MDM user scope applies to users. Device groups aren't supported.

</details>

### Q1.10

Personal iPhones must be enrolled so that IT can manage a **separate work partition** only, without seeing the device serial number. Devices run iOS 18. Users must enroll from the Settings app.

Which enrollment type should you configure?

- A. Device enrollment with Company Portal
- B. Web based device enrollment
- C. Account driven user enrollment
- D. Automated Device Enrollment

**Objective:** 1.2.3

<details>
<summary>Answer</summary>

**C.** Account driven user enrollment creates a managed work partition, hides hardware identifiers, and starts from **Settings > VPN & Device Management**. It needs the service discovery file and Managed Apple Accounts or federation.

</details>

### Q1.11

The Apple MDM push certificate expired yesterday. The admin who created it has left the company, and nobody knows the Apple Account used. What's the impact of creating a new certificate with a different Apple Account?

- A. No impact; devices pick up the new certificate automatically.
- B. All iOS/iPadOS and macOS devices must re-enroll.
- C. Only ADE devices must re-enroll.
- D. Only macOS devices must re-enroll.

**Objective:** 1.2.3

<details>
<summary>Answer</summary>

**B.** Renewing with the **same** Apple Account keeps devices managed. A new Apple Account generates a new push topic, and every Apple device must re-enroll.

</details>

### Q1.12

A logistics company buys rugged Android scanners. Each scanner is shared by shift workers, must run only the inventory app, and has no primary user.

Which Android Enterprise enrollment type should you use?

- A. Personally owned work profile
- B. Corporate-owned work profile
- C. Fully managed
- D. Dedicated

**Objective:** 1.2.4

<details>
<summary>Answer</summary>

**D.** Dedicated (COSU) devices are userless or shared and support kiosk/lock-task mode. Use the Entra shared device mode token if workers sign in to apps.

</details>

### Q1.13

New fully managed Android devices fail to enroll after scanning the QR code, but devices enrolled last month work normally. What should you check first?

- A. The Managed Google Play binding
- B. The enrollment token expiration date of the profile
- C. The Apple MDM push certificate
- D. The compliance policy grace period

**Objective:** 1.2.4

<details>
<summary>Answer</summary>

**B.** Expired or revoked tokens block new enrollments without affecting existing devices.

</details>

### Q1.14

You need corporate iPads to enroll automatically, be supervised, and prevent users from removing the management profile. Which two components are required? Each correct answer presents part of the solution.

- A. An ADE (enrollment program) token from Apple Business Manager
- B. An enrollment profile with **Locked enrollment** set to Yes
- C. A web based device enrollment profile
- D. A Managed Google Play binding
- E. An account driven user enrollment profile

**Objective:** 1.2.5

<details>
<summary>Answer</summary>

**A and B.**

</details>

### Q1.15

A company buys 300 Samsung Galaxy phones from a Samsung reseller and 200 Pixel phones from an authorized zero-touch reseller. All phones must enroll as fully managed without IT touching them. What should you configure?

- A. Knox Mobile Enrollment for Samsung and Google zero-touch for Pixel, both using the Intune fully managed enrollment token
- B. Google zero-touch for all devices using a QR code
- C. Apple Business Manager for all devices
- D. Personally owned work profile enrollment with the Company Portal

**Objective:** 1.2.6

<details>
<summary>Answer</summary>

**A.** Each service needs a configuration/profile that carries the Intune enrollment **token** in the DPC extras JSON. Don't register a device in both services.

</details>

### Q1.16

Help desk staff in Madrid must be able to restart and sync **only** devices used by Madrid employees, and must see only Madrid configuration profiles. What should you configure? Select all that apply.

- A. A custom Intune role with Remote tasks permissions
- B. A role assignment whose scope groups contain Madrid users/devices
- C. Scope tags on Madrid objects, added to the role assignment
- D. The Microsoft Entra Global Reader role
- E. The Microsoft Entra Joined Device Local Administrator role

**Objective:** 1.3.1, 1.3.2

<details>
<summary>Answer</summary>

**A, B and C.** The role gives the permissions, scope groups limit targets, and scope tags limit visibility.

</details>

### Q1.17

You want every Windows device in the **London-Devices** group to be tagged automatically with the **London** scope tag. What should you do?

- A. Add the London scope tag to each device manually.
- B. Assign the London scope tag to the London-Devices group in the scope tag's Assignments.
- C. Use an assignment filter.
- D. Create a dynamic user group.

**Objective:** 1.3.2

<details>
<summary>Answer</summary>

**B.**

</details>

### Q1.18

You need to ensure that no single administrator can wipe a device. What should you configure?

- A. Privileged Identity Management for the Intune Administrator role
- B. A Multi Admin Approval access policy with profile type **Device actions**
- C. A custom role without the Wipe permission for all admins
- D. A Conditional Access policy for the Intune admin center

**Objective:** 1.3.3

<details>
<summary>Answer</summary>

**B.** MAA requires a second admin from the approver group to approve wipe/retire/delete. PIM controls who has the role, not individual actions.

</details>

### Q1.19

Your MAA approver group was created as a Microsoft 365 group. Approvers report that they can't see any requests. What should you do?

- A. Make the group mail-enabled.
- B. Replace it with a security group that is a member group of an Intune role assignment.
- C. Assign the approvers the Global Administrator role.
- D. Enable notifications in the access policy.

**Objective:** 1.3.3

<details>
<summary>Answer</summary>

**B.** Approver groups must be **security** groups with direct members, assigned as member groups in an Intune role assignment. MAA doesn't send notifications.

</details>

### Q1.20

Users must have **three days** to fix a noncompliant Windows device before losing access to Exchange Online, and they must be emailed immediately. How should you configure the actions for noncompliance?

- A. Mark device noncompliant: 0 days. Send email: 3 days.
- B. Mark device noncompliant: 3 days. Send email: 0 days.
- C. Mark device noncompliant: 3 days. Remotely lock: 0 days.
- D. Add device to retire list: 3 days.

**Objective:** 1.3.4

<details>
<summary>Answer</summary>

**B.** Delaying *Mark device noncompliant* creates a grace period (the device is still treated as compliant by CA).

</details>

### Q1.21

Devices with no compliance policy assigned are currently allowed through a Conditional Access policy that requires compliant devices. You need to block them. What should you change?

- A. The compliance status validity period
- B. *Mark devices with no compliance policy assigned as* → Not compliant
- C. Enhanced jailbreak detection
- D. The CA policy to require hybrid join

**Objective:** 1.3.4, 1.3.5

<details>
<summary>Answer</summary>

**B.**

</details>

### Q1.22

You create a Conditional Access policy that requires a compliant device for all cloud apps. New users can no longer enroll their devices. What should you do?

- A. Disable the compliance policy.
- B. Exclude the Microsoft Intune Enrollment cloud app from the policy (and protect it with MFA instead).
- C. Change the grant to Require approved client app.
- D. Set the policy to report-only permanently.

**Objective:** 1.3.5

<details>
<summary>Answer</summary>

**B.** A device can't be compliant before it enrolls, so enrollment must not require compliance. *Require approved client app* is read-only since June 30, 2026.

</details>

### Q1.23

Hybrid joined users need passwordless sign-in to Windows and SSO to on-premises file shares. You want to avoid deploying certificates to domain controllers. Which Windows Hello for Business deployment should you use?

- A. Certificate trust
- B. Key trust
- C. Cloud Kerberos trust
- D. Windows Hello convenience PIN

**Objective:** 1.3.6

<details>
<summary>Answer</summary>

**C.** Cloud Kerberos trust uses the Microsoft Entra Kerberos server object and needs no PKI. Key trust requires DC certificates.

</details>

### Q1.24

You deploy a Windows LAPS policy from Intune with backup to Microsoft Entra ID. Devices never show a password in the Intune admin center. The LAPS event log has no event 10029. What's the most likely cause?

- A. The devices are Entra joined.
- B. *Enable Microsoft Entra Local Administrator Password Solution (LAPS)* is set to No in Entra device settings.
- C. The password age is 30 days.
- D. The built-in Administrator account is renamed.

**Objective:** 1.3.7

<details>
<summary>Answer</summary>

**B.** Both the tenant switch and the policy are required.

</details>

### Q1.25

Help desk members must be able to read LAPS passwords but must not be Intune administrators. Which role should you assign?

- A. Helpdesk Administrator
- B. Security Reader
- C. Cloud Device Administrator
- D. Intune Help Desk Operator

**Objective:** 1.3.7

<details>
<summary>Answer</summary>

**C.** Helpdesk Administrator and Security Reader can see metadata only. The Intune Help Desk Operator role doesn't grant the Entra `deviceLocalCredentials/password/read` permission.

</details>

### Q1.26

You must ensure that **only** the built-in Administrator and the `SG-Workstation-Admins` group are members of the local Administrators group on corporate Windows devices. What should you configure?

- A. Local user group membership policy with **Add (Update)**
- B. Local user group membership policy with **Add (Replace)**
- C. The Microsoft Entra Joined Device Local Administrator role
- D. A Windows LAPS policy

**Objective:** 1.3.8

<details>
<summary>Answer</summary>

**B.** Replace removes all other members (the built-in Administrator is kept). The Entra role is tenant-wide and only adds members.

</details>
