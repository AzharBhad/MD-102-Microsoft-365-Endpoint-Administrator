# Contributing

Thanks for helping improve this MD-102 study repository. Corrections, updated portal paths, new original practice questions, and lab fixes are all welcome.

## Ground rules

1. **No exam dumps or NDA content.** Never paste, paraphrase, or "reconstruct" real exam questions. All practice questions must be original and scenario-based. PRs that reference braindump sites are closed.
2. **No personal or tenant data.** Use placeholders only:
   - Tenant: `contoso.onmicrosoft.com` / tenant ID `00000000-0000-0000-0000-000000000000`
   - Users: `user1@contoso.onmicrosoft.com`, `helpdesk1@contoso.onmicrosoft.com`
   - Devices: `CONTOSO-LAB-01`, serial `LAB-SERIAL-0001`
   - Never include secrets, client secrets, certificate private keys, or screenshots with real data.
3. **Current product names only.** Microsoft Entra ID (not Azure AD), Microsoft Intune admin center (not MEM / Endpoint Manager admin center), Microsoft Defender XDR, Windows Autopilot device preparation, App Control for Business (not WDAC), Microsoft Entra Connect / Cloud Sync.
4. **Official source first.** Every technical claim should be traceable to a Microsoft Learn page listed in the doc's *Microsoft Learn references* section.
5. **Exam wording is verbatim.** The *Exam objective* block must match the [official study guide](https://learn.microsoft.com/credentials/certifications/resources/study-guides/md-102) exactly.

## Repository conventions

| Item | Convention | Example |
|---|---|---|
| Doc file | `<domain>/docs/<objective-id>-<slug>.md` | `01-Prepare-Infrastructure/docs/1.3.7-windows-laps.md` |
| Lab file | `<domain>/labs/LAB-<d>.<nn>-<slug>.md` | `02-Manage-Maintain-Devices/labs/LAB-2.01-autopilot-user-driven.md` |
| Objective ID | `<domain>.<skill>.<bullet>` in study-guide order | `3.2.3` = Implement Windows Autopatch and configure Hotpatch policies |
| Diagrams | Mermaid, inline in the doc; reusable ones in `assets/diagrams/` | `assets/diagrams/autopilot-flow.md` |
| Scripts | `08-Scripts/<area>/<Verb-Noun>.ps1`, comment-based help required | `08-Scripts/graph/Get-NoncompliantDevices.ps1` |

When you add or rename a doc or lab, update **both** [`EXAM-OBJECTIVE-MAP.md`](EXAM-OBJECTIVE-MAP.md) and [`PROGRESS-TRACKER.md`](PROGRESS-TRACKER.md). The `Objective coverage` workflow fails if an objective loses its doc or lab.

## Doc template

```markdown
# <id> <Short title>

> **Exam objective:** <verbatim bullet from the study guide>
>
> **Domain:** <n> - <domain name> (<weight>) · **Skill:** <n.n> <skill name>
>
> **Hands-on:** [LAB-x.xx](../labs/LAB-x.xx-slug.md)

## Concept in plain English
## How it works
## Licensing requirements
## Configuration steps
### Microsoft Intune admin center
### PowerShell / Microsoft Graph
## Comparison
## Exam tips and common traps
## Real-world notes
## Microsoft Learn references
```

## Lab template

```markdown
# LAB-x.xx - <Title>

| Lab ID | Objectives covered | Estimated time | Difficulty |
|---|---|---|---|

## Prerequisites
## Required licenses
## Steps            (each step ends with **Expected result:**)
## Validation
## Troubleshooting
## Cleanup / rollback
## Stretch challenge
## Knowledge check  (answers inside <details>)
```

## Local checks

```bash
npx markdownlint-cli2 "**/*.md"
python3 .github/scripts/check_coverage.py --check-map --domains 1,2,3,4,5
# PowerShell syntax check of every script
pwsh -NoProfile -Command 'Get-ChildItem 08-Scripts -Recurse -Filter *.ps1 | ForEach-Object { $e = $null; [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$e); if ($e) { Write-Error "$($_.Name): $($e[0].Message)" } }'
```

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/): `docs: add Autopilot documentation`, `lab: fix LAB-3.05 onboarding step`, `ci: add link check`, `fix: correct LAPS rotation path`.
