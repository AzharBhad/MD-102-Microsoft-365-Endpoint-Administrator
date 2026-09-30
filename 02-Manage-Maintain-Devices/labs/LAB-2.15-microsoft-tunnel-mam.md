# LAB-2.15 - Microsoft Tunnel for MAM

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.15 | 2.3.5 | 90 min | Advanced |

**Goal:** Deploy a Microsoft Tunnel Gateway on a Linux VM, extend it to an unenrolled Android device with Defender + Edge app configuration and an app protection policy, and monitor server health.

> **Cost warning:** This lab uses an Azure (or local) Linux VM with a public IP. **Delete it when done.**

## Prerequisites

- Azure subscription (or a local Linux VM reachable on TCP/UDP 443 from your phone).
- A public DNS name `tunnel.contoso.com` (or the Azure VM DNS label) and a TLS certificate for it (Let's Encrypt works).
- An **unenrolled** Android phone with Microsoft Defender, Microsoft Edge and Company Portal installed (don't sign in to Company Portal).
- An internal test web page reachable from the Tunnel server (for example, a small web server on the same vNet).

## Required licenses

Intune Plan 2 (Tunnel for MAM) / Suite / Microsoft 365 E3+ (July 2026). Intune Plan 1 for the gateway itself.

## Steps

### Step 1 - Linux server

Create an Ubuntu 24.04 VM (2 vCPU, 4 GB), open inbound **TCP 443 + UDP 443**, install Docker (`sudo apt install docker.io`) or Podman.

**Expected result:** SSH access, container runtime running.

### Step 2 - Server configuration and site

Intune → **Tenant administration > Microsoft Tunnel Gateway**:

- **Server configurations > Create** `TunnelCfg-Lab`: IPv4 range `169.254.0.0/16`, DNS server (your vNet DNS or `168.63.129.16` in Azure), DNS suffix `contoso.local`, split tunnel include route: the internal test subnet, port 443.
- **Sites > Create** `Site-Lab`: public address `tunnel.contoso.com`, server config `TunnelCfg-Lab`.

**Expected result:** Both objects listed.

### Step 3 - Install the server

**Servers > Create** → select `Site-Lab` → **Download script** → on the VM:

```bash
chmod +x mstunnel-setup
sudo ./mstunnel-setup
# accept EULA, provide TLS cert (PEM) + key, sign in with an Intune admin when prompted
```

**Expected result:** Server shows *Healthy* in **Health status** after a few minutes.

### Step 4 - App configuration for Defender (Android)

**Apps > Configuration > Create > Managed apps** → public app **Microsoft Defender Endpoint (Android)** → *Microsoft Tunnel settings*: Use Microsoft Tunnel VPN **Yes**, connection name `Contoso-Tunnel`, site `Site-Lab` → assign `SG-Lab-Users`.

**Expected result:** Policy created.

### Step 5 - App configuration for Edge (Android)

**Managed apps** → **Microsoft Edge (Android)** → General configuration:

- `com.microsoft.intune.mam.managedbrowser.TunnelAvailable.IntuneMAMOnly` = `True`
- `com.microsoft.intune.mam.managedbrowser.StrictTunnelMode` = `True` (optional)

Assign `SG-Lab-Users`.

**Expected result:** Policy created (no trailing spaces in keys/values).

### Step 6 - App protection policy for Edge

**Apps > Protection > Create > Android** → apps: Microsoft Edge → default data protection → assign `SG-Lab-Users`.

**Expected result:** Policy created.

### Step 7 - Test on the phone

Open **Edge** → sign in with user1 (work account). The Defender app starts the tunnel automatically → browse to the internal test page.

**Expected result:** The internal page loads over the tunnel. Switching Edge to a personal/InPrivate profile disconnects the tunnel (identity switch).

### Step 8 - Monitor

- Intune **Health status**: CPU, memory, latency, TLS certificate expiry, active connections.
- Server:

```bash
sudo mst-cli server show health
sudo mst-cli server show status
```

**Expected result:** Healthy, with 1 active connection while the phone is connected.

## Validation

- An internal resource is reachable from Edge on an **unenrolled** phone.
- No device enrollment record exists for the phone in Intune (only an app protection / MAM record).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Server *Unhealthy - TLS certificate* | Cert expired/wrong chain → re-import with `mst-cli import_cert` |
| Defender says "Tunnel not configured" | Defender app config not assigned, or multiple Defender app configs with different tunnel settings |
| Edge doesn't trigger tunnel | Missing Edge app config key, or no app protection policy on Edge |
| Internal site unreachable | Split-tunnel route missing, DNS server/suffix wrong, NSG blocking internal traffic |

## Cleanup / rollback

**Delete the Azure VM, public IP and disk.** Delete the server from Intune (**Servers > Delete**), then the site and server configuration. Remove the app config/protection policies if not needed.

## Stretch challenge

Configure a **trusted root certificate** for Edge in the Tunnel for MAM app config so Edge trusts an internal site signed by your Cloud PKI ([LAB-2.14](LAB-2.14-cloud-pki-scep.md)).

## Knowledge check

1. Which app is the tunnel client on unenrolled Android devices?
2. What three policies enable Tunnel for MAM on Android?
3. Where do you check the gateway's TLS certificate expiry?

<details>
<summary>Answers</summary>

1. **Microsoft Defender** (Defender for Endpoint app).
2. App configuration for **Defender**, app configuration for **Edge**, and an **app protection policy** for Edge.
3. **Tenant administration > Microsoft Tunnel Gateway > Health status** (or `mst-cli server show health`).

</details>
