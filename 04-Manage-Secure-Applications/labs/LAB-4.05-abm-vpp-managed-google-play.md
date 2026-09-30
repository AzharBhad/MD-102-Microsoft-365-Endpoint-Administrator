# LAB-4.05 - Apple Business Manager and Managed Google Play apps

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-4.05 | 4.1.8 | 45 min | Intermediate |

**Goal:** Approve and deploy Managed Google Play apps (public, private and web), and configure an Apple VPP (Apps and Books) token with device-licensed apps.

> **Apple part:** requires an ABM organization. Without one, complete the Google part and walk through the VPP steps.

## Prerequisites

- Managed Google Play bound (LAB-1.06). An Android Enterprise device optional.
- *(Apple)* ABM access with the Content Manager role, and ADE-enrolled iOS device optional.

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Public Managed Google Play app

**Apps > Android > Create > Managed Google Play app** → search **Microsoft Teams** → **Select** → **Approve** → *Keep approved when app requests new permissions* → **Sync**.

**Expected result:** Teams appears under Apps > Android as *Managed Google Play store app*.

### Step 2 - Assign

Assign Teams **Required** to `SG-Lab-ETG-AE-FullyManaged` (corporate) and **Available** to `SG-Lab-Users` (work profile Play Store).

**Expected result:** Teams installs on the fully managed device. BYOD work profile users see it in the work Play Store.

### Step 3 - Private app and web app

In the MGP iframe:

- **Private apps** → upload any test `.apk` (for example, a sample app you built) → title `Contoso Inventory`.
- **Web apps** → `https://contoso.sharepoint.com` → *Full screen* → icon.

Sync and assign both.

**Expected result:** The private app is visible only to your organization's Managed Google Play (publishing can take ~10 minutes).

### Step 4 - Apple VPP token

1. ABM → **Apps and Books** → search **Microsoft Outlook** → location `Contoso Lab` → quantity 10 → **Get**.
2. ABM → your name → **Preferences > Payments and Billing** → download the **server token** for the location.
3. Intune → **Tenant administration > Connectors and tokens > Apple VPP tokens > Create** → upload → Country **United States** → **Automatic app updates** = Yes → Create → **Sync**.

**Expected result:** Token *Active*. Outlook appears under Apps > iOS/iPadOS as a VPP app with licence counts.

### Step 5 - Device-licensed deployment

Assign Outlook (VPP) **Required** → **License type: Device** → target corporate ADE iPhones.

**Expected result:** Outlook installs silently on supervised devices without an Apple Account prompt. Licence count **Used** increases.

### Step 6 - Company Portal via VPP for ADE

Get **Intune Company Portal** in Apps and Books → device licensing → set it in the ADE profile (*Install Company Portal with VPP* = Yes, token selected) from LAB-1.07.

**Expected result:** Company Portal installs during ADE Setup Assistant.

## Validation

| Check | Expected |
|---|---|
| MGP public/private/web apps | Approved, synced, assigned |
| VPP token | Active, auto-update on |
| Device licensing | Silent install, licence consumed |

## Troubleshooting

| Symptom | Fix |
|---|---|
| MGP app not in Intune list | Not **synced** after approval |
| VPP app shows "Insufficient licenses" | Buy more licences in ABM for that location |
| VPP token "Assigned to another MDM" | Use *Take control of token from another MDM* |
| iOS prompts for Apple Account | User licensing selected, or the device isn't supervised |

## Cleanup / rollback

Revoke licences (**App licenses > Revoke**) before deleting VPP apps/tokens. Unassign MGP test apps.

## Stretch challenge

Configure **Managed Google Play app update priority = High priority** for Teams and explain when you'd use it.

## Knowledge check

1. What makes a VPP app install silently without an Apple Account?
2. What must you do after approving an app in Managed Google Play?
3. How often does a VPP token need renewal?

<details>
<summary>Answers</summary>

1. **Device licensing** on **supervised** devices.
2. **Sync** Managed Google Play in Intune (and then assign).
3. **Every year**.

</details>
