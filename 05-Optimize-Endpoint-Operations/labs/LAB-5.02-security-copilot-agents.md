# LAB-5.02 - Security Copilot agents and Copilot in Intune

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.02 | 5.1.2, 5.1.3, 5.1.4 | 60-90 min | Advanced |

**Goal:** Set up the Vulnerability Remediation Agent, investigate and respond to a suggestion, and use Copilot in Intune to analyze device performance.

> ⚠️ **Cost guardrail:** Security Copilot bills in **security compute units (SCUs)**. Microsoft 365 E5/E7 paid tenants include a monthly allowance; trial and developer tenants may not. Before you start, check **Security Copilot > Owner settings** for capacity and any overage setting. If you'd pay for provisioned SCUs, **turn overage off**, do this lab in one sitting, then **delete the capacity** (see [lab environment setup](../../00-Getting-Started/lab-environment-setup.md)). No capacity? Do the **paper path**: read the steps, study the Learn screenshots, and answer the knowledge check.

## Prerequisites

- Windows devices onboarded to **Defender for Endpoint** with vulnerability data visible in **Defender > Vulnerability management** (LAB-3.05, wait 24 h after onboarding).
- Endpoint analytics enabled with at least 5 devices for scores (LAB-5.05) - Part B still works with fewer devices for single-device prompts.
- Security Copilot capacity with the **Microsoft Intune** and **Microsoft Defender** plugins enabled.
- Roles: Intune **Read Only Operator** (or Intune Administrator) + Security Copilot **Owner**. Rights in Entra and Defender to delegate permissions to the agent's identity.

## Required licenses

Intune Plan 1, Microsoft Security Copilot (SCUs), Defender Vulnerability Management (Defender for Endpoint P2 / Microsoft 365 E5). Device query steps: Advanced Analytics.

## Steps

### Part A - Vulnerability Remediation Agent

#### Step 1 - Set up the agent

**Intune admin center > Agents > Vulnerability Remediation Agent > Set up Agent** → review permissions, plugins and workspace → **Start agent**.

**Expected result:** An **agent identity** (agentic user) is created in Entra ID. The page shows that permissions must be delegated before runs succeed.

#### Step 2 - Delegate permissions and run the readiness check

1. Intune: add the agentic user to a **Read Only Operator** role assignment (or a custom role with *Mobile apps: Read* and *Device configurations: Read*).
2. Defender XDR: assign the agentic user a custom unified RBAC role equivalent to **Security Reader**.
3. Agent **Settings** tab → **Run Readiness Check**.

**Expected result:** Readiness check passes and **Run** becomes available.

#### Step 3 - Run and investigate

1. **Overview > Start agent** (or **Run**). Watch **Activity**: *Run in progress* → *Complete*.
2. **Suggestions** tab → sort by **Impact** → open the top suggestion.
3. Record: remediation type (app / OS), impact, exposed devices, number of CVEs, and whether the suggested step starts with **Expedite** (CVSS ≥ 9.0).
4. Open one CVE in **Defender > Vulnerability management > Weaknesses** → check exploit availability and exposed devices.

**Expected result:** You can explain *why* this suggestion is at the top.

#### Step 4 - Respond

Choose one:

- **Accept:** implement the guidance in a pilot (for example, a quality update / expedite policy for `DG-Lab-Windows-Corporate` (pilot subset), or an app update with supersedence), then **Mark as applied**.
- **Reject/defer:** write a one-line risk acceptance (reason, owner, review date), use 👎 feedback, leave it *Not applied*.

**Expected result:** Suggestion status reflects your decision, and **Last applied** shows your account/time if applied.

### Part B - Copilot in Intune for device performance

#### Step 5 - Summarize and compare

1. **Devices > All devices > CONTOSO-LAB-01 > Summarize with Copilot**.
2. In Copilot chat: *"Compare this device with CONTOSO-LAB-02"*.
3. *"Analyze error code 0x87D1041C"*.

**Expected result:** A summary (hardware, OS, apps, policies), a comparison table and an error explanation - limited to what your RBAC scope allows.

#### Step 6 - Explorer to group

**Explorer** → type *"devices with the lowest startup performance score"* (or pick a built-in example) → review → **Add to group** `DG-Lab-SlowStartup`.

**Expected result:** A new group containing the listed devices (useful as a remediation target in LAB-5.05).

#### Step 7 - Device query with Copilot (Advanced Analytics)

Device → **Monitor > Device query** → ask Copilot *"What are the top 10 processes using the most memory on this device?"* → run the generated KQL.

**Expected result:** A KQL query against the `Process` table and a result list.

### Step 8 - Check the cost

Security Copilot portal → usage monitoring → find the SCUs used by this lab.

**Expected result:** You know roughly what one agent run and a few prompts cost.

## Validation

| Check | Expected |
|---|---|
| Agent identity created and readiness check passed | ✅ |
| At least one suggestion investigated with CVE evidence | ✅ |
| Suggestion marked *Applied* or rejection documented | ✅ |
| Copilot summary/compare/error analysis | ✅ |
| Explorer results added to a group | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| "You don't have access to this agent - Licenses" | Missing Security Copilot capacity/plugins or Defender Vulnerability Management |
| "... - Workspace" | Your account isn't in the Security Copilot workspace - ask the Copilot owner |
| Run button disabled | Readiness check not passed - delegate Intune and Defender permissions to the agentic user |
| No suggestions | No Defender vulnerability data yet (onboard devices, wait 24 h), or only Windows Server devices |
| Run fails mid-way | SCUs exhausted, or authorization lost - check capacity; remove and set up the agent again if the identity is broken |

## Cleanup / rollback

- Remove the agent if you don't need it (**Agents > agent > Remove agent**) - this deletes suggestions and applied history.
- Delete Security Copilot capacity if you provisioned it for the lab.
- Delete `DG-Lab-SlowStartup` if not used in LAB-5.05.

## Stretch challenge

Build a Security Copilot **promptbook** for the helpdesk: *summarize device → list noncompliant settings → last 5 app crashes → suggest next steps*. Run it on two devices and compare SCU usage.

## Knowledge check

1. What data source does the Vulnerability Remediation Agent use?
2. What does **Mark as applied** do to devices?
3. Which Intune agents are still available after August 31, 2026?
4. Which Copilot feature turns a natural-language query into a group or custom report?
5. What licence is needed for device query?

<details>
<summary>Answers</summary>

1. **Microsoft Defender Vulnerability Management** (via the Defender plugin), combined with Intune data.
2. **Nothing** - it's an admin self-attestation that records a timestamp.
3. Only the **Vulnerability Remediation Agent** (Policy Configuration and Change Review removed after Aug 31, 2026; Device Offboarding removed June 1, 2026).
4. **Explorer** in the Intune admin center.
5. **Advanced Analytics**.

</details>
