# Windows Autopilot flows

Two Autopilot engines and the classic deployment modes on one page. Used by Domain 2 docs.

## Classic Autopilot (deployment profile)

```mermaid
sequenceDiagram
  autonumber
  participant OEM as OEM / IT
  participant APS as Autopilot service
  participant IN as Intune
  participant DEV as Device (OOBE)
  OEM->>APS: Register hash (CSV / partner / Convert existing)
  IN->>IN: [ZTDid] / group tag dynamic group → profile Assigned
  DEV->>APS: Online at OOBE → download profile
  alt User-driven
    DEV->>DEV: Branded sign-in → Entra (or hybrid) join
  else Self-deploying
    DEV->>DEV: TPM attestation → Entra join (no user)
  else Pre-provisioning
    DEV->>DEV: Win×5 → technician ESP (device phase) → Reseal → user flow later
  end
  DEV->>IN: MDM enrollment → ESP (device setup → account setup)
  IN-->>DEV: Policies · certificates · apps
```

## Autopilot device preparation

```mermaid
sequenceDiagram
  autonumber
  participant U as User (in assigned user group)
  participant DEV as Device (OOBE)
  participant IN as Intune
  U->>DEV: Sign in with work account at OOBE
  DEV->>IN: Entra join + enrollment
  IN->>IN: Enrollment time grouping → device added to static group (owner: Intune Provisioning Client)
  IN-->>DEV: Selected apps (≤25) + scripts (≤10) with % progress
  DEV-->>U: Desktop - remaining assignments continue in background
  IN-->>IN: Near real-time deployment report
```

## Decision tree

```mermaid
flowchart TD
  A{Hybrid join, kiosk/self-deploying,<br/>pre-provisioning, Autopilot Reset,<br/>name template, HoloLens/MTR, Windows 10?}
  A -->|Yes| C[Classic Autopilot profile]
  A -->|No| B{Want no hash registration,<br/>GCCH/DoD, real-time reporting,<br/>Win32 + LOB during OOBE?}
  B -->|Yes| D[Autopilot device preparation]
  B -->|No| C
```

Related docs: [2.1.1](../../02-Manage-Maintain-Devices/docs/2.1.1-autopilot-profiles-vs-device-preparation.md), [2.1.2](../../02-Manage-Maintain-Devices/docs/2.1.2-autopilot-deployment-modes.md), [2.1.5](../../02-Manage-Maintain-Devices/docs/2.1.5-enrollment-status-page.md).
