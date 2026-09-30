# LAB-2.11 - Endpoint Privilege Management

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.11 | 2.3.1 | 60 min | Intermediate |

**Goal:** Enable EPM, create user-confirmed, automatic and deny rules, process a support-approved request, and build a rule from the elevation report.

## Prerequisites

- CONTOSO-LAB-03 (Entra joined) with user3 as a **standard** user (LAB-2.01).
- An installer to test, for example the Notepad++ installer copied to `C:\Program Files\Contoso\Installers\` (use an admin session or deploy it with Intune so standard users can't modify the folder).
- EPM licensing active (**Tenant administration > Intune add-ons** shows EPM as *Active* or on trial).

## Required licenses

Intune Suite / EPM add-on / Microsoft 365 E5 (July 2026+).

## Steps

### Step 1 - Elevation settings policy

**Endpoint security > Endpoint Privilege Management > Create > Windows > Elevation settings policy** → `EPM-Settings-Lab`:

- Endpoint Privilege Management: **Enabled**
- Default elevation response: **Require user confirmation** (lab), validation **Business justification**
- Send elevation data for reporting: Yes. Reporting scope: **Diagnostic data and all endpoint elevations**

Assign to `DG-Lab-Windows-Corporate`.

**Expected result:** The EPM agent installs (`Get-Service EPMService` or *Microsoft EPM Agent Service*). Right-click on an EXE shows **Run with elevated access**.

### Step 2 - Observe unmanaged elevation

As user3, right-click the Notepad++ installer → **Run with elevated access** → enter a justification.

**Expected result:** The install proceeds (default response). The elevation appears as *Unmanaged* in reports after some time.

### Step 3 - Build a rule from the report

**EPM > Reports > Elevation report** → select the Notepad++ entry → **Create rule** → add to a new policy `EPM-Rules-Lab` → elevation type **User confirmed** + Windows authentication → *File path* `C:\Program Files\Contoso\Installers` → child processes **Require rule to elevate** → assign to `SG-Lab-Users`.

**Expected result:** A new rule with the file hash/certificate prefilled.

### Step 4 - Deny rule

Add a rule to `EPM-Rules-Lab`: file `regedit.exe`, **Deny**.

**Expected result:** *Run with elevated access* on regedit shows that the app can't be run as administrator.

### Step 5 - Support approved flow

1. Change `EPM-Settings-Lab` default response to **Require support approval**.
2. As user3, try elevating an app without a rule (for example, `C:\Windows\System32\mmc.exe`) → submit a request with justification.
3. As admin: **EPM > Elevation requests** → open → **Approve**.
4. User3 retries.

**Expected result:** After approval, the elevation succeeds and the request shows *Approved*, with the approver recorded.

### Step 6 - Automatic rule (hash required)

Add a rule for a trusted internal tool with elevation type **Automatic** → provide the **file hash** (`Get-FileHash -Algorithm SHA256`).

**Expected result:** The tool runs elevated with no prompt (you still use *Run with elevated access* unless the rule targets automatic launch).

## Validation

| Test | Expected |
|---|---|
| Notepad++ installer | Prompt with Windows auth. Elevates |
| regedit elevated | Denied |
| Unruled app | Support request → approval → elevates |
| user3 in local Administrators | Never |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No *Run with elevated access* option | Settings policy not applied / EPM disabled / agent not installed yet |
| Rule not matched | Path/hash mismatch (new installer version), or a device-targeted rule overridden by a user-targeted one |
| Reports empty | Reporting scope too low, or wait (reports aren't real-time) |

## Cleanup / rollback

Set the default response back to user confirmation for other labs, or unassign the EPM policies.

## Stretch challenge

Use **Copilot in Intune** to analyze a pending elevation request and compare its risk summary with your own assessment.

## Knowledge check

1. Which elevation type requires a file hash?
2. Which wins: a device-targeted *Automatic* rule or a user-targeted *User confirmed* rule for the same file?
3. Which account does EPM use to run most elevated processes?

<details>
<summary>Answers</summary>

1. **Automatic**.
2. The **user-targeted** rule (and a Deny would beat both).
3. A **virtual account** (except *Elevate as current user*).

</details>
