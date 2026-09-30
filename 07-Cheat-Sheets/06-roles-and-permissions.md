# Cheat sheet: roles and least privilege

Exam questions love "least privilege". Match the task to the **smallest** role.

## Task → role

| Task | Least-privilege role | Where it's assigned | Doc |
|---|---|---|---|
| Everything in Intune | Intune Administrator | Entra ID | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |
| Manage Intune roles and assignments | Intune Role Administrator (Intune) | Intune | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |
| Help desk: sync, restart, view devices | **Help Desk Operator** (Intune) + scope groups/tags | Intune | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |
| Read-only view of Intune | **Read Only Operator** (Intune) | Intune | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |
| Manage Cloud PCs | **Windows 365 Administrator** (Entra) / Cloud PC Administrator (Intune) | Entra / Intune | [2.1.7](../02-Manage-Maintain-Devices/docs/2.1.7-windows-365-cloud-pcs.md) |
| Read **LAPS passwords** | **Cloud Device Administrator** or Intune Administrator, or custom Entra role with `deviceLocalCredentials/password/read` | Entra ID | [1.3.7](../01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |
| See LAPS metadata only | Helpdesk Administrator | Entra ID | [1.3.7](../01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md) |
| Read **BitLocker keys** in Intune | Intune permission *Managed devices > View BitLocker keys* (or Cloud Device Administrator) | Intune / Entra | [2.4.4](../02-Manage-Maintain-Devices/docs/2.4.4-rotate-bitlocker-keys.md) |
| Local admin on every Entra joined device | Microsoft Entra Joined Device Local Administrator (tenant-wide) | Entra ID | [1.1.2](../01-Prepare-Infrastructure/docs/1.1.2-join-devices-to-entra-id.md) |
| Local admin on **some** devices | **Local user group membership** policy (device groups) | Intune | [1.3.8](../01-Prepare-Infrastructure/docs/1.3.8-local-group-membership.md) |
| Approve EPM support-approved elevations | Intune role with EPM *elevation request approval* | Intune | [2.3.1](../02-Manage-Maintain-Devices/docs/2.3.1-endpoint-privilege-management.md) |
| Remote Help with UAC elevation | Intune role with Remote Help permissions incl. **Elevation** | Intune | [2.3.3](../02-Manage-Maintain-Devices/docs/2.3.3-remote-help.md) |
| Approve multi admin approval requests | Member of the MAA **approver security group** (with an Intune role) | Intune | [1.3.3](../01-Prepare-Infrastructure/docs/1.3.3-multi-admin-approval.md) |
| Microsoft 365 Apps admin center | **Office Apps Administrator** | Entra ID | [4.1.7](../04-Manage-Secure-Applications/docs/4.1.7-microsoft-365-apps-admin-center.md) |
| Service health in Intune / M365 | **Service Support Administrator** | Entra ID | [5.2.5](../05-Optimize-Endpoint-Operations/docs/5.2.5-service-health-message-center.md) |
| Message center posts | **Message Center Reader** | Entra ID | [5.2.5](../05-Optimize-Endpoint-Operations/docs/5.2.5-service-health-message-center.md) |
| Endpoint analytics reports (read) | Help Desk Operator / Read Only Operator / Endpoint Security Manager, or Entra **Reports Reader** | Intune / Entra | [5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md) |
| Run remediation on demand | Intune role with **Run remediation** (Remote tasks) | Intune | [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| Set up the Vulnerability Remediation Agent | Intune Read Only Operator (or custom) + Security Copilot **Owner** | Intune / Copilot | [5.1.2](../05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| Endpoint security policies | **Endpoint Security Manager** (Intune) | Intune | [1.3.1](../01-Prepare-Infrastructure/docs/1.3.1-intune-windows365-rbac.md) |

## Intune RBAC building blocks

| Piece | Controls | Remember |
|---|---|---|
| **Role definition** | *What* you can do (permissions) | Built-in or custom |
| **Members** | *Who* gets the role | Security group of admins |
| **Scope groups** | *Which users/devices* you can act on or assign to | Targets |
| **Scope tags** | *Which objects* (policies, apps, devices) you can see | Visibility |

- Scope tags don't restrict assignment targets - **scope groups** do.
- Delegated Graph calls respect RBAC and scope tags; **app-only** calls don't ([5.1.1](../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md)).
- Use **PIM** (Entra ID P2) for just-in-time elevation of Entra roles.
