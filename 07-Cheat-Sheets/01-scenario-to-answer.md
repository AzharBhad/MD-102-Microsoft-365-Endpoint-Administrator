# Cheat sheet: scenario → answer

MD-102 questions are mostly scenarios. Learn the **trigger words** and the answer they point to. Every row links to the doc that explains why.

## Domain 1 - Prepare infrastructure

| Scenario keywords | Answer | Doc |
|---|---|---|
| Personal device, BYOD, users keep their personal account | **Entra registered** | [1.1.1](../01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md) |
| New devices, cloud-only, no on-premises infrastructure | **Entra joined** | [1.1.1](../01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md) |
| Must still receive Group Policy / computer-account auth | **Hybrid join** (Entra Connect + SCP) | [1.1.1](../01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md) |
| Device "shows as registered instead of joined" | User chose **Connect** instead of **Join this device to Microsoft Entra ID** | [1.1.2](../01-Prepare-Infrastructure/docs/1.1.2-join-devices-to-entra-id.md) |
| Devices join Entra but don't appear in Intune | **MDM user scope** None/excludes user, or no Intune licence | [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |
| Devices added to a group automatically, minimal effort | **Dynamic group** (Entra ID P1) | [1.1.4](../01-Prepare-Infrastructure/docs/1.1.4-device-groups-dynamic-membership.md) |
| Group membership *during* enrollment so apps install at setup | **Enrollment time grouping** (static group, owner Intune Provisioning Client) | [2.2.6](../02-Manage-Maintain-Devices/docs/2.2.6-assignment-filters-enrollment-time-grouping.md) |
| Users may enroll at most 3 devices | **Device limit restriction** | [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| Block personal iOS, allow ABM iPads | **Platform restriction** personally owned = Block | [1.2.1](../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| Personal iPhones, IT must not see personal apps or wipe the device | **Account driven user enrollment** (or MAM-WE) | [1.2.3](../01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| Enroll iPhone without installing Company Portal | **Web based device enrollment** or account driven user enrollment | [1.2.3](../01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| Corporate iPhones supervised, users can't remove management | **ABM + ADE** with **locked enrollment** | [1.2.5](../01-Prepare-Infrastructure/docs/1.2.5-apple-business-manager-integration.md) |
| Corporate Android, personal apps allowed, IT can wipe | **COPE** (corporate-owned work profile) | [1.2.4](../01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |
| Shared scanners locked to one app | **Dedicated** (+ Entra shared device mode) | [1.2.4](../01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |
| Samsung devices, zero touch, reseller | **Knox Mobile Enrollment**; mixed OEMs → **Google zero-touch** | [1.2.6](../01-Prepare-Infrastructure/docs/1.2.6-knox-mobile-enrollment-zero-touch.md) |
| Help desk can act only on Paris devices | Role + **scope groups** (targets) + **scope tags** (visible objects) | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |
| Admins only see their region's policies | **Scope tags** | [1.3.2](../01-Prepare-Infrastructure/docs/1.3.2-scope-tags-scoped-administration.md) |
| Second admin must approve wipes / script deployments | **Multi admin approval** (Device actions / Scripts) | [1.3.3](../01-Prepare-Infrastructure/docs/1.3.3-multi-admin-approval.md) |
| Devices with no compliance policy get through CA | Tenant setting *Mark devices with no compliance policy* = **Not compliant** | [1.3.4](../01-Prepare-Infrastructure/docs/1.3.4-compliance-policies.md) |
| Give users 3 days to fix before blocking | *Mark device noncompliant* after **3 days** | [1.3.4](../01-Prepare-Infrastructure/docs/1.3.4-compliance-policies.md) |
| Evaluate a CA policy without affecting users | **Report-only** | [1.3.5](../01-Prepare-Infrastructure/docs/1.3.5-conditional-access-require-compliance.md) |
| Compliant **or** hybrid joined devices | Both controls + **Require one of the selected controls** | [1.3.5](../01-Prepare-Infrastructure/docs/1.3.5-conditional-access-require-compliance.md) |
| Passwordless Windows sign-in with on-prem SSO, minimal infrastructure | **WHfB cloud Kerberos trust** | [1.3.6](../01-Prepare-Infrastructure/docs/1.3.6-windows-hello-for-business.md) |
| Help desk reads local admin passwords, can't manage policies | Entra **Cloud Device Administrator** (or custom `deviceLocalCredentials/password/read`) | [1.3.7](../01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |
| Help desk local admin only on London devices | **Local user group membership** policy to London device group | [1.3.8](../01-Prepare-Infrastructure/docs/1.3.8-local-group-membership.md) |

## Domain 2 - Manage and maintain devices

| Scenario keywords | Answer | Doc |
|---|---|---|
| No hardware hash collection, minimal admin effort | **Autopilot device preparation** | [2.1.1](../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md) |
| Hybrid join, pre-provisioning, self-deploying, naming template, HoloLens | **Classic Autopilot profile** | [2.1.1](../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md) |
| Kiosk, digital sign, no user interaction | **Self-deploying** (TPM 2.0 attestation) | [2.1.2](../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) |
| Partner prepares devices, shorter wait for users | **Pre-provisioning** (Windows key × 5) | [2.1.2](../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) |
| Users must not reach desktop until apps/profiles installed | **ESP** with *Block device use...* + blocking apps | [2.1.5](../02-Manage-Maintain-Devices/docs/2.1.5-enrollment-status-page.md) |
| Stay on a specific Windows 11 version for a year | **Feature update policy** (not a 365-day deferral) | [2.1.6](../02-Manage-Maintain-Devices/docs/2.1.6-windows-11-upgrades.md) |
| Cloud PCs must be hybrid joined | **Azure network connection** | [2.1.7](../02-Manage-Maintain-Devices/docs/2.1.7-windows-365-cloud-pcs.md) |
| Restore user settings/apps on a new PC | **Windows Backup** - restore = tenant-wide Enrollment setting, Entra join only | [2.1.8](../02-Manage-Maintain-Devices/docs/2.1.8-windows-backup.md) |
| Migrate GPOs with least effort | **Group Policy analytics** → Migrate | [2.2.1](../02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |
| Third-party app ships ADMX | **Import ADMX** | [2.2.1](../02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |
| iOS restriction doesn't apply to BYOD iPhones | Setting **requires supervision** | [2.2.3](../02-Manage-Maintain-Devices/docs/2.2.3-ios-ipados-configuration-profiles.md) |
| Grant Mac app Full Disk Access silently | **PPPC** payload | [2.2.4](../02-Manage-Maintain-Devices/docs/2.2.4-macos-configuration-profiles.md) |
| Zebra/Samsung vendor settings | **OEMConfig** | [2.2.2](../02-Manage-Maintain-Devices/docs/2.2.2-android-configuration-profiles.md) |
| All devices except kiosks, no new groups | **Assignment filter** (Exclude) | [2.2.6](../02-Manage-Maintain-Devices/docs/2.2.6-assignment-filters-enrollment-time-grouping.md) |
| Standard users install one signed app without admin rights | **EPM** elevation rule | [2.3.1](../02-Manage-Maintain-Devices/docs/2.3.1-endpoint-privilege-management.md) |
| Third-party apps without packaging | **Enterprise App Catalog** | [2.3.2](../02-Manage-Maintain-Devices/docs/2.3.2-enterprise-app-catalog.md) |
| Remote control + UAC with RBAC and audit | **Remote Help** | [2.3.3](../02-Manage-Maintain-Devices/docs/2.3.3-remote-help.md) |
| Wi-Fi certs, no on-prem PKI | **Cloud PKI + SCEP** | [2.3.4](../02-Manage-Maintain-Devices/docs/2.3.4-cloud-pki.md) |
| Personal Android reaches intranet in Edge without enrolling | **Tunnel for MAM** | [2.3.5](../02-Manage-Maintain-Devices/docs/2.3.5-microsoft-tunnel-for-mam.md) |
| New driver caused stop errors on one model | **Advanced Analytics anomalies** | [2.3.6](../02-Manage-Maintain-Devices/docs/2.3.6-advanced-analytics.md) |
| Remove corporate data from personal phone, keep photos | **Retire** | [2.4.1](../02-Manage-Maintain-Devices/docs/2.4.1-sync-restart-retire-wipe.md) |
| Reuse Windows device for a new user, stay enrolled | **Autopilot Reset** | [2.4.1](../02-Manage-Maintain-Devices/docs/2.4.1-sync-restart-retire-wipe.md) |
| Rename 80 devices | **Bulk device actions** (max 100) | [2.4.2](../02-Manage-Maintain-Devices/docs/2.4.2-bulk-remote-actions.md) |
| Recovery key disclosed to user | **BitLocker key rotation** / client-driven rotation | [2.4.4](../02-Manage-Maintain-Devices/docs/2.4.4-rotate-bitlocker-keys.md) |
| Live info from one Windows device without a script | **Device query** | [2.4.6](../02-Manage-Maintain-Devices/docs/2.4.6-device-query-kql.md) |
| Logs from a corporate Windows device remotely | **Collect diagnostics** | [2.4.7](../02-Manage-Maintain-Devices/docs/2.4.7-collect-diagnostics-logs.md) |

## Domain 3 - Protect devices

| Scenario keywords | Answer | Doc |
|---|---|---|
| Local admins add their own Defender exclusions | **Disable Local Admin Merge** (+ tamper protection) | [3.1.1](../03-Protect-Devices/docs/3.1.1-antivirus-policies.md) |
| Encrypt without user interaction | **Silent BitLocker**: TPM-only, warning disabled, standard user encryption allowed | [3.1.2](../03-Protect-Devices/docs/3.1.2-disk-encryption-bitlocker-filevault.md) |
| Only centrally managed firewall rules | *Allow Local Policy Merge* = **False** | [3.1.3](../03-Protect-Devices/docs/3.1.3-firewall-policies.md) |
| Stop Word launching PowerShell | **ASR rule** *Block all Office applications from creating child processes* | [3.1.4](../03-Protect-Devices/docs/3.1.4-attack-surface-reduction-zero-trust.md) |
| Block USB writes except approved | **Device control** | [3.1.4](../03-Protect-Devices/docs/3.1.4-attack-surface-reduction-zero-trust.md) |
| Microsoft-recommended settings, least effort | **Security baseline** | [3.1.5](../03-Protect-Devices/docs/3.1.5-security-baselines.md) |
| Block access from high-risk devices | MDE connector + compliance **machine risk score** + CA | [3.1.6](../03-Protect-Devices/docs/3.1.6-defender-for-endpoint-integration-edr.md) |
| Onboard all Intune Windows devices to MDE, least effort | **EDR policy, Auto from connector** | [3.1.7](../03-Protect-Devices/docs/3.1.7-onboard-defender-for-endpoint.md) |
| Allow only Windows, Store and Intune-deployed apps | **App Control** built-in controls + **managed installer** | [3.1.8](../03-Protect-Devices/docs/3.1.8-app-control-for-business.md) |
| Emergency security patch today | **Expedite** quality update | [3.2.2](../03-Protect-Devices/docs/3.2.2-update-rings-feature-quality-updates.md) |
| Stop a bad cumulative update now | **Pause** quality updates on the ring (35 days) | [3.2.2](../03-Protect-Devices/docs/3.2.2-update-rings-feature-quality-updates.md) |
| Windows + M365 Apps + Edge + Teams updates with minimal policy work | **Windows Autopatch** | [3.2.3](../03-Protect-Devices/docs/3.2.3-windows-autopatch-hotpatch.md) |
| Monthly security updates without restarts | **Hotpatch** | [3.2.3](../03-Protect-Devices/docs/3.2.3-windows-autopatch-hotpatch.md) |
| Force iOS update by a date | **Settings catalog DDM** software update | [3.2.4](../03-Protect-Devices/docs/3.2.4-apple-update-policies-settings-catalog.md) |
| Pin Zebra firmware and schedule rollout | **Zebra LifeGuard OTA** (FOTA) | [3.2.5](../03-Protect-Devices/docs/3.2.5-android-updates-fota.md) |
| Peers across subnets/NATs at one site | DO download mode **Group (2)** + Group ID | [3.2.6](../03-Protect-Devices/docs/3.2.6-delivery-optimization.md) |

## Domain 4 - Manage and secure applications

| Scenario keywords | Answer | Doc |
|---|---|---|
| EXE with silent switch + prerequisite | **Win32** + **dependency** | [4.1.1](../04-Manage-Secure-Applications/docs/4.1.1-prepare-apps-for-deployment.md) |
| Replace v1 with v2 | **Supersedence** (uninstall previous) | [4.1.2](../04-Manage-Secure-Applications/docs/4.1.2-deploy-win32-lob-store-apps.md) |
| Store app kept updated | **Microsoft Store app (new)** (WinGet) | [4.1.2](../04-Manage-Secure-Applications/docs/4.1.2-deploy-win32-lob-store-apps.md) |
| Mute Outlook/Teams notifications after hours | **Quiet Time** policy | [4.1.3](../04-Manage-Secure-Applications/docs/4.1.3-quiet-time-policies.md) |
| Remove Office MSI when deploying M365 Apps | *Remove other versions* / ODT `<RemoveMSI />` | [4.1.4](../04-Manage-Secure-Applications/docs/4.1.4-deploy-microsoft-365-apps.md) |
| Office settings on unmanaged devices | **Cloud Policy service** | [4.1.5](../04-Manage-Secure-Applications/docs/4.1.5-microsoft-365-apps-policies.md) |
| M365 Apps fails in Autopilot ESP with Win32 apps | **Win32 + ODT** package | [4.1.6](../04-Manage-Secure-Applications/docs/4.1.6-m365-apps-autopilot-odt.md) |
| Office updates with rollback and exclusion windows | **Cloud update** (M365 Apps admin center) | [4.1.7](../04-Manage-Secure-Applications/docs/4.1.7-microsoft-365-apps-admin-center.md) |
| Silent iOS app install, no Apple Account | VPP **device licensing** on supervised devices | [4.1.8](../04-Manage-Secure-Applications/docs/4.1.8-store-apps-abm-managed-google-play.md) |
| App installs but Intune says failed (0x87D1041C) | **Detection rule** wrong | [4.1.9](../04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| Protect email on personal phones without enrollment | **App protection policy** + CA *Require app protection policy* | [4.2.1](../04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| Block copy from Outlook to WhatsApp | APP data transfer → **Policy managed apps** | [4.2.1](../04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| Only Outlook with APP can reach Exchange on mobile | CA **Require app protection policy** (approved client app is read-only) | [4.2.2](../04-Manage-Secure-Applications/docs/4.2.2-conditional-access-app-protection.md) |
| Pre-fill Outlook account on enrolled iPhones, block personal accounts | App config **managed devices** | [4.2.3](../04-Manage-Secure-Applications/docs/4.2.3-app-configuration-policies.md) |
| Edge settings on unenrolled phones | App config **managed apps** | [4.2.3](../04-Manage-Secure-Applications/docs/4.2.3-app-configuration-policies.md) |

## Domain 5 - Optimize endpoint operations

| Scenario keywords | Answer | Doc |
|---|---|---|
| Unattended script, no stored secrets | **Managed identity** / certificate app-only + Graph SDK | [5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| Prioritize CVEs with Intune fix steps | **Vulnerability Remediation Agent** | [5.1.2](../05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| Natural-language query → group/report | Copilot in Intune **Explorer** | [5.1.3](../05-Optimize-Endpoint-Operations/docs/5.1.3-security-copilot-agents-device-performance.md) |
| Record that an agent suggestion was implemented | **Mark as applied** | [5.1.4](../05-Optimize-Endpoint-Operations/docs/5.1.4-security-copilot-agent-recommendations.md) |
| Org-specific check affects Conditional Access | **Custom compliance** (script + JSON) | [5.1.5](../05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) |
| Stream Intune logs to a SIEM | Diagnostic settings → **Event Hubs** | [5.2.1](../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| Automated report export | Graph **exportJobs** | [5.2.1](../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| Boot/sign-in times, app crashes, cloud readiness | **Endpoint analytics** | [5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md) |
| Detect and fix an issue on a schedule | **Remediations** (detection `exit 1`) | [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| Blue screens trend | Startup performance → **Restart frequency** → stop errors | [5.2.4](../05-Optimize-Endpoint-Operations/docs/5.2.4-reliability-user-experience-scores.md) |
| Is Intune down? / APNs expired? | **Tenant status** (service health / connector status) | [5.2.5](../05-Optimize-Endpoint-Operations/docs/5.2.5-service-health-message-center.md) |
| Email IT when enrollment failures spike | Log Analytics + **Azure Monitor alert rule** | [5.2.6](../05-Optimize-Endpoint-Operations/docs/5.2.6-alerts-notifications.md) |
