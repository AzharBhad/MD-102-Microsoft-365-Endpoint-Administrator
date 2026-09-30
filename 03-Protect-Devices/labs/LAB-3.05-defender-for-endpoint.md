# LAB-3.05 - Defender for Endpoint connector, onboarding, EDR and triage

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-3.05 | 3.1.6, 3.1.7 | 75 min | Intermediate |

**Goal:** Connect Intune and Defender for Endpoint, onboard Windows devices with an EDR policy, make machine risk drive compliance and Conditional Access, generate a test alert, and triage the incident in Microsoft Defender XDR.

## Prerequisites

- Microsoft 365 E5 trial (includes Defender for Endpoint P2). First sign-in to `security.microsoft.com` provisions the Defender tenant (can take minutes to hours).
- CONTOSO-LAB-01 and -03.
- CA010 from [LAB-1.11](../../01-Prepare-Infrastructure/labs/LAB-1.11-compliance-conditional-access.md).

## Required licenses

Defender for Endpoint P2, Intune Plan 1, Entra ID P1.

## Steps

### Step 1 - Enable the connection in Defender

Defender portal → **Settings > Endpoints > Advanced features**:

- **Microsoft Intune connection** = On
- Automated investigation = On. Enable EDR in block mode = On. Allow or block file = On. Tamper protection = On
- Save.

**Expected result:** Saved.

### Step 2 - Enable the connector in Intune

**Tenant administration > Connectors and tokens > Microsoft Defender for Endpoint** → wait for *Connection status: Enabled* → turn on *Connect Windows devices…*, *Connect Android devices…*, *Connect iOS/iPadOS devices…*, and *Allow Microsoft Defender for Endpoint to enforce Endpoint Security Configurations* → Save.

**Expected result:** Connection status Enabled with a recent *Last synchronized*.

### Step 3 - EDR onboarding policy

**Endpoint security > Endpoint detection and response > Create** → Windows → **Endpoint detection and response** → `EDR-Lab-Onboard` → package type **Auto from connector**, sample sharing **All** → assign to `DG-Lab-Windows-Corporate`.

**Expected result:** After sync:

```powershell
Get-Service Sense
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status').OnboardingState   # 1
```

Defender portal → **Assets > Devices** lists both VMs as *Onboarded*.

### Step 4 - Compliance based on machine risk

Edit `CP-Windows-Baseline` → **Microsoft Defender for Endpoint** → *Require the device to be at or under the machine risk score* = **Low**.

**Expected result:** Saved. Devices with Medium+ risk become noncompliant.

### Step 5 - Generate a test alert

Run the **detection test** from the Defender portal onboarding page (**Settings > Endpoints > Onboarding** → *Run a detection test*) in an elevated PowerShell on CONTOSO-LAB-03. Also drop the EICAR file.

**Expected result:** Within ~15 minutes, an alert and an **incident** appear under **Incidents & alerts**.

### Step 6 - Triage the incident

Open the incident:

1. **Assign to me**, set **Status = In progress**.
2. Review the **attack story**, **alerts**, **assets**, **evidence**.
3. Open the device page → **Timeline** → find the test process.
4. Response actions: **Run antivirus scan (Quick)**, **Collect investigation package**. Optionally **Isolate device** (then **Release from isolation**).
5. Resolve: **Classification** = *Informational, expected activity* → *Security testing*.

**Expected result:** The incident is resolved with a classification. Action center shows the actions taken.

### Step 7 - Observe compliance impact (optional)

While the alert is active, the device risk may be Medium/High → Intune compliance for CONTOSO-LAB-03 flips to **Not compliant** → CA010 blocks Outlook on the web.

**Expected result:** Risk-based access control demonstrated. After resolution, risk drops and compliance returns.

### Step 8 - Security tasks (optional)

Defender portal → **Vulnerability management > Recommendations** → pick one → **Request remediation** → *Remediation request to Intune*. In Intune → **Endpoint security > Security tasks** → accept → complete.

**Expected result:** The task flow from SOC to endpoint team is demonstrated.

## Validation

| Check | Expected |
|---|---|
| Devices onboarded | Both in Defender device inventory |
| Test alert → incident | ✅ triaged + resolved |
| Risk in compliance | Setting visible in compliance report |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Connector stays *Unavailable* | Enable the connection in Defender advanced features first. Wait up to 15 min |
| SENSE not running | EDR policy not applied, or the OS lacks the sensor (Home edition). Check event log *SENSE* |
| Devices "Can be onboarded" but not onboarded | Policy targeting/assignment issue |
| No incident | Test ran without elevation, or Defender tenant still provisioning |

## Cleanup / rollback

Keep onboarding. Consider setting the risk score compliance to **Medium** to avoid lab lockouts.

## Stretch challenge

Write an advanced hunting query that lists processes launched by Office apps in the last 7 days:

```kusto
DeviceProcessEvents
| where Timestamp > ago(7d)
| where InitiatingProcessFileName in~ ("winword.exe","excel.exe","powerpnt.exe","outlook.exe")
| project Timestamp, DeviceName, InitiatingProcessFileName, FileName, ProcessCommandLine
```

## Knowledge check

1. Where must the Defender–Intune connection be enabled?
2. Which EDR package option avoids downloading an onboarding blob?
3. How does a Defender alert end up blocking access to Exchange Online?

<details>
<summary>Answers</summary>

1. In **both** Defender (*Advanced features > Microsoft Intune connection*) and Intune (*Connectors > Microsoft Defender for Endpoint*).
2. **Auto from connector**.
3. The alert raises **machine risk** → the Intune **compliance** rule (risk score) marks the device noncompliant → **Conditional Access** *require compliant device* blocks.

</details>
