# LAB-2.14 - Cloud PKI with a SCEP profile

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.14 | 2.3.4 | 60 min | Advanced |

**Goal:** Build a two-tier Cloud PKI (root + issuing), deploy trusted certificate and SCEP profiles to Windows, use the certificate in a Wi-Fi profile, and monitor and revoke issued certificates.

## Prerequisites

- Cloud PKI licensed or on trial (trial CAs use software keys - fine for a lab. Trials allow a small number of CAs).
- CONTOSO-LAB-01 or -03.

## Required licenses

Intune Suite / Cloud PKI add-on / Microsoft 365 E5 (July 2026+).

## Steps

### Step 1 - Root CA

**Tenant administration > Cloud PKI > Create** → `Contoso Lab Root CA`:

- CA type **Root CA**. Validity **10 years**
- EKU: **Client Authentication** (and Server Authentication if you'll test RADIUS)
- Subject CN `Contoso Lab Root CA`, O `Contoso Lab`, C `US`
- Key size/algorithm: RSA 2048, SHA-256

**Expected result:** Status *Active* after a few minutes.

### Step 2 - Issuing CA

**Create** → `Contoso Lab Issuing CA` → **Issuing CA**, root source **Intune**, root = the one above, validity **6 years**, EKU Client Authentication, CN `Contoso Lab Issuing CA`.

**Expected result:** Active. **Properties** shows the **SCEP URI**, CRL and AIA URIs → copy the SCEP URI.

### Step 3 - Download CA certificates

Open each CA → **Download** → `root.cer`, `issuing.cer`.

**Expected result:** Two `.cer` files.

### Step 4 - Trusted certificate profiles

**Devices > Configuration > Create > Windows 10 and later > Templates > Trusted certificate**:

- `WIN-Trusted-CloudPKI-Root` → upload root → store **Computer certificate store - Root**
- `WIN-Trusted-CloudPKI-Issuing` → upload issuing → store **Computer certificate store - Intermediate**

Assign both to `DG-Lab-Windows-Corporate`.

**Expected result:** *Succeeded*. Certificates are visible in `certlm.msc`.

### Step 5 - SCEP profile

**Templates > SCEP certificate** → `WIN-SCEP-User-CloudPKI`:

- Certificate type **User**
- Subject name format `CN={{UserPrincipalName}}`. SAN: **User principal name (UPN)** = `{{UserPrincipalName}}`
- Validity 1 year. Key storage provider: **Enroll to TPM KSP if present, otherwise Software KSP**
- Key usage: Digital signature, Key encipherment. Key size 2048. Hash SHA-2
- Root certificate: `WIN-Trusted-CloudPKI-Root`
- EKU: Client Authentication
- Renewal threshold 20%
- SCEP Server URLs: paste the SCEP URI (keep `{{CloudPKIFQDN}}`)

Assign to `SG-Lab-Users`.

**Expected result:** The user certificate appears in `certmgr.msc` > Personal, issued by *Contoso Lab Issuing CA*.

### Step 6 - Use in Wi-Fi

**Templates > Wi-Fi** → Enterprise → SSID `Contoso-Lab-Secure` → EAP type **EAP-TLS** → server trust: root `WIN-Trusted-CloudPKI-Root`, server names `radius.contoso.com` → client authentication certificate: `WIN-SCEP-User-CloudPKI` → assign.

**Expected result:** The profile shows *Succeeded* (the network doesn't need to exist for policy delivery).

### Step 7 - Monitor and revoke

**Cloud PKI > Contoso Lab Issuing CA > View all certificates** → find the user certificate → **Revoke**.

**Expected result:** Status *Revoked*. The CRL republishes (can take a short while).

## Validation

```powershell
Get-ChildItem Cert:\CurrentUser\My | Where-Object Issuer -like '*Contoso Lab Issuing CA*' |
  Select-Object Subject, NotAfter, Thumbprint
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| SCEP profile *Error* | Subject variable missing on the user (for example, email), EKU not present on the issuing CA, or root trusted profile not assigned |
| No certificate after hours | Device can't reach `*.manage.microsoft.com`. Check the SCEP URI was pasted unchanged |
| Chain not trusted | Issuing CA certificate not deployed to the Intermediate store |

## Cleanup / rollback

Unassign profiles. Trial CAs can be paused/revoked. Don't delete CAs that issued certificates you still need.

## Stretch challenge

Create a **BYOCA** issuing CA: download the CSR, sign it with an AD CS lab CA using the *Subordinate Certification Authority* template, and upload it.

## Knowledge check

1. Which Intune profiles are needed for a Cloud PKI SCEP deployment?
2. Can Cloud PKI issue PKCS (.pfx) certificates?
3. How long is the Cloud PKI CRL valid?

<details>
<summary>Answers</summary>

1. **Trusted certificate** profiles (root and issuing) + **SCEP certificate** profile (+ the Wi-Fi/VPN profile that uses it).
2. **No** - SCEP only.
3. **7 days** (republished every 3.5 days and on each revocation).

</details>
