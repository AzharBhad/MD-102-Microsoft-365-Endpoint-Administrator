# LAB-1.05 - Apple personal enrollment and APNs

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.05 | 1.2.3 | 60 min (30 min without a device) | Intermediate |

**Goal:** Configure the Apple MDM push certificate, create iOS/iPadOS personal enrollment profiles (web-based device enrollment and account driven user enrollment), and enroll a personal iPhone/iPad or Mac.

> **No Apple device?** Complete Steps 1-4 and use the validation questions. Step 5 is optional.

## Prerequisites

- A **lab-only Apple Account** (not your personal one) for the APNs certificate.
- Optional: an iPhone/iPad (iOS 17+) or a Mac (macOS 14+) that you can enroll and later remove.
- For account-driven user enrollment: a domain you control where you can publish a `.well-known` file, **and** a Managed Apple Account for the test user (or ABM federation). If you don't have these, use **web based device enrollment**.

## Required licenses

Intune Plan 1 for user5. Entra ID P1.

## Steps

### Step 1 - Create the Apple MDM push certificate

1. Intune → **Devices > Enrollment > Apple > Apple MDM Push certificate**.
2. Accept → **Download your CSR**.
3. Open the Apple Push Certificates Portal (identity.apple.com), sign in with the lab Apple Account → **Create a Certificate** → upload the CSR → download the `.pem`.
4. Back in Intune: enter the Apple Account email → upload the `.pem` → **Upload**.

**Expected result:** Status **Active**, *Days until expiration* ≈ 365.

### Step 2 - Configure JIT registration prerequisites

1. **Devices > Configuration > Create > iOS/iPadOS > Templates > Device features** → `iOS-SSO-Extension`.
2. **Single sign-on app extension** → *SSO app extension type* = **Microsoft Entra ID** → *Enable shared device mode* = No.
3. Assign to `SG-Lab-Users`.
4. **Apps > iOS/iPadOS > Add > iOS store app** → search **Microsoft Authenticator** → assign **Required** to `SG-Lab-Users`.

**Expected result:** Profile and app assigned.

### Step 3 - Create a web based device enrollment profile

1. **Devices > Enrollment > Apple > Enrollment types > Create profile > iOS/iPadOS**.
2. Name `iOS-BYOD-WebDevice`. *Enrollment type* = **Web based device enrollment**.
3. Assign to `SG-Lab-Users`.

**Expected result:** The profile appears with priority 1.

### Step 4 - (Optional) Account driven user enrollment

1. Publish at `https://contoso.com/.well-known/com.apple.remotemanagement` (no file extension, `Content-Type: application/json`):

   ```json
   {"Servers":[{"Version":"mdm-byod","BaseURL":"https://manage.microsoft.com/EnrollmentServer/PostReportDeviceInfoForUEV2?aadTenantId=00000000-0000-0000-0000-000000000000"}]}
   ```

2. Verify it returns `application/json`:

   ```bash
   curl -I "https://contoso.com/.well-known/com.apple.remotemanagement"
   ```

3. Create profile `iOS-BYOD-UserEnrollment` → *Enrollment type* = **Determine based on user choice** → assign to `SG-Lab-Pilot-Users` and move it to priority 1.

**Expected result:** `curl` shows `HTTP/2 200` and `content-type: application/json`.

### Step 5 - Enroll a device (optional)

- **Web based device enrollment (iPhone):** Safari → `https://portal.manage.microsoft.com` → sign in as user5 → *Enroll* → download the profile → **Settings > Profile Downloaded > Install** → return to Safari to finish.
- **Account driven (iPhone):** **Settings > General > VPN & Device Management > Sign In to Work or School Account** → user1 → *Allow Remote Management*.
- **macOS:** install **Company Portal for macOS** → sign in as user5 → *Begin* → install the management profile → approve in **System Settings > Privacy & Security > Profiles**.

**Expected result:** The device appears in Intune with *Ownership: Personal*. Account-driven devices show limited hardware inventory (no serial/IMEI).

## Validation

| Check | Pass criteria |
|---|---|
| APNs certificate | Active, Apple Account recorded |
| Profiles | Correct priority order, assigned to user groups (device groups not allowed) |
| Enrolled device (if done) | Ownership Personal. Authenticator installed |

## Troubleshooting

| Symptom | Fix |
|---|---|
| "Your Apple ID does not support the expected services" | Service discovery file missing, wrong domain, or wrong content type |
| Profile won't install on iPhone | APNs certificate expired or wrong Apple Account. Personal iOS blocked by platform restriction |
| Mac enrolls but no policies arrive | User didn't approve the MDM profile (user-approved MDM required) |
| Web enrollment falls back to the Company Portal app | Device runs iOS < 15 |

## Cleanup / rollback

- iPhone: **Settings > General > VPN & Device Management > [profile] > Remove Management** (or Intune **Retire**).
- Mac: remove the management profile, or Intune **Retire**.
- Keep the APNs certificate for [LAB-1.07](LAB-1.07-apple-business-manager-ade.md) and [LAB-2.08](../../02-Manage-Maintain-Devices/labs/LAB-2.08-mobile-macos-configuration-profiles.md).

## Stretch challenge

Compare the device details page of a device-enrolled iPhone and a user-enrolled iPhone. List three inventory fields that are hidden for user enrollment and explain why Apple hides them.

## Knowledge check

1. How long is the APNs certificate valid, and what happens if you renew it with a different Apple Account?
2. Which iOS personal enrollment method doesn't require the Company Portal app **and** manages the whole device?
3. What must be hosted on your domain for account driven user enrollment?
4. Can you assign Apple user enrollment profiles to device groups?

<details>
<summary>Answers</summary>

1. **365 days**. A different Apple Account creates a new certificate → all Apple devices must **re-enroll**.
2. **Web based device enrollment** (iOS/iPadOS 15+).
3. The **service discovery** JSON at `/.well-known/com.apple.remotemanagement`.
4. No - user enrollment requires **user** groups.

</details>
