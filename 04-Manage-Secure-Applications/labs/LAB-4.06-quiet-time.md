# LAB-4.06 - Quiet Time

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.06 | 4.1.3 | 25 min | Beginner |

**Goal:** Create "days of the week" and "date range" Quiet Time policies that mute Outlook and Teams notifications on iOS/Android, and test user overrides.

## Prerequisites

- A phone (iOS or Android) with Outlook and Teams signed in as user1 (enrolled or MAM-only).
- Commercial cloud tenant (Quiet Time isn't supported in GCC/GCC High/DoD/21Vianet).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Days of the week policy

**Apps > Quiet Time > Policies > Create policy** → **Days of the week** → `QT-AfterHours-Lab`:

- Allday: *Mute notifications all day* = Require → Saturday, Sunday
- Certain Hours: *Mute notifications daily* = Require → 19:00-07:00 → Monday-Friday
- End User Overrides: *Allow user to change settings* = **Yes**

Assign to `SG-Lab-Users`.

**Expected result:** Policy created. Delivery can take up to **24 hours**.

### Step 2 - Date range policy

**Create policy** → **Date Range** → `QT-Shutdown-Lab` → Start 24 Dec 18:00, End 02 Jan 07:00 → assign `SG-Lab-Users`.

**Expected result:** Created.

### Step 3 - Test (optional device)

Temporarily edit the weekday window to cover the current time → wait for the policy to apply → send an email and a Teams chat to user1.

**Expected result:** Messages arrive in the apps, but no notifications are shown. In Outlook: **Settings > Notifications > Quiet time** shows the organization schedule (editable because overrides are allowed).

### Step 4 - Disable overrides

Set *Allow user to change settings* = **No**.

**Expected result:** The user can no longer change the organization quiet time schedule in Outlook.

### Step 5 - Think about Non-working time

Read the *Non-working time* type and write down the prerequisite (Working Time API integration for Teams/frontline).

**Expected result:** You can explain why not to enable it without that integration.

## Validation

- Both policies are assigned to user groups.
- Notification behaviour (if tested) matches the schedule.

## Troubleshooting

| Symptom | Fix |
|---|---|
| No effect after an hour | Policies take up to 24 h. Check the user is in the group and apps are current |
| Teams still notifies | Teams not signed in with the targeted work account, or outdated app |

## Cleanup / rollback

Restore the weekday schedule to after-hours or delete the lab policies.

## Stretch challenge

Draft a "right to disconnect" configuration for three countries with different rules, using separate groups and policies.

## Knowledge check

1. Which apps are muted by Quiet Time policies?
2. Where are Quiet Time policies created?
3. What does the *Non-working time* type depend on?

<details>
<summary>Answers</summary>

1. **Microsoft Outlook** (email) and **Microsoft Teams** on iOS/iPadOS and Android.
2. **Apps > Quiet Time > Policies**.
3. The **Working Time API** integration (Teams/frontline working hours).

</details>
