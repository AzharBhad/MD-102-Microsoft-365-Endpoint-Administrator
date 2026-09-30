# Cheat sheet: numbers, limits and codes

Numbers that show up in MD-102 scenarios. Each value is explained in the linked doc. Limits change - check Learn if a number looks off.

## Enrollment and identity

| Item | Value | Doc |
|---|---|---|
| Intune device limit restriction | 1-15 devices per user, default **5** | [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| Device enrollment manager (DEM) | Up to **1,000** devices per DEM account | [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| Apple APNs certificate, ADE token, VPP token | Renew **every year** (three separate renewals) | [1.2.5](../01-Prepare-Infrastructure/docs/1.2.5-apple-business-manager-integration.md) |
| Compliance status validity period | Default **30 days** (1-120) | [1.3.4](../01-Prepare-Infrastructure/docs/1.3.4-compliance-policies.md) |
| LAPS backup success event | **10029** (Entra ID) | [1.3.7](../01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |

## Autopilot and provisioning

| Item | Value | Doc |
|---|---|---|
| Device name template | Max **15** characters | [2.1.3](../02-Manage-Maintain-Devices/docs/2.1.3-autopilot-device-name-template.md) |
| Device preparation essential apps / scripts | Up to **25** apps and **10** scripts | [2.1.1](../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md) |
| Pre-provisioning technician flow | Press **Windows key 5 times** at OOBE | [2.1.2](../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) |
| Self-deploying / pre-provisioning hardware | **TPM 2.0** with attestation | [2.1.2](../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) |
| Windows 365 custom image | Gen2, generalized, max **128 GB** (64 GB recommended) | [2.1.7](../02-Manage-Maintain-Devices/docs/2.1.7-windows-365-cloud-pcs.md) |

## Device management

| Item | Value | Doc |
|---|---|---|
| Bulk device actions | Max **100** devices per run | [2.4.2](../02-Manage-Maintain-Devices/docs/2.4.2-bulk-remote-actions.md) |
| Collected diagnostics retention | **28 days** | [2.4.7](../02-Manage-Maintain-Devices/docs/2.4.7-collect-diagnostics-logs.md) |
| Cloud PKI CRL | Valid **7 days** | [2.3.4](../02-Manage-Maintain-Devices/docs/2.3.4-cloud-pki.md) |
| Firewall rules policy | Up to **150** rules per policy | [3.1.3](../03-Protect-Devices/docs/3.1.3-firewall-policies.md) |

## Security and updates

| Item | Value | Doc |
|---|---|---|
| ASR events | **1121** blocked, **1122** audited, 1129 user allowed (Warn) | [3.1.4](../03-Protect-Devices/docs/3.1.4-attack-surface-reduction-zero-trust.md) |
| App Control events | **3076** audit, **3077** enforced block | [3.1.8](../03-Protect-Devices/docs/3.1.8-app-control-for-business.md) |
| Pause Windows updates on a ring | Up to **35 days** | [3.2.2](../03-Protect-Devices/docs/3.2.2-update-rings-feature-quality-updates.md) |
| Android system update freeze periods | Up to **90 days** per year | [3.2.5](../03-Protect-Devices/docs/3.2.5-android-updates-fota.md) |
| Apple DDM updates | iOS/iPadOS **17+**, macOS **14+** | [3.2.4](../03-Protect-Devices/docs/3.2.4-apple-update-policies-settings-catalog.md) |
| Delivery Optimization download modes | 0 HTTP only, **1 LAN**, **2 Group**, 3 Internet, **99 Simple**, 100 Bypass | [3.2.6](../03-Protect-Devices/docs/3.2.6-delivery-optimization.md) |
| Hotpatch | Windows 11 **24H2+** Enterprise, VBS on; quarterly baseline restarts | [3.2.3](../03-Protect-Devices/docs/3.2.3-windows-autopatch-hotpatch.md) |

## Apps

| Item | Value | Doc |
|---|---|---|
| Win32 detection script = detected | **exit 0 AND** output on STDOUT | [4.1.1](../04-Manage-Secure-Applications/docs/4.1.1-prepare-apps-for-deployment.md) |
| App installed but not detected | **0x87D1041C** | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| Quiet Time policy delivery | Up to **24 hours** | [4.1.3](../04-Manage-Secure-Applications/docs/4.1.3-quiet-time-policies.md) |
| APP offline grace period (Microsoft defaults) | **720 min** → block access, **90 days** → wipe data | [4.2.1](../04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| CA *Require approved client app* | Read-only since **June 30, 2026** | [4.2.2](../04-Manage-Secure-Applications/docs/4.2.2-conditional-access-app-protection.md) |

## Operations (Domain 5)

| Item | Value | Doc |
|---|---|---|
| Graph JSON batching | Up to **20** requests per batch | [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| Graph throttling | HTTP **429** + `Retry-After` | [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| exportJobs throttling | **100**/tenant/min (8 per user, 48 per app) | [5.2.1](../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| Security Copilot in M365 E5/E7 | **400 SCUs** per 1,000 licences per month, max **10,000** | [5.1.2](../05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| Vulnerability Remediation Agent "Expedite" | CVSS **≥ 9.0** | [5.1.4](../05-Optimize-Endpoint-Operations/docs/5.1.4-security-copilot-agent-recommendations.md) |
| Custom compliance | Runs every **8 h**; JSON ≤ **100 rules / 100 KB**; script ≤ 1 MB, ≤ 10 min (Windows) | [5.1.5](../05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) |
| Diagnostic settings latency | Audit/operational **near real time**; compliance org/devices **daily** (up to 48 h) | [5.2.1](../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| Endpoint analytics | ≥ **5** devices for scores; data **24 h** after restart; boot/sign-in events kept **29 days** | [5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md) |
| Startup processes / model performance | Shown when ≥ **10** devices affected | [5.2.4](../05-Optimize-Endpoint-Operations/docs/5.2.4-reliability-user-experience-scores.md) |
| Healthy update restarts | About **1 per device per month** | [5.2.4](../05-Optimize-Endpoint-Operations/docs/5.2.4-reliability-user-experience-scores.md) |
| Remediations | Up to **200** packages, output ≤ **2,048** characters; detection **exit 1** = issue | [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| Device query for multiple devices export | Up to **50,000** rows | [2.4.6](../02-Manage-Maintain-Devices/docs/2.4.6-device-query-kql.md) |
| Connector status | Warning: expires ≤ **7 days** or no sync > 1 day; Unhealthy: expired or no sync **3+ days** | [5.2.5](../05-Optimize-Endpoint-Operations/docs/5.2.5-service-health-message-center.md) |
