# Endpoint security stack

How Intune endpoint security policies, Defender for Endpoint and Conditional Access fit together (Domain 3).

```mermaid
flowchart TB
  subgraph Intune["Microsoft Intune - Endpoint security"]
    AV[Antivirus + exclusions<br/>+ tamper protection]
    FW[Firewall + rules]
    ASR[ASR rules · device control]
    ENC[Disk encryption<br/>BitLocker / FileVault]
    ACB[App Control for Business<br/>+ managed installer]
    SB[Security baselines]
    EDR[EDR onboarding]
    UPD[Updates: rings · feature · quality/Hotpatch ·<br/>drivers · Autopatch · Apple DDM · Android FOTA]
    CMP[Compliance<br/>encryption · OS · risk score]
  end
  subgraph Defender["Microsoft Defender XDR"]
    MDE[Defender for Endpoint<br/>sensor · EDR · AIR · hunting]
    INC[Incidents & alerts]
    TVM[Vulnerability management]
  end
  subgraph Entra["Microsoft Entra ID"]
    CA[Conditional Access<br/>require compliant device]
  end
  EDR --> MDE
  MDE --> INC
  MDE -->|machine risk| CMP
  TVM -->|security tasks| Intune
  AV & FW & ASR & ENC & ACB & SB & UPD --> Dev[Managed devices]
  Dev --> CMP
  CMP --> CA --> Apps[Microsoft 365 & SaaS apps]
```

## Zero Trust mapping

| Principle | Controls in this repo |
|---|---|
| Verify explicitly | Compliance (objective 1.3.4), Conditional Access (objective 1.3.5), machine risk (objective 3.1.6) |
| Least privilege | LAPS (objective 1.3.7), local groups (objective 1.3.8), EPM (objective 2.3.1), App Control (objective 3.1.8) |
| Assume breach | ASR/device control (objective 3.1.4), EDR (objective 3.1.6), encryption (objective 3.1.2), fast patching (objective 3.2.x) |
