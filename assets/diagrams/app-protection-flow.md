# App protection and Conditional Access flow

What happens when a user on a personal (unenrolled) phone opens Outlook against a tenant that requires app protection (Domain 4, objectives [4.2.1](../../04-Manage-Secure-Applications/docs/4.2.1-app-protection-policies.md) and [4.2.2](../../04-Manage-Secure-Applications/docs/4.2.2-conditional-access-app-protection.md)).

```mermaid
sequenceDiagram
  autonumber
  actor U as User (BYOD phone)
  participant App as Outlook (Intune SDK)
  participant B as Broker<br/>Authenticator (iOS) /<br/>Company Portal (Android)
  participant E as Microsoft Entra ID<br/>Conditional Access
  participant I as Intune APP service
  participant M as Exchange Online

  U->>App: Sign in with work account
  App->>B: Brokered authentication
  B->>E: Token request (device registered by broker)
  E-->>B: Grant requires "Require app protection policy"
  B->>I: Is an APP assigned to this user + app?
  I-->>App: App protection policy (PIN, encryption, data transfer)
  App->>U: Set app PIN
  App->>E: Retry token request (APP applied)
  E-->>App: Access token
  App->>M: Mail sync (org data stays in policy-managed apps)
  Note over App,I: Conditional launch checks run at launch<br/>and on the offline grace period
```

## Channels at a glance

```mermaid
flowchart LR
  subgraph Enrolled["Enrolled device (MDM)"]
    MDA[App configuration<br/>Managed devices channel]
    APPm[App protection policy<br/>managed device types]
  end
  subgraph Unenrolled["Unenrolled device (MAM-WE)"]
    MAA[App configuration<br/>Managed apps channel]
    APPu[App protection policy<br/>unmanaged device types]
  end
  CA[Conditional Access<br/>Require app protection policy] --> APPm
  CA --> APPu
  MDA -->|needs app deployed by Intune| Apps[Outlook · Edge · Teams]
  MAA -->|delivered via Intune SDK| Apps
  APPm --> Apps
  APPu --> Apps
```

| Control | Needs enrollment | Delivered by |
|---|---|---|
| App protection policy | No | Intune SDK / App Wrapping Tool in the app |
| App configuration - managed apps | No | Intune SDK (with APP) |
| App configuration - managed devices | Yes | MDM channel (iOS app config / Android managed configurations) |
| Selective wipe | No | Intune APP service at next app launch |
