# LAB-5.06 - Service health, operational baseline and alerts

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-5.06 | 5.2.5, 5.2.6 | 60 min | Intermediate |

**Goal:** Review tenant health and connectors, subscribe the team to service communications, define an operational baseline, and build alerts for compliance drift, enrollment failures and risky configuration changes.

> 💰 **Cost guardrail:** Log search alert rules cost a small amount per rule per month plus Log Analytics ingestion. Use the workspace from LAB-5.04 with its daily cap, and delete the alert rules afterwards.

## Prerequisites

- LAB-5.04 completed (diagnostic settings → `law-intune-lab`).
- A compliance policy assigned to lab devices (LAB-1.11).
- Global Administrator or Privileged Role Administrator to assign Entra roles (Step 2).

## Required licenses

Intune Plan 1, Microsoft 365 (admin center), Azure subscription for alerts.

## Steps

### Step 1 - Tenant status

**Tenant administration > Tenant status**:

1. **Tenant details** → note the tenant location, MDM authority and **service release** (select it to open *What's new*).
2. **Connector status** → list each connector and its state. For Apple: note the **APNs certificate** expiry and Apple Account used.
3. **Service health and message center** → open any active incident/advisory → **See past incidents/advisories**.

**Expected result:** A short table of connector states and expiry dates.

### Step 2 - Least-privilege roles for health information

Entra admin center → assign `helpdesk1` the **Service Support Administrator** role (eligible via PIM if available) and **Message Center Reader**. Sign in as `helpdesk1` → Intune **Tenant status** → service health visible.

**Expected result:** Health and message center visible without Global Administrator.

### Step 3 - Service communications

Microsoft 365 admin center:

1. **Health > Service health > Customize > Email** → *Send me email notifications about service health* → address `endpoint-team@contoso.onmicrosoft.com` (placeholder DL) → services: Microsoft Intune, Microsoft Entra, Windows (as available).
2. **Health > Message center > Preferences** → **Custom view**: Intune, Windows, Microsoft Entra → **Email**: weekly digest.
3. *(Optional)* **Planner** sync for message center posts.

**Expected result:** Notification preferences saved.

### Step 4 - Operational baseline

Build a baseline table from current data (Reports + Endpoint analytics):

| KPI | Current value | Alert threshold |
|---|---|---|
| % compliant devices | | e.g. drops > 3 points |
| Enrollment failures per hour | | e.g. > 5 |
| App install failure rate | | e.g. > 5% |
| Quality update compliance | | e.g. < 90% after 14 days |
| Endpoint analytics score | | red vs baseline |
| Connectors | Healthy | any Warning |

**Expected result:** A filled-in baseline you'll use for thresholds.

### Step 5 - User compliance notifications

1. **Devices > Compliance > Notifications > Create notification** → `NT-Noncompliant-EN` → subject *Your device doesn't meet Contoso security requirements* → message with steps and helpdesk contact → show company logo → **Create**.
2. Your Windows compliance policy → **Properties > Actions for noncompliance > Edit** → **Send email to end user** → 0 days → template `NT-Noncompliant-EN` → additional recipients `SG-Lab-Helpdesk`.

**Expected result:** When a device becomes noncompliant, the user and helpdesk get an email.

### Step 6 - Action group

Azure portal → **Monitor > Alerts > Action groups > Create** → `AG-Endpoint-Team` in `rg-intune-lab` → notification: **Email** to your lab admin address → **Create**.

**Expected result:** Action group created (a confirmation email arrives).

### Step 7 - Alert rules

Workspace `law-intune-lab` → **Logs** → run each query, then **New alert rule** → custom log search → action group `AG-Endpoint-Team`:

| Rule | Query (adjust columns to your schema) | Frequency / lookback | Threshold |
|---|---|---|---|
| `Intune - Enrollment failures spike` | `IntuneOperationalLogs \| where OperationName == "Enrollment" and Result == "Fail" \| summarize Failures = count()` | 15 min / 1 h | Failures > 5 (use > 0 for the test) |
| `Intune - Policy deleted` | `IntuneAuditLogs \| where OperationName has "Delete" \| project TimeGenerated, Identity, OperationName` | 15 min / 15 min | Rows > 0 |
| `Intune - Compliance drift` | `IntuneDeviceComplianceOrg` noncompliant % query from [objective 5.2.6](../docs/5.2.6-alerts-notifications.md) | 1 day / 1 day | Result rows > 0 |

**Expected result:** Three enabled alert rules.

### Step 8 - Test

1. Create and delete a test configuration profile `ZZ-Delete-Test`.
2. Attempt an enrollment that fails (for example, enroll a personal Windows device while **Windows (MDM) personally owned** is blocked in enrollment restrictions).

**Expected result:** Within ~15-30 minutes, alert emails for *Policy deleted* and *Enrollment failures spike*. **Monitor > Alerts** shows fired alerts.

## Validation

| Check | Expected |
|---|---|
| Connector table with expiry dates | ✅ |
| Health visible to `helpdesk1` via least-privilege roles | ✅ |
| Service health + message center email preferences | ✅ |
| Baseline table | ✅ |
| Noncompliance email template + action | ✅ |
| 3 alert rules, at least 2 fired in test | ✅ |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Alert never fires | No data yet in the table, query returns no rows in the lookback, wrong column/operation name |
| `helpdesk1` can't see service health | Missing Service Support Administrator, or PIM role not activated |
| Noncompliance email not received | Template not selected, user has no mailbox, or device not yet evaluated noncompliant |
| Too many alerts | Raise thresholds, alert on rates not single events, add suppression (mute actions) |

## Cleanup / rollback

Delete the three alert rules and the action group (or all of `rg-intune-lab` when you finish Domain 5). Remove the helpdesk role assignments if not needed. Keep the notification template.

## Stretch challenge

Replace the email action with a **Logic App** that posts a formatted Teams message including a link to the device in the Intune admin center.

## Knowledge check

1. Which Intune page shows connector health, service health and message center posts?
2. Which Entra role gives least-privilege access to service health?
3. Where do you configure email notifications about service health?
4. Which log table would you alert on for enrollment failures?
5. When does a connector show *Warning*?

<details>
<summary>Answers</summary>

1. **Tenant administration > Tenant status**.
2. **Service Support Administrator** (plus Message Center Reader for messages).
3. **Microsoft 365 admin center > Health > Service health > Customize > Email**.
4. **`IntuneOperationalLogs`**.
5. Credential expires within **7 days**, or last sync was more than **1 day** ago.

</details>
