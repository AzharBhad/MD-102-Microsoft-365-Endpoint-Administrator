# Practice questions - Domain 5: Optimize endpoint operations (10-15%)

All questions are **original** and written for this repository. They aren't taken from the exam. Expand each answer after you've chosen.

## Questions

### Q5.01

A nightly script must read all Intune managed devices without anyone signing in. You want to avoid storing secrets. What should you use?

- A. A service account with a password stored in the script
- B. An Azure Automation runbook with a **managed identity** granted `DeviceManagementManagedDevices.Read.All`
- C. Delegated permissions with `Connect-MgGraph -Scopes`
- D. The Intune PowerShell SDK (`Microsoft.Graph.Intune`) module

**Objective:** 5.1.1

<details>
<summary>Answer</summary>

**B.** Managed identities (or certificate-based app-only auth) avoid stored secrets. The old Intune PowerShell module is retired.

</details>

### Q5.02

A script using delegated Graph permissions only returns some of the tenant's devices, even with paging handled. What's the most likely cause?

- A. Graph `v1.0` doesn't return Windows devices.
- B. The admin's Intune **RBAC role and scope tags** limit which devices they can see.
- C. The script needs `$batch`.
- D. Delegated calls are limited to 100 devices.

**Objective:** 5.1.1

<details>
<summary>Answer</summary>

**B.** Delegated calls run as the signed-in admin, including their Intune scope.

</details>

### Q5.03

Your script receives HTTP 429 responses from Microsoft Graph during a bulk operation. What should it do?

- A. Retry immediately in a tight loop.
- B. Honour the **Retry-After** header and back off, and reduce request volume.
- C. Switch from `v1.0` to `beta`.
- D. Request `DeviceManagementManagedDevices.PrivilegedOperations.All`.

**Objective:** 5.1.1

<details>
<summary>Answer</summary>

**B.** 429 is throttling. Back off and use `$select`/`$batch` to reduce calls.

</details>

### Q5.04

A script must remotely **sync** and **restart** devices. Which Graph permission is required?

- A. DeviceManagementManagedDevices.Read.All
- B. DeviceManagementConfiguration.ReadWrite.All
- C. **DeviceManagementManagedDevices.PrivilegedOperations.All**
- D. Device.ReadWrite.All

**Objective:** 5.1.1

<details>
<summary>Answer</summary>

**C.** Remote actions such as sync, restart, wipe and retire need PrivilegedOperations.

</details>

### Q5.05

You set up the Vulnerability Remediation Agent, but it returns no suggestions. Intune and Security Copilot are licensed. What's most likely missing?

- A. An Endpoint analytics baseline
- B. **Defender Vulnerability Management data** from devices onboarded to Defender for Endpoint
- C. A custom compliance policy
- D. A Log Analytics workspace

**Objective:** 5.1.2

<details>
<summary>Answer</summary>

**B.** The agent prioritizes CVEs from Defender Vulnerability Management. No onboarded devices = no data.

</details>

### Q5.06

After setting up the Vulnerability Remediation Agent, the **Run** button is unavailable. What should you do?

- A. Buy an Intune Suite licence.
- B. Delegate the required Intune and Defender permissions to the agent's **agentic user**, then pass **Run Readiness Check**.
- C. Assign the agent to a device group.
- D. Enable the Policy Configuration Agent first.

**Objective:** 5.1.2

<details>
<summary>Answer</summary>

**B.** Runs stay disabled until permissions are delegated to the agent identity and the readiness check passes.

</details>

### Q5.07

Which statement about the Vulnerability Remediation Agent is correct?

- A. It automatically deploys quality updates to exposed devices.
- B. It supports Windows Server devices.
- C. It provides prioritized suggestions with step-by-step Intune remediation guidance; admins implement the fix.
- D. It doesn't consume Security Copilot capacity.

**Objective:** 5.1.2

<details>
<summary>Answer</summary>

**C.** The agent suggests; admins act. It covers Windows client devices and apps in Intune and consumes SCUs.

</details>

### Q5.08

A helpdesk engineer wants Copilot to produce a KQL query showing the top memory-consuming processes on one device. What's required?

