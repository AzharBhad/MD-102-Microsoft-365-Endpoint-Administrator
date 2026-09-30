# LAB-1.11 - Compliance policy and Conditional Access

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.11 | 1.3.4, 1.3.5 | 75 min | Intermediate |

**Goal:** Build Windows and iOS compliance policies with a grace period and notifications, then enforce them with a Conditional Access policy tested in report-only mode first.

## Prerequisites

- CONTOSO-LAB-01 (Entra joined, enrolled) and CONTOSO-LAB-02 (registered, personal).
- A break-glass account excluded from all CA policies.
- Security defaults **disabled** (**Entra > Overview > Properties > Manage security defaults**).

## Required licenses

Intune Plan 1 + **Entra ID P1**.

## Steps

### Step 1 - Tenant compliance settings

**Endpoint security > Device compliance > Compliance policy settings** → *Mark devices with no compliance policy assigned as* = **Not compliant** → validity period **30** → Save.

**Expected result:** Settings saved.

### Step 2 - Notification template

**Devices > Compliance > Notifications > Create notification** → `Noncompliance - Windows` → subject "Action needed: your device isn't compliant" → body with `{{DeviceName}}` and steps → include IT contact.

**Expected result:** **Send preview email** arrives in your mailbox.

### Step 3 - Windows compliance policy

**Devices > Compliance > Create policy > Windows 10 and later** → `CP-Windows-Baseline`:

- Device Health: *Require Secure Boot* = Require
- Device Properties: *Minimum OS version* = `10.0.22631`
- System Security: *Require encryption of data storage on device* = Require, *Firewall* = Require, *TPM* = Require, *Antivirus* = Require, *Microsoft Defender Antimalware* = Require
- Actions: *Mark device noncompliant* = **1** day. *Send email* = **0** days (template from Step 2). *Add device to retire list* = 30 days.
- Assign: `SG-Lab-Users`.

**Expected result:** The policy is created. After a device sync, CONTOSO-LAB-01 evaluates within ~15 minutes.

### Step 4 - iOS compliance policy

`CP-iOS-Baseline`: *Jailbroken devices* = Block, *Minimum OS* = 17.0, *Require a password* = Require, *Maximum minutes of inactivity* = 5 → assign `SG-Lab-Users`.

**Expected result:** Created.

### Step 5 - Review compliance

Devices → CONTOSO-LAB-01 → **Device compliance** → open `CP-Windows-Baseline` per-setting status.

**Expected result:** A VM **without BitLocker** shows *Require encryption* = Not compliant, and the device state shows **In grace period** (1 day) - not *Not compliant* yet.

### Step 6 - Create the CA policy in report-only mode

Entra → **Conditional Access > New policy** `CA010 - Lab users - Office 365 - Require compliant device`:

- Users: `SG-Lab-Users`. Exclude: break-glass.
- Target resources: **Office 365**.
- Grant: **Require device to be marked as compliant**.
- Enable: **Report-only**.

**Expected result:** Policy saved in report-only mode.

### Step 7 - Generate sign-ins and review impact

Sign in to `https://outlook.office.com` as user1 from CONTOSO-LAB-01 (Edge, signed in) and as user4 from CONTOSO-LAB-02.

Entra → **Sign-in logs** → open each sign-in → **Report-only** tab.

**Expected result:** LAB-01 = *Report-only: Success* (if compliant or in grace), LAB-02 = *Report-only: Failure* (registered / personal, no compliance).

### Step 8 - Use the What If tool

**Conditional Access > What If** → user4, Office 365, Windows, device state not compliant.

**Expected result:** CA010 listed under *Policies that will apply*.

### Step 9 - Enforce

Switch CA010 to **On**. Retry from CONTOSO-LAB-02 in Edge.

**Expected result:** "You can't get there from here" with guidance to enroll/check compliance.

## Validation

| Check | Expected |
|---|---|
| LAB-01 compliance | Compliant, or in grace then noncompliant if not encrypted (encrypt it in [LAB-3.02](../../03-Protect-Devices/labs/LAB-3.02-bitlocker-filevault.md)) |
| LAB-02 Outlook on the web access | Blocked when CA is On |
| Break-glass sign-in | Not affected |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Compliant device still blocked in Chrome | Install the **Microsoft Single Sign On** extension, or use Edge signed in |
| Device *Not evaluated* | Sync the device. Make sure a policy is assigned (user **or** device group) |
| All users blocked | CA targeted *All users* without exclusions → sign in with break-glass and fix |
| Can't enroll new devices after CA | Exclude the **Microsoft Intune Enrollment** app from CA010 or scope it to Office 365 only |

## Cleanup / rollback

Set CA010 to **Report-only** or **Off** if it blocks other labs. Keep compliance policies.

## Stretch challenge

Add a second grant control **Require Microsoft Entra hybrid joined device** with *Require one of the selected controls* and explain which population each control serves.

## Knowledge check

1. What does *In grace period* mean for Conditional Access?
2. Which tenant setting stops devices with no assigned compliance policy from passing CA?
3. Why start CA policies in report-only mode?
4. Which grant control became read-only on June 30, 2026, and what replaces it?

<details>
<summary>Answers</summary>

1. The device is still treated as **compliant** until the *Mark device noncompliant* schedule elapses.
2. *Mark devices with no compliance policy assigned as* = **Not compliant**.
3. To evaluate impact through sign-in logs/insights without blocking users.
4. **Require approved client app** → use **Require app protection policy**.

</details>
