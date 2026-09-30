# Endpoint operations monitoring

How data flows from devices into reports, analytics, Copilot and alerts (Domain 5).

```mermaid
flowchart LR
  subgraph Devices["Managed devices"]
    W[Windows<br/>IME · DiagTrack · MDE sensor]
    M[iOS / Android / macOS]
  end
  subgraph Intune["Microsoft Intune"]
    REP[Built-in reports<br/>operational · organizational · historical]
    EA[Endpoint analytics<br/>+ Advanced Analytics]
    RM[Remediations]
    CC[Custom compliance]
    TS[Tenant status<br/>connectors · service health]
    CP[Copilot in Intune<br/>Explorer · chat · device query KQL]
    VRA[Vulnerability Remediation Agent]
  end
  subgraph Azure["Azure Monitor"]
    LA[Log Analytics<br/>IntuneAuditLogs · IntuneOperationalLogs ·<br/>IntuneDeviceComplianceOrg · IntuneDevices]
    WB[Workbooks]
    AL[Alert rules → action groups]
  end
  DVM[Defender Vulnerability<br/>Management] --> VRA
  W --> REP & EA & RM & CC
  M --> REP
  REP & EA --> CP
  Intune -->|diagnostic settings| LA
  LA --> WB
  LA --> AL
  Intune -->|Graph exportJobs| BI[Power BI / scripts]
  M365[M365 admin center<br/>service health · message center] --> TS
  AL & M365 --> OPS[Endpoint operations team]
  CP & VRA --> OPS
```

## Which tool for which question

| Question | Tool | Objective |
|---|---|---|
| Can I automate this task? | Graph PowerShell / exportJobs | [5.1.1](../../05-Optimize-Endpoint-Operations/docs/5.1.1-powershell-graph-automation.md) |
| Which vulnerabilities should I fix first? | Vulnerability Remediation Agent | [5.1.2](../../05-Optimize-Endpoint-Operations/docs/5.1.2-security-copilot-agents-threat-investigation.md) |
| Why is this device slow? | Copilot in Intune + Endpoint/Advanced Analytics | [5.1.3](../../05-Optimize-Endpoint-Operations/docs/5.1.3-security-copilot-agents-device-performance.md) |
| Is our org-specific rule met? | Custom compliance | [5.1.5](../../05-Optimize-Endpoint-Operations/docs/5.1.5-custom-compliance-powershell.md) |
| What's the state of the estate? | Reports, workbooks | [5.2.1](../../05-Optimize-Endpoint-Operations/docs/5.2.1-reporting-workbooks-export.md) |
| How good is the user experience? | Endpoint analytics scores | [5.2.2](../../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md), [5.2.4](../../05-Optimize-Endpoint-Operations/docs/5.2.4-reliability-user-experience-scores.md) |
| Can we fix it automatically? | Remediations | [5.2.3](../../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md) |
| Is it us or Microsoft? | Tenant status, service health | [5.2.5](../../05-Optimize-Endpoint-Operations/docs/5.2.5-service-health-message-center.md) |
| Tell me when it breaks | Alerts and notifications | [5.2.6](../../05-Optimize-Endpoint-Operations/docs/5.2.6-alerts-notifications.md) |
