# Configuration Manager: legacy context

**Configuration Manager (ConfigMgr/MECM/SCCM), co-management and tenant attach are not objectives in the October 27, 2026 skills outline.** This page gives just enough context to recognize them in scenarios and in real-world environments, so you can focus study time on the listed objectives.

## Why you may still see it

- Many organizations are mid-migration from ConfigMgr to Intune, so it appears in job interviews and real tickets.
- Some Learn pages for listed objectives mention co-managed devices (for example, Endpoint analytics, Remediations, Windows Update policies).
- Exam scenarios can describe an existing ConfigMgr estate as background while asking about an Intune feature.

## Three terms to know

| Term | What it is | Where it shows up in this repo |
|---|---|---|
| **Co-management** | A Windows device managed by ConfigMgr **and** Intune at the same time; **workloads** (compliance, configuration, Windows Update policies, apps, Endpoint Protection, Office Click-to-Run, resource access) are switched to Intune one by one | Remediations and Endpoint analytics support co-managed devices ([5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md), [5.2.3](../05-Optimize-Endpoint-Operations/docs/5.2.3-remediation-scripts.md)); the **Windows Update policies** workload must be on Intune for Intune update rings to apply ([3.2.1](../03-Protect-Devices/docs/3.2.1-plan-device-updates.md)) |
| **Tenant attach** | Uploads ConfigMgr devices to the Intune admin center (view, run actions, Endpoint analytics) without Intune enrollment | Endpoint analytics can include tenant-attached devices ([5.2.2](../05-Optimize-Endpoint-Operations/docs/5.2.2-endpoint-analytics.md)) |
| **Device credential enrollment** | The GPO option used when ConfigMgr co-management enrolls hybrid devices into Intune | [1.2.2](../01-Prepare-Infrastructure/docs/1.2.2-windows-automatic-enrollment.md) |

## Exam rule of thumb

If an answer requires building or extending ConfigMgr infrastructure and another answer does the same thing with a cloud-native Intune feature, the outline favours the **Intune** answer - unless the question explicitly says ConfigMgr must stay in charge of a workload.

## Want hands-on anyway?

Use Microsoft's [Configuration Manager evaluation lab kit](https://learn.microsoft.com/intune/configmgr/core/get-started/2019/evaluation-and-lab) after the exam. It isn't needed to pass MD-102 against the current outline.

## Microsoft Learn references

- [What is co-management?](https://learn.microsoft.com/intune/configmgr/comanage/overview)
- [Co-management workloads](https://learn.microsoft.com/intune/configmgr/comanage/workloads)
- [Microsoft Intune tenant attach](https://learn.microsoft.com/intune/configmgr/tenant-attach/device-sync-actions)
