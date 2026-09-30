# Cheat sheet: Windows Autopilot

## Classic profile vs device preparation

| | Classic Autopilot profile | Autopilot device preparation |
|---|---|---|
| Registration | Hardware hash (OEM, partner, CSV, Graph) | None (optional device association) |
| Assigned to | **Device** group (for example, `[ZTDid]` dynamic rule) | **User** group |
| Join | Entra join or **hybrid join** | **Entra join only** |
| Modes | User-driven, **self-deploying**, **pre-provisioning**, Autopilot Reset | User-driven, automatic (Windows 365) |
| Progress page | **ESP** | Own progress page (no ESP) |
| Device group | Any | **Static** group owned by **Intune Provisioning Client** (ETG) |
| Apps/scripts during setup | ESP blocking apps | Up to **25** apps, **10** scripts |
| Naming template | ✅ (max 15 chars, ignored for hybrid) | ❌ |
| Windows version | Windows 10/11 | Windows 11 |

## Deployment modes (classic)

| Mode | Use when | Requirements |
|---|---|---|
| **User-driven** | Standard user laptops | Network, user credentials |
| **Self-deploying** | Kiosks, digital signs, Teams Rooms | **TPM 2.0 attestation**, Entra join only, no user ESP phase |
| **Pre-provisioning** | Partner/IT pre-stages apps before delivery | TPM 2.0 attestation, **Windows key × 5**, device-targeted apps only in technician phase, then **Reseal** |
| **Autopilot Reset** | Reuse device for a new user, keep enrollment | Local or remote reset |
| **Hybrid join** | GPO still required | **Intune Connector for Active Directory**, Domain Join profile, *Skip AD connectivity check* over VPN |

## Order of operations

`Register device → group (dynamic [ZTDid] or group tag) → assign profile → wait for "Assigned" → deploy`

## ESP rules

- Tracks **required** apps only. Block device use until apps/profiles installed for zero-touch security.
- Device setup = device-targeted; account setup = user-targeted (none in self-deploying).
- **Don't mix LOB MSI and Win32** apps - package as Win32 (including M365 Apps via ODT).
- *Only show page to devices provisioned by OOBE* avoids ESP for Settings-app enrollments.

## Troubleshooting quick hits

| Symptom | Likely cause |
|---|---|
| Profile not applied, generic OOBE | Profile not **Assigned** yet, device not in the group |
| No company branding at sign-in | Entra **company branding** not configured |
| Self-deploying / pre-provisioning fails on VM | **TPM attestation** not available |
| Hybrid join times out | Connector offline, no DC line of sight, missing *Skip AD connectivity check* |
| Device reappears after being deleted | Still registered in **Windows Autopilot devices** - deregister |
| Device preparation doesn't start | Group not static / owner not Intune Provisioning Client, user not in policy group, device registered with classic profile |

Logs and tools: [09-Troubleshooting/log-locations.md](../09-Troubleshooting/log-locations.md) · Diagram: [Autopilot flow](../assets/diagrams/autopilot-flow.md)

Docs: [2.1.1](../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md) · [2.1.2](../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) · [2.1.3](../02-Manage-Maintain-Devices/docs/2.1.3-autopilot-device-name-template.md) · [2.1.4](../02-Manage-Maintain-Devices/docs/2.1.4-implement-autopilot-deployment.md) · [2.1.5](../02-Manage-Maintain-Devices/docs/2.1.5-enrollment-status-page.md)
