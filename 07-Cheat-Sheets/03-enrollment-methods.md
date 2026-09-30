# Cheat sheet: enrollment methods by platform

Pick the method from **ownership** (corporate vs personal) and **how much control** you need.

## Windows

| Method | Ownership | Join type | Key facts |
|---|---|---|---|
| **Autopilot (classic profile)** | Corporate | Entra or hybrid | Hardware hash registration, device-group assignment, ESP, naming template |
| **Autopilot device preparation** | Corporate | Entra only | No hash needed, user-group policy, static ETG device group, up to 25 apps / 10 scripts |
| **Automatic enrollment** (Entra join in OOBE or Settings) | Corporate | Entra | Needs **MDM user scope** + Intune licence |
| **Group Policy auto-enrollment** | Corporate | Hybrid | Device must be hybrid joined first |
| **Bulk enrollment** (provisioning package) | Corporate | Entra | No primary user, no user-targeted apps |
| **Register + enroll** (Access work or school > Connect) | Personal | Registered | BYOD Windows, limited (no Collect diagnostics) |
| **Co-management** | Corporate | Hybrid/Entra | Configuration Manager + Intune; see [ConfigMgr context](../00-Getting-Started/configuration-manager-context.md) |

## Apple

| Method | Ownership | Supervised | Key facts |
|---|---|---|---|
| **ADE** via Apple Business Manager | Corporate | ✅ | Locked enrollment, Setup Assistant with modern auth |
| **Apple Configurator** | Corporate | ✅ | Adds non-ABM purchases to ABM or direct enroll |
| **Account driven user enrollment** | Personal | ❌ | Managed Apple Account, privacy-preserving, separate volume |
| **Web based device enrollment** | Personal | ❌ | No Company Portal app needed (iOS 15+) |
| **Device enrollment with Company Portal** | Personal | ❌ | Legacy BYOD device enrollment |
| **Shared iPad / without user affinity** | Corporate | ✅ | No CA, no user-licensed apps |

Required connectors: **APNs certificate** (all Apple MDM), **ADE token**, **VPP token** - renew yearly.

## Android

| Method | Ownership | Key facts |
|---|---|---|
| **Personally owned work profile** | Personal | No token or reset, work apps separated |
| **Fully managed** | Corporate | Work use only, full control |
| **Corporate-owned work profile (COPE)** | Corporate | Personal apps allowed, IT can wipe device |
| **Dedicated** | Corporate | Kiosk/shared, Managed Home Screen, Entra shared device mode |
| **AOSP** | Corporate | Devices without Google Mobile Services (headsets, Teams devices) |
| **Knox Mobile Enrollment** / **Google zero-touch** | Corporate | Zero-touch provisioning; the Intune **enrollment token** is in the DPC extras |
| ~~Device administrator~~ | - | **Deprecated** - block it in platform restrictions |

## macOS

| Method | Ownership | Key facts |
|---|---|---|
| **ADE** | Corporate | Supervised, Platform SSO, FileVault escrow |
| **Company Portal (user approved)** | Personal/corporate | User-approved MDM needed for PPPC and kernel/system extensions |

## Controls that apply across methods

| Control | Where |
|---|---|
| Who may enroll which platform, personal vs corporate | **Enrollment restrictions** (platform, device limit) |
| Corporate identifiers (IMEI/serial) | Devices > Enrollment > Corporate device identifiers |
| Notify users of new enrollments | **Enrollment notifications** |
| Group membership during enrollment | **Enrollment time grouping** |
| Tokens expire / new devices can't enroll | Check the **token/certificate** expiry and **Tenant status > Connector status** |

Docs: [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) · [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) · [1.2.3](../01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) · [1.2.4](../01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) · [1.2.5](../01-Prepare-Infrastructure/docs/1.2.5-apple-business-manager-integration.md) · [1.2.6](../01-Prepare-Infrastructure/docs/1.2.6-knox-mobile-enrollment-zero-touch.md) · [2.1.1](../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md)
