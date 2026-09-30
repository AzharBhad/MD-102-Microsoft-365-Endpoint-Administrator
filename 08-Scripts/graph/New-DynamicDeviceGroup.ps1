<#
.SYNOPSIS
    Creates a Microsoft Entra dynamic device security group.

.DESCRIPTION
    Wraps New-MgGroup with validation for dynamic device rules. Used in LAB-1.04.
    Fails if a group with the same display name already exists.

.PARAMETER DisplayName
    Group name, for example DG-Windows-Corporate.

.PARAMETER MembershipRule
    Dynamic membership rule. Must reference device.* attributes.

.PARAMETER Description
    Optional description.

.EXAMPLE
    .\New-DynamicDeviceGroup.ps1 -DisplayName 'DG-Autopilot' `
        -MembershipRule '(device.devicePhysicalIDs -any (_ -startsWith "[ZTDid]"))'

.NOTES
    Requires Microsoft.Graph.Groups. Scope: Group.ReadWrite.All. Entra ID P1 required.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateLength(1, 256)]
    [string]$DisplayName,

    [Parameter(Mandatory)]
    [ValidateScript({ $_ -match 'device\.' -and $_ -notmatch 'user\.' })]
    [string]$MembershipRule,

    [string]$Description = 'Created by New-DynamicDeviceGroup.ps1'
)

$ErrorActionPreference = 'Stop'
Connect-MgGraph -Scopes 'Group.ReadWrite.All' -NoWelcome

$escaped = $DisplayName.Replace("'", "''")
if (Get-MgGroup -Filter "displayName eq '$escaped'" -ErrorAction SilentlyContinue) {
    throw "A group named '$DisplayName' already exists."
}

# MailNickname cannot contain spaces or some special characters
$nick = ($DisplayName -replace '[^a-zA-Z0-9-]', '')
if ([string]::IsNullOrEmpty($nick)) { $nick = "dg$(Get-Random)" }

if ($PSCmdlet.ShouldProcess($DisplayName, 'Create dynamic device group')) {
    $group = New-MgGroup -DisplayName $DisplayName -Description $Description `
        -MailEnabled:$false -MailNickname $nick -SecurityEnabled `
        -GroupTypes 'DynamicMembership' -MembershipRule $MembershipRule `
        -MembershipRuleProcessingState 'On'

    [pscustomobject]@{
        Id             = $group.Id
        DisplayName    = $group.DisplayName
        MembershipRule = $group.MembershipRule
    }
}
