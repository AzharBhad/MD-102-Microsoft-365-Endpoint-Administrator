# 09 - Troubleshooting

Practical troubleshooting references for the lab and the job. The exam tests the same skills: pick the right log, report or tool for a symptom.

| File | Contents |
|---|---|
| [log-locations.md](log-locations.md) | Where the logs are on Windows, macOS, iOS and Android, plus service-side tools |
| [error-codes.md](error-codes.md) | Enrollment, app, security and operations codes with likely causes |
| [troubleshooting-flows.md](troubleshooting-flows.md) | Step-by-step flows for enrollment, Autopilot, apps, Conditional Access and policy conflicts |

## Toolbox

| Tool | Use |
|---|---|
| **Troubleshooting + support > Troubleshoot** (Intune) | One user: devices, assignments, failures, app protection |
| **Collect diagnostics** (remote action) | Logs from a corporate Windows device without touching it |
| **Device query** (Advanced Analytics) | Live state of a Windows device with KQL |
| **Copilot in Intune** | Summarize/compare devices, explain error codes |
| `dsregcmd /status` | Entra join/registration and PRT state |
| `mdmdiagnosticstool.exe` | Targeted MDM/Autopilot/TPM log cab |
| **CMTrace** | Reading IME and Configuration Manager style logs |
| Edge `about:intunehelp` | App protection and app configuration state on mobile/MAM |
| Entra **Sign-in logs** | Conditional Access results |
| **Audit logs** (Intune + Entra) | Who changed what |

Labs that practise these tools: [LAB-2.17](../02-Manage-Maintain-Devices/labs/LAB-2.17-remote-actions.md), [LAB-2.18](../02-Manage-Maintain-Devices/labs/LAB-2.18-device-query-diagnostics.md), [LAB-4.01](../04-Manage-Secure-Applications/labs/LAB-4.01-win32-packaging-troubleshooting.md), [LAB-5.06](../05-Optimize-Endpoint-Operations/labs/LAB-5.06-service-health-alerts.md).
