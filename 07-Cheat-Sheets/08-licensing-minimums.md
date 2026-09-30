# Cheat sheet: minimum licence for a feature

Condensed from the [licensing guide](../00-Getting-Started/licensing-guide.md). When a question says "minimize cost", choose the **smallest** SKU that includes the feature.

## Intune tiers

| Feature | Plan 1 | Plan 2 | Intune Suite |
|---|---|---|---|
| Enrollment, compliance, configuration, apps, APP/app config, endpoint security, update policies, Autopilot, Endpoint analytics, Tunnel (enrolled), LAPS, MAA | ✅ | ✅ | ✅ |
| **Remote Help**, **Advanced Analytics**, **Tunnel for MAM**, specialty devices, **Android FOTA** | - | ✅ | ✅ |
| **Endpoint Privilege Management**, **Enterprise App Management**, **Cloud PKI** | - | - | ✅ |

**July 2026:** Microsoft 365 **E3** includes Intune Plan 2 capabilities (Remote Help, Advanced Analytics). Microsoft 365 **E5/E7** add EPM, Enterprise App Management and Cloud PKI.

## Other features

| Feature | Minimum |
|---|---|
| Automatic MDM enrollment, dynamic groups, Conditional Access | **Entra ID P1** |
| Risk-based CA, PIM | **Entra ID P2** |
| Require compliant device in CA | Intune Plan 1 + Entra ID P1 |
| Remediations | Windows **Enterprise E3/E5**, Education A3/A5, or **VDA** (plus Intune) |
| Feature update / expedite / driver policies, Autopatch | Windows Enterprise E3+, Education A3+, Business Premium, or Windows 365 Enterprise |
| Hotpatch | Hotpatch-eligible Windows licence, Windows 11 24H2+ Enterprise, VBS |
| Defender EDR, Vulnerability Management | **Defender for Endpoint P2** (Microsoft 365 E5) |
| Vulnerability Remediation Agent | Intune P1 + **Security Copilot SCUs** + Defender Vulnerability Management |
| Security Copilot | Included allowance in M365 **E5/E7** (400 SCUs per 1,000 licences/month); otherwise provisioned SCUs billed hourly |
| Windows 365 Cloud PC | Windows 365 licence per user (+ Windows Enterprise, Intune, Entra ID P1) |
| Log Analytics, workbooks, alert rules | **Azure subscription** |
| Windows LAPS in Entra ID | Any Entra ID licence |
