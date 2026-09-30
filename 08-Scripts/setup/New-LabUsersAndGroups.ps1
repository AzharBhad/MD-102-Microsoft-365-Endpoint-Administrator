<#
.SYNOPSIS
    Creates the standard MD-102 lab users and groups in a TEST tenant.

.DESCRIPTION
    Creates user1-user5, helpdesk1, admin2 and the security groups used across the
    labs in this repository (see 00-Getting-Started/lab-environment-setup.md).
    Idempotent: existing objects are skipped.

    Run ONLY in a dedicated lab tenant.

.PARAMETER TenantDomain
    Your lab tenant's initial domain, for example contoso.onmicrosoft.com.

.PARAMETER UsageLocation
    Two-letter country code required for licence assignment (default US).

.EXAMPLE
    .\New-LabUsersAndGroups.ps1 -TenantDomain contoso.onmicrosoft.com

.NOTES
    Requires: Microsoft.Graph.Users, Microsoft.Graph.Groups
    Scopes:   User.ReadWrite.All, Group.ReadWrite.All
    Passwords are generated randomly and written to the console once - store them
    in a password manager. Nothing is written to disk.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^[a-z0-9-]+\.onmicrosoft\.com$')]
    [string]$TenantDomain,

    [string]$UsageLocation = 'US'
)

$ErrorActionPreference = 'Stop'

Connect-MgGraph -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All' -NoWelcome

function New-LabPassword {
    $chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%*'
    -join (1..20 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

$users = @(
    @{ Nick = 'user1';     Name = 'Lab User 1' }
    @{ Nick = 'user2';     Name = 'Lab User 2' }
    @{ Nick = 'user3';     Name = 'Lab User 3' }
    @{ Nick = 'user4';     Name = 'Lab User 4' }
    @{ Nick = 'user5';     Name = 'Lab User 5' }
    @{ Nick = 'helpdesk1'; Name = 'Lab Helpdesk 1' }
    @{ Nick = 'admin2';    Name = 'Lab Admin 2 (MAA approver)' }
)

$created = @{}
foreach ($u in $users) {
    $upn = "$($u.Nick)@$TenantDomain"
    $existing = Get-MgUser -Filter "userPrincipalName eq '$upn'" -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "Exists: $upn" -ForegroundColor DarkGray
        $created[$u.Nick] = $existing.Id
        continue
    }
    if ($PSCmdlet.ShouldProcess($upn, 'Create user')) {
        $tempPassword = New-LabPassword
        $new = New-MgUser -AccountEnabled -DisplayName $u.Name -MailNickname $u.Nick `
            -UserPrincipalName $upn -UsageLocation $UsageLocation `
            -PasswordProfile @{ Password = $tempPassword; ForceChangePasswordNextSignIn = $true }
        $created[$u.Nick] = $new.Id
        Write-Host "Created: $upn  (temporary password: $tempPassword)" -ForegroundColor Green
    }
}

$groups = @(
    @{ Name = 'SG-Lab-Users';         Members = 'user1','user2','user3','user4','user5' }
    @{ Name = 'SG-Lab-Pilot-Users';   Members = 'user1','user2' }
    @{ Name = 'SG-Lab-Helpdesk';      Members = 'helpdesk1' }
    @{ Name = 'SG-Lab-MAA-Approvers'; Members = 'admin2' }
    @{ Name = 'SG-Lab-ETG-Windows';   Members = @() }   # add Intune Provisioning Client as OWNER manually (LAB-2.02)
)

foreach ($g in $groups) {
    $grp = Get-MgGroup -Filter "displayName eq '$($g.Name)'" -ErrorAction SilentlyContinue
    if (-not $grp -and $PSCmdlet.ShouldProcess($g.Name, 'Create assigned security group')) {
        $grp = New-MgGroup -DisplayName $g.Name -MailEnabled:$false -MailNickname $g.Name -SecurityEnabled
        Write-Host "Created group: $($g.Name)" -ForegroundColor Green
    }
    foreach ($m in $g.Members) {
        try {
            New-MgGroupMember -GroupId $grp.Id -DirectoryObjectId $created[$m] -ErrorAction Stop
        } catch {
            if ($_.Exception.Message -notmatch 'already exist') { throw }
        }
    }
}

$dynamic = @(
    @{ Name = 'DG-Lab-Windows-Corporate'; Rule = '(device.deviceOSType -eq "Windows") and (device.deviceOwnership -eq "Company")' }
    @{ Name = 'DG-Lab-Autopilot';         Rule = '(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))' }
)
foreach ($d in $dynamic) {
    if (-not (Get-MgGroup -Filter "displayName eq '$($d.Name)'" -ErrorAction SilentlyContinue) -and
        $PSCmdlet.ShouldProcess($d.Name, 'Create dynamic device group')) {
        New-MgGroup -DisplayName $d.Name -MailEnabled:$false -MailNickname $d.Name -SecurityEnabled `
            -GroupTypes 'DynamicMembership' -MembershipRule $d.Rule -MembershipRuleProcessingState 'On' | Out-Null
        Write-Host "Created dynamic group: $($d.Name)" -ForegroundColor Green
    }
}

Write-Host "`nNext: assign Microsoft 365 E5 licences (or group-based licensing on SG-Lab-Users)." -ForegroundColor Cyan
