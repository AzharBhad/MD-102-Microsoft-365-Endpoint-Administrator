# Common error codes and messages

Codes that appear in this repo's docs, with the likely cause. Always read the full error text Intune shows - it's usually more specific than any table.

## Enrollment and join (Windows)

| Code / message | Likely cause | Fix | Doc |
|---|---|---|---|
| **0x80180014** | Enrollment restriction blocks the device, or an old Intune record exists | Check platform restrictions; delete the stale device record | [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |
| **0x8018002b** | UPN uses an unverified domain, or user not in **MDM user scope** | Verify the domain / add the user to MDM scope | [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |
| **801c0003** / "Your organization has reached its device limit" | Entra *Maximum number of devices per user*, or user not allowed to join | Raise the quota / allow the user | [1.1.2](../01-Prepare-Infrastructure/docs/1.1.2-join-devices-to-entra-id.md) |
| **DeviceCapReached** / "Device cap reached" | Intune **device limit restriction** | Raise the limit or remove old devices | [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| Device joins Entra but isn't in Intune | MDM user scope = None/Some (user excluded) or no Intune licence | Fix MDM scope and licensing | [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |
| Shows as *registered* not *joined* | User selected **Connect** instead of **Join this device to Microsoft Entra ID** | Disconnect and join | [1.1.2](../01-Prepare-Infrastructure/docs/1.1.2-join-devices-to-entra-id.md) |

## Enrollment (Apple and Android)

| Message | Likely cause | Doc |
|---|---|---|
| "Your Apple ID does not support the expected services on this device" | Service discovery file missing or wrong content type (account driven user enrollment) | [1.2.3](../01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| Apple devices stop receiving commands | **APNs certificate expired** - renew with the same Apple Account | [1.2.3](../01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| New Android corporate devices can't enroll, old ones fine | Enrollment **token expired** | [1.2.4](../01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |

## Apps (Win32 / IME)

| Code | Meaning | Fix | Doc |
|---|---|---|---|
| **0x87D1041C** | Installed but **not detected** | Fix the detection rule (path, version, product code) | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| **0x87D1313C** | Network connection lost during download | Retry; check proxy/firewall and Delivery Optimization | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| **1603** (installer exit code) | MSI/EXE failed | Read the installer log; test as SYSTEM | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| **1618** | Another installation in progress | Keep mapped to *Retry* | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| **3010** / **1641** | Soft / hard reboot required | Configure return codes and restart behaviour | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| *Not applicable* | Requirement rule or assignment filter excluded the device | Review requirements/filters | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |

## Security and compliance events

| Event / signal | Meaning | Doc |
|---|---|---|
| LAPS **10029** | Password backed up to Entra ID (missing = tenant LAPS switch off) | [1.3.7](../01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |
| ASR **1121** / **1122** / 1129 | Blocked / audited / user allowed after Warn | [3.1.4](../03-Protect-Devices/docs/3.1.4-attack-surface-reduction-zero-trust.md) |
| CodeIntegrity **3076** / **3077** | App Control audit / enforced block | [3.1.8](../03-Protect-Devices/docs/3.1.8-app-control-for-business.md) |
| New devices noncompliant for BitLocker/Secure Boot | Device Health Attestation needs a **reboot** | [1.3.4](../01-Prepare-Infrastructure/docs/1.3.4-compliance-policies.md) |
| Policy status **Conflict** | Two policies set different values | [2.2.1](../02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |

## Operations

| Symptom | Likely cause | Doc |
|---|---|---|
| Graph **403** | Missing scope/consent, or RBAC scope excludes the object | [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| Graph **429** | Throttled - honour `Retry-After` | [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| Remediations greyed out | Windows license verification not confirmed | [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| Endpoint analytics *Insufficient data* | Fewer than 5 reporting devices | [5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md) |
| Custom compliance setting shows error | Script output not single-line JSON, or `SettingName` mismatch | [5.1.5](../05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) |
| Agent run fails | SCUs exhausted, permissions not delegated, authorization expired | [5.1.2](../05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
