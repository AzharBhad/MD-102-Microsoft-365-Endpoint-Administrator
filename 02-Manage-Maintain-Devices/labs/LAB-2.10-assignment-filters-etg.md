# LAB-2.10 - Assignment filters and enrollment time grouping

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|
| LAB-2.10 | 2.2.6 | 45 min | Intermediate |

**Goal:** Target policies precisely with include/exclude filters on *All devices*, read the filter evaluation report, and confirm enrollment time grouping delivered apps during enrollment.

## Prerequisites

- At least two Windows devices (for example CONTOSO-LAB-01 corporate and CONTOSO-LAB-02 personal).
- [LAB-2.02](LAB-2.02-autopilot-device-preparation.md) completed (ETG group with a device).

## Required licenses

Intune Plan 1.

## Steps

### Step 1 - Create filters

**Tenant administration > Filters > Create > Managed devices**:

| Filter | Platform | Rule |
|---|---|---|
| `WIN-INCL-Corporate` | Windows 10 and later | `(device.deviceOwnership -eq "Corporate")` |
| `WIN-INCL-Win11-24H2plus` | Windows 10 and later | `(device.osVersion -startsWith "10.0.26")` |
| `WIN-EXCL-VirtualMachines` | Windows 10 and later | `(device.model -eq "Virtual Machine")` |

Use the **Preview** tab for each.

**Expected result:** Preview lists matching devices.

### Step 2 - Assign with a filter

Create a settings catalog policy `WIN-Filter-Test` (for example, *Personalization > Lock Screen Image URL*) → assign to **All devices** with filter `WIN-INCL-Corporate` (**Include**).

**Expected result:** After sync, CONTOSO-LAB-01 = *Succeeded*. CONTOSO-LAB-02 = **Not applicable**.

### Step 3 - Filter evaluation report

**Devices > [CONTOSO-LAB-02] > Filter evaluation** (or **Reports > Filter evaluation**) → find `WIN-Filter-Test`.

**Expected result:** Evaluation result **No match** for `WIN-INCL-Corporate`, with the evaluated property values.

### Step 4 - Exclude mode

Change the assignment to filter `WIN-EXCL-VirtualMachines` in **Exclude** mode.

**Expected result:** All Hyper-V VMs become *Not applicable* (their model is *Virtual Machine*). This shows how easily a filter can remove your whole lab from a policy.

### Step 5 - Managed app filter

**Filters > Create > Managed apps** → `APP-Unmanaged-Android` → platform Android → `(app.deviceManagementType -eq "Unmanaged")`.

**Expected result:** Filter available for app protection/configuration assignments (used in [LAB-4.07](../../04-Manage-Secure-Applications/labs/LAB-4.07-app-protection-conditional-access.md)).

### Step 6 - Review ETG

**Devices > Monitor > Enrollment time grouping failures** → should be empty. Check `SG-Lab-ETG-Windows` membership and when the policies landed (device → *Device configuration* timestamps vs enrollment time).

**Expected result:** Apps/policies arrived during OOBE. No ETG failures.

## Validation

| Device | WIN-INCL-Corporate | WIN-EXCL-VirtualMachines |
|---|---|---|
| CONTOSO-LAB-01 (corporate VM) | Applies | Excluded |
| CONTOSO-LAB-02 (personal VM) | Not applicable | Excluded |

## Troubleshooting

| Symptom | Fix |
|---|---|
| Filter preview empty | Wrong property value (check the device's hardware page), or platform mismatch |
| Policy still applies after exclusion filter | Device not synced yet, or the policy is assigned through another group without the filter |
| Can't select a filter | The workload or platform doesn't support filters, or a different filter type (app vs device) was used |

## Cleanup / rollback

Remove `WIN-Filter-Test`. Keep the filters.

## Stretch challenge

Replace two dynamic device groups from [LAB-1.04](../../01-Prepare-Infrastructure/labs/LAB-1.04-dynamic-device-groups.md) with *All devices + filter* assignments, and argue the pros and cons (evaluation time, reuse in other Microsoft services).

## Knowledge check

1. How many filters can one assignment use?
2. Where do you see why a filter did or didn't match a device?
3. What's the difference between managed device and managed app filters?

<details>
<summary>Answers</summary>

1. **One** (include or exclude).
2. The **Filter evaluation** report (device or tenant level).
3. Device filters use device properties for MDM workloads. App filters use app/device-context properties for app protection and app configuration policies (including unmanaged devices).

</details>
