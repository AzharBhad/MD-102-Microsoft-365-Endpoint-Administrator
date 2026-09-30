# LAB-4.07 - App protection policies (MAM-WE) and Conditional Access

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.07 | 4.2.1, 4.2.2 | 75 min | Intermediate |

**Goal:** Protect corporate data on an unenrolled personal phone with app protection policies, enforce them with Conditional Access, protect Edge on an unmanaged Windows device, and perform a selective wipe.

## Prerequisites

- A **personal, unenrolled** iPhone or Android phone. Install Outlook, Teams, Edge and the broker (**Authenticator** on iOS, **Company Portal** on Android - no enrollment needed).
- Optional: an unmanaged Windows 11 VM with Edge (MAM for Windows).
- Break-glass account excluded from CA.

## Required licenses

Intune Plan 1 + Entra ID P1.

## Steps

### Step 1 - iOS and Android APP (Level 2)

**Apps > Protection > Create policy > iOS/iPadOS** → `APP-iOS-L2-BYOD`:

- Apps: *Target to all device types* = **No** → **Unmanaged** → core Microsoft apps (Outlook, Teams, Word, Excel, PowerPoint, OneDrive, SharePoint, Edge, OneNote)
- Data protection: backup Block. **Send org data** → Policy managed apps. **Save copies** Block → allow OneDrive/SharePoint. **Cut/copy/paste** → Policy managed apps with paste in. Web content → Edge. Encrypt Require
- Access: PIN Require (6 digits), biometrics allowed, recheck 30 min
- Conditional launch: Max PIN attempts 5. **Offline grace period** 720 min (block) / 90 days (wipe). **Jailbroken** Block access. Min OS Warn at 17.0

Assign `SG-Lab-Users`. Repeat for **Android** (`APP-AND-L2-BYOD`: also block screen capture, Play Integrity Basic).

**Expected result:** Two policies assigned.

### Step 2 - Conditional Access for mobile

Entra → **New policy** `CA020 - Mobile - Office 365 - Require APP`:

- Users `SG-Lab-Users` (exclude break-glass). Resources **Office 365**
- Conditions: platforms **iOS, Android**
- Grant: **Require app protection policy**
- **Report-only** first

**Expected result:** Saved.

### Step 3 - Test on the phone

1. Native **Mail** app → add the work account.
2. **Outlook** → sign in as user1.

Review **Sign-in logs** → report-only results. Then switch CA020 to **On** and retry.

**Expected result:** Native Mail = blocked (report-only failure → then enforced). Outlook = asks for the broker registration, then an **app PIN** → access granted.

### Step 4 - Data leakage tests

In Outlook, copy text from a work email → paste into a personal notes app. Try **Save attachment** to local Files.

**Expected result:** Paste is blocked (or only works into policy-managed apps). Save is only allowed to OneDrive/SharePoint.

### Step 5 - MAM for Windows (optional)

1. **Apps > Protection > Create > Windows** → target **Microsoft Edge** → *Device types*: unmanaged → block copy to external apps, block print (as needed) → assign.
2. CA `CA021 - Windows - O365 - Browser - Require APP`: platforms **Windows**, client apps **Browser**, grant **Require app protection policy** (or compliant device, *Require one of*).
3. On the unmanaged VM: Edge → sign in with a **work profile** → access Outlook on the web.

**Expected result:** Edge prompts to create a work profile and apply protection. Other browsers are blocked.

### Step 6 - Monitor and selective wipe

- **Apps > Monitor > App protection status** → user1 → apps and policy check-in times.
- **Apps > App selective wipe > Create wipe request** → user1 → device → **Create**.

**Expected result:** Next time Outlook opens, the org data is wiped and the account removed. Personal data and apps remain.

## Validation

| Check | Expected |
|---|---|
| Native Mail blocked | ✅ |
| Outlook with PIN | ✅ |
| Copy to personal app | Blocked |
| Selective wipe | Work account data removed only |

## Troubleshooting

| Symptom | Fix |
|---|---|
| "Your organization requires Authenticator" loop | Install/open Authenticator (iOS) or Company Portal (Android) as broker |
| APP not applied | User not assigned. App not in policy. Sign-in with a different account. Check `about:intunehelp` in Edge |
| Blocked even in Outlook | CA requires APP but no APP is **assigned** to that user |

## Cleanup / rollback

Keep APP + CA020 (report-only if they get in the way). Remove the phone's work accounts.

## Stretch challenge

Import Microsoft's **data protection framework** Level 3 JSON (via Graph) for a high-risk group, and compare settings with your Level 2 policy.

## Knowledge check

1. Which broker app is required on iOS for app protection?
2. What CA grant replaces *Require approved client app*?
3. What does a selective wipe remove?

<details>
<summary>Answers</summary>

1. **Microsoft Authenticator**.
2. **Require app protection policy**.
3. **Organization data** in managed apps (and the work account), not personal data.

</details>
