# LAB-4.08 - App configuration policies

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.08 | 4.2.3 | 40 min | Intermediate |

**Goal:** Configure Outlook "work accounts only" via the managed-devices channel on an enrolled device, configure Edge via the managed-apps channel on an unenrolled device, and verify what the apps received.

## Prerequisites

- An **enrolled** iOS (or Android Enterprise) device with Outlook deployed by Intune (VPP/App Store or Managed Google Play).
- An **unenrolled** phone with Edge (from LAB-4.07).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Managed devices: Outlook (iOS)

**Apps > Configuration > Create > Managed devices** → Platform **iOS/iPadOS** → Targeted app **Microsoft Outlook** → `ACD-iOS-Outlook-WorkOnly`:

- Configuration designer → *Configure email account settings* = **Yes** → Authentication type Modern authentication → Username attribute **User Principal Name** → Email address attribute **Primary SMTP address**
- **Allow only work or school accounts** = **Enabled**
- (XML/keys view shows `IntuneMAMAllowedAccountsOnly` = `Enabled`, `IntuneMAMUPN` = `{{userprincipalname}}`)

Assign to the enrolled users/devices.

**Expected result:** Outlook pre-fills the work account, and adding a personal account is blocked.

### Step 2 - Managed devices: Android Enterprise

**Create > Managed devices** → **Android Enterprise** → *All profile types* → app **Microsoft Outlook** → configuration designer → set *Allowed accounts* / account setup keys → assign.

**Expected result:** Same behaviour on Android Enterprise.

### Step 3 - Managed apps: Edge (any device)

**Create > Managed apps** → *Select public apps*: **Microsoft Edge** (iOS and Android) → `ACA-Edge-Lab`:

- Edge configuration settings: **Homepage shortcut URL** `https://contoso.sharepoint.com`
- **Managed bookmarks**: `Intune|https://intune.microsoft.com`, `HR|https://contoso.sharepoint.com/sites/hr`
- **Block** URLs: `*.example-gambling.com`
- *Redirect restricted sites to personal context* = Yes

Assign `SG-Lab-Users`.

**Expected result:** On the unenrolled phone, Edge (work profile) shows the homepage shortcut and managed bookmarks.

### Step 4 - Verify

- Edge → `about:intunehelp` → **View Intune app status** → app configuration and APP settings listed.
- Intune → app config policy → **Device status / User status**.

**Expected result:** Settings visible in `about:intunehelp`, and policy status *Succeeded*.

### Step 5 - Channel reasoning

Complete: *Which channel works on the unenrolled phone? Which requires the app to be deployed by Intune?*

**Expected result:** Managed apps works without enrollment. Managed devices requires enrollment and an Intune-managed app.

## Validation

| Channel | Evidence |
|---|---|
| Managed devices (Outlook) | Personal accounts blocked on enrolled device |
| Managed apps (Edge) | Homepage/bookmarks on unenrolled phone |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Outlook still allows personal accounts | App wasn't installed/managed by Intune (installed manually first) → uninstall, redeploy via Intune |
| Edge settings missing | Edge not signed in to the work profile. No APP applied |
| Token not resolved (`{{userprincipalname}}` literal) | Typo/case in token |

## Cleanup / rollback

Keep policies, or unassign if they interfere.

## Stretch challenge

Configure **Managed Home Screen** with an app configuration policy (dedicated device from LAB-2.08) to show a sign-in screen and a session PIN.

## Knowledge check

1. Which app configuration channel works on unenrolled devices?
2. Which keys enforce "work accounts only" in Outlook on enrolled iOS?
3. Where can you see what configuration reached Edge?

<details>
<summary>Answers</summary>

1. **Managed apps**.
2. `IntuneMAMAllowedAccountsOnly` = `Enabled` and `IntuneMAMUPN` = `{{userprincipalname}}`.
3. **`about:intunehelp`** in Edge.

</details>