- A. Endpoint analytics only
- B. An **Advanced Analytics** licence (device query) and Security Copilot
- C. A Log Analytics workspace
- D. Defender for Endpoint P2

**Objective:** 5.1.3

<details>
<summary>Answer</summary>

**B.** Copilot generates KQL for device query, which requires Advanced Analytics.

</details>

### Q5.09

You need to find devices with poor startup scores using natural language and immediately target them with a remediation. Which feature should you use?

- A. Copilot in Intune **Explorer** → add results to a group
- B. Tenant status
- C. The Device Offboarding Agent
- D. Microsoft 365 Apps admin center

**Objective:** 5.1.3

<details>
<summary>Answer</summary>

**A.** Explorer can add query results to a group or save a custom report.

</details>

### Q5.10

An agent suggestion recommends expediting a Windows quality update. You deploy it to all devices. What should you do in the agent afterwards?

- A. Nothing - the agent detects the deployment and closes the suggestion.
- B. Select **Mark as applied** to record the remediation.
- C. Remove and re-add the agent.
- D. Give the suggestion a thumbs-down.

**Objective:** 5.1.4

<details>
<summary>Answer</summary>

**B.** Mark as applied is an admin self-attestation with a timestamp. The agent doesn't track your deployment itself.

</details>

### Q5.11

Why might a Vulnerability Remediation Agent suggestion start with **Expedite**?

- A. The device is noncompliant.
- B. The CVE's **CVSS score is 9.0 or higher**.
- C. The update is a feature update.
- D. The device is enrolled in Autopatch.

**Objective:** 5.1.4

<details>
<summary>Answer</summary>

**B.** For CVSS ≥ 9.0 the agent recommends expediting the quality update.

</details>

### Q5.12

As of October 2026, which Security Copilot agent is still available in the Intune admin center?

- A. Policy Configuration Agent
- B. Change Review Agent
- C. Device Offboarding Agent
- D. **Vulnerability Remediation Agent**

**Objective:** 5.1.4

<details>
<summary>Answer</summary>

**D.** Device Offboarding was removed June 1, 2026; Policy Configuration and Change Review after August 31, 2026.

</details>

### Q5.13

Your custom compliance discovery script returns pretty-printed multi-line JSON, and all custom settings show errors. What should you change?

- A. Use `ConvertTo-Json -Compress` so the output is a single line.
- B. Run the script in 32-bit PowerShell.
- C. Upload the JSON rules as a script.
- D. Enable signature check.

**Objective:** 5.1.5

<details>
<summary>Answer</summary>

**A.** Windows discovery scripts must return compressed single-line JSON.

</details>

### Q5.14

Where do you define which discovered value counts as compliant in custom compliance?

- A. In the discovery script's exit code
- B. In the **JSON rules file** (SettingName, Operator, DataType, Operand)
- C. In a Conditional Access policy
- D. In a remediation script

**Objective:** 5.1.5

<details>
<summary>Answer</summary>

**B.** The script discovers values; the JSON file defines the rules and user remediation strings.

</details>

### Q5.15

How often does the Intune Management Extension run custom compliance discovery scripts by default?

- A. Every hour
- B. **Every 8 hours**
- C. Every 24 hours
- D. Only at enrollment

**Objective:** 5.1.5

<details>
<summary>Answer</summary>

**B.** Every 8 hours, and when the user selects Check compliance.

</details>

### Q5.16

You must stream Intune audit logs to a third-party SIEM in near real time. Which diagnostic settings destination should you choose?

- A. Storage account
- B. **Event Hubs**
- C. Log Analytics workspace only
- D. Export to CSV

**Objective:** 5.2.1

<details>
<summary>Answer</summary>

**B.** Event Hubs is for streaming to SIEM tools. Storage = archive; Log Analytics = query/workbooks/alerts.

</details>

### Q5.17

A Power BI report must refresh device inventory from Intune every night without a human exporting CSVs. Which option uses the supported reporting export API?

- A. Microsoft Graph **`deviceManagement/reports/exportJobs`**
- B. Intune Data Warehouse (beta) connector v1
- C. Screen-scraping the admin center
- D. Advanced Analytics device query

**Objective:** 5.2.1

