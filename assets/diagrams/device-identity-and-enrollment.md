# Device identity and enrollment flow

End-to-end view of how a device gets from "unboxed" to "compliant and allowed by Conditional Access". Used by Domain 1 docs.

```mermaid
flowchart TD
  subgraph Identity["Microsoft Entra ID"]
    J[Entra joined]
    H[Entra hybrid joined]
    R[Entra registered]
  end

  subgraph Methods["Enrollment methods"]
    AP[Windows Autopilot /<br/>device preparation]
    OOBE[OOBE / Settings join]
    GPO[GPO auto-enroll<br/>hybrid]
    CP[Company Portal /<br/>web enrollment]
    ADE[Apple ADE via ABM]
    UE[Account driven<br/>user enrollment]
    AE[Android Enterprise<br/>QR / zero-touch / KME]
  end

  AP --> J
  OOBE --> J
  GPO --> H
  CP --> R
  UE --> R
  ADE --> R
  AE --> R

  J & H & R --> G{Enrollment gates<br/>MDM scope · platform restriction ·<br/>device limit · licence}
  G -->|pass| I[Intune managed device]
  G -->|fail| X[Enrollment failure report]

  I --> C[Compliance policies]
  C -->|isCompliant| E[(Entra device object)]
  E --> CA{Conditional Access<br/>Require compliant device}
  CA -->|compliant| OK[Access granted]
  CA -->|not compliant| BLK[Blocked + remediation]
```

## Legend

| Symbol | Meaning |
|---|---|
| Entra joined | Windows owned by the organization, cloud identity |
| Hybrid joined | Windows joined to AD DS **and** registered in Entra |
| Registered | BYOD Windows, all iOS/iPadOS/Android/macOS Intune devices |

Related docs: [1.1.1](../../01-Prepare-Infrastructure/docs/1.1.1-choose-device-join-type.md), [1.2.1](../../01-Prepare-Infrastructure/docs/1.2.1-intune-enrollment-settings.md), [1.3.5](../../01-Prepare-Infrastructure/docs/1.3.5-conditional-access-require-compliance.md).
