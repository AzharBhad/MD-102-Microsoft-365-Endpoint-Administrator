# Glossary

Current Microsoft product names are used throughout (Microsoft Entra ID, not Azure AD; Microsoft Intune admin center, not Microsoft Endpoint Manager). Former names are in brackets so you can recognize older material.

| Term | Meaning | Doc |
|---|---|---|
| **ABM** - Apple Business Manager | Apple portal for buying devices/apps and linking them to an MDM | [1.2.5](01-Prepare-Infrastructure/docs/1.2.5-apple-business-manager-integration.md) |
| **ADE** - Automated Device Enrollment (formerly DEP) | Zero-touch, supervised enrollment of Apple devices from ABM | [1.2.5](01-Prepare-Infrastructure/docs/1.2.5-apple-business-manager-integration.md) |
| **Advanced Analytics** | Intune Plan 2 capability: anomalies, device query, battery health, resource performance, device timeline | [2.3.6](02-Manage-Maintain-Devices/docs/2.3.6-advanced-analytics.md) |
| **Agentic identity** | Microsoft Entra identity a Security Copilot agent runs under, with delegated permissions | [5.1.2](05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| **ANC** - Azure network connection | Windows 365 network option for vNet access and hybrid join | [2.1.7](02-Manage-Maintain-Devices/docs/2.1.7-windows-365-cloud-pcs.md) |
| **AOSP** | Android Open Source Project management for devices without Google Mobile Services | [1.2.4](01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |
| **APNs** | Apple Push Notification service certificate required for all Apple MDM | [1.2.3](01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| **APP** - App protection policy (MAM) | Data protection inside apps (PIN, encryption, copy/paste) with or without enrollment | [4.2.1](04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| **App configuration policy** | Settings for apps; *managed devices* (MDM channel) or *managed apps* (Intune SDK) | [4.2.3](04-Manage-Secure-Applications/docs/4.2.3-app-configuration-policies.md) |
| **App Control for Business** (formerly WDAC) | Windows application allow-listing, with managed installer support | [3.1.8](03-Protect-Devices/docs/3.1.8-app-control-for-business.md) |
| **ASR** - Attack surface reduction | Rules that block risky behaviours (for example, Office creating child processes) | [3.1.4](03-Protect-Devices/docs/3.1.4-attack-surface-reduction-zero-trust.md) |
| **Assignment filter** | Device-property rule that narrows a group assignment at check-in | [2.2.6](02-Manage-Maintain-Devices/docs/2.2.6-assignment-filters-enrollment-time-grouping.md) |
| **Autopilot device preparation** | Newer Autopilot experience: no hash registration, user-group policy, Entra join | [2.1.1](02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md) |
| **Autopatch** (Windows Autopatch) | Service that automates Windows, Microsoft 365 Apps, Edge and Teams updates in rings | [3.2.3](03-Protect-Devices/docs/3.2.3-windows-autopatch-hotpatch.md) |
| **Broker app** | Microsoft Authenticator (iOS) or Company Portal (Android) handling SSO and APP registration | [4.2.2](04-Manage-Secure-Applications/docs/4.2.2-conditional-access-app-protection.md) |
| **CA** - Conditional Access | Entra ID policy engine: signals → grant/block | [1.3.5](01-Prepare-Infrastructure/docs/1.3.5-conditional-access-require-compliance.md) |
| **Cloud PKI** | Intune-hosted certificate authority issuing SCEP certificates | [2.3.4](02-Manage-Maintain-Devices/docs/2.3.4-cloud-pki.md) |
| **Cloud Policy service** | User-based Microsoft 365 Apps policy, works on unmanaged devices | [4.1.5](04-Manage-Secure-Applications/docs/4.1.5-microsoft-365-apps-policies.md) |
| **Cloud update** | Microsoft 365 Apps admin center feature that manages Office updates (replaced servicing profiles) | [4.1.7](04-Manage-Secure-Applications/docs/4.1.7-microsoft-365-apps-admin-center.md) |
| **Co-management** | Windows device managed by Configuration Manager and Intune together | [ConfigMgr context](00-Getting-Started/configuration-manager-context.md) |
| **COPE** / **COBO** | Corporate-owned work profile / corporate-owned fully managed (Android Enterprise) | [1.2.4](01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |
| **CSP** - Configuration service provider | Windows MDM interface behind each setting (OMA-URI) | [2.2.1](02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |
| **Custom compliance** | Script + JSON rules extending compliance checks | [5.1.5](05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) |
| **DDM** - Declarative Device Management | Apple's newer management model; used for OS updates in the settings catalog | [3.2.4](03-Protect-Devices/docs/3.2.4-apple-update-policies-settings-catalog.md) |
| **Dedicated device** | Android Enterprise kiosk/shared device mode | [1.2.4](01-Prepare-Infrastructure/docs/1.2.4-android-enterprise-enrollment-profiles.md) |
| **DEM** - Device enrollment manager | Account that can enroll up to 1,000 devices | [1.2.1](01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md) |
| **Device query** | KQL queries against one device (live) or the fleet (inventory) | [2.4.6](02-Manage-Maintain-Devices/docs/2.4.6-device-query-kql.md) |
| **Diagnostic settings** | Routes Intune logs to Log Analytics, Event Hubs or storage | [5.2.1](05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| **DO** - Delivery Optimization | Peer-to-peer content distribution for updates and apps | [3.2.6](03-Protect-Devices/docs/3.2.6-delivery-optimization.md) |
| **EDR** - Endpoint detection and response | Defender for Endpoint behavioural detection; onboarded by EDR policy | [3.1.6](03-Protect-Devices/docs/3.1.6-defender-for-endpoint-integration-edr.md) |
| **Endpoint analytics** | User experience scores: startup, app reliability, work from anywhere | [5.2.2](05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md) |
| **Enterprise App Catalog** | Prepackaged third-party Win32 apps (Enterprise App Management) | [2.3.2](02-Manage-Maintain-Devices/docs/2.3.2-enterprise-app-catalog.md) |
| **Entra hybrid joined** (formerly hybrid Azure AD joined) | Joined to on-premises AD and registered in Entra ID | [1.1.1](01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md) |
| **Entra joined** / **registered** | Cloud-joined corporate device / personal device with a work account | [1.1.1](01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md) |
| **EPM** - Endpoint Privilege Management | Lets standard users elevate approved apps | [2.3.1](02-Manage-Maintain-Devices/docs/2.3.1-endpoint-privilege-management.md) |
| **ESP** - Enrollment Status Page | Autopilot progress page that can block until apps/policies install | [2.1.5](02-Manage-Maintain-Devices/docs/2.1.5-enrollment-status-page.md) |
| **ETG** - Enrollment time grouping | Adds devices to a static group during enrollment | [2.2.6](02-Manage-Maintain-Devices/docs/2.2.6-assignment-filters-enrollment-time-grouping.md) |
| **Expedite** | Quality update policy that installs a security update ASAP, overriding deferrals | [3.2.2](03-Protect-Devices/docs/3.2.2-update-rings-feature-quality-updates.md) |
| **FOTA** - Firmware over the air | Android firmware update integrations (Samsung E-FOTA, Zebra LifeGuard) | [3.2.5](03-Protect-Devices/docs/3.2.5-android-updates-fota.md) |
| **Group Policy analytics** | Imports GPO backups and maps settings to Intune | [2.2.1](02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |
| **Hotpatch** | Monthly Windows security updates without restarts (quarterly baseline restarts) | [3.2.3](03-Protect-Devices/docs/3.2.3-windows-autopatch-hotpatch.md) |
| **IME** - Intune Management Extension | Windows agent for Win32 apps, scripts, remediations, custom compliance | [4.1.9](04-Manage-Secure-Applications/docs/4.1.9-monitor-troubleshoot-app-deployment.md) |
| **Intune Plan 1 / Plan 2 / Suite** | Base licence / advanced add-on / full add-on bundle | [Licensing](00-Getting-Started/licensing-guide.md) |
| **KME** - Knox Mobile Enrollment | Samsung zero-touch enrollment | [1.2.6](01-Prepare-Infrastructure/docs/1.2.6-knox-mobile-enrollment-zero-touch.md) |
| **LAPS** (Windows LAPS) | Rotates and backs up the local admin password to Entra ID or AD | [1.3.7](01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |
| **MAA** - Multi admin approval | Second-admin approval for protected Intune changes | [1.3.3](01-Prepare-Infrastructure/docs/1.3.3-multi-admin-approval.md) |
| **MAM-WE** - MAM without enrollment | App protection on devices not enrolled in Intune | [4.2.1](04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| **Managed Google Play** | Google store for approving and distributing work apps | [4.1.8](04-Manage-Secure-Applications/docs/4.1.8-store-apps-abm-managed-google-play.md) |
| **Managed installer** | App Control trust for apps installed by the IME | [3.1.8](03-Protect-Devices/docs/3.1.8-app-control-for-business.md) |
| **MDE** - Microsoft Defender for Endpoint | Enterprise endpoint security (EDR, vulnerability management) | [3.1.7](03-Protect-Devices/docs/3.1.7-onboard-defender-for-endpoint.md) |
| **MDM user scope** | Entra setting controlling who auto-enrolls into Intune | [1.2.2](01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |
| **ODT** - Office Deployment Tool | `setup.exe /configure configuration.xml` installer for Microsoft 365 Apps | [4.1.6](04-Manage-Secure-Applications/docs/4.1.6-m365-apps-autopilot-odt.md) |
| **OEMConfig** | Android vendor-specific settings via the OEM's app | [2.2.2](02-Manage-Maintain-Devices/docs/2.2.2-android-configuration-profiles.md) |
| **Platform SSO** | macOS sign-in with Entra ID credentials / passwordless | [2.2.4](02-Manage-Maintain-Devices/docs/2.2.4-macos-configuration-profiles.md) |
| **PPPC** | macOS Privacy Preferences Policy Control payload | [2.2.4](02-Manage-Maintain-Devices/docs/2.2.4-macos-configuration-profiles.md) |
| **Pre-provisioning** (formerly white glove) | Autopilot mode where IT/partner pre-installs device content | [2.1.2](02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md) |
| **Remediations** (formerly Proactive remediations) | Scheduled detection + remediation script packages | [5.2.3](05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| **Remote Help** | Intune remote assistance with RBAC and Entra authentication | [2.3.3](02-Manage-Maintain-Devices/docs/2.3.3-remote-help.md) |
| **Retire** / **Wipe** | Remove corporate data and management / factory reset | [2.4.1](02-Manage-Maintain-Devices/docs/2.4.1-sync-restart-retire-wipe.md) |
| **SCEP** / **PKCS** | Certificate delivery protocols (device-generated key / Intune-imported key) | [2.3.4](02-Manage-Maintain-Devices/docs/2.3.4-cloud-pki.md) |
| **Scope groups** / **scope tags** | RBAC targets you can act on / objects you can see | [1.3.2](01-Prepare-Infrastructure/docs/1.3.2-scope-tags-scoped-administration.md) |
| **SCU** - Security compute unit | Security Copilot capacity unit | [5.1.2](05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| **Security baseline** | Microsoft-recommended group of security settings | [3.1.5](03-Protect-Devices/docs/3.1.5-security-baselines.md) |
| **Selective wipe** | Removes org data from APP-managed apps only | [4.2.1](04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) |
| **Settings catalog** | Recommended unified settings picker for new policies | [2.2.1](02-Manage-Maintain-Devices/docs/2.2.1-windows-configuration-profiles.md) |
| **Supersedence** | Win32 relationship that updates/replaces an older app | [4.1.2](04-Manage-Secure-Applications/docs/4.1.2-deploy-win32-lob-store-apps.md) |
| **Supervised** | Apple corporate mode unlocking extra restrictions (ADE/Configurator) | [2.2.3](02-Manage-Maintain-Devices/docs/2.2.3-ios-ipados-configuration-profiles.md) |
| **Tunnel for MAM** | Microsoft Tunnel access for unenrolled iOS/Android apps | [2.3.5](02-Manage-Maintain-Devices/docs/2.3.5-microsoft-tunnel-for-mam.md) |
| **Update ring** | Windows Update deferral, deadline and restart settings | [3.2.2](03-Protect-Devices/docs/3.2.2-update-rings-feature-quality-updates.md) |
| **User enrollment** (account driven) | Privacy-preserving Apple BYOD enrollment with a managed Apple Account | [1.2.3](01-Prepare-Infrastructure/docs/1.2.3-apple-personal-enrollment.md) |
| **VPP** - Apps and Books | Apple volume purchasing via ABM; device or user licensing | [4.1.8](04-Manage-Secure-Applications/docs/4.1.8-store-apps-abm-managed-google-play.md) |
| **Vulnerability Remediation Agent** | Security Copilot agent prioritizing CVEs with Intune fix steps | [5.1.2](05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| **WHfB** - Windows Hello for Business | Phishing-resistant, key-based Windows sign-in | [1.3.6](01-Prepare-Infrastructure/docs/1.3.6-windows-hello-for-business.md) |
| **Win32 app** | Intune app type wrapping any installer as `.intunewin` | [4.1.1](04-Manage-Secure-Applications/docs/4.1.1-prepare-apps-for-deployment.md) |
| **Windows 365** | Cloud PCs streamed from Microsoft's cloud | [2.1.7](02-Manage-Maintain-Devices/docs/2.1.7-windows-365-cloud-pcs.md) |
| **Windows Backup for Organizations** | Backs up settings/Store apps and restores them on a new Entra joined device | [2.1.8](02-Manage-Maintain-Devices/docs/2.1.8-windows-backup.md) |
| **Zero-touch** (Android) | Google's reseller-based corporate Android provisioning | [1.2.6](01-Prepare-Infrastructure/docs/1.2.6-knox-mobile-enrollment-zero-touch.md) |