<details>
<summary>Answer</summary>

**A.** exportJobs exports Intune reports. The Data Warehouse beta connector v1 was retired in April 2026.

</details>

### Q5.18

You enabled Endpoint analytics yesterday. The Overview page shows *Insufficient data*. What's the most likely reason?

- A. The tenant lacks Security Copilot.
- B. Fewer than **5** devices have reported data (devices must restart after receiving the policy).
- C. Devices run Windows Enterprise.
- D. Remediations are disabled.

**Objective:** 5.2.2

<details>
<summary>Answer</summary>

**B.** At least five reporting devices are required, and data appears up to 24 h after a restart.

</details>

### Q5.19

Which three subscores make up the Endpoint analytics score?

- A. Compliance, configuration, updates
- B. **Startup performance, Application reliability, Work from anywhere**
- C. Battery health, resource performance, anomalies
- D. Boot, sign-in, restart frequency

**Objective:** 5.2.2

<details>
<summary>Answer</summary>

**B.** The overall score is a weighted average of those three.

</details>

### Q5.20

A remediation's detection script finds the problem but the remediation script never runs. The detection script writes the issue to output and exits with code 0. What should you change?

- A. Run the script as the logged-on user.
- B. Make the detection script **`exit 1`** when the issue is found.
- C. Schedule it hourly.
- D. Enable 64-bit PowerShell.

**Objective:** 5.2.3

<details>
<summary>Answer</summary>

**B.** Only exit code 1 triggers the remediation script.

</details>

### Q5.21

Admins can't create remediation packages; the option is greyed out. Users have Microsoft 365 E3. What should you do?

- A. Buy Intune Plan 2.
- B. Turn on and confirm **Windows license verification** (Tenant administration > Connectors and tokens > Windows data).
- C. Enable Endpoint analytics baselines.
- D. Assign the Help Desk Operator role.

**Objective:** 5.2.3

<details>
<summary>Answer</summary>

**B.** Remediations need Windows Enterprise E3/E5 (included in M365 E3) and the license confirmation.

</details>

### Q5.22

In the Startup performance **Restart frequency** view, which category should ideally be about one per device per month?

- A. Stop errors
- B. Restart (no update)
- C. **Update**
- D. Long power button press

**Objective:** 5.2.4

<details>
<summary>Answer</summary>

**C.** About one update restart per month is healthy. Restart (no update) should be near zero.

</details>

### Q5.23

A service desk lead must see Intune service health incidents in the Intune admin center without Global Administrator rights. Which role should you assign?

- A. Intune Read Only Operator
- B. **Service Support Administrator**
- C. Reports Reader
- D. Cloud Device Administrator

**Objective:** 5.2.5

<details>
<summary>Answer</summary>

**B.** Service health on Tenant status requires Service Support Administrator.

</details>

### Q5.24

Apple devices suddenly stop receiving policies. Where should you check first in Intune?

- A. Endpoint analytics
- B. **Tenant administration > Tenant status > Connector status** (APNs certificate)
- C. App protection status
- D. Windows Autopatch reports

**Objective:** 5.2.5

<details>
<summary>Answer</summary>

**B.** An expired APNs certificate breaks Apple management. Connector status shows it as Unhealthy.

</details>

### Q5.25

The endpoint team wants an email within 15 minutes whenever enrollment failures spike. What should you configure?

- A. Compliance policy actions for noncompliance
- B. Enrollment notifications
- C. Diagnostic settings to **Log Analytics** and an **Azure Monitor log search alert rule** on `IntuneOperationalLogs` with an action group
- D. A Quiet Time policy

**Objective:** 5.2.6

<details>
<summary>Answer</summary>

**C.** Operational logs arrive in near real time; alert rules and action groups notify IT.

</details>

### Q5.26

Users must receive an email the moment their device becomes noncompliant, with the helpdesk in copy. What should you configure?

- A. An Azure Monitor alert rule
- B. A notification message template and the **Send email to end user** action for noncompliance, with additional recipients
- C. Enrollment notifications
- D. Service health email preferences

**Objective:** 5.2.6

<details>
<summary>Answer</summary>

**B.** Noncompliance actions notify users; add groups as additional recipients.

</details>
