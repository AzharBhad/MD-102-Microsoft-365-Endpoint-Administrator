# LAB-1.10 - Multi-admin approval

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-1.10 | 1.3.3 | 45 min | Intermediate |

**Goal:** Protect device wipe/retire/delete and PowerShell scripts with access policies, then complete an approval round-trip between two admins.

## Prerequisites

- `admin` (Intune Administrator) and `admin2` (in `SG-Lab-MAA-Approvers`).
- Two browser profiles.
- A spare test device record you're happy to **retire** (for example, the registered CONTOSO-LAB-02 or a stale device).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Prepare the approver group

1. Confirm `SG-Lab-MAA-Approvers` is a **security** group with admin2 as a **direct** member.
2. Intune → **Tenant administration > Roles > Read Only Operator > Assignments > Assign** → `MAA Approvers` → admin group `SG-Lab-MAA-Approvers` → scope **All devices / All users**.
3. Create a custom role `Lab - MAA Approver` with **Multi Admin Approval: Approval for Multi Admin Approval** and assign it to the same group (skip if admin2 is already Intune Administrator).

**Expected result:** admin2 has read + approval permission via a role assignment on the group.

### Step 2 - Create the Device actions access policy (as admin)

**Tenant administration > Multi Admin Approval > Access policies > Create** → Name `MAA-DeviceActions` → Profile type **Device actions** → Approvers `SG-Lab-MAA-Approvers` → Business justification "Protect wipe/retire/delete" → **Submit for approval**.

**Expected result:** The policy shows *Needs approval*.

### Step 3 - Approve the policy (as admin2)

admin2 → **Multi Admin Approval > Received requests** → open the request → **Approve** with notes.

**Expected result:** Status *Approved*.

### Step 4 - Complete the policy (as admin)

admin → **Access policies** → `MAA-DeviceActions` → **Complete**.

**Expected result:** The policy is *Active*.

### Step 5 - Request a retire (as admin)

Devices → test device → **Retire** → enter a business justification → **Submit**.

**Expected result:** A banner shows the request was submitted. The device isn't retired yet. **My requests** shows *Needs approval*.

### Step 6 - Approve and complete the retire

admin2 approves → admin opens **My requests** → **Complete**.

**Expected result:** The retire command is issued. The device shows *Retire pending*, then disappears or shows retired.

### Step 7 - Scripts policy (repeat)

Create `MAA-Scripts` (Profile type **Scripts**). After it's active, try to upload a PowerShell script (**Devices > Scripts and remediations > Platform scripts > Add**).

**Expected result:** The upload becomes a request that needs approval.

### Step 8 - Audit

**Tenant administration > Audit logs** → filter *Category: Multi Admin Approval* (or activity names containing *Approval*).

**Expected result:** Entries for create, approve and complete by the respective accounts.

## Validation

- admin can't approve their own request (the Approve button is unavailable).
- Only one pending request per object - try to submit a second retire for the same device before completing.

## Troubleshooting

| Symptom | Fix |
|---|---|
| admin2 doesn't see Received requests | Approver group isn't assigned to an Intune role as a member group, or admin2 is a nested member |
| admin2 removed from group automatically | Same cause - the group must be a member group in a role assignment |
| Automation script gets 4xx after enabling policies | App-auth Graph calls are now subject to MAA → follow the approval headers workflow, or add an **Exclusion** for that app |
| Locked out after creating a **Role** policy | Delete the Role access policy, wait 3-5 min, fix RBAC, recreate |

## Cleanup / rollback

Delete `MAA-Scripts` and `MAA-DeviceActions` (deletion of an access policy itself requires approval when an *Access policies* policy exists).

## Stretch challenge

Protect **Compliance policies** with MAA, then edit the Windows compliance policy from [LAB-1.11](LAB-1.11-compliance-conditional-access.md). Record the end-to-end time from request to completion and suggest an operational SLA.

## Knowledge check

1. Who selects **Complete** after a request is approved?
2. What happens if the approver group is a Microsoft 365 group?
3. Name three resource types an access policy can protect.
4. Are app protection policies covered by the *Apps* profile type?

<details>
<summary>Answers</summary>

1. The **requesting** admin who submitted it.
2. Approver membership fails to resolve silently - approvers can't approve.
3. Any three of: Apps, Scripts, Device actions, Compliance policies, Configuration policies, Role-based access control, Access policies, Tenant configuration.
4. **No** - only app deployments.

</details>
